Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794062173;
	b=rWMZc8qB8oHlOe0H19zGknXH4i+browxPBU8HDn2ZTGunpDFl/xOrfTPwps2cqYf0H38
	 E2Nx/ldGYMaaEBGLNpigo+ZgFrH2JWtsQl1dRF0GrnVj60dxCjvjBUeGieCXK7O0j0LyM
	 AYDG+aFrxomPUZO2buXsbNnjT5fZ9o5Dv8gOXAHJ6W26N3zq6fWf92W+O8jnmPs7saVRI
	 VdJfCpk8lCY1QUHPQawuIlWSrAyNAWA9Qrvvac/lSSGz+jILTjNT0IZzjIT/CeMF303EN
	 aakcqdv1TwPlYP4sB3duJh9lhxq23PQBOK70zEqBhkOf2VGyN6nVfJsgj0vqYtb8s2g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794062173;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=6nTzJJsfZskaoxFYnfG2MRMouzAtJx7RBZ+kkPbZ/Lo=;
	b=cNP8bYC6iBy0MqI0roOZ0vFkmpoJS/Lu0YUV4/qVKSXQ/y0i2ovnFEwfAEzX5z8kffXe
	 Pg4QtnuDnPNeXYj1F1/XmbH9JJ67oMKdl3RjLxJjV8eFLrASjckZlyKF0ZB2HAfSeNjf7
	 uM7PXpUFx7Z9gNtAsSPAJaIOJl5ZD+Eq1q3/dhHs+IghpGBZptpAUEkG6K9BMUhT/InFX
	 kxmy8ZPalRx2sap6mRt9B4sl96b7LnVgu8pmdbcpmLZpFU2pDsZ7HuLFb9Pkmm0Vw/5MH
	 TlQorUABFBOi6Vfh8/YHVQQ6yXmr7F1Ya91SJMPKAYX3XqsFX1jx4h9kK1orJhsrqvw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=wawkXCkC;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B5E09606A326;
	Sat,  7 Nov 2026 14:36:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=wawkXCkC
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 648D61F0089F;
	Sat,  7 Nov 2026 14:36:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794062172;
	bh=6nTzJJsfZskaoxFYnfG2MRMouzAtJx7RBZ+kkPbZ/Lo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=wawkXCkCv/6DfYH02rPMqeQKwKP7PfesTdkgWVc6spD7FEpxPTSqjMKU2QYQ2vGkC
	 Y+YZS3GPeGPXauMbJWKvto9LpaLngjZV8XRiClwj7QpMoDiumfkrI4cd8yXg8attXV
	 Ffr6X0z7FwfAlIZLYvxPmdsj3cBXnqSjygGHCEJI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thorsten Blum <blum@kernel.org>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1133/1536] hwrng: ba431 - fix reported byte count
Date: Sat,  7 Nov 2026 08:52:29 -0500
Message-ID: <20261107135029.536191521@linuxfoundation.org>
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

From: Thorsten Blum <blum@kernel.org>

[ Upstream commit 7e638679883ceff5b6e7b6dcad09c21a105e941f ]

Use the size of the buffer element instead of the pointer size to report
the number of bytes read. Since data is a u32 pointer and sizeof(data)
is 8 bytes on 64-bit systems, using the pointer size reports twice the
number of bytes actually read.

Fixes: 0289e9be5dc2 ("hwrng: ba431 - add support for BA431 hwrng")
Cc: stable@vger.kernel.org
Signed-off-by: Thorsten Blum <blum@kernel.org>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/char/hw_random/ba431-rng.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/char/hw_random/ba431-rng.c b/drivers/char/hw_random/ba431-rng.c
index 9de7466e68962..c33fbc25b7cdf 100644
--- a/drivers/char/hw_random/ba431-rng.c
+++ b/drivers/char/hw_random/ba431-rng.c
@@ -148,7 +148,7 @@ static int ba431_trng_read(struct hwrng *rng, void *buf, size_t max, bool wait)
 		}
 	}
 
-	n *= sizeof(data);
+	n *= sizeof(*data);
 	return (n || !wait) ? n : -EIO;
 }
 
-- 
2.53.0



