Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 19BBC14263
	for <patches@lists.linux.dev>; Mon, 23 Oct 2023 11:08:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pRM5tdxm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 87930C433C9;
	Mon, 23 Oct 2023 11:08:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1698059330;
	bh=6bowPTYvC6wSX+PXqF/Mnuj/jqczWk3cQf4+/gnDVrQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pRM5tdxmwMWmODfaX65qoD98fudpKv7FgXBoXio5+0/IeosiJKGRUT9UchguLKnlo
	 XhNOwW1i0TlO4OzeHCdX0eojvi/P1I2ywTukDuYJYtO9hCI+PD9zZ7q5GJrMJQVYTW
	 ooBCsBI9BbluX1uWl25y5g5IgmbuXQqNfjUiTvJ4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Renan Guilherme Lebre Ramos <japareaggae@gmail.com>,
	Hans de Goede <hdegoede@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.5 141/241] platform/x86: touchscreen_dmi: Add info for the Positivo C4128B
Date: Mon, 23 Oct 2023 12:55:27 +0200
Message-ID: <20231023104837.313367077@linuxfoundation.org>
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

From: Renan Guilherme Lebre Ramos <japareaggae@gmail.com>

[ Upstream commit aa7dcba3bae6869122828b144a3cfd231718089d ]

Add information for the Positivo C4128B, a notebook/tablet convertible.

Link: https://github.com/onitake/gsl-firmware/pull/217
Signed-off-by: Renan Guilherme Lebre Ramos <japareaggae@gmail.com>
Link: https://lore.kernel.org/r/20231004235900.426240-1-japareaggae@gmail.com
Reviewed-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/x86/touchscreen_dmi.c | 23 +++++++++++++++++++++++
 1 file changed, 23 insertions(+)

diff --git a/drivers/platform/x86/touchscreen_dmi.c b/drivers/platform/x86/touchscreen_dmi.c
index 363a9848e2b88..0c67337726984 100644
--- a/drivers/platform/x86/touchscreen_dmi.c
+++ b/drivers/platform/x86/touchscreen_dmi.c
@@ -771,6 +771,21 @@ static const struct ts_dmi_data pipo_w11_data = {
 	.properties	= pipo_w11_props,
 };
 
+static const struct property_entry positivo_c4128b_props[] = {
+	PROPERTY_ENTRY_U32("touchscreen-min-x", 4),
+	PROPERTY_ENTRY_U32("touchscreen-min-y", 13),
+	PROPERTY_ENTRY_U32("touchscreen-size-x", 1915),
+	PROPERTY_ENTRY_U32("touchscreen-size-y", 1269),
+	PROPERTY_ENTRY_STRING("firmware-name", "gsl1680-positivo-c4128b.fw"),
+	PROPERTY_ENTRY_U32("silead,max-fingers", 10),
+	{ }
+};
+
+static const struct ts_dmi_data positivo_c4128b_data = {
+	.acpi_name	= "MSSL1680:00",
+	.properties	= positivo_c4128b_props,
+};
+
 static const struct property_entry pov_mobii_wintab_p800w_v20_props[] = {
 	PROPERTY_ENTRY_U32("touchscreen-min-x", 32),
 	PROPERTY_ENTRY_U32("touchscreen-min-y", 16),
@@ -1502,6 +1517,14 @@ const struct dmi_system_id touchscreen_dmi_table[] = {
 			DMI_MATCH(DMI_BIOS_VERSION, "MOMO.G.WI71C.MABMRBA02"),
 		},
 	},
+	{
+		/* Positivo C4128B */
+		.driver_data = (void *)&positivo_c4128b_data,
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "Positivo Tecnologia SA"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "C4128B-1"),
+		},
+	},
 	{
 		/* Point of View mobii wintab p800w (v2.0) */
 		.driver_data = (void *)&pov_mobii_wintab_p800w_v20_data,
-- 
2.40.1



