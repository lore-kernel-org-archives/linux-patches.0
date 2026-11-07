Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794062171;
	b=stfhltjA+XxGqFqSLW5wWyacn9ub2rcColIcIEbZ4Tm/FqSH3sjJsofsaW0Fs6tWqVsY
	 ipjmYhxtIA5KWR2pKJyImR25ZjVh+WtqKsomXbCeY6wF44TYVgZB/Dt+mxacwIRo9JQKz
	 DsAFaZyfYiGQd0YsDSmr15dIdv8CX4HlIB2w/0hN4F7QCtMfcJW7EQE8fef/I2EiqiB42
	 4onq3FYBjyHo7g/Nk8SiBzb+hA16NHDXNcXhuRtfG0vL+VSK2tqHxplaJCypv8TloQuBe
	 JaOWP9/XQyWll0wXconf47leTUVXYPUmMnnFPgVjiZtYY05D6tn4qjAeDyQl0FMmeDQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794062171;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Lj9Yp1tu87lgXVW2VPd58QlCC/xuKtoe2b0QLK35lxM=;
	b=fucaLiXVxaajDUJqAx2r0kNVOgAZqD8YiqsN8xCw3u+gzgd3fg2FwapbGJ68jGpgJoF5
	 J277z7UcintooOeG9m64nnmNuIcnutMVAEZSULxlmnqTLlXGl1WCiRtXua857Lkq94R5S
	 emVimHqx65hlpCbzDC1o9aetGQXY3SNTJLaLabqhl1VRxSl1hxoQOdWuIW6/NG13rvwM/
	 DAbGlGfzKWSB0/UkHpemzml68veIr6UEk6Fs7U8yRHLUFTeCVqSMgWyJ3hHVJ1cbNqUK+
	 5ohp9G+dUA+3jUWnsc/MiIN2JW8IHYlpkIzO73bUuNrMft5UXLIH+uDyslzjm/boX9g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=IjFB1qjz;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C2A2606A326;
	Sat,  7 Nov 2026 14:36:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=IjFB1qjz
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 27BE71F0089F;
	Sat,  7 Nov 2026 14:36:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794062171;
	bh=Lj9Yp1tu87lgXVW2VPd58QlCC/xuKtoe2b0QLK35lxM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=IjFB1qjz1m3IomwcCJPWE34SU3Ta8CKds+nSD/M0tEzLpYXFgNtb7etwYYZwc5OAX
	 bbGqaxMOre9/79dKhql5iwX8TKOeBUyvYt+V4BOkxBSD4KRgFzRFhn6KVuq4RF5IDS
	 K4H6xC0tYV+hisYbdOHiNCEmVyIV4Avq9bwFZ3K4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thorsten Blum <blum@kernel.org>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1132/1536] hwrng: amd - report partial reads in non-blocking mode
Date: Sat,  7 Nov 2026 08:52:28 -0500
Message-ID: <20261107135029.507357130@linuxfoundation.org>
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



