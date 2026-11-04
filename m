Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793829355;
	b=iF76FtvDRjZCg8FjXrr3BnflZTsWnkXi23R+aDUN9ck88VI7WWlYLEGXpIAlXeMn7gL6
	 iUp1NsoTybEl4jlmwSbz4g/N8PKBCPuLezEJOrMhTZE70L21Wq2X8v4Ic7SXrcCVfV8gC
	 y93RduAjrToQLMwJB2iQu4q0vEbWsE1hZo1H8gPPd28JxOC7wk3kuFB7WwDJo/gb74v1i
	 iyrMuUFF1DcPWwPH7exGv5eT42wQzpwU1T0lLdBJjhblO4Ff9Ysf9uDUXMKGiGDXzvajq
	 jt4A2Y8TdxGYRTh6Q949oOjT4iVAh4gHthx3IuEwIi2jzpNbVkeo66f7jnuPxiPDPsQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793829355;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=znQjV0yBP8xvH7sLjS2KT3w+RTjxLOy95908JTF1lMs=;
	b=rsAtdc2hbVaoUUX0NH4ebioctX16Z9Oxo2itEoqFWTp/Lq0Vc0dlvUBWPpirSZFclSFk
	 cUkqLjR7fEnyALr5CikmlP5ML5sBdyopZRxb13pum7T9Ump6QRYfxc8sJxLVrX9q7FPGB
	 vKTO584LxP1+yYcG6/lr2W4/TwH5foPZMeWBOCbI2CeK/giuNhtvlgALDOTq4LPOxW2ec
	 2t+kWEm4njZCxEgYyXvEK02/N3lYBpEAJrFXjif0lARt+z0Cd6Mz1gIWdZM7gKVPufmYb
	 +FUIQBxyfGe20gBz1vzqxdfG0FEzHXnQN8jkvxMnMdspAIwHmMpfgzNkClgXWIY+s4Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=bVQrvEM+;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 92DB160A5BD2;
	Wed,  4 Nov 2026 21:55:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=bVQrvEM+
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 321D91F00919;
	Wed,  4 Nov 2026 21:55:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793829355;
	bh=znQjV0yBP8xvH7sLjS2KT3w+RTjxLOy95908JTF1lMs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=bVQrvEM+/B420+S8bnTK8aWnVKWPIg2VLO549g116Fo6OuhAAb5LcKxFEe4ExEez0
	 ZfkLgDEGBMWfyvjMwVtqqH0JtxO3+oMxj5HVHU+rHxtNA70ZInDJ4dDMBzdOi6HuGq
	 GC99QM4QjpJCCqiXo5cX5IWur+WSYCSLUnyu0kio=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yang Wang <kevinyang.wang@amd.com>,
	Hawking Zhang <Hawking.Zhang@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0074/1005] drm/amd/pm: Validate Tonga PowerPlay state array bounds
Date: Wed,  4 Nov 2026 15:56:47 -0500
Message-ID: <20261104211045.687064156@linuxfoundation.org>
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

From: Yang Wang <kevinyang.wang@amd.com>

[ Upstream commit 1ac24df78c566d767a5ef05a1fe0ecc55bac248d ]

process_pptables_v1_0.c builds the Tonga state array pointer
from usStateArrayOffset before checking that the table buffer covers
the referenced data. A truncated PowerPlay table can therefore lead to
out-of-bounds reads while validating the state array.

Validate the fixed table size first, then check the state array offset
and entry range before dereferencing the state array.

Signed-off-by: Yang Wang <kevinyang.wang@amd.com>
Reviewed-by: Hawking Zhang <Hawking.Zhang@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../powerplay/hwmgr/process_pptables_v1_0.c   | 62 ++++++++++++-------
 1 file changed, 40 insertions(+), 22 deletions(-)

diff --git a/drivers/gpu/drm/amd/pm/powerplay/hwmgr/process_pptables_v1_0.c b/drivers/gpu/drm/amd/pm/powerplay/hwmgr/process_pptables_v1_0.c
index 6cfef1b295abb..94c1e2c103703 100644
--- a/drivers/gpu/drm/amd/pm/powerplay/hwmgr/process_pptables_v1_0.c
+++ b/drivers/gpu/drm/amd/pm/powerplay/hwmgr/process_pptables_v1_0.c
@@ -1113,15 +1113,17 @@ static int init_thermal_controller(
  * @powerplay_table: Pointer to the PowerPlay Table.
  * Exception:  2 if the powerplay table is incorrect.
  */
-static int check_powerplay_tables(
-		struct pp_hwmgr *hwmgr,
-		const ATOM_Tonga_POWERPLAYTABLE *powerplay_table
-		)
+static int get_tonga_state_array(struct pp_hwmgr *hwmgr,
+	const ATOM_Tonga_POWERPLAYTABLE *powerplay_table,
+	const ATOM_Tonga_State_Array **state_array)
 {
 	const ATOM_Tonga_State_Array *state_arrays;
+	u16 state_array_offset;
+	size_t state_array_size;
+	size_t table_size = hwmgr->soft_pp_table_size;
 
-	state_arrays = (ATOM_Tonga_State_Array *)(((unsigned long)powerplay_table) +
-		le16_to_cpu(powerplay_table->usStateArrayOffset));
+	PP_ASSERT_WITH_CODE((table_size >= sizeof(*powerplay_table)),
+			    "Invalid PowerPlay Table!", return -1);
 
 	PP_ASSERT_WITH_CODE((ATOM_Tonga_TABLE_REVISION_TONGA <=
 		powerplay_table->sHeader.ucTableFormatRevision),
@@ -1130,12 +1132,34 @@ static int check_powerplay_tables(
 		"State table is not set!", return -1);
 	PP_ASSERT_WITH_CODE((0 < powerplay_table->sHeader.usStructureSize),
 		"Invalid PowerPlay Table!", return -1);
+
+	state_array_offset = le16_to_cpu(powerplay_table->usStateArrayOffset);
+	PP_ASSERT_WITH_CODE((state_array_offset <=
+			     table_size - sizeof(*state_arrays)),
+			    "Invalid PowerPlay Table!", return -1);
+
+	state_arrays = (ATOM_Tonga_State_Array *)(((unsigned long)powerplay_table) +
+		state_array_offset);
 	PP_ASSERT_WITH_CODE((0 < state_arrays->ucNumEntries),
 		"Invalid PowerPlay Table!", return -1);
 
+	state_array_size = struct_size(state_arrays, entries, state_arrays->ucNumEntries);
+	PP_ASSERT_WITH_CODE((state_array_size <= table_size - state_array_offset),
+			    "Invalid PowerPlay Table!", return -1);
+
+	*state_array = state_arrays;
+
 	return 0;
 }
 
+static int check_powerplay_tables(struct pp_hwmgr *hwmgr,
+	const ATOM_Tonga_POWERPLAYTABLE *powerplay_table)
+{
+	const ATOM_Tonga_State_Array *state_arrays;
+
+	return get_tonga_state_array(hwmgr, powerplay_table, &state_arrays);
+}
+
 static int pp_tables_v1_0_initialize(struct pp_hwmgr *hwmgr)
 {
 	int result = 0;
@@ -1239,17 +1263,16 @@ const struct pp_table_func pptable_v1_0_funcs = {
 
 int get_number_of_powerplay_table_entries_v1_0(struct pp_hwmgr *hwmgr)
 {
-	ATOM_Tonga_State_Array const *state_arrays;
+	const ATOM_Tonga_State_Array *state_arrays;
 	const ATOM_Tonga_POWERPLAYTABLE *pp_table = get_powerplay_table(hwmgr);
+	int result;
 
 	PP_ASSERT_WITH_CODE((NULL != pp_table),
 			"Missing PowerPlay Table!", return -1);
-	PP_ASSERT_WITH_CODE((pp_table->sHeader.ucTableFormatRevision >=
-			ATOM_Tonga_TABLE_REVISION_TONGA),
-			"Incorrect PowerPlay table revision!", return -1);
 
-	state_arrays = (ATOM_Tonga_State_Array *)(((unsigned long)pp_table) +
-			le16_to_cpu(pp_table->usStateArrayOffset));
+	result = get_tonga_state_array(hwmgr, pp_table, &state_arrays);
+	PP_ASSERT_WITH_CODE((result == 0),
+			    "Invalid PowerPlay Table State Array.", return result);
 
 	return (uint32_t)(state_arrays->ucNumEntries);
 }
@@ -1380,15 +1403,11 @@ int get_powerplay_table_entry_v1_0(struct pp_hwmgr *hwmgr,
 
 	if (pp_table->sHeader.ucTableFormatRevision >=
 			ATOM_Tonga_TABLE_REVISION_TONGA) {
-		state_arrays = (ATOM_Tonga_State_Array *)(((unsigned long)pp_table) +
-				le16_to_cpu(pp_table->usStateArrayOffset));
-
-		PP_ASSERT_WITH_CODE((0 < pp_table->usStateArrayOffset),
-				"Invalid PowerPlay Table State Array Offset.", return -1);
-		PP_ASSERT_WITH_CODE((0 < state_arrays->ucNumEntries),
-				"Invalid PowerPlay Table State Array.", return -1);
-		PP_ASSERT_WITH_CODE((entry_index <= state_arrays->ucNumEntries),
-				"Invalid PowerPlay Table State Array Entry.", return -1);
+		result = get_tonga_state_array(hwmgr, pp_table, &state_arrays);
+		PP_ASSERT_WITH_CODE((result == 0),
+				    "Invalid PowerPlay Table State Array.", return result);
+		PP_ASSERT_WITH_CODE((entry_index < state_arrays->ucNumEntries),
+				    "Invalid PowerPlay Table State Array Entry.", return -1);
 
 		state_entry = GET_FLEXIBLE_ARRAY_MEMBER_ADDR(
 						ATOM_Tonga_State, entries,
@@ -1414,4 +1433,3 @@ int get_powerplay_table_entry_v1_0(struct pp_hwmgr *hwmgr,
 
 	return result;
 }
-
-- 
2.53.0



