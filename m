Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795036235;
	b=wTRZvgIxIDSPhpNrNej4NVVN109FxLbrxsr/g8MfBnvoAwcLEqxlJLHxkCH+3sk6+El4
	 7HxsrNYV+HQeVWizodVHP7zVfx7dtEb+rVxqp2U9LBKI2STAhJZL8unwtjV5vZTvU5nez
	 ghEWZnCgmH29UQDz1jr3JsKQfbXO805FhwKJD7FN3UPRiS9lBXXQfQNM+GhuMadN1mC78
	 9Xc8NceIrLFyKwTLVlTTNqxL3wpZA69NgYKGUH219Ff1lqhPBJkC1M3FQRuvhC+zX4pK/
	 Wy96psQc6egLt20ThV2CcsGdt8b85RA2kWcQw5fMOlDPAdguz5sUm419ofy9yMVoU1w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795036235;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=rnylNf9l9NuSWNr3Xt8GxKeRU0G7hq3rjEc5YRKQ1Cc=;
	b=UsUsEfhTlaB46RvBPx9J/JqgeTpCktCmR44m6uJD9DRkm2A+SP1iAOHXrKoLEJEz8vr7
	 GDqvk2xnvp8fIr1I5MRMAT5Zjjb0tAG9XmIxWw4IIoExmXfwavQh5KaQAFGpq6zwBWvay
	 DnkroJ8ohUgFAv3/Kc8Ln0DpSwhqpF1kR4/TtfKJEAKoszZiz8gNd6hvMMXVmiNvYZTqB
	 +y55w2mrpKC7ylG532EnfKYdCqKanXS/zw+uuEIfhR/4eDqeR57gecBxjasdoqfmcMBOG
	 cU98pw1mQ4s2VIyM0dwAoFCgAMsqUTqBY6SrurfaAaKSwClc5ONk9L8y50SvyyVdsuA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=rgEFubwA;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3CB46606A320;
	Wed, 18 Nov 2026 21:10:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=rgEFubwA
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 93CA21F000C4;
	Wed, 18 Nov 2026 21:10:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795036235;
	bh=rnylNf9l9NuSWNr3Xt8GxKeRU0G7hq3rjEc5YRKQ1Cc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=rgEFubwAXMHvsKT8BBHE7y9cFLLfiGzOqrdLnYof/HFhaGE2TdQGig+RV/hWOWt9F
	 nOcheZB/ZKHKTQ/f/ltjSkTVNk3NarRe50t+I1X79wjAF/X1aOCjBl7pPAAlH5twT4
	 i7RxXKt1hBJCz0GKrSsE7+uvIs2Kkrv7RADkgkHg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thorsten Blum <blum@kernel.org>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0987/3318] hwrng: amd - report partial reads in non-blocking mode
Date: Wed, 18 Nov 2026 15:26:49 +0100
Message-ID: <20261118150349.395723514@linuxfoundation.org>
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

From: Thorsten Blum <blum@kernel.org>

[ Upstream commit e7f5ce911efb2017381f28bbedb6243a74a9c285 ]

amd_rng_read() returns 0 if no more data is available, even if some data
was already copied to the output buffer. Return the number of copied
bytes instead.

Fixes: 85962d2248fa ("hwrng: amd - Convert to new hwrng read() API")
Cc: stable@vger.kernel.org
Signed-off-by: Thorsten Blum <blum@kernel.org>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/char/hw_random/amd-rng.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/char/hw_random/amd-rng.c b/drivers/char/hw_random/amd-rng.c
index 9a24d19236dc7..cc65d40a55984 100644
--- a/drivers/char/hw_random/amd-rng.c
+++ b/drivers/char/hw_random/amd-rng.c
@@ -80,7 +80,7 @@ static int amd_rng_read(struct hwrng *rng, void *buf, size_t max, bool wait)
 				if (timeout-- == 0)
 					return read;
 			} else {
-				return 0;
+				return read;
 			}
 		} else {
 			*data = ioread32(priv->iobase + RNGDATA);
-- 
2.53.0



