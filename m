Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795023300;
	b=ZseL/i/cQ5S7ZEuCsmpEpirHtzSxc+IFeVzUBHmOHIXXZD2EZy78/68uXeX8rJ7xH/vZ
	 PvaAvfTr8dN0fgAHvgZ1RlCV3WPdH/kZRBlvhMPMV+pdsoTOXNMnR+l3QKzdFveg6W0wc
	 UElEUFb9RLaohRCmFBhPSYxyej8RN5WIqu/Tr4GfH8weyDPTIGy2E8wAJcFkf3NDPeRr/
	 7mgY0FgVtWG0k0zq5y1uczQDYrAXYV3DVoVr4qIP4vVxfv75DQ8r9fidSclkYLJD0brP8
	 hfXvlT3fcK6XKCInkIze/ftEkbk01TZ4DLw9enPT5OKFtore6rbHVV9xBYMtbOt1UHA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795023300;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=MzsF9IIDKUkR16ja9Ma4aY6yb/om19eo82/OvZ1Nz8U=;
	b=mnOJDExuUWLgoHc00F2EZLF0ilI5zuqSMZnws1GPfkBW5Y1wouA+BbWPHabmekLLuzNt
	 qIMpUnZxgmjmqvmnBi/lOTIz4Gx7pnZAQ9qX+CQGr6ZtSUf1QB5YaYdc2qc9lieUOhdWr
	 OijQJmx+09jI44dZo4JizG+17jg6ySatVlab9Hrow6Rc63iKQ1vlz2wqNGxr7pPUqvoeb
	 r2lUWEFvXGMRRxSZRmxitpjGLTr5cQi2CiBSFDNm3Jr2/KsiQXj6ofTZ3ugcycGQaxgJV
	 1/CyjDAQYcI3hNrDesL46t5LFk92pSakBwK1oy0PH6MRNQCV0V3HwRfqt2nUzqGF7bQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=GgCXECli;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9DC46606A32F;
	Wed, 18 Nov 2026 17:35:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=GgCXECli
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AC6BB1F000C4;
	Wed, 18 Nov 2026 17:34:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795023300;
	bh=MzsF9IIDKUkR16ja9Ma4aY6yb/om19eo82/OvZ1Nz8U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=GgCXECli6lco0MmqBiRTxkn0q1wh509Nqwt9bZDvOwnYUh+QV2SQO3cEexf53/z1d
	 5rRB3ZKk3zBpJEHYG4c0L9OEc+oJ1OIRbJPC2AKgeu4P19iAOQrlg1hj/31UHg9OZ3
	 1udwJyCJnLTg3Kd3Zoy7g1iq5iDLodGBEl6y6b3s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mario Limonciello <superm1@kernel.org>,
	K Prateek Nayak <kprateek.nayak@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0320/2151] cpufreq/amd-pstate-ut: Fix amd_pstate_ut_check_freq failure with Requested CPU Min frequency BIOS option
Date: Wed, 18 Nov 2026 15:34:15 +0100
Message-ID: <20261118150133.614320774@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
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

From: K Prateek Nayak <kprateek.nayak@amd.com>

[ Upstream commit a23fca4ae137ec8e7620cc4f00b468b89cf5a7bd ]

Since commit 608a76b65288 ("cpufreq/amd-pstate: Add support for the
"Requested CPU Min frequency" BIOS option"), amd-pstate driver sets
policy->min to frequency corresponding to bios_min_perf if a valid BIOS
programmed min frequency value is detected.

amd_pstate_ut_check_freq expects policy->min to always match
lowest_nonlinear_freq which does not hold true on platforms with user
configured BIOS min freq.

Update the test case to compare policy->min to bios_min_freq on
platforms that set it. Final comparison is adjusted to account for
insane values by clamping the result within the supported frequency
range.

While at it, move freq_to_perf() and perf_to_freq() helpers to internal
header to allow their use from amd-pstate-ut.

Reviewed-by: Mario Limonciello <superm1@kernel.org>
Fixes: 608a76b65288 ("cpufreq/amd-pstate: Add support for the "Requested CPU Min frequency" BIOS option")
Signed-off-by: K Prateek Nayak <kprateek.nayak@amd.com>
Link: https://lore.kernel.org/r/20260909102650.4582-1-kprateek.nayak@amd.com
Signed-off-by: Mario Limonciello <superm1@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/cpufreq/amd-pstate-ut.c | 23 ++++++++++++++++++++++-
 drivers/cpufreq/amd-pstate.c    | 13 -------------
 drivers/cpufreq/amd-pstate.h    | 14 ++++++++++++++
 3 files changed, 36 insertions(+), 14 deletions(-)

diff --git a/drivers/cpufreq/amd-pstate-ut.c b/drivers/cpufreq/amd-pstate-ut.c
index 93b80bf992a6a..b0482f4655c9b 100644
--- a/drivers/cpufreq/amd-pstate-ut.c
+++ b/drivers/cpufreq/amd-pstate-ut.c
@@ -193,11 +193,14 @@ static int amd_pstate_ut_check_freq(u32 index)
 	for_each_online_cpu(cpu) {
 		struct cpufreq_policy *policy __free(put_cpufreq_policy) = NULL;
 		struct amd_cpudata *cpudata;
+		union perf_cached perf;
 
 		policy = cpufreq_cpu_get(cpu);
 		if (!policy)
 			continue;
+
 		cpudata = policy->driver_data;
+		perf = READ_ONCE(cpudata->perf);
 
 		if (!((policy->cpuinfo.max_freq >= cpudata->nominal_freq) &&
 			(cpudata->nominal_freq > cpudata->lowest_nonlinear_freq) &&
@@ -209,7 +212,25 @@ static int amd_pstate_ut_check_freq(u32 index)
 			return -EINVAL;
 		}
 
-		if (cpudata->lowest_nonlinear_freq != policy->min) {
+		if (perf.bios_min_perf) {
+			u32 bios_min_freq = perf_to_freq(perf, cpudata->nominal_freq,
+							 perf.bios_min_perf);
+
+			/*
+			 * User set bios_min_freq cannot be trusted to
+			 * be within the driver limits. Clamp it similar
+			 * to cpufreq_verify_within_cpu_limits().
+			 */
+			bios_min_freq = clamp_t(u32, bios_min_freq,
+						     policy->cpuinfo.min_freq,
+						     policy->cpuinfo.max_freq);
+
+			if (bios_min_freq != policy->min) {
+				pr_err("%s cpu%d bios_min_freq=%d policy_min=%d, they should be equal!\n",
+					__func__, cpu, bios_min_freq, policy->min);
+				return -EINVAL;
+			}
+		} else if (cpudata->lowest_nonlinear_freq != policy->min) {
 			pr_err("%s cpu%d cpudata_lowest_nonlinear_freq=%d policy_min=%d, they should be equal!\n",
 				__func__, cpu, cpudata->lowest_nonlinear_freq, policy->min);
 			return -EINVAL;
diff --git a/drivers/cpufreq/amd-pstate.c b/drivers/cpufreq/amd-pstate.c
index c5047b56be50f..130b037be8f95 100644
--- a/drivers/cpufreq/amd-pstate.c
+++ b/drivers/cpufreq/amd-pstate.c
@@ -147,19 +147,6 @@ static struct quirk_entry quirk_amd_7k62 = {
 	.lowest_freq = 550,
 };
 
-static inline u8 freq_to_perf(union perf_cached perf, u32 nominal_freq, unsigned int freq_val)
-{
-	u32 perf_val = DIV_ROUND_UP_ULL((u64)freq_val * perf.nominal_perf, nominal_freq);
-
-	return (u8)clamp(perf_val, perf.lowest_perf, perf.highest_perf);
-}
-
-static inline u32 perf_to_freq(union perf_cached perf, u32 nominal_freq, u8 perf_val)
-{
-	return DIV_ROUND_UP_ULL((u64)nominal_freq * perf_val,
-				perf.nominal_perf);
-}
-
 static int __init dmi_matched_7k62_bios_bug(const struct dmi_system_id *dmi)
 {
 	/**
diff --git a/drivers/cpufreq/amd-pstate.h b/drivers/cpufreq/amd-pstate.h
index 325d935718f65..d7305261f575f 100644
--- a/drivers/cpufreq/amd-pstate.h
+++ b/drivers/cpufreq/amd-pstate.h
@@ -134,6 +134,20 @@ enum amd_pstate_mode {
 	AMD_PSTATE_GUIDED,
 	AMD_PSTATE_MAX,
 };
+
+static inline u8 freq_to_perf(union perf_cached perf, u32 nominal_freq, unsigned int freq_val)
+{
+	u32 perf_val = DIV_ROUND_UP_ULL((u64)freq_val * perf.nominal_perf, nominal_freq);
+
+	return (u8)clamp(perf_val, perf.lowest_perf, perf.highest_perf);
+}
+
+static inline u32 perf_to_freq(union perf_cached perf, u32 nominal_freq, u8 perf_val)
+{
+	return DIV_ROUND_UP_ULL((u64)nominal_freq * perf_val,
+				perf.nominal_perf);
+}
+
 const char *amd_pstate_get_mode_string(enum amd_pstate_mode mode);
 int amd_pstate_get_status(void);
 int amd_pstate_update_status(const char *buf, size_t size);
-- 
2.53.0



