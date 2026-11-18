Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795059289;
	b=P2/j1wdVIJBOhUtiReDSBbYH4akj/kxpec7C06sFK3y9aLtXGRmtYeUd6Y/wiiBqRm6k
	 evGfQvzZDR124vo+QsK8hY3JkquPFv88vPDuRJRz1ndCC7SKaDQtQdRsSN5c0WeX0g7p+
	 Jqn6pO98/XK5+94Tm/QsVmQ3JtxiPiMuQ00PhfVKXvWY1g4JAi9v9pT5x4mkiIx8maccx
	 rV+kaLcpKZX/RUyZ7ok0CQraWgcaUXOwW2Dyyu+MWbdydkF+1Xt1l0CYARYIgnh+6TfQY
	 pXyxMrogWK4AsEOo0G9uX74Kpz8pQIpnCVMIrUMqKtLuORoaHkNGyvJ0eriD4okgJfg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795059289;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=omTYz2BGjwpShgPDMshTwvq0b65xvedw92wvDXDDnuk=;
	b=QveJjkqCZ2QUtV9XoEbvKY+KYuQgVr9MrAVLhnTyFbBm2lCupd/NVc93PicTQ+wVqRrD
	 yUtHI8Akb3QyJcJrTNmm7VGlCVrWEgbAi+GOiw2bbM3fNDBrEo07uWSVy7lwRlEn9T4RX
	 /y4SJboXwL+ET9Nq6mKgUz3XWFHzA7fmB/jR2Che/hO8iZmwc3x6e/OFUARLOZdTd6gPu
	 yXdwcUMPkICAyZVSI/GqmMkPWuI60HioySj+w17EsB5wjDAWLybc+gKzJJISaEsshSCLb
	 qQb0hRLv0NjtS31yPP0R4zLwXe0kQCmXVgp+0/Ubf3FxCrqHJwi9UidjP3eqfT0xC7A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=NrzFo0X8;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E2CC1606A330;
	Thu, 19 Nov 2026 03:34:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=NrzFo0X8
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 443571F000C4;
	Thu, 19 Nov 2026 03:34:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795059288;
	bh=omTYz2BGjwpShgPDMshTwvq0b65xvedw92wvDXDDnuk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=NrzFo0X8IBgwtz93pTKIZ+0NRqssSXcZ+yctb1ZpxpUgefGUIihuJt8CL5RANqCqp
	 kSK0vAT4RE4QVjBpgBt6uhCH7uLA3IPw//UVpdDb3JCITt1oLDTLVPyZYshk87+eca
	 DQRXa3n4ZJcx1FGKQhU7tvNsCgIcSY/YdFAT+Qlo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
	Joerg Roedel <joerg.roedel@amd.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 0787/1848] iommu/amd: Force device table to maximum size
Date: Wed, 18 Nov 2026 15:47:05 +0100
Message-ID: <20261118145949.393227376@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
 arch/x86/include/asm/cpufeatures.h |  6 ++++++
 arch/x86/kernel/cpu/amd.c          | 18 ++++++++++++++++++
 drivers/iommu/amd/init.c           | 23 ++++++++++++++++++++++-
 3 files changed, 46 insertions(+), 1 deletion(-)

diff --git a/arch/x86/include/asm/cpufeatures.h b/arch/x86/include/asm/cpufeatures.h
index 19a18df50a2ea..12928845f136c 100644
--- a/arch/x86/include/asm/cpufeatures.h
+++ b/arch/x86/include/asm/cpufeatures.h
@@ -416,6 +416,12 @@
 #define X86_FEATURE_IBPB_BRTYPE		(20*32+28) /* "" MSR_PRED_CMD[IBPB] flushes all branch type predictions */
 #define X86_FEATURE_SRSO_NO		(20*32+29) /* "" CPU is not affected by SRSO */
 
+/*
+ * Upstream defines X86_FEATURE_ZEN6 as (3*32+6). That bit is still
+ * X86_FEATURE_P3 in this kernel, so use a free bit in this word.
+ */
+#define X86_FEATURE_ZEN6		(21*32+7) /* "" CPU based on Zen6 microarchitecture */
+
 #define X86_FEATURE_TSA_SQ_NO          (22*32+11) /* "" AMD CPU not vulnerable to TSA-SQ */
 #define X86_FEATURE_TSA_L1_NO          (22*32+12) /* "" AMD CPU not vulnerable to TSA-L1 */
 #define X86_FEATURE_CLEAR_CPU_BUF_VM   (22*32+13) /* "" Clear CPU buffers using VERW before VMRUN */
diff --git a/arch/x86/kernel/cpu/amd.c b/arch/x86/kernel/cpu/amd.c
index 0ded215bcaf63..2abed4f24dbc9 100644
--- a/arch/x86/kernel/cpu/amd.c
+++ b/arch/x86/kernel/cpu/amd.c
@@ -769,6 +769,24 @@ static void bsp_init_amd(struct cpuinfo_x86 *c)
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
index cccbe59c2604e..c643ea095c972 100644
--- a/drivers/iommu/amd/init.c
+++ b/drivers/iommu/amd/init.c
@@ -21,6 +21,7 @@
 #include <linux/kmemleak.h>
 #include <linux/mem_encrypt.h>
 #include <linux/iopoll.h>
+#include <linux/sizes.h>
 #include <asm/pci-direct.h>
 #include <asm/iommu.h>
 #include <asm/apic.h>
@@ -2664,6 +2665,21 @@ static void __init ivinfo_init(void *ivrs)
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
@@ -2732,7 +2748,12 @@ static int __init early_amd_iommu_init(void)
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



