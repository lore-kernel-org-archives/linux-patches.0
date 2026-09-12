Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 30C6142586B;
	Sat, 12 Sep 2026 12:30:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789216254; cv=none; b=iq1ZjE21/Vbm3BszYOt/o9dZucH9GXr9NBMhdKhn42EPrvixBto5u6O1/LcKbRJ/jLf66kxjBjhu0zNzrQe3AdTVL+6aa0M+rDvPPJ2JdjSO9ajqwj2WUim99eobWdR8ZKCK0/3ISMcKKn1ebOu5w8b0GC67Z5qAgKlH/KkIBrM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789216254; c=relaxed/simple;
	bh=LqPvemgAb8L08JtlY2TZD3evBIezYUkbfjedlFQ/UqE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=W4Ynt8qAtBT3xJRoQbLph0zzD8lg61NnnTxNV+zJMT4VtWEJ+asllvoumf2sNjSt7CH3pQXqSCixiD7OFij0vsZyOcNq2Meqd8sfsqP9f9RbwxeWEFBVgj6IlvjOumj2dZtecrtVc0DQrOQlJDTGwhGNzJE6rTQrnGaJHCFWxVc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dLf0nxdc; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dLf0nxdc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 134AE1F000FF;
	Sat, 12 Sep 2026 12:30:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789216253;
	bh=fY+YVcnsyGLh1noHN0kPWTB4MIdIYAUSfNQcIdorY8Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=dLf0nxdcT8ydAFsUv3RG6pgb9Mf2H0e8hBCN5piFxrHtiNUz+c+LF9iOu68wWe/zh
	 vXYVGZWtHfBRDQtq66fuy51m1Wdp7DkcSYr01f3SN1sDDt3RtwtsNML59vEzd7lROF
	 xTWwOflZYG1AXqpMx/fYE49iDmqG/lwbcl5dPO4s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pierre Gondois <pierre.gondois@arm.com>,
	Lifeng Zheng <zhenglifeng1@huawei.com>,
	Mario Limonciello <mario.limonciello@amd.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0657/1376] ACPI: CPPC: Add cppc_set_reg_val()
Date: Sat, 12 Sep 2026 08:51:23 +0200
Message-ID: <20260912065622.184135080@linuxfoundation.org>
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

[ Upstream commit e05c75072c2eaa6e0b152a558b3be5cbcf79a587 ]

Add cppc_set_reg_val() as a generic function for setting CPPC register
values, with this features:

 1. Check register. If a register is writeable, it must be a buffer and
    can not be null.

 2. Extract the operations if register is in PCC out as
    cppc_set_reg_val_in_pcc().

This function can be used to reduce some existing code duplication.

Reviewed-by: Pierre Gondois <pierre.gondois@arm.com>
Signed-off-by: Lifeng Zheng <zhenglifeng1@huawei.com>
Reviewed-by: Mario Limonciello <mario.limonciello@amd.com>
Link: https://patch.msgid.link/20250411093855.982491-6-zhenglifeng1@huawei.com
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Stable-dep-of: 9dfd13f80c85 ("cpufreq/amd-pstate: Toggle auto_sel in active mode on shared memory systems")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/acpi/cppc_acpi.c | 49 ++++++++++++++++++++++++++++++++++++++++
 1 file changed, 49 insertions(+)

diff --git a/drivers/acpi/cppc_acpi.c b/drivers/acpi/cppc_acpi.c
index 28c8ec2b38aac..52306eec1cca8 100644
--- a/drivers/acpi/cppc_acpi.c
+++ b/drivers/acpi/cppc_acpi.c
@@ -1239,6 +1239,55 @@ static int cppc_get_reg_val(int cpu, enum cppc_regs reg_idx, u64 *val)
 	return cpc_read(cpu, reg, val);
 }
 
+static int cppc_set_reg_val_in_pcc(int cpu, struct cpc_register_resource *reg, u64 val)
+{
+	int pcc_ss_id = per_cpu(cpu_pcc_subspace_idx, cpu);
+	struct cppc_pcc_data *pcc_ss_data = NULL;
+	int ret;
+
+	if (pcc_ss_id < 0) {
+		pr_debug("Invalid pcc_ss_id\n");
+		return -ENODEV;
+	}
+
+	ret = cpc_write(cpu, reg, val);
+	if (ret)
+		return ret;
+
+	pcc_ss_data = pcc_data[pcc_ss_id];
+
+	down_write(&pcc_ss_data->pcc_lock);
+	/* after writing CPC, transfer the ownership of PCC to platform */
+	ret = send_pcc_cmd(pcc_ss_id, CMD_WRITE);
+	up_write(&pcc_ss_data->pcc_lock);
+
+	return ret;
+}
+
+static int cppc_set_reg_val(int cpu, enum cppc_regs reg_idx, u64 val)
+{
+	struct cpc_desc *cpc_desc = per_cpu(cpc_desc_ptr, cpu);
+	struct cpc_register_resource *reg;
+
+	if (!cpc_desc) {
+		pr_debug("No CPC descriptor for CPU:%d\n", cpu);
+		return -ENODEV;
+	}
+
+	reg = &cpc_desc->cpc_regs[reg_idx];
+
+	/* if a register is writeable, it must be a buffer and not null */
+	if ((reg->type != ACPI_TYPE_BUFFER) || IS_NULL_REG(&reg->cpc_entry.reg)) {
+		pr_debug("CPC register is not supported\n");
+		return -EOPNOTSUPP;
+	}
+
+	if (CPC_IN_PCC(reg))
+		return cppc_set_reg_val_in_pcc(cpu, reg, val);
+
+	return cpc_write(cpu, reg, val);
+}
+
 /**
  * cppc_get_desired_perf - Get the desired performance register value.
  * @cpunum: CPU from which to get desired performance.
-- 
2.53.0



