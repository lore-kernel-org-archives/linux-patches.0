Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8890914389C;
	Wed, 19 Jun 2024 13:11:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718802712; cv=none; b=H6pnQhCc5j+jEWO6sFU/ddSq4NYTU4iHScr7MMYjxkkai8f95cC/AX3lqT6UHKgEhaoEypkl5S2gWnXrQIG9wsVsuYIdbLNfomP9C0p/yFmU+cjucb1eW3OfSI5UG+cTmcBDDHPGX2pTMzB+UfahvjHdkiTh6cISVqHxgaXES4I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718802712; c=relaxed/simple;
	bh=Z8+8A14pDz5uoOOgAjWBJqne6BS1EK8EzQSXSTkWS0Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oo1vkNT8XUXz1yBCgSF64fyINte+kvnnUUsgGd8zcNBboAIC1/CHrlxigd40GcduYpBATfXJg4yFePKgTEbiTrFa4guM6fAC3COffAsmsC1cLPtt6SoHPjSku1Pb0m1vP1nUNvQM8YuNOQXw4h69eXwv9TN7mqbMq/FdXAs26As=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WxXBvn+y; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WxXBvn+y"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0E30CC2BBFC;
	Wed, 19 Jun 2024 13:11:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718802712;
	bh=Z8+8A14pDz5uoOOgAjWBJqne6BS1EK8EzQSXSTkWS0Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WxXBvn+ye93wtYzVuQbZdIbfOSce75SKT76OcPgDu+C5Z1WyPvZmIEtZoGjk67Oom
	 r5aekruzfXl2inHYRkbweGMZuNK3jCGiBBlSvyaTrvl/FGqc/brmTnBHlrhi5ca5TK
	 pAVXAD11O43nLAvw5AFP6fUY79R3z2uLUtmlfHBE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Quan Zhou <zhouquan@iscas.ac.cn>,
	Andrew Jones <ajones@ventanamicro.com>,
	Anup Patel <anup@brainfault.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.9 022/281] RISC-V: KVM: Fix incorrect reg_subtype labels in kvm_riscv_vcpu_set_reg_isa_ext function
Date: Wed, 19 Jun 2024 14:53:01 +0200
Message-ID: <20240619125610.701801915@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240619125609.836313103@linuxfoundation.org>
References: <20240619125609.836313103@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Quan Zhou <zhouquan@iscas.ac.cn>

[ Upstream commit c66f3b40b17d3dfc4b6abb5efde8e71c46971821 ]

In the function kvm_riscv_vcpu_set_reg_isa_ext, the original code
used incorrect reg_subtype labels KVM_REG_RISCV_SBI_MULTI_EN/DIS.
These have been corrected to KVM_REG_RISCV_ISA_MULTI_EN/DIS respectively.
Although they are numerically equivalent, the actual processing
will not result in errors, but it may lead to ambiguous code semantics.

Fixes: 613029442a4b ("RISC-V: KVM: Extend ONE_REG to enable/disable multiple ISA extensions")
Signed-off-by: Quan Zhou <zhouquan@iscas.ac.cn>
Reviewed-by: Andrew Jones <ajones@ventanamicro.com>
Link: https://lore.kernel.org/r/ff1c6771a67d660db94372ac9aaa40f51e5e0090.1716429371.git.zhouquan@iscas.ac.cn
Signed-off-by: Anup Patel <anup@brainfault.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/riscv/kvm/vcpu_onereg.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/riscv/kvm/vcpu_onereg.c b/arch/riscv/kvm/vcpu_onereg.c
index 994adc26db4b1..e5706f5f2c71a 100644
--- a/arch/riscv/kvm/vcpu_onereg.c
+++ b/arch/riscv/kvm/vcpu_onereg.c
@@ -718,9 +718,9 @@ static int kvm_riscv_vcpu_set_reg_isa_ext(struct kvm_vcpu *vcpu,
 	switch (reg_subtype) {
 	case KVM_REG_RISCV_ISA_SINGLE:
 		return riscv_vcpu_set_isa_ext_single(vcpu, reg_num, reg_val);
-	case KVM_REG_RISCV_SBI_MULTI_EN:
+	case KVM_REG_RISCV_ISA_MULTI_EN:
 		return riscv_vcpu_set_isa_ext_multi(vcpu, reg_num, reg_val, true);
-	case KVM_REG_RISCV_SBI_MULTI_DIS:
+	case KVM_REG_RISCV_ISA_MULTI_DIS:
 		return riscv_vcpu_set_isa_ext_multi(vcpu, reg_num, reg_val, false);
 	default:
 		return -ENOENT;
-- 
2.43.0



