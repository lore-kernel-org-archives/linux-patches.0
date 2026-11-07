Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794064165;
	b=GrHYmkU0mAtt13ZHU+cU563zmpSnND4I2B3gNKSLDwQueqUJ+fi2uOtxa0z8IFzgBVTg
	 qBlB1m/bUAt2IGxtuNRq4WYxyY8w5wZ4/ccarRXYRlTRjHqJcDPxJqvtb/IjN7XWyaruc
	 nDCbP/JgkR6yXEOMk+606hJt7DKvFnjnWgT0Vw4eScZ8nb7X7L0uczPR23fcI1glGl5kE
	 fdSeZH8yhXsMr2VijA63G5ge+8lKiwBkuJF4qRgRuPm0z2FG4wQ82gz3oMbsCl/p9gFkJ
	 L1s+cCsAGrcV9QMbI7tLiPprVseyvY+cwvXKCIS9diJOFuKRzYOSo/cFwAhHLJJ8Y1g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794064165;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=dixo/ybMhqVieDEF0IxBPoV75WNoGx5XXrVMZqWmj0g=;
	b=kwzXruSlX5GSZQicxuXUgWtalUn9B4i0ze4TSB6cgQUdNOflsVvfxnBUG2yPtmxxEKTv
	 oDNe3jrBbUk6NrmSXnQR6Pt4Ei5FoKsgB1GuHilbsQQluwFg11+OBK6FEeDZfiWBQP0+X
	 5SGckX6mc+TMlxQnzkQaEYIkoPGM2j2J1WvmtzEUcmzJCT2FuAZPFOhjJD0Scawaf5s2w
	 zr8AGM/CCVbZ0zEadRMFE2gGB/ageQDd+K5OhT412PvyBI5OH1RQpWxdbu71waJICSqT/
	 a18PjHb4q2k4xQu/gxKmaMEiLekxHaMhtQcWu2r9/tVAD6VcOjGBZN4B128jBal2hrQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=F1+q0BAH;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B195C606A32E;
	Sat,  7 Nov 2026 15:09:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=F1+q0BAH
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 639E61F008A1;
	Sat,  7 Nov 2026 15:09:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794064164;
	bh=dixo/ybMhqVieDEF0IxBPoV75WNoGx5XXrVMZqWmj0g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=F1+q0BAH6deVrIhlOiyRbGinWcapgx77HV/2LON8McfEaQk1fZGsj9ukHukcl6ITm
	 6EFbpu43u9x5M/O2HHLgJZehOPHXf5xc/nEmrdeZt1K4Bp3WoMdqyaaeJlxdptFFsY
	 wSAmtBkukik9ac9OZHlK5xK/7X6u+FehG6ZAl+Vc=
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
Subject: [PATCH 7.3 0294/1257] KVM: arm64: ptdump: Check the page tables arent freed when accessing
Date: Sat,  7 Nov 2026 08:43:10 -0500
Message-ID: <20261107134947.587199280@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

7.3-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/kvm/ptdump.c | 43 +++++++++++++++++++++++++++++++----------
 1 file changed, 33 insertions(+), 10 deletions(-)

diff --git a/arch/arm64/kvm/ptdump.c b/arch/arm64/kvm/ptdump.c
index 69899797dbad8..b5a0584260e8b 100644
--- a/arch/arm64/kvm/ptdump.c
+++ b/arch/arm64/kvm/ptdump.c
@@ -115,15 +115,28 @@ static int kvm_ptdump_build_levels(struct ptdump_pg_level *level, u32 start_lvl)
 
 static struct kvm_ptdump_guest_state *kvm_ptdump_parser_create(struct kvm_s2_mmu *mmu)
 {
+	struct kvm *kvm = kvm_s2_mmu_to_kvm(mmu);
 	struct kvm_ptdump_guest_state *st;
-	struct kvm_pgtable *pgtable = mmu->pgt;
+	s8 start_level;
 	int ret;
 
+	/*
+	 * We only need the pgt start level to initialize the ptdump, get it
+	 * while holding the mmu_lock. It's fine if the pgt gets freed
+	 * afterwards, we'll check again when doing the actual dump.
+	 */
+	scoped_guard(read_lock, &kvm->mmu_lock) {
+		if (mmu->pgt)
+			start_level = mmu->pgt->start_level;
+		else
+			return ERR_PTR(-ENOENT);
+	}
+
 	st = kzalloc_obj(struct kvm_ptdump_guest_state, GFP_KERNEL_ACCOUNT);
 	if (!st)
 		return ERR_PTR(-ENOMEM);
 
-	ret = kvm_ptdump_build_levels(&st->level[0], pgtable->start_level);
+	ret = kvm_ptdump_build_levels(&st->level[0], start_level);
 	if (ret) {
 		kfree(st);
 		return ERR_PTR(ret);
@@ -149,6 +162,9 @@ static int kvm_ptdump_guest_show(struct seq_file *m, void *unused)
 	};
 
 	guard(write_lock)(&kvm->mmu_lock);
+	if (!mmu->pgt)
+		return 0;
+
 	st->parser_state = (struct ptdump_pg_state) {
 		.marker		= &st->ipa_marker[0],
 		.end_address	= BIT(mmu->pgt->ia_bits),
@@ -211,17 +227,27 @@ static const struct file_operations kvm_ptdump_guest_fops = {
 
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
 
@@ -230,15 +256,12 @@ static int kvm_pgtable_debugfs_open(struct inode *m, struct file *file,
 {
 	struct kvm_s2_mmu *mmu = m->i_private;
 	struct kvm *kvm = kvm_s2_mmu_to_kvm(mmu);
-	struct kvm_pgtable *pgtable;
 	int ret;
 
 	if (!kvm_get_kvm_safe(kvm))
 		return -ENOENT;
 
-	pgtable = mmu->pgt;
-
-	ret = single_open(file, show, pgtable);
+	ret = single_open(file, show, mmu);
 	if (ret < 0)
 		kvm_put_kvm(kvm);
 	return ret;
-- 
2.53.0



