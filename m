Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795057145;
	b=24AQqTzm/EgM269nrX+oxPne3Sz5Z1O5bX3Uit8mEYwU0LAcpv+hMMsBZ/0D4PEVMPwQ
	 o23/cb30iJALbZwttoouonSs9bhnLAQpLzt7pFWiRLE4uZWqvwPIUHtSghxJrB5vss4dL
	 GWB355NTS7cFf44eAwH9gm1CZoP8j9HjvRX5+aNyQRlvb0GFD/aIGbKDNVTgdhyBOJ2GG
	 vMcf2eKjAn1n0rGcx2Tpfe3cmX7zqLNvt1A0WrGqAuMyU+2jJhkpk5xcdxErADANlxiLA
	 FetX9e6gxlaZfupKP7iDCJqRIFcQjORGgaC2m7Wi9B1Pf6e7q8tdtqt0CUCoXoZ8Clg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795057145;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ekz7JF/VFaNOP4nCnZGuWWRd5LosZPjav8M2WfXXsRo=;
	b=whoPKKWbO6FfrBLQ4QAT0UJINjBSEMylpdlyk6xFjl6QMZsCqiNhMX1rujM20Mt+rSRq
	 X29zNWgrUJtCcdcAmT5xAO9l8mv3P48gdI7sJB5+fvHGK7nqbovVoLFhs/+NbSc2cxRv8
	 C05MuSCb61f1GstEKOZI37w8sluI0VBbWeCXRNuHx7jqkICGsm4lSZn26rFHiKJ84zp7z
	 v8Xjw9z2f5jmI1CxlZCGrMjeOGnwUCBtjKbKOAj9unmG/69rs6CSniR5xlgf1T+JeP+lv
	 Wx2oBKULpZYGSUgABwKxtYGSaaoqmrTAWYD3abXS+8U21nRpWaSDbjJ2an7CDMgtUjQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=M5wru4ZA;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 52EF9606A31C;
	Thu, 19 Nov 2026 02:59:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=M5wru4ZA
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AC4771F000C4;
	Thu, 19 Nov 2026 02:59:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795057145;
	bh=ekz7JF/VFaNOP4nCnZGuWWRd5LosZPjav8M2WfXXsRo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=M5wru4ZAMwVNOec9mL3UpYrurYk35PZJ9aFJoQSRumUddkBNO/zMOGoww2DkSlmnP
	 O1rNTfSX/4RGS9Z9WB2YeQn7x4Wuskz3pE/JAs+15237osDYkrPwcMCnob9yGSfNC/
	 C/zCDg2nKlyy7iv1REnx1BgewvieCSvHg1d5wcmA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Asad Kamal <asad.kamal@amd.com>,
	Lijo Lazar <lijo.lazar@amd.com>,
	Hawking Zhang <Hawking.Zhang@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 0027/1848] drm/amd/pm: Validate OD DPM triples before mutating tables
Date: Wed, 18 Nov 2026 15:34:25 +0100
Message-ID: <20261118145912.264492973@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index f2852e5c505ed..ca06b6da3e4e3 100644
--- a/drivers/gpu/drm/amd/pm/powerplay/hwmgr/smu7_hwmgr.c
+++ b/drivers/gpu/drm/amd/pm/powerplay/hwmgr/smu7_hwmgr.c
@@ -5093,23 +5093,29 @@ static int smu7_odn_edit_dpm_table(struct pp_hwmgr *hwmgr,
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
index 6a4ee61612313..77d9be460c961 100644
--- a/drivers/gpu/drm/amd/pm/powerplay/hwmgr/vega10_hwmgr.c
+++ b/drivers/gpu/drm/amd/pm/powerplay/hwmgr/vega10_hwmgr.c
@@ -5457,11 +5457,9 @@ static int vega10_odn_edit_dpm_table(struct pp_hwmgr *hwmgr,
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
@@ -5479,21 +5477,32 @@ static int vega10_odn_edit_dpm_table(struct pp_hwmgr *hwmgr,
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



