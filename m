Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795053090;
	b=c2tbOf0yIAWm/dSa0T5vSyHohQI1vHelL4CUv8M+wwkVK+SNSnGv4yw2iLZ9eP/vLGxZ
	 TyrpW4BtS+9f349hD4bhnPhuN4J+i8Kc3cVjqz9kGxmyq+dy8aReLj/7Ak9FiC0DGjCBb
	 ppNv26U4f8Kn+cIZnrCVvgqG2xoDKOf89kLS6rrx2TeDl0NX3qve6rRVNzpMN7pKHmvMQ
	 8YJpe3NdO+fGfRp4imqrjEAjmRJciQH5pWx7oXQ4J7QOzyDjbzM+XzTCB//OblrqIPseW
	 2LOnnhLwl5OSzko1wv0ReYabDOnaHLT45KB+tOVkQmHork/jNakYuUMvTDqa5/iVEwg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795053090;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=xEuGVAVBOaisnKGwv6BJqfQUhqrpBoGe8gRxv7M41hQ=;
	b=zhBP2btu+wVcknuyEsE8OdZZGxsJCUPIGK2ZYdvKuHOc+eIkceZH2Tx9JKHhasP/COtH
	 KOH21yWC3GimidFZECANQb1TOjZLM7tVT6gRCQ6YAD/PNRa/e4hwDJQPI6r1jVUMfrZMJ
	 ObpHcG+YW4C80mbWUHlhxMzwGP6igQ5VDG98zCHmWxU6aZCK7vQD8BRo4cFWlZGAcKk3V
	 b25jBMMZ3mIFS67Lgl9mYq5Ua8BlgRaGvm4J6d3hRKFH5nbjC2ua80rchx7YlqXxkwgBe
	 YlZp3wf0OvU/PrKOIXoiQVXTv9kxffYx0bxlr9anpsYQtW8LYG6sxrDMedN+tvn9fhQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=c2r4ny9A;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7EB21606A320;
	Thu, 19 Nov 2026 01:51:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=c2r4ny9A
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8CAE41F000C4;
	Thu, 19 Nov 2026 01:51:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795053090;
	bh=xEuGVAVBOaisnKGwv6BJqfQUhqrpBoGe8gRxv7M41hQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=c2r4ny9Acd6Y7qmmB94+QqR9qYJfKZcbkYP3F0r8d+oNr87PGCdU8Z/ApkXLvp83M
	 pBZ4Ymq9PKU8wK9XwYclkaPw2xMug5jFRMh0zpVN6Zj4CKprBiYglvo9rRNcuFTc2g
	 pZnrVSM7kLrRlNP3lQz3mYOtt38NttpRWFzYlgT0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christian Loehle <christian.loehle@arm.com>,
	Sumit Gupta <sumitg@nvidia.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 0797/2214] ACPI: CPPC: Validate FFH register fields before hardware access
Date: Wed, 18 Nov 2026 15:41:13 +0100
Message-ID: <20261118150043.420451539@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
 arch/arm64/kernel/topology.c    |  9 +++++++++
 arch/x86/kernel/acpi/cppc_msr.c | 15 +++++++++++++++
 drivers/acpi/cppc_acpi.c        | 10 ++++++----
 3 files changed, 30 insertions(+), 4 deletions(-)

diff --git a/arch/arm64/kernel/topology.c b/arch/arm64/kernel/topology.c
index b142254d8c0fb..5feda5b55d454 100644
--- a/arch/arm64/kernel/topology.c
+++ b/arch/arm64/kernel/topology.c
@@ -332,10 +332,19 @@ bool cpc_ffh_supported(void)
 	return true;
 }
 
+static bool cpc_ffh_reg_valid(const struct cpc_reg *reg)
+{
+	return reg->bit_width && reg->bit_width <= 64 &&
+	       reg->bit_offset <= 64 - reg->bit_width;
+}
+
 int cpc_read_ffh(int cpu, struct cpc_reg *reg, u64 *val)
 {
 	int ret = -EOPNOTSUPP;
 
+	if (!cpc_ffh_reg_valid(reg))
+		return -EINVAL;
+
 	switch ((u64)reg->address) {
 	case 0x0:
 		ret = counters_read_on_cpu(cpu, cpu_read_corecnt, val);
diff --git a/arch/x86/kernel/acpi/cppc_msr.c b/arch/x86/kernel/acpi/cppc_msr.c
index b961de569e7e5..37543b21ce94d 100644
--- a/arch/x86/kernel/acpi/cppc_msr.c
+++ b/arch/x86/kernel/acpi/cppc_msr.c
@@ -4,6 +4,8 @@
  * Copyright (c) 2016, Intel Corporation.
  */
 
+#include <linux/limits.h>
+
 #include <acpi/cppc_acpi.h>
 #include <asm/msr.h>
 
@@ -14,10 +16,20 @@ bool cpc_ffh_supported(void)
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
 	err = rdmsrl_safe_on_cpu(cpunum, reg->address, val);
 	if (!err) {
 		u64 mask = GENMASK_ULL(reg->bit_offset + reg->bit_width - 1,
@@ -34,6 +46,9 @@ int cpc_write_ffh(int cpunum, struct cpc_reg *reg, u64 val)
 	u64 rd_val;
 	int err;
 
+	if (!cpc_ffh_reg_valid(reg))
+		return -EINVAL;
+
 	err = rdmsrl_safe_on_cpu(cpunum, reg->address, &rd_val);
 	if (!err) {
 		u64 mask = GENMASK_ULL(reg->bit_offset + reg->bit_width - 1,
diff --git a/drivers/acpi/cppc_acpi.c b/drivers/acpi/cppc_acpi.c
index 30c8799b1a6a8..c51183c2fd6f3 100644
--- a/drivers/acpi/cppc_acpi.c
+++ b/drivers/acpi/cppc_acpi.c
@@ -967,6 +967,9 @@ static int cpc_read(int cpu, struct cpc_register_resource *reg_res, u64 *val)
 	}
 
 	*val = 0;
+	if (reg->space_id == ACPI_ADR_SPACE_FIXED_HARDWARE)
+		return cpc_read_ffh(cpu, reg, val);
+
 	size = GET_BIT_WIDTH(reg);
 
 	if (reg->space_id == ACPI_ADR_SPACE_PLATFORM_COMM && pcc_ss_id >= 0) {
@@ -979,8 +982,6 @@ static int cpc_read(int cpu, struct cpc_register_resource *reg_res, u64 *val)
 	}
 	else if (reg->space_id == ACPI_ADR_SPACE_SYSTEM_MEMORY)
 		vaddr = reg_res->sys_mem_vaddr;
-	else if (reg->space_id == ACPI_ADR_SPACE_FIXED_HARDWARE)
-		return cpc_read_ffh(cpu, reg, val);
 	else
 		return acpi_os_read_memory((acpi_physical_address)reg->address,
 				val, size);
@@ -1026,6 +1027,9 @@ static int cpc_write(int cpu, struct cpc_register_resource *reg_res, u64 val)
 	struct cpc_desc *cpc_desc;
 	unsigned long flags;
 
+	if (reg->space_id == ACPI_ADR_SPACE_FIXED_HARDWARE)
+		return cpc_write_ffh(cpu, reg, val);
+
 	size = GET_BIT_WIDTH(reg);
 
 	if (reg->space_id == ACPI_ADR_SPACE_PLATFORM_COMM && pcc_ss_id >= 0) {
@@ -1038,8 +1042,6 @@ static int cpc_write(int cpu, struct cpc_register_resource *reg_res, u64 val)
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



