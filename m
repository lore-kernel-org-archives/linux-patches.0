Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793829362;
	b=5SEjaU/ppSfH2TfRr8EkoYTe7u1G8/uMW7kW3n6ZEFhhSFPfg48b+5QMi4GqMg25Qr3x
	 tgr+qGe+89Prv+2ta8jPX9tLiLgQfu6kED3s6dDnMmBfY92rt2VdijSojsPYEPuEhiXli
	 hkKCRvcQH4KdYTw0kXe0f8ar/hSenuZXZ1q8rLFIxx69jb+foSiNhA+BfND/6TgqA3Au/
	 MTsigqGX7OnIj9bptE1uvRlK9ldNAGh9dPK4L2ftNSujkBImsy6WbGjvaajFah75WiGbA
	 KIcbwf3tERqbHpoDHlSiOY8zbFSp05PLIYlUs5bsXhfOP2UvsbcMo7Hh8Xg2XWqlVsw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793829362;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Iw3B1WoUzc0DHsTxBY5u2n2qWQEjsLdA2GP5zXPSyfU=;
	b=NWlb/GFOOYhyvKvhu0XP2eHs9BJqqoYnbKmjI4j7DdD1YzBUGguQw3LsFFAHcgsWa8kj
	 mU+eW5Jq5h9Dlc2F49wNk7Sw1NhHIZZYNWHfNzDel9uAKGWEwft16VqNOwVdw3Z2nicnw
	 p6u/dYwq3+6xdp0Oirei1ihorudSZfp0WFJGoQZprF5Jc7+RUm+vMh2e48HO5O0HBtmHI
	 Zg9+Ge9QouCXQJbdEdF2/bsuv0kMy1W1BTC0GAZQEbsFSvXAC/aN2Upl4ThU0NvDG6sNG
	 pI7VON9rKKpQ7WXYmTwnf/LSq+OYaqvRdGVgJ4dXMIaKQyohQAMAwzWO2jcgnKBEdIg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=VJp9oZrI;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F73260BF2D5;
	Wed,  4 Nov 2026 21:56:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=VJp9oZrI
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6941C1F0093A;
	Wed,  4 Nov 2026 21:56:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793829362;
	bh=Iw3B1WoUzc0DHsTxBY5u2n2qWQEjsLdA2GP5zXPSyfU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=VJp9oZrIT0yP4zG0I+OgbMBeFj9NEZYgz2MvFTraOVi2XCmTTHARP9OmLynBb6/os
	 v3nw+TfDMGaUXFKsXMn64ulldcJ3MVDFAN7a9WGEl9y5zF/Ppff7D0XH2kzBOT2Z6q
	 SRx0Q8yOKcqGP57kaR0jMx50chm2PrhKiR/LlmMQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yang Wang <kevinyang.wang@amd.com>,
	Hawking Zhang <Hawking.Zhang@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0078/1005] drm/amd/pm: Validate legacy hwmgr PP table offsets
Date: Wed,  4 Nov 2026 15:56:51 -0500
Message-ID: <20261104211045.802581070@linuxfoundation.org>
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

[ Upstream commit 0ceb6bc43e62f0e73b282c9de8f4bc4d5498f281 ]

processpptables.c walks several variable-length PPLIB tables by
using offsets from the VBIOS PowerPlay table. Some paths dereference
extended headers, state arrays, clock arrays, non-clock arrays, or VCE
records before checking that the referenced data is inside the table
buffer.

Add local bounds helpers and validate the relevant offsets and entry
sizes before dereferencing them. This prevents truncated or malformed
legacy PowerPlay tables from driving out-of-bounds reads during hwmgr
initialization and table entry lookup.

Signed-off-by: Yang Wang <kevinyang.wang@amd.com>
Reviewed-by: Hawking Zhang <Hawking.Zhang@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../amd/pm/powerplay/hwmgr/processpptables.c  | 446 +++++++++++++-----
 1 file changed, 316 insertions(+), 130 deletions(-)

diff --git a/drivers/gpu/drm/amd/pm/powerplay/hwmgr/processpptables.c b/drivers/gpu/drm/amd/pm/powerplay/hwmgr/processpptables.c
index f06b29e33ba45..f1009b2973574 100644
--- a/drivers/gpu/drm/amd/pm/powerplay/hwmgr/processpptables.c
+++ b/drivers/gpu/drm/amd/pm/powerplay/hwmgr/processpptables.c
@@ -47,26 +47,53 @@
 
 #define NUM_BITS_CLOCK_INFO_ARRAY_INDEX 6
 
+static bool pp_table_has_space(struct pp_hwmgr *hwmgr, size_t offset,
+			       size_t size)
+{
+	size_t table_size = hwmgr->soft_pp_table_size;
+
+	return offset <= table_size && size <= table_size - offset;
+}
+
+static const ATOM_PPLIB_EXTENDEDHEADER *
+get_extended_header(struct pp_hwmgr *hwmgr,
+		    const ATOM_PPLIB_POWERPLAYTABLE *powerplay_table,
+		    size_t min_size)
+{
+	const ATOM_PPLIB_POWERPLAYTABLE3 *powerplay_table3;
+	const ATOM_PPLIB_EXTENDEDHEADER *extended_header;
+	u16 offset;
+
+	if (le16_to_cpu(powerplay_table->usTableSize) <
+	    sizeof(ATOM_PPLIB_POWERPLAYTABLE3) ||
+	    !pp_table_has_space(hwmgr, 0, sizeof(ATOM_PPLIB_POWERPLAYTABLE3)))
+		return NULL;
+
+	powerplay_table3 = (const ATOM_PPLIB_POWERPLAYTABLE3 *)powerplay_table;
+	offset = le16_to_cpu(powerplay_table3->usExtendendedHeaderOffset);
+	if (!offset || !pp_table_has_space(hwmgr, offset,
+					   sizeof(extended_header->usSize)))
+		return NULL;
+
+	extended_header = (const ATOM_PPLIB_EXTENDEDHEADER *)
+		(((unsigned long)powerplay_table) + offset);
+	if (le16_to_cpu(extended_header->usSize) < min_size ||
+	    !pp_table_has_space(hwmgr, offset, min_size))
+		return NULL;
+
+	return extended_header;
+}
+
 static uint16_t get_vce_table_offset(struct pp_hwmgr *hwmgr,
 			const ATOM_PPLIB_POWERPLAYTABLE *powerplay_table)
 {
 	uint16_t vce_table_offset = 0;
+	const ATOM_PPLIB_EXTENDEDHEADER *extended_header;
 
-	if (le16_to_cpu(powerplay_table->usTableSize) >=
-	   sizeof(ATOM_PPLIB_POWERPLAYTABLE3)) {
-		const ATOM_PPLIB_POWERPLAYTABLE3 *powerplay_table3 =
-			(const ATOM_PPLIB_POWERPLAYTABLE3 *)powerplay_table;
-
-		if (powerplay_table3->usExtendendedHeaderOffset > 0) {
-			const ATOM_PPLIB_EXTENDEDHEADER  *extended_header =
-						(const ATOM_PPLIB_EXTENDEDHEADER *)
-						(((unsigned long)powerplay_table3) +
-						le16_to_cpu(powerplay_table3->usExtendendedHeaderOffset));
-			if (le16_to_cpu(extended_header->usSize) >=
-			   SIZE_OF_ATOM_PPLIB_EXTENDEDHEADER_V2)
-				vce_table_offset = le16_to_cpu(extended_header->usVCETableOffset);
-		}
-	}
+	extended_header = get_extended_header(hwmgr, powerplay_table,
+					      SIZE_OF_ATOM_PPLIB_EXTENDEDHEADER_V2);
+	if (extended_header)
+		vce_table_offset = le16_to_cpu(extended_header->usVCETableOffset);
 
 	return vce_table_offset;
 }
@@ -93,7 +120,14 @@ static uint16_t get_vce_clock_info_array_size(struct pp_hwmgr *hwmgr,
 	if (table_offset > 0) {
 		const VCEClockInfoArray *p = (const VCEClockInfoArray *)
 			(((unsigned long) powerplay_table) + table_offset);
-		table_size = sizeof(uint8_t) + p->ucNumEntries * sizeof(VCEClockInfo);
+		size_t size;
+
+		if (!pp_table_has_space(hwmgr, table_offset, sizeof(p->ucNumEntries)))
+			return 0;
+
+		size = sizeof(uint8_t) + p->ucNumEntries * sizeof(VCEClockInfo);
+		if (pp_table_has_space(hwmgr, table_offset, size))
+			table_size = size;
 	}
 
 	return table_size;
@@ -104,10 +138,13 @@ static uint16_t get_vce_clock_voltage_limit_table_offset(struct pp_hwmgr *hwmgr,
 {
 	uint16_t table_offset = get_vce_clock_info_array_offset(hwmgr,
 							powerplay_table);
+	u16 table_size;
 
-	if (table_offset > 0)
-		return table_offset + get_vce_clock_info_array_size(hwmgr,
-							powerplay_table);
+	if (table_offset > 0) {
+		table_size = get_vce_clock_info_array_size(hwmgr, powerplay_table);
+		if (table_size)
+			return table_offset + table_size;
+	}
 
 	return 0;
 }
@@ -121,8 +158,15 @@ static uint16_t get_vce_clock_voltage_limit_table_size(struct pp_hwmgr *hwmgr,
 	if (table_offset > 0) {
 		const ATOM_PPLIB_VCE_Clock_Voltage_Limit_Table *ptable =
 			(const ATOM_PPLIB_VCE_Clock_Voltage_Limit_Table *)(((unsigned long) powerplay_table) + table_offset);
+		size_t size;
 
-		table_size = sizeof(uint8_t) + ptable->numEntries * sizeof(ATOM_PPLIB_VCE_Clock_Voltage_Limit_Record);
+		if (!pp_table_has_space(hwmgr, table_offset, sizeof(ptable->numEntries)))
+			return 0;
+
+		size = sizeof(uint8_t) +
+			ptable->numEntries * sizeof(ATOM_PPLIB_VCE_Clock_Voltage_Limit_Record);
+		if (pp_table_has_space(hwmgr, table_offset, size))
+			table_size = size;
 	}
 	return table_size;
 }
@@ -130,9 +174,13 @@ static uint16_t get_vce_clock_voltage_limit_table_size(struct pp_hwmgr *hwmgr,
 static uint16_t get_vce_state_table_offset(struct pp_hwmgr *hwmgr, const ATOM_PPLIB_POWERPLAYTABLE *powerplay_table)
 {
 	uint16_t table_offset = get_vce_clock_voltage_limit_table_offset(hwmgr, powerplay_table);
+	u16 table_size;
 
-	if (table_offset > 0)
-		return table_offset + get_vce_clock_voltage_limit_table_size(hwmgr, powerplay_table);
+	if (table_offset > 0) {
+		table_size = get_vce_clock_voltage_limit_table_size(hwmgr, powerplay_table);
+		if (table_size)
+			return table_offset + table_size;
+	}
 
 	return 0;
 }
@@ -143,8 +191,12 @@ static const ATOM_PPLIB_VCE_State_Table *get_vce_state_table(
 {
 	uint16_t table_offset = get_vce_state_table_offset(hwmgr, powerplay_table);
 
-	if (table_offset > 0)
-		return (const ATOM_PPLIB_VCE_State_Table *)(((unsigned long) powerplay_table) + table_offset);
+	if (table_offset > 0) {
+		if (pp_table_has_space(hwmgr, table_offset,
+				       sizeof(((ATOM_PPLIB_VCE_State_Table *)0)->numEntries)))
+			return (const ATOM_PPLIB_VCE_State_Table *)
+				(((unsigned long)powerplay_table) + table_offset);
+	}
 
 	return NULL;
 }
@@ -153,21 +205,13 @@ static uint16_t get_uvd_table_offset(struct pp_hwmgr *hwmgr,
 			const ATOM_PPLIB_POWERPLAYTABLE *powerplay_table)
 {
 	uint16_t uvd_table_offset = 0;
+	const ATOM_PPLIB_EXTENDEDHEADER *extended_header;
+
+	extended_header = get_extended_header(hwmgr, powerplay_table,
+					      SIZE_OF_ATOM_PPLIB_EXTENDEDHEADER_V3);
+	if (extended_header)
+		uvd_table_offset = le16_to_cpu(extended_header->usUVDTableOffset);
 
-	if (le16_to_cpu(powerplay_table->usTableSize) >=
-	    sizeof(ATOM_PPLIB_POWERPLAYTABLE3)) {
-		const ATOM_PPLIB_POWERPLAYTABLE3 *powerplay_table3 =
-			(const ATOM_PPLIB_POWERPLAYTABLE3 *)powerplay_table;
-		if (powerplay_table3->usExtendendedHeaderOffset > 0) {
-			const ATOM_PPLIB_EXTENDEDHEADER  *extended_header =
-					(const ATOM_PPLIB_EXTENDEDHEADER *)
-					(((unsigned long)powerplay_table3) +
-				le16_to_cpu(powerplay_table3->usExtendendedHeaderOffset));
-			if (le16_to_cpu(extended_header->usSize) >=
-			    SIZE_OF_ATOM_PPLIB_EXTENDEDHEADER_V3)
-				uvd_table_offset = le16_to_cpu(extended_header->usUVDTableOffset);
-		}
-	}
 	return uvd_table_offset;
 }
 
@@ -193,8 +237,14 @@ static uint16_t get_uvd_clock_info_array_size(struct pp_hwmgr *hwmgr,
 		const UVDClockInfoArray *p = (const UVDClockInfoArray *)
 					(((unsigned long) powerplay_table)
 					+ table_offset);
-		table_size = sizeof(UCHAR) +
-			     p->ucNumEntries * sizeof(UVDClockInfo);
+		size_t size;
+
+		if (!pp_table_has_space(hwmgr, table_offset, sizeof(p->ucNumEntries)))
+			return 0;
+
+		size = sizeof(UCHAR) + p->ucNumEntries * sizeof(UVDClockInfo);
+		if (pp_table_has_space(hwmgr, table_offset, size))
+			table_size = size;
 	}
 
 	return table_size;
@@ -206,10 +256,13 @@ static uint16_t get_uvd_clock_voltage_limit_table_offset(
 {
 	uint16_t table_offset = get_uvd_clock_info_array_offset(hwmgr,
 						     powerplay_table);
+	u16 table_size;
 
-	if (table_offset > 0)
-		return table_offset +
-			get_uvd_clock_info_array_size(hwmgr, powerplay_table);
+	if (table_offset > 0) {
+		table_size = get_uvd_clock_info_array_size(hwmgr, powerplay_table);
+		if (table_size)
+			return table_offset + table_size;
+	}
 
 	return 0;
 }
@@ -218,21 +271,12 @@ static uint16_t get_samu_table_offset(struct pp_hwmgr *hwmgr,
 			const ATOM_PPLIB_POWERPLAYTABLE *powerplay_table)
 {
 	uint16_t samu_table_offset = 0;
+	const ATOM_PPLIB_EXTENDEDHEADER *extended_header;
 
-	if (le16_to_cpu(powerplay_table->usTableSize) >=
-	    sizeof(ATOM_PPLIB_POWERPLAYTABLE3)) {
-		const ATOM_PPLIB_POWERPLAYTABLE3 *powerplay_table3 =
-			(const ATOM_PPLIB_POWERPLAYTABLE3 *)powerplay_table;
-		if (powerplay_table3->usExtendendedHeaderOffset > 0) {
-			const ATOM_PPLIB_EXTENDEDHEADER  *extended_header =
-				(const ATOM_PPLIB_EXTENDEDHEADER *)
-				(((unsigned long)powerplay_table3) +
-				le16_to_cpu(powerplay_table3->usExtendendedHeaderOffset));
-			if (le16_to_cpu(extended_header->usSize) >=
-			    SIZE_OF_ATOM_PPLIB_EXTENDEDHEADER_V4)
-				samu_table_offset = le16_to_cpu(extended_header->usSAMUTableOffset);
-		}
-	}
+	extended_header = get_extended_header(hwmgr, powerplay_table,
+					      SIZE_OF_ATOM_PPLIB_EXTENDEDHEADER_V4);
+	if (extended_header)
+		samu_table_offset = le16_to_cpu(extended_header->usSAMUTableOffset);
 
 	return samu_table_offset;
 }
@@ -254,21 +298,12 @@ static uint16_t get_acp_table_offset(struct pp_hwmgr *hwmgr,
 				const ATOM_PPLIB_POWERPLAYTABLE *powerplay_table)
 {
 	uint16_t acp_table_offset = 0;
+	const ATOM_PPLIB_EXTENDEDHEADER *extended_header;
 
-	if (le16_to_cpu(powerplay_table->usTableSize) >=
-	    sizeof(ATOM_PPLIB_POWERPLAYTABLE3)) {
-		const ATOM_PPLIB_POWERPLAYTABLE3 *powerplay_table3 =
-			(const ATOM_PPLIB_POWERPLAYTABLE3 *)powerplay_table;
-		if (powerplay_table3->usExtendendedHeaderOffset > 0) {
-			const ATOM_PPLIB_EXTENDEDHEADER  *pExtendedHeader =
-				(const ATOM_PPLIB_EXTENDEDHEADER *)
-				(((unsigned long)powerplay_table3) +
-				le16_to_cpu(powerplay_table3->usExtendendedHeaderOffset));
-			if (le16_to_cpu(pExtendedHeader->usSize) >=
-			    SIZE_OF_ATOM_PPLIB_EXTENDEDHEADER_V6)
-				acp_table_offset = le16_to_cpu(pExtendedHeader->usACPTableOffset);
-		}
-	}
+	extended_header = get_extended_header(hwmgr, powerplay_table,
+					      SIZE_OF_ATOM_PPLIB_EXTENDEDHEADER_V6);
+	if (extended_header)
+		acp_table_offset = le16_to_cpu(extended_header->usACPTableOffset);
 
 	return acp_table_offset;
 }
@@ -290,21 +325,12 @@ static uint16_t get_cacp_tdp_table_offset(
 				const ATOM_PPLIB_POWERPLAYTABLE *powerplay_table)
 {
 	uint16_t cacTdpTableOffset = 0;
+	const ATOM_PPLIB_EXTENDEDHEADER *extended_header;
 
-	if (le16_to_cpu(powerplay_table->usTableSize) >=
-	    sizeof(ATOM_PPLIB_POWERPLAYTABLE3)) {
-		const ATOM_PPLIB_POWERPLAYTABLE3 *powerplay_table3 =
-				(const ATOM_PPLIB_POWERPLAYTABLE3 *)powerplay_table;
-		if (powerplay_table3->usExtendendedHeaderOffset > 0) {
-			const ATOM_PPLIB_EXTENDEDHEADER  *pExtendedHeader =
-					(const ATOM_PPLIB_EXTENDEDHEADER *)
-					(((unsigned long)powerplay_table3) +
-				le16_to_cpu(powerplay_table3->usExtendendedHeaderOffset));
-			if (le16_to_cpu(pExtendedHeader->usSize) >=
-			    SIZE_OF_ATOM_PPLIB_EXTENDEDHEADER_V7)
-				cacTdpTableOffset = le16_to_cpu(pExtendedHeader->usPowerTuneTableOffset);
-		}
-	}
+	extended_header = get_extended_header(hwmgr, powerplay_table,
+					      SIZE_OF_ATOM_PPLIB_EXTENDEDHEADER_V7);
+	if (extended_header)
+		cacTdpTableOffset = le16_to_cpu(extended_header->usPowerTuneTableOffset);
 
 	return cacTdpTableOffset;
 }
@@ -341,22 +367,13 @@ static uint16_t get_sclk_vdd_gfx_table_offset(struct pp_hwmgr *hwmgr,
 			const ATOM_PPLIB_POWERPLAYTABLE *powerplay_table)
 {
 	uint16_t sclk_vdd_gfx_table_offset = 0;
+	const ATOM_PPLIB_EXTENDEDHEADER *extended_header;
 
-	if (le16_to_cpu(powerplay_table->usTableSize) >=
-	    sizeof(ATOM_PPLIB_POWERPLAYTABLE3)) {
-		const ATOM_PPLIB_POWERPLAYTABLE3 *powerplay_table3 =
-				(const ATOM_PPLIB_POWERPLAYTABLE3 *)powerplay_table;
-		if (powerplay_table3->usExtendendedHeaderOffset > 0) {
-			const ATOM_PPLIB_EXTENDEDHEADER  *pExtendedHeader =
-				(const ATOM_PPLIB_EXTENDEDHEADER *)
-				(((unsigned long)powerplay_table3) +
-				le16_to_cpu(powerplay_table3->usExtendendedHeaderOffset));
-			if (le16_to_cpu(pExtendedHeader->usSize) >=
-			    SIZE_OF_ATOM_PPLIB_EXTENDEDHEADER_V8)
-				sclk_vdd_gfx_table_offset =
-					le16_to_cpu(pExtendedHeader->usSclkVddgfxTableOffset);
-		}
-	}
+	extended_header = get_extended_header(hwmgr, powerplay_table,
+					      SIZE_OF_ATOM_PPLIB_EXTENDEDHEADER_V8);
+	if (extended_header)
+		sclk_vdd_gfx_table_offset =
+			le16_to_cpu(extended_header->usSclkVddgfxTableOffset);
 
 	return sclk_vdd_gfx_table_offset;
 }
@@ -770,20 +787,37 @@ static ULONG size_of_entry_v2(ULONG num_dpm_levels)
 }
 
 static const ATOM_PPLIB_STATE_V2 *get_state_entry_v2(
+					struct pp_hwmgr *hwmgr,
 					const StateArray * pstate_arrays,
+					u16 state_array_offset,
 							 ULONG entry_index)
 {
 	ULONG i;
 	const ATOM_PPLIB_STATE_V2 *pstate;
+	size_t entry_offset;
+	size_t entry_size;
+
+	if (entry_index >= pstate_arrays->ucNumEntries)
+		return NULL;
 
+	entry_offset = state_array_offset + sizeof(pstate_arrays->ucNumEntries);
 	pstate = pstate_arrays->states;
-	if (entry_index <= pstate_arrays->ucNumEntries) {
-		for (i = 0; i < entry_index; i++)
-			pstate = (ATOM_PPLIB_STATE_V2 *)(
-						  (unsigned long)pstate +
-			     size_of_entry_v2(pstate->ucNumDPMLevels));
+	for (i = 0; i <= entry_index; i++) {
+		if (!pp_table_has_space(hwmgr, entry_offset, sizeof(*pstate)))
+			return NULL;
+
+		entry_size = size_of_entry_v2(pstate->ucNumDPMLevels);
+		if (!pp_table_has_space(hwmgr, entry_offset, entry_size))
+			return NULL;
+
+		if (i == entry_index)
+			return pstate;
+
+		entry_offset += entry_size;
+		pstate = (ATOM_PPLIB_STATE_V2 *)((unsigned long)pstate + entry_size);
 	}
-	return pstate;
+
+	return NULL;
 }
 
 static const unsigned char soft_dummy_pp_table[] = {
@@ -851,6 +885,8 @@ int pp_tables_get_response_times(struct pp_hwmgr *hwmgr,
 
 	PP_ASSERT_WITH_CODE(NULL != powerplay_tab,
 			    "Missing PowerPlay Table!", return -EINVAL);
+	PP_ASSERT_WITH_CODE(pp_table_has_space(hwmgr, 0, sizeof(*powerplay_tab)),
+			    "Invalid PowerPlay Table!", return -EINVAL);
 
 	*vol_rep_time = (uint32_t)le16_to_cpu(powerplay_tab->usVoltageTime);
 	*bb_rep_time = (uint32_t)le16_to_cpu(powerplay_tab->usBackbiasTime);
@@ -863,13 +899,21 @@ int pp_tables_get_num_of_entries(struct pp_hwmgr *hwmgr,
 {
 	const StateArray *pstate_arrays;
 	const ATOM_PPLIB_POWERPLAYTABLE *powerplay_table = get_powerplay_table(hwmgr);
+	u16 state_array_offset;
 
 	if (powerplay_table == NULL)
 		return -1;
+	if (!pp_table_has_space(hwmgr, 0, sizeof(*powerplay_table)))
+		return -1;
 
 	if (powerplay_table->sHeader.ucTableFormatRevision >= 6) {
+		state_array_offset = le16_to_cpu(powerplay_table->usStateArrayOffset);
+		if (!pp_table_has_space(hwmgr, state_array_offset,
+					sizeof(pstate_arrays->ucNumEntries)))
+			return -1;
+
 		pstate_arrays = (StateArray *)(((unsigned long)powerplay_table) +
-					le16_to_cpu(powerplay_table->usStateArrayOffset));
+					state_array_offset);
 
 		*num_of_entries = (unsigned long)(pstate_arrays->ucNumEntries);
 	} else
@@ -896,49 +940,128 @@ int pp_tables_get_entry(struct pp_hwmgr *hwmgr,
 	const NonClockInfoArray *pnon_clock_arrays;
 
 	const ATOM_PPLIB_STATE *pstate_entry;
+	u16 state_array_offset;
+	u16 clock_info_array_offset;
+	u16 non_clock_info_array_offset;
+	size_t clock_info_offset;
+	size_t non_clock_info_offset;
+	size_t state_entry_offset;
 
 	if (powerplay_table == NULL)
 		return -1;
+	if (!pp_table_has_space(hwmgr, 0, sizeof(*powerplay_table)))
+		return -1;
 
 	ps->classification.bios_index = entry_index;
 
 	if (powerplay_table->sHeader.ucTableFormatRevision >= 6) {
+		state_array_offset = le16_to_cpu(powerplay_table->usStateArrayOffset);
+		if (!pp_table_has_space(hwmgr, state_array_offset,
+					sizeof(pstate_arrays->ucNumEntries)))
+			return -1;
+
 		pstate_arrays = (StateArray *)(((unsigned long)powerplay_table) +
-					le16_to_cpu(powerplay_table->usStateArrayOffset));
+					state_array_offset);
+
+		if (entry_index >= pstate_arrays->ucNumEntries)
+			return -1;
 
-		if (entry_index > pstate_arrays->ucNumEntries)
+		pstate_entry_v2 = get_state_entry_v2(hwmgr, pstate_arrays,
+						     state_array_offset,
+						     entry_index);
+		if (!pstate_entry_v2)
+			return -1;
+
+		clock_info_array_offset =
+			le16_to_cpu(powerplay_table->usClockInfoArrayOffset);
+		if (!pp_table_has_space(hwmgr, clock_info_array_offset,
+					sizeof(*pclock_arrays)))
 			return -1;
 
-		pstate_entry_v2 = get_state_entry_v2(pstate_arrays, entry_index);
 		pclock_arrays = (ClockInfoArray *)(((unsigned long)powerplay_table) +
-					le16_to_cpu(powerplay_table->usClockInfoArrayOffset));
+					clock_info_array_offset);
+		if (!pclock_arrays->ucEntrySize)
+			return -1;
+
+		non_clock_info_array_offset =
+			le16_to_cpu(powerplay_table->usNonClockInfoArrayOffset);
+		if (!pp_table_has_space(hwmgr, non_clock_info_array_offset,
+					sizeof(*pnon_clock_arrays)))
+			return -1;
 
 		pnon_clock_arrays = (NonClockInfoArray *)(((unsigned long)powerplay_table) +
-						le16_to_cpu(powerplay_table->usNonClockInfoArrayOffset));
+						non_clock_info_array_offset);
+		if (!pnon_clock_arrays->ucEntrySize ||
+		    pnon_clock_arrays->ucEntrySize < ATOM_PPLIB_NONCLOCKINFO_VER1 ||
+		    (pnon_clock_arrays->ucEntrySize > ATOM_PPLIB_NONCLOCKINFO_VER1 &&
+		     pnon_clock_arrays->ucEntrySize < ATOM_PPLIB_NONCLOCKINFO_VER2) ||
+		    pstate_entry_v2->nonClockInfoIndex >= pnon_clock_arrays->ucNumEntries)
+			return -1;
 
+		non_clock_info_offset = non_clock_info_array_offset +
+			offsetof(NonClockInfoArray, nonClockInfo) +
+			pstate_entry_v2->nonClockInfoIndex * pnon_clock_arrays->ucEntrySize;
+		if (!pp_table_has_space(hwmgr, non_clock_info_offset,
+					pnon_clock_arrays->ucEntrySize))
+			return -1;
 		pnon_clock_info = (ATOM_PPLIB_NONCLOCK_INFO *)((unsigned long)(pnon_clock_arrays->nonClockInfo) +
 					(pstate_entry_v2->nonClockInfoIndex * pnon_clock_arrays->ucEntrySize));
 
 		result = init_non_clock_fields(hwmgr, ps, pnon_clock_arrays->ucEntrySize, pnon_clock_info);
 
 		for (i = 0; i < pstate_entry_v2->ucNumDPMLevels; i++) {
-			const void *pclock_info = (const void *)(
-							(unsigned long)(pclock_arrays->clockInfo) +
-							(pstate_entry_v2->clockInfoIndex[i] * pclock_arrays->ucEntrySize));
+			const void *pclock_info;
+
+			if (pstate_entry_v2->clockInfoIndex[i] >=
+			    pclock_arrays->ucNumEntries)
+				return -1;
+
+			clock_info_offset = clock_info_array_offset +
+				offsetof(ClockInfoArray, clockInfo) +
+				pstate_entry_v2->clockInfoIndex[i] * pclock_arrays->ucEntrySize;
+			if (!pp_table_has_space(hwmgr, clock_info_offset,
+						pclock_arrays->ucEntrySize))
+				return -1;
+
+			pclock_info = (const void *)
+					((unsigned long)(pclock_arrays->clockInfo) +
+					(pstate_entry_v2->clockInfoIndex[i] *
+					 pclock_arrays->ucEntrySize));
 			res = func(hwmgr, &ps->hardware, i, pclock_info);
 			if ((0 == result) && (0 != res))
 				result = res;
 		}
 	} else {
-		if (entry_index > powerplay_table->ucNumStates)
+		if (entry_index >= powerplay_table->ucNumStates ||
+		    !powerplay_table->ucStateEntrySize ||
+		    !powerplay_table->ucNonClockSize ||
+		    powerplay_table->ucNonClockSize < ATOM_PPLIB_NONCLOCKINFO_VER1 ||
+		    (powerplay_table->ucNonClockSize > ATOM_PPLIB_NONCLOCKINFO_VER1 &&
+		     powerplay_table->ucNonClockSize < ATOM_PPLIB_NONCLOCKINFO_VER2) ||
+		    !powerplay_table->ucClockInfoSize)
+			return -1;
+
+		state_array_offset = le16_to_cpu(powerplay_table->usStateArrayOffset);
+		state_entry_offset = state_array_offset +
+			entry_index * powerplay_table->ucStateEntrySize;
+		if (!pp_table_has_space(hwmgr, state_entry_offset,
+					powerplay_table->ucStateEntrySize))
 			return -1;
 
 		pstate_entry = (ATOM_PPLIB_STATE *)((unsigned long)powerplay_table +
-						    le16_to_cpu(powerplay_table->usStateArrayOffset) +
+						    state_array_offset +
 						    entry_index * powerplay_table->ucStateEntrySize);
 
+		non_clock_info_array_offset =
+			le16_to_cpu(powerplay_table->usNonClockInfoArrayOffset);
+		non_clock_info_offset = non_clock_info_array_offset +
+			pstate_entry->ucNonClockStateIndex * powerplay_table->ucNonClockSize;
+		if (!pp_table_has_space(hwmgr, non_clock_info_offset,
+					powerplay_table->ucNonClockSize))
+			return -1;
+
 		pnon_clock_info = (ATOM_PPLIB_NONCLOCK_INFO *)((unsigned long)powerplay_table +
-						le16_to_cpu(powerplay_table->usNonClockInfoArrayOffset) +
+						non_clock_info_array_offset +
 						pstate_entry->ucNonClockStateIndex *
 						powerplay_table->ucNonClockSize);
 
@@ -947,12 +1070,23 @@ int pp_tables_get_entry(struct pp_hwmgr *hwmgr,
 							pnon_clock_info);
 
 		for (i = 0; i < powerplay_table->ucStateEntrySize-1; i++) {
-			const void *pclock_info = (const void *)((unsigned long)powerplay_table +
-						le16_to_cpu(powerplay_table->usClockInfoArrayOffset) +
+			const void *pclock_info;
+
+			clock_info_array_offset =
+				le16_to_cpu(powerplay_table->usClockInfoArrayOffset);
+			clock_info_offset = clock_info_array_offset +
+				pstate_entry->ucClockStateIndices[i] *
+				powerplay_table->ucClockInfoSize;
+			if (!pp_table_has_space(hwmgr, clock_info_offset,
+						powerplay_table->ucClockInfoSize))
+				return -1;
+
+			pclock_info = (const void *)((unsigned long)powerplay_table +
+						clock_info_array_offset +
 						pstate_entry->ucClockStateIndices[i] *
 						powerplay_table->ucClockInfoSize);
 
-			int res = func(hwmgr, &ps->hardware, i, pclock_info);
+			res = func(hwmgr, &ps->hardware, i, pclock_info);
 
 			if ((0 == result) && (0 != res))
 					result = res;
@@ -1667,21 +1801,70 @@ static int get_vce_state_table_entry(struct pp_hwmgr *hwmgr,
 							unsigned long *flag)
 {
 	const ATOM_PPLIB_POWERPLAYTABLE *powerplay_table = get_powerplay_table(hwmgr);
+	const ATOM_PPLIB_VCE_State_Table *vce_state_table;
+	const ATOM_PPLIB_VCE_State_Record *record;
+	const VCEClockInfoArray *vce_clock_info_array;
+	const VCEClockInfo *vce_clock_info;
+	const ClockInfoArray *clock_arrays;
+	u16 vce_state_table_offset;
+	u16 vce_clock_info_array_offset;
+	u16 clock_info_array_offset;
+	unsigned long clockInfoIndex;
+	size_t record_offset;
+	size_t vce_clock_info_offset;
+	size_t clock_info_offset;
+
+	if (!powerplay_table || !pp_table_has_space(hwmgr, 0, sizeof(*powerplay_table)))
+		return -1;
 
-	const ATOM_PPLIB_VCE_State_Table *vce_state_table = get_vce_state_table(hwmgr, powerplay_table);
+	vce_state_table_offset = get_vce_state_table_offset(hwmgr, powerplay_table);
+	vce_state_table = get_vce_state_table(hwmgr, powerplay_table);
+	if (!vce_state_table || i >= vce_state_table->numEntries)
+		return -1;
+
+	record_offset = vce_state_table_offset +
+		offsetof(ATOM_PPLIB_VCE_State_Table, entries) +
+		i * sizeof(*record);
+	if (!pp_table_has_space(hwmgr, record_offset, sizeof(*record)))
+		return -1;
+
+	record = &vce_state_table->entries[i];
+
+	vce_clock_info_array_offset =
+		get_vce_clock_info_array_offset(hwmgr, powerplay_table);
+	if (!pp_table_has_space(hwmgr, vce_clock_info_array_offset,
+				sizeof(vce_clock_info_array->ucNumEntries)))
+		return -1;
 
-	unsigned short vce_clock_info_array_offset = get_vce_clock_info_array_offset(hwmgr, powerplay_table);
+	vce_clock_info_array = (const VCEClockInfoArray *)
+		(((unsigned long)powerplay_table) + vce_clock_info_array_offset);
+	if (record->ucVCEClockInfoIndex >= vce_clock_info_array->ucNumEntries)
+		return -1;
 
-	const VCEClockInfoArray *vce_clock_info_array = (const VCEClockInfoArray *)(((unsigned long) powerplay_table) + vce_clock_info_array_offset);
+	vce_clock_info_offset = vce_clock_info_array_offset +
+		offsetof(VCEClockInfoArray, entries) +
+		record->ucVCEClockInfoIndex * sizeof(*vce_clock_info);
+	if (!pp_table_has_space(hwmgr, vce_clock_info_offset, sizeof(*vce_clock_info)))
+		return -1;
 
-	const ClockInfoArray *clock_arrays = (ClockInfoArray *)(((unsigned long)powerplay_table) +
-								le16_to_cpu(powerplay_table->usClockInfoArrayOffset));
+	vce_clock_info = &vce_clock_info_array->entries[record->ucVCEClockInfoIndex];
 
-	const ATOM_PPLIB_VCE_State_Record *record = &vce_state_table->entries[i];
+	clock_info_array_offset = le16_to_cpu(powerplay_table->usClockInfoArrayOffset);
+	if (!pp_table_has_space(hwmgr, clock_info_array_offset,
+				sizeof(*clock_arrays)))
+		return -1;
 
-	const VCEClockInfo *vce_clock_info = &vce_clock_info_array->entries[record->ucVCEClockInfoIndex];
+	clock_arrays = (ClockInfoArray *)(((unsigned long)powerplay_table) +
+					  clock_info_array_offset);
+	clockInfoIndex = record->ucClockInfoIndex & 0x3F;
+	if (!clock_arrays->ucEntrySize || clockInfoIndex >= clock_arrays->ucNumEntries)
+		return -1;
 
-	unsigned long clockInfoIndex = record->ucClockInfoIndex & 0x3F;
+	clock_info_offset = clock_info_array_offset +
+		offsetof(ClockInfoArray, clockInfo) +
+		clockInfoIndex * clock_arrays->ucEntrySize;
+	if (!pp_table_has_space(hwmgr, clock_info_offset, clock_arrays->ucEntrySize))
+		return -1;
 
 	*flag = (record->ucClockInfoIndex >> NUM_BITS_CLOCK_INFO_ARRAY_INDEX);
 
@@ -1705,6 +1888,10 @@ static int pp_tables_initialize(struct pp_hwmgr *hwmgr)
 	hwmgr->need_pp_table_upload = true;
 
 	powerplay_table = get_powerplay_table(hwmgr);
+	PP_ASSERT_WITH_CODE((powerplay_table),
+			    "Missing PowerPlay Table!", return -1);
+	PP_ASSERT_WITH_CODE(pp_table_has_space(hwmgr, 0, sizeof(*powerplay_table)),
+			    "Invalid PowerPlay Table!", return -1);
 
 	result = init_powerplay_tables(hwmgr, powerplay_table);
 
@@ -1807,4 +1994,3 @@ const struct pp_table_func pptable_funcs = {
 	.pptable_get_vce_state_table_entry =
 						get_vce_state_table_entry,
 };
-
-- 
2.53.0



