Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794064145;
	b=zTvmZImO+65THur7SDlmDyqR8cHrCwV2d5NmxBBbuSFtrfyKNjKCot0KMpRHe7h8ipyW
	 6LiJgjjL8qjCSxnLlD8DvuSnY/KYDmZf7D9ccpLwF3lKPAlSvHGnI48UlQ7tKRZLh3TOt
	 +hYMhosYftkHNK4cIvKeBt0YIm/wZyKduRDqipSU+GbLn9FjASao87IOIbN/wZ4aK1HEG
	 F64YgkxCdils16M0bq2u5L1pl4on9SReBK6e3ZHhKuW1tE7zObgZ33LyJ9+m9A1grCx8N
	 jxpu6SsKvqGztoGgugBXcbNwIY/PaHB+dMFV8cBqw3/ArfgcOTLmmA7ESxu0qhBKO2w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794064145;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=tOA7MLsws3xi64yoGXJyT5EVFZdYQXT/2VxMX+iu34g=;
	b=5Vnin6vmrQo5CG6ThlCDrLjtEfg0MUsK6K4oFRX/no4I3SdagfpXEeQZihEVXgchmTlx
	 M7ZJ3ZpeprR6Xc/Jw70HJuKtzsFtnt1xace/8vSJboAy+FMKABN67EcBUPLSqk6wozTEr
	 ktTWlJB4LNUmCq41+h5HZeKLDONWlSmya4uZQETwAYWO3Ac3X6PNXeufa5x3BQSi4lhHJ
	 f1OHURbJgXd8xFMGSM0Gbn5kqxvzTAoj92N0JPoYEZqXTiAuAi85eg42eVMogOSFTIH8D
	 xs5gcWPlYTzKJormDbmTK8DpwkY1ybcvWfb/8/a6za8srzwQzvv8pR4XWrGjYKsSxVQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=SE3mZ6mj;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A68FA606A33F;
	Sat,  7 Nov 2026 15:09:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=SE3mZ6mj
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 537561F008A2;
	Sat,  7 Nov 2026 15:09:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794064145;
	bh=tOA7MLsws3xi64yoGXJyT5EVFZdYQXT/2VxMX+iu34g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=SE3mZ6mjiWqR6fXApAROiYQy97DtdH3rv/6cvMcRKLXwXwc4dSMXDBSsHyuW+Dzos
	 DfvY8xQ0VsIJv9EqKvarN/jcfh5cauvNWRcmaxWyHLbbq17K4LfUA34qhiO8dXkfOR
	 mMMxEDqwMln2sKrNzt0Z7vb/jQ5TX6z++2HDTo+g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Weili Qian <qianweili@huawei.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0254/1257] crypto: hisilicon/hpre - return -EOVERFLOW for small ECDH output buffer
Date: Sat,  7 Nov 2026 08:42:30 -0500
Message-ID: <20261107134946.520283775@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134939.434104957@linuxfoundation.org>
References: <20261107134939.434104957@linuxfoundation.org>
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
index 7894211b99727..bad9fe5d8c3c2 100644
--- a/drivers/crypto/hisilicon/hpre/hpre_crypto.c
+++ b/drivers/crypto/hisilicon/hpre/hpre_crypto.c
@@ -1452,7 +1452,7 @@ static int hpre_ecdh_msg_request_set(struct hpre_ctx *ctx,
 
 	if (req->dst_len < ctx->key_sz << 1) {
 		req->dst_len = ctx->key_sz << 1;
-		return -EINVAL;
+		return -EOVERFLOW;
 	}
 
 	tmp = kpp_request_ctx(req);
-- 
2.53.0



