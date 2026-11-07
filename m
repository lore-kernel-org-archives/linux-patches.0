Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794061352;
	b=jp3Nsg4k0Fjtvjz01Bav2H2cAiuBu8ea3Ofw4nAcmpSzW4xYLxVXxSgOIJv2k15I1fba
	 2LerTc609/FuZZrDhK7SQMPTTvdfwgGnJXKDI+/RL5tqoZg+0F4cBpuuYb48p83LlkA+c
	 N/qWvi7dbNcn/m0O2ueuYi2aZ1yk2VocNPsl9nm4sUxmOqy0aHSIp2c+0r0GOJp3cTrVo
	 BnTW58uo/6q3XJX0UTlDMNI4xnxTJxCaW510BvDWRO6Gckw/6b7N0yMreFDI/XRCMm5SL
	 syGxPKEDQBTP2aFFlL4ULSsKaWAmokvg6MzZWJyQ/GvCQ4yHx9cSMML5piSfwNi+OgA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794061352;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=1lFV1/tmAXuxJdvTKNnkkGweQWUWpWF2CM2UeGeGHmo=;
	b=ohd118UAf/8+2eDCuG8IESV2rRXeJxruB8Gj91r/UNM/U8WVkvpnNgzifp3Y1HmGKl8x
	 cBIx4rGU4grpIDc7N+ZVHn0f5o1OihT/GIVyuV4YNom5OuAPSYpvcxcCPyaHNnw3mSrQB
	 WLs/F1rHX3hhWooCzY8P13YG4YtJegk2nAiaYExpRiX1h5oJUzb450jcSlQXsXGLM5qUc
	 AlKfUZmsN+OqHfnV4eOAWkBbakL5krI/bgwKkToAwK5zR/JUVE7zrpQ64gmJNNQFFg+N+
	 YQN4Q7h1G6lcCxavnLLZep5+Dit9Eee6hm7wCgNpZyo+nHK2LSgz7HrR2NKCiRla1LQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ACKXRR4R;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5EC8A606A326;
	Sat,  7 Nov 2026 14:22:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ACKXRR4R
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C4E651F008A2;
	Sat,  7 Nov 2026 14:22:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794061352;
	bh=1lFV1/tmAXuxJdvTKNnkkGweQWUWpWF2CM2UeGeGHmo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ACKXRR4RScDqKudVj4ag1BvZEcxM8Kme8gd/TIIwsQKOA3qrvjGCnLSPP/JTpZ7um
	 23DCDfL54lg9FWblIE+t97TWMHAFIuZIt/R+8Ovk+lBULq4qF3IYGH2GDdcgawGo76
	 CGxiFN68dUrnI5cdZHiXsp4qfx1PI+tUQLFuc/ZE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bibo Mao <maobibo@loongson.cn>,
	Huacai Chen <chenhuacai@loongson.cn>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0479/1536] LoongArch: KVM: Deliver interrupt after IN_GUEST_MODE is set
Date: Sat,  7 Nov 2026 08:41:35 -0500
Message-ID: <20261107135010.949414613@linuxfoundation.org>
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
index 92a1fff0829c3..4563bb47f804e 100644
--- a/arch/loongarch/kvm/vcpu.c
+++ b/arch/loongarch/kvm/vcpu.c
@@ -276,10 +276,10 @@ static int kvm_pre_enter_guest(struct kvm_vcpu *vcpu)
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
@@ -317,7 +317,7 @@ static int kvm_handle_exit(struct kvm_run *run, struct kvm_vcpu *vcpu)
 	u32 intr = estat & CSR_ESTAT_IS;
 	u32 ecode = (estat & CSR_ESTAT_EXC) >> CSR_ESTAT_EXC_SHIFT;
 
-	vcpu->mode = OUTSIDE_GUEST_MODE;
+	smp_store_mb(vcpu->mode, OUTSIDE_GUEST_MODE);
 
 	/* Set a default exit reason */
 	run->exit_reason = KVM_EXIT_UNKNOWN;
-- 
2.53.0



