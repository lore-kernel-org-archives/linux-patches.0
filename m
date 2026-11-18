Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795033451;
	b=42Fy0Cx2wmBFdQIWmhH8oxWrHQLlJU2Z/Mi7kvQEzZhG9JLW2OM4cpOXo+lrfr8D7tIb
	 cpS3qnX1WJM9+XZ6q+YjcZNDFvdGlvlOVFJvPyeu7U8YZUmtKBhj/DwuEPBsWtifSMjeP
	 iGgL4fz2nhtFgh2/tMqVEYmK6sryrwVGzs1A3TQngVP5b2pw4BvTEmj+YWJSU00pUo9rE
	 vElEgLOuA7Lxpb3rs6YG3XsJJ0anOX9Wx+dmrLPuM9Xh3fQAPRZPfwk7X4ihBSPe47n/M
	 9Cs2mun42ZMqSjCSJ1h1jlBDzQFKwhG98JFMtr9FlUhcBbRGSM3bWs1SJwxY+x+ECHg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795033451;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=8qv5M7pavfQOTJwodxX+xwPMgF1MmKw3dOJ9GseM0lM=;
	b=eW2sg22PHA6nT6eNNbVg3AWt0AyU96BapqBXI7Do9teW9LwA6DsArnVwnm4QNHOTflTq
	 qy4aLTJTLaTzSQBqF2ECsJtSLk0RQks77Vinjv9LL6uArVRIUistyu3griqyWONByeCBu
	 I2ludM+rfV3sSMXVpx02p62+NV3mSDt+vdelL15qT8N8ITJYohWkG/OSYY5dLSxBE4wvT
	 LrehsVQ4+2CGy5iWUN2093SgqJmcqky9AkS6lduLytuk+90p9ud0G/OuVIY3XlkDlQ05G
	 VUQmTxNyigw/xEkXyDMm8wr0a/or4Qb4fQH3YQegolEt81G3cQYbUAOdDdEjHEPiWOA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=bkwsjrDC;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E5782606A320;
	Wed, 18 Nov 2026 20:24:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=bkwsjrDC
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 435271F000C4;
	Wed, 18 Nov 2026 20:24:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795033450;
	bh=8qv5M7pavfQOTJwodxX+xwPMgF1MmKw3dOJ9GseM0lM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=bkwsjrDCcDQPD+zI1OwmLM1WpmivwuKqrxcC3zgteEaiU7YqREc9HSAd8DoAqbYSA
	 VswWFRaL+9pPnOHETRQoIaHzQubbmL6l05HROcWkcFgASdYMq1qqA08ih7gW7pOOUR
	 P0KKsXPWND3HGktNn41X1J/Imhh2kwMSz//XPcPI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Asad Kamal <asad.kamal@amd.com>,
	Lijo Lazar <lijo.lazar@amd.com>,
	Hawking Zhang <Hawking.Zhang@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0020/3318] drm/amd/pm: Validate OD DPM triples before mutating tables
Date: Wed, 18 Nov 2026 15:10:42 +0100
Message-ID: <20261118150314.324226483@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Asad Kamal <asad.kamal@amd.com>

[ Upstream commit b390cb9d776039fc4f0be13b2649299079227d12 ]

vega10_odn_edit_dpm_table() and smu7_odn_edit_dpm_table() could mutate
the live ODN table for valid triples, then return 0 after detecting a
truncated buffer or out-of-range index. Validate all (index, clock,
voltage) triples first and return -EINVAL on any failure; only then
apply updates.

v2: Use distinct message for different error case, removed unused
input_level from validation loop (Lijo)

v3: Reject negative level indices, input[] is long but was compared only
against unsigned table bounds, so negative values could pass and truncate
when assigned to uint32_t input_level.

Set DPMTABLE_OD_UPDATE_SCLK/MCLK only after validation passes,
so a failed sysfs write does not leave need_update_dpm_table set for a
later commit.

Signed-off-by: Asad Kamal <asad.kamal@amd.com>
Reviewed-by: Lijo Lazar <lijo.lazar@amd.com>
Reviewed-by: Hawking Zhang <Hawking.Zhang@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../drm/amd/pm/powerplay/hwmgr/smu7_hwmgr.c   | 34 ++++++++++-------
 .../drm/amd/pm/powerplay/hwmgr/vega10_hwmgr.c | 37 ++++++++++++-------
 2 files changed, 43 insertions(+), 28 deletions(-)

diff --git a/drivers/gpu/drm/amd/pm/powerplay/hwmgr/smu7_hwmgr.c b/drivers/gpu/drm/amd/pm/powerplay/hwmgr/smu7_hwmgr.c
index 73e0d10c02fa2..fe99538c2f6fc 100644
--- a/drivers/gpu/drm/amd/pm/powerplay/hwmgr/smu7_hwmgr.c
+++ b/drivers/gpu/drm/amd/pm/powerplay/hwmgr/smu7_hwmgr.c
@@ -5654,23 +5654,29 @@ static int smu7_odn_edit_dpm_table(struct pp_hwmgr *hwmgr,
 	}
 
 	for (i = 0; i < size; i += 3) {
-		if (i + 3 > size || input[i] >= podn_dpm_table_in_backend->num_of_pl) {
-			pr_info("invalid clock voltage input \n");
-			return 0;
+		if (i + 3 > size) {
+			pr_info("truncated clock/voltage input\n");
+			return -EINVAL;
 		}
-		input_level = input[i];
-		input_clk = input[i+1] * 100;
-		input_vol = input[i+2];
-
-		if (smu7_check_clk_voltage_valid(hwmgr, type, input_clk, input_vol)) {
-			podn_dpm_table_in_backend->entries[input_level].clock = input_clk;
-			podn_vdd_dep_in_backend->entries[input_level].clk = input_clk;
-			podn_dpm_table_in_backend->entries[input_level].vddc = input_vol;
-			podn_vdd_dep_in_backend->entries[input_level].vddc = input_vol;
-			podn_vdd_dep_in_backend->entries[input_level].vddgfx = input_vol;
-		} else {
+		if (input[i] < 0 || input[i] >= podn_dpm_table_in_backend->num_of_pl) {
+			pr_info("invalid clock/voltage level\n");
 			return -EINVAL;
 		}
+		input_clk = input[i + 1] * 100;
+		input_vol = input[i + 2];
+		if (!smu7_check_clk_voltage_valid(hwmgr, type, input_clk, input_vol))
+			return -EINVAL;
+	}
+
+	for (i = 0; i < size; i += 3) {
+		input_level = input[i];
+		input_clk = input[i + 1] * 100;
+		input_vol = input[i + 2];
+		podn_dpm_table_in_backend->entries[input_level].clock = input_clk;
+		podn_vdd_dep_in_backend->entries[input_level].clk = input_clk;
+		podn_dpm_table_in_backend->entries[input_level].vddc = input_vol;
+		podn_vdd_dep_in_backend->entries[input_level].vddc = input_vol;
+		podn_vdd_dep_in_backend->entries[input_level].vddgfx = input_vol;
 	}
 
 	return 0;
diff --git a/drivers/gpu/drm/amd/pm/powerplay/hwmgr/vega10_hwmgr.c b/drivers/gpu/drm/amd/pm/powerplay/hwmgr/vega10_hwmgr.c
index 084ed8c5bf428..312b18ad78aee 100644
--- a/drivers/gpu/drm/amd/pm/powerplay/hwmgr/vega10_hwmgr.c
+++ b/drivers/gpu/drm/amd/pm/powerplay/hwmgr/vega10_hwmgr.c
@@ -5640,11 +5640,9 @@ static int vega10_odn_edit_dpm_table(struct pp_hwmgr *hwmgr,
 	if (PP_OD_EDIT_SCLK_VDDC_TABLE == type) {
 		dpm_table = &data->dpm_table.gfx_table;
 		podn_vdd_dep_table = &data->odn_dpm_table.vdd_dep_on_sclk;
-		data->need_update_dpm_table |= DPMTABLE_OD_UPDATE_SCLK;
 	} else if (PP_OD_EDIT_MCLK_VDDC_TABLE == type) {
 		dpm_table = &data->dpm_table.mem_table;
 		podn_vdd_dep_table = &data->odn_dpm_table.vdd_dep_on_mclk;
-		data->need_update_dpm_table |= DPMTABLE_OD_UPDATE_MCLK;
 	} else if (PP_OD_RESTORE_DEFAULT_TABLE == type) {
 		memcpy(&(data->dpm_table), &(data->golden_dpm_table), sizeof(struct vega10_dpm_table));
 		vega10_odn_initial_default_setting(hwmgr);
@@ -5662,21 +5660,32 @@ static int vega10_odn_edit_dpm_table(struct pp_hwmgr *hwmgr,
 	}
 
 	for (i = 0; i < size; i += 3) {
-		if (i + 3 > size || input[i] >= podn_vdd_dep_table->count) {
-			pr_info("invalid clock voltage input\n");
-			return 0;
+		if (i + 3 > size) {
+			pr_info("truncated clock/voltage input\n");
+			return -EINVAL;
 		}
-		input_level = input[i];
-		input_clk = input[i+1] * 100;
-		input_vol = input[i+2];
-
-		if (vega10_check_clk_voltage_valid(hwmgr, type, input_clk, input_vol)) {
-			dpm_table->dpm_levels[input_level].value = input_clk;
-			podn_vdd_dep_table->entries[input_level].clk = input_clk;
-			podn_vdd_dep_table->entries[input_level].vddc = input_vol;
-		} else {
+		if (input[i] < 0 || input[i] >= podn_vdd_dep_table->count) {
+			pr_info("invalid clock/voltage level\n");
 			return -EINVAL;
 		}
+		input_clk = input[i + 1] * 100;
+		input_vol = input[i + 2];
+		if (!vega10_check_clk_voltage_valid(hwmgr, type, input_clk, input_vol))
+			return -EINVAL;
+	}
+
+	if (type == PP_OD_EDIT_SCLK_VDDC_TABLE)
+		data->need_update_dpm_table |= DPMTABLE_OD_UPDATE_SCLK;
+	else
+		data->need_update_dpm_table |= DPMTABLE_OD_UPDATE_MCLK;
+
+	for (i = 0; i < size; i += 3) {
+		input_level = input[i];
+		input_clk = input[i + 1] * 100;
+		input_vol = input[i + 2];
+		dpm_table->dpm_levels[input_level].value = input_clk;
+		podn_vdd_dep_table->entries[input_level].clk = input_clk;
+		podn_vdd_dep_table->entries[input_level].vddc = input_vol;
 	}
 	vega10_odn_update_soc_table(hwmgr, type);
 	return 0;
-- 
2.53.0



