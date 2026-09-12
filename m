Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8479F47A87A;
	Sat, 12 Sep 2026 12:30:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789216244; cv=none; b=LTR6pMz0tl4Os3oU0t2eQ2HJwh0xfjiGCKynsTtgCwpnXMJdv78mJNg4SUDoEqW3dEFwK4XEiBOmDqLeA2UJfNeCR0MIR2GbSbQLmJExTfRVHaA+7XvnRLGPoAjjB2uiV6bNCrymU8JTFjgpPBC9u74ys1ileRgwjJltWowl3oE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789216244; c=relaxed/simple;
	bh=LCo3Q3STR/HqVU1TwPjuSSTnpLmAsSXxJ+FoAjeji7E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=O22WZQsTOXk0Y6hyrfxVIMxH2KfJHL5KqqlXyxc5Iih7UBJoKnsLLBrb9aNjjhmXIJU2vEOaIBydKM0OQNoxpuzst9IZYOi1ZKROcF8bt5mWnyOLopsnFIBLPL3u6RkLReGzQbSNoVKOQcJEwvJS5h82dHbSytSNDdLCzeJrvRY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=akjpng/r; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="akjpng/r"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 701331F000FF;
	Sat, 12 Sep 2026 12:30:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789216243;
	bh=mDZU2Hg/Jh3o2H1ske3ZVQnUqZ9RcnWPEk7AoIUS+zQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=akjpng/rLaUlgs6daCNLKyeuzHe5m6FSAFNlz0ueuzZNNxTIMPEDb9pXp+ksMA4ZG
	 0SFoKRWwHu9vp/CW6mXytMGJs6dGykm4+BDMWvwTIF4zBTK7wkBA4K2QmVUPLHPhjb
	 i9xbkx1FdY+ExM8boyYh6O9PybdEEf5yV2fe6Kz4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pierre Gondois <pierre.gondois@arm.com>,
	Lifeng Zheng <zhenglifeng1@huawei.com>,
	Mario Limonciello <mario.limonciello@amd.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0655/1376] ACPI: CPPC: Optimize cppc_get_perf()
Date: Sat, 12 Sep 2026 08:51:21 +0200
Message-ID: <20260912065622.140611521@linuxfoundation.org>
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

[ Upstream commit 45f3763a2122553e548fa0430b77605dc23f00cc ]

Optimize cppc_get_perf() with three changes:

 1. Change the error kind to "no such device" when pcc_ss_id < 0, as
    other register value getting functions.

 2. Add a check to ensure the pointer 'perf' is no null.

 3. Add a check to verify if the register is supported to be read before
    using it. The logic is:

    (1) If the register is of the integer type, check whether the
        register is optional and its value is 0. If yes, the register
        is not supported.

    (2) If the register is of other types, a null one is not supported.

 4. Return the result of cpc_read() instead of 0.

Reviewed-by: Pierre Gondois <pierre.gondois@arm.com>
Signed-off-by: Lifeng Zheng <zhenglifeng1@huawei.com>
Reviewed-by: Mario Limonciello <mario.limonciello@amd.com>
Link: https://patch.msgid.link/20250411093855.982491-3-zhenglifeng1@huawei.com
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Stable-dep-of: 9dfd13f80c85 ("cpufreq/amd-pstate: Toggle auto_sel in active mode on shared memory systems")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/acpi/cppc_acpi.c | 24 +++++++++++++++++-------
 1 file changed, 17 insertions(+), 7 deletions(-)

diff --git a/drivers/acpi/cppc_acpi.c b/drivers/acpi/cppc_acpi.c
index 9f158353b3603..1d857af8e7176 100644
--- a/drivers/acpi/cppc_acpi.c
+++ b/drivers/acpi/cppc_acpi.c
@@ -1195,6 +1195,9 @@ static int cppc_get_perf(int cpunum, enum cppc_regs reg_idx, u64 *perf)
 	struct cpc_desc *cpc_desc = per_cpu(cpc_desc_ptr, cpunum);
 	struct cpc_register_resource *reg;
 
+	if (perf == NULL)
+		return -EINVAL;
+
 	if (!cpc_desc) {
 		pr_debug("No CPC descriptor for CPU:%d\n", cpunum);
 		return -ENODEV;
@@ -1202,20 +1205,29 @@ static int cppc_get_perf(int cpunum, enum cppc_regs reg_idx, u64 *perf)
 
 	reg = &cpc_desc->cpc_regs[reg_idx];
 
+	if ((reg->type == ACPI_TYPE_INTEGER && IS_OPTIONAL_CPC_REG(reg_idx) &&
+	     !reg->cpc_entry.int_value) || (reg->type != ACPI_TYPE_INTEGER &&
+	     IS_NULL_REG(&reg->cpc_entry.reg))) {
+		pr_debug("CPC register is not supported\n");
+		return -EOPNOTSUPP;
+	}
+
 	if (CPC_IN_PCC(reg)) {
 		int pcc_ss_id = per_cpu(cpu_pcc_subspace_idx, cpunum);
 		struct cppc_pcc_data *pcc_ss_data = NULL;
-		int ret = 0;
+		int ret;
 
-		if (pcc_ss_id < 0)
-			return -EIO;
+		if (pcc_ss_id < 0) {
+			pr_debug("Invalid pcc_ss_id\n");
+			return -ENODEV;
+		}
 
 		pcc_ss_data = pcc_data[pcc_ss_id];
 
 		down_write(&pcc_ss_data->pcc_lock);
 
 		if (send_pcc_cmd(pcc_ss_id, CMD_READ) >= 0)
-			cpc_read(cpunum, reg, perf);
+			ret = cpc_read(cpunum, reg, perf);
 		else
 			ret = -EIO;
 
@@ -1224,9 +1236,7 @@ static int cppc_get_perf(int cpunum, enum cppc_regs reg_idx, u64 *perf)
 		return ret;
 	}
 
-	cpc_read(cpunum, reg, perf);
-
-	return 0;
+	return cpc_read(cpunum, reg, perf);
 }
 
 /**
-- 
2.53.0



