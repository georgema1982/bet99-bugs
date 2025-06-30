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
        <!-- Success alert placeholder -->
        <div id="successAlert" class="alert alert-success alert-dismissible fade show" role="alert" style="display:none;">
            Bug added successfully!
            <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
        </div>

        <h1 class="mb-4">Welcome to the Bug Tracker</h1>
        <p class="lead">This is the home page of the Bug Tracker application.</p>

        <!-- Add Bug Button -->
        <button type="button" class="btn btn-primary mb-3" data-bs-toggle="modal" data-bs-target="#addBugModal">
            Add Bug
        </button>

        <h2 class="mt-5">Recently Edited Bugs</h2>
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
                <tr id="noBugsMsg" style="display:none;">
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
                        <option value="LOW">LOW</option>
                        <option value="MEDIUM">MEDIUM</option>
                        <option value="HIGH">HIGH</option>
                        <option value="CRITICAL">CRITICAL</option>
                    </select>
                </div>
                <div class="mb-3">
                    <label for="status" class="form-label">Status</label>
                    <select class="form-select" id="status" name="status" required>
                        <option value="">Select Status</option>
                        <option value="OPEN">OPEN</option>
                        <option value="IN_PROGRESS">IN_PROGRESS</option>
                        <option value="RESOLVED">RESOLVED</option>
                        <option value="CLOSED">CLOSED</option>
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

    function loadBugs() {
        $.ajax({
            url: '<c:url value="/api/bugs"/>',
            type: 'GET',
            success: function(bugs) {
                $('#bugsTable tbody').empty();
                if (bugs && bugs.length > 0) {
                    $('#noBugsMsg').hide();
                    bugs.forEach(function(bug) {
                        $('#bugsTable tbody').append(createBugRow(bug));
                    });
                } else {
                    $('#noBugsMsg').show();
                }
            },
            error: function() {
                $('#bugsTable tbody').empty();
                $('#noBugsMsg').find('td').text('Failed to load bugs.').show();
            }
        });
    }

    $(document).ready(function() {
        // Load bugs on page load
        loadBugs();

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
                    $('#noBugsMsg').hide();
                    // Show success alert
                    $('#successAlert').show();
                },
                error: function() {
                    alert('Failed to add bug. Please try again.');
                }
            });
        });
    });
    </script>
</body>
</html>