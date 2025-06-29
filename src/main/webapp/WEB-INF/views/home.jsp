<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <title>Home Page</title>
</head>
<body>
    <h1>Welcome to the Home Page!</h1>
    <c:set var="username" value="Guest" />
    <p>Hello, <c:out value="${username}" />!</p>

    <h2>Sample List</h2>
    <c:set var="items" value="${['Apple', 'Banana', 'Cherry']}" />
    <ul>
        <c:forEach var="item" items="${items}">
            <li><c:out value="${item}" /></li>
        </c:forEach>
    </ul>
</body>
</html>