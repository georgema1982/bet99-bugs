function createBugRow(bug) {
    const row = $($('#bugRowTemplate').prop('content')).clone();
    row.find('.bug-id').text(bug.id ? bug.id : '');
    row.find('.bug-title').text(bug.bugTitle);
    row.find('.bug-description').text(bug.description);

    // Localize severity using spring message keys
    if (bug.severity) {
        const severityKey = 'severity.' + bug.severity.toLowerCase();
        const localized = $(`#severity-messages [data-key="${severityKey}"]`).text();
        row.find('.bug-severity').text(localized || bug.severity);
    } else {
        row.find('.bug-severity').text('');
    }

    // When rendering status in the table
    if (bug.status) {
        const statusKey = 'status.' + bug.status.toLowerCase();
        const localizedStatus = $(`#status-messages [data-key="${statusKey}"]`).text();
        row.find('.bug-status').text(localizedStatus || bug.status);
    } else {
        row.find('.bug-status').text('');
    }
    return row;
}

function loadBugs(severity) {
    let url = '/api/bugs';
    if (severity) {
        url += '?severity=' + encodeURIComponent(severity);
    }
    $.ajax({
        url: url,
        type: 'GET',
        success: function(bugs) {
            $('#bugsTable tbody').empty();
            if (bugs && bugs.length > 0) {
                $('#noBugsMsg').addClass('d-none');
                bugs.forEach(function(bug) {
                    $('#bugsTable tbody').append(createBugRow(bug));
                });
            } else {
                $('#noBugsMsg').removeClass('d-none');
            }
        },
        error: function() {
            $('#bugsTable tbody').empty();
            $('#noBugsMsg').find('td').text('Failed to load bugs.');
            $('#noBugsMsg').removeClass('d-none');
        }
    });
}

$(document).ready(function() {
    // Load bugs on page load
    loadBugs();

    // Refresh button
    $('#refreshBugsBtn').on('click', function() {
        $('#filterSeverity').val('');
        loadBugs();
        $('#filterCollapse').collapse('hide');
    });

    // Filter by severity when dropdown changes
    $('#filterSeverity').on('change', function() {
        const severity = $(this).val();
        loadBugs(severity);
        $('#filterCollapse').collapse('hide');
    });

    // Add bug form submit
    $('#addBugForm').on('submit', function(e) {
        e.preventDefault();

        const bugData = {
            bugTitle: $('#bugTitle').val(),
            description: $('#description').val(),
            severity: $('#severity').val(),
            status: $('#status').val()
        };

        $.ajax({
            url: '/api/bugs',
            type: 'POST',
            contentType: 'application/json',
            data: JSON.stringify(bugData),
            success: function(newBug) {
                $('#addBugModal').modal('hide');
                $('#addBugForm')[0].reset();
                $('#bugsTable tbody').append(createBugRow(newBug));
                $('#noBugsMsg').addClass('d-none');
                $('#successAlert').removeClass('d-none');
            },
            error: function(xhr) {
                $('#addBugForm .is-invalid').removeClass('is-invalid');
                $('#addBugForm .invalid-feedback').remove();

                if (xhr.responseJSON) {
                    $.each(xhr.responseJSON, function(field, message) {
                        const $input = $('#addBugForm [name="' + field + '"]');
                        if ($input.length) {
                            $input.addClass('is-invalid');
                            if ($input.next('.invalid-feedback').length === 0) {
                                $input.after('<div class="invalid-feedback">' + message + '</div>');
                            }
                        }
                    });
                } else {
                    $('#errorAlert').removeClass('d-none');
                }
            }
        });
    });
});