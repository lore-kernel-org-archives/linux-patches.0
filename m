Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB5083D6465;
	Thu, 15 Jan 2026 17:49:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768499368; cv=none; b=SDuH+g8Gbm1ow+ia5CLukxQm2n25xBa6+W1TZ71vjPYTZV28bL1RLTZiesOdKOJOUInVqMiTOXXi4NWpP93IqTeUYs1ivLJ7V8gSMm+XsV+v+1FLF9vCv99rNpUaVZS0Hu9clwRzZrurAevhX0gf5EuiB/yGqCI27QGlITcmP58=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768499368; c=relaxed/simple;
	bh=H7ojO6amcCifPlF4BSQWhFlgxF1TVM8LFtVY9BroH1o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MKb20qPATA5U1iw3Rnf/KGY9kynzHbM7RXagzDzFpCdDmWvYQSHcYz9JzJHjDph/wQnoy8wW873HGC/YNuxBgH5TX3b8mdN7LcZOSBaTuLsjXm8oehnDQmGjSf9W6SvO8Ke1bd7hzZcPn94hewAyBKPRKr1vRKTO8fJ8MrW+VaE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=q3NcexK4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="q3NcexK4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 37080C116D0;
	Thu, 15 Jan 2026 17:49:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1768499368;
	bh=H7ojO6amcCifPlF4BSQWhFlgxF1TVM8LFtVY9BroH1o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=q3NcexK4uutaqhKdwkbCjBrUqqgFIKrF4sJOSawEFeQjcjMs2B8QxgfByVuzM1+Zv
	 OvjLlyLfd0G67EuUAofVZwzQST29NJgZSQVqzTHiCwUfvvdAd9BJFm8CTe8afM6nW3
	 UmrVGX/yaT2dsaBgpxbWJWmtbDlqA5WWwCSR4lSI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
	Jonathan Cameron <jonathan.cameron@huawei.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 159/451] ACPI: property: Use ACPI functions in acpi_graph_get_next_endpoint() only
Date: Thu, 15 Jan 2026 17:46:00 +0100
Message-ID: <20260115164236.663419198@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260115164230.864985076@linuxfoundation.org>
References: <20260115164230.864985076@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 7c3d98fae457d..3a3efd15b8497 100644
--- a/drivers/acpi/property.c
+++ b/drivers/acpi/property.c
@@ -1188,7 +1188,7 @@ static struct fwnode_handle *acpi_graph_get_next_endpoint(
 
 	if (!prev) {
 		do {
-			port = fwnode_get_next_child_node(fwnode, port);
+			port = acpi_get_next_subnode(fwnode, port);
 			/*
 			 * The names of the port nodes begin with "port@"
 			 * followed by the number of the port node and they also
@@ -1206,13 +1206,13 @@ static struct fwnode_handle *acpi_graph_get_next_endpoint(
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



