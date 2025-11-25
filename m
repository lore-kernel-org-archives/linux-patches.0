Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B6D0532BF5B;
	Tue, 25 Nov 2025 17:59:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764093570; cv=none; b=UUwxMCfA3h6oc+4qBTX2sRf9uOgPDlVWuQ8V5kWaswWbkiFADsQNkWLOK4tM5OxCBWzAwpiANGm7ohYDJBpyhAhmVrMNXAdFIdkXJKd8EM05IlUtLIGRd5ORUIbYKd6r9ouFrukb/4zqJLSvXS/iN62KnlF7bA/liBZB2M7mXUM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764093570; c=relaxed/simple;
	bh=h1qlIj8HN/bM1sBtCtKsuSxVMyqRjvY/Uk7aNakm8hM=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:To:Cc; b=Wmcv6vF0TUyMPch7Sw86u4Trok268qWmOv83lNNPiGkhuORhkTUe98bFv4rFcePxEUWQvi4nPyDQiyJP57EBRJ4qGUkx7ScMbIavmH8tygoghVMuAUMIsE0i/P9TZwZMYjlz8Ye3d/yXechx74BZxJX12nVY0dmghICxRRjn19c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=QKhhfPUt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="QKhhfPUt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5943FC4CEF1;
	Tue, 25 Nov 2025 17:59:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1764093570;
	bh=h1qlIj8HN/bM1sBtCtKsuSxVMyqRjvY/Uk7aNakm8hM=;
	h=From:Date:Subject:To:Cc:From;
	b=QKhhfPUtCMlfCcOICVoGwipUuNj2cmL2Y6m+rfxvgq59YzUjL89dgWluW2TkivAR2
	 D/cCdGiOsioLMK8SQICulxOuoLJemRvfIH5oPwciSZXgSj1MxSxckd9YpLzn9aSC8I
	 41Wruge3gwVkVcRkGRra1gg5o08KvassgXFMkgq7ORzsnpy0HlSW/5MqGUeHEiVLgA
	 stIGrXR4d08526DVfI2lwvJaDJwFiHnPIln+uc16H19VnUljsu5iBQ8etehMigwzi0
	 c2p3A/uGc/dPwMul9NhdN8Nq11jDDaxD8hLMhtTU/L44+UZwBqUPX92w43oJ2VqTCX
	 nUiO5ngFp+3zQ==
From: Nathan Chancellor <nathan@kernel.org>
Date: Tue, 25 Nov 2025 10:59:15 -0700
Subject: [PATCH] KVM: arm64: Add break to default case in
 kvm_pgtable_stage2_pte_prot()
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20251125-arm64-kvm-hyp-pgtable-fix-c23-ext-warn-v1-1-98b506ddefbf@kernel.org>
X-B4-Tracking: v=1; b=H4sIAHLuJWkC/yXNQQ7CIBCF4as0s3YSQUHjVUwXgNN21CIZsNY0v
 buoyy95+d8CmYQpw6lZQGjizI9YoTYNhMHFnpAv1aC32iilDToZ7R5v04jDO2Hqi/N3wo5nDHq
 HNBd8OYl4NMpbb+hgO4IaS0J18zs6t3/np79SKN86rOsHSVH8dooAAAA=
X-Change-ID: 20251125-arm64-kvm-hyp-pgtable-fix-c23-ext-warn-851b6b5e76fe
To: Marc Zyngier <maz@kernel.org>, Oliver Upton <oupton@kernel.org>, 
 Joey Gouly <joey.gouly@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
 Zenghui Yu <yuzenghui@huawei.com>
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
 llvm@lists.linux.dev, patches@lists.linux.dev, 
 Nathan Chancellor <nathan@kernel.org>
X-Mailer: b4 0.15-dev
X-Developer-Signature: v=1; a=openpgp-sha256; l=1562; i=nathan@kernel.org;
 h=from:subject:message-id; bh=h1qlIj8HN/bM1sBtCtKsuSxVMyqRjvY/Uk7aNakm8hM=;
 b=owGbwMvMwCUmm602sfCA1DTG02pJDJmq7+pLPp/MFlzXcIbv96LXBRKT7dmTlOaGZk/M1oyuO
 Gvr+vl3RykLgxgXg6yYIkv1Y9XjhoZzzjLeODUJZg4rE8gQBi5OAZjIxESG/4Wz/7ZMKWbImLRM
 verzz17TAN+Xs9pFZ0gXr7/+3X1DyF9GhpXl8v+1t4XcXyWf87h8s0GK1qNbpuWyRcflFpyN+pk
 sxQAA
X-Developer-Key: i=nathan@kernel.org; a=openpgp;
 fpr=2437CB76E544CB6AB3D9DFD399739260CB6CB716

Clang warns (or errors with CONFIG_WERROR=y / W=e):

  arch/arm64/kvm/hyp/pgtable.c:757:2: error: label at end of compound statement is a C23 extension [-Werror,-Wc23-extensions]
    757 |         }
        |         ^

With older versions of clang (15 and older) and GCC (at least the minimum
supported, 8.1), this is an unconditional hard error:

  arch/arm64/kvm/hyp/pgtable.c: In function 'kvm_pgtable_stage2_pte_prot':
  arch/arm64/kvm/hyp/pgtable.c:756:2: error: label at end of compound statement
    default:
    ^~~~~~~

  arch/arm64/kvm/hyp/pgtable.c:756:10: error: label at end of compound statement: expected statement
          default:
                  ^
                   ;

Add a break statement to this default case to clear up the error/warning.

Fixes: 2608563b466b ("KVM: arm64: Add support for FEAT_XNX stage-2 permissions")
Signed-off-by: Nathan Chancellor <nathan@kernel.org>
---
 arch/arm64/kvm/hyp/pgtable.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/arm64/kvm/hyp/pgtable.c b/arch/arm64/kvm/hyp/pgtable.c
index 57e13a5d0405..947ac1a951a5 100644
--- a/arch/arm64/kvm/hyp/pgtable.c
+++ b/arch/arm64/kvm/hyp/pgtable.c
@@ -754,6 +754,7 @@ enum kvm_pgtable_prot kvm_pgtable_stage2_pte_prot(kvm_pte_t pte)
 		prot |= KVM_PGTABLE_PROT_PX;
 		break;
 	default:
+		break;
 	}
 
 	return prot;

---
base-commit: b5e3afe91cfa420076851bbd833f11ecd3fab74d
change-id: 20251125-arm64-kvm-hyp-pgtable-fix-c23-ext-warn-851b6b5e76fe

Best regards,
--  
Nathan Chancellor <nathan@kernel.org>

