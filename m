Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 880454F4CF0;
	Thu, 17 Sep 2026 17:49:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789667341; cv=none; b=DJpzzOi0UenVtiRnIUrdlj+C6HIkDldkmkaaIN0OXB8N2bcCEBgpR8a8M63PHTXHQgtnDST68gL4vs7WswhMsNqOFZlPfw6LbIcHTMSuuE99oALFCJa/wwFzfJVtKs7cYLDS8qIYPxT9IhIgX1cci6/ur4FvPEFVbzGQlNWEi8w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789667341; c=relaxed/simple;
	bh=Nqce8BpXC9XHvQHfu/Rgg0pYMa5p6iKAHsxz3dtuLHQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Zl96InB1npSKEz7NF/bO2hy1lW/V9vYPd0UkZQ87Q5v2Q6YnPZ1dI6kVmn1Yj1v1AzJ4zB5MZKmfBfheUAHGC8lTANPtuEz3cuWdd3q9+Zj/1uddEIGU1Z3gCsNpbP5u0sDz2AywYfGCttHfXXL6RyyRWfhWcBkkSvTcf38H4PE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oOOExEAy; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oOOExEAy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B8F051F000FF;
	Thu, 17 Sep 2026 17:48:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789667340;
	bh=4tpb/JAOhBWXljKI6/LirspsgAF8fHGeaAI5QgnY9Q8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=oOOExEAyKIearDzgA4PEIKLRMEAwoi470gp1u+oMVertWOr6ZbMy8fhRXn4/MwrlP
	 vRtgCaDAvx27Lzwyzb5tFfEDLhG2dQGWopC4accvG1IibWb8od435U/fNWxt5hP73m
	 aCGi2SZzugEGfNSahd5BORnT6rax7ZPELgdKLFoE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mark Pearson <mpearson-lenovo@squebb.ca>,
	Guenter Roeck <linux@roeck-us.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0061/1102] watchdog: lenovo_se10_wdt: Add support for SE10 Gen 2 platform
Date: Thu, 17 Sep 2026 16:00:04 +0100
Message-ID: <20260917151540.988706992@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151539.408551884@linuxfoundation.org>
References: <20260917151539.408551884@linuxfoundation.org>
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

From: Mark Pearson <mpearson-lenovo@squebb.ca>

[ Upstream commit 7b25feb19ce8073193fff6a05a43b5a5c2854b4b ]

The Lenovo SE10 Gen 2 platform uses a watchdog chip from the same family.
Watchdog functionality is the same, so update the driver with the new chip
ID.

Add the Gen 2 MTM's to enable support on the platform.

Tested on SE10 G2.

Signed-off-by: Mark Pearson <mpearson-lenovo@squebb.ca>
Link: https://lore.kernel.org/r/20260428124954.1193450-1-mpearson-lenovo@squebb.ca
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/watchdog/lenovo_se10_wdt.c | 66 +++++++++++++++++++++++++++++-
 1 file changed, 65 insertions(+), 1 deletion(-)

diff --git a/drivers/watchdog/lenovo_se10_wdt.c b/drivers/watchdog/lenovo_se10_wdt.c
index cd0500e5080b4..99ff01af41243 100644
--- a/drivers/watchdog/lenovo_se10_wdt.c
+++ b/drivers/watchdog/lenovo_se10_wdt.c
@@ -178,7 +178,7 @@ static int se10_wdt_probe(struct platform_device *pdev)
 		return -EBUSY;
 
 	chip_id = get_chipID();
-	if (chip_id != 0x5632) {
+	if (chip_id != 0x5632 && chip_id != 0x5652) {
 		release_region(CFG_PORT, CFG_SIZE);
 		return -ENODEV;
 	}
@@ -280,6 +280,70 @@ static const struct dmi_system_id se10_dmi_table[] __initconst = {
 		},
 		.callback = se10_create_platform_device,
 	},
+	{
+		.ident = "LENOVO-SE10-G2",
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "LENOVO"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "13LJ"),
+		},
+		.callback = se10_create_platform_device,
+	},
+	{
+		.ident = "LENOVO-SE10-G2",
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "LENOVO"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "13LK"),
+		},
+		.callback = se10_create_platform_device,
+	},
+	{
+		.ident = "LENOVO-SE10-G2",
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "LENOVO"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "13S1"),
+		},
+		.callback = se10_create_platform_device,
+	},
+	{
+		.ident = "LENOVO-SE10-G2",
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "LENOVO"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "13S2"),
+		},
+		.callback = se10_create_platform_device,
+	},
+	{
+		.ident = "LENOVO-SE10-G2",
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "LENOVO"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "13S3"),
+		},
+		.callback = se10_create_platform_device,
+	},
+	{
+		.ident = "LENOVO-SE10-G2",
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "LENOVO"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "13S4"),
+		},
+		.callback = se10_create_platform_device,
+	},
+	{
+		.ident = "LENOVO-SE10-G2",
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "LENOVO"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "13S5"),
+		},
+		.callback = se10_create_platform_device,
+	},
+	{
+		.ident = "LENOVO-SE10-G2",
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "LENOVO"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "13S6"),
+		},
+		.callback = se10_create_platform_device,
+	},
 	{}
 };
 MODULE_DEVICE_TABLE(dmi, se10_dmi_table);
-- 
2.53.0



