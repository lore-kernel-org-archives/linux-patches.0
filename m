Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794063091;
	b=3EUPizXnO59//zIMNuWTAZc2rEGO+roh9FhF3PuTGbNJ9DEdtrpGizYJeQt9GipD0xL7
	 yI/4mZp/IGRwXmnANr00qZ5j0weHqKBeH05kIMn6Y5ra8lYmA3fsr+aZOZb9dyShY8gGa
	 4PjqQdW5N45TYBiuC+zrijpfkDFYQWqu6SiC4gyKf8l0DB5SXJoqY+Yw1YVLdcDMLCEdO
	 EeHOUnxFe5yF3FOnUExInQdQGJt438DfgKB52IkStnMsYG52BBJ8SogSfxoDJgkw3/5KQ
	 J6eI+Oq9EMw+hg670mNJGpeRJ7Jfu3uuf/ZkXNMAInc12iYiLeTudIVI8ulLHmHiNHQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794063091;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=l+iNuU74E8/RA6zpqthrdm4FKbNCNUAjDYpp6zJVSWA=;
	b=x9JRdhU5boY02AuzMfEACvzPQmpfEodVg9huXv9vtjfaFIEV0mEKFzZVPUm5RnOwQQ/U
	 z5mtZrjdoC5uyrPTQ/xP2ckYiVbc6Erq9wQam8Z/HJbbAyja5Tw9MXQr3Q4sr9RiAsJTp
	 mEWDpHx+FAMopj++KyXFRLukmXYSwsIv/+BF34M306jknAiMd1Vor6ntawRdQ2DRlYqbv
	 WpQrdQKLcCl91iepQ5me1AXlmYnySF5YYJFfala6gjla2mcjRgXpDEmvSGLJ0MlW1vuyE
	 oULoJCM1HGk+T0YPLDl8Tm7qyTcC2dWMv87ZZW+qov5jBOn4KqWrk/HRxUnq0QfIwNw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=hZ4ossqZ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D666A606D804;
	Sat,  7 Nov 2026 14:51:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=hZ4ossqZ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7F1611F0089F;
	Sat,  7 Nov 2026 14:51:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794063090;
	bh=l+iNuU74E8/RA6zpqthrdm4FKbNCNUAjDYpp6zJVSWA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hZ4ossqZgJmDVzeU4cMm+WGbpJ/+1ev7QjKc0ywiRSjXja1LpI6i+ZaDBr9e5003G
	 TgImsGlFlfnaWltw/pjm6DhSE2fUX8vCMrI5xdGAgupwE3AHacUSdLpFZkkYhbwq50
	 SNQ7poC99AqzTrowW9HAKFEuTvO4OrrXLGoCahzc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thorsten Blum <blum@kernel.org>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 328/869] hwrng: amd - report partial reads in non-blocking mode
Date: Sat,  7 Nov 2026 08:50:10 -0500
Message-ID: <20261107134903.564821703@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134852.069646174@linuxfoundation.org>
References: <20261107134852.069646174@linuxfoundation.org>
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



