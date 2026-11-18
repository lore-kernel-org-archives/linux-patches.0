Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795045088;
	b=UKEsIv9spnLXPwc4rr8fPK7ae42mTN9Lfp74o8ipI7F2OAOzJ7avIoOFVKL+V+5Lz7DW
	 QR/g9OlRKbR2E5c+pLOTZbke51MW3hdnhZ0CIEblf3PasWJ0aoxG7oTsciTRX93Bh1EvE
	 THKQD5w2xy2MUWBRho0d3Als/6iVgrVms+BlAUXrOC1tcvXFaOlJYu3on9rq09mLp2QZw
	 rQBmlgj4ZnOZlJi1M0tzNGznlQRmWMNBWXViJrFbriypr9ggRzIpq6V4PE9VJkmLH4zY+
	 g82CFnQLEzFJq7G5p+ondxBjmIBoXbdcdDW3ZlaUf21qTWB+ozDGw1D+p8sybqJSGLg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795045088;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=/uSDr2hrb29Y0iwexfQBT/1YWMD6k4XGYsdQrAa2fus=;
	b=WFEfeIwXy1ebW/WGtZscIm+4lEyAynh7BSCe0K3DJPo0isX1tmN5pKw8Sdvi0NlOHENl
	 HSdl6iiLZDMr2VIXyvYVn09s5OvrGgmKQ1t2O2MzG4/GSltZXl6H9S+G/QmRZPErsUOzj
	 gYtOy/MS05aK7cKlYKPS6jh0yGSH6ijYO7721sF8u5HdRh7X9QIY0nTyvhtAL3yLnnyd2
	 s3Z+7IpL+qASYRJ2Wz0ftgcv7v6ZOLDWfIcwEyzPULI61LZNPHJN1evItKuZY0SMhTmx7
	 GHn22mi88mVJoNkGp7BJpfkOtG7J2B1co3KeLiQK1F/RoTAoRS9Mko12Vr1R3I4g8Mw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=1SfjoWat;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B7F82606A332;
	Wed, 18 Nov 2026 23:38:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=1SfjoWat
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D7B191F000CC;
	Wed, 18 Nov 2026 23:38:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795045088;
	bh=/uSDr2hrb29Y0iwexfQBT/1YWMD6k4XGYsdQrAa2fus=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=1SfjoWat2DCiCsWPrk1u4BND3qhuDJJvAycHwi1iZW6ZnwF5mqUxgzfVIybGzWFiX
	 NXLDM5Z0JCVySh4GPf6K5FB5XJjiA44h3GPwFejytrRfV6Q3dpvEXcBnRdEDbaP6S5
	 YqxSzXequgIk76Vw9omdoSC07NG/E8tAfGm+nH2o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Weili Qian <qianweili@huawei.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0800/2857] crypto: hisilicon/hpre - fix pointer dereference before length check
Date: Wed, 18 Nov 2026 15:30:34 +0100
Message-ID: <20261118150230.380272895@linuxfoundation.org>
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
index 541f5eb76b6e8..8169eda341c78 100644
--- a/drivers/crypto/hisilicon/hpre/hpre_crypto.c
+++ b/drivers/crypto/hisilicon/hpre/hpre_crypto.c
@@ -752,7 +752,7 @@ static void hpre_dh_exit_tfm(struct crypto_kpp *tfm)
 
 static void hpre_rsa_drop_leading_zeros(const char **ptr, size_t *len)
 {
-	while (!**ptr && *len) {
+	while (*len && !**ptr) {
 		(*ptr)++;
 		(*len)--;
 	}
-- 
2.53.0



