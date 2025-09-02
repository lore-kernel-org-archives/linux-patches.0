Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A96F331B137;
	Tue,  2 Sep 2025 13:29:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756819791; cv=none; b=Mv1iKyJvgTBgX5kEfHimRZO9VmdWtQHzinY42lr2Mnc7j8PpTXpR/4wQlVAwwiEsv7V8aCYCa0bXse3fjK9DsaOV/go9dW9ajQJX+83UaE2hiDx2ea3dg0TI6FkL/pLkoL5lDTc++byPXlRCGtvCUxZJ9WauuyAqQsejn3X4MuE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756819791; c=relaxed/simple;
	bh=8AD0/c+rd1lMl97spgaeab/t36JR3s9CBgqlyLuFmgA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JeyICB0oc/jLQKtVC4nqA0GjlzUZGYYbhpM58OmbYIIgq3eXpOEtI7dkfEHplU4x4dw4wJwShF3x1o9/6TWf2O/FgCjkyOVic2bBRjOwWwN+g4FWdSQj26ts16MMA2wyd4oI1uLJaCG2Jqwy9e9jGN5baxLG0DPn+65m69/j6/Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=G7WYqn7E; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="G7WYqn7E"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BB4BBC4CEFA;
	Tue,  2 Sep 2025 13:29:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756819791;
	bh=8AD0/c+rd1lMl97spgaeab/t36JR3s9CBgqlyLuFmgA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=G7WYqn7EU40B8NEkmBAYiIERBSBbBG6wcuuzK34hy4np/sc27V4BlCHyONo9c2jRh
	 KFDuP4METCe1JNrTcShgtePtzpnZ3tQbhOzn2FqMr/a2otM9j4GEuhRrdXFiA8wvFb
	 xcowbbg204ISAtElaKNaOooPWXDCjv9SP6totxWc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mason Chang <mason-cw.chang@mediatek.com>,
	Daniel Lezcano <daniel.lezcano@linaro.org>,
	Daniel Golle <daniel@makrotopia.org>
Subject: [PATCH 6.16 141/142] thermal/drivers/mediatek/lvts_thermal: Add lvts commands and their sizes to driver data
Date: Tue,  2 Sep 2025 15:20:43 +0200
Message-ID: <20250902131953.682268462@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250902131948.154194162@linuxfoundation.org>
References: <20250902131948.154194162@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mason Chang <mason-cw.chang@mediatek.com>

commit 6203a5e6fd090ed05f6d9b92e33bc7e7679a3dd6 upstream.

Add LVTS commands and their sizes to driver data in preparation for
adding different commands.

Signed-off-by: Mason Chang <mason-cw.chang@mediatek.com>
Link: https://lore.kernel.org/r/20250526102659.30225-3-mason-cw.chang@mediatek.com
Signed-off-by: Daniel Lezcano <daniel.lezcano@linaro.org>
Signed-off-by: Daniel Golle <daniel@makrotopia.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/thermal/mediatek/lvts_thermal.c |   65 +++++++++++++++++++++++++-------
 1 file changed, 52 insertions(+), 13 deletions(-)

--- a/drivers/thermal/mediatek/lvts_thermal.c
+++ b/drivers/thermal/mediatek/lvts_thermal.c
@@ -96,17 +96,6 @@
 
 #define LVTS_MINIMUM_THRESHOLD		20000
 
-static const u32 default_conn_cmds[] = { 0xC103FFFF, 0xC502FF55 };
-/*
- * Write device mask: 0xC1030000
- */
-static const u32 default_init_cmds[] = {
-	0xC1030E01, 0xC1030CFC, 0xC1030A8C, 0xC103098D, 0xC10308F1,
-	0xC10307A6, 0xC10306B8, 0xC1030500, 0xC1030420, 0xC1030300,
-	0xC1030030, 0xC10300F6, 0xC1030050, 0xC1030060, 0xC10300AC,
-	0xC10300FC, 0xC103009D, 0xC10300F1, 0xC10300E1
-};
-
 static int golden_temp = LVTS_GOLDEN_TEMP_DEFAULT;
 static int golden_temp_offset;
 
@@ -136,7 +125,11 @@ struct lvts_ctrl_data {
 
 struct lvts_data {
 	const struct lvts_ctrl_data *lvts_ctrl;
+	const u32 *conn_cmd;
+	const u32 *init_cmd;
 	int num_lvts_ctrl;
+	int num_conn_cmd;
+	int num_init_cmd;
 	int temp_factor;
 	int temp_offset;
 	int gt_calib_bit_offset;
@@ -996,9 +989,10 @@ static int lvts_ctrl_set_enable(struct l
 
 static int lvts_ctrl_connect(struct device *dev, struct lvts_ctrl *lvts_ctrl)
 {
+	const struct lvts_data *lvts_data = lvts_ctrl->lvts_data;
 	u32 id;
 
-	lvts_write_config(lvts_ctrl, default_conn_cmds, ARRAY_SIZE(default_conn_cmds));
+	lvts_write_config(lvts_ctrl, lvts_data->conn_cmd, lvts_data->num_conn_cmd);
 
 	/*
 	 * LVTS_ID : Get ID and status of the thermal controller
@@ -1017,7 +1011,9 @@ static int lvts_ctrl_connect(struct devi
 
 static int lvts_ctrl_initialize(struct device *dev, struct lvts_ctrl *lvts_ctrl)
 {
-	lvts_write_config(lvts_ctrl, default_init_cmds, ARRAY_SIZE(default_init_cmds));
+	const struct lvts_data *lvts_data = lvts_ctrl->lvts_data;
+
+	lvts_write_config(lvts_ctrl, lvts_data->init_cmd, lvts_data->num_init_cmd);
 
 	return 0;
 }
@@ -1446,6 +1442,17 @@ static int lvts_resume(struct device *de
 	return 0;
 }
 
+static const u32 default_conn_cmds[] = { 0xC103FFFF, 0xC502FF55 };
+/*
+ * Write device mask: 0xC1030000
+ */
+static const u32 default_init_cmds[] = {
+	0xC1030E01, 0xC1030CFC, 0xC1030A8C, 0xC103098D, 0xC10308F1,
+	0xC10307A6, 0xC10306B8, 0xC1030500, 0xC1030420, 0xC1030300,
+	0xC1030030, 0xC10300F6, 0xC1030050, 0xC1030060, 0xC10300AC,
+	0xC10300FC, 0xC103009D, 0xC10300F1, 0xC10300E1
+};
+
 /*
  * The MT8186 calibration data is stored as packed 3-byte little-endian
  * values using a weird layout that makes sense only when viewed as a 32-bit
@@ -1740,7 +1747,11 @@ static const struct lvts_ctrl_data mt819
 
 static const struct lvts_data mt7988_lvts_ap_data = {
 	.lvts_ctrl	= mt7988_lvts_ap_data_ctrl,
+	.conn_cmd	= default_conn_cmds,
+	.init_cmd	= default_init_cmds,
 	.num_lvts_ctrl	= ARRAY_SIZE(mt7988_lvts_ap_data_ctrl),
+	.num_conn_cmd	= ARRAY_SIZE(default_conn_cmds),
+	.num_init_cmd	= ARRAY_SIZE(default_init_cmds),
 	.temp_factor	= LVTS_COEFF_A_MT7988,
 	.temp_offset	= LVTS_COEFF_B_MT7988,
 	.gt_calib_bit_offset = 24,
@@ -1748,7 +1759,11 @@ static const struct lvts_data mt7988_lvt
 
 static const struct lvts_data mt8186_lvts_data = {
 	.lvts_ctrl	= mt8186_lvts_data_ctrl,
+	.conn_cmd	= default_conn_cmds,
+	.init_cmd	= default_init_cmds,
 	.num_lvts_ctrl	= ARRAY_SIZE(mt8186_lvts_data_ctrl),
+	.num_conn_cmd	= ARRAY_SIZE(default_conn_cmds),
+	.num_init_cmd	= ARRAY_SIZE(default_init_cmds),
 	.temp_factor	= LVTS_COEFF_A_MT7988,
 	.temp_offset	= LVTS_COEFF_B_MT7988,
 	.gt_calib_bit_offset = 24,
@@ -1757,7 +1772,11 @@ static const struct lvts_data mt8186_lvt
 
 static const struct lvts_data mt8188_lvts_mcu_data = {
 	.lvts_ctrl	= mt8188_lvts_mcu_data_ctrl,
+	.conn_cmd	= default_conn_cmds,
+	.init_cmd	= default_init_cmds,
 	.num_lvts_ctrl	= ARRAY_SIZE(mt8188_lvts_mcu_data_ctrl),
+	.num_conn_cmd	= ARRAY_SIZE(default_conn_cmds),
+	.num_init_cmd	= ARRAY_SIZE(default_init_cmds),
 	.temp_factor	= LVTS_COEFF_A_MT8195,
 	.temp_offset	= LVTS_COEFF_B_MT8195,
 	.gt_calib_bit_offset = 20,
@@ -1766,7 +1785,11 @@ static const struct lvts_data mt8188_lvt
 
 static const struct lvts_data mt8188_lvts_ap_data = {
 	.lvts_ctrl	= mt8188_lvts_ap_data_ctrl,
+	.conn_cmd	= default_conn_cmds,
+	.init_cmd	= default_init_cmds,
 	.num_lvts_ctrl	= ARRAY_SIZE(mt8188_lvts_ap_data_ctrl),
+	.num_conn_cmd	= ARRAY_SIZE(default_conn_cmds),
+	.num_init_cmd	= ARRAY_SIZE(default_init_cmds),
 	.temp_factor	= LVTS_COEFF_A_MT8195,
 	.temp_offset	= LVTS_COEFF_B_MT8195,
 	.gt_calib_bit_offset = 20,
@@ -1775,7 +1798,11 @@ static const struct lvts_data mt8188_lvt
 
 static const struct lvts_data mt8192_lvts_mcu_data = {
 	.lvts_ctrl	= mt8192_lvts_mcu_data_ctrl,
+	.conn_cmd	= default_conn_cmds,
+	.init_cmd	= default_init_cmds,
 	.num_lvts_ctrl	= ARRAY_SIZE(mt8192_lvts_mcu_data_ctrl),
+	.num_conn_cmd	= ARRAY_SIZE(default_conn_cmds),
+	.num_init_cmd	= ARRAY_SIZE(default_init_cmds),
 	.temp_factor	= LVTS_COEFF_A_MT8195,
 	.temp_offset	= LVTS_COEFF_B_MT8195,
 	.gt_calib_bit_offset = 24,
@@ -1784,7 +1811,11 @@ static const struct lvts_data mt8192_lvt
 
 static const struct lvts_data mt8192_lvts_ap_data = {
 	.lvts_ctrl	= mt8192_lvts_ap_data_ctrl,
+	.conn_cmd	= default_conn_cmds,
+	.init_cmd	= default_init_cmds,
 	.num_lvts_ctrl	= ARRAY_SIZE(mt8192_lvts_ap_data_ctrl),
+	.num_conn_cmd	= ARRAY_SIZE(default_conn_cmds),
+	.num_init_cmd	= ARRAY_SIZE(default_init_cmds),
 	.temp_factor	= LVTS_COEFF_A_MT8195,
 	.temp_offset	= LVTS_COEFF_B_MT8195,
 	.gt_calib_bit_offset = 24,
@@ -1793,7 +1824,11 @@ static const struct lvts_data mt8192_lvt
 
 static const struct lvts_data mt8195_lvts_mcu_data = {
 	.lvts_ctrl	= mt8195_lvts_mcu_data_ctrl,
+	.conn_cmd	= default_conn_cmds,
+	.init_cmd	= default_init_cmds,
 	.num_lvts_ctrl	= ARRAY_SIZE(mt8195_lvts_mcu_data_ctrl),
+	.num_conn_cmd	= ARRAY_SIZE(default_conn_cmds),
+	.num_init_cmd	= ARRAY_SIZE(default_init_cmds),
 	.temp_factor	= LVTS_COEFF_A_MT8195,
 	.temp_offset	= LVTS_COEFF_B_MT8195,
 	.gt_calib_bit_offset = 24,
@@ -1802,7 +1837,11 @@ static const struct lvts_data mt8195_lvt
 
 static const struct lvts_data mt8195_lvts_ap_data = {
 	.lvts_ctrl	= mt8195_lvts_ap_data_ctrl,
+	.conn_cmd	= default_conn_cmds,
+	.init_cmd	= default_init_cmds,
 	.num_lvts_ctrl	= ARRAY_SIZE(mt8195_lvts_ap_data_ctrl),
+	.num_conn_cmd	= ARRAY_SIZE(default_conn_cmds),
+	.num_init_cmd	= ARRAY_SIZE(default_init_cmds),
 	.temp_factor	= LVTS_COEFF_A_MT8195,
 	.temp_offset	= LVTS_COEFF_B_MT8195,
 	.gt_calib_bit_offset = 24,


