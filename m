Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795042961;
	b=qRj/2RiDH1rrQe4faXtupx0hQD1hmO1aRYDD19LWvlrdtOoeMNrnxx/v1CUU1qanF0r0
	 C5oev3shSWcA39t9FOAPgOnEBHDpa66eOeKZI8e6n3WKvacF9djaElwdf79pKUn77pQKB
	 0qnPtUVcFHA4obgX+rwu8p6edQliBKQcPJRNzObgZKnAafEfvnqfWhPp6xaGMnh59Du+N
	 QVUK4qdv3uT/D/Lcf3bYw9KUhyDGnMqI3S0N9UKKXrwvr7AINbxv+gke8ZCbP19csQvgd
	 QDkICMrFA8mOOyTo+mZwn+erVRm3HZD7VupCSETfDWcRU0Uo1/oExOZkm2DVJd/QBeQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795042961;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=PZcdddmxKiYhXeEOU4FqGBWAd1VBYdfwpn7hMuGIysA=;
	b=xL+jzgjDYceUDlG2VuNHmPPVNlV7alErrD+U8vIasS1ZATx6EdrJXbGb06hiNGuCXNL5
	 0yOpCFcHCJuv8/EEmX0G1yLywdiAvAyAt8tyDsUchOCS0kzxnh35BjPIREZqQv2XG9lzc
	 JzrLi5fX3VS+5gPZ/bubKnoX6LX09EWw8U5GRVKh0kwjdWEtYovcvXdPgXwbw73nRgTq0
	 KbSaHhjuH3OZ6UmbHRHTbrbQNQgSv0nYf4sfIGAS/ASUhqIcn8MeCfa2SRCMiF09UNUmA
	 pW2EIBzHqKl6TrCSOLM+BkMbZPC/cwmWQJ8IlOo76GaLprXHix4qJxnD1Hwq5AEiIOA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=MP9RpHrj;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9489F606A31C;
	Wed, 18 Nov 2026 23:02:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=MP9RpHrj
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9DD561F000C4;
	Wed, 18 Nov 2026 23:02:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795042961;
	bh=PZcdddmxKiYhXeEOU4FqGBWAd1VBYdfwpn7hMuGIysA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=MP9RpHrjqg/qrXCkvO8rw/jDqBy4Um6Vs1SLA/pNUJBMRS7vx4TG4c/X+2bGXjvo7
	 9bn9rFpg7f3enhC1AYSL9Vp7H6HhcrJLTGUF+GavXOOMQ6XjFXcF0SHRnA6NOBCWx7
	 Uh7+X4HHKEoChV3ncTIdO9qBEGpnGPbnKAjBFKzo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yang Wang <kevinyang.wang@amd.com>,
	Hawking Zhang <Hawking.Zhang@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0041/2857] drm/amd/pm: Validate Tonga PowerPlay state array bounds
Date: Wed, 18 Nov 2026 15:17:55 +0100
Message-ID: <20261118150202.814786684@linuxfoundation.org>
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
index 17882f8dfdd34..14bc6beb91b33 100644
--- a/drivers/gpu/drm/amd/pm/powerplay/hwmgr/process_pptables_v1_0.c
+++ b/drivers/gpu/drm/amd/pm/powerplay/hwmgr/process_pptables_v1_0.c
@@ -1115,15 +1115,17 @@ static int init_thermal_controller(
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
@@ -1132,12 +1134,34 @@ static int check_powerplay_tables(
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
@@ -1241,17 +1265,16 @@ const struct pp_table_func pptable_v1_0_funcs = {
 
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
@@ -1382,15 +1405,11 @@ int get_powerplay_table_entry_v1_0(struct pp_hwmgr *hwmgr,
 
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
@@ -1416,4 +1435,3 @@ int get_powerplay_table_entry_v1_0(struct pp_hwmgr *hwmgr,
 
 	return result;
 }
-
-- 
2.53.0



