Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794060361;
	b=U0a0dbEFzn5Ai4SDV6NixF/BSWmuIN6d8PSNj/ZN63yJLstAnxQDq7qznd+DUln4/mV/
	 1Ytp2RwR0TIQUIhjxQ0kGjNH4++GJ+Jil3f8f/GqxZtWuU6Ii4u7O74twk12/DaYXIGhb
	 zlND2M7MgvlWr7NMI7HATNnoTcfbJtXrNs4rOBf1lK7mj1JWYimob/Sat8coQnZlG0OpL
	 oXSM9VgSege1N3CA8WEn3XRchSABeLXEjxWAGmANFEiydlcBbDL4dV2bT53Z5Rwpx3lu7
	 H7YlnflFTh2toqzD7CmEsiHK2HQjts7295QI47cXSajqT5VlfAEGdIvSuSoFNNm3JnA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794060361;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=idGcGtNsgjamBTuuPKe+HROIVPqSH81eipwnTxOuTaw=;
	b=iTzJyYytEIuVuPH65NyThOSWNqIWN2fVA0Qcj+t7tR8hw1+iVFSKoZF6ePTWpTRfbeIx
	 uGPCHTFfz5wnKgHMAK7NW2bRsroWbuJ+H7ZT5VqYwIMlPZxaodjA+HSl5Pq+p/FjoGfH1
	 adirY1MYgFy3uNv4Ar1D73SatKRbyteOzLFGMbIo3jOQBtoaS6bDXOB4XCSzk/x5IrUlZ
	 2WBk6mr350ZtDHhj2N0lOFAtB1Jrud5Du8n+OC4uGhe0to3ilsttUirU/t1QshVsMJINe
	 FakscmMR5WAa/XI96II8jfFLS/gfk5RPo2CVa8z7f9fqYdmdJr8h0dFT8emGjN2yhSA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=mWNGyXas;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B1775606A32C;
	Sat,  7 Nov 2026 14:06:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=mWNGyXas
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6831F1F00901;
	Sat,  7 Nov 2026 14:06:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794060360;
	bh=idGcGtNsgjamBTuuPKe+HROIVPqSH81eipwnTxOuTaw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=mWNGyXasYAg8rZMHBw8HlfxiskKAAWWNGht3Go0abBAu6u3EtehLInTI+qTGu9/cJ
	 t1NnsBp5AySbPU4rw1Frmqqc87uBMnAh6SI/Vce3mEA+eIQ66yGC85azzM3gRwHwzJ
	 a+VtPt5Oy59Mr5qGkgDrHxkQSls+LwrSjBsEAo2o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0005/1536] Revert "KVM: s390: Fix FOLL_*/FAULT_FLAG_* confusion"
Date: Sat,  7 Nov 2026 08:33:41 -0500
Message-ID: <20261107134957.822670420@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134957.653319350@linuxfoundation.org>
References: <20261107134957.653319350@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

This reverts commit f5b6a9fa37d0770f9977b9b3b9fb1dc6cb0423f3.

Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/s390/kvm/kvm-s390.c | 24 ++++++++++++------------
 1 file changed, 12 insertions(+), 12 deletions(-)

diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c
index 7bb5640bb8a71..8381f052dd4aa 100644
--- a/arch/s390/kvm/kvm-s390.c
+++ b/arch/s390/kvm/kvm-s390.c
@@ -4748,12 +4748,12 @@ static void kvm_s390_assert_primary_as(struct kvm_vcpu *vcpu)
  * @vcpu: the vCPU whose gmap is to be fixed up
  * @gfn: the guest frame number used for memslots (including fake memslots)
  * @gaddr: the gmap address, does not have to match @gfn for ucontrol gmaps
- * @foll: FOLL_* flags
+ * @flags: FOLL_* flags
  *
  * Return: 0 on success, < 0 in case of error.
  * Context: The mm lock must not be held before calling. May sleep.
  */
-int __kvm_s390_handle_dat_fault(struct kvm_vcpu *vcpu, gfn_t gfn, gpa_t gaddr, unsigned int foll)
+int __kvm_s390_handle_dat_fault(struct kvm_vcpu *vcpu, gfn_t gfn, gpa_t gaddr, unsigned int flags)
 {
 	struct kvm_memory_slot *slot;
 	unsigned int fault_flags;
@@ -4767,13 +4767,13 @@ int __kvm_s390_handle_dat_fault(struct kvm_vcpu *vcpu, gfn_t gfn, gpa_t gaddr, u
 	if (!slot || slot->flags & KVM_MEMSLOT_INVALID)
 		return vcpu_post_run_addressing_exception(vcpu);
 
-	fault_flags = foll & FOLL_WRITE ? FAULT_FLAG_WRITE : 0;
+	fault_flags = flags & FOLL_WRITE ? FAULT_FLAG_WRITE : 0;
 	if (vcpu->arch.gmap->pfault_enabled)
-		foll |= FOLL_NOWAIT;
+		flags |= FOLL_NOWAIT;
 	vmaddr = __gfn_to_hva_memslot(slot, gfn);
 
 try_again:
-	pfn = __kvm_faultin_pfn(slot, gfn, foll, &writable, &page);
+	pfn = __kvm_faultin_pfn(slot, gfn, flags, &writable, &page);
 
 	/* Access outside memory, inject addressing exception */
 	if (is_noslot_pfn(pfn))
@@ -4789,7 +4789,7 @@ int __kvm_s390_handle_dat_fault(struct kvm_vcpu *vcpu, gfn_t gfn, gpa_t gaddr, u
 			return 0;
 		vcpu->stat.pfault_sync++;
 		/* Could not setup async pfault, try again synchronously */
-		foll &= ~FOLL_NOWAIT;
+		flags &= ~FOLL_NOWAIT;
 		goto try_again;
 	}
 	/* Any other error */
@@ -4809,7 +4809,7 @@ int __kvm_s390_handle_dat_fault(struct kvm_vcpu *vcpu, gfn_t gfn, gpa_t gaddr, u
 	return rc;
 }
 
-static int vcpu_dat_fault_handler(struct kvm_vcpu *vcpu, unsigned long gaddr, unsigned int foll)
+static int vcpu_dat_fault_handler(struct kvm_vcpu *vcpu, unsigned long gaddr, unsigned int flags)
 {
 	unsigned long gaddr_tmp;
 	gfn_t gfn;
@@ -4834,18 +4834,18 @@ static int vcpu_dat_fault_handler(struct kvm_vcpu *vcpu, unsigned long gaddr, un
 		}
 		gfn = gpa_to_gfn(gaddr_tmp);
 	}
-	return __kvm_s390_handle_dat_fault(vcpu, gfn, gaddr, foll);
+	return __kvm_s390_handle_dat_fault(vcpu, gfn, gaddr, flags);
 }
 
 static int vcpu_post_run_handle_fault(struct kvm_vcpu *vcpu)
 {
-	unsigned int foll = 0;
+	unsigned int flags = 0;
 	unsigned long gaddr;
 	int rc;
 
 	gaddr = current->thread.gmap_teid.addr * PAGE_SIZE;
 	if (kvm_s390_cur_gmap_fault_is_write())
-		foll = FOLL_WRITE;
+		flags = FAULT_FLAG_WRITE;
 
 	switch (current->thread.gmap_int_code & PGM_INT_CODE_MASK) {
 	case 0:
@@ -4887,7 +4887,7 @@ static int vcpu_post_run_handle_fault(struct kvm_vcpu *vcpu)
 			send_sig(SIGSEGV, current, 0);
 		if (rc != -ENXIO)
 			break;
-		foll = FOLL_WRITE;
+		flags = FAULT_FLAG_WRITE;
 		fallthrough;
 	case PGM_PROTECTION:
 	case PGM_SEGMENT_TRANSLATION:
@@ -4897,7 +4897,7 @@ static int vcpu_post_run_handle_fault(struct kvm_vcpu *vcpu)
 	case PGM_REGION_SECOND_TRANS:
 	case PGM_REGION_THIRD_TRANS:
 		kvm_s390_assert_primary_as(vcpu);
-		return vcpu_dat_fault_handler(vcpu, gaddr, foll);
+		return vcpu_dat_fault_handler(vcpu, gaddr, flags);
 	default:
 		KVM_BUG(1, vcpu->kvm, "Unexpected program interrupt 0x%x, TEID 0x%016lx",
 			current->thread.gmap_int_code, current->thread.gmap_teid.val);
-- 
2.53.0



