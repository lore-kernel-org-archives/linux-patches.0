Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 64A8D32C957;
	Fri, 17 Oct 2025 15:14:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760714093; cv=none; b=ftqABginbZ0qJ3kvUYOzj2ReT+FH5LBIQ4dhtWdZYF340eKLly6WwbtJhLpzk5B/BDJ+4BuT78nc11fbNQMA26GEzyTSeTPP/4ijLw40eyG8R/uy3UpvBPXxaBYhp1oR79CYf2rLQuNeLW7F8qEJVCoLUUiVXd7ElveuSzCp130=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760714093; c=relaxed/simple;
	bh=Zp6fn61gSC08auZCIfB8iDQJeia5T3nWHOLpiLQ5oEo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OkytKq/sVeYQPWKlw6OSd2syvGlxm0TLKnd1Mq78ZCZXy7BZg0SOx6IL977Xb1oUMA+mY4WySWQVkQkbwp6/awX+MRe7eVw+zq0zpbtyxqaJ7UTxCQb5wImx73k/SrtJtR4WJxLxj62narLs5knkmTUwbCNHmx80QNBw13A+Cts=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LLXKfqG3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LLXKfqG3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DE2CFC4CEE7;
	Fri, 17 Oct 2025 15:14:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760714093;
	bh=Zp6fn61gSC08auZCIfB8iDQJeia5T3nWHOLpiLQ5oEo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LLXKfqG3k3oaAhGaR4auFuzL7Vd48XL1TyinbdlpWLQ7AIa88xz3Egr7uQLWd7IL1
	 5NMGgdsFxyyKek/cZ0VJAOeH3I1rPQD7X8jog0Sjjeb1h6kYnxa0oEuqMHqpIqig95
	 JFyBJUAALGuapxKtXblNIbttMAuxA8qA5BVaLjwo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Leo Yan <leo.yan@arm.com>,
	James Clark <james.clark@linaro.org>,
	Namhyung Kim <namhyung@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 024/277] perf arm-spe: Rename the common data source encoding
Date: Fri, 17 Oct 2025 16:50:31 +0200
Message-ID: <20251017145148.030859564@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251017145147.138822285@linuxfoundation.org>
References: <20251017145147.138822285@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 1443c28545a94..358c611eeddbb 100644
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
index 921b1c6e11379..4754d247dbe73 100644
--- a/tools/perf/util/arm-spe.c
+++ b/tools/perf/util/arm-spe.c
@@ -411,15 +411,15 @@ static int arm_spe__synth_instruction_sample(struct arm_spe_queue *speq,
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
@@ -441,17 +441,17 @@ static void arm_spe__synth_data_source_neoverse(const struct arm_spe_record *rec
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
@@ -460,8 +460,8 @@ static void arm_spe__synth_data_source_neoverse(const struct arm_spe_record *rec
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
@@ -469,7 +469,7 @@ static void arm_spe__synth_data_source_neoverse(const struct arm_spe_record *rec
 	/*
 	 * System cache is assumed to be L3
 	 */
-	case ARM_SPE_NV_SYS_CACHE:
+	case ARM_SPE_COMMON_DS_SYS_CACHE:
 		data_src->mem_lvl = PERF_MEM_LVL_L3 | PERF_MEM_LVL_HIT;
 		data_src->mem_lvl_num = PERF_MEM_LVLNUM_L3;
 		data_src->mem_snoop = PERF_MEM_SNOOP_HIT;
@@ -478,13 +478,13 @@ static void arm_spe__synth_data_source_neoverse(const struct arm_spe_record *rec
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
@@ -520,7 +520,7 @@ static void arm_spe__synth_data_source_generic(const struct arm_spe_record *reco
 static u64 arm_spe__synth_data_source(const struct arm_spe_record *record, u64 midr)
 {
 	union perf_mem_data_src	data_src = { .mem_op = PERF_MEM_OP_NA };
-	bool is_neoverse = is_midr_in_range_list(midr, neoverse_spe);
+	bool is_common = is_midr_in_range_list(midr, common_ds_encoding_cpus);
 
 	/* Only synthesize data source for LDST operations */
 	if (!is_ldst_op(record->op))
@@ -533,8 +533,8 @@ static u64 arm_spe__synth_data_source(const struct arm_spe_record *record, u64 m
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



