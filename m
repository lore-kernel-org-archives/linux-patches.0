Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2DF4814012
	for <patches@lists.linux.dev>; Mon, 23 Oct 2023 11:08:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OKFnPZt1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 98B30C433C8;
	Mon, 23 Oct 2023 11:08:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1698059316;
	bh=vTEFKl+x+uFukC2otFWMhzuSCcOEyP42CzJSp+CxhL4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OKFnPZt12Orzuhy2bscUP6iDUCqwXP93BTBYZ/wRqmNjHR01ulspDaGoQwc9T6kOd
	 iSiMQrPfTETfNi8iGJaEr/dpdxANrMXSuzQ+tR0Ww0N8RzQaaHnw0P9jQkn6+WWJcZ
	 02agFPAkQJqfyzR4DnDXx4ECRiDmfbxU29vvBLNM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tomasz Swiatek <swiatektomasz99@gmail.com>,
	Hans de Goede <hdegoede@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.5 136/241] platform/x86: touchscreen_dmi: Add info for the BUSH Bush Windows tablet
Date: Mon, 23 Oct 2023 12:55:22 +0200
Message-ID: <20231023104837.184050808@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231023104833.832874523@linuxfoundation.org>
References: <20231023104833.832874523@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tomasz Swiatek <swiatektomasz99@gmail.com>

[ Upstream commit 34c271e778c1d8589ee9c833eee5ecb6fbb03149 ]

Add touchscreen info for the BUSH Bush Windows tablet.

It was tested using gslx680_ts_acpi module and on patched kernel
installed on device.

Link: https://github.com/onitake/gsl-firmware/pull/215
Link: https://github.com/systemd/systemd/pull/29268
Signed-off-by: Tomasz Swiatek <swiatektomasz99@gmail.com>
Reviewed-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/x86/touchscreen_dmi.c | 22 ++++++++++++++++++++++
 1 file changed, 22 insertions(+)

diff --git a/drivers/platform/x86/touchscreen_dmi.c b/drivers/platform/x86/touchscreen_dmi.c
index f9301a9382e74..363a9848e2b88 100644
--- a/drivers/platform/x86/touchscreen_dmi.c
+++ b/drivers/platform/x86/touchscreen_dmi.c
@@ -42,6 +42,21 @@ static const struct ts_dmi_data archos_101_cesium_educ_data = {
 	.properties     = archos_101_cesium_educ_props,
 };
 
+static const struct property_entry bush_bush_windows_tablet_props[] = {
+	PROPERTY_ENTRY_U32("touchscreen-size-x", 1850),
+	PROPERTY_ENTRY_U32("touchscreen-size-y", 1280),
+	PROPERTY_ENTRY_BOOL("touchscreen-swapped-x-y"),
+	PROPERTY_ENTRY_U32("silead,max-fingers", 10),
+	PROPERTY_ENTRY_BOOL("silead,home-button"),
+	PROPERTY_ENTRY_STRING("firmware-name", "gsl1680-bush-bush-windows-tablet.fw"),
+	{ }
+};
+
+static const struct ts_dmi_data bush_bush_windows_tablet_data = {
+	.acpi_name      = "MSSL1680:00",
+	.properties     = bush_bush_windows_tablet_props,
+};
+
 static const struct property_entry chuwi_hi8_props[] = {
 	PROPERTY_ENTRY_U32("touchscreen-size-x", 1665),
 	PROPERTY_ENTRY_U32("touchscreen-size-y", 1140),
@@ -1070,6 +1085,13 @@ const struct dmi_system_id touchscreen_dmi_table[] = {
 			DMI_MATCH(DMI_PRODUCT_NAME, "ARCHOS 101 Cesium Educ"),
 		},
 	},
+	{
+		/* Bush Windows tablet */
+		.driver_data = (void *)&bush_bush_windows_tablet_data,
+		.matches = {
+			DMI_MATCH(DMI_PRODUCT_NAME, "Bush Windows tablet"),
+		},
+	},
 	{
 		/* Chuwi Hi8 */
 		.driver_data = (void *)&chuwi_hi8_data,
-- 
2.40.1



