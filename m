Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A3B684ABBD4;
	Thu, 17 Sep 2026 16:05:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789661109; cv=none; b=gVsmnTvJYLKyScKj1Dk4+YcwgxSVvmh7mt0E+azLVU8c/gSFcfitcSjGBuzvRN4BqmFigkXStcGADWcpxxQILkPC+2t3KXVYmmD+5l30kmQ8Gv57QHQ01jMCrJBIOf8gvKo0o9d85u/R51MHPSGVS9sMHOZuFZpFJ4rtAe53A88=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789661109; c=relaxed/simple;
	bh=qQuVe8bssH7T6o32w5fN3xsS52Wt4Ui5rrnUPAnChI0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EVStom3gs/txQhFi4x6sU7DIv7O2lddwwgwY3GhoNYiaVZaSehugliQgLiCMGe64T4a95tbakOG5H1l0RFblMc9NKXgMG/HB+90bmrxvD/Utb9jv8tCCx2E0ShlHATwFtWS36B8/3fHMAxr7JgreqFpbc+FH8CRRwqGvstCAbsQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rKRxKRZw; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rKRxKRZw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 08B931F000FF;
	Thu, 17 Sep 2026 16:05:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789661108;
	bh=2IQOFdgKCcD48nspj9Zcuwu579AL8bFKIv63JwJBBE8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=rKRxKRZwTeE98iLjwq5pxNm+NTmCC3hHpsoHyfAt6jVqBFh7AnTNZTlXL9LEh+iuW
	 0monuz6xBbmPTe7lctuVfjPtB/1Eqo5HmoEQy2uRZ1gIlu8xx4bnQFrgsf8SI1Qb01
	 hBonQd4zln+dAcC/A0Vch7PmwSod3NCT4/fGr7a8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mark Pearson <mpearson-lenovo@squebb.ca>,
	Guenter Roeck <linux@roeck-us.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0086/1250] watchdog: lenovo_se10_wdt: Add support for SE10 Gen 2 platform
Date: Thu, 17 Sep 2026 15:58:01 +0100
Message-ID: <20260917151554.312203557@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151551.901433442@linuxfoundation.org>
References: <20260917151551.901433442@linuxfoundation.org>
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



