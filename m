Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795034763;
	b=gMGyBxPDCVrCeYitXsVCxKUXpTOEq0c3uwnUmfI7ZwEnbRIZBHl3yMyYwHutDSRqVUFv
	 GjIFnH18Qs6QdRdZlPdzO9Z3M7+SA3CEoInVycO+9qF7btKppLFhRrdES4Nwde0NSmZzV
	 4VZxZ3ZVLJs8p5v83Uilmer7zE2rMdCbgf7FONK8FKcYsifa6Fs0Woa9+J6HxT5rboMXR
	 u6DslDGbSQuJzZf+eh16AdiDTQYXMXRbGQl8YjKmrDBbW6ACwtP89PVEzGYmvM9wLEf/S
	 /LlYYuED33Noo9L8rcpr4AFKmSIaZLEOE5lE62UcfsphnKePy6MQPBVOpxM6cFGfGig==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795034763;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=zFgg4BmRyj61ZwAEpxWe27bcWerYodE1K6LlpD18zns=;
	b=jJfCektzKv9wWaxKRynLAo69bcqpxqw7QkJl9urwm5rCxeqdISlWuBDxOwnD0qmGCvcQ
	 TqsXmbMBxJDJL5VOknzwsKAU8GUD1cv3yNA98j1SoCgUhX+SQK7gyrvAv9Wgt9JrrpFg3
	 G1lWhKNTlEe9yc0PuCVM5hz7tr7i73lPIcgRIb2fokUkIDgqppqPKgyBkRWLWBy0zB/ls
	 ydJNWlo1elubY/xIFjxy/8xm19TD+yVEE9xWGFMnIbs6h7SdVZXnQvvGbaS5WJgs8jUvH
	 457+X7h2i9cXDL+p4QMqG5lKLwogieLKXh0W/d0tP8feICMlYW65TUsgciUXTrtTRZQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=A8KfGFwE;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B93E8606A320;
	Wed, 18 Nov 2026 20:46:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=A8KfGFwE
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3FFE31F000C4;
	Wed, 18 Nov 2026 20:46:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795034763;
	bh=zFgg4BmRyj61ZwAEpxWe27bcWerYodE1K6LlpD18zns=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=A8KfGFwEpWUQM7LvHeDsmPeA+tH6Wt4NiQ1y/QxjmLFzCRuOFcgEajAqu73esOyzM
	 uJF9rDJhWMLf/p/Zixl67dc2tJ6n1j/fjd3GTVAhCFHvXAxLeMOwNkV9jrsecLAl/m
	 60MWeIdJrhiv1qoLWThNk/HC3HMg3/sM38ESOly4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xie Bo <xb@ultrarisc.com>,
	Anup Patel <anup@brainfault.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0482/3318] RISC-V: KVM: Propagate interrupted G-stage faults
Date: Wed, 18 Nov 2026 15:18:24 +0100
Message-ID: <20261118150331.420824436@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Xie Bo <xb@ultrarisc.com>

[ Upstream commit f41fb17143df890855d3de980f8eb92dfd595817 ]

__kvm_faultin_pfn() reports an interrupted host page fault with
KVM_PFN_ERR_SIGPENDING. RISC-V currently handles it as a generic
error PFN and returns -EFAULT.

Return -EINTR for the signal-pending sentinel so callers can distinguish
an interrupted fault from an invalid userspace mapping. Do not log the
expected interruption as a vCPU exit error.

Fixes: 9d05c1fee837 ("RISC-V: KVM: Implement stage2 page table programming")
Cc: stable@vger.kernel.org
Signed-off-by: Xie Bo <xb@ultrarisc.com>
Reviewed-by: Anup Patel <anup@brainfault.org>
Link: https://lore.kernel.org/r/20260810051544.3953925-3-xb@ultrarisc.com
Signed-off-by: Anup Patel <anup@brainfault.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/riscv/kvm/mmu.c       | 2 ++
 arch/riscv/kvm/vcpu_exit.c | 2 +-
 2 files changed, 3 insertions(+), 1 deletion(-)

diff --git a/arch/riscv/kvm/mmu.c b/arch/riscv/kvm/mmu.c
index a9e2fd7245e1e..5e289af4ebdf7 100644
--- a/arch/riscv/kvm/mmu.c
+++ b/arch/riscv/kvm/mmu.c
@@ -673,6 +673,8 @@ int kvm_riscv_gstage_map(struct kvm_vcpu *vcpu,
 				vma_pageshift, current);
 		return 0;
 	}
+	if (is_sigpending_pfn(hfn))
+		return -EINTR;
 	if (is_error_noslot_pfn(hfn))
 		return -EFAULT;
 
diff --git a/arch/riscv/kvm/vcpu_exit.c b/arch/riscv/kvm/vcpu_exit.c
index 2415722c01b8e..671744b651fba 100644
--- a/arch/riscv/kvm/vcpu_exit.c
+++ b/arch/riscv/kvm/vcpu_exit.c
@@ -209,7 +209,7 @@ int kvm_riscv_vcpu_exit(struct kvm_vcpu *vcpu, struct kvm_run *run,
 	}
 
 	/* Print details in-case of error */
-	if (ret < 0) {
+	if (ret < 0 && ret != -EINTR) {
 		kvm_err("VCPU exit error %d\n", ret);
 		kvm_err("SEPC=0x%lx SSTATUS=0x%lx HSTATUS=0x%lx\n",
 			vcpu->arch.guest_context.sepc,
-- 
2.53.0



