Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794061401;
	b=i1lzhaQcnyEq8OunjRtSvL7X3FkOxmn7OBGyPJ57HS5BaZMgTukgUFoqa7pYJkQj9uju
	 dE0qceAEgN521xMrBVb8Ec+E02Q/fHqNZALgkeUxGw3aGW8u7H2cdRbhweGRi6Dx56U5F
	 x9IRmoiYsn0n8nzTxqCmQTCttglSk1JLLPsd18PNpz4mBPaoiwfSNgkv+AzyUIjbY+gG1
	 eoSC91tUD8zTYWncbzDCKTXy0jQfW4DeYbukeMjTfptpfZkT/gRgHmqZDhNahWiVXswJh
	 kDWNkP75egCOuBm213s10wGGeD1R2xxJ6ElBQf2+MduBjg0cznZEKRLMG9cwCYWqb3Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794061401;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=T/WfDeVBdAJDMHq8HKdYfmF6RzpIgO8T5TmmQGzRHe8=;
	b=QFHS4kUH3VGiGF6AA0dvZzUkUraIaCvwOv2QGc/R+Q2iW3UIw/C8sGWIy7hh7I57CPKm
	 vBZotcCkB/1Wv+ksy5zL5VBwrJcIJIQNMcX438n9ycPwmZibFU2cdXteQdvFc87bMkcCJ
	 MMo4dQcLlyk0sVTQdDVfDhEuQlSOU7HIe4R++A4/hd80lTyAjflLGrCzEuaoByxSwWyXQ
	 X/RW8XLCirfL0EKH8heE3qFht0JE3wAbN6ugGA89in7W8TGRZhz3Qh68VQjjsGYqbMXnK
	 D0BaQoIFYqbQtrLFkbHCIIjAjos3vskc+4qgmTp+jmZKbawrXCv1/GX44M8FIAgUQOQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=XMdLPTNt;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5952F606A332;
	Sat,  7 Nov 2026 14:23:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=XMdLPTNt
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0464B1F0089F;
	Sat,  7 Nov 2026 14:23:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794061401;
	bh=T/WfDeVBdAJDMHq8HKdYfmF6RzpIgO8T5TmmQGzRHe8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=XMdLPTNtgx5pNB0CtDVMP6gqLw09b6yNKT+0zhwVnaNah8HAaiuOiGTuqpvUPnymE
	 alzeqdfDQlxKsDQCo/rkrUXzUocPn9Qds6qTXc9uZ+fncycWdb8W9l/eVeJkrMDMmx
	 NznbPpB8MkIOq6aURU/ebJykvOI55PXrWpNyTGt8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xie Bo <xb@ultrarisc.com>,
	Anup Patel <anup@brainfault.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0519/1536] RISC-V: KVM: Propagate interrupted G-stage faults
Date: Sat,  7 Nov 2026 08:42:15 -0500
Message-ID: <20261107135012.007403401@linuxfoundation.org>
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
index b63650f9b966a..55685f953cd51 100644
--- a/arch/riscv/kvm/mmu.c
+++ b/arch/riscv/kvm/mmu.c
@@ -653,6 +653,8 @@ int kvm_riscv_gstage_map(struct kvm_vcpu *vcpu,
 				vma_pageshift, current);
 		return 0;
 	}
+	if (is_sigpending_pfn(hfn))
+		return -EINTR;
 	if (is_error_noslot_pfn(hfn))
 		return -EFAULT;
 
diff --git a/arch/riscv/kvm/vcpu_exit.c b/arch/riscv/kvm/vcpu_exit.c
index fa98e5c024b21..14968edede833 100644
--- a/arch/riscv/kvm/vcpu_exit.c
+++ b/arch/riscv/kvm/vcpu_exit.c
@@ -215,7 +215,7 @@ int kvm_riscv_vcpu_exit(struct kvm_vcpu *vcpu, struct kvm_run *run,
 	}
 
 	/* Print details in-case of error */
-	if (ret < 0) {
+	if (ret < 0 && ret != -EINTR) {
 		kvm_err("VCPU exit error %d\n", ret);
 		kvm_err("SEPC=0x%lx SSTATUS=0x%lx HSTATUS=0x%lx\n",
 			vcpu->arch.guest_context.sepc,
-- 
2.53.0



