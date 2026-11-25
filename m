Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795623247;
	b=4CCy9t1MVvHEAGl0YEGuMnkrKzoER00Rv5LtDtylpeusCsM0NqyXhbUAlBva/dn7SGdx
	 m+3sRBxpVDjBIO53XGpoauGp+mGAYJ0KITllaMS5G8ET3QHO5s2+AKo//JmWwCHl7nOAf
	 cQ5hpj8ue5p9DGGWYLMuBwHrInY8D4MlXdmSRXje9XCAtBFZpd5S78JbEGoqo6YL5IZ2X
	 jUcHzO7XLpZyZwbig3GbsyO3b/hKWj62G8i3t/f06G3EoI7LsEfCjiguve+GwBm2NQ10Q
	 7xNJaKY8hiL+pYMM/Qyl8NE34VDQNxxkttxm4SmlPz8h4b8sKxKZr7bRjaalqiVUlkQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795623247;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=LsJCKeTVgZT1gJBiOsbFFqOvG0WfXkfAC8HjI8XOM/I=;
	b=Lx7j8QW99/VSDdril6L1Wc9vEAsqLxOIRA8qAA+DOnc8qMJkwAiW/rC7GhBTsshgvVYl
	 wnlcvoKBGN6RqtRJu14+6jRXP/ur8czroxtCFc30MZx8i+f1jLpEj2qMo+JSFzeVOq4aN
	 z9XwL1WsoglBl/qajYCPqeq0ZmuKGyYMVZA0PfquGzs0kINV65WR9H3e/naj/lky8WfkC
	 11tCKgNMYLfzWuumLQrhcvYSlDPX8EHJkLoa6FfCSzKMe6FwR4VSn+7nGI+zFVTviKhS1
	 +e2Lw7Z/QTPLPd7RoV7kADvormqr3IyULeKq6dx8eN8WpPHNcypLd1kGh1SpF3F/IAQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=s8PqjAG3;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DFA7A606A321;
	Wed, 25 Nov 2026 16:14:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=s8PqjAG3
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 96DF11F000C6;
	Wed, 25 Nov 2026 16:14:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795623246;
	bh=LsJCKeTVgZT1gJBiOsbFFqOvG0WfXkfAC8HjI8XOM/I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=s8PqjAG3a1q6nSxXovdc1NYipVCRN3yxzY5azScmeBIRxeC1LBxLQFoa/inZ/vhLl
	 R0oImyIwaCukFfRlF+Oqjj7FTvNdCjNeAf4YrDGwtl8dR8eLPo6aVaUnpxOqbDLgSP
	 iJ14Ex1edmacAK1DfqWjs8V7MwDHu6lhL2df0qs4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bibo Mao <maobibo@loongson.cn>,
	Tao Cui <cuitao@kylinos.cn>,
	Huacai Chen <chenhuacai@loongson.cn>
Subject: [PATCH 6.18 798/990] LoongArch: KVM: Propagate real error code in kvm_pch_pic_create()
Date: Wed, 25 Nov 2026 15:36:05 +0100
Message-ID: <20261125143840.737308825@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143822.072087159@linuxfoundation.org>
References: <20261125143822.072087159@linuxfoundation.org>
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

From: Tao Cui <cuitao@kylinos.cn>

commit 20f3bf3d3dce16f43b82881293586ce7d73982b6 upstream.

The real error code of kvm_setup_default_irq_routing() is replaced by
kvm_pch_pic_create() with a fixed -ENOMEM. Return the actual error code,
as kvm_eiointc_create() already does; while the kvm_ipi_create() case is
fixed separately by "Return the actual error code in kvm_ipi_create()"
(Chaithanya Lagisetty).

Cc: stable@vger.kernel.org
Fixes: e785dfacf7e7 ("LoongArch: KVM: Add PCHPIC device support")
Reviewed-by: Bibo Mao <maobibo@loongson.cn>
Signed-off-by: Tao Cui <cuitao@kylinos.cn>
Signed-off-by: Huacai Chen <chenhuacai@loongson.cn>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/loongarch/kvm/intc/pch_pic.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/loongarch/kvm/intc/pch_pic.c
+++ b/arch/loongarch/kvm/intc/pch_pic.c
@@ -436,7 +436,7 @@ static int kvm_pch_pic_create(struct kvm
 
 	ret = kvm_setup_default_irq_routing(kvm);
 	if (ret)
-		return -ENOMEM;
+		return ret;
 
 	s = kzalloc(sizeof(struct loongarch_pch_pic), GFP_KERNEL);
 	if (!s)


