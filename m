Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795033544;
	b=dI+Oqa31zKq1RDTWijY7ROPmZl2OcZBV3hkZLPRPzEpdZWTz3nzND7GIlr0ISqR5gZNG
	 93Rq1Xsn8p+NwQLVKEajlW5wi9ge+Y9h+wupbwUypCmuvDwzLqPB+7A45sk+GJpZTrJw7
	 GgFniK58x33QiT12azxeeOHtGie89bNU6M3qzgeMX0LBTrte1LWQ2f54oAJPYrQrueu/o
	 6GRHkZSjz9V5V/y9yxtaSQQjhduzgpJx0tUFYroOUj5700g+l6kA4MC4/JlDr7ZLl+CUg
	 32KMZrD7sZK7y+Qt2gDMhiS4CgZzWXcYx2EVt3q+RhgRm3ZNHIjkaZOecqBaMsn6esg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795033544;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ZAz9ibq+/hcUKB4UBLvmvmsoDab710naIg59McHKukc=;
	b=uMTQgPOqTQhQEXlPOV6DmTtpcgjlTOEwgyRmU3LnRYb05TGEWdrPSDZIyBJ6XuU5yPof
	 AUsbVBW7ASuYTCemFI/8cQI6vjtn/Pgco7QWVQ4ZWIfCxtEoicdyTbslYE0NcDZuC7dT0
	 6oTZ43n9cr05mVN831PFtFhXkKrWqZPb/NfomSzPL22Fw21JP0PuUEWcIsr7SA5FRRS6V
	 JHUXh8ONJyp9hciohaOGNbngg0MVRqGkfPgeWqvYCIkhWV3oOjXn47XCJYf6plasGUZUD
	 ngpQ96CfF4NwEc9UE6RknZO+aXW76EijyVGv89E03uTZD6WcZzep2/qnRRWspcJ94pw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=KA0trm7V;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 39E5A606A31C;
	Wed, 18 Nov 2026 20:25:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=KA0trm7V
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9414C1F000C5;
	Wed, 18 Nov 2026 20:25:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795033544;
	bh=ZAz9ibq+/hcUKB4UBLvmvmsoDab710naIg59McHKukc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=KA0trm7Vm+TGqcyRDSgSK6Xr+VGe0RC1eNDND8DTjZ/rGnJvJgYyTZ9iycINUXjMk
	 2qfdx9YT1/ng5BlmeTq18FsEdbfyUScuKZrDuUBKUbe1v1rJxedftW0aIviTPceo90
	 NZk6itsOpU+lvyUY4iBYD2qt7gyC8CJRvwkxCr2g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xiang Liu <xiang.liu@amd.com>,
	Hawking Zhang <Hawking.Zhang@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0052/3318] drm/amd/pm: Guard VBIOS AC timing table walk
Date: Wed, 18 Nov 2026 15:11:14 +0100
Message-ID: <20261118150315.480929583@linuxfoundation.org>
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



