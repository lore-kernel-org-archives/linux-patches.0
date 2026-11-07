Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794062101;
	b=ibLiwOmJ8yZXe6bilbpU00FNi5e4y9HR1lWP9T6lwHnKN7JqFNf8eTJtH8eCH8kQzNCD
	 LKjTzvoa4XWisDLzJA+7O/YyHOPwMv9bMBuYB43uIJX4V4gNxL530cvAxvevU8SWPhen4
	 07rOdZpj3F8XkZSBJSe4hV80Xkwtz9DIFcJSFEeqM+2JvxJuYXQue6iUiCGTmtK7tXzAf
	 tY01BZSr+G5g1Nr1HwlaEX7Y7ieNxFH5FbXjFeYa637EyWJk6PCKCPm+wHnPVhCiVPNKX
	 G9ZkEGGbkWjIBcFV43s3kDaG42j8rmenUdnWe0W8nzdAAOIyk6LY3V4U12M2TjaFT4w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794062101;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Npn4R+yXtR5Sx9+n9zGDJ6MMydFLAlFccepS/326Yk0=;
	b=cl1eoPKeHsEvxnR/tu7VYSGRape8amI11umcWy7G7z1OJWnTjMEGEIoYeh3DtdXFE2dF
	 3x4mqMyMcf8amBEBN66eUHZR94IqrTVOZIRs7tcO4L/45NszbQCj0O/scrvSXG4CFcDlW
	 7STdFdY1DqXJlPPWEMNvTCKNUnx8lBpWMmdXgAPYE6Z0S0vk/0EhM2oVmPFNzbH2Famir
	 7H9TcxZeHyDv69Ii0hAS6VdxAFe2XOwEoHGIhXGiOs64czQiwlK5jGpGjPZSHbE6lA1oq
	 AldrtV4VKdOwn7zlXjdBCwaBIZPLgTnmZe/Om9lSqgku3boxtlvm7SbT3Y7MfbaissQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=PbMnyXeM;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 74DB460A262D;
	Sat,  7 Nov 2026 14:35:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=PbMnyXeM
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 172D41F008A2;
	Sat,  7 Nov 2026 14:35:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794062101;
	bh=Npn4R+yXtR5Sx9+n9zGDJ6MMydFLAlFccepS/326Yk0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=PbMnyXeMEAU+RNds/dQVD1gUcyUoZw/rKQ4V/OUzRHjeFVnW+hL+Eoq4EkK6QJg6E
	 Bg4S/sL3eyirsCZsb0n7Yozj6dmGCzCkqXezie3EGCNS15Q4zmy5ZBiJRD7Zj5W4YA
	 QG2Iwy9Ab0yTVGLRbXMWLxP3V6ACMEb8HNvVSZHI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Weili Qian <qianweili@huawei.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1036/1536] crypto: hisilicon/hpre - return -EOVERFLOW for small ECDH output buffer
Date: Sat,  7 Nov 2026 08:50:52 -0500
Message-ID: <20261107135026.772837317@linuxfoundation.org>
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
index f92d44d24cd4f..072f5ad6739f3 100644
--- a/drivers/crypto/hisilicon/hpre/hpre_crypto.c
+++ b/drivers/crypto/hisilicon/hpre/hpre_crypto.c
@@ -1509,7 +1509,7 @@ static int hpre_ecdh_msg_request_set(struct hpre_ctx *ctx,
 
 	if (req->dst_len < ctx->key_sz << 1) {
 		req->dst_len = ctx->key_sz << 1;
-		return -EINVAL;
+		return -EOVERFLOW;
 	}
 
 	tmp = kpp_request_ctx(req);
-- 
2.53.0



