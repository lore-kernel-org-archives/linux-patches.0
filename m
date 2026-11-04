Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793831327;
	b=1s9nKvoKbCSy2/FQGN+fTqlm75P0siLzXwMZXe8v4HYlojCg66N9IgIq1vfGXwKbHZTv
	 9LQLjW+m9p3/BjLluLMbGCc4xF/FgjZT91AsV7UIMo+R5IrhcQ6vN2T86VIU8r+/9xTYY
	 Ipd0CbWmOYIIUOSJoBauYX286m3CefE1lTEJ3YVDfReHfFyzhpQlX6RQnUVsO3W4/vl2I
	 ic7jkdq0YeteIjMus8wGT1bnHy86jzszgLxgFrzaYIUDHnVgr2JT5BQvuCMpy4R24lq7U
	 9Kniy4m2HzyIl5u1ZiEzIJTFA0gj+mGnCpvvYaY46Bo/8Ny4QimvublSs7QesADzQ9w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793831327;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=rSPUPYoAqcG3vRo0UUlZ4CoLyb9RQMpOywXL8/NSVmk=;
	b=EDsXwy9DmlhbrXO7ZJMXLa8XNPQgVYndru5aEdcVJiFW1NvbfVOCLPqfpEB4tCtPqSU9
	 AAcekna0PgoBlaNDxiwCy+AHH7ZZVK3pMSAp5leeB/Apyd+ozPx2RlRhObbgAV1FA9nFh
	 R9m1IraO74yHfzSLRZKT64yM5bmRRMwTx9aWZq6/iHDLXAOIJrGum6qZUfvRCZd4ljY1p
	 UL9lhOvZVu+XbTsLJW1dVvfxUxdxpM6wzRnamr7COA4IBdnJzzD7cQGw49SWt/Do/JKTC
	 4FaWRrVacjNJnbZI4QxdbWf77RUV0cM9RkllR3E0xaNVSvH7ilxsjyoTJeByznbRuRA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Hc7mVJ31;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 77042606A33A;
	Wed,  4 Nov 2026 22:28:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Hc7mVJ31
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0BF081F000C1;
	Wed,  4 Nov 2026 22:28:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793831327;
	bh=rSPUPYoAqcG3vRo0UUlZ4CoLyb9RQMpOywXL8/NSVmk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Hc7mVJ31dURNEFw+AQ4BGjvUzRFrcPcevMJ6OYlEENYUcpEPFSpFNi6CwGrUww4Sa
	 KCtPP/qie9RFjsCR1sPw49jrFvy2xQoMBh02PXgeVT9kG3roqJMWCH7Peg9S3o6AKi
	 9oST1iMtCa047CiSWQIifLloZaM4FHxWRBD9RKPQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xie Bo <xb@ultrarisc.com>,
	Anup Patel <anup@brainfault.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0588/1005] RISC-V: KVM: Release unused page after MMU invalidation
Date: Wed,  4 Nov 2026 16:05:21 -0500
Message-ID: <20261104211100.335434089@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261104211043.516122098@linuxfoundation.org>
References: <20261104211043.516122098@linuxfoundation.org>
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

From: Xie Bo <xb@ultrarisc.com>

[ Upstream commit ed54fdb460a6e81d5f8f38388d1f10b385dd4a58 ]

If an MMU invalidation races with a G-stage fault, the fault handler skips
installing the page but leaves ret set to zero. As a result,
kvm_release_faultin_page() treats the page as used and can unnecessarily
mark it dirty.

Track the invalidation retry separately and release the page as unused,
while preserving the existing return value so that the vCPU retries the
fault.

Fixes: 2ed90cb0938a ("KVM: RISC-V: Retry fault if vma_lookup() results become invalid")
Cc: stable@vger.kernel.org
Signed-off-by: Xie Bo <xb@ultrarisc.com>
Reviewed-by: Anup Patel <anup@brainfault.org>
Link: https://lore.kernel.org/r/20260810051544.3953925-2-xb@ultrarisc.com
Signed-off-by: Anup Patel <anup@brainfault.org>
[ sashal: Dropped the is_hugetlb context line and used spin_lock/spin_unlock on mmu_lock instead of write_lock/write_unlock, so the unused flag hunks apply to this tree's older kvm_riscv_mmu_map(). ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/riscv/kvm/mmu.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/arch/riscv/kvm/mmu.c b/arch/riscv/kvm/mmu.c
index b5a809a091d60..bdc8243e9c947 100644
--- a/arch/riscv/kvm/mmu.c
+++ b/arch/riscv/kvm/mmu.c
@@ -308,6 +308,7 @@ int kvm_riscv_mmu_map(struct kvm_vcpu *vcpu, struct kvm_memory_slot *memslot,
 {
 	int ret;
 	kvm_pfn_t hfn;
+	bool unused = false;
 	bool writable;
 	short vma_pageshift;
 	gfn_t gfn = gpa >> PAGE_SHIFT;
@@ -394,8 +395,10 @@ int kvm_riscv_mmu_map(struct kvm_vcpu *vcpu, struct kvm_memory_slot *memslot,
 
 	spin_lock(&kvm->mmu_lock);
 
-	if (mmu_invalidate_retry(kvm, mmu_seq))
+	if (mmu_invalidate_retry(kvm, mmu_seq)) {
+		unused = true;
 		goto out_unlock;
+	}
 
 	if (writable) {
 		mark_page_dirty_in_slot(kvm, memslot, gfn);
@@ -410,7 +413,8 @@ int kvm_riscv_mmu_map(struct kvm_vcpu *vcpu, struct kvm_memory_slot *memslot,
 		kvm_err("Failed to map in G-stage\n");
 
 out_unlock:
-	kvm_release_faultin_page(kvm, page, ret && ret != -EEXIST, writable);
+	kvm_release_faultin_page(kvm, page,
+				 unused || (ret && ret != -EEXIST), writable);
 	spin_unlock(&kvm->mmu_lock);
 	return ret;
 }
-- 
2.53.0



