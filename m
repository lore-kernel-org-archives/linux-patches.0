Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793213084;
	b=lSkZXEVVpGPePLjIyWLs+cNxc9Yc3ndtkWMqNNhXc2ZHVlYF0tNvePRI2DKXHdHaHvF4
	 fFB3wapFD+fauFqIfwqoxq6LGLbW7KhpK5lHFzgxo7iWs9pxyULN/RtPGEnOCmlopOS9b
	 UHESYjpQGFAzkVsvyrTcu2prlO3kduHDqGafXSsDQ1PePGHzkjFq+7R23vMNo7QUDGuFC
	 i2KBilYzJYOy8VFoeAcxX4XILK0jbd5vHQ2V/pfZCYFMe0a5GRbaMVaxobcwI3MSbQmpk
	 kHraVXaqmhD/zeOkqNTetcw9DCW6RpzKYg/qBF/msf++YEQBLjm9/4Y8Qs+NIG4LG1A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793213084;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=XpiN9LYDSG1A0KErjAe8RkJ2TzdTB6+Qrl6kyR3K/Cw=;
	b=T4rqfmiy0r9jL49+mmCUOdmocJ9gDu/dPNQ4IYaIzyr5WFIlJKqvQIAmrVGxIXy/u0b1
	 D9i/wwtk+asgeP6s+6dXDeZ2v7lAW1Fz45aktALQxc++Zk+swg7kP5esHFPWmlo2Sx2Xs
	 GsAUApoONMeQzgHXWlb3lIWs7qV9A01RmJA+nNU4BvpkPOzS4EPq1LDX5ubZro0/dKP6t
	 ekwsvAdAwLrd6JkqdOuxcMujjOqU1A//252o9T3dK+sTTccruvdtUc0f2Bn1NuZVgnsVG
	 QoZmZzXIIWfM8qu9M+81XwwxIM68pxEDdDMv78BE9K6+j6cG2JSryCnl4AmeNZEhdpA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=cPBU5NLx;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 68CD1606A325;
	Wed, 28 Oct 2026 18:44:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=cPBU5NLx
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 846011F01825;
	Wed, 28 Oct 2026 18:44:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793213084;
	bh=XpiN9LYDSG1A0KErjAe8RkJ2TzdTB6+Qrl6kyR3K/Cw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=cPBU5NLxnV1VgH6sBJVB19rOLYiNj9LFWbi03WysiidmI/2Cr6PJDCkEO9tmqIfYj
	 HdF8z5xxuxzQadFuGnV95s6190mlgQq4Ar8M8zVVL/61N7s6VBPllamKdSIdQueK01
	 gw8ocr4Et+cDGkD9fdWdw0sGrhu3S+tgQm1DqGRI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mostafa Saleh <smostafa@google.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0380/1887] KVM: arm64: Dont use the VMA to size stage-2 block mappings for VM_PFNMAP
Date: Wed, 28 Oct 2026 17:41:16 +0100
Message-ID: <20261028170507.879414337@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
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

From: Mostafa Saleh <smostafa@google.com>

[ Upstream commit 71cc2c67fb8f8d5aa8154eb482e9846d2214f11b ]

get_vma_page_shift() derives the stage-2 block size for VM_PFNMAP VMAs
from the VMA layout alone, which does not necessarily match what
stage-1 maps for that VMA.

Upstream commit 71cc2c67fb8f ("KVM: arm64: Use stage-1 leaf size for
VM_PFNMAP") drops that calculation and lets transparent_hugepage_adjust()
derive the mapping size from the stage-1 leaf instead. The second part
is not applicable here: in this kernel transparent_hugepage_adjust()
takes a reference on the backing struct page, which is not safe for
MMIO, and stage-1 has no huge PFNMAP before v6.12 anyway. Only drop the
VMA-based calculation, so VM_PFNMAP VMAs are mapped at PAGE_SIZE.

Fixes: 2aa53d68cee6 ("KVM: arm64: Try stage2 block mapping for host device MMIO")
Cc: stable@vger.kernel.org
Signed-off-by: Mostafa Saleh <smostafa@google.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/kvm/mmu.c | 25 ++-----------------------
 1 file changed, 2 insertions(+), 23 deletions(-)

diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
index 54ccdcc2dbdf7..2ccc623796429 100644
--- a/arch/arm64/kvm/mmu.c
+++ b/arch/arm64/kvm/mmu.c
@@ -1077,32 +1077,11 @@ transparent_hugepage_adjust(struct kvm *kvm, struct kvm_memory_slot *memslot,
 	return PAGE_SIZE;
 }
 
-static int get_vma_page_shift(struct vm_area_struct *vma, unsigned long hva)
+static int get_vma_page_shift(struct vm_area_struct *vma)
 {
-	unsigned long pa;
-
 	if (is_vm_hugetlb_page(vma) && !(vma->vm_flags & VM_PFNMAP))
 		return huge_page_shift(hstate_vma(vma));
 
-	if (!(vma->vm_flags & VM_PFNMAP))
-		return PAGE_SHIFT;
-
-	VM_BUG_ON(is_vm_hugetlb_page(vma));
-
-	pa = (vma->vm_pgoff << PAGE_SHIFT) + (hva - vma->vm_start);
-
-#ifndef __PAGETABLE_PMD_FOLDED
-	if ((hva & (PUD_SIZE - 1)) == (pa & (PUD_SIZE - 1)) &&
-	    ALIGN_DOWN(hva, PUD_SIZE) >= vma->vm_start &&
-	    ALIGN(hva, PUD_SIZE) <= vma->vm_end)
-		return PUD_SHIFT;
-#endif
-
-	if ((hva & (PMD_SIZE - 1)) == (pa & (PMD_SIZE - 1)) &&
-	    ALIGN_DOWN(hva, PMD_SIZE) >= vma->vm_start &&
-	    ALIGN(hva, PMD_SIZE) <= vma->vm_end)
-		return PMD_SHIFT;
-
 	return PAGE_SHIFT;
 }
 
@@ -1214,7 +1193,7 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
 		use_read_lock = (fault_status == FSC_PERM && write_fault &&
 				 fault_granule == PAGE_SIZE);
 	} else {
-		vma_shift = get_vma_page_shift(vma, hva);
+		vma_shift = get_vma_page_shift(vma);
 	}
 
 	shared = (vma->vm_flags & VM_SHARED);
-- 
2.53.0



