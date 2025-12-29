Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2AD4922CBD9;
	Mon, 29 Dec 2025 16:14:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767024880; cv=none; b=oPJnZ6a4KiiQ/rrtigbJAhj2vXBKBjVtKjR9/KBGpfF1Qme4RR4GAYCRC3lL3OP7dtdIRcHYVDNheANpK7uY/8UqDmnDSM0/bS6gwO7L6LfC4IE4lNSvfugjiknFkbdoZlr8lcG3hgfS7+rcXfSW7mT7mLC5QNGqSS6J9B62wzI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767024880; c=relaxed/simple;
	bh=jSrYkvZbXtDJp1t3cTt6WSCWFJO8nOO71fz5Ynknzqc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CZjuyaXm6QfEyyLg2jAWMZVkbLQ/gPjzNpV/F6Tu1ChTJwWoQBqLXCtRAqN6hPwRku2orasRqLq1ezWLsjQZ9MdmxNeIEQTDD3q8WdUgtx9nIznu23z6mejBg/Uad/yWmcbfx2zzz6xGEHRzBjSQnjQWqlR8QWpCB46MzOhXz8Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xKYYHL4E; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xKYYHL4E"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5C903C4CEF7;
	Mon, 29 Dec 2025 16:14:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767024879;
	bh=jSrYkvZbXtDJp1t3cTt6WSCWFJO8nOO71fz5Ynknzqc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xKYYHL4EvHPvOA5F9K0tiDpuVBcc9rCtcJ6PZbU9EhEc2k10pz2wW8mmK56OtApRl
	 GLgxfHwKWNpSfV6kzmp/8u3gocLyPlTjPBlS7pCZ/zqeZOFhhuClkB7TQQKqSNg6r1
	 GCQNtPzTo1+K3qjUN27OPJv/Cpqfhwnb2vR4LRHQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
	Jonathan Cameron <jonathan.cameron@huawei.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 017/430] ACPI: property: Use ACPI functions in acpi_graph_get_next_endpoint() only
Date: Mon, 29 Dec 2025 17:06:59 +0100
Message-ID: <20251229160724.788911337@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251229160724.139406961@linuxfoundation.org>
References: <20251229160724.139406961@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sakari Ailus <sakari.ailus@linux.intel.com>

[ Upstream commit 5d010473cdeaabf6a2d3a9e2aed2186c1b73c213 ]

Calling fwnode_get_next_child_node() in ACPI implementation of the fwnode
property API is somewhat problematic as the latter is used in the
impelementation of the former. Instead of using
fwnode_get_next_child_node() in acpi_graph_get_next_endpoint(), call
acpi_get_next_subnode() directly instead.

Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Reviewed-by: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
Reviewed-by: Jonathan Cameron <jonathan.cameron@huawei.com>
Link: https://patch.msgid.link/20251001104320.1272752-3-sakari.ailus@linux.intel.com
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/acpi/property.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/acpi/property.c b/drivers/acpi/property.c
index b12057baaae7b..19737f9e1e16f 100644
--- a/drivers/acpi/property.c
+++ b/drivers/acpi/property.c
@@ -1472,7 +1472,7 @@ static struct fwnode_handle *acpi_graph_get_next_endpoint(
 
 	if (!prev) {
 		do {
-			port = fwnode_get_next_child_node(fwnode, port);
+			port = acpi_get_next_subnode(fwnode, port);
 			/*
 			 * The names of the port nodes begin with "port@"
 			 * followed by the number of the port node and they also
@@ -1490,13 +1490,13 @@ static struct fwnode_handle *acpi_graph_get_next_endpoint(
 	if (!port)
 		return NULL;
 
-	endpoint = fwnode_get_next_child_node(port, prev);
+	endpoint = acpi_get_next_subnode(port, prev);
 	while (!endpoint) {
-		port = fwnode_get_next_child_node(fwnode, port);
+		port = acpi_get_next_subnode(fwnode, port);
 		if (!port)
 			break;
 		if (is_acpi_graph_node(port, "port"))
-			endpoint = fwnode_get_next_child_node(port, NULL);
+			endpoint = acpi_get_next_subnode(port, NULL);
 	}
 
 	/*
-- 
2.51.0



