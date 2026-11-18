Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795053539;
	b=NMT5Pqd41Vdhp3ApuuGWmAdpJ+Fu1Z0JZrW0pQsG3FW42VpOyC8WtFMZg4zAP7htlRuX
	 MgA0V6De7DDheVBtI1o+ljVPVT+NUcRmRiv+OuODFgYvcxUk55ZZ2iQwaELXR8oo7NYAL
	 Ut/6nlqqLkN7X+Q3Hgqd+rJ0lArIICbxpZYIDUVI5KmvLIRgtE8L8qiXXV/fop0tE2uwu
	 d00xWF4rPIGtk7FjNnVQXSGUAwH4s8sz4NjbLu/eeFn4k9OGLyyqrJubJQzBZEiVkf7bX
	 fquun5GsU3SbFUYpgk9OFmh+lpHFiU5PE0FjpTIYkOHwV7zH+6GbUsnhkezjCspKxKA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795053539;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=rW5EfQFdcZrQGVe1c5d+V484DPL3vJMy1/e44GJ64ck=;
	b=ifycQTnX2K6uto4snYtkCVcqhXZuPARIhEE2cLwgEEgDTEyOLXPoicDblDfKYo2FKkA6
	 SnwduRPU5GYwu4bsn1eteKRiijz1xKFgSrLeMdudYdKg56U3VONUO9jv4CkjVFNhHrYZr
	 UCaFyNhLPJjCKACnFDzu1p1JeFEZBAN2136qU6torgmqa+ngneKIQrIDgosRwfwHUkcmu
	 6VevPSckqS25QC3TXardrXLlBs8iyVbEi/umf55S5/daVGW0n/Wp9wgO3dPBvjjwz3Cqy
	 hTZlZxaYPvrjoJDvnB67i1/5aelxu0wuYJdrbudVWIXXzSux6EzGHCjhOn+chZXksug==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=c4zPSgv+;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 19917606A33B;
	Thu, 19 Nov 2026 01:58:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=c4zPSgv+
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 686911F000C5;
	Thu, 19 Nov 2026 01:58:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795053539;
	bh=rW5EfQFdcZrQGVe1c5d+V484DPL3vJMy1/e44GJ64ck=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=c4zPSgv+bAL0dc8ZHLF+ZS3dtsSslTMyRIPotRG2ETbjF5GjDiYf3iZc4AFe5NwVI
	 M/OGNmZMQWcnK/Ri2QuBP7opmc0WOATr26h5ACZVMzzByJlfwx9u6UPDFkgk05oPQV
	 OJzmwPSLUhC3X0VKe9oQTLsd8rjd9idiZ+pN84Jw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
	Joerg Roedel <joerg.roedel@amd.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 0955/2214] iommu/amd: Force device table to maximum size
Date: Wed, 18 Nov 2026 15:43:51 +0100
Message-ID: <20261118150050.523514514@linuxfoundation.org>
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

From: Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>

commit 6e2213dae78b41976c60133eb10cf99e81916638 upstream.

IOMMU can perform out-of-bounds read of the device table entry (DTE)
that is adjacent to the last DTE and falls outside the device table.
For example, if the device table can hold 0 to N-1 entries, then the
IOMMU can be made to fetch the Nth entry, which falls outside the
device table.

The device table is owned by the hypervisor (HV) and is assigned in 4KB
pages that are contiguous in system physical address (SPA). If the
out-of-bound DTE falls on a guest-owned page, then the guest can exploit
this bug to setup malicious table walks to corrupt HV pages and/or bring
down the system. Note that this bug does not manifest when the device
table size is set to its maximum size of 2MB.

Therefore, force the device table size to the maximum 2MB on affected
processors. These are CPU family 0x17 (Zen1/Zen2) through family 0x1a
(Zen5/BRH).

This is a mitigation for CVE-2024-21963.

kdump copies the previous kernel's device table only when the size
encoded in the IOMMU device-table register matches dev_table_size.
A mixed rollout disagrees: the unpatched kernel uses the IVRS-derived
size and the patched kernel uses 2MB, so copy_device_table() rejects
the table and reinitializes translation. Kernels that both have this
patch agree on 2MB and the copy succeeds. Update the production
kernel and the crash kernel together.

This kernel has one global device table. Only that size is forced
to 2MB. Alias and rlookup sizes stay derived from the IVRS.

This backport adds X86_FEATURE_ZEN6. Bit 3*32+6 is still
X86_FEATURE_P3 here, so the new flag uses free bit 21*32+7.
Family 0x1a models 0x50-0x5f, 0x80-0xaf, 0xc0-0xcf, and
0xd8-0xef are Zen6 and are excluded from the workaround.
This kernel has no X86_FEATURE_ZEN5. Other family 0x1a models
stay unmarked and still take the 2MB device table.

Signed-off-by: Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/include/asm/cpufeatures.h |  5 +++++
 arch/x86/kernel/cpu/amd.c          | 18 ++++++++++++++++++
 drivers/iommu/amd/init.c           | 23 ++++++++++++++++++++++-
 3 files changed, 45 insertions(+), 1 deletion(-)

diff --git a/arch/x86/include/asm/cpufeatures.h b/arch/x86/include/asm/cpufeatures.h
index 060ae0d8387e7..a25b6d4838a69 100644
--- a/arch/x86/include/asm/cpufeatures.h
+++ b/arch/x86/include/asm/cpufeatures.h
@@ -439,6 +439,11 @@
 #define X86_FEATURE_CLEAR_BHB_HW	(21*32+ 3) /* "" BHI_DIS_S HW control enabled */
 #define X86_FEATURE_CLEAR_BHB_LOOP_ON_VMEXIT (21*32+ 4) /* "" Clear branch history at vmexit using SW loop */
 #define X86_FEATURE_INDIRECT_THUNK_ITS	(21*32 + 5) /* "" Use thunk for indirect branches in lower half of cacheline */
+/*
+ * Upstream defines X86_FEATURE_ZEN6 as (3*32+6). That bit is still
+ * X86_FEATURE_P3 in this kernel, so use a free bit in this word.
+ */
+#define X86_FEATURE_ZEN6		(21*32+7) /* "" CPU based on Zen6 microarchitecture */
 
 #define X86_FEATURE_TSA_SQ_NO          (21*32+11) /* "" AMD CPU not vulnerable to TSA-SQ */
 #define X86_FEATURE_TSA_L1_NO          (21*32+12) /* "" AMD CPU not vulnerable to TSA-L1 */
diff --git a/arch/x86/kernel/cpu/amd.c b/arch/x86/kernel/cpu/amd.c
index 2ad2c454b9829..3cb9ca970326e 100644
--- a/arch/x86/kernel/cpu/amd.c
+++ b/arch/x86/kernel/cpu/amd.c
@@ -742,6 +742,24 @@ static void bsp_init_amd(struct cpuinfo_x86 *c)
 		}
 		break;
 	}
+	case 0x1a: {
+		switch (c->x86_model) {
+		case 0x50 ... 0x5f:
+		case 0x80 ... 0xaf:
+		case 0xc0 ... 0xcf:
+		case 0xd8 ... 0xef:
+			setup_force_cpu_cap(X86_FEATURE_ZEN6);
+			break;
+		default:
+			/*
+			 * Zen5 models in family 0x1a have no feature bit
+			 * in this kernel. Leave them unmarked so the
+			 * device-table workaround still applies.
+			 */
+			break;
+		}
+		break;
+	}
 	default:
 		break;
 	}
diff --git a/drivers/iommu/amd/init.c b/drivers/iommu/amd/init.c
index 103a3c3e91d33..fd5af64f18e0e 100644
--- a/drivers/iommu/amd/init.c
+++ b/drivers/iommu/amd/init.c
@@ -22,6 +22,7 @@
 #include <linux/kmemleak.h>
 #include <linux/mem_encrypt.h>
 #include <linux/iopoll.h>
+#include <linux/sizes.h>
 #include <asm/pci-direct.h>
 #include <asm/iommu.h>
 #include <asm/apic.h>
@@ -2757,6 +2758,21 @@ static void __init ivinfo_init(void *ivrs)
 	amd_iommu_ivinfo = *((u32 *)(ivrs + IOMMU_IVINFO_OFFSET));
 }
 
+/*
+ * Apply workaround for Zen1 to Zen5(BRH) generation of processors.
+ * References: CVE-2024-21963
+ */
+static bool __init amd_iommu_force_max_dev_table(void)
+{
+	if (boot_cpu_data.x86 >= 0x17 && boot_cpu_data.x86 <= 0x1a) {
+		if (cpu_feature_enabled(X86_FEATURE_ZEN6))
+			return false;
+		else
+			return true;
+	}
+	return false;
+}
+
 /*
  * This is the hardware init function for AMD IOMMU in the system.
  * This function is called either from amd_iommu_init or from the interrupt
@@ -2824,7 +2840,12 @@ static int __init early_amd_iommu_init(void)
 	if (ret)
 		goto out;
 
-	dev_table_size     = tbl_size(DEV_TABLE_ENTRY_SIZE);
+	if (amd_iommu_force_max_dev_table()) {
+		pr_info("Force device table to maximum size\n");
+		dev_table_size = SZ_2M;
+	} else {
+		dev_table_size = tbl_size(DEV_TABLE_ENTRY_SIZE);
+	}
 	alias_table_size   = tbl_size(ALIAS_TABLE_ENTRY_SIZE);
 	rlookup_table_size = tbl_size(RLOOKUP_TABLE_ENTRY_SIZE);
 
-- 
2.53.0



