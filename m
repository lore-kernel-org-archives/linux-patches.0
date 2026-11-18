Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795051092;
	b=YsqV9+by1gU/S2ga0VpFx+Zb/xB9W1KD+qcteHrM//icFhD0udw8KFwV/aK463SoTvQx
	 yQCbHlnLIywmMnkD/PBLK3qN4WrOxXEB/Cxy7VDdOaPdu6NEDANXeSuC+rieUXa1Snu17
	 v83xEw+oGiXCS6IvIadVRHlPoi8T5sqfyWPV7mMyr853C+BiyBx+sKStFmnduyh1I7f0C
	 AvK4HVC7zX4ar2hN3NDiVHEBCDkR1LqHuLGp9ucNw4aJm2eB6tp+bcl1rFmisUVVfZeqT
	 1NkZBDCFW9qS+O+V9lwwo/1R6+OwQZaj/2IfTxa8n72unfOzICY2ue6MRoep5QEyJzg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795051092;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=p/pWNXbGxPPDIe5jX/kNUD8LzMjAanZ0Xe29pn0IbXQ=;
	b=u2zaLGh/MlZXi8EmidkvQmfTzCVtGhVhuNdLNlHxWPX8sCRpMoXxKu2oZvDkqbSAKkK3
	 R0nD2poduRY9RT+QmfzlOuTaHFkipS74epq7iA4WqamAo3Ptuei7tx1eekYmIXm4l67xM
	 +h7pZX6E8ZLcC4pjMhOY5kPd3lbTFqtWYzYL0KZHig0amKxjJ9E/GsPNW5ayYd5kPZfFO
	 SU/35eCiY8tHRleuKpS99f5vS9GtUu+As/GBdu6QE4XcDU2uRlr+ZQmnA5LVw+5Ygno+1
	 sNHJ0GLR0WHnhyJx6vFPKxucS6a/q0Pur0hH1kx0uGfI+XtmOv+4UOQ2S+bRZ8DJOFw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=n3zNvzf9;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DBC9F606A330;
	Thu, 19 Nov 2026 01:18:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=n3zNvzf9
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1FB201F000C5;
	Thu, 19 Nov 2026 01:18:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795051092;
	bh=p/pWNXbGxPPDIe5jX/kNUD8LzMjAanZ0Xe29pn0IbXQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=n3zNvzf9Y+9Y4ohm58pIPVevJPaQdC1nSeaAxyTsX3FNWlMOSpy19vPSyG0Ec8rO1
	 WLYX8IKz1aKcSw+O+XrT7gHjUWmJSwpL5F5IOPoHMnuasjhdTbyuLtWsEPO2x0hg1X
	 NuCp0Mq+XZl/v2QbtflNnk+YwzDsY1i+n3jrwmaI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xiang Liu <xiang.liu@amd.com>,
	Hawking Zhang <Hawking.Zhang@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 0045/2214] drm/amd/pm: Guard VBIOS AC timing table walk
Date: Wed, 18 Nov 2026 15:28:41 +0100
Message-ID: <20261118150011.853194624@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Xiang Liu <xiang.liu@amd.com>

[ Upstream commit 2bf6867e5953a140fc91c3159987656e44ed29fb ]

Reject AC timing blocks with a stride smaller than a dword before walking
VBIOS data. A zero stride can otherwise keep reg_data pinned on a
nonmatching MEM_ID forever.

Also bound the data-block and END marker reads by the returned VRAM_Info
table size so malformed index/data sizes do not push the timing walk past
the table.

Signed-off-by: Xiang Liu <xiang.liu@amd.com>
Reviewed-by: Hawking Zhang <Hawking.Zhang@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../drm/amd/pm/powerplay/hwmgr/ppatomctrl.c   | 28 +++++++++++++++----
 1 file changed, 22 insertions(+), 6 deletions(-)

diff --git a/drivers/gpu/drm/amd/pm/powerplay/hwmgr/ppatomctrl.c b/drivers/gpu/drm/amd/pm/powerplay/hwmgr/ppatomctrl.c
index 640350bbd9085..e981cc3d2f1a5 100644
--- a/drivers/gpu/drm/amd/pm/powerplay/hwmgr/ppatomctrl.c
+++ b/drivers/gpu/drm/amd/pm/powerplay/hwmgr/ppatomctrl.c
@@ -47,16 +47,22 @@ union voltage_object_info {
 static int atomctrl_retrieve_ac_timing(
 		uint8_t index,
 		ATOM_INIT_REG_BLOCK *reg_block,
+		u8 *table_end,
 		pp_atomctrl_mc_reg_table *table)
 {
 	uint32_t i, j;
+	u16 stride = le16_to_cpu(reg_block->usRegDataBlkSize);
 	uint8_t tmem_id;
 	ATOM_MEMORY_SETTING_DATA_BLOCK *reg_data = (ATOM_MEMORY_SETTING_DATA_BLOCK *)
 		((uint8_t *)reg_block + (2 * sizeof(uint16_t)) + le16_to_cpu(reg_block->usRegIndexTblSize));
 
 	uint8_t num_ranges = 0;
 
-	while (*(uint32_t *)reg_data != END_OF_REG_DATA_BLOCK &&
+	if (stride < sizeof(uint32_t))
+		return -EINVAL;
+
+	while ((uint8_t *)reg_data + sizeof(uint32_t) <= table_end &&
+	       *(uint32_t *)reg_data != END_OF_REG_DATA_BLOCK &&
 			num_ranges < VBIOS_MAX_AC_TIMING_ENTRIES) {
 		tmem_id = (uint8_t)((*(uint32_t *)reg_data & MEM_ID_MASK) >> MEM_ID_SHIFT);
 
@@ -68,6 +74,10 @@ static int atomctrl_retrieve_ac_timing(
 			for (i = 0, j = 1; i < table->last; i++) {
 				if ((table->mc_reg_address[i].uc_pre_reg_data &
 							LOW_NIBBLE_MASK) == DATA_FROM_TABLE) {
+					if ((uint8_t *)reg_data +
+					    (j + 1) * sizeof(uint32_t) > table_end)
+						return -EINVAL;
+
 					table->mc_reg_table_entry[num_ranges].mc_data[i] =
 						(uint32_t)*((uint32_t *)reg_data + j);
 					j++;
@@ -82,11 +92,13 @@ static int atomctrl_retrieve_ac_timing(
 		}
 
 		reg_data = (ATOM_MEMORY_SETTING_DATA_BLOCK *)
-			((uint8_t *)reg_data + le16_to_cpu(reg_block->usRegDataBlkSize)) ;
+			((uint8_t *)reg_data + stride);
 	}
 
-	PP_ASSERT_WITH_CODE((*(uint32_t *)reg_data == END_OF_REG_DATA_BLOCK),
-			"Invalid VramInfo table.", return -1);
+	if ((uint8_t *)reg_data + sizeof(uint32_t) > table_end ||
+	    *(uint32_t *)reg_data != END_OF_REG_DATA_BLOCK)
+		return -EINVAL;
+
 	table->num_entries = num_ranges;
 
 	return 0;
@@ -137,6 +149,7 @@ int atomctrl_initialize_mc_reg_table(
 {
 	ATOM_VRAM_INFO_HEADER_V2_1 *vram_info;
 	ATOM_INIT_REG_BLOCK *reg_block;
+	u8 *table_end;
 	int result = 0;
 	u8 frev, crev;
 	u16 size;
@@ -158,6 +171,7 @@ int atomctrl_initialize_mc_reg_table(
 	}
 
 	if (0 == result) {
+		table_end = (uint8_t *)vram_info + size;
 		reg_block = (ATOM_INIT_REG_BLOCK *)
 			((uint8_t *)vram_info + le16_to_cpu(vram_info->usMemClkPatchTblOffset));
 		result = atomctrl_set_mc_reg_address_table(reg_block, table);
@@ -165,7 +179,7 @@ int atomctrl_initialize_mc_reg_table(
 
 	if (0 == result) {
 		result = atomctrl_retrieve_ac_timing(module_index,
-					reg_block, table);
+					reg_block, table_end, table);
 	}
 
 	return result;
@@ -178,6 +192,7 @@ int atomctrl_initialize_mc_reg_table_v2_2(
 {
 	ATOM_VRAM_INFO_HEADER_V2_2 *vram_info;
 	ATOM_INIT_REG_BLOCK *reg_block;
+	u8 *table_end;
 	int result = 0;
 	u8 frev, crev;
 	u16 size;
@@ -199,6 +214,7 @@ int atomctrl_initialize_mc_reg_table_v2_2(
 	}
 
 	if (0 == result) {
+		table_end = (uint8_t *)vram_info + size;
 		reg_block = (ATOM_INIT_REG_BLOCK *)
 			((uint8_t *)vram_info + le16_to_cpu(vram_info->usMemClkPatchTblOffset));
 		result = atomctrl_set_mc_reg_address_table(reg_block, table);
@@ -206,7 +222,7 @@ int atomctrl_initialize_mc_reg_table_v2_2(
 
 	if (0 == result) {
 		result = atomctrl_retrieve_ac_timing(module_index,
-					reg_block, table);
+					reg_block, table_end, table);
 	}
 
 	return result;
-- 
2.53.0



