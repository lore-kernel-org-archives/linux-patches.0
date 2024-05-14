Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6EA0CF9D4;
	Tue, 14 May 2024 11:57:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715687873; cv=none; b=fq4NppXNPSD95D3OOSGaCZFnkedSa80CheXMSDUyh0hgVUZF1Oh45WT3RuYlQEuHM3t+qBhHydJ5fBG2ShAejKjqGSbLG4n8igghb5dqZp63LmsFqZVpgFLLaOOrFwo4mW7AfqOy97n+XBfmamRqSst9dphci23eosPYCrLpfyA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715687873; c=relaxed/simple;
	bh=3/A9RiK5TsC67+gtH6OoVtXsAv8w6Af6DAvKViPt+mE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Nj5UpwdYf63PKh4RzfDDj4h2DVDb4Ar2KUZsyouFacFxag/G1cTeSzj+AuMf9klyhjThUCJf869+b98lbJ8LsjLkUKB1R9cWSYrMomtlwopYUJsWMMGsqGodg8ebWGrXbk5S3njZzoAtgizIurVavc9z6nXL22nmSdtJMYuGnBs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CXJtH3NG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CXJtH3NG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E74E9C2BD10;
	Tue, 14 May 2024 11:57:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1715687873;
	bh=3/A9RiK5TsC67+gtH6OoVtXsAv8w6Af6DAvKViPt+mE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CXJtH3NGPdw02rywGgZ/bGp7JinS0vBR5J+6lYJl8iVQHdoxmlB82sCCQRRUSoe8U
	 cX94nJCkUkpOoqFNS7OcQDKTWxReb98lSS+YOtLWjOgSy0yhAJF05753pzkXmXYEl9
	 ap0JpWmRwtD90ps3D3O8IBH0aHYbpewnXiHQJ3Aw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jarred White <jarredwhite@linux.microsoft.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Vanshidhar Konda <vanshikonda@os.amperecomputing.com>,
	Easwar Hariharan <eahariha@linux.microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 134/168] Revert "Revert "ACPI: CPPC: Use access_width over bit_width for system memory accesses""
Date: Tue, 14 May 2024 12:20:32 +0200
Message-ID: <20240514101011.741736314@linuxfoundation.org>
X-Mailer: git-send-email 2.45.0
In-Reply-To: <20240514101006.678521560@linuxfoundation.org>
References: <20240514101006.678521560@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Easwar Hariharan <eahariha@linux.microsoft.com>

This reverts commit b54c4632946ae42f2b39ed38abd909bbf78cbcc2 which was a
revert of a backport of commit 2f4a4d63a193be6fd530d180bb13c3592052904c
upstream to 5.15.y.

Cc: Jarred White <jarredwhite@linux.microsoft.com>
Cc: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Cc: Vanshidhar Konda <vanshikonda@os.amperecomputing.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Easwar Hariharan <eahariha@linux.microsoft.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/acpi/cppc_acpi.c | 27 ++++++++++++++++++++++++---
 1 file changed, 24 insertions(+), 3 deletions(-)

diff --git a/drivers/acpi/cppc_acpi.c b/drivers/acpi/cppc_acpi.c
index 7cc9183c8dc8e..408b1fda5702d 100644
--- a/drivers/acpi/cppc_acpi.c
+++ b/drivers/acpi/cppc_acpi.c
@@ -161,6 +161,13 @@ show_cppc_data(cppc_get_perf_caps, cppc_perf_caps, nominal_freq);
 show_cppc_data(cppc_get_perf_ctrs, cppc_perf_fb_ctrs, reference_perf);
 show_cppc_data(cppc_get_perf_ctrs, cppc_perf_fb_ctrs, wraparound_time);
 
+/* Check for valid access_width, otherwise, fallback to using bit_width */
+#define GET_BIT_WIDTH(reg) ((reg)->access_width ? (8 << ((reg)->access_width - 1)) : (reg)->bit_width)
+
+/* Shift and apply the mask for CPC reads/writes */
+#define MASK_VAL(reg, val) ((val) >> ((reg)->bit_offset & 			\
+					GENMASK(((reg)->bit_width), 0)))
+
 static ssize_t show_feedback_ctrs(struct kobject *kobj,
 		struct kobj_attribute *attr, char *buf)
 {
@@ -762,8 +769,10 @@ int acpi_cppc_processor_probe(struct acpi_processor *pr)
 			} else if (gas_t->space_id == ACPI_ADR_SPACE_SYSTEM_MEMORY) {
 				if (gas_t->address) {
 					void __iomem *addr;
+					size_t access_width;
 
-					addr = ioremap(gas_t->address, gas_t->bit_width/8);
+					access_width = GET_BIT_WIDTH(gas_t) / 8;
+					addr = ioremap(gas_t->address, access_width);
 					if (!addr)
 						goto out_free;
 					cpc_ptr->cpc_regs[i-2].sys_mem_vaddr = addr;
@@ -936,6 +945,7 @@ static int cpc_read(int cpu, struct cpc_register_resource *reg_res, u64 *val)
 {
 	int ret_val = 0;
 	void __iomem *vaddr = NULL;
+	int size;
 	int pcc_ss_id = per_cpu(cpu_pcc_subspace_idx, cpu);
 	struct cpc_reg *reg = &reg_res->cpc_entry.reg;
 
@@ -955,7 +965,9 @@ static int cpc_read(int cpu, struct cpc_register_resource *reg_res, u64 *val)
 		return acpi_os_read_memory((acpi_physical_address)reg->address,
 				val, reg->bit_width);
 
-	switch (reg->bit_width) {
+	size = GET_BIT_WIDTH(reg);
+
+	switch (size) {
 	case 8:
 		*val = readb_relaxed(vaddr);
 		break;
@@ -974,12 +986,16 @@ static int cpc_read(int cpu, struct cpc_register_resource *reg_res, u64 *val)
 		ret_val = -EFAULT;
 	}
 
+	if (reg->space_id == ACPI_ADR_SPACE_SYSTEM_MEMORY)
+		*val = MASK_VAL(reg, *val);
+
 	return ret_val;
 }
 
 static int cpc_write(int cpu, struct cpc_register_resource *reg_res, u64 val)
 {
 	int ret_val = 0;
+	int size;
 	void __iomem *vaddr = NULL;
 	int pcc_ss_id = per_cpu(cpu_pcc_subspace_idx, cpu);
 	struct cpc_reg *reg = &reg_res->cpc_entry.reg;
@@ -994,7 +1010,12 @@ static int cpc_write(int cpu, struct cpc_register_resource *reg_res, u64 val)
 		return acpi_os_write_memory((acpi_physical_address)reg->address,
 				val, reg->bit_width);
 
-	switch (reg->bit_width) {
+	size = GET_BIT_WIDTH(reg);
+
+	if (reg->space_id == ACPI_ADR_SPACE_SYSTEM_MEMORY)
+		val = MASK_VAL(reg, val);
+
+	switch (size) {
 	case 8:
 		writeb_relaxed(val, vaddr);
 		break;
-- 
2.43.0



