Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793829357;
	b=YfU+/x5fE+t+jugaWal6FhPPkt67QJVuMXS4beYFQm98mW5FnzkpRsFKJwo96CVDak0D
	 CLgB0RdWJvzKKgO7dajBxlYSiy1ZKeJxxHGWxuqFgsY7IQInTCFRSgOsQGtc9foj2qCeu
	 r/MUsiV1I7iCSH/gWQmebZU8ffELI023ER5vqWsGSudJj9VRApicd5g+NnPNfNgMw2sDh
	 3DTPjd8ij+9ks1Xw7UVrK3bROTwajIexcDfZKTRVkhNB6QLo267QShQ4UnsZxg+6iLi7Q
	 6ILRHe9y0Q80QJv4S/vb2/Vm2w+JmmDe9ueaCIfXfO8MPvKQbDRl2Xs2SAqYdbe1adw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793829357;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=wiJ7TAV6+6DMin7BeNzVECOhkqFEsEIPIXAIhycS9K4=;
	b=ebtxsEGHHeWwgCcPG36nZtc/4O+F4ZDGK8OfQZJ32177pcpoOOOjHR2S8Uc5F/nVRsYo
	 9BLOdFDqum39lLMQ40HkshryBpsmpqkKRAp0Bd7DF8zcSq/ZndfHMK9sQ42NANSpS2r7M
	 qJjWpi0ceIBpOu6HKY2uqHlZdsiyGoYOX5IFl/tLx1JT2udDtgWUE7m+kzfdI47iniJVh
	 JGyDnUwzg+I9YGOlfRgDH5PaWiRJ54NBd1KHsTAuyFsT9S1FzKHfynHHEXDz15XqJgZJo
	 xq1KSckXcbj/E2F5yVgL+bDLrdhOls3/D7NpATTi5aj9CP8k1loSkG2jRpNS75gQ1/g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=LWal6KQw;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0178E607493E;
	Wed,  4 Nov 2026 21:55:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=LWal6KQw
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 96AAB1F00919;
	Wed,  4 Nov 2026 21:55:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793829356;
	bh=wiJ7TAV6+6DMin7BeNzVECOhkqFEsEIPIXAIhycS9K4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=LWal6KQwBodnM76A5xWi5guKXfv1Ne3jV68TOgzCuKpsxSISOihj/8Sy7py4xtCL9
	 q5e37rfmijKeVVHXV8WEcpkacMjdj8hWhvNapvxBusIO5lhAt1unFnjAtYqkSeSehT
	 j072VaNJDMQhpNhHgQ2QOutOnVzrE0pLTJ5INe44=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xiang Liu <xiang.liu@amd.com>,
	Hawking Zhang <Hawking.Zhang@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0075/1005] drm/amd/pm: Guard VBIOS AC timing table walk
Date: Wed,  4 Nov 2026 15:56:48 -0500
Message-ID: <20261104211045.715198116@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261104211043.516122098@linuxfoundation.org>
References: <20261104211043.516122098@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index 1fff7567bca27..4b796d60b03d4 100644
--- a/drivers/gpu/drm/amd/pm/powerplay/hwmgr/ppatomctrl.c
+++ b/drivers/gpu/drm/amd/pm/powerplay/hwmgr/ppatomctrl.c
@@ -46,16 +46,22 @@ union voltage_object_info {
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
 
@@ -67,6 +73,10 @@ static int atomctrl_retrieve_ac_timing(
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
@@ -81,11 +91,13 @@ static int atomctrl_retrieve_ac_timing(
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
@@ -136,6 +148,7 @@ int atomctrl_initialize_mc_reg_table(
 {
 	ATOM_VRAM_INFO_HEADER_V2_1 *vram_info;
 	ATOM_INIT_REG_BLOCK *reg_block;
+	u8 *table_end;
 	int result = 0;
 	u8 frev, crev;
 	u16 size;
@@ -157,6 +170,7 @@ int atomctrl_initialize_mc_reg_table(
 	}
 
 	if (0 == result) {
+		table_end = (uint8_t *)vram_info + size;
 		reg_block = (ATOM_INIT_REG_BLOCK *)
 			((uint8_t *)vram_info + le16_to_cpu(vram_info->usMemClkPatchTblOffset));
 		result = atomctrl_set_mc_reg_address_table(reg_block, table);
@@ -164,7 +178,7 @@ int atomctrl_initialize_mc_reg_table(
 
 	if (0 == result) {
 		result = atomctrl_retrieve_ac_timing(module_index,
-					reg_block, table);
+					reg_block, table_end, table);
 	}
 
 	return result;
@@ -177,6 +191,7 @@ int atomctrl_initialize_mc_reg_table_v2_2(
 {
 	ATOM_VRAM_INFO_HEADER_V2_2 *vram_info;
 	ATOM_INIT_REG_BLOCK *reg_block;
+	u8 *table_end;
 	int result = 0;
 	u8 frev, crev;
 	u16 size;
@@ -198,6 +213,7 @@ int atomctrl_initialize_mc_reg_table_v2_2(
 	}
 
 	if (0 == result) {
+		table_end = (uint8_t *)vram_info + size;
 		reg_block = (ATOM_INIT_REG_BLOCK *)
 			((uint8_t *)vram_info + le16_to_cpu(vram_info->usMemClkPatchTblOffset));
 		result = atomctrl_set_mc_reg_address_table(reg_block, table);
@@ -205,7 +221,7 @@ int atomctrl_initialize_mc_reg_table_v2_2(
 
 	if (0 == result) {
 		result = atomctrl_retrieve_ac_timing(module_index,
-					reg_block, table);
+					reg_block, table_end, table);
 	}
 
 	return result;
-- 
2.53.0



