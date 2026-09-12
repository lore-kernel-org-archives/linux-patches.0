Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BCC7642586B;
	Sat, 12 Sep 2026 12:30:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789216249; cv=none; b=FAxu4LDzESXgxoiLDaSIDBlEu90l6A2hsvFg8p0H67YcJ99YT9cm688ftNWOufwHMuz3kABW1IJFoy1r2J7Kdd2d0PU/BZhK6macMFDrlBACFi3lNipowTPkjg3CufiOZZFfW0pcZiSZ57auSkmRa+3TgfzOK01X1d5qTtmn+7w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789216249; c=relaxed/simple;
	bh=hwKVc3FnxGrMcoEP4/hedApDA4eQu6YaCTp00SRo41U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=shRwYzGUNPn/Ah8nTkgaiL38zjgg3dGaKz5vM/QmYol8dRBgkYsRCnYT+7ii7g9Sg3wY7G7SYLeA61Ym4+MchFCQyIqQvhRreWUdW97u6rBnjDQtB3jf1uGONeJa4Abtxc0t1+rI5jVYNeJ3AZScvX9Xd0B+xpUHcOcwBr7V3fw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TmwYDYAi; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TmwYDYAi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 740B81F000FF;
	Sat, 12 Sep 2026 12:30:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789216248;
	bh=jXSe/JZZ4hgOukscKCVfLVo8MIV4pGcSLCRoVYkvw5k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=TmwYDYAi8F2A5EymPShC+f1D07lvT7pX0GwlLF45fxe74Bb7f9wp6KQ8M7c+WNFUL
	 OkZxvssKuA9ToLXNJdt7mzUmEewQx0OAu/vxt8lgU8eZ78ZCWZjCPszGFOMmy7g1VB
	 1LaNMwWHlED2FsHljZJKcqH9EPELuR6/Dt+Tz9g0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pierre Gondois <pierre.gondois@arm.com>,
	Lifeng Zheng <zhenglifeng1@huawei.com>,
	Mario Limonciello <mario.limonciello@amd.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0656/1376] ACPI: CPPC: Rename cppc_get_perf() to cppc_get_reg_val()
Date: Sat, 12 Sep 2026 08:51:22 +0200
Message-ID: <20260912065622.162150591@linuxfoundation.org>
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

[ Upstream commit 714d103ce868cd0718d0e5262cbc76384a2eb03a ]

Rename cppc_get_perf() to cppc_get_reg_val() as a generic function to
read CPPC registers.

Reviewed-by: Pierre Gondois <pierre.gondois@arm.com>
Signed-off-by: Lifeng Zheng <zhenglifeng1@huawei.com>
Reviewed-by: Mario Limonciello <mario.limonciello@amd.com>
Link: https://patch.msgid.link/20250411093855.982491-4-zhenglifeng1@huawei.com
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Stable-dep-of: 9dfd13f80c85 ("cpufreq/amd-pstate: Toggle auto_sel in active mode on shared memory systems")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/acpi/cppc_acpi.c | 22 +++++++++++-----------
 1 file changed, 11 insertions(+), 11 deletions(-)

diff --git a/drivers/acpi/cppc_acpi.c b/drivers/acpi/cppc_acpi.c
index 1d857af8e7176..28c8ec2b38aac 100644
--- a/drivers/acpi/cppc_acpi.c
+++ b/drivers/acpi/cppc_acpi.c
@@ -1190,16 +1190,16 @@ static int cpc_write(int cpu, struct cpc_register_resource *reg_res, u64 val)
 	return ret_val;
 }
 
-static int cppc_get_perf(int cpunum, enum cppc_regs reg_idx, u64 *perf)
+static int cppc_get_reg_val(int cpu, enum cppc_regs reg_idx, u64 *val)
 {
-	struct cpc_desc *cpc_desc = per_cpu(cpc_desc_ptr, cpunum);
+	struct cpc_desc *cpc_desc = per_cpu(cpc_desc_ptr, cpu);
 	struct cpc_register_resource *reg;
 
-	if (perf == NULL)
+	if (val == NULL)
 		return -EINVAL;
 
 	if (!cpc_desc) {
-		pr_debug("No CPC descriptor for CPU:%d\n", cpunum);
+		pr_debug("No CPC descriptor for CPU:%d\n", cpu);
 		return -ENODEV;
 	}
 
@@ -1213,7 +1213,7 @@ static int cppc_get_perf(int cpunum, enum cppc_regs reg_idx, u64 *perf)
 	}
 
 	if (CPC_IN_PCC(reg)) {
-		int pcc_ss_id = per_cpu(cpu_pcc_subspace_idx, cpunum);
+		int pcc_ss_id = per_cpu(cpu_pcc_subspace_idx, cpu);
 		struct cppc_pcc_data *pcc_ss_data = NULL;
 		int ret;
 
@@ -1227,7 +1227,7 @@ static int cppc_get_perf(int cpunum, enum cppc_regs reg_idx, u64 *perf)
 		down_write(&pcc_ss_data->pcc_lock);
 
 		if (send_pcc_cmd(pcc_ss_id, CMD_READ) >= 0)
-			ret = cpc_read(cpunum, reg, perf);
+			ret = cpc_read(cpu, reg, val);
 		else
 			ret = -EIO;
 
@@ -1236,7 +1236,7 @@ static int cppc_get_perf(int cpunum, enum cppc_regs reg_idx, u64 *perf)
 		return ret;
 	}
 
-	return cpc_read(cpunum, reg, perf);
+	return cpc_read(cpu, reg, val);
 }
 
 /**
@@ -1248,7 +1248,7 @@ static int cppc_get_perf(int cpunum, enum cppc_regs reg_idx, u64 *perf)
  */
 int cppc_get_desired_perf(int cpunum, u64 *desired_perf)
 {
-	return cppc_get_perf(cpunum, DESIRED_PERF, desired_perf);
+	return cppc_get_reg_val(cpunum, DESIRED_PERF, desired_perf);
 }
 EXPORT_SYMBOL_GPL(cppc_get_desired_perf);
 
@@ -1261,7 +1261,7 @@ EXPORT_SYMBOL_GPL(cppc_get_desired_perf);
  */
 int cppc_get_nominal_perf(int cpunum, u64 *nominal_perf)
 {
-	return cppc_get_perf(cpunum, NOMINAL_PERF, nominal_perf);
+	return cppc_get_reg_val(cpunum, NOMINAL_PERF, nominal_perf);
 }
 
 /**
@@ -1273,7 +1273,7 @@ int cppc_get_nominal_perf(int cpunum, u64 *nominal_perf)
  */
 int cppc_get_highest_perf(int cpunum, u64 *highest_perf)
 {
-	return cppc_get_perf(cpunum, HIGHEST_PERF, highest_perf);
+	return cppc_get_reg_val(cpunum, HIGHEST_PERF, highest_perf);
 }
 EXPORT_SYMBOL_GPL(cppc_get_highest_perf);
 
@@ -1286,7 +1286,7 @@ EXPORT_SYMBOL_GPL(cppc_get_highest_perf);
  */
 int cppc_get_epp_perf(int cpunum, u64 *epp_perf)
 {
-	return cppc_get_perf(cpunum, ENERGY_PERF, epp_perf);
+	return cppc_get_reg_val(cpunum, ENERGY_PERF, epp_perf);
 }
 EXPORT_SYMBOL_GPL(cppc_get_epp_perf);
 
-- 
2.53.0



