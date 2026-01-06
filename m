Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0ED8B340A46;
	Tue,  6 Jan 2026 17:15:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767719701; cv=none; b=Jn62UYFjs22kyTA+VXMiaQVhmKP6M2kL0JnLz1KI12CRb+69PoiZE0rUSLDgM+XSLSu7QBs9umuCQYVger9sep/MzAZtkGWIowHBKuPvmyhfGRTQP/f/UNFd6sAbZiph83cSy92hE2TgCAbNhW4KZLotTSmIwONSDD61Jids53M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767719701; c=relaxed/simple;
	bh=gz9o5UWsp2aztMdy6kAbP7mbqHzL8kT5TjOmsrVK2Bo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PjcGYO1PFi7yJHW0uG5O6jCcb0utBa6Q8A7gi7/Ra3WdRaWZ9zrd1jPWF9vG6lDUPJ5AtQHVkn6kk80KAh+ld4IuHufwAn/ljkrk6FtMPcEBymbJ+mASJa4QfTb8Y5n4aeCGR3QpxEOmfmUEwfbu00OsIKTVSwfao+I3RA5NtYg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EOqG5Knw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EOqG5Knw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E32B5C116C6;
	Tue,  6 Jan 2026 17:14:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767719700;
	bh=gz9o5UWsp2aztMdy6kAbP7mbqHzL8kT5TjOmsrVK2Bo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EOqG5Knw6DAHqBYbDzCnopgySnC36O0QL7k173jstrF+srFWiFopdGfzfBc3zCzLM
	 twQPMiJln9CAAXJHQbvFt9jBfuaLS7WOdnhd/Ghn0IIsea1kvmxNaZRQ2rPrtTJCd6
	 wK16+LIQzJmSaHFaxXegSIgJUiIpqWf09DTmeLF4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
	Jonathan Cameron <jonathan.cameron@huawei.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 014/567] ACPI: property: Use ACPI functions in acpi_graph_get_next_endpoint() only
Date: Tue,  6 Jan 2026 17:56:36 +0100
Message-ID: <20260106170451.869964080@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260106170451.332875001@linuxfoundation.org>
References: <20260106170451.332875001@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index b7ee463e757d2..8a37de04b69be 100644
--- a/drivers/acpi/property.c
+++ b/drivers/acpi/property.c
@@ -1441,7 +1441,7 @@ static struct fwnode_handle *acpi_graph_get_next_endpoint(
 
 	if (!prev) {
 		do {
-			port = fwnode_get_next_child_node(fwnode, port);
+			port = acpi_get_next_subnode(fwnode, port);
 			/*
 			 * The names of the port nodes begin with "port@"
 			 * followed by the number of the port node and they also
@@ -1459,13 +1459,13 @@ static struct fwnode_handle *acpi_graph_get_next_endpoint(
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



