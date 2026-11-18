Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795052450;
	b=WK7rug4TJdWmK7ogXQxm7ulDkcja58rVg8lbqdsn90ylYEMfVAxvolyJQJ+n6PANOetY
	 yGhpBMj5vTzJnf5YMXHrkOFgJzsfeB0bG/1QvmLwjJ98ED2Rx0HpIcZnG/e70sKTyGcWZ
	 gPcGAbZ62hIiZ++CZFOTRymkEeaYnu2/FaCbF7YjOtlhmD5bHxrPKfmExTKdODxcIveh2
	 1800DG+/JTgVQ50PNNCzfZ8KngbJGNM8AkCk5Pz4yIppidlOheXmE62yU+xTl/GzbESTh
	 3kCwiMqqWzbyhK38jTFhP7xaSoq4cox1TnhJkDm2lFbtqUIHLwEHFbYEWiwsTigCGuw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795052450;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=A1Ffkk3hm1jac7GXSQlThmWuzzNRfMCyQzHvJpgZ/mw=;
	b=UtGq1yPhCbc04/WjKJZDfYGQbrCo0qYIJkRqN85dIFcd3pOEYAlNlrqdb37mUudvrBte
	 SNBbcTTR9zhMcyRsIBW5q7uiYtCoPgwy8vDCAhRJV4wbL50qFPiHbhsAq7P5n2Pw75s6T
	 aXXIfX5mD1iCh06t1VXpAB4UcJLvxNAD+zakE4juE/C1KqanWb/bP93jYgpaVJ9F8BYQL
	 MZNYrVO4gW0oDRf1n5lO+c4LuIx9Kcru7yX5x72nu55PI8asdrrRHtw5BgXizreYkubNA
	 mcq1nbhUEGP3qZClmB5nsvckiJPHAR7ZZjnUA3Lso2VxUEXPIFRllOFEorhxrrKhiFg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=xtcJSAaT;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1AF5D606A32A;
	Thu, 19 Nov 2026 01:40:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=xtcJSAaT
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6CE551F000C4;
	Thu, 19 Nov 2026 01:40:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795052450;
	bh=A1Ffkk3hm1jac7GXSQlThmWuzzNRfMCyQzHvJpgZ/mw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=xtcJSAaTVyhQfv5UgLA5XcAwymjTfYtGGin2qt98J5He0+UgRDY5NRXWL6ZEuNCBV
	 hQAzyNFvXxB1GenuL5oVjwLN51h7VKpvXy7pTvXyKLaFpW/3r5AaeI7pOhtoYAirF3
	 WkpjAWNIH5qSFEwmJ1Aa5h7/ie4je5L/pRH9vOEo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thorsten Blum <blum@kernel.org>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 0566/2214] hwrng: amd - report partial reads in non-blocking mode
Date: Wed, 18 Nov 2026 15:37:22 +0100
Message-ID: <20261118150033.620925073@linuxfoundation.org>
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
index 5229da114377a..ab45736ea617e 100644
--- a/drivers/char/hw_random/amd-rng.c
+++ b/drivers/char/hw_random/amd-rng.c
@@ -79,7 +79,7 @@ static int amd_rng_read(struct hwrng *rng, void *buf, size_t max, bool wait)
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



