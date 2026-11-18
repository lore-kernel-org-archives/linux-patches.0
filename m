Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795033533;
	b=diiT2MnSOPQWZIO5UO3Vg4MxJptba2kxw3uS7wmPpgwc7ZyNfIcdtA2h5epjNfhPDJA+
	 0IgkLveIB/hKqTCebpNl4YfZ/LMLyKI2LKFsL8cfOMZYYYuEcHekv5TdFwo/i4TY938bW
	 M4QhgJN4SeAt1Dbso+vVinOcUL0fbY4rfMaH7xGU04yoekwJbKK0D/ffBKrbqXn5icNWv
	 GSMP0DcxpCc6sQ2y7RhJPqzij+2GlOeZi1GM+3n5JJpmrU18EFUlGWHJuVqBgMJZdlxXp
	 uQc8hHJcGwGJ93MptOrwuuZ8/nBUDpiK1/XFU5pCDpUb4lpZynrZiA/re7YZbuDzAPQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795033533;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=E14VjT5Q6qymQIyOUMmKO2s0DGegV+7NXQX64uIpQ1w=;
	b=R2fimc3BY/oeFgkG2kZpSl61GetypZg9S1c62ULGicL6sHMOPzEwzKqkOway+dUbPgtY
	 y3V6dPlbxtmn1xVe+D58lIyd7mih6xD5iU1QEVaafTZb0i3cOmU9GAan31txXyFott/gg
	 IcpcQYc+7FI35zwkMixkp/TSRub8c5mYTZUGGi7SY4YKqgRFQoMFAxjFCiCG9BuYcQqyk
	 VKEwsnmKhcJQEkpDEMKxzdEnghj0NeD9AjaWKSDYRIb50SExZe2+ZFlQ3Ba7lddQv4yw4
	 uJ04BPNF4IAc2rCIRCCMUSTXfdoyvmNvmtSjqwT7lgIUt5bbI5W4W5BnTF1MlkGmqcQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Z9Pb+RlT;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 37E15606A31C;
	Wed, 18 Nov 2026 20:25:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Z9Pb+RlT
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8AD021F000C4;
	Wed, 18 Nov 2026 20:25:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795033533;
	bh=E14VjT5Q6qymQIyOUMmKO2s0DGegV+7NXQX64uIpQ1w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Z9Pb+RlTtGY9MyNJg841Iflm+HSt1EHroT7pBhnBCyGIy7DorBu3G39DbjZM6ve0q
	 HsCJw/A4Z28gBjtRNLkjI4AES8a5sB6HqXdLnOrBuEThkxvX1JUce5O3UUeLrndfAB
	 elF3mn1tIqVWNTHtrQ5HvFk0qDv5gFaK6G90ytUY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yang Wang <kevinyang.wang@amd.com>,
	Hawking Zhang <Hawking.Zhang@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0048/3318] drm/amd/pm: Validate Vega hwmgr PowerPlay table bounds
Date: Wed, 18 Nov 2026 15:11:10 +0100
Message-ID: <20261118150315.342321074@linuxfoundation.org>
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
index 3be616af327ef..64cff9f4850a6 100644
--- a/drivers/gpu/drm/amd/pm/powerplay/hwmgr/vega10_processpptables.c
+++ b/drivers/gpu/drm/amd/pm/powerplay/hwmgr/vega10_processpptables.c
@@ -63,14 +63,17 @@ static const void *get_powerplay_table(struct pp_hwmgr *hwmgr)
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
@@ -79,12 +82,34 @@ static int check_powerplay_tables(
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
@@ -1249,15 +1274,14 @@ int vega10_get_number_of_powerplay_table_entries(struct pp_hwmgr *hwmgr)
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
@@ -1308,17 +1332,11 @@ int vega10_get_powerplay_table_entry(struct pp_hwmgr *hwmgr,
 
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
 
@@ -1360,4 +1378,3 @@ int vega10_baco_set_cap(struct pp_hwmgr *hwmgr)
 			PHM_PlatformCaps_BACO);
 	return result;
 }
-
diff --git a/drivers/gpu/drm/amd/pm/powerplay/hwmgr/vega12_processpptables.c b/drivers/gpu/drm/amd/pm/powerplay/hwmgr/vega12_processpptables.c
index 89148f73b514a..8e6b1565d00de 100644
--- a/drivers/gpu/drm/amd/pm/powerplay/hwmgr/vega12_processpptables.c
+++ b/drivers/gpu/drm/amd/pm/powerplay/hwmgr/vega12_processpptables.c
@@ -64,6 +64,13 @@ static int check_powerplay_tables(
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
index 79c817752a331..8fb19fe014ae5 100644
--- a/drivers/gpu/drm/amd/pm/powerplay/hwmgr/vega20_processpptables.c
+++ b/drivers/gpu/drm/amd/pm/powerplay/hwmgr/vega20_processpptables.c
@@ -638,6 +638,13 @@ static int check_powerplay_tables(
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



