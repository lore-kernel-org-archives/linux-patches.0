Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795042888;
	b=G+wh9nNRq+YzK/Yi7hqfkaA0zaUxmeDRvZNQ8VBGdromw+5lEdWzAe2259QHVtFnP7rE
	 HQTSwk565jolCqm7Pix6O0+NvTROw9jp2HORDVI+BzQ14dFWiviwK6s3GW9+cim8inw8Y
	 xG+wzywaNLv8eT5/s53marmB8VZrxNKG608paDMopZKifUAXYQcc8sAtHxATBNCM8fDSC
	 LzckCghjNRxcIcH+imw44XmocHGp7pHNYUjfkcGTkkcA6bLpV4wi2cpKogfCGsWj4wqcU
	 wjvO2nFkbll6KadShLQUGBVoF+7RPAEesycEiTizjXvOsWWj8BfuC5QNVpqP8aL0htA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795042888;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=K9TyreaW2VnjVD0C3/+GyeluSPnz6HvS+BveaM8DMe4=;
	b=S1+Yg1YrpPMsUS72zmwYEjkSbpL70MURJIvSdLSbWKlgPB2gJ03ypi3HUnPjNqGbUijJ
	 bqMpeWovr9lDan63qTfx4xtDid0FyIuha//Y40sYz2aR9kVY3oKL9QfzfZ904tzBmCwiC
	 dcx6zOQciiUccj1dBddPy9kGf/DcTxxdk75iLPVNdL1nRTipaU6vbxC/oIi9wl5zn8Ykf
	 oX9Z10ukKMQ+a2Q6kvkCDNUUeS6vpC3K8OeVt91lokg0Obs8j2njNzwDuobJ2MlDOr1Wz
	 7otmLKNa+N07EO6X6HBuuJea29K2ohpFv1Db0kTB/sGp3O6RLxTZhw94yvU5m83e48A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ilX90duN;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 91704606A320;
	Wed, 18 Nov 2026 23:01:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ilX90duN
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E3A911F000C4;
	Wed, 18 Nov 2026 23:01:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795042888;
	bh=K9TyreaW2VnjVD0C3/+GyeluSPnz6HvS+BveaM8DMe4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ilX90duNZgym7U8yCnrQHaznQgMyrGh4Q+nAzSZ1+qfRnDVBVdSQ0zKHMzEpMSVjh
	 EIkbUCRoeCgOUpN5sL+U4cb/N1rZxrLs5fwocXXAHOwzdN0IngMkSXILjt0iebjwPd
	 6TFrMfIX7S/+lGGCZ/K8ZVp71D997XgO34Bx2Llw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stephan Mueller <smueller@chronox.de>,
	Markus Theil <theil.markus@gmail.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0008/2857] crypto: jitter - fix intermediary handling
Date: Wed, 18 Nov 2026 15:17:22 +0100
Message-ID: <20261118150201.618244307@linuxfoundation.org>
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

From: Markus Theil <theil.markus@gmail.com>

[ Upstream commit 735b72568c73875269a6b73ab9543a70f6ac8a9f ]

The intermediary value was included in the wrong
hash state. While there, adapt to user-space by
setting the timestamp to 0 if stuck and inserting
the values nevertheless.

Acked-by: Stephan Mueller <smueller@chronox.de>
Signed-off-by: Markus Theil <theil.markus@gmail.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 crypto/jitterentropy-kcapi.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/crypto/jitterentropy-kcapi.c b/crypto/jitterentropy-kcapi.c
index 74d5c8da0e8ab..da298ad9b2731 100644
--- a/crypto/jitterentropy-kcapi.c
+++ b/crypto/jitterentropy-kcapi.c
@@ -134,7 +134,7 @@ int jent_hash_time(void *hash_state, __u64 time, u8 *addtl,
 	 * Inject the data from the previous loop into the pool. This data is
 	 * not considered to contain any entropy, but it stirs the pool a bit.
 	 */
-	ret = crypto_shash_update(desc, intermediary, sizeof(intermediary));
+	ret = crypto_shash_update(hash_state_desc, intermediary, sizeof(intermediary));
 	if (ret)
 		goto err;
 
@@ -147,11 +147,12 @@ int jent_hash_time(void *hash_state, __u64 time, u8 *addtl,
 	 * conditioning operation to have an identical amount of input data
 	 * according to section 3.1.5.
 	 */
-	if (!stuck) {
-		ret = crypto_shash_update(hash_state_desc, (u8 *)&time,
-					  sizeof(__u64));
+	if (stuck) {
+		time = 0;
 	}
 
+	ret = crypto_shash_update(hash_state_desc, (u8 *)&time, sizeof(__u64));
+
 err:
 	shash_desc_zero(desc);
 	memzero_explicit(intermediary, sizeof(intermediary));
-- 
2.53.0



