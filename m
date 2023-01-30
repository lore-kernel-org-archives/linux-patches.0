Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C0E2928EB
	for <patches@lists.linux.dev>; Mon, 30 Jan 2023 14:14:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 410ECC433EF;
	Mon, 30 Jan 2023 14:14:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1675088095;
	bh=4Gc73CJ873XpudmASwn0YLSJWc8kOkJVPH3jrtCX4Zo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=D/zZavZD30eIAiPnjvqdQXAtz9pFa12GH45Jzxh9bfkgGHYi/762PvCoK1qo7U50J
	 VSdFdsiE6/muWWlHYnDuM42rrk9HNpEY+390op9qE1rpyKI+ZKkjyCjHQvUreVwqaq
	 aV2EtJJAdndL22bMY8ee8weyepLTaSc6NzCKpU70=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michael Klein <m.klein@mvz-labor-lb.de>,
	Hans de Goede <hdegoede@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 114/204] platform/x86: touchscreen_dmi: Add info for the CSL Panther Tab HD
Date: Mon, 30 Jan 2023 14:51:19 +0100
Message-Id: <20230130134321.475179134@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230130134316.327556078@linuxfoundation.org>
References: <20230130134316.327556078@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Michael Klein <m.klein@mvz-labor-lb.de>

[ Upstream commit 36c2b9d6710427f802494ba070621cb415198293 ]

Add touchscreen info for the CSL Panther Tab HD.

Signed-off-by: Michael Klein <m.klein@mvz-labor-lb.de>
Link: https://lore.kernel.org/r/20221220121103.uiwn5l7fii2iggct@LLGMVZLB-0037
Reviewed-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/x86/touchscreen_dmi.c | 25 +++++++++++++++++++++++++
 1 file changed, 25 insertions(+)

diff --git a/drivers/platform/x86/touchscreen_dmi.c b/drivers/platform/x86/touchscreen_dmi.c
index 3d0790263fa7..93671037fd59 100644
--- a/drivers/platform/x86/touchscreen_dmi.c
+++ b/drivers/platform/x86/touchscreen_dmi.c
@@ -255,6 +255,23 @@ static const struct ts_dmi_data connect_tablet9_data = {
 	.properties     = connect_tablet9_props,
 };
 
+static const struct property_entry csl_panther_tab_hd_props[] = {
+	PROPERTY_ENTRY_U32("touchscreen-min-x", 1),
+	PROPERTY_ENTRY_U32("touchscreen-min-y", 20),
+	PROPERTY_ENTRY_U32("touchscreen-size-x", 1980),
+	PROPERTY_ENTRY_U32("touchscreen-size-y", 1526),
+	PROPERTY_ENTRY_BOOL("touchscreen-inverted-y"),
+	PROPERTY_ENTRY_BOOL("touchscreen-swapped-x-y"),
+	PROPERTY_ENTRY_STRING("firmware-name", "gsl1680-csl-panther-tab-hd.fw"),
+	PROPERTY_ENTRY_U32("silead,max-fingers", 10),
+	{ }
+};
+
+static const struct ts_dmi_data csl_panther_tab_hd_data = {
+	.acpi_name      = "MSSL1680:00",
+	.properties     = csl_panther_tab_hd_props,
+};
+
 static const struct property_entry cube_iwork8_air_props[] = {
 	PROPERTY_ENTRY_U32("touchscreen-min-x", 1),
 	PROPERTY_ENTRY_U32("touchscreen-min-y", 3),
@@ -1100,6 +1117,14 @@ const struct dmi_system_id touchscreen_dmi_table[] = {
 			DMI_MATCH(DMI_PRODUCT_NAME, "Tablet 9"),
 		},
 	},
+	{
+		/* CSL Panther Tab HD */
+		.driver_data = (void *)&csl_panther_tab_hd_data,
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "CSL Computer GmbH & Co. KG"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "CSL Panther Tab HD"),
+		},
+	},
 	{
 		/* CUBE iwork8 Air */
 		.driver_data = (void *)&cube_iwork8_air_data,
-- 
2.39.0



