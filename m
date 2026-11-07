Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794061353;
	b=y9dGj3qvt2IRv5+rBwr+Q8QdF99nULaUdJDFV2ZBwg4baS4eg3k4g+13YM9E29Lod7lN
	 wInWxQ9d5SH/MIDOferlsgl47CXSmCUC3wHpeo3Vdpmy1wp451ssrcAjsoJJVgo+dz2+Q
	 Q6NvTdO1I3ElfRg/VGGsJ0usAod8zvb/KP7ndGyHNeJQjyM39w2+IfNEdJkpKvv5hf8rW
	 nLrulTvUOGHryHa1iu+OHGZDzuq2x93Kn1fSP9VJq5m7MHHAP30/bDBDm4FpisAgOq3fr
	 UkC3Da5ysXqf4D/6IHzaFrGW/UghgrFjxYjoWfjtd5FSTMYYqR+BDnj79dZRFH1T6Qg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794061353;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=k4PpNCx8VM/S29bNIaAosBN6FTF436rPpoW+pa9DMT8=;
	b=DBjcmnmI420308BKTpewo6pEWvdzj4svpkJSCzoEcBi8KIKG96YNuufdS8KedWRuwfQ/
	 Orzvwbj7nEudzpwfxLD7ZM/UxW9iPqNyq9gCTnIZg4DXfn8Bayq1EMDUn888PfcilHzjl
	 WSBkzNK1oP/krH56z/odCMa4suzrbagg/kGQlhhX9F7BG8U9bzT4w9cU5z8sdijMC5aBc
	 cyBTfPEm4hSqCCnUZD5S9m5QT9yNKLOwYDxtIsDD5nr9JpqOv0Bczppa6hTJUfwuDMBMr
	 wuY6s2PJU/mq4h6zKgDPiXOT60wo8Y+tRPBMfpb/Tf5l4VtBO0a8SgsK4M+DlQVzw/g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=L05cQevd;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D7F5606A326;
	Sat,  7 Nov 2026 14:22:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=L05cQevd
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 060801F008A1;
	Sat,  7 Nov 2026 14:22:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794061353;
	bh=k4PpNCx8VM/S29bNIaAosBN6FTF436rPpoW+pa9DMT8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=L05cQevdKlyl2ppCAGAWqPKyeLJWND9bWwJdOLORkUgSXv6gQCLBtjqleLE+wf6Gj
	 syFo/ZQ6Yui2q8+m6aRsRlvhXWyw8Rj8UBDwTtHytWimI54xnlNdnUJFg4RLCpU1Pc
	 hL325YNDqSapFcgadSsqOi5I6rrwMRv4zTmP/f80=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bibo Mao <maobibo@loongson.cn>,
	Huacai Chen <chenhuacai@loongson.cn>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0480/1536] LoongArch: KVM: Set vcpu->cpu before IN_GUEST_MODE is set
Date: Sat,  7 Nov 2026 08:41:36 -0500
Message-ID: <20261107135010.974662207@linuxfoundation.org>
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

[ Upstream commit 32d05564a6128d59ea876cf9078fe6866a809e14 ]

In function kvm_make_vcpu_request(), it will send IPI to physical CPU
when vCPU is in IN_GUEST_MODE mode. And physical CPU is set in function
kvm_check_vpid(), thus it should be called before IN_GUEST_MODE is set.
Otherwise IPI will send to wrong old physical CPU where vCPU is running.

Cc: stable@vger.kernel.org
Fixes: 2fc3bd86db4b ("LoongArch: KVM: Implement basic vcpu interfaces")
Signed-off-by: Bibo Mao <maobibo@loongson.cn>
Signed-off-by: Huacai Chen <chenhuacai@loongson.cn>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/loongarch/kvm/vcpu.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/loongarch/kvm/vcpu.c b/arch/loongarch/kvm/vcpu.c
index 4563bb47f804e..f94013d23919a 100644
--- a/arch/loongarch/kvm/vcpu.c
+++ b/arch/loongarch/kvm/vcpu.c
@@ -277,10 +277,10 @@ static int kvm_pre_enter_guest(struct kvm_vcpu *vcpu)
 		 */
 		local_irq_disable();
 		kvm_deliver_exception(vcpu);
+		kvm_check_vpid(vcpu);
 		/* Make sure the vcpu mode has been written */
 		smp_store_mb(vcpu->mode, IN_GUEST_MODE);
 		kvm_deliver_intr(vcpu);
-		kvm_check_vpid(vcpu);
 
 		/*
 		 * Called after function kvm_check_vpid()
-- 
2.53.0



