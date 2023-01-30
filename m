Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 34D3528EB
	for <patches@lists.linux.dev>; Mon, 30 Jan 2023 14:02:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A0F71C433EF;
	Mon, 30 Jan 2023 14:02:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1675087374;
	bh=ydFMu5ZyxgpUiV8oCBnVJ4roBXD2zXe+BP/cCH793Js=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kIbfXFOE388ZKt+5AOLbmsrYLfGWZa07LWv9P/OqHUkqdIrQERj8iFUqN/p3ZhQIE
	 JDgQ7vhF+PixHIUpslIivDz+86huD29CIAfZ9RCY2ntbiwrlBb2SJwjsTp1UsYI3ux
	 ykVNqC4xtjXKDlKREkAsd59hL6hC5EfVAQAyxsWs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Thomas=20Wei=C3=9Fschuh?= <linux@weissschuh.net>,
	Hans de Goede <hdegoede@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 186/313] platform/x86: asus-wmi: Ignore fan on E410MA
Date: Mon, 30 Jan 2023 14:50:21 +0100
Message-Id: <20230130134345.371695079@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230130134336.532886729@linuxfoundation.org>
References: <20230130134336.532886729@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Thomas Weißschuh <linux@weissschuh.net>

[ Upstream commit 82cc5c6c624c63f7b57214e325e2ea685d924e89 ]

The ASUS VivoBook has a fan device described in its ACPI tables but does
not actually contain any physical fan.
Use the quirk to inhibit fan handling.

Signed-off-by: Thomas Weißschuh <linux@weissschuh.net>
Link: https://lore.kernel.org/r/20221221-asus-fan-v1-2-e07f3949725b@weissschuh.net
Reviewed-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/x86/asus-nb-wmi.c | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/drivers/platform/x86/asus-nb-wmi.c b/drivers/platform/x86/asus-nb-wmi.c
index b34bddda0a9b..cb15acdf14a3 100644
--- a/drivers/platform/x86/asus-nb-wmi.c
+++ b/drivers/platform/x86/asus-nb-wmi.c
@@ -121,6 +121,10 @@ static struct quirk_entry quirk_asus_tablet_mode = {
 	.tablet_switch_mode = asus_wmi_lid_flip_rog_devid,
 };
 
+static struct quirk_entry quirk_asus_ignore_fan = {
+	.wmi_ignore_fan = true,
+};
+
 static int dmi_matched(const struct dmi_system_id *dmi)
 {
 	pr_info("Identified laptop model '%s'\n", dmi->ident);
@@ -473,6 +477,15 @@ static const struct dmi_system_id asus_quirks[] = {
 		},
 		.driver_data = &quirk_asus_tablet_mode,
 	},
+	{
+		.callback = dmi_matched,
+		.ident = "ASUS VivoBook E410MA",
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "ASUSTeK COMPUTER INC."),
+			DMI_MATCH(DMI_PRODUCT_NAME, "E410MA"),
+		},
+		.driver_data = &quirk_asus_ignore_fan,
+	},
 	{},
 };
 
-- 
2.39.0



