Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794585354;
	b=ERKBCWIzM+Utt+y1kapLh7roLXz8Au9c57WmsG5rI2vPAL9GMZBjuCfwu8SMWKAetmPV
	 TJlJwmWdZPC/JxHjqGNOOYRpPJDi4oPdFBicyhvkA1fjKAEVb4eh5de1c3Su/smegwqlU
	 NE50vTVAggkeUPy2Fo2sY9jKHwAhiQjqTB5Z69LafAjQFYX4DPrJDckJqrkWkfxcy4wSE
	 tsbMZhTSTX86DNZmryI9E5EY/aPSqEI/Vy9sNgG73eyrvKyq6o54NPnFnXjl1t4mTkuft
	 Tfuq7V5vsE3DxNrv1k96rsAvBq2BJFjGWziL+kShNOT6/HWKZnpLtkxnL9DbOvOhOPw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794585354;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ntEQq6DbPmN/S3iwwtNMCJPHPZG7zKj+xQmfG7hXjDk=;
	b=wXRByWY7R0UeiE8iF3pJ8OEc6pFyjlX6QDAlartaqEYvSb/aPDGy8f0EURH65Lt0mHPS
	 6vCi4VdybdwLPmU8RTBiRi+NPr/hQGL6TEe0CJJdd1SB8lkon/Cr+17UV30AQ+BY6Sdmw
	 A60bIJAI86a6S5nMf2nmAxmT2pEGNLyPs1BVXB9/RmNxE6ZGsvIosNAAGD8mb3twJhWd7
	 io6dzjq502wDnRDP+P6kUNGZ4ceusdvRnSmXFw2PmBK0QYrGSKMRMXi1o6Y2Z2QKbl+2N
	 1DvYa+fSUJ7JKB4hnHWSF9ZasKCj/r5yVtjEVuMZdjLdDMqZsbXrLWRVv79qV4WOAmA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=MXv0J4S6;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 21F9E606A8AA;
	Fri, 13 Nov 2026 15:55:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=MXv0J4S6
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C25541F00937;
	Fri, 13 Nov 2026 15:55:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794585354;
	bh=ntEQq6DbPmN/S3iwwtNMCJPHPZG7zKj+xQmfG7hXjDk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=MXv0J4S6owkh+2b7Ekg23/nHVXC2Ivi5k3On6EHG4WwCen5NVfmlGvJ6t9N2AtewL
	 m/Ou+ZfR8oZcQqMolGorvHBw3irlec+o3TdMVWgJmE6njR83Se/MzYE0MUGAWGOFua
	 JkI21/emfhggtAhOcggZh7WhA7TgLPpNFl5ipi1M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christian Loehle <christian.loehle@arm.com>,
	Sumit Gupta <sumitg@nvidia.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 034/507] ACPI: CPPC: Validate FFH register fields before hardware access
Date: Fri, 13 Nov 2026 10:45:38 -0500
Message-ID: <20261113153754.595209730@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153753.358973689@linuxfoundation.org>
References: <20261113153753.358973689@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Christian Loehle <christian.loehle@arm.com>

commit 6b016c5c96448c0a5f09328d37f66562d154a5e5 upstream.

The x86 CPPC FFH accessors construct masks and shift values using the
firmware's Bit Width and Bit Offset without checking that the field fits
in an MSR. A zero-width field or a field extending beyond bit 63 can
therefore cause an invalid shift. The safe MSR accessors only handle an
access fault, not invalid field arithmetic after a successful read.

Also, the 64-bit GAS address is implicitly narrowed to the 32-bit MSR
number. A descriptor with nonzero upper address bits can access a different
MSR from the one described by firmware.

The arm64 AMU counter readers have the same unchecked field arithmetic.
Validate the field bounds before reading a counter, including both
descriptors in the paired counter path.

Dispatch FFH accesses before decoding the GAS Access Size in the common
read and write paths. Otherwise, a large access_width can trigger an
invalid shift in GET_BIT_WIDTH() before the architecture validates its
register. That field has architecture-specific FFH semantics and is not
needed by the generic memory/port accessor on this path.

Validate x86 MSR addresses and share the field-bounds checks between
related accessors within each architecture.

Fixes: a6cbcdd5ab5f ("ACPI / CPPC: Add support for functional fixed hardware address")
Fixes: 68c5debcc06d ("arm64: implement CPPC FFH support using AMUs")
Fixes: f489c948028b ("ACPI: CPPC: Fix access width used for PCC registers")
Cc: All applicable <stable@vger.kernel.org>
Signed-off-by: Christian Loehle <christian.loehle@arm.com>
Tested-by: Sumit Gupta <sumitg@nvidia.com>
Link: https://patch.msgid.link/20260916162805.1039247-17-christian.loehle@arm.com
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Christian Loehle <christian.loehle@arm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/kernel/topology.c | 12 +++++++++++-
 arch/x86/kernel/acpi/cppc.c  | 15 +++++++++++++++
 drivers/acpi/cppc_acpi.c     | 10 ++++++----
 3 files changed, 32 insertions(+), 5 deletions(-)

diff --git a/arch/arm64/kernel/topology.c b/arch/arm64/kernel/topology.c
index b8baba2811666..44305b997a026 100644
--- a/arch/arm64/kernel/topology.c
+++ b/arch/arm64/kernel/topology.c
@@ -470,6 +470,12 @@ static void amu_read_core_const_ctrs(void *val)
 	cpu_read_corecnt(&ctrs->corecnt);
 }
 
+static bool cpc_ffh_reg_valid(const struct cpc_reg *reg)
+{
+	return reg->bit_width && reg->bit_width <= 64 &&
+	       reg->bit_offset <= 64 - reg->bit_width;
+}
+
 static u64 cpc_ffh_extract_bits(const struct cpc_reg *reg, u64 val)
 {
 	val &= GENMASK_ULL(reg->bit_offset + reg->bit_width - 1,
@@ -506,7 +512,8 @@ int cpc_read_ffh_fb_ctrs(int cpu, struct cpc_reg *reg1, u64 *val1,
 	struct amu_ffh_ctrs ctrs;
 	int ret;
 
-	if (!is_amu_ctr_reg(reg1) || !is_amu_ctr_reg(reg2))
+	if (!is_amu_ctr_reg(reg1) || !is_amu_ctr_reg(reg2) ||
+	    !cpc_ffh_reg_valid(reg1) || !cpc_ffh_reg_valid(reg2))
 		return -EINVAL;
 
 	ret = counters_read_on_cpu(cpu, amu_read_core_const_ctrs, &ctrs);
@@ -530,6 +537,9 @@ int cpc_read_ffh(int cpu, struct cpc_reg *reg, u64 *val)
 {
 	int ret = -EOPNOTSUPP;
 
+	if (!cpc_ffh_reg_valid(reg))
+		return -EINVAL;
+
 	switch ((u64)reg->address) {
 	case CPC_FFH_CTR_CORE:
 		ret = counters_read_on_cpu(cpu, cpu_read_corecnt, val);
diff --git a/arch/x86/kernel/acpi/cppc.c b/arch/x86/kernel/acpi/cppc.c
index bbade0da5130f..174b734e82614 100644
--- a/arch/x86/kernel/acpi/cppc.c
+++ b/arch/x86/kernel/acpi/cppc.c
@@ -6,6 +6,8 @@
 
 #include <linux/bitfield.h>
 
+#include <linux/limits.h>
+
 #include <acpi/cppc_acpi.h>
 #include <asm/msr.h>
 #include <asm/processor.h>
@@ -45,10 +47,20 @@ bool cpc_ffh_supported(void)
 	return true;
 }
 
+static bool cpc_ffh_reg_valid(const struct cpc_reg *reg)
+{
+	return reg->address <= U32_MAX && reg->bit_width &&
+	       reg->bit_width <= 64 &&
+	       reg->bit_offset <= 64 - reg->bit_width;
+}
+
 int cpc_read_ffh(int cpunum, struct cpc_reg *reg, u64 *val)
 {
 	int err;
 
+	if (!cpc_ffh_reg_valid(reg))
+		return -EINVAL;
+
 	err = rdmsrq_safe_on_cpu(cpunum, reg->address, val);
 	if (!err) {
 		u64 mask = GENMASK_ULL(reg->bit_offset + reg->bit_width - 1,
@@ -65,6 +77,9 @@ int cpc_write_ffh(int cpunum, struct cpc_reg *reg, u64 val)
 	u64 rd_val;
 	int err;
 
+	if (!cpc_ffh_reg_valid(reg))
+		return -EINVAL;
+
 	err = rdmsrq_safe_on_cpu(cpunum, reg->address, &rd_val);
 	if (!err) {
 		u64 mask = GENMASK_ULL(reg->bit_offset + reg->bit_width - 1,
diff --git a/drivers/acpi/cppc_acpi.c b/drivers/acpi/cppc_acpi.c
index fef54fcd00b78..dc9e1c1fb071e 100644
--- a/drivers/acpi/cppc_acpi.c
+++ b/drivers/acpi/cppc_acpi.c
@@ -1133,6 +1133,9 @@ static int cpc_read(int cpu, struct cpc_register_resource *reg_res, u64 *val)
 	}
 
 	*val = 0;
+	if (reg->space_id == ACPI_ADR_SPACE_FIXED_HARDWARE)
+		return cpc_read_ffh(cpu, reg, val);
+
 	size = GET_BIT_WIDTH(reg);
 
 	if (IS_ENABLED(CONFIG_HAS_IOPORT) &&
@@ -1160,8 +1163,6 @@ static int cpc_read(int cpu, struct cpc_register_resource *reg_res, u64 *val)
 	}
 	else if (reg->space_id == ACPI_ADR_SPACE_SYSTEM_MEMORY)
 		vaddr = reg_res->sys_mem_vaddr;
-	else if (reg->space_id == ACPI_ADR_SPACE_FIXED_HARDWARE)
-		return cpc_read_ffh(cpu, reg, val);
 	else
 		return acpi_os_read_memory((acpi_physical_address)reg->address,
 				val, size);
@@ -1208,6 +1209,9 @@ static int cpc_write(int cpu, struct cpc_register_resource *reg_res, u64 val)
 	unsigned long flags;
 	bool locked = false;
 
+	if (reg->space_id == ACPI_ADR_SPACE_FIXED_HARDWARE)
+		return cpc_write_ffh(cpu, reg, val);
+
 	size = GET_BIT_WIDTH(reg);
 
 	if (IS_ENABLED(CONFIG_HAS_IOPORT) &&
@@ -1233,8 +1237,6 @@ static int cpc_write(int cpu, struct cpc_register_resource *reg_res, u64 val)
 	}
 	else if (reg->space_id == ACPI_ADR_SPACE_SYSTEM_MEMORY)
 		vaddr = reg_res->sys_mem_vaddr;
-	else if (reg->space_id == ACPI_ADR_SPACE_FIXED_HARDWARE)
-		return cpc_write_ffh(cpu, reg, val);
 	else
 		return acpi_os_write_memory((acpi_physical_address)reg->address,
 				val, size);
-- 
2.53.0



