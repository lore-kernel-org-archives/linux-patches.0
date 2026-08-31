Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 848FB4B387B;
	Mon, 31 Aug 2026 13:52:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788184327; cv=none; b=srLAqPD1kCkW17fHT+eU2BYRPxaNd9eE6KD397KrXAnfRiIx8t6ZO7jqNmo7ewLH5aMB0GgrfUXHwnIMwiPWgTebSlAaxNghZMkNZq4GWfnlBXN2YADXE4Iq4HpgZIvRD19/L9+dWulzhxzCdA9+ibyLCyBGXh4o9/28F69FseQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788184327; c=relaxed/simple;
	bh=UKbE8Vjwes4TL6ZTcS5/esfZdVwnTrYRpKDESMo3oSw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Nc2KhegUjZvV7F4yefVUSsipjGESA9QutGtgvrwZFC/qVam5dm+s2tgmx04B/WWD1oKoXknfmJTuiYRTqpS7/9W/E+CkVZBeM8L98hy0Flp3N8O2GZ3ZZ1tWkbJPFFJv/cng7tLpq1TQ+fHMT38kZoh90HYvgR4+Qc83QfiTgUA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=M78dQ0ex; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="M78dQ0ex"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 941861F00ADB;
	Mon, 31 Aug 2026 13:52:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788184325;
	bh=n9CokUx5yYfzrb1Or8u9C+gFdqLvtr+1GVFLUJxDmuU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=M78dQ0exfqikgciEIPc2nSxal/3sXJNQTgtFLKsw7vSqCanAz3hXVa9VU5v1OIzhZ
	 SgGvsMUD9u7/9Y9vqDMMm0TlEWSdNoAhrGCTtctsHdebdq5E+r99revGAt88GaOdLV
	 aDQVYWnZ8QTH2WfFJFIWbm1Pw47ZkojwML6dKcUGdsiil+ql6WjpwxuRuwkPq66hyJ
	 nTqSJDv9mdAf7vWoqFvBrAKlopqtxVywqRH1QirCkzAIQ5qFR9rfsO9zxQl1hF7Uqa
	 XVnshrRU2K0vcTmS64av9BzximA9gaRBujkYgDbZJpIdJJI0BcuHTi8aOaq67rUH2X
	 +Z20eDZ1BEwRw==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Mark Pearson <mpearson-lenovo@squebb.ca>,
	Guenter Roeck <linux@roeck-us.net>,
	Sasha Levin <sashal@kernel.org>,
	wim@linux-watchdog.org,
	linux-watchdog@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18-6.12] watchdog: lenovo_se10_wdt: Fix use-after-free and resource leak risk
Date: Mon, 31 Aug 2026 09:30:54 -0400
Message-ID: <20260831133314.4125787-626-sashal@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260831133314.4125787-1-sashal@kernel.org>
References: <20260831133314.4125787-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.18.48
Content-Transfer-Encoding: 8bit

From: Mark Pearson <mpearson-lenovo@squebb.ca>

[ Upstream commit 3394e894880a60338a2981dd688fd25e88d79667 ]

Review by sashiko.dev highlighted potential use after free and resource
leak instances.

Set se10_pdev to null to prevent use after free

Remove DMI call back and instead directly call
se10_create_platform_device. Handle error cases appropriately

Link: https://sashiko.dev/#/patchset/20260428124954.1193450-1-mpearson-lenovo%40squebb.ca

Signed-off-by: Mark Pearson <mpearson-lenovo@squebb.ca>
Link: https://lore.kernel.org/r/20260504180159.999189-1-mpearson-lenovo@squebb.ca
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

The history search finished. In this 6.18.43 checkout, `git log -S
'lenovo-se10-wdt'` shows the driver file first appearing at
`5d324e5159d9e` (Nov 2025 USB merge). That matches what we already saw
in blame.

The driver itself was added upstream in 6.10 (`watchdog:
lenovo_se10_wdt: Watchdog driver for Lenovo SE10 platform`); the buggy
DMI-callback init pattern has been there since then. Nothing in this
changes the earlier **YES** backport recommendation.

 drivers/watchdog/lenovo_se10_wdt.c | 32 ++++++++++++++----------------
 1 file changed, 15 insertions(+), 17 deletions(-)

diff --git a/drivers/watchdog/lenovo_se10_wdt.c b/drivers/watchdog/lenovo_se10_wdt.c
index 99ff01af41243..503e220263f95 100644
--- a/drivers/watchdog/lenovo_se10_wdt.c
+++ b/drivers/watchdog/lenovo_se10_wdt.c
@@ -224,7 +224,7 @@ static struct platform_driver se10_wdt_driver = {
 	.probe  = se10_wdt_probe,
 };
 
-static int se10_create_platform_device(const struct dmi_system_id *id)
+static int se10_create_platform_device(void)
 {
 	int err;
 
@@ -233,9 +233,10 @@ static int se10_create_platform_device(const struct dmi_system_id *id)
 		return -ENOMEM;
 
 	err = platform_device_add(se10_pdev);
-	if (err)
+	if (err) {
 		platform_device_put(se10_pdev);
-
+		se10_pdev = NULL;
+	}
 	return err;
 }
 
@@ -246,7 +247,6 @@ static const struct dmi_system_id se10_dmi_table[] __initconst = {
 			DMI_MATCH(DMI_SYS_VENDOR, "LENOVO"),
 			DMI_MATCH(DMI_PRODUCT_NAME, "12NH"),
 		},
-		.callback = se10_create_platform_device,
 	},
 	{
 		.ident = "LENOVO-SE10",
@@ -254,7 +254,6 @@ static const struct dmi_system_id se10_dmi_table[] __initconst = {
 			DMI_MATCH(DMI_SYS_VENDOR, "LENOVO"),
 			DMI_MATCH(DMI_PRODUCT_NAME, "12NJ"),
 		},
-		.callback = se10_create_platform_device,
 	},
 	{
 		.ident = "LENOVO-SE10",
@@ -262,7 +261,6 @@ static const struct dmi_system_id se10_dmi_table[] __initconst = {
 			DMI_MATCH(DMI_SYS_VENDOR, "LENOVO"),
 			DMI_MATCH(DMI_PRODUCT_NAME, "12NK"),
 		},
-		.callback = se10_create_platform_device,
 	},
 	{
 		.ident = "LENOVO-SE10",
@@ -270,7 +268,6 @@ static const struct dmi_system_id se10_dmi_table[] __initconst = {
 			DMI_MATCH(DMI_SYS_VENDOR, "LENOVO"),
 			DMI_MATCH(DMI_PRODUCT_NAME, "12NL"),
 		},
-		.callback = se10_create_platform_device,
 	},
 	{
 		.ident = "LENOVO-SE10",
@@ -278,7 +275,6 @@ static const struct dmi_system_id se10_dmi_table[] __initconst = {
 			DMI_MATCH(DMI_SYS_VENDOR, "LENOVO"),
 			DMI_MATCH(DMI_PRODUCT_NAME, "12NM"),
 		},
-		.callback = se10_create_platform_device,
 	},
 	{
 		.ident = "LENOVO-SE10-G2",
@@ -286,7 +282,6 @@ static const struct dmi_system_id se10_dmi_table[] __initconst = {
 			DMI_MATCH(DMI_SYS_VENDOR, "LENOVO"),
 			DMI_MATCH(DMI_PRODUCT_NAME, "13LJ"),
 		},
-		.callback = se10_create_platform_device,
 	},
 	{
 		.ident = "LENOVO-SE10-G2",
@@ -294,7 +289,6 @@ static const struct dmi_system_id se10_dmi_table[] __initconst = {
 			DMI_MATCH(DMI_SYS_VENDOR, "LENOVO"),
 			DMI_MATCH(DMI_PRODUCT_NAME, "13LK"),
 		},
-		.callback = se10_create_platform_device,
 	},
 	{
 		.ident = "LENOVO-SE10-G2",
@@ -302,7 +296,6 @@ static const struct dmi_system_id se10_dmi_table[] __initconst = {
 			DMI_MATCH(DMI_SYS_VENDOR, "LENOVO"),
 			DMI_MATCH(DMI_PRODUCT_NAME, "13S1"),
 		},
-		.callback = se10_create_platform_device,
 	},
 	{
 		.ident = "LENOVO-SE10-G2",
@@ -310,7 +303,6 @@ static const struct dmi_system_id se10_dmi_table[] __initconst = {
 			DMI_MATCH(DMI_SYS_VENDOR, "LENOVO"),
 			DMI_MATCH(DMI_PRODUCT_NAME, "13S2"),
 		},
-		.callback = se10_create_platform_device,
 	},
 	{
 		.ident = "LENOVO-SE10-G2",
@@ -318,7 +310,6 @@ static const struct dmi_system_id se10_dmi_table[] __initconst = {
 			DMI_MATCH(DMI_SYS_VENDOR, "LENOVO"),
 			DMI_MATCH(DMI_PRODUCT_NAME, "13S3"),
 		},
-		.callback = se10_create_platform_device,
 	},
 	{
 		.ident = "LENOVO-SE10-G2",
@@ -326,7 +317,6 @@ static const struct dmi_system_id se10_dmi_table[] __initconst = {
 			DMI_MATCH(DMI_SYS_VENDOR, "LENOVO"),
 			DMI_MATCH(DMI_PRODUCT_NAME, "13S4"),
 		},
-		.callback = se10_create_platform_device,
 	},
 	{
 		.ident = "LENOVO-SE10-G2",
@@ -334,7 +324,6 @@ static const struct dmi_system_id se10_dmi_table[] __initconst = {
 			DMI_MATCH(DMI_SYS_VENDOR, "LENOVO"),
 			DMI_MATCH(DMI_PRODUCT_NAME, "13S5"),
 		},
-		.callback = se10_create_platform_device,
 	},
 	{
 		.ident = "LENOVO-SE10-G2",
@@ -342,7 +331,6 @@ static const struct dmi_system_id se10_dmi_table[] __initconst = {
 			DMI_MATCH(DMI_SYS_VENDOR, "LENOVO"),
 			DMI_MATCH(DMI_PRODUCT_NAME, "13S6"),
 		},
-		.callback = se10_create_platform_device,
 	},
 	{}
 };
@@ -350,10 +338,20 @@ MODULE_DEVICE_TABLE(dmi, se10_dmi_table);
 
 static int __init se10_wdt_init(void)
 {
+	int err;
+
 	if (!dmi_check_system(se10_dmi_table))
 		return -ENODEV;
 
-	return platform_driver_register(&se10_wdt_driver);
+	err = platform_driver_register(&se10_wdt_driver);
+	if (err)
+		return err;
+
+	err = se10_create_platform_device();
+	if (err)
+		platform_driver_unregister(&se10_wdt_driver);
+
+	return err;
 }
 
 static void __exit se10_wdt_exit(void)
-- 
2.53.0

