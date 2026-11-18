Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795036243;
	b=RuLiPLc/kDb/37d9LSt0YDu4X3SB1wjn4RENegisq6Yidef3QD6SQQqRpe1VxkEmMm8p
	 D9o9e0wvEfnDS7XJzVfTsqN7z05YUy1jJ1dxfGZPimz3I5FGAv+OlJFFhzdkzByGclo8o
	 bEIIrxSHW34OTJyItY4LRYnfIRzFeQqPqqZjriSAiC0Qzn/3taqEbnLj0U5CFuGn1WJRf
	 2nk2kj7mi4LtCqRPpW3s69l48YwCp5GEywlELeBT8LiBLbbxyZEBWCXIpFXJe0UvMz8pt
	 DWivHorrltkGEo5YCiGyFYUA/Ri8CZqnRi87m14Y2N04BY7+hKtwkMq2JuKPjJzY95w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795036243;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=pw5EbDGbzxvPV7P+AomJYoylt6aJ5B2xGulUxAb5Hjc=;
	b=hGgemb/kAEX4nPtDjzsoIw4nqiiGHi5Wzbg2UhpoXFX/5JJymnfHmLVG3eF2/MTdCoMa
	 P1HXr4W9fZ706eAO1axTESze7FM9VPLOu2zcbjxZsnfWsEh9PqFUkn/PKLmMsjDkBObMd
	 uuOTzJIMTixkAo5OE40tu+HIJ806JHfH+R2n2ct9aw2ux5C57lM9k5nwP7b7Rn0tYGL8A
	 cQj7M0kOZjaPUDTQFfHhz0YVKdLfO8AEeHfLCwhUVt+3uRIZUkliOfh6jM3Aebekcjy14
	 CUrq8EBMdyqDzOEvgmhej+iwk8xWtGDcgW2XjlsT+/5DbSJioc8MFcBcy1pTP3L+Xcw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=URQ6DKTd;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 73081606A325;
	Wed, 18 Nov 2026 21:10:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=URQ6DKTd
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9A2B21F000C4;
	Wed, 18 Nov 2026 21:10:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795036243;
	bh=pw5EbDGbzxvPV7P+AomJYoylt6aJ5B2xGulUxAb5Hjc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=URQ6DKTdcCSr40WmMWe0v8+6UCOY4UNnM8PJ/DL3Y+uyr5nPO4zsOWNxOSsnpB/tF
	 V7ngmeVI/aL4TnJORZyskiwNqfKApgBUYsoa1N05MPCekbXb30zwjKcwQv2Cc0axiC
	 85n7jPAx3lvhDeTVhuUy0JRjTcLVniEdk5x9bZTo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Aldo Ariel Panzardo <qwe.aldo@gmail.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0990/3318] crypto: nx - validate ignore before subtracting in decompress
Date: Wed, 18 Nov 2026 15:26:52 +0100
Message-ID: <20261118150349.507768716@linuxfoundation.org>
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

From: Aldo Ariel Panzardo <qwe.aldo@gmail.com>

[ Upstream commit b5c2df42977390a71f1940def5be9bd5c69ac2e0 ]

The decompress() function subtracts the header-supplied `ignore` value
(a u16 from the compressed stream) from `dlen` (the number of bytes
produced by the decompressor) without checking that ignore <= dlen.

If a caller decompresses a crafted buffer where `hdr->ignore` exceeds
the actual decompressed length, the subtraction wraps around to a
near-UINT_MAX value.  The subsequent memcpy() then copies gigabytes of
data past the destination buffer, causing an out-of-bounds kernel write.

Add a bounds check before the subtraction and return -EINVAL if the
value is inconsistent.

Cc: stable@vger.kernel.org
Signed-off-by: Aldo Ariel Panzardo <qwe.aldo@gmail.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/crypto/nx/nx-842.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/crypto/nx/nx-842.c b/drivers/crypto/nx/nx-842.c
index 3b82b6f67f8c4..fb30bdb55c009 100644
--- a/drivers/crypto/nx/nx-842.c
+++ b/drivers/crypto/nx/nx-842.c
@@ -418,6 +418,8 @@ static int decompress(struct nx842_crypto_ctx *ctx,
 
 	slen -= spadding;
 
+	if (ignore > dlen)
+		return -EINVAL;
 	dlen -= ignore;
 	if (ignore)
 		pr_debug("ignoring last %x bytes\n", ignore);
-- 
2.53.0



