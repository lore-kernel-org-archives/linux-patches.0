Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795058370;
	b=FhXeRp8ptwmU3BfzRtPaUPUUVxuVwPWw9cCN9G/DikOrlHkSM1mtD9KizsAzf2+5ZF+p
	 noV808hFaJlhKw/fskThIKg7DO72wQAZw7okApbWUgYeJSglaGC/XnTVBL1MO0jZ/nnNm
	 xp8ulXhbhFPYt6v5dHjr6E2+nEjfZEHIl0lCTrgLv0cDoEcOpEiMHwRjkYmx4ctD3Vwfu
	 DSCwmVRPMbo1URHUkAEuuv2Psa4kQjgKurWz2excLcJY9mhzVd9OAauOIFbQU704Xx7TK
	 j0J8kr8l4pDPLyODhtKoCfe2aRimgdjux6ZY7/UXfw+li1Hu9gQaSsVHlBZRFnjv62g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795058370;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=jZxTsUXJRrDQIfLqdo8ZwvqD2o7YcDTe3BP9v0mDWYM=;
	b=3MpDH1NWdOvW8YvbpbEVsUKBNOHEwkhYwuClhqiJv2xYyF2l5CUTiWwMP6h+E9gUp4HN
	 OvHYWn+n5+EUtHGIVq3IO2++0qKNrf3+EsizEumy4jXhAB/vdNQHtWb82LAnbfr2uVO4m
	 Vx0CP3tKOGTj7vA/5jXuNnaxa9BbRg4iB3OGi6EhOtLqJcP5YP/hjfm4FUPi6BhgfT5JE
	 trNLWz5Nrx2edt6oVly0k3j6SmdjobNMav9qs826ESwTR/e+psz4E7ymCoB0DhFPMWMT4
	 rfGYSajXkRpgJnvfcWdwuwdfDu9ArIbIvwx7iYcm3th8h1oIor+ira2tHbbJw0bFRNg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=1TUbY8Yx;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD904606A31C;
	Thu, 19 Nov 2026 03:19:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=1TUbY8Yx
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0F1341F000C5;
	Thu, 19 Nov 2026 03:19:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795058370;
	bh=jZxTsUXJRrDQIfLqdo8ZwvqD2o7YcDTe3BP9v0mDWYM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=1TUbY8YxHm/xEtVDe/M9Tsa2kOzSwf25NiknGL6/0/4GoA65dP4RjRu3gZ2UhSCWa
	 r//ZHmCPP6GXHsDM7sMP+zu/C0T9m3rxgYw8jGxRPvtKuogtIkQ+QNoFA2ZeqnAF2g
	 3GvXO9ygviE5pNUK/Bx4Zfkv9jzZ66zqWZGkyj2s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thorsten Blum <blum@kernel.org>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 0461/1848] hwrng: amd - report partial reads in non-blocking mode
Date: Wed, 18 Nov 2026 15:41:39 +0100
Message-ID: <20261118145933.721906771@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 3f3fdf6ee3d52..c12ec4654a1be 100644
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



