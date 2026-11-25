Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795620013;
	b=z6RstgCSZUvSaJf1W7sf0jIngCywWo274wPvXJuBZtngY+O7IyV/JKXDBPF9P+UW7KEo
	 wj98h9qMNfAZN4A1aHAQqsSvltw31Xqz8PNXPrpknJdZnLWPRV+q43SNH0Qkgytjf8lbf
	 nS4M1TVNOZOiKfPQcmrzwkyjTuQz1VDLC+oRfgo4XPZDDwbQsmojJ7DZvzlwWNcTTY5jy
	 7VfmmE4MefGRCqtcRwFh7qKBYBNs2CZNwYsZWQYgQhR1YVmrj/3Y0iCofcglVW/JGMswH
	 e88YshLt63QS8iOCZkNGcACe2wKDB3hKMOGUVrIR15oshNl4M1vTjXRlddQw2HVjSGg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795620013;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=r+xk287JjGhrN6RHzK6Msa2C30y9Ovm27Sk6HEgvuGg=;
	b=CXM89m9SJI4h0g70Hzt78/ESkuxUJ1FmUA52grU84X335r040snSxFbU2rlbsvsP3mu4
	 9KDXliMQ7IezUwW8e3IyHJSUBjUZTvpjx7F4k0G7ON2VNwfbO767HVOM/kwA8PQUh9/mk
	 v22C8Kqb6Gan85hXXmpF5vNqU46t08Qmb5vW2cqfac+sdWADmbQP1ruU/FHVovGG6sRMB
	 jZkdIeQeZTE3SCv5otJmMW07g5egNzvjVaCGYXetzDtdnCQwHtpbTiyplaEfi688NVBBB
	 OzGpmun7sg36q3Eatq9yzI7cjbbrBVMwuBEL/m/xadZFfiLMZVghHIrHo2/K9qhPooQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=XjXC11Tu;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 18FDF606A323;
	Wed, 25 Nov 2026 15:20:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=XjXC11Tu
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6A94A1F000C4;
	Wed, 25 Nov 2026 15:20:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795620013;
	bh=r+xk287JjGhrN6RHzK6Msa2C30y9Ovm27Sk6HEgvuGg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=XjXC11Tucg57fdPP9OO0hbovoCVc/zRDLHhgZ74W0ZXY1KXTOFoauUT5eYUtgonqa
	 Tom4zgkLPFdAIEoSdHHhL/gPLALx6wmAPF0cF6WzO02ihpWgMvY4Lv4i6e4jeo3niL
	 uhQ8vQVVkG9agQMnNJ0TpN9hNRaeSxJXfn06Y8DU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bibo Mao <maobibo@loongson.cn>,
	Tao Cui <cuitao@kylinos.cn>,
	Huacai Chen <chenhuacai@loongson.cn>
Subject: [PATCH 7.3 0779/1005] LoongArch: KVM: Propagate real error code in kvm_pch_pic_create()
Date: Wed, 25 Nov 2026 15:35:17 +0100
Message-ID: <20261125143839.988277047@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143821.729802100@linuxfoundation.org>
References: <20261125143821.729802100@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

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
@@ -444,7 +444,7 @@ static int kvm_pch_pic_create(struct kvm
 
 	ret = kvm_setup_default_irq_routing(kvm);
 	if (ret)
-		return -ENOMEM;
+		return ret;
 
 	s = kzalloc_obj(struct loongarch_pch_pic);
 	if (!s)


