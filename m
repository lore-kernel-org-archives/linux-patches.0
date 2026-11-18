Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795052322;
	b=KO7OUmqw/yZSUveGBkUiTmIBkTxxe7IED4F18rjjmfGBtnfdulySMU6mdYMmtR6aAuxf
	 +npD8x+XDwl3LQqbraHS2dAbVXVJsscib6D3/3jqoPi8vrze9moGh0yU94pcjGbtQ0TVa
	 DbVMxtfQLTNJJNCHcilk/9Tdqhpd63N/RRkPOexpHNN1ZR8SfPMcH1RPT/zCMQct9fJdW
	 Z/dit4diRltp5TVjaYIre0bKUkyPZ9PKA9bIh1OmTp7xUla5EJ34+Bb8UPbaiS3EnKNmp
	 D9tTPWhqC+fSZZAAuWxEl+A45hGqU9q8vxasvfX1uWOfQRVd05f7Dy4226sjP9HsrJg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795052322;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=jm2cqdvHDkAw0S3rl2s1vNNm4y3BUeQdE1CkPNHIIUQ=;
	b=p1rOqjaDGN32TZs2HjZZsmYdYDxE0mo05O/VnhTmOAkz2pub2SLXwcD1uI55WM6lcrav
	 wZO4WrsShVFdNCDC9m4ZRQBv0pE9yIAQxDt9M/HdyngOpS2hw7pq5FWe3S7JSs5a4aoJv
	 Gp+xukvCqSSmL8bvJLp8oEj6gwEdwB+slHgXaoUjYo0aCwHUjJFK6cGmmOcepEokWc5ub
	 mcUhL6jq+QPIh5A3ELYPC83qMtnj41mIsQ3NBmWS2eppch8WaT8JEcqqzk90XFnSn7Wof
	 2MKgz3mUMfdGQIrPX48JIq+DIbZIfcZVqMYcxTQ5CFP8HqvBpZ91VM1I5dkx2R+KvsQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=k1zH5Gyi;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A68DA606A337;
	Thu, 19 Nov 2026 01:38:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=k1zH5Gyi
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DAEAA1F0092B;
	Thu, 19 Nov 2026 01:38:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795052322;
	bh=jm2cqdvHDkAw0S3rl2s1vNNm4y3BUeQdE1CkPNHIIUQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=k1zH5GyiEV4yVSWDxJu9RV9WcfMVAwMjWrYRhtJd8t0WfMNcaHhuKtQO9Il0pjkt/
	 r0OcYz8Cn5ieD21OJAwT1LyEsEk73UZTZ+ktYajJ/RmMTGztKLf2D36oEtpBKhybyg
	 eFoFd1ReSvPooCmh6MuPVo4IF2cHWxJeCajWy2fM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Weili Qian <qianweili@huawei.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 0519/2214] crypto: hisilicon/hpre - return -EOVERFLOW for small ECDH output buffer
Date: Wed, 18 Nov 2026 15:36:35 +0100
Message-ID: <20261118150031.851183097@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index d3a37aaacff8f..759929839c779 100644
--- a/drivers/crypto/hisilicon/hpre/hpre_crypto.c
+++ b/drivers/crypto/hisilicon/hpre/hpre_crypto.c
@@ -1480,7 +1480,7 @@ static int hpre_ecdh_msg_request_set(struct hpre_ctx *ctx,
 
 	if (req->dst_len < ctx->key_sz << 1) {
 		req->dst_len = ctx->key_sz << 1;
-		return -EINVAL;
+		return -EOVERFLOW;
 	}
 
 	tmp = kpp_request_ctx(req);
-- 
2.53.0



