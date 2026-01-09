Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE0F735B13F;
	Fri,  9 Jan 2026 12:34:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767962063; cv=none; b=VLL9LKf9ngR7GYgKq6QUyra5PGEsuXcxzqpggp20P7SuxN1+ng1yx6Jp5SD/yEkUEKgQ7mGMp1l+9NsnMFe3g7uNjUEN4Fecz076l1LwHNK5569uePEIqHH0A35dVUG1Ek6r5ior7H9UIfnOYYwqMXLSK+NJDS/kjZGt7WwoRI8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767962063; c=relaxed/simple;
	bh=+smaygD2mIOt8sI4Vhmj0DM7SFdmpt5Vxz0tGJhLXBo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YWMimhXAzcV42rq6roRAPKDpWAex/g0WzZQ+rASnfTcrFkr2jYgoabAi7MElkG5Qv7bR0gw9MMEY3c3Uyi5gO5WMV9SddKh2TJ+ck7K7HvUcX0r4dJ/a5oRVAYpjusMBt+L1j6AEscJXGX2ISOtju6Ohb8WDwUThRerAuvM0sP8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NSFNOKRu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NSFNOKRu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F4230C4CEF1;
	Fri,  9 Jan 2026 12:34:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767962063;
	bh=+smaygD2mIOt8sI4Vhmj0DM7SFdmpt5Vxz0tGJhLXBo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NSFNOKRuzwsQTnr6DfT2YfIGKpCF1ydQKrhCNVqhfVLlchjqYlviGeTBq/HvEdiwU
	 dZkqa6HuVKmWldp/mBcoTAaG9sjK04HtvrHlEc5WjksloSSbZWc8VtKnu5qNyXFjen
	 dEx9TWxIGQvREecrplri/wVDPp4CHGthSXqQhbtk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
	Jonathan Cameron <jonathan.cameron@huawei.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 233/634] ACPI: property: Use ACPI functions in acpi_graph_get_next_endpoint() only
Date: Fri,  9 Jan 2026 12:38:31 +0100
Message-ID: <20260109112126.196258387@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260109112117.407257400@linuxfoundation.org>
References: <20260109112117.407257400@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 0ff1c3d2504d4..577942d29d133 100644
--- a/drivers/acpi/property.c
+++ b/drivers/acpi/property.c
@@ -1382,7 +1382,7 @@ static struct fwnode_handle *acpi_graph_get_next_endpoint(
 
 	if (!prev) {
 		do {
-			port = fwnode_get_next_child_node(fwnode, port);
+			port = acpi_get_next_subnode(fwnode, port);
 			/*
 			 * The names of the port nodes begin with "port@"
 			 * followed by the number of the port node and they also
@@ -1400,13 +1400,13 @@ static struct fwnode_handle *acpi_graph_get_next_endpoint(
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



