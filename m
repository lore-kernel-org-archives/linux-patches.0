Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E50E1330B00;
	Fri, 17 Oct 2025 15:51:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760716273; cv=none; b=VdD8AOUoZQtaSQiUi0oYTiD888u2Ikhkbm/RJ25DttC/RQKiLtJxkTANOWIERGmA/9aY1npjCdG12l1RgcwMgpnHDXMSHt6kJvNWAaR3b3PkBnrh/sdH1KEBNkPC3lGMoSZIV9/T466CPQ8/pDps5U6ZzlVBU7lt2hzcYXVTCaI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760716273; c=relaxed/simple;
	bh=pvR+TlwFMRHgvKKBBLFoF47oognW0qNhbRAEBADr3kk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ipOt0JPaLRfyko4/z4YEKrilVSU+z+3Bw58c7RhhRQxxXSX1hjdvbwyO+ARGXxXzqYnOmRb44tWvOQGBN7ItjtqLEbgE38wZF51BKqaFsSdDXDJhsllWX/6VFNHvuNMmqYaxgaxi5jCfv+SHd6uOS1IXLm7ps8lVsQ740uvt8CU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=R+Ske+by; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="R+Ske+by"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 44A04C4CEE7;
	Fri, 17 Oct 2025 15:51:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760716272;
	bh=pvR+TlwFMRHgvKKBBLFoF47oognW0qNhbRAEBADr3kk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=R+Ske+byOd566oIY9augRF6n+VZ0m5lTbGJMomgtinVvLYYDKM8nxhvd8rzSUjEU1
	 v6aomYECpXAI/7Qq0IeSfk77Fm0gnTApEPEcu4NuT0vbgEWicLYwZujD4X91CmIQN6
	 KyLkxOHv/8TV1TuUytKGLsq0bYLmVf5tBUAe/bjc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Leo Yan <leo.yan@arm.com>,
	James Clark <james.clark@linaro.org>,
	Namhyung Kim <namhyung@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 133/276] perf arm-spe: Rename the common data source encoding
Date: Fri, 17 Oct 2025 16:53:46 +0200
Message-ID: <20251017145147.338331585@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251017145142.382145055@linuxfoundation.org>
References: <20251017145142.382145055@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Leo Yan <leo.yan@arm.com>

[ Upstream commit 50b8f1d5bf4ad7f09ef8012ccf5f94f741df827b ]

The Neoverse CPUs follow the common data source encoding, and other
CPU variants can share the same format.

Rename the CPU list and data source definitions as common data source
names. This change prepares for appending more CPU variants.

Signed-off-by: Leo Yan <leo.yan@arm.com>
Reviewed-by: James Clark <james.clark@linaro.org>
Link: https://lore.kernel.org/r/20241003185322.192357-3-leo.yan@arm.com
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Stable-dep-of: cb300e351505 ("perf arm_spe: Correct memory level for remote access")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../util/arm-spe-decoder/arm-spe-decoder.h    | 18 ++++++------
 tools/perf/util/arm-spe.c                     | 28 +++++++++----------
 2 files changed, 23 insertions(+), 23 deletions(-)

diff --git a/tools/perf/util/arm-spe-decoder/arm-spe-decoder.h b/tools/perf/util/arm-spe-decoder/arm-spe-decoder.h
index fa269c9c53b33..d9166794e527f 100644
--- a/tools/perf/util/arm-spe-decoder/arm-spe-decoder.h
+++ b/tools/perf/util/arm-spe-decoder/arm-spe-decoder.h
@@ -56,15 +56,15 @@ enum arm_spe_op_type {
 	ARM_SPE_OP_BR_INDIRECT	= 1 << 17,
 };
 
-enum arm_spe_neoverse_data_source {
-	ARM_SPE_NV_L1D		 = 0x0,
-	ARM_SPE_NV_L2		 = 0x8,
-	ARM_SPE_NV_PEER_CORE	 = 0x9,
-	ARM_SPE_NV_LOCAL_CLUSTER = 0xa,
-	ARM_SPE_NV_SYS_CACHE	 = 0xb,
-	ARM_SPE_NV_PEER_CLUSTER	 = 0xc,
-	ARM_SPE_NV_REMOTE	 = 0xd,
-	ARM_SPE_NV_DRAM		 = 0xe,
+enum arm_spe_common_data_source {
+	ARM_SPE_COMMON_DS_L1D		= 0x0,
+	ARM_SPE_COMMON_DS_L2		= 0x8,
+	ARM_SPE_COMMON_DS_PEER_CORE	= 0x9,
+	ARM_SPE_COMMON_DS_LOCAL_CLUSTER = 0xa,
+	ARM_SPE_COMMON_DS_SYS_CACHE	= 0xb,
+	ARM_SPE_COMMON_DS_PEER_CLUSTER	= 0xc,
+	ARM_SPE_COMMON_DS_REMOTE	= 0xd,
+	ARM_SPE_COMMON_DS_DRAM		= 0xe,
 };
 
 struct arm_spe_record {
diff --git a/tools/perf/util/arm-spe.c b/tools/perf/util/arm-spe.c
index c86e60b5954c5..68445c1e1db3b 100644
--- a/tools/perf/util/arm-spe.c
+++ b/tools/perf/util/arm-spe.c
@@ -314,15 +314,15 @@ static int arm_spe__synth_branch_sample(struct arm_spe_queue *speq,
 	return arm_spe_deliver_synth_event(spe, speq, event, &sample);
 }
 
-static const struct midr_range neoverse_spe[] = {
+static const struct midr_range common_ds_encoding_cpus[] = {
 	MIDR_ALL_VERSIONS(MIDR_NEOVERSE_N1),
 	MIDR_ALL_VERSIONS(MIDR_NEOVERSE_N2),
 	MIDR_ALL_VERSIONS(MIDR_NEOVERSE_V1),
 	{},
 };
 
-static void arm_spe__synth_data_source_neoverse(const struct arm_spe_record *record,
-						union perf_mem_data_src *data_src)
+static void arm_spe__synth_data_source_common(const struct arm_spe_record *record,
+					      union perf_mem_data_src *data_src)
 {
 	/*
 	 * Even though four levels of cache hierarchy are possible, no known
@@ -344,17 +344,17 @@ static void arm_spe__synth_data_source_neoverse(const struct arm_spe_record *rec
 	}
 
 	switch (record->source) {
-	case ARM_SPE_NV_L1D:
+	case ARM_SPE_COMMON_DS_L1D:
 		data_src->mem_lvl = PERF_MEM_LVL_L1 | PERF_MEM_LVL_HIT;
 		data_src->mem_lvl_num = PERF_MEM_LVLNUM_L1;
 		data_src->mem_snoop = PERF_MEM_SNOOP_NONE;
 		break;
-	case ARM_SPE_NV_L2:
+	case ARM_SPE_COMMON_DS_L2:
 		data_src->mem_lvl = PERF_MEM_LVL_L2 | PERF_MEM_LVL_HIT;
 		data_src->mem_lvl_num = PERF_MEM_LVLNUM_L2;
 		data_src->mem_snoop = PERF_MEM_SNOOP_NONE;
 		break;
-	case ARM_SPE_NV_PEER_CORE:
+	case ARM_SPE_COMMON_DS_PEER_CORE:
 		data_src->mem_lvl = PERF_MEM_LVL_L2 | PERF_MEM_LVL_HIT;
 		data_src->mem_lvl_num = PERF_MEM_LVLNUM_L2;
 		data_src->mem_snoopx = PERF_MEM_SNOOPX_PEER;
@@ -363,8 +363,8 @@ static void arm_spe__synth_data_source_neoverse(const struct arm_spe_record *rec
 	 * We don't know if this is L1, L2 but we do know it was a cache-2-cache
 	 * transfer, so set SNOOPX_PEER
 	 */
-	case ARM_SPE_NV_LOCAL_CLUSTER:
-	case ARM_SPE_NV_PEER_CLUSTER:
+	case ARM_SPE_COMMON_DS_LOCAL_CLUSTER:
+	case ARM_SPE_COMMON_DS_PEER_CLUSTER:
 		data_src->mem_lvl = PERF_MEM_LVL_L3 | PERF_MEM_LVL_HIT;
 		data_src->mem_lvl_num = PERF_MEM_LVLNUM_L3;
 		data_src->mem_snoopx = PERF_MEM_SNOOPX_PEER;
@@ -372,7 +372,7 @@ static void arm_spe__synth_data_source_neoverse(const struct arm_spe_record *rec
 	/*
 	 * System cache is assumed to be L3
 	 */
-	case ARM_SPE_NV_SYS_CACHE:
+	case ARM_SPE_COMMON_DS_SYS_CACHE:
 		data_src->mem_lvl = PERF_MEM_LVL_L3 | PERF_MEM_LVL_HIT;
 		data_src->mem_lvl_num = PERF_MEM_LVLNUM_L3;
 		data_src->mem_snoop = PERF_MEM_SNOOP_HIT;
@@ -381,13 +381,13 @@ static void arm_spe__synth_data_source_neoverse(const struct arm_spe_record *rec
 	 * We don't know what level it hit in, except it came from the other
 	 * socket
 	 */
-	case ARM_SPE_NV_REMOTE:
+	case ARM_SPE_COMMON_DS_REMOTE:
 		data_src->mem_lvl = PERF_MEM_LVL_REM_CCE1;
 		data_src->mem_lvl_num = PERF_MEM_LVLNUM_ANY_CACHE;
 		data_src->mem_remote = PERF_MEM_REMOTE_REMOTE;
 		data_src->mem_snoopx = PERF_MEM_SNOOPX_PEER;
 		break;
-	case ARM_SPE_NV_DRAM:
+	case ARM_SPE_COMMON_DS_DRAM:
 		data_src->mem_lvl = PERF_MEM_LVL_LOC_RAM | PERF_MEM_LVL_HIT;
 		data_src->mem_lvl_num = PERF_MEM_LVLNUM_RAM;
 		data_src->mem_snoop = PERF_MEM_SNOOP_NONE;
@@ -423,7 +423,7 @@ static void arm_spe__synth_data_source_generic(const struct arm_spe_record *reco
 static u64 arm_spe__synth_data_source(const struct arm_spe_record *record, u64 midr)
 {
 	union perf_mem_data_src	data_src = { .mem_op = PERF_MEM_OP_NA };
-	bool is_neoverse = is_midr_in_range_list(midr, neoverse_spe);
+	bool is_common = is_midr_in_range_list(midr, common_ds_encoding_cpus);
 
 	if (record->op & ARM_SPE_OP_LD)
 		data_src.mem_op = PERF_MEM_OP_LOAD;
@@ -432,8 +432,8 @@ static u64 arm_spe__synth_data_source(const struct arm_spe_record *record, u64 m
 	else
 		return 0;
 
-	if (is_neoverse)
-		arm_spe__synth_data_source_neoverse(record, &data_src);
+	if (is_common)
+		arm_spe__synth_data_source_common(record, &data_src);
 	else
 		arm_spe__synth_data_source_generic(record, &data_src);
 
-- 
2.51.0



