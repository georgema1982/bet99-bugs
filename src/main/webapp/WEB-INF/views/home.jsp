<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <title>Home Page</title>
    <!-- Bootstrap CSS CDN -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body>
    <div class="container mt-5">
        <div id="successAlert" class="alert alert-success alert-dismissible fade show d-none" role="alert">
            Bug added successfully!
            <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
        </div>

        <div id="errorAlert" class="alert alert-danger alert-dismissible fade show d-none" role="alert">
            Failed to add bug. Please try again.
            <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
        </div>

        <h1 class="mb-4">Welcome to the Bug Tracker</h1>

        <!-- Add Bug Button, Refresh Button, and Filter Button -->
        <div class="mb-3 d-flex gap-2 align-items-center">
            <button type="button" class="btn btn-primary" data-bs-toggle="modal" data-bs-target="#addBugModal">
                Add Bug
            </button>
            <button type="button" class="btn btn-secondary" id="refreshBugsBtn">
                Refresh
            </button>
            <button type="button" class="btn btn-info" data-bs-toggle="collapse" data-bs-target="#filterCollapse" aria-expanded="false" aria-controls="filterCollapse" id="filterBugsBtn">
                Filter
            </button>
        </div>

        <!-- Bootstrap Collapse for Filter -->
        <div class="collapse mb-3" id="filterCollapse">
            <div class="card card-body" style="max-width: 300px;">
                <label for="filterSeverity" class="form-label mb-1">Filter by Severity</label>
                <select class="form-select" id="filterSeverity">
                    <option value="">All Severities</option>
                    <c:forEach var="sev" items="${severities}">
                        <option value="${sev}">${sev}</option>
                    </c:forEach>
                </select>
            </div>
        </div>

        <table class="table table-striped table-bordered mt-3" id="bugsTable">
            <thead class="table-dark">
                <tr>
                    <th>ID</th>
                    <th>Title</th>
                    <th>Description</th>
                    <th>Severity</th>
                    <th>Status</th>
                </tr>
            </thead>
            <tbody>
                <!-- Rows will be dynamically inserted here -->
            </tbody>
            <tfoot>
                <tr id="noBugsMsg" class="d-none">
                    <td colspan="5" class="alert alert-info m-0 text-center">No recently edited bugs found.</td>
                </tr>
            </tfoot>
        </table>
    </div>

    <!-- Hidden row template -->
    <template id="bugRowTemplate">
        <tr>
            <td class="bug-id"></td>
            <td class="bug-title"></td>
            <td class="bug-description"></td>
            <td class="bug-severity"></td>
            <td class="bug-status"></td>
        </tr>
    </template>

    <!-- Add Bug Modal -->
    <div class="modal fade" id="addBugModal" tabindex="-1" aria-labelledby="addBugModalLabel" aria-hidden="true">
      <div class="modal-dialog">
        <div class="modal-content">
          <form id="addBugForm">
            <div class="modal-header">
              <h5 class="modal-title" id="addBugModalLabel">Add New Bug</h5>
              <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            <div class="modal-body">
                <div class="mb-3">
                    <label for="bugTitle" class="form-label">Title</label>
                    <input type="text" class="form-control" id="bugTitle" name="bugTitle" required>
                </div>
                <div class="mb-3">
                    <label for="description" class="form-label">Description</label>
                    <textarea class="form-control" id="description" name="description" required></textarea>
                </div>
                <div class="mb-3">
                    <label for="severity" class="form-label">Severity</label>
                    <select class="form-select" id="severity" name="severity" required>
                        <option value="">Select Severity</option>
                        <c:forEach var="sev" items="${severities}">
                            <option value="${sev}">${sev}</option>
                        </c:forEach>
                    </select>
                </div>
                <div class="mb-3">
                    <label for="status" class="form-label">Status</label>
                    <select class="form-select" id="status" name="status" required>
                        <option value="">Select Status</option>
                        <c:forEach var="stat" items="${statuses}">
                            <option value="${stat}">${stat}</option>
                        </c:forEach>
                    </select>
                </div>
            </div>
            <div class="modal-footer">
              <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
              <button type="submit" class="btn btn-primary">Add Bug</button>
            </div>
          </form>
        </div>
      </div>
    </div>

    <!-- Bootstrap JS Bundle CDN (optional, for interactive components) -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
    <!-- Add jQuery CDN for AJAX (if not already included) -->
    <script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>
    <script>
    function createBugRow(bug) {
        const row = $($('#bugRowTemplate').prop('content')).clone();
        row.find('.bug-id').text(bug.id ? bug.id : '');
        row.find('.bug-title').text(bug.bugTitle);
        row.find('.bug-description').text(bug.description);
        row.find('.bug-severity').text(bug.severity);
        row.find('.bug-status').text(bug.status);
        return row;
    }

    function loadBugs(severity) {
        let url = '<c:url value="/api/bugs"/>';
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
        });

        // Filter by severity when dropdown changes
        $('#filterSeverity').on('change', function() {
            const severity = $(this).val();
            loadBugs(severity);
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
                url: '<c:url value="/api/bugs"/>',
                type: 'POST',
                contentType: 'application/json',
                data: JSON.stringify(bugData),
                success: function(newBug) {
                    $('#addBugModal').modal('hide');
                    $('#addBugForm')[0].reset();
                    $('#bugsTable tbody').append(createBugRow(newBug));
                    $('#noBugsMsg').addClass('d-none');
                    // Show success alert
                    $('#successAlert').removeClass('d-none');
                },
                error: function(xhr) {
                    // Hide any previous error messages
                    $('#addBugForm .is-invalid').removeClass('is-invalid');
                    $('#addBugForm .invalid-feedback').remove();

                    if (xhr.responseJSON) {
                        // Show validation errors at corresponding fields
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
                        // Show a general error alert
                        $('#errorAlert').removeClass('d-none');
                    }
                }
            });
        });
    });
    </script>
</body>
</html>