Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795057193;
	b=in5nxXEEL9xvZSvaYZa1RCFk6PydQt1eIckHQm4YHbngaYosFX0rhpjdphlWWlXqx8Ss
	 0Djaqet87uLcRdu1HwgSLMcizVj/zO4ixeQUdUWmnJrEE6mjYkIdJ5WrxbnaPFlel9QCn
	 ZKTGDLdoNXSIg7qYD+viynV/seRWosGMAe6qqr12ESuIE+wZTCX0Nd6evfjgEHDv2rgW6
	 rzsjcFhe7bt7idS3UcQX07gkLWsMCBTs/hT/OhUmjJ07u1duRnQgAZBhSIuOhQ7hR6+Px
	 f97WwabvdHOYA0+pL+7PNFKKMUUtYh/G+JMXz0aPkPAjsZbo/xYnSMuwez1okPE80Dg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795057193;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=p6x39D1rsxdDxTmlfLqWjkhb7x/BF7cq3Pygq3eT2zY=;
	b=CTW0YI5EnGn1vIgzeYKC0mWfL2z4XRt05eNQPK7Nztd65xRF1+ujep1ExdT7ZFpYk7BQ
	 hiMjlg2vuVM3xjCKo8pd6qWkr7iY5twqz335a0C26zMPAXm0+6NYLBTpTv86qW7Xcr0r5
	 RctLpbZVasDZtgHRt0GUxwrDEpuU+fei91bMzsk0usX+d65h/rrbq8Y60oj/r5ma3uM6E
	 BgipAw0m4YLLMWGhfjQQpLkCOcjA+tUV8MrA/Q4UcvbD32EP72rYeOhha8mAJSggFH79U
	 QsZhwiwHdzu79L1kwVwzRagcNhxZje7mFUGmaqj+zMO7GEjIe3cQmcbntubVnikKQ5g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=PLaZEGd+;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9DF65606A334;
	Thu, 19 Nov 2026 02:59:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=PLaZEGd+
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DD90B1F000CA;
	Thu, 19 Nov 2026 02:59:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795057193;
	bh=p6x39D1rsxdDxTmlfLqWjkhb7x/BF7cq3Pygq3eT2zY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=PLaZEGd+DEqQYEcokMzY9yYqfsPwkhm7UdhUX8SUdusDgt0yFUJS4FF/nhjElUbu0
	 cBxPF4D8rgm1fC9KgmqKw3hOpL2Tx1Cv/mBxzQIXHGHCAT0/b/bUiA79g89mYj6a4l
	 eQ2utzFESlIJBK5FLcy0ni00lT+FsXiXO2vQzkZs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yang Wang <kevinyang.wang@amd.com>,
	Hawking Zhang <Hawking.Zhang@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 0043/1848] drm/amd/pm: Validate Tonga PowerPlay state array bounds
Date: Wed, 18 Nov 2026 15:34:41 +0100
Message-ID: <20261118145912.921288714@linuxfoundation.org>
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
index 5998c78ad536c..4e6965ff1b869 100644
--- a/drivers/gpu/drm/amd/pm/powerplay/hwmgr/process_pptables_v1_0.c
+++ b/drivers/gpu/drm/amd/pm/powerplay/hwmgr/process_pptables_v1_0.c
@@ -1034,15 +1034,17 @@ static int init_thermal_controller(
  * @param powerplay_table Pointer to the PowerPlay Table.
  * @exception 2 if the powerplay table is incorrect.
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
@@ -1051,12 +1053,34 @@ static int check_powerplay_tables(
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
@@ -1160,17 +1184,16 @@ const struct pp_table_func pptable_v1_0_funcs = {
 
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
@@ -1300,15 +1323,11 @@ int get_powerplay_table_entry_v1_0(struct pp_hwmgr *hwmgr,
 
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
@@ -1334,4 +1353,3 @@ int get_powerplay_table_entry_v1_0(struct pp_hwmgr *hwmgr,
 
 	return result;
 }
-
-- 
2.53.0



