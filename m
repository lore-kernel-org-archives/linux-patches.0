Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794590561;
	b=aALSZOcGE6+1IVbUYF5g+L3ar7HX/NIsaLGlAkbwFx7VULI5L0rxDsnx04ENZRIR88T1
	 YpTY34k7B0FAxkOcGrRlnYe+UNnlYjZlSuvOYFqajTL3DZ9wJSDFV04t8A7DR0KRC8Uut
	 +kseQtVHey3fBgZhucRfAOIafi5ZI5jZ/ALYXGBO3FFTvW2i3EHCEUffJcC+A/VKFI0fw
	 ETzVuVmJK9/CvT0p6cl/maQWPxpjfMAyuxjGrrLIcX4hWXg4zBLzailgzWDfDsXQVwyCs
	 hEoAMif8Sx/hdTfNuZ7XcBBiozxjKFz+6dKuWa2hQogT+x0NQQ0uyZN1R4I64wElWMw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794590561;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=AOXJqZbhPbBjWtNKIeuxxXT0afjotoV8YiiUxCrQtBI=;
	b=HaYO14GBaTm86IkySuFrqD+uUcAjlELdWObqxjkTlip+9Kl+4fi3Ub6WQ16zRXy8CTFD
	 e+SM0NlvxlMMcWpo8WVuCDCjBOjSYztQBQCK/NLhD/EP3eVbzMLPodoXYJqZg55N1VZhk
	 nEaz6Qyc/ouCl1KisYlHOvRjvqMm3bPoiyLngD7G7hzDKITL6uuoYoHGlDR9zsgLEpXoN
	 YHQjSP8vNEC5vHVs4fjKX2NM1deG2yCfVgHlHX9nCME3zFy4QxCRUMtYxwIgyubSrB/VH
	 266einfVUJVazeRWrO4/bXXcJxYsAVU8D6FIhRxypsY3+nv0zcudce3xZdHwSEPM+ww==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=FJXciCgc;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC79D606BD06;
	Fri, 13 Nov 2026 17:22:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=FJXciCgc
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7594B1F000C4;
	Fri, 13 Nov 2026 17:22:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794590560;
	bh=AOXJqZbhPbBjWtNKIeuxxXT0afjotoV8YiiUxCrQtBI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=FJXciCgceWYkMicFBcZkbm5ESX0fH8iKnQw83lsovpPkVOOePj7C39RAGmw+nUmjn
	 /tCbqvn4YFAc2YdxsZ9GHsXhPUJGr7M18NhKroL0POX/HEvqT7XQqA77i2ILbp9fa2
	 opmBJXzIVTJncTUdLtRIRMzjvgkSLGVUZCKLGI1M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko AI <sashiko-bot@kernel.org>,
	Vincent Donnefort <vdonnefort@google.com>,
	Itaru Kitayama <itaru.kitayama@fujitsu.com>,
	Wei-Lin Chang <weilin.chang@arm.com>,
	Marc Zyngier <maz@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 495/686] KVM: arm64: ptdump: Check the page tables arent freed when accessing
Date: Fri, 13 Nov 2026 10:50:28 -0500
Message-ID: <20261113153837.698510972@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153820.902362109@linuxfoundation.org>
References: <20261113153820.902362109@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Wei-Lin Chang <weilin.chang@arm.com>

[ Upstream commit 7d7199bdf77a3a6ed74d0037133f435a7febe97c ]

An open debugfs file keeps the KVM structure alive, but does not prevent
mmu notifier release from freeing the stage-2 page tables when the VMM’s
address space is torn down. Therefore page tables belonging to the mmus
could have been freed when a thread opens or reads the ptdump files.
Take the mmu_lock and check mmu->pgt is still alive before accessing the
page tables.

Also for the ipa_range file and stage2_levels file, switch from keeping
the pointer to the page tables to keeping the pointer to the mmu.

Fixes: 7c4f73548ed1 ("KVM: arm64: Register ptdump with debugfs on guest creation")
Reported-by: Sashiko AI <sashiko-bot@kernel.org>
Closes: https://lore.kernel.org/kvmarm/20260623144054.B91D21F000E9@smtp.kernel.org/
Reviewed-by: Vincent Donnefort <vdonnefort@google.com>
Tested-by: Vincent Donnefort <vdonnefort@google.com>
Tested-by: Itaru Kitayama <itaru.kitayama@fujitsu.com>
Signed-off-by: Wei-Lin Chang <weilin.chang@arm.com>
Cc: stable@vger.kernel.org
Link: https://patch.msgid.link/20260924094951.727352-2-weilin.chang@arm.com
Signed-off-by: Marc Zyngier <maz@kernel.org>
[ sashal: copied ia_bits alongside start_level under mmu_lock to accommodate parser initialization during open ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/kvm/ptdump.c | 50 +++++++++++++++++++++++++++++------------
 1 file changed, 36 insertions(+), 14 deletions(-)

diff --git a/arch/arm64/kvm/ptdump.c b/arch/arm64/kvm/ptdump.c
index dc5acfb00af91..8e4966194be49 100644
--- a/arch/arm64/kvm/ptdump.c
+++ b/arch/arm64/kvm/ptdump.c
@@ -97,22 +97,35 @@ static struct kvm_ptdump_guest_state *kvm_ptdump_parser_create(struct kvm *kvm)
 {
 	struct kvm_ptdump_guest_state *st;
 	struct kvm_s2_mmu *mmu = &kvm->arch.mmu;
-	struct kvm_pgtable *pgtable = mmu->pgt;
+	s8 start_level;
+	u32 ia_bits;
 	int ret;
 
+	/*
+	 * We only need the pgt start level and IPA size to initialize the ptdump,
+	 * get them while holding the mmu_lock. It's fine if the pgt gets freed
+	 * afterwards, we'll check again when doing the actual dump.
+	 */
+	scoped_guard(read_lock, &kvm->mmu_lock) {
+		if (!mmu->pgt)
+			return ERR_PTR(-ENOENT);
+		start_level = mmu->pgt->start_level;
+		ia_bits = mmu->pgt->ia_bits;
+	}
+
 	st = kzalloc(sizeof(struct kvm_ptdump_guest_state), GFP_KERNEL_ACCOUNT);
 	if (!st)
 		return ERR_PTR(-ENOMEM);
 
-	ret = kvm_ptdump_build_levels(&st->level[0], pgtable->start_level);
+	ret = kvm_ptdump_build_levels(&st->level[0], start_level);
 	if (ret) {
 		kfree(st);
 		return ERR_PTR(ret);
 	}
 
 	st->ipa_marker[0].name		= "Guest IPA";
-	st->ipa_marker[1].start_address = BIT(pgtable->ia_bits);
-	st->range[0].end		= BIT(pgtable->ia_bits);
+	st->ipa_marker[1].start_address = BIT(ia_bits);
+	st->range[0].end		= BIT(ia_bits);
 
 	st->kvm				= kvm;
 	st->parser_state = (struct ptdump_pg_state) {
@@ -141,9 +154,11 @@ static int kvm_ptdump_guest_show(struct seq_file *m, void *unused)
 
 	parser_state->seq = m;
 
-	write_lock(&kvm->mmu_lock);
+	guard(write_lock)(&kvm->mmu_lock);
+	if (!mmu->pgt)
+		return 0;
+
 	ret = kvm_pgtable_walk(mmu->pgt, 0, BIT(mmu->pgt->ia_bits), &walker);
-	write_unlock(&kvm->mmu_lock);
 
 	return ret;
 }
@@ -193,17 +208,27 @@ static const struct file_operations kvm_ptdump_guest_fops = {
 
 static int kvm_pgtable_range_show(struct seq_file *m, void *unused)
 {
-	struct kvm_pgtable *pgtable = m->private;
+	struct kvm_s2_mmu *mmu = m->private;
+	struct kvm *kvm = kvm_s2_mmu_to_kvm(mmu);
+
+	guard(read_lock)(&kvm->mmu_lock);
+
+	if (mmu->pgt)
+		seq_printf(m, "%2u\n", mmu->pgt->ia_bits);
 
-	seq_printf(m, "%2u\n", pgtable->ia_bits);
 	return 0;
 }
 
 static int kvm_pgtable_levels_show(struct seq_file *m, void *unused)
 {
-	struct kvm_pgtable *pgtable = m->private;
+	struct kvm_s2_mmu *mmu = m->private;
+	struct kvm *kvm = kvm_s2_mmu_to_kvm(mmu);
+
+	guard(read_lock)(&kvm->mmu_lock);
+
+	if (mmu->pgt)
+		seq_printf(m, "%1d\n", KVM_PGTABLE_MAX_LEVELS - mmu->pgt->start_level);
 
-	seq_printf(m, "%1d\n", KVM_PGTABLE_MAX_LEVELS - pgtable->start_level);
 	return 0;
 }
 
@@ -211,15 +236,12 @@ static int kvm_pgtable_debugfs_open(struct inode *m, struct file *file,
 				    int (*show)(struct seq_file *, void *))
 {
 	struct kvm *kvm = m->i_private;
-	struct kvm_pgtable *pgtable;
 	int ret;
 
 	if (!kvm_get_kvm_safe(kvm))
 		return -ENOENT;
 
-	pgtable = kvm->arch.mmu.pgt;
-
-	ret = single_open(file, show, pgtable);
+	ret = single_open(file, show, &kvm->arch.mmu);
 	if (ret < 0)
 		kvm_put_kvm(kvm);
 	return ret;
-- 
2.53.0



