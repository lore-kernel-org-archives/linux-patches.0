Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795036029;
	b=jNtSDPTgeIPihvVMQB928iDkSjZqFo8F8TrdDx8KPpUvRf0FoIywnMGu/uZ3JgGWE8A8
	 wcvETEjfTycd7rO6RAksyHQrVtqznzAssY92NDLLTBlLZg7vA3TeErnU1D0ZzO0UmGAzu
	 alIGZrXWHaj+0qLm/vDC+wLQoFaXXEZ2UQZ2cXteMH0rX5kKKTySHI1vOq1le9RQVcoWe
	 Rytwf3O6nYawWht5Sed2UjZIoO2OygkeJJVev+w/neWnnfnc8FZgEzKk8tM4T7USNH34A
	 F61bXGoKCA1Pad/jXrMhlKdFauKBbUNhihn/kERdzhfQfXjBwv72ithTGm7as5oIA9A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795036029;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=/CQ+pOV+FrIiBrSnxj5+SS07T8oIPu3tvXmbDGKG+0k=;
	b=FF5fjnYpTtVv+Un7HwIx9DaRGsYzE3TcKrd91jcuUpq8sOr78PwaHI8eyt1vz3ya6P7k
	 XYdzFmlVeCnbAkNAm+JqZKOxAJEkaDYpuSsLe918qzjr9wOK8e292fdEGDAoLnljsRHVS
	 t5Lyw5U18gRO1Z9v7Fi60e/aMpelu0SvErwwXurh146nNlhaUXaJ8eiz7zsNITV95FLwl
	 Ujh2AYEwwQhDegHlMPlvH/ydj9O62m5OZvNSrz9T+VwjpwuVCVwNj8etfgKYnbhPc4W79
	 ExDAm5Bro7erivVCRpZfnVS6RvJXrDImcKkg2JdrP4scHvQ7GA42QMzsXOb9LTrTFNw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="zlz/7Je1";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 05955606A31C;
	Wed, 18 Nov 2026 21:07:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=zlz/7Je1
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 160CB1F000C4;
	Wed, 18 Nov 2026 21:07:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795036028;
	bh=/CQ+pOV+FrIiBrSnxj5+SS07T8oIPu3tvXmbDGKG+0k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=zlz/7Je1aWS0xvsMu3ulfAVhv+x00IQwl5OVlAvgam7L7aJhSwL71a6Lszy4iFHg/
	 5tvKLo63C/S2MTa1MCKD/65fzQo9lp/9z9BcdrKr7BiYQmVcLZldFGfTcbEn5wiRee
	 MBW+v5T2mZqr1Q4bWijtfrY09LoZ0p+PBwfKmgiE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Weili Qian <qianweili@huawei.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0912/3318] crypto: hisilicon/hpre - fix pointer dereference before length check
Date: Wed, 18 Nov 2026 15:25:34 +0100
Message-ID: <20261118150346.873909178@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Weili Qian <qianweili@huawei.com>

[ Upstream commit 9770bb7d335f8f8db01e99168bbdd9ce2cb6238c ]

In hpre_rsa_drop_leading_zeros(), the loop condition dereferences *ptr
before checking *len, causing an out-of-bounds read when *len is zero.

Swap to while (*len && !**ptr) to test length first.

Fixes: c8b4b477079d ("crypto: hisilicon - add HiSilicon HPRE accelerator")
Cc: stable@vger.kernel.org
Signed-off-by: Weili Qian <qianweili@huawei.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/crypto/hisilicon/hpre/hpre_crypto.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/crypto/hisilicon/hpre/hpre_crypto.c b/drivers/crypto/hisilicon/hpre/hpre_crypto.c
index 059319f7a7160..e90807bc9d4ad 100644
--- a/drivers/crypto/hisilicon/hpre/hpre_crypto.c
+++ b/drivers/crypto/hisilicon/hpre/hpre_crypto.c
@@ -764,7 +764,7 @@ static void hpre_dh_exit_tfm(struct crypto_kpp *tfm)
 
 static void hpre_rsa_drop_leading_zeros(const char **ptr, size_t *len)
 {
-	while (!**ptr && *len) {
+	while (*len && !**ptr) {
 		(*ptr)++;
 		(*len)--;
 	}
-- 
2.53.0



