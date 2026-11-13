Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794585858;
	b=HRljybTMNxrMDTyK1vM1gYXxKGAi5+enZY8gAtdiQo/FPlufsb4nJS/NQEjKHf7qIZHf
	 vq54Qcy1xlnJZGF9LJ7RG0RVr81BPMVNXp9vtpJ17HbDTkTJgxN7ywHwdIL3QbTz+UdoM
	 OVCog/I6dLQeRpRpkek7XV4nr6LVGrwbnwfZ5yZg6TamdesAT7axehNZZcfMYucIcM4dW
	 HU/+vBJv29n7L/uiq8UEGel4lhMrod+qDYDmoTchcBu/ttapfnZemOgQIreE/J/mp7OsW
	 XdKr3eaSHPFeTSfpn9eGX7ggMuu+Rzui02Mf/oCTJw/RW1zz6l+eCKqwbfX+tPdPKjw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794585858;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=rnNB/kH7GbMPx4QiMqePMRO8aB3diO8D4mIIojzJPDI=;
	b=mA8EnwSmeYvQ7fjraD3zYVN4NFuhImIfO3TnIwjJLIc2e6IG/KnnfdBuJZE0ci1OQeC6
	 nMLRd1FzUPsRsHmN/D5SR5bT+e9rBCodzrgG93CspCcd4PdgsgY7qxnsLl7vCIcK0yb4X
	 WAaThVihtv78JvUb1YdXDc2rGfRFAs8q5x9AuN4g//xpmkDsKqc2DoksguPl5zEdjzmxc
	 Bt6AiOs7snduc5fcVfppidJicUXJecjB2lBHYb4/wfEXX2TMf94Z2H0lDUP0DEZuVPZsV
	 t6+bv0DUudcHuoLSeVJJTor1ZlfUAQvdKDNwadKUIDs8TMlWrE6ik/jz8t1EsBJiLsQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=r2Ig3Kce;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CFE84606BAB8;
	Fri, 13 Nov 2026 16:04:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=r2Ig3Kce
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7C28A1F000C4;
	Fri, 13 Nov 2026 16:04:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794585858;
	bh=rnNB/kH7GbMPx4QiMqePMRO8aB3diO8D4mIIojzJPDI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=r2Ig3KcegD6iIJtHSuaEwb734vxqMFN07t2A8NEjelmz5d3+0Dpo5JFC63KZFh4iu
	 YPXVvOpPMLFJkyGndMnrUSX6symHblnQ0sT1qX5bQxtDw46rGULIebm6vSAxU4t4GG
	 uaqVMYuDExk0bAejX3QlCsaz//eeJ8jEz8YbBM5M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
	Joerg Roedel <joerg.roedel@amd.com>,
	Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 7.3 433/507] iommu/amd: Force device table to maximum size
Date: Fri, 13 Nov 2026 10:52:17 -0500
Message-ID: <20261113153811.419614291@linuxfoundation.org>
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

kdump reuses the previous kernel's device table only when the size
encoded in the IOMMU device-table register matches
pci_seg->dev_table_size. A mixed rollout disagrees: the unpatched
kernel uses the IVRS-derived size and the patched kernel uses 2MB,
so __reuse_device_table() rejects the table. On SNP-capable IOMMUs
that rejection panics the kdump kernel. Kernels that both have this
patch agree on 2MB and reuse succeeds. Update the production kernel
and the crash kernel together.

Signed-off-by: Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iommu/amd/init.c |   27 ++++++++++++++++++++++++---
 1 file changed, 24 insertions(+), 3 deletions(-)

--- a/drivers/iommu/amd/init.c
+++ b/drivers/iommu/amd/init.c
@@ -1720,6 +1720,21 @@ static int __init init_iommu_from_acpi(s
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
@@ -1742,9 +1757,15 @@ static struct amd_iommu_pci_seg *__init
 
 	pci_seg->last_bdf = last_bdf;
 	DUMP_printk("PCI segment : 0x%0x, last bdf : 0x%04x\n", id, last_bdf);
-	pci_seg->dev_table_size =
-		max(roundup_pow_of_two((last_bdf + 1) * DEV_TABLE_ENTRY_SIZE),
-		    SZ_4K);
+	if (amd_iommu_force_max_dev_table()) {
+		pr_info("Force device table to maximum size\n");
+		pci_seg->dev_table_size = SZ_2M;
+	} else {
+		pci_seg->dev_table_size =
+			max(roundup_pow_of_two((last_bdf + 1) *
+					       DEV_TABLE_ENTRY_SIZE),
+			    SZ_4K);
+	}
 
 	pci_seg->id = id;
 	init_llist_head(&pci_seg->dev_data_list);


