Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794063379;
	b=0VXFGJESinjhg8In0hrQQjkMCa3y4VYhi1n24q5Qr8jarsUoxNARfHIClD3vlNZWISsR
	 LCGO1OmuR8k/psm4zFj6+IMYtTqN8ICZlYm+qZTDfYQsCN8Ij/YaOemN8Bw4MPYeGOq9f
	 TH+iHBHviSbVE0HECJ9xNiwhKwKhEo71/0frWxBeLVudEkV/QEhI+3Sm8ngbGoYvTwM16
	 mOemKZXB3WkNwCEghWBAqPTnRWRAWQKh4/WBbDdQrbi4txv0fkPTdD0i0h8C6V8RYYIPB
	 oZs/jIVTqB+8wsi33JeyAKGYD/s8XLoRnKf3X9jJjlEYiv5nUOuL6wlND4bF9BZm62A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794063379;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=jPMwIE8uCnKDFVV6K/DnZybekHQfaGyQigUTlBssBTU=;
	b=ZZsrV0yaBMUwm3BB4oSw1TdG08sH/HQfPqTbvUHqlIp4FR+4OEujgqinpuiLd33VKIGS
	 REJRuzBzv9t+f0bc+QuSbBc8OpoNmXxo8OuwWJ9RfBJQaRZxSTylNuShJ4cBL5ybHMu/u
	 PvrE9BcWaumGH9HCw4b88K7N4hLoxDiAyjpQol9lQ9gYBQ2KdhnI/75PwpDJUQIMmbpjy
	 HOfl0NOIkwnX7W6yQXbwjaKgyToNA3H1cTVkfhNX1W2o5vfDeetEXPCodMfdviiVvo62s
	 KONtuTC0nNE7J6l+GfwkIgQUzolbCO7F/YCzwZnQ+Vq+I8ZT1bKUPVzcq7Y2slKkAxg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="jsBKPR/h";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 798A1606D81C;
	Sat,  7 Nov 2026 14:56:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=jsBKPR/h
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2D7FC1F008A1;
	Sat,  7 Nov 2026 14:56:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794063379;
	bh=jPMwIE8uCnKDFVV6K/DnZybekHQfaGyQigUTlBssBTU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=jsBKPR/h1Ot4mdQViukl9Szzmo8CekIzAfSYiLRdhGGOlhpNyJ5lANnR8VboCjvSF
	 8Ty13oDiErc3dEL0ApgpzNDiq+gNjBKDX6rh6rA4NN6hWbyOD+Bc7tywZ+kS9WzzVv
	 lWo+YdNx6tRF+j/Ox5QbnJmOYJubXQaLHp11KtyU=
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
Subject: [PATCH 6.18 553/869] iommu/amd: Dont allocate kdump device table from DMA32
Date: Sat,  7 Nov 2026 08:53:55 -0500
Message-ID: <20261107134912.104848533@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134852.069646174@linuxfoundation.org>
References: <20261107134852.069646174@linuxfoundation.org>
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
index 0572e1a674f0b..16c26d75f46f4 100644
--- a/drivers/iommu/amd/init.c
+++ b/drivers/iommu/amd/init.c
@@ -648,8 +648,19 @@ static int __init find_last_devid_acpi(struct acpi_table_header *table, u16 pci_
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



