Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794590044;
	b=i2dJNh/3JqKrQdzBcjF2V+yQup/JnOYYGXpVRZdtV69nGKtWPpAG9bAuM0mBXowi2xdg
	 +NYrqm8K8RWeeuo82nIO0x/TFAk6Oavh8S2SPhmm/wTdQQj+8/z2Kt3RaEAJnIGzFNAH9
	 kYZ8LEtv9q/evnFpLR/uR/hcaagu5Agu51eWuaOWjUsVrr2FVFD+M/ckX0w5HFHZYWqza
	 psX5kmzkx4UG6ta8kaS6Wf8p0epg0veaDJTki9jjxwkc1sGqEex1EfbVgremrVhmPfd8+
	 Ae94KcU/Ns+DpvWlOo6KmQ3T43cSReGOAqeiGFscF3K/dMEnhD50MNhvPHScmhGRqnw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794590044;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=FZKUcwLnzlN7L+6LKq1Vi31MqhB+vVS7fYCc3iWqQUM=;
	b=jqJVFxq98PSlmQlrir7kXBBmDu2HBIVW0Li1Qj+EPFR5crVlzYtfFBvzEzFPPwi22Vjn
	 3YH66xqqE1TGdHhO1EqM+gXd20CiAtmN/ipJvSQmNRzrmq/07b196X5jpsltvE5eiZQog
	 TbkdGPHmA8dV8ZP/9LlfVxT/cABjZojN9CyJUNAodls1tIPNe3nxq6XJRQqfneEiMysRa
	 Hxx7dzDvKb6C7y1n+Or2wRdH1FzklfOKRPAdNAT27WOqtdc5yj7Ty5ehGB5SWNiuEv2yi
	 wTbgXIKEJGK3ZLy+k8sWym97fL8j79HnlLVtJKkvVRZf1qlZVFXtf9ZN1QS/U2SY4KQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=wfH+No0q;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D5B05606B346;
	Fri, 13 Nov 2026 17:14:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=wfH+No0q
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8235F1F000C8;
	Fri, 13 Nov 2026 17:14:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794590044;
	bh=FZKUcwLnzlN7L+6LKq1Vi31MqhB+vVS7fYCc3iWqQUM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=wfH+No0qecPMlzTZJ+Z8pWxw9QltxkxkXen64k/lMNAvNiV8XUe6zXhmlHrs6kZBv
	 155vnBKdGFQg4xb+Kp8+PIpMg5afboDMKNIblPLjgSUKvMqNJ3PS9s6jlL5kRvlrM/
	 p/fGY6ZwNxRP2B5m2fyHUWVqipGgxpbgmajFDn8k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christian Loehle <christian.loehle@arm.com>,
	Sumit Gupta <sumitg@nvidia.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 079/686] ACPI: CPPC: Validate FFH register fields before hardware access
Date: Fri, 13 Nov 2026 10:43:32 -0500
Message-ID: <20261113153823.566537760@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153820.902362109@linuxfoundation.org>
References: <20261113153820.902362109@linuxfoundation.org>
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
 arch/arm64/kernel/topology.c |  9 +++++++++
 arch/x86/kernel/acpi/cppc.c  | 15 +++++++++++++++
 drivers/acpi/cppc_acpi.c     | 10 ++++++----
 3 files changed, 30 insertions(+), 4 deletions(-)

diff --git a/arch/arm64/kernel/topology.c b/arch/arm64/kernel/topology.c
index 202f677e2b0f2..bbbe866680fd2 100644
--- a/arch/arm64/kernel/topology.c
+++ b/arch/arm64/kernel/topology.c
@@ -478,10 +478,19 @@ bool cpc_ffh_supported(void)
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
diff --git a/arch/x86/kernel/acpi/cppc.c b/arch/x86/kernel/acpi/cppc.c
index be4c5e9e5ff6f..ca5287ccd8968 100644
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
index 531777557b47c..a3984e061ce0c 100644
--- a/drivers/acpi/cppc_acpi.c
+++ b/drivers/acpi/cppc_acpi.c
@@ -1017,6 +1017,9 @@ static int cpc_read(int cpu, struct cpc_register_resource *reg_res, u64 *val)
 	}
 
 	*val = 0;
+	if (reg->space_id == ACPI_ADR_SPACE_FIXED_HARDWARE)
+		return cpc_read_ffh(cpu, reg, val);
+
 	size = GET_BIT_WIDTH(reg);
 
 	if (IS_ENABLED(CONFIG_HAS_IOPORT) &&
@@ -1044,8 +1047,6 @@ static int cpc_read(int cpu, struct cpc_register_resource *reg_res, u64 *val)
 	}
 	else if (reg->space_id == ACPI_ADR_SPACE_SYSTEM_MEMORY)
 		vaddr = reg_res->sys_mem_vaddr;
-	else if (reg->space_id == ACPI_ADR_SPACE_FIXED_HARDWARE)
-		return cpc_read_ffh(cpu, reg, val);
 	else
 		return acpi_os_read_memory((acpi_physical_address)reg->address,
 				val, size);
@@ -1091,6 +1092,9 @@ static int cpc_write(int cpu, struct cpc_register_resource *reg_res, u64 val)
 	struct cpc_desc *cpc_desc;
 	unsigned long flags;
 
+	if (reg->space_id == ACPI_ADR_SPACE_FIXED_HARDWARE)
+		return cpc_write_ffh(cpu, reg, val);
+
 	size = GET_BIT_WIDTH(reg);
 
 	if (IS_ENABLED(CONFIG_HAS_IOPORT) &&
@@ -1116,8 +1120,6 @@ static int cpc_write(int cpu, struct cpc_register_resource *reg_res, u64 val)
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



