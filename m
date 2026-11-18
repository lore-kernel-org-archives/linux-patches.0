Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795042953;
	b=cSF0H/U34C7k7GrHwvTIzZ7TWQZMgQVvSs+NmhE4czj8pNGHYKBpJiHVPcPtTDIfH5/D
	 ch0Ydkbb5R2T5rZRg0Poe1PWpA8jQen0/UqMF888l1OPz4DdIYBU/b1Y3Gg5nEulIEaF6
	 V6oaa5LGdFUyyHuYIAwust80EwTn91q5TgvAVfWWAGAMkV17SHCD0QgU4w6DTQWf9sBr/
	 1e22rgqrgJGr2DNpVidz3bTLZGoyozmzKtFE32uG0k6MOrJDr0qp3dcWP+sYUZuQ4Zp+0
	 oc93vcR88Az/0S1xg+v/QZPQfz7K1IN6o/BtPRaxdSMArwIRYhx5lTePuAA4fkPs8qw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795042953;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=JyHzLmIQB3pgh1U1YNyzeF0tJcfkh/PRVx/mQmVYaxk=;
	b=3bKq8CEomDZYLY9KE3AKvoF6O6z9fkH8T7O9MIRiBdYXI6aB54iyDcGoOzWfUbcLE8By
	 16wZz1717V2e1GcDsyjSmPaEREgf4L29tCN7sGGstFlajj2xYvOFUwJapoUBZzHcgclhJ
	 BJQsPC2vdaZw2I6LwiInGJ4s9U6u5EuubnNtUDbZqGha61eldx7ZPUD5JSMC/+y9mEAKz
	 RFbxulBQ4ELUebg5htvoz7pxH3S44UMHqA3vwIF2ni9HPPNSFvn5ZvNKSwyzQU7XCBHvR
	 BdfULPMjRwimuf9vEVL1bwwm/or5FWm5Gdcu54bugz7eJHCaLOsY3V3e496iX0cTNvQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=VFm4WC1Q;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 352F3606A320;
	Wed, 18 Nov 2026 23:02:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=VFm4WC1Q
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3D1321F000C4;
	Wed, 18 Nov 2026 23:02:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795042952;
	bh=JyHzLmIQB3pgh1U1YNyzeF0tJcfkh/PRVx/mQmVYaxk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=VFm4WC1Qla0IZCWQsak37XjmQpkJtfZtHW3YSV31bq6jaGBKMRyfM4n45nxNRfKse
	 3CoCQfpCgl1AXaGt7TKwfDTng9dVFAhaFfrxSIrC/EM/8bItF2Po+OiULuhTGbvcQe
	 Jb4ApWctWfWYq2Y+WAeQ+URxI4h2a6P+iF6uqL54=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yang Wang <kevinyang.wang@amd.com>,
	Hawking Zhang <Hawking.Zhang@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0038/2857] drm/amd/pm: Validate Vega hwmgr PowerPlay table bounds
Date: Wed, 18 Nov 2026 15:17:52 +0100
Message-ID: <20261118150202.706538258@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yang Wang <kevinyang.wang@amd.com>

[ Upstream commit 3a8d8e0b7f61cd759d5d4870b6220161f8a5b114 ]

The Vega hwmgr PowerPlay table parsers read fixed table fields,
state array entries, or SMC PPT fields before validating that the
VBIOS table buffer covers those structures. A truncated table can
therefore lead to out-of-bounds reads during hwmgr initialization.

Reject tables smaller than the fixed PowerPlay table. For Vega10, also
validate the state array offset and entry range before dereferencing
the state array.

Signed-off-by: Yang Wang <kevinyang.wang@amd.com>
Reviewed-by: Hawking Zhang <Hawking.Zhang@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../powerplay/hwmgr/vega10_processpptables.c  | 59 ++++++++++++-------
 .../powerplay/hwmgr/vega12_processpptables.c  |  7 +++
 .../powerplay/hwmgr/vega20_processpptables.c  |  7 +++
 3 files changed, 52 insertions(+), 21 deletions(-)

diff --git a/drivers/gpu/drm/amd/pm/powerplay/hwmgr/vega10_processpptables.c b/drivers/gpu/drm/amd/pm/powerplay/hwmgr/vega10_processpptables.c
index 95b988823f50f..bc75f09112cda 100644
--- a/drivers/gpu/drm/amd/pm/powerplay/hwmgr/vega10_processpptables.c
+++ b/drivers/gpu/drm/amd/pm/powerplay/hwmgr/vega10_processpptables.c
@@ -64,14 +64,17 @@ static const void *get_powerplay_table(struct pp_hwmgr *hwmgr)
 	return table_address;
 }
 
-static int check_powerplay_tables(
-		struct pp_hwmgr *hwmgr,
-		const ATOM_Vega10_POWERPLAYTABLE *powerplay_table)
+static int get_vega10_state_array(struct pp_hwmgr *hwmgr,
+	const ATOM_Vega10_POWERPLAYTABLE *powerplay_table,
+	const ATOM_Vega10_State_Array **state_array)
 {
 	const ATOM_Vega10_State_Array *state_arrays;
+	u16 state_array_offset;
+	size_t state_array_size;
+	size_t table_size = hwmgr->soft_pp_table_size;
 
-	state_arrays = (ATOM_Vega10_State_Array *)(((unsigned long)powerplay_table) +
-		le16_to_cpu(powerplay_table->usStateArrayOffset));
+	PP_ASSERT_WITH_CODE((table_size >= sizeof(*powerplay_table)),
+			    "Invalid PowerPlay Table!", return -1);
 
 	PP_ASSERT_WITH_CODE((powerplay_table->sHeader.format_revision >=
 			ATOM_Vega10_TABLE_REVISION_VEGA10),
@@ -80,12 +83,34 @@ static int check_powerplay_tables(
 		"State table is not set!", return -1);
 	PP_ASSERT_WITH_CODE(powerplay_table->sHeader.structuresize > 0,
 		"Invalid PowerPlay Table!", return -1);
+
+	state_array_offset = le16_to_cpu(powerplay_table->usStateArrayOffset);
+	PP_ASSERT_WITH_CODE((state_array_offset <=
+			     table_size - sizeof(*state_arrays)),
+			    "Invalid PowerPlay Table!", return -1);
+
+	state_arrays = (ATOM_Vega10_State_Array *)(((unsigned long)powerplay_table) +
+		state_array_offset);
 	PP_ASSERT_WITH_CODE(state_arrays->ucNumEntries > 0,
 		"Invalid PowerPlay Table!", return -1);
 
+	state_array_size = struct_size(state_arrays, states, state_arrays->ucNumEntries);
+	PP_ASSERT_WITH_CODE((state_array_size <= table_size - state_array_offset),
+			    "Invalid PowerPlay Table!", return -1);
+
+	*state_array = state_arrays;
+
 	return 0;
 }
 
+static int check_powerplay_tables(struct pp_hwmgr *hwmgr,
+	const ATOM_Vega10_POWERPLAYTABLE *powerplay_table)
+{
+	const ATOM_Vega10_State_Array *state_arrays;
+
+	return get_vega10_state_array(hwmgr, powerplay_table, &state_arrays);
+}
+
 static int set_platform_caps(struct pp_hwmgr *hwmgr, uint32_t powerplay_caps)
 {
 	set_hw_cap(
@@ -1250,15 +1275,14 @@ int vega10_get_number_of_powerplay_table_entries(struct pp_hwmgr *hwmgr)
 {
 	const ATOM_Vega10_State_Array *state_arrays;
 	const ATOM_Vega10_POWERPLAYTABLE *pp_table = get_powerplay_table(hwmgr);
+	int result;
 
 	PP_ASSERT_WITH_CODE((pp_table != NULL),
 			"Missing PowerPlay Table!", return -1);
-	PP_ASSERT_WITH_CODE((pp_table->sHeader.format_revision >=
-			ATOM_Vega10_TABLE_REVISION_VEGA10),
-			"Incorrect PowerPlay table revision!", return -1);
 
-	state_arrays = (ATOM_Vega10_State_Array *)(((unsigned long)pp_table) +
-			le16_to_cpu(pp_table->usStateArrayOffset));
+	result = get_vega10_state_array(hwmgr, pp_table, &state_arrays);
+	PP_ASSERT_WITH_CODE((result == 0),
+			    "Invalid PowerPlay Table State Array.", return result);
 
 	return (uint32_t)(state_arrays->ucNumEntries);
 }
@@ -1309,17 +1333,11 @@ int vega10_get_powerplay_table_entry(struct pp_hwmgr *hwmgr,
 
 	if (pp_table->sHeader.format_revision >=
 			ATOM_Vega10_TABLE_REVISION_VEGA10) {
-		state_arrays = (ATOM_Vega10_State_Array *)
-				(((unsigned long)pp_table) +
-				le16_to_cpu(pp_table->usStateArrayOffset));
-
-		PP_ASSERT_WITH_CODE(pp_table->usStateArrayOffset > 0,
-				"Invalid PowerPlay Table State Array Offset.",
-				return -1);
-		PP_ASSERT_WITH_CODE(state_arrays->ucNumEntries > 0,
+		result = get_vega10_state_array(hwmgr, pp_table, &state_arrays);
+		PP_ASSERT_WITH_CODE((result == 0),
 				"Invalid PowerPlay Table State Array.",
-				return -1);
-		PP_ASSERT_WITH_CODE((entry_index <= state_arrays->ucNumEntries),
+				return result);
+		PP_ASSERT_WITH_CODE((entry_index < state_arrays->ucNumEntries),
 				"Invalid PowerPlay Table State Array Entry.",
 				return -1);
 
@@ -1361,4 +1379,3 @@ int vega10_baco_set_cap(struct pp_hwmgr *hwmgr)
 			PHM_PlatformCaps_BACO);
 	return result;
 }
-
diff --git a/drivers/gpu/drm/amd/pm/powerplay/hwmgr/vega12_processpptables.c b/drivers/gpu/drm/amd/pm/powerplay/hwmgr/vega12_processpptables.c
index bd54fbd393b97..464ae9eed73a8 100644
--- a/drivers/gpu/drm/amd/pm/powerplay/hwmgr/vega12_processpptables.c
+++ b/drivers/gpu/drm/amd/pm/powerplay/hwmgr/vega12_processpptables.c
@@ -65,6 +65,13 @@ static int check_powerplay_tables(
 		struct pp_hwmgr *hwmgr,
 		const ATOM_Vega12_POWERPLAYTABLE *powerplay_table)
 {
+	size_t smc_pptable_size =
+		offsetofend(ATOM_Vega12_POWERPLAYTABLE, smcPPTable);
+	size_t table_size = hwmgr->soft_pp_table_size;
+
+	PP_ASSERT_WITH_CODE((table_size >= smc_pptable_size),
+			    "Invalid PowerPlay Table!", return -1);
+
 	PP_ASSERT_WITH_CODE((powerplay_table->sHeader.format_revision >=
 		ATOM_VEGA12_TABLE_REVISION_VEGA12),
 		"Unsupported PPTable format!", return -1);
diff --git a/drivers/gpu/drm/amd/pm/powerplay/hwmgr/vega20_processpptables.c b/drivers/gpu/drm/amd/pm/powerplay/hwmgr/vega20_processpptables.c
index 1f90825394575..20af10dda2e81 100644
--- a/drivers/gpu/drm/amd/pm/powerplay/hwmgr/vega20_processpptables.c
+++ b/drivers/gpu/drm/amd/pm/powerplay/hwmgr/vega20_processpptables.c
@@ -639,6 +639,13 @@ static int check_powerplay_tables(
 		struct pp_hwmgr *hwmgr,
 		const ATOM_Vega20_POWERPLAYTABLE *powerplay_table)
 {
+	size_t smc_pptable_size =
+		offsetofend(ATOM_Vega20_POWERPLAYTABLE, smcPPTable);
+	size_t table_size = hwmgr->soft_pp_table_size;
+
+	PP_ASSERT_WITH_CODE((table_size >= smc_pptable_size),
+			    "Invalid PowerPlay Table!", return -1);
+
 	PP_ASSERT_WITH_CODE((powerplay_table->sHeader.format_revision >=
 		ATOM_VEGA20_TABLE_REVISION_VEGA20),
 		"Unsupported PPTable format!", return -1);
-- 
2.53.0



