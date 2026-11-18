Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795043944;
	b=AxpD0QodSuKOGrhGwQa1TP/yVPan8FW9l4q30vFfq2/ft4gA5gKR3wcioI/rRxPU/Bu7
	 eKd5aBmVu/kUSynCyKSveeo/iGoXtyFYdRYqMjgFzh8EO6//WCiwsU5d9JR8z8rneH4ZX
	 ZiSkjqZ+a7bcDIIzIB+3WYAFYT/CaOiHG4ggTr69hAL6ikg/wpX4IsmRSbmtNx859/nd6
	 VRy46KZ5W8qd0xXQ/dnV07Fl0fy5Im2qJiBdALRf/U83RY9fSjlnGBZQSHJL9eq53rmw+
	 C+OfMiMYKTDWl/wqA3q5K/Dvk8tnfihxRUYpd8jPL2j9Tgs+jffJRkl7vb2JHdBLSlg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795043944;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=HF860mGzU7TKbFTTL6Jy017iLxAEcIwyL8TNFdpPGCI=;
	b=ZwYd8wF4DDn0UuO90zQno0QycxUk7knx0fCr7RSgfMs60QCZ8MMfKPAqGs9+6E1wRvvx
	 PEa+BFrZi1qAQyI1/3CKrNoW/frs592PE9B3cG2DEflboEDSE1QJLObxyK68PBBMVmih/
	 vaML3ap83Vh8nuBFwz7DlFOvgH8e8OVaCCs7zepdhY93hFmzv8VHsVPpDHo/NA9HlZotu
	 e7xaBBa9eXDbJMocW8uXAgZMefJd6YisAjHbEyMtXZxM4dxe4HLb2gDIa3TZXmNhpiz3L
	 z7g4SRYqkN2x/ALHlMhGz0xd/TINK03YHjk40jGKVXgDxq2b2QtdHC2loJqWcW9i32g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=sb+4w3f+;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9222F606A325;
	Wed, 18 Nov 2026 23:19:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=sb+4w3f+
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D8CE41F000C4;
	Wed, 18 Nov 2026 23:19:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795043944;
	bh=HF860mGzU7TKbFTTL6Jy017iLxAEcIwyL8TNFdpPGCI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=sb+4w3f+aKum1pBZ8sbNry6ZHBedHWOLqhHEW93wzEM7aRSLZLpAO901HOADMu1cv
	 Kka9/j2LR1VzC32DTp8cAu9G4mKo1ICL5uRj3PisGPWZp3xXPVy0cqCdRB3SvGrWUb
	 Z749ijRQ9z6TPojqRaR2nXKwoWa40Tj1xUpjWU80=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shuhei Takeshita <jyohuku.alterego@gmail.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0391/2857] IB/hfi1: Fix the PIO_CRED credit-return mmap
Date: Wed, 18 Nov 2026 15:23:45 +0100
Message-ID: <20261118150215.474955927@linuxfoundation.org>
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

From: Shuhei Takeshita <jyohuku.alterego@gmail.com>

[ Upstream commit 62f0f34fbd2b2d5653d33d3b9d42fdcabb1c0101 ]

hfi1_file_mmap()'s PIO_CRED case must hand user space the single
credit-return page that holds this context's entry.  That page is the
second or third page of the per-node credit-return allocation once the
hardware send context index reaches 64 or 128, so the failure below is
intermittent: when the entry lands on the first page the offset is zero
and everything works.

Two things are wrong.

First, cr_page_offset is a byte offset but .va is a struct
credit_return *, so adding it is pointer arithmetic and scales the offset
by sizeof(struct credit_return) == 64.  memvirt then lands 256 KiB or
512 KiB past a 10240-byte allocation.  With an IOMMU translating, that
address is inside the vmalloc range but in no vm_area, so
dma_mmap_coherent() -> iommu_dma_mmap() finds no pages, vmalloc_to_pfn()
returns page_to_pfn(NULL), and remap_pfn_range() installs a frame above
MAXPHYADDR.  The first user read then takes:

  psm2_ep_open_pr: Corrupted page table at address 7a14d007e000
  PGD 800000013886a067 P4D 800000013886a067 PUD 13886b067 PMD 13886c067
                                            PTE 800049168e911235
  Oops: Bad pagetable: 000d [#1] SMP PTI

Second, and still wrong once the arithmetic is corrected,
dma_mmap_coherent() describes a whole coherent buffer and selects the
page within it with vma->vm_pgoff.  Offsetting cpu_addr has no effect:
for a vmap'd allocation iommu_dma_mmap() uses cpu_addr only to locate the
vm_area and then maps pages[vm_pgoff], which hfi1_file_mmap() has just
set to 0.  User space therefore always receives the first credit-return
page, every credit read is for the wrong context, and send PIO stalls
forever.

Use the DMA API as intended: pass the base of the allocation with its
full length and select the page with vm_pgoff.  A separate length is
needed because memlen must keep describing the VMA for the existing size
check.  The dma-direct path stays correct as well, since dma_direct_mmap()
adds the same vm_pgoff to the base pfn.

Tested on a Dell T7610 (Xeon E5-2650 v2, Intel IOMMU in DMA-FQ mode)
against a Threadripper PRO 3995WX peer, both Omni-Path 100.  Before this
change psm2_ep_open() Oopses the kernel; with only the arithmetic
corrected psm2_ep_open() succeeds but any transfer that uses send PIO
hangs, PSM2_SDMA=2 (send PIO disabled) completing normally while
PSM2_SDMA=0 (send PIO only) hangs every time.  With this change send PIO,
send DMA and the default mixed mode all work.

Fixes: 1ec82317a1da ("IB/hfi1: Use dma_mmap_coherent for matching buffers")
Cc: stable@vger.kernel.org
Signed-off-by: Shuhei Takeshita <jyohuku.alterego@gmail.com>
Link: https://patch.msgid.link/20260809032743.2671579-3-jyohuku.alterego@gmail.com
Signed-off-by: Leon Romanovsky <leon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/hfi1/file_ops.c | 21 ++++++++++++++++-----
 1 file changed, 16 insertions(+), 5 deletions(-)

diff --git a/drivers/infiniband/hw/hfi1/file_ops.c b/drivers/infiniband/hw/hfi1/file_ops.c
index 1bc59d71c1d0b..bcdd7ac138ef3 100644
--- a/drivers/infiniband/hw/hfi1/file_ops.c
+++ b/drivers/infiniband/hw/hfi1/file_ops.c
@@ -328,6 +328,7 @@ static int hfi1_file_mmap(struct file *fp, struct vm_area_struct *vma)
 	void *memvirt = NULL;
 	dma_addr_t memdma = 0;
 	u8 subctxt, mapio = 0, vmf = 0, type;
+	size_t memdmalen = 0;
 	ssize_t memlen = 0;
 	int ret = 0;
 	u16 ctxt;
@@ -373,7 +374,9 @@ static int hfi1_file_mmap(struct file *fp, struct vm_area_struct *vma)
 		mapio = 1;
 		break;
 	case PIO_CRED: {
+		struct credit_return_base *cr = &dd->cr_base[uctxt->sc->node];
 		u64 cr_page_offset;
+
 		if (flags & VM_WRITE) {
 			ret = -EPERM;
 			goto done;
@@ -383,11 +386,18 @@ static int hfi1_file_mmap(struct file *fp, struct vm_area_struct *vma)
 		 * second or third page allocated for credit returns (if number
 		 * of enabled contexts > 64 and 128 respectively).
 		 */
-		cr_page_offset = ((u64)uctxt->sc->hw_free -
-				  (u64)dd->cr_base[uctxt->sc->node].va) &
+		cr_page_offset = ((u64)uctxt->sc->hw_free - (u64)cr->va) &
 				 PAGE_MASK;
-		memvirt = dd->cr_base[uctxt->sc->node].va + cr_page_offset;
-		memdma = dd->cr_base[uctxt->sc->node].dma + cr_page_offset;
+		/*
+		 * dma_mmap_coherent() describes the whole coherent buffer and
+		 * selects the page within it with vma->vm_pgoff, so pass the
+		 * base of the allocation and its length and let vm_pgoff pick
+		 * the page.
+		 */
+		vma->vm_pgoff = cr_page_offset >> PAGE_SHIFT;
+		memvirt = cr->va;
+		memdma = cr->dma;
+		memdmalen = TXE_NUM_CONTEXTS * sizeof(struct credit_return);
 		memlen = PAGE_SIZE;
 		flags &= ~VM_MAYWRITE;
 		flags |= VM_DONTCOPY | VM_DONTEXPAND;
@@ -569,7 +579,8 @@ static int hfi1_file_mmap(struct file *fp, struct vm_area_struct *vma)
 		ret = 0;
 	} else if (memdma) {
 		ret = dma_mmap_coherent(&dd->pcidev->dev, vma,
-					memvirt, memdma, memlen);
+					memvirt, memdma,
+					memdmalen ? memdmalen : memlen);
 	} else if (mapio) {
 		ret = io_remap_pfn_range(vma, vma->vm_start,
 					 PFN_DOWN(memaddr),
-- 
2.53.0



