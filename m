Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793831911;
	b=C56Cp/Y337znsuDIzZUEa1QihJOGJ+h7rZBEpjnzgUSy3xO2uRR/0+I1EHNgFepJCp3a
	 ck3EqFMitgx7BMiZ4TkOUdifYXIvrFBSi5FSo4c9Ffm3C27nM0sw2faLnfFwpj4IjoTGa
	 D44FKgDwtFA3btqDRVVBcwRaYuXKUFFzbdQdPI7TCjae3BDWFaHCgDjwf7U99PyUQs9qE
	 FZ2/vYxvFHqy+qxLx0Z0jHLv2nytZQbaNswCqylRX77wCGai/MqqhRL+Op2qEzFsNZl07
	 4aalGC1vMjtc0WhGKAZJxzpD6FLd62ITCCujL3RZM0k5/3vvwFSJpCnuXpJTth6bceQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793831911;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=+YM0S781jI2+ydPj8Iz7uG2eSjMaEo3byu2ElUHOTdc=;
	b=BSZ1/LmDlcvTXI3CsGcOj6LEtSUiCIho+I9rL2hEak8EsWbRQiYPnMJuwftb96GR79ld
	 meh7yfZE84SQef4OtcCQivv1nL3XAuSh5eNGUCdxPy1WLq0GemED40lOTDLfggn8EpItt
	 Evabm2JMhF/mUpIoOir0tf0aogf027No2s7TNKSgzFtnYmXLu32HU76DSKPJX3c4Sk5pH
	 uci/BWQrl8OTXyE/d9X69Y27CTZFCO1od2KdYbAggHIgbKQJ4eo2jrdt6wDH/zdhmz7RP
	 7UOK3d8rLSq9kYXMXfmIWOkdmWh6lrzSNoJT9m6bLN3cRhB5N8ZaPqyaO8vRsl63ZlA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=KMQRTXJo;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E0574606A32D;
	Wed,  4 Nov 2026 22:38:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=KMQRTXJo
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 32CB91F000C1;
	Wed,  4 Nov 2026 22:38:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793831910;
	bh=+YM0S781jI2+ydPj8Iz7uG2eSjMaEo3byu2ElUHOTdc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=KMQRTXJomPYl8qSTbfl6sFs2HuY5EBVA59GXjfm+aXm+8RLMOFPHeISfT9z+5nM1D
	 hBSJRpOW3sj6/n4cJblhLhsl7Pw9JvwikD25aES74YXZSGMB30D7UuBNQyulBH4TY2
	 SWFRTFALSwceMcSEPml9pCZQRjV8qqyLCe6MwMew=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chengfeng Ye <nicoyip.dev@gmail.com>,
	Kai Huang <kai.huang@intel.com>,
	Sean Christopherson <seanjc@google.com>
Subject: [PATCH 6.18 0938/1005] KVM: x86: Take SRCU in kvm_zap_gfn_range()
Date: Wed,  4 Nov 2026 16:11:11 -0500
Message-ID: <20261104211109.402543072@linuxfoundation.org>
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

From: Chengfeng Ye <nicoyip.dev@gmail.com>

commit b59a87c1ba3c347e8aec5f932eb7abf13064fd62 upstream.

kvm_zap_gfn_range() walks memslots and rmaps and may drop mmu_lock to
reschedule. Callers that do not already hold kvm->srcu (or slots_lock)
can race with memslot deletion: synchronize_srcu_expedited() does not
wait, kvm_free_memslot() frees the old slot and its rmap, and the zap
resumes on freed memory.

The VFIO noncoherent-DMA path hits this by zapping the entire GPA
space without SRCU. KASAN reported:

  BUG: KASAN: vmalloc-out-of-bounds in slot_rmap_walk_next+0x82/0x1c0
  Read of size 8 at addr ffffc900005c1008
  Call Trace:
   slot_rmap_walk_next+0x82/0x1c0
   __kvm_rmap_zap_gfn_range+0x17a/0x280
   kvm_zap_gfn_range+0x2a6/0x6a0
   kvm_vfio_set_attr+0x576/0x770
   kvm_device_ioctl+0x1ff/0x3b0

Take SRCU inside kvm_zap_gfn_range() so every caller is covered.
Nesting with an existing kvm->srcu critical section is fine; the
helper uses a local index. Drop the now-redundant SRCU pair from
__kvm_set_or_clear_apicv_inhibit().

Fixes: 362ff6dca541 ("KVM: x86/mmu: Zap KVM TDP when noncoherent DMA assignment starts/stops")
Cc: stable@vger.kernel.org
Signed-off-by: Chengfeng Ye <nicoyip.dev@gmail.com>
Reviewed-by: Kai Huang <kai.huang@intel.com>
Link: https://patch.msgid.link/20260825183924.237727-1-nicoyip.dev@gmail.com
Signed-off-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kvm/mmu/mmu.c |    2 ++
 arch/x86/kvm/x86.c     |    2 --
 2 files changed, 2 insertions(+), 2 deletions(-)

--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -6876,6 +6876,8 @@ void kvm_zap_gfn_range(struct kvm *kvm,
 	if (WARN_ON_ONCE(gfn_end <= gfn_start))
 		return;
 
+	guard(srcu)(&kvm->srcu);
+
 	write_lock(&kvm->mmu_lock);
 
 	kvm_mmu_invalidate_begin(kvm);
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -10619,10 +10619,8 @@ void __kvm_set_or_clear_apicv_inhibit(st
 		kvm->arch.apicv_inhibit_reasons = new;
 		if (new) {
 			unsigned long gfn = gpa_to_gfn(APIC_DEFAULT_PHYS_BASE);
-			int idx = srcu_read_lock(&kvm->srcu);
 
 			kvm_zap_gfn_range(kvm, gfn, gfn+1);
-			srcu_read_unlock(&kvm->srcu, idx);
 		}
 	} else {
 		kvm->arch.apicv_inhibit_reasons = new;


