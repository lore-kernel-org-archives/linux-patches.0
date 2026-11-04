Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793831245;
	b=Ypj0wvvKmC0hJaRfujertAH4Nh/V9kiYbRiPphI+u3DgooRJHvVNRNHGYUCtQVJZAVHl
	 BVtUUMnwkqTxmz8p9h/TPLcwRcBOMtgW/9xJiWHX80EeROZcOwevKVu7jhGuRWYakf6p9
	 dcAHOtyNYcX+kxM0Ptp5QSS4tS5waE1lyGahiG6VW6PQwo6ke+I9CJDDAfZoDQrTZd2R8
	 VWpMRXjJ6DAESJarDzyle9fTZ4s2/5sMrs8v/VRkO3DgQ9kviXgR214A6e+DFmNO+L7hV
	 jJdh+8riiltsGOKAx83ctyxGRXr5uSbP0ivZnxU80I3Ofhax3SPFB2xOyvoZfYfHaig==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793831245;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=l9E4Pyo4x1sHsrm6TiK6AaPq+/aSuTwVqBNF5g4seTw=;
	b=J0snzZgdPVl7gfOPfXlORBfGhf/kN1J1E+4QSnrt/3ps7E2uHdyoqI0BsM/VzcKvP60i
	 5YLyxbNFeIToG73gm4nXeLWBUjo1NB12BxPnzaZjxgv95M9+wFWcZIb02G61Fy4Hb3NkM
	 Qh6Z1ybAB6s7c4k/oLgtuasmNBDrOGMsNEI1KwQklnieIwOEsbDOKmHnWPbNlEFJMYFbb
	 v3ClQoTZ7sl3kLTwKZlJwg6hqfWP2ptnMRSnNNpbfoHRWD7XK24voUZdXXHg0CcCs8dP0
	 MV8JSN+YbRENyGw4W9ceJ7LWQZKgUw4pbfAtv6wwip2PDTzqdkSQfdx7MufXN6b/wEA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=AnJL1YYs;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE36B606A33E;
	Wed,  4 Nov 2026 22:27:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=AnJL1YYs
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 659F61F000C1;
	Wed,  4 Nov 2026 22:27:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793831244;
	bh=l9E4Pyo4x1sHsrm6TiK6AaPq+/aSuTwVqBNF5g4seTw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=AnJL1YYsfohywI7hS+CGpQOOd6T4yPAxwV6vtKxRhaQQW7Gn7C/aUodSq0hxyHGZ8
	 dYOTf4VxyfgqsF6N8JXqznEZD1QVcqeJpl7+9vvJs6fCO0936c4Ze1OEEZNJbi3/YB
	 WJTHPGaPf08eCcpA6pIuKo7UxLOLBQU+o56BRkIc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bibo Mao <maobibo@loongson.cn>,
	Huacai Chen <chenhuacai@loongson.cn>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0550/1005] LoongArch: KVM: Deliver interrupt after IN_GUEST_MODE is set
Date: Wed,  4 Nov 2026 16:04:43 -0500
Message-ID: <20261104211059.299531355@linuxfoundation.org>
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

From: Bibo Mao <maobibo@loongson.cn>

[ Upstream commit 8c5cd2b9d6a724998c1ab9af06ac897b6152d568 ]

Interrupt delivery should be called after IN_GUEST_MODE is set. Other
threads may be posting interrupt however does not send IPI to the vCPU,
since the vCPU is not in IN_GUEST_MODE yet.

Here move function call with kvm_deliver_intr() after IN_GUEST_MODE is
set, and set mode with OUTSIDE_GUEST_MODE with atomic method.

Signed-off-by: Bibo Mao <maobibo@loongson.cn>
Signed-off-by: Huacai Chen <chenhuacai@loongson.cn>
Stable-dep-of: 32d05564a612 ("LoongArch: KVM: Set vcpu->cpu before IN_GUEST_MODE is set")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/loongarch/kvm/vcpu.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/loongarch/kvm/vcpu.c b/arch/loongarch/kvm/vcpu.c
index 760985b8bd728..ee969e3957009 100644
--- a/arch/loongarch/kvm/vcpu.c
+++ b/arch/loongarch/kvm/vcpu.c
@@ -281,10 +281,10 @@ static int kvm_pre_enter_guest(struct kvm_vcpu *vcpu)
 		 * check vmid before vcpu enter guest
 		 */
 		local_irq_disable();
-		kvm_deliver_intr(vcpu);
 		kvm_deliver_exception(vcpu);
 		/* Make sure the vcpu mode has been written */
 		smp_store_mb(vcpu->mode, IN_GUEST_MODE);
+		kvm_deliver_intr(vcpu);
 		kvm_check_vpid(vcpu);
 
 		/*
@@ -322,7 +322,7 @@ static int kvm_handle_exit(struct kvm_run *run, struct kvm_vcpu *vcpu)
 	u32 intr = estat & CSR_ESTAT_IS;
 	u32 ecode = (estat & CSR_ESTAT_EXC) >> CSR_ESTAT_EXC_SHIFT;
 
-	vcpu->mode = OUTSIDE_GUEST_MODE;
+	smp_store_mb(vcpu->mode, OUTSIDE_GUEST_MODE);
 
 	/* Set a default exit reason */
 	run->exit_reason = KVM_EXIT_UNKNOWN;
-- 
2.53.0



