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
        <h1 class="mb-4">Welcome to the Bug Tracker</h1>
        <p class="lead">This is the home page of the Bug Tracker application.</p>

        <!-- Add Bug Button -->
        <button type="button" class="btn btn-primary mb-3" data-bs-toggle="modal" data-bs-target="#addBugModal">
            Add Bug
        </button>

        <c:if test="${not empty bugs}">
            <h2 class="mt-5">Recently Edited Bugs</h2>
            <table class="table table-striped table-bordered mt-3">
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
                    <c:forEach var="bug" items="${bugs}">
                        <tr>
                            <td>${bug.id}</td>
                            <td>${bug.bugTitle}</td>
                            <td>${bug.description}</td>
                            <td>${bug.severity}</td>
                            <td>${bug.status}</td>
                        </tr>
                    </c:forEach>
                </tbody>
            </table>
        </c:if>

        <c:if test="${empty bugs}">
            <div class="alert alert-info mt-4">No recently edited bugs found.</div>
        </c:if>
    </div>

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
    $(document).ready(function() {
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
                    // Hide modal
                    $('#addBugModal').modal('hide');
                    // Reset form
                    $('#addBugForm')[0].reset();

                    // Append new row to the table
                    const newRow = `
                        <tr>
                            <td>${newBug.id ? newBug.id : ''}</td>
                            <td>${newBug.bugTitle}</td>
                            <td>${newBug.description}</td>
                            <td>${newBug.severity}</td>
                            <td>${newBug.status}</td>
                        </tr>
                    `;
                    // If table exists, append. If not, create table.
                    if ($('table tbody').length) {
                        $('table tbody').append(newRow);
                    } else {
                        // If no table, create one (optional)
                        // location.reload(); // fallback: reload page
                    }
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