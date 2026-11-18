Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795045091;
	b=4UHm2EkTWMCOsPGGGgHetD36uYVu+0Y/dCHKR4aAobDjSg3wicGt8i5YWxSrcUQd4iYe
	 Qy4+pPZkQCTo1Nz3V/8lHy6N1DHYWEVP/brtARgFeUepex0p3T0EOzoDrhanMbDk9YDdd
	 fb6ZQs0bOezz9HYOfpKVEiXpy7Q+y9J/umOjAjmUCzxKtukY6TZ1gh66oWUl/DKH7t2LE
	 39XnEINqIyiU9QABWE1zGXKVtMtGHxZAmAIhyKQySaKlSxwt8IliurYCsY0yUdkNgCwgS
	 TiqEMnEcPAKafbkDreCO/i1tQwBKKTkFoCjLlvmTdJ6MAcZzlW6aGYLdBaqL7wiUL+g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795045091;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=bkrU/bYlrdSy10FWyfkwXxPug0pFlBigBqKUffVNW98=;
	b=l4jPqG37tbXTyhueOsTalksBPxoxfXEYxUQo9RMy3+YX2/KB7PoUd2xaCcmn6oJTvbCh
	 B6cRyKFMqhk1vuhN5HkPmSgcpQlMjy0jPcboZB7gyzC8nSmcOPG96cBtjy0YKcDoXeGxi
	 hKak7itDTmzIIbCdkLEdddUJ0v3v2Q5cal5iaDOwmZVa0Xp/SYjctw4gdcARB6XNJ2Et/
	 QeSLNcdAodU1s6VL2ltbZH0vb/A7jGRPC2n+R6unS0ybhpdeayInk0Od2noyuaRB+Sq61
	 zTLK+mBZ4Bi+NGZSz0HEfI3mJ1TkUZpW+367+QaWcYWkC4ELoW2W/UhZlXevdx35DWw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=dW0oOqFd;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 46980606A325;
	Wed, 18 Nov 2026 23:38:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=dW0oOqFd
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9D7FB1F000C6;
	Wed, 18 Nov 2026 23:38:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795045091;
	bh=bkrU/bYlrdSy10FWyfkwXxPug0pFlBigBqKUffVNW98=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=dW0oOqFdsLHjwCLSi7vWitAVGCaxd6VUDi3tEjvXifBxFIPDnqbWcAEP6wB/mX24y
	 5eW0q0P/j+VaNv/LXi14vTVkfEm+3iyr3jsObxklsJ+WARrrMDICAus04+CVBk5vbA
	 ZsbM9tNSFs67tzG+WVEaF/q0vJZGf3faYO53ZKiE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Weili Qian <qianweili@huawei.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0801/2857] crypto: hisilicon/hpre - return -EOVERFLOW for small ECDH output buffer
Date: Wed, 18 Nov 2026 15:30:35 +0100
Message-ID: <20261118150230.415177136@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

From: Weili Qian <qianweili@huawei.com>

[ Upstream commit 232804a5ed70a8ace32c46d341d438aeba54bc67 ]

hpre_ecdh_msg_request_set() returns -EINVAL when the output buffer
is too small, after setting req->dst_len to the required size.
-EINVAL is misleading because the caller can retry with a larger
buffer. Return -EOVERFLOW as other kpp implementations do.

Fixes: 05e7b906aa7c ("crypto: hisilicon/hpre - add 'ECDH' algorithm")
Cc: stable@vger.kernel.org
Signed-off-by: Weili Qian <qianweili@huawei.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/crypto/hisilicon/hpre/hpre_crypto.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/crypto/hisilicon/hpre/hpre_crypto.c b/drivers/crypto/hisilicon/hpre/hpre_crypto.c
index 8169eda341c78..7aada55a9c6f6 100644
--- a/drivers/crypto/hisilicon/hpre/hpre_crypto.c
+++ b/drivers/crypto/hisilicon/hpre/hpre_crypto.c
@@ -1483,7 +1483,7 @@ static int hpre_ecdh_msg_request_set(struct hpre_ctx *ctx,
 
 	if (req->dst_len < ctx->key_sz << 1) {
 		req->dst_len = ctx->key_sz << 1;
-		return -EINVAL;
+		return -EOVERFLOW;
 	}
 
 	tmp = kpp_request_ctx(req);
-- 
2.53.0



