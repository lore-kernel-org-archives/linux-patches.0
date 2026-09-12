Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8FCB6455626;
	Sat, 12 Sep 2026 12:31:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789216263; cv=none; b=G5n+Vz9VdiFPNDTuGPZ/Su9XUdNU9u/KLUuh1xlLmzU5+vZhJqB6Ejhj9ZZvmseMcMuh0A0ke7u7HH3pAhRc0Mkdl71S7SxLKprmP0MqeFEMC8Ho4/xRsjTJJGZcnsQUz9VQtodjJMOiM94bSnUYmPQ3X/ScVQYrWz6Q4ZwG5d0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789216263; c=relaxed/simple;
	bh=cCehJtXJ0Qa9qzN81dGt4ubvHUegLPyCIwLZGtvteH8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YBEN0QVkJ5uQ85At0YN9J4EyYh1aURd2pXyfIiQeOGhcQsZkq43/FC7iwekDYUBDf78TjQt2D37NI89K44QQ18KYtppIrADKhtj8kIkCQMQ08DM2JgKm2qGYsYq77A4UFmfbKIOI14VELTgXelil+nHVLDeIioNAA2kXwonouSc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TMrjgdQs; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TMrjgdQs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 950F31F000FF;
	Sat, 12 Sep 2026 12:31:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789216262;
	bh=JyWraZwdCXCdW7/qfM+xp7yCu57lv0N1vMj7G+D+VkM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=TMrjgdQsN5YUiwmr9XwCJnaAwAYrjoEYdjemEvahF9+m78Lh4SRQRZzIW9+Co2P79
	 /lNJWKG0ezxlpCjWq9kCdRbwHpK0Um+z9hN9m0d/Exh9TssVwlSygm6amTUudyk1ox
	 TPCIvVgxFBDnZgN1VCHNC2TFAkdO8b+G0vXFo3mI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pierre Gondois <pierre.gondois@arm.com>,
	Lifeng Zheng <zhenglifeng1@huawei.com>,
	Mario Limonciello <mario.limonciello@amd.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0659/1376] ACPI: CPPC: Modify cppc_get_auto_sel_caps() to cppc_get_auto_sel()
Date: Sat, 12 Sep 2026 08:51:25 +0200
Message-ID: <20260912065622.227909435@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.535295758@linuxfoundation.org>
References: <20260912065607.535295758@linuxfoundation.org>
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

From: Lifeng Zheng <zhenglifeng1@huawei.com>

[ Upstream commit 2605e4ab6615ef43361b18fc6d08dd884896aad8 ]

Modify cppc_get_auto_sel_caps() to cppc_get_auto_sel(). Using a
cppc_perf_caps to carry the value is unnecessary.

Add a check to ensure the pointer 'enable' is not null.

Reviewed-by: Pierre Gondois <pierre.gondois@arm.com>
Signed-off-by: Lifeng Zheng <zhenglifeng1@huawei.com>
Reviewed-by: Mario Limonciello <mario.limonciello@amd.com>
Link: https://patch.msgid.link/20250411093855.982491-8-zhenglifeng1@huawei.com
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Stable-dep-of: 9dfd13f80c85 ("cpufreq/amd-pstate: Toggle auto_sel in active mode on shared memory systems")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/acpi/cppc_acpi.c     | 18 +++++++++++-------
 drivers/cpufreq/amd-pstate.c |  3 ++-
 include/acpi/cppc_acpi.h     |  6 +++---
 3 files changed, 16 insertions(+), 11 deletions(-)

diff --git a/drivers/acpi/cppc_acpi.c b/drivers/acpi/cppc_acpi.c
index e33ad70827429..8ad6d12b77727 100644
--- a/drivers/acpi/cppc_acpi.c
+++ b/drivers/acpi/cppc_acpi.c
@@ -1610,23 +1610,27 @@ int cppc_set_epp_perf(int cpu, struct cppc_perf_ctrls *perf_ctrls, bool enable)
 EXPORT_SYMBOL_GPL(cppc_set_epp_perf);
 
 /**
- * cppc_get_auto_sel_caps - Read autonomous selection register.
- * @cpunum : CPU from which to read register.
- * @perf_caps : struct where autonomous selection register value is updated.
+ * cppc_get_auto_sel() - Read autonomous selection register.
+ * @cpu: CPU from which to read register.
+ * @enable: Return address.
  */
-int cppc_get_auto_sel_caps(int cpunum, struct cppc_perf_caps *perf_caps)
+int cppc_get_auto_sel(int cpu, bool *enable)
 {
 	u64 auto_sel;
 	int ret;
 
-	ret = cppc_get_reg_val(cpunum, AUTO_SEL_ENABLE, &auto_sel);
+	if (enable == NULL)
+		return -EINVAL;
+
+	ret = cppc_get_reg_val(cpu, AUTO_SEL_ENABLE, &auto_sel);
 	if (ret)
 		return ret;
 
-	perf_caps->auto_sel = (bool)auto_sel;
+	*enable = (bool)auto_sel;
+
 	return 0;
 }
-EXPORT_SYMBOL_GPL(cppc_get_auto_sel_caps);
+EXPORT_SYMBOL_GPL(cppc_get_auto_sel);
 
 /**
  * cppc_set_auto_sel - Write autonomous selection register.
diff --git a/drivers/cpufreq/amd-pstate.c b/drivers/cpufreq/amd-pstate.c
index de687d073b7b2..5806bcc18517a 100644
--- a/drivers/cpufreq/amd-pstate.c
+++ b/drivers/cpufreq/amd-pstate.c
@@ -393,6 +393,7 @@ static int cppc_init_perf(struct amd_cpudata *cpudata)
 {
 	struct cppc_perf_caps cppc_perf;
 	u64 numerator;
+	bool auto_sel;
 
 	int ret = cppc_get_perf_caps(cpudata->cpu, &cppc_perf);
 	if (ret)
@@ -414,7 +415,7 @@ static int cppc_init_perf(struct amd_cpudata *cpudata)
 	if (cppc_state == AMD_PSTATE_ACTIVE)
 		return 0;
 
-	ret = cppc_get_auto_sel_caps(cpudata->cpu, &cppc_perf);
+	ret = cppc_get_auto_sel(cpudata->cpu, &auto_sel);
 	if (ret) {
 		pr_warn("failed to get auto_sel, ret: %d\n", ret);
 		return 0;
diff --git a/include/acpi/cppc_acpi.h b/include/acpi/cppc_acpi.h
index 62d368bcd9eca..31767c65be20c 100644
--- a/include/acpi/cppc_acpi.h
+++ b/include/acpi/cppc_acpi.h
@@ -159,7 +159,7 @@ extern int cpc_read_ffh(int cpunum, struct cpc_reg *reg, u64 *val);
 extern int cpc_write_ffh(int cpunum, struct cpc_reg *reg, u64 val);
 extern int cppc_get_epp_perf(int cpunum, u64 *epp_perf);
 extern int cppc_set_epp_perf(int cpu, struct cppc_perf_ctrls *perf_ctrls, bool enable);
-extern int cppc_get_auto_sel_caps(int cpunum, struct cppc_perf_caps *perf_caps);
+extern int cppc_get_auto_sel(int cpu, bool *enable);
 extern int cppc_set_auto_sel(int cpu, bool enable);
 extern int amd_get_highest_perf(unsigned int cpu, u32 *highest_perf);
 extern int amd_get_boost_ratio_numerator(unsigned int cpu, u64 *numerator);
@@ -229,11 +229,11 @@ static inline int cppc_get_epp_perf(int cpunum, u64 *epp_perf)
 {
 	return -EOPNOTSUPP;
 }
-static inline int cppc_set_auto_sel(int cpu, bool enable)
+static inline int cppc_get_auto_sel(int cpu, bool *enable)
 {
 	return -EOPNOTSUPP;
 }
-static inline int cppc_get_auto_sel_caps(int cpunum, struct cppc_perf_caps *perf_caps)
+static inline int cppc_set_auto_sel(int cpu, bool enable)
 {
 	return -EOPNOTSUPP;
 }
-- 
2.53.0



