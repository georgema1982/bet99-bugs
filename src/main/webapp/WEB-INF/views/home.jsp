<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html>
<head>
    <title><spring:message code="home.title" /></title>
    <!-- Bootstrap CSS CDN -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <!-- Bootstrap Icons CDN -->
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">
</head>
<body>
    <div class="container mt-5">
        <div id="successAlert" class="alert alert-success alert-dismissible fade show d-none" role="alert">
            <spring:message code="alert.success" />
            <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="<spring:message code='button.close'/>"></button>
        </div>

        <div id="errorAlert" class="alert alert-danger alert-dismissible fade show d-none" role="alert">
            <spring:message code="alert.error" />
            <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="<spring:message code='button.close'/>"></button>
        </div>

        <h1 class="mb-4"><spring:message code="home.heading" /></h1>

        <!-- Add Bug Button, Refresh Button, and Filter Button -->
        <div class="mb-3 d-flex gap-2 align-items-center">
            <button type="button" class="btn btn-primary" data-bs-toggle="modal" data-bs-target="#addBugModal" title="<spring:message code='button.addBug'/>">
                <i class="bi bi-plus-circle"></i>
            </button>
            <button type="button" class="btn btn-secondary" id="refreshBugsBtn" title="<spring:message code='button.refresh'/>">
                <i class="bi bi-arrow-clockwise"></i>
            </button>
            <button type="button" class="btn btn-info" data-bs-toggle="collapse" data-bs-target="#filterCollapse" aria-expanded="false" aria-controls="filterCollapse" id="filterBugsBtn" title="<spring:message code='button.filter'/>">
                <i class="bi bi-funnel"></i>
            </button>
        </div>

        <!-- Bootstrap Collapse for Filter -->
        <div class="collapse mb-3" id="filterCollapse">
            <div class="card card-body" style="max-width: 300px;">
                <label for="filterSeverity" class="form-label mb-1"><spring:message code="label.filterSeverity" /></label>
                <select class="form-select" id="filterSeverity">
                    <option value=""><spring:message code="option.allSeverities" /></option>
                    <c:forEach var="sev" items="${severities}">
                        <option value="${sev}">
                            <spring:message code="severity.${fn:toLowerCase(sev)}" />
                        </option>
                    </c:forEach>
                </select>
            </div>
        </div>

        <table class="table table-striped table-bordered mt-3" id="bugsTable">
            <thead class="table-dark">
                <tr>
                    <th><spring:message code="table.id" /></th>
                    <th><spring:message code="table.title" /></th>
                    <th><spring:message code="table.description" /></th>
                    <th><spring:message code="table.severity" /></th>
                    <th><spring:message code="table.status" /></th>
                </tr>
            </thead>
            <tbody>
                <!-- Rows will be dynamically inserted here -->
            </tbody>
            <tfoot>
                <tr id="noBugsMsg" class="d-none">
                    <td colspan="5" class="alert alert-info m-0 text-center"><spring:message code="table.noBugs" /></td>
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
            <td class="bug-severity" data-severity=""></td>
            <td class="bug-status"></td>
        </tr>
    </template>

    <!-- Add Bug Modal -->
    <div class="modal fade" id="addBugModal" tabindex="-1" aria-labelledby="addBugModalLabel" aria-hidden="true">
      <div class="modal-dialog">
        <div class="modal-content">
          <form id="addBugForm">
            <div class="modal-header">
              <h5 class="modal-title" id="addBugModalLabel"><spring:message code="modal.addBugTitle" /></h5>
              <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="<spring:message code='button.close'/>"></button>
            </div>
            <div class="modal-body">
                <div class="mb-3">
                    <label for="bugTitle" class="form-label"><spring:message code="label.title" /></label>
                    <input type="text" class="form-control" id="bugTitle" name="bugTitle" required>
                </div>
                <div class="mb-3">
                    <label for="description" class="form-label"><spring:message code="label.description" /></label>
                    <textarea class="form-control" id="description" name="description" required></textarea>
                </div>
                <div class="mb-3">
                    <label for="severity" class="form-label"><spring:message code="label.severity" /></label>
                    <select class="form-select" id="severity" name="severity" required>
                        <option value=""><spring:message code="option.selectSeverity" /></option>
                        <c:forEach var="sev" items="${severities}">
                            <option value="${sev}">
                                <spring:message code="severity.${fn:toLowerCase(sev)}" />
                            </option>
                        </c:forEach>
                    </select>
                </div>
                <div class="mb-3">
                    <label for="status" class="form-label"><spring:message code="label.status" /></label>
                    <select class="form-select" id="status" name="status" required>
                        <option value=""><spring:message code="option.selectStatus" /></option>
                        <c:forEach var="stat" items="${statuses}">
                            <option value="${stat}">
                                <spring:message code="status.${fn:toLowerCase(stat)}" />
                            </option>
                        </c:forEach>
                    </select>
                </div>
            </div>
            <div class="modal-footer">
              <button type="button" class="btn btn-secondary" data-bs-dismiss="modal"><spring:message code="button.cancel" /></button>
              <button type="submit" class="btn btn-primary"><spring:message code="button.addBug" /></button>
            </div>
          </form>
        </div>
      </div>
    </div>

    <!-- Hidden severity messages for localization -->
    <div id="severity-messages" class="d-none">
        <c:forEach var="sev" items="${severities}">
            <span data-key="severity.${fn:toLowerCase(sev)}">
                <spring:message code="severity.${fn:toLowerCase(sev)}"/>
            </span>
        </c:forEach>
    </div>

    <!-- Hidden status messages for localization -->
    <div id="status-messages" class="d-none">
        <c:forEach var="stat" items="${statuses}">
            <span data-key="status.${fn:toLowerCase(stat)}">
                <spring:message code="status.${fn:toLowerCase(stat)}"/>
            </span>
        </c:forEach>
    </div>

    <!-- Bootstrap JS Bundle CDN (optional, for interactive components) -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
    <script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>
    <script src="<c:url value='/js/bugs.js'/>"></script>
</body>
</html>