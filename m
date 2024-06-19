Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E63091487F1;
	Wed, 19 Jun 2024 12:58:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718801925; cv=none; b=fgjKbwZYeYtvtcF1N2XjEb68/0KQXuWLiz926tS8/hgqhffAIhTsqzn24cIA5gM++1pIdvAmuw/xVtZD+7haXn07Z1nnbdhvf4cCEAg/W0RRliuauUZMgW13+R016kGCgf4fxVLZ8HrNWAiXe/f85ym5FyZ9AdDmd8oeTnxenIE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718801925; c=relaxed/simple;
	bh=g8VqCFAhD8JsxAFG7ozCKOvByo5JLOyIJpRHiuhU6Yo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=n3Nb8s8q+3/xv+bZoD+YA+S/37X/ixTRHNzCkpAZpBBMUR6BuANK0eRlMluq7W01dUb7iB2uK4sNR9wRzpnxfZDtUHAunABcucw5lkavKCMMM6+TDH8+DqN47vggQjYTaMxsZOBg+WdXWKSmewqw/zw/KKDja+WxU8tYQ7BAAE0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MblyQXjH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MblyQXjH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6CE78C32786;
	Wed, 19 Jun 2024 12:58:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718801924;
	bh=g8VqCFAhD8JsxAFG7ozCKOvByo5JLOyIJpRHiuhU6Yo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MblyQXjH+Uiuf2h+4s0fmqqgxQH1+EKoKisZ/3v/oeuIkOFw69zKXFzqQiF7jLMKk
	 YljLv3LFnpnjdBOPeki2nqK9q0k6L6jzMHSCRIOo8a+G8Donf+JAoWFZ6SS4mcS6Ro
	 TbOWNv4unMYxtf5rkuzcafgni9onY3x0yTdgNRpg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Quan Zhou <zhouquan@iscas.ac.cn>,
	Andrew Jones <ajones@ventanamicro.com>,
	Anup Patel <anup@brainfault.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 015/267] RISC-V: KVM: Fix incorrect reg_subtype labels in kvm_riscv_vcpu_set_reg_isa_ext function
Date: Wed, 19 Jun 2024 14:52:46 +0200
Message-ID: <20240619125606.941412181@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240619125606.345939659@linuxfoundation.org>
References: <20240619125606.345939659@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index b7e0e03c69b1e..d520b25d85616 100644
--- a/arch/riscv/kvm/vcpu_onereg.c
+++ b/arch/riscv/kvm/vcpu_onereg.c
@@ -614,9 +614,9 @@ static int kvm_riscv_vcpu_set_reg_isa_ext(struct kvm_vcpu *vcpu,
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



