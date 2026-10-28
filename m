Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793214477;
	b=DzoNMmOeTaRjiIxIeOIHeiB2i8UxnvwsdqDBTqx0fAkSK1mRCOMvAZcHLvFwYrrr8wdW
	 iVtlTU3R3uqubyGv3DOuTKYcED2+H6wkcUEV3S2iazUT3tpKF9WkvZcNMJ+yAbr/wmaHC
	 X/uuH8Ya72+Nf2FKgmgZ+z/16X/MdxW6UdeUrls0sD1scrYS5krz3tRmtLm3G2A/Bfu/T
	 aPZ2K31QhigOmLxq9KmuT0SQVwG1r+pufQR5tqFJk262Y50lPbPmtV4EOtZMLoKbsYtfK
	 6Xs+D4Nj9pvtJyaZxTE7Bj4I2E33ZefxBFBzY9yKWfjX5nS0yulebbsnFiWk1ukE37Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793214477;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=lNDjeBEB3aKIjYN0L6/KKHXqxa3XFvzlN+B7VhJvqGc=;
	b=I1f4bXdSCvNS/nY6JHqhg6b7/MkP8XpDN6SorT5jutDucz22e6D36fdrusz+eWByYRFT
	 vseiGxr3SUOc+Bief6VoVm8nFUBcLSRj4k6v6iLTkJMK2l1Es6eiqbVfYcm6H8dlGuzwL
	 LzR5ISuqBUyohN1g6dqZ36BCZdvFHGgEEjhl8lPc/5DeKerXE6BPNO7iJpA0mLeeAsD/M
	 /NXkroh/Zz35kLNzgC7E2rM8yjx9hHWd2DRQDjELwxddPh+EvZ93vDvtxmRq2FWXSDi8K
	 7d8ySE1xo7Cv8TvlMQlcKxvGRxwCbZBG8OpYOVrFsaM9sbBfnKzsPFjPOe53h7Ciecg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=i4xAGVtJ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 30E63606AB1D;
	Wed, 28 Oct 2026 19:07:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=i4xAGVtJ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 87FCE1F031E7;
	Wed, 28 Oct 2026 19:07:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793214476;
	bh=lNDjeBEB3aKIjYN0L6/KKHXqxa3XFvzlN+B7VhJvqGc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=i4xAGVtJRPb63KY6qGRmaOr+cjeCmDUsg2V+2LwDWwp5CTf7dKdOm3VBKOhRHR37I
	 lRDhX5pYnFTF9PDtZsgtG6SQ7OlLVnxNgTeyAA47yTHxZSFSXrOBKY+JC65iVmxhcL
	 AAS3TUvoL67DwGJHsJHHCEY4KMEi84rk8t69drp4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nutty Liu <nutty.liu@hotmail.com>,
	Troy Mitchell <troy.mitchell@linux.spacemit.com>,
	"Guo Ren (Alibaba DAMO Academy)" <guoren@kernel.org>,
	Fangyu Yu <fangyu.yu@linux.alibaba.com>,
	Anup Patel <anup@brainfault.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0855/1887] RISC-V: KVM: Write hgatp register with valid mode bits
Date: Wed, 28 Oct 2026 17:49:11 +0100
Message-ID: <20261028170518.881671688@linuxfoundation.org>
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

From: Fangyu Yu <fangyu.yu@linux.alibaba.com>

[ Upstream commit 2b351e3d04be9e1533f26c3464f1e44a5beace30 ]

According to the RISC-V Privileged Architecture Spec, when MODE=Bare
is selected,software must write zero to the remaining fields of hgatp.

We have detected the valid mode supported by the HW before, So using a
valid mode to detect how many vmid bits are supported.

Fixes: fd7bb4a251df ("RISC-V: KVM: Implement VMID allocator")
Reviewed-by: Nutty Liu <nutty.liu@hotmail.com>
Reviewed-by: Troy Mitchell <troy.mitchell@linux.spacemit.com>
Reviewed-by: Guo Ren (Alibaba DAMO Academy) <guoren@kernel.org>
Signed-off-by: Fangyu Yu <fangyu.yu@linux.alibaba.com>
Signed-off-by: Guo Ren (Alibaba DAMO Academy) <guoren@kernel.org>
Link: https://lore.kernel.org/r/20250821142542.2472079-2-guoren@kernel.org
Signed-off-by: Anup Patel <anup@brainfault.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/riscv/kvm/vmid.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/riscv/kvm/vmid.c b/arch/riscv/kvm/vmid.c
index 6cd93995fb65e..dc5d318fe91cd 100644
--- a/arch/riscv/kvm/vmid.c
+++ b/arch/riscv/kvm/vmid.c
@@ -26,7 +26,7 @@ void kvm_riscv_gstage_vmid_detect(void)
 
 	/* Figure-out number of VMID bits in HW */
 	old = csr_read(CSR_HGATP);
-	csr_write(CSR_HGATP, old | HGATP_VMID_MASK);
+	csr_write(CSR_HGATP, (kvm_riscv_gstage_mode() << HGATP_MODE_SHIFT) | HGATP_VMID_MASK);
 	vmid_bits = csr_read(CSR_HGATP);
 	vmid_bits = (vmid_bits & HGATP_VMID_MASK) >> HGATP_VMID_SHIFT;
 	vmid_bits = fls_long(vmid_bits);
-- 
2.53.0



