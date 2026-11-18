Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795046606;
	b=SKuvkCvEbCincQ6Y8Ok9c7/jX5iOP5IqYxJrDRgxK4Kw0ocOUDhCWV68s//NEEOoytgx
	 lakGMCrw6sWtw5MeAV6XJo7W0+M62vKWFgUa8RlbJn+xAZsUo5kLtl9N3pOlaOdWSeEZ6
	 IX0IktJBGJKRKzG9MRHQWvJyY3Nv+MAk/eN+ti8OzK2yzbbr3AI9zIZFpNwX0FNXOX0e/
	 R1a14zzZ0WDGd24CkaXNY5Cgww+tbyDaZ/4ZlrAqUSFTfzx3ELtTIVyaR4qyeS9LhWM+C
	 looik5Ar4/2/91tR1ka48D41X+JJWFx6HZXkM2z0Ah0xPcAdByE+rP1AiFPDTnsMXJw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795046606;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=qeCGLtPMKcZC3B0/DZNxZwxlYHh+rFanBXPlq8epyKA=;
	b=Cp5+c+IxPI9yAt38EaGfMSXTZw8NIf+055HvLgWr/Pt2aWX1aPbNKYYeFUK6SyaGrn7Q
	 CfWCDyVupLLv1srUE9q9ksBFmOY3wVLXXjm5/pN7AePoOQwPsP0Q9Z9WFM+56hEL3Gf7E
	 XEizc0U9zxrEYgEZL1XKaNZcVUQqEVh3o47Y84PmFqYsZF2EtE1gyiR0LavjRoQOedGwv
	 FPKb5zkyC88XSV49sebIeeFzE/P37IDfwDHCYDKZyekxYogbnZt3TSz+6SmUPtdIPoUsn
	 KuG73Bkul6KYABnY6TNBeR9StQhhoBMzlOh/LzTi50tKNEch8ogeL8zxDKEo0qNf//w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=QVAhJ2al;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 90A90606A336;
	Thu, 19 Nov 2026 00:03:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=QVAhJ2al
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A38EF1F000C4;
	Thu, 19 Nov 2026 00:03:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795046606;
	bh=qeCGLtPMKcZC3B0/DZNxZwxlYHh+rFanBXPlq8epyKA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=QVAhJ2alQGsJgwLAFqU91sFRmEL1JjLJ47wHq9Y+TPFVix2uaWffB1qSC6LgIJO8U
	 /SC4E46aRVMTxVRr5oFSyc8OgZ5Ega5VkIB0uzW5mohgaWThD2JgUb6Kwo7kzE6J0K
	 WQrXSTbolPdvhurWIhkAovc2z320oZ972jzGtuVI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
	Joerg Roedel <joerg.roedel@amd.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1334/2857] iommu/amd: Force device table to maximum size
Date: Wed, 18 Nov 2026 15:39:28 +0100
Message-ID: <20261118150249.466623445@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
encoded in the IOMMU device-table register matches
pci_seg->dev_table_size. A mixed rollout disagrees: the unpatched
kernel uses the IVRS-derived size and the patched kernel uses 2MB,
so copy_device_table() rejects the table and reinitializes
translation. Kernels that both have this patch agree on 2MB and the
copy succeeds. Update the production kernel and the crash kernel
together.

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
index 8d1613a915439..d37af8033682d 100644
--- a/arch/x86/include/asm/cpufeatures.h
+++ b/arch/x86/include/asm/cpufeatures.h
@@ -452,6 +452,11 @@
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
index 8d9c067992e5f..32cd072daf635 100644
--- a/arch/x86/kernel/cpu/amd.c
+++ b/arch/x86/kernel/cpu/amd.c
@@ -713,6 +713,24 @@ static void bsp_init_amd(struct cpuinfo_x86 *c)
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
index 39d260ae6ff39..fd11dee96f80b 100644
--- a/drivers/iommu/amd/init.c
+++ b/drivers/iommu/amd/init.c
@@ -1587,6 +1587,21 @@ static int __init init_iommu_from_acpi(struct amd_iommu *iommu,
 	return 0;
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
 /* Allocate PCI segment data structure */
 static struct amd_iommu_pci_seg *__init alloc_pci_segment(u16 id,
 					  struct acpi_table_header *ivrs_base)
@@ -1609,7 +1624,13 @@ static struct amd_iommu_pci_seg *__init alloc_pci_segment(u16 id,
 
 	pci_seg->last_bdf = last_bdf;
 	DUMP_printk("PCI segment : 0x%0x, last bdf : 0x%04x\n", id, last_bdf);
-	pci_seg->dev_table_size     = tbl_size(DEV_TABLE_ENTRY_SIZE, last_bdf);
+	if (amd_iommu_force_max_dev_table()) {
+		pr_info("Force device table to maximum size\n");
+		pci_seg->dev_table_size = SZ_2M;
+	} else {
+		pci_seg->dev_table_size = tbl_size(DEV_TABLE_ENTRY_SIZE,
+						   last_bdf);
+	}
 	pci_seg->alias_table_size   = tbl_size(ALIAS_TABLE_ENTRY_SIZE, last_bdf);
 	pci_seg->rlookup_table_size = tbl_size(RLOOKUP_TABLE_ENTRY_SIZE, last_bdf);
 
-- 
2.53.0



