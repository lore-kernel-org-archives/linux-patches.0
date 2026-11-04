Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793827210;
	b=nyWg7dCajtur4XPirGorS7j6KJegxPQ/qtszZvZFKu/QxD6BNhespAgAMXznDHp/sLOV
	 euXchQx7BdwWDQAI0j9sHW2d5O+vfLxwO6cDQD/tnccHDrCghLbF148SO5ycOR2iiD3uK
	 qDWxmltOQHg5aH4LFsUbdadPCpYC5W7x3d74CIsSORoeYksl1fr0YcGE2vci6DXbaALlG
	 5a6FLxLukGqLJwdbaWhi+zn8wTW3TuBivMMEOXMmgfwH2SiO7qNX+Nd0OuCPt+FlpT17P
	 odSFXHSTuhqR/rCvPfGG+TFrD5sP2Y4HgUqRP+pWPxNWTKq81qr7Tf0fTfS+lhY/J/Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793827210;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=iaANhY+yD4ah89ykbbrEOtG3CXrG11C61CND8OkOv3U=;
	b=YGSbm7LkUAMBvq2yJ/gTunIZAUsxNNPxUE0FNBPXSc0P1/bfEtwlr1T5iJ1s2PU8nOjV
	 aKj5WcdQnk69qlSwsRRVC4KUn+cD7A5FSup1vlKYU5c4igsulDED7l74EUHqsMG30DCVd
	 x2WyO04sxRShm2GJFmcXrnpbfRDZ/RiXYSsLTwf+F7UCzCoifc5izkDbzLmcuNOpkxDw4
	 epHPszRBX1U9LT3eq3Bh2X6SqxFBXEAEcdVEj1VIANV/KDRd+rhI9vE37XRoB4c+BpXQr
	 Vow07WvkDAkQTwk4BlpB1PN48w/x9uNT1JDGU2D/b05zdolzUYJXeDVn4E1YTeejOUg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=uAAA9xA3;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 90338606B39A;
	Wed,  4 Nov 2026 21:20:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=uAAA9xA3
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 392EF1F000C1;
	Wed,  4 Nov 2026 21:20:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793827209;
	bh=iaANhY+yD4ah89ykbbrEOtG3CXrG11C61CND8OkOv3U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=uAAA9xA3mMGlA2Y5wR6YaFDgSIoYmMEJE05sUHDRaYPiSjsXAauhaa7MR/czbA0iK
	 svd9WXom/He2FhriSARetufRiIo3mlkuac4hqhGqiZ4U7i8ry1NcXhZxyrCEFZxIwj
	 Zbmhgz1OxRvYKqXRZtGF2VHS6+sGzGdyNqUWaleg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sean Christopherson <seanjc@google.com>,
	syzbot+0948c82180d475ad24e2@syzkaller.appspotmail.com,
	syzbot+fb7c2dd166d3ea63df2a@syzkaller.appspotmail.com,
	David Woodhouse <dwmw@amazon.co.uk>,
	Paul Durrant <paul@xen.org>,
	Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH 7.3 223/547] KVM: pfncache: use a dedicated invalidation sequence for cache refresh
Date: Wed,  4 Nov 2026 16:06:47 -0500
Message-ID: <20261104211044.493660396@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261104211038.406938024@linuxfoundation.org>
References: <20261104211038.406938024@linuxfoundation.org>
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

From: David Woodhouse <dwmw@amazon.co.uk>

commit da260bcb56feeb6489a83f310308453a0a7de25e upstream.

The gfn_to_pfn_cache refresh path guards against mmu notifier
invalidations which complete while it has dropped gpc->lock for the
HVA->PFN lookup: hva_to_pfn_retry() samples kvm->mmu_invalidate_seq
and retries if it changed, or if mn_active_invalidate_count is still
elevated.

That is insufficient for HVA-based caches. mmu_invalidate_seq is only
advanced by kvm_mmu_invalidate_end() when the invalidated range
overlaps a memslot, and an HVA-based cache (e.g. the Xen shared_info
page mapped with KVM_XEN_ATTR_TYPE_SHARED_INFO_HVA) need not be backed
by any memslot at all. An invalidation of the cached HVA which starts
and ends entirely within the lookup window is thus invisible to the
retry check: mn_active_invalidate_count is back to zero and the
sequence never moved. The refresh then publishes a mapping of a page
which has already been freed, and the next reader dereferences it:

  BUG: KASAN: use-after-free in kvm_xen_shared_info_init+0x3c6/0x440
  Read of size 4 at addr ffff8880599c2900 by task syz.2.383/7257

Since gfn_to_pfn_cache_invalidate_start() deliberately skips caches
which are not currently valid (including one whose refresh is in
progress, as the refresh clears the valid flag before dropping the
lock), the retry check is the only line of defence, and it must fire
for *any* invalidation, not just those hitting a memslot.

Add a dedicated kvm->gpc_invalidate_seq, incremented by every
kvm_mmu_notifier_invalidate_range_end() under mn_invalidate_lock
before mn_active_invalidate_count is decremented, and check it in
hva_to_pfn_retry() instead of mmu_invalidate_seq. Incrementing in
range_end() in the same critical section as the in-progress count
also closes the variant where the cache is activated with the
contested HVA only after invalidate_range_start() has run.

The same bug is also reachable through the per-vCPU vcpu_info cache
(KVM_XEN_VCPU_ATTR_TYPE_VCPU_INFO_HVA), where the stale mapping is
then dereferenced by kvm_setup_guest_pvclock() on the next KVM_RUN:

  BUG: KASAN: use-after-free in kvm_setup_guest_pvclock+0x5bf/0x660

This intentionally makes refresh retry on *unrelated* mmu notifier
events; restoring precision (and reworking the GPC locking more
generally) is left for a subsequent series.

Reproducers: https://david.woodhou.se/xen_shinfo_race.c
             https://david.woodhou.se/vcpu_info_race.c

Suggested-by: Sean Christopherson <seanjc@google.com>
Reported-by: syzbot+0948c82180d475ad24e2@syzkaller.appspotmail.com
Closes: https://lore.kernel.org/all/6a0c5f2c.a00a0220.2c7954.0000.GAE@google.com/
Tested-by: syzbot+0948c82180d475ad24e2@syzkaller.appspotmail.com
Reported-by: syzbot+fb7c2dd166d3ea63df2a@syzkaller.appspotmail.com
Closes: https://lore.kernel.org/all/6a426dd2.854d4ab9.360e1d.0008.GAE@google.com/
Fixes: b9220d32799a ("KVM: x86/xen: allow shared_info to be mapped by fixed HVA")
Cc: stable@vger.kernel.org
Signed-off-by: David Woodhouse <dwmw@amazon.co.uk>
Assisted-by: Claude:claude-mythos-5
Reviewed-by: Paul Durrant <paul@xen.org>
Link: https://patch.msgid.link/20260831213632.81023-13-dwmw2@infradead.org
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/linux/kvm_host.h |    2 ++
 virt/kvm/kvm_main.c      |   10 ++++++++++
 virt/kvm/pfncache.c      |   18 +++++++++---------
 3 files changed, 21 insertions(+), 9 deletions(-)

--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -854,6 +854,8 @@ struct kvm {
 	gfn_t mmu_invalidate_range_start;
 	gfn_t mmu_invalidate_range_end;
 
+	unsigned long gpc_invalidate_seq;
+
 	struct list_head devices;
 	u64 manual_dirty_log_protect;
 	struct dentry *debugfs_dentry;
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -813,6 +813,16 @@ static void kvm_mmu_notifier_invalidate_
 
 	/* Pairs with the increment in range_start(). */
 	spin_lock(&kvm->mn_invalidate_lock);
+	kvm->gpc_invalidate_seq++;
+
+	/*
+	 * As with the MMU sequence counter and mmu_invalidate_in_progress, the
+	 * GPC sequence increase must be visible before the invalidate count
+	 * goes to zero.  Pairs with the smp_rmb() in
+	 * mmu_notifier_retry_cache().
+	 */
+	smp_wmb();
+
 	if (!WARN_ON_ONCE(!kvm->mn_active_invalidate_count))
 		--kvm->mn_active_invalidate_count;
 	wake = !kvm->mn_active_invalidate_count;
--- a/virt/kvm/pfncache.c
+++ b/virt/kvm/pfncache.c
@@ -124,7 +124,7 @@ static void gpc_unmap(kvm_pfn_t pfn, voi
 #endif
 }
 
-static inline bool mmu_notifier_retry_cache(struct kvm *kvm, unsigned long mmu_seq)
+static inline bool mmu_notifier_retry_cache(struct kvm *kvm, unsigned long gpc_seq)
 {
 	/*
 	 * mn_active_invalidate_count acts for all intents and purposes
@@ -136,20 +136,20 @@ static inline bool mmu_notifier_retry_ca
 	 * Note, it does not matter that mn_active_invalidate_count
 	 * is not protected by gpc->lock.  It is guaranteed to
 	 * be elevated before the mmu_notifier acquires gpc->lock, and
-	 * isn't dropped until after mmu_invalidate_seq is updated.
+	 * isn't dropped until after gpc_invalidate_seq is updated.
 	 */
 	if (kvm->mn_active_invalidate_count)
 		return true;
 
 	/*
 	 * Ensure mn_active_invalidate_count is read before
-	 * mmu_invalidate_seq.  This pairs with the smp_wmb() in
-	 * mmu_notifier_invalidate_range_end() to guarantee either the
+	 * gpc_invalidate_seq.  This pairs with the smp_wmb() in
+	 * kvm_mmu_notifier_invalidate_range_end() to guarantee either the
 	 * old (non-zero) value of mn_active_invalidate_count or the
-	 * new (incremented) value of mmu_invalidate_seq is observed.
+	 * new (incremented) value of gpc_invalidate_seq is observed.
 	 */
 	smp_rmb();
-	return kvm->mmu_invalidate_seq != mmu_seq;
+	return kvm->gpc_invalidate_seq != gpc_seq;
 }
 
 static kvm_pfn_t hva_to_pfn_retry(struct gfn_to_pfn_cache *gpc)
@@ -158,7 +158,7 @@ static kvm_pfn_t hva_to_pfn_retry(struct
 	void *old_khva = (void *)PAGE_ALIGN_DOWN((uintptr_t)gpc->khva);
 	kvm_pfn_t new_pfn = KVM_PFN_ERR_FAULT;
 	void *new_khva = NULL;
-	unsigned long mmu_seq;
+	unsigned long gpc_seq;
 	struct page *page;
 
 	struct kvm_follow_pfn kfp = {
@@ -181,7 +181,7 @@ static kvm_pfn_t hva_to_pfn_retry(struct
 	gpc->valid = false;
 
 	do {
-		mmu_seq = gpc->kvm->mmu_invalidate_seq;
+		gpc_seq = gpc->kvm->gpc_invalidate_seq;
 		smp_rmb();
 
 		write_unlock_irq(&gpc->lock);
@@ -232,7 +232,7 @@ static kvm_pfn_t hva_to_pfn_retry(struct
 		 * attempting to refresh.
 		 */
 		WARN_ON_ONCE(gpc->valid);
-	} while (mmu_notifier_retry_cache(gpc->kvm, mmu_seq));
+	} while (mmu_notifier_retry_cache(gpc->kvm, gpc_seq));
 
 	gpc->valid = true;
 	gpc->pfn = new_pfn;


