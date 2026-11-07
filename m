Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794063962;
	b=p56dIUx1Y4nXtozufBVInbsWks+PuQCngGA+K7w60K0BfZI+guDsxdvXwCZqFKnXCis0
	 RZNjSpb9HmolasKRPO+OwMO923tp//neohJRyhYxIkQP1ixc21uge5mkKPZKLk9IWNnke
	 HGgEsMXi6/F0AHlxHfUmCJ8gq9n7EzbJ2Md3nEN8QHjAN1FEqxut9sZ1t0dBH2E2Onqf9
	 yb5Ch4ilKrqhPO9X0rX2IgLmFvTYnN7jQGb5CI/jWYGn+TEdaHAmiGUXVW6yFueCaIOD1
	 KBDZ5ScXx931CD+G3ZxbR63kMr5CCp7kTiCNOVy5VVJwXjZYxFGMfXwtTqxIP7b8New==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794063962;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=My5c5r7T24JWgXmyzUEJuVs8UyVWNziP8pIMIzY/VmE=;
	b=Lxw6GwMY2uhed8Tt/XApaUM7xZ+gqJIUztM2B+A4PNuUj50XQT9VjiFm3xo5mkwmPwfz
	 qYn6bayZKF4qMh6JmW2WDVC30ECmcDicpYMWbE4RL/PBueO1e8a56i7vJaQXVlh0MD1NB
	 JeZ6Ty6cn/meEokWknKhmCxVC5At7zYwNgoNRahQzeL3R4Ko0W+l+ahIBOk7wyHYXcUSM
	 JQvQTJlFEgLaEK0z0FwufmFG1NeIhQw3v/EB3ny/2LBnYcRKUPrbGHv1B/jV3g8RQSdaf
	 tWnr8CyXAbZFkEVv8xOn2fuTM6WgtQr+h+JyukboamQSEjbIFEW4UoTzq/P/UUH8A1A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=sUSx77Xy;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 01D4C606EE97;
	Sat,  7 Nov 2026 15:06:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=sUSx77Xy
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 976411F008A6;
	Sat,  7 Nov 2026 15:06:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794063961;
	bh=My5c5r7T24JWgXmyzUEJuVs8UyVWNziP8pIMIzY/VmE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=sUSx77XyvqX9I2bZh/IHJ+qqJ5ESLiNlt2eUwgWoOTBZ+o2GisrEH9W2eS2x1FGuO
	 pDZ/uhLIwRVZnc65nIBjnLRhcqmJAuYPku+70pnFbij+zzJWC+e6ucQvkWWpoxiYPh
	 FCn3HM5m0ToYY5NxkYp82/VPe83TRkZB5n7QSfQo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Karl Mehltretter <kmehltretter@gmail.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0149/1257] lib/842: require a complete history block for repeat templates
Date: Sat,  7 Nov 2026 08:40:45 -0500
Message-ID: <20261107134943.429665869@linuxfoundation.org>
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

From: Karl Mehltretter <kmehltretter@gmail.com>

[ Upstream commit deb631649882bbf43f7c2fc79b5990139fd744ba ]

An 842 repeat template copies the preceding eight-byte output block. The
decoder rejects a repeat only when no output has been produced. A
short-data operation can produce between one and seven bytes before a
repeat.

Such a stream makes the repeat copy read before the start of the output
buffer. Depending on the surrounding mapping, this can fault or bring
preceding memory into the decompressed data.

This is also reachable through zram's compressed writeback path. With 842
selected, targeted corruption of the compressed data on its backing device
to a short-data-then-repeat stream made a KASAN kernel report a
vmalloc-out-of-bounds read when zram read the page back.

Require at least one complete output block before accepting a repeat.

Fixes: 2da572c959dd ("lib: add software 842 compression/decompression")
Cc: stable@vger.kernel.org
Assisted-by: LLM
Signed-off-by: Karl Mehltretter <kmehltretter@gmail.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 lib/842/842_decompress.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/lib/842/842_decompress.c b/lib/842/842_decompress.c
index 87d1e0f8a4926..45a9815abd637 100644
--- a/lib/842/842_decompress.c
+++ b/lib/842/842_decompress.c
@@ -309,7 +309,7 @@ int sw842_decompress(const u8 *in, unsigned int ilen,
 			if (ret)
 				return ret;
 
-			if (p.out == out) /* no previous bytes */
+			if (p.out - p.ostart < 8) /* no complete previous block */
 				return -EINVAL;
 
 			/* copy rep + 1 */
-- 
2.53.0



