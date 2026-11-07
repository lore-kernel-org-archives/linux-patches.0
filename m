Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794064826;
	b=flEUOZ65KA0A2mdphI2JfsrHlJHVq69VZbeUvUEWeM9BaOI9+8fRDDvJzt7OBXIrddCV
	 XZTTd9AFQPTvRIQhPxcsu5xYTDp+CgFaBOfpZHDe5wLG79qzyQ0bvv2S0yPuPqyloQiwr
	 R9drLz9e2BzeUnFut9i8ZfyTV+YSU7WQP3Lq6WJumK1K4ckCply8bAUsPD9V00WW0uTuR
	 5sEIOCcAc+bjWyjUzzOfpK0ShBXhCrMgih/6Lz6kyDK1mh7tKuPgdRmKA9t6j5OKJn9D0
	 /RI9WbbD1+6HJ/k7XbC9hcYMXJZnmkrq/DeVxVMI+FwtFsYXJlLDcRYQZSp6naaH73w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794064826;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=O9yn0ts9P1Dkb5LpeCd78ID5oZZZ8O3ZFYuzZddMsIw=;
	b=GT5dmNFIHa0zJNiIqgo/8RyJsp1bRcENVoMaJPGVcLf6kEUigslOxjYtm+TBcYC7I8GW
	 5Q12o125491vOC9TVdKyEP4cDFtxpA4dskVUnXO2GkMIinRDJikcYxlL4VcE1z8Mauc3H
	 UbbHATi9KEnR37b5N86qwpxpW9z3MgXv/HXay6xx/5MRJJ/DfFtYT0BujlwTU30DEJW0d
	 lQ4hP30eDGFxs8g6x2D4Zyzk6q3xL4YEaoXCtdBiU4/dDTwbyDgt82TRJL2RdOO6mQh1R
	 T5NGCn5zuBFrSNQXU5eiKivbjhMLhOHoIp+b+roblrkxnh8/Cd3MfIrrv9904d7XQhQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=TQDbQrxn;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 193A6606A339;
	Sat,  7 Nov 2026 15:20:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=TQDbQrxn
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 288581F0089F;
	Sat,  7 Nov 2026 15:20:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794064825;
	bh=O9yn0ts9P1Dkb5LpeCd78ID5oZZZ8O3ZFYuzZddMsIw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=TQDbQrxnOJecq/yNPelfDRzCXlf6lPL73m5Nygz/1HRnonOeAVoPe+0pGUgg/UIuq
	 71FneREQKiY+Xpb12D335rupJpxo19e5+HknNRMWdnHr9OaWADImMBhQFNpW64IVvR
	 zDs/vHgjOea5kmHVuDloSmjU2+lgKlipbHy3DACs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ashish Kalra <ashish.kalra@amd.com>,
	Ankit Soni <Ankit.Soni@amd.com>,
	Matt Fleming <mfleming@cloudflare.com>,
	Vasant Hegde <vasant.hegde@amd.com>,
	Joerg Roedel <joerg.roedel@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0759/1257] iommu/amd: Dont allocate kdump device table from DMA32
Date: Sat,  7 Nov 2026 08:50:55 -0500
Message-ID: <20261107135000.249446293@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134939.434104957@linuxfoundation.org>
References: <20261107134939.434104957@linuxfoundation.org>
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

From: Matt Fleming <mfleming@cloudflare.com>

[ Upstream commit bae0d3760661ac77148944e88aafef698cf7b2bf ]

Booting a kdump kernel with crashkernel=X,high crashkernel=0,low on an
AMD system fails the per-segment device table allocation because there
is no memory below 4G:

  swapper/0: page allocation failure: order:9, mode:0x40104(GFP_DMA32|__GFP_ZERO|__GFP_COMP)
  iommu_alloc_pages_node_sz+0x7f/0x150
  alloc_pci_segment+0x4bd/0x650
  iommu_go_to_state+0x213d/0x34e0
  amd_iommu_prepare+0x39/0xa0
  irq_remapping_prepare+0x83/0xd0
  enable_IR_x2apic+0x61/0x370

On our E810 systems, the kdump kernel booted but ice MSI-X interrupts
never fired and the TX queues timed out.

Commit b336781b82cc ("iommu/amd: Allocate memory below 4G for dev table
if translation pre-enabled") allocated device tables below 4G. At the
time, the kdump kernel programmed a copy of the old table into the base
register with the IOMMU still enabled. The 64-bit register is updated
as two 32-bit halves, so the running IOMMU could see a half-written,
invalid table pointer. Keeping both tables below 4G leaves the upper
half zero throughout the update, so the pointer stays valid.

Since commit 38e5f33ee359 ("iommu/amd: Reuse device table for kdump")
the kdump kernel reuses the previous kernel's table without writing the
base register, so its newly allocated table is discarded when reuse
succeeds. If reuse fails, the previous patch programs the new table only
after disabling the IOMMU. Either way, the kdump kernel's table doesn't
need to be below 4G.

The previous kernel still allocates its table from DMA32, so the kdump
kernel's check that the old table is below 4G still works. Drop
GFP_DMA32 for kdump kernels only.

Cc: stable@vger.kernel.org # 6.18.x
Reviewed-by: Ashish Kalra <ashish.kalra@amd.com>
Reviewed-by: Ankit Soni <Ankit.Soni@amd.com>
Signed-off-by: Matt Fleming <mfleming@cloudflare.com>
Reviewed-by: Vasant Hegde <vasant.hegde@amd.com>
Signed-off-by: Matt Fleming <mfleming@cloudflare.com>
Reviewed-by: Ashish Kalra <ashish.kalra@amd.com>
Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iommu/amd/init.c | 15 +++++++++++++--
 1 file changed, 13 insertions(+), 2 deletions(-)

diff --git a/drivers/iommu/amd/init.c b/drivers/iommu/amd/init.c
index 102b7b5d2021e..0506617b27c29 100644
--- a/drivers/iommu/amd/init.c
+++ b/drivers/iommu/amd/init.c
@@ -629,8 +629,19 @@ static int __init find_last_devid_acpi(struct acpi_table_header *table, u16 pci_
 /* Allocate per PCI segment device table */
 static inline int __init alloc_dev_table(struct amd_iommu_pci_seg *pci_seg)
 {
-	pci_seg->dev_table = iommu_alloc_pages_sz(GFP_KERNEL | GFP_DMA32,
-						  pci_seg->dev_table_size);
+	gfp_t gfp = GFP_KERNEL;
+
+	/*
+	 * Keep normal kernel device tables below 4G because a later kdump
+	 * kernel only trusts and reuses old tables below that limit. A kdump
+	 * kernel's new table is either discarded when reuse succeeds or
+	 * programmed after the IOMMU is disabled, so the table does not
+	 * need DMA32 memory (which the crashkernel may not have).
+	 */
+	if (!is_kdump_kernel())
+		gfp |= GFP_DMA32;
+
+	pci_seg->dev_table = iommu_alloc_pages_sz(gfp, pci_seg->dev_table_size);
 	if (!pci_seg->dev_table)
 		return -ENOMEM;
 
-- 
2.53.0



