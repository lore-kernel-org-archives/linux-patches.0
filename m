Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795052458;
	b=oCI+NuQfXvgIZu379oGOp9iKpD3b1EySlMDE7Y3ca9DFaF/SUksPsKH2i5iWz29Iab7P
	 /fGEiad6lCYZctPxU5Tf7zkHuoVo0HQ6DHGEgEhePmGpFWew8YFgHEvAUENGO3TzVuWeB
	 pJt+WXCJh4Qm+Y9t29QHlaunlGH8lIAB5IWKEDgSCERII+/VJ4r9Jmw0fYQKJefaru7Jy
	 EyTGaFIZ41wX8N+Nb8oER6vUid0HY9s95dFwlGImXuyxsSoh/E/3coZROceRYLRXmEoye
	 2kZde4tim/3DzxQoelqJxfjDKOShHdka5MuT2Jz4fVmh9HrEWGdV5cqu/SK0/YRUo6A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795052458;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=6B2uJzNXByTsQREba8FRiFgFoNrGmrOx/SMH6Gu7sG8=;
	b=lxkGA27eAy5IVU5ttuxX4mcAmEQGKLIQfwIoJvfu9/60zE3RDKr+139hvgbfiiWdme45
	 4Y7And7cr/95nXJsiUNeuOo0H70viufMkcJMaAwUG1JwX1f1ylhjAos0aJ2y/fHcY2BeB
	 VlFVzGwuwnVmCLiKnEHFRKSpVg7Ty/XSzJCk4yZNZyNVe0Jq03lKD4702zEYgYy95fq62
	 +KMrH+hB5zjli/CZ9X7cdSP0DCCA3K5PpLCOoFIr4PegJOxVZ4Y34DkpN0UQmIm9WF9qy
	 B9wygVZj54mQ/aJSIEumlJQLSuLApNMzd4evxQo6SGQlkIHrYW1nHHwV6v4ZekKdEhA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=BWt9SjZC;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A86E606A320;
	Thu, 19 Nov 2026 01:40:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=BWt9SjZC
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BA5561F000C4;
	Thu, 19 Nov 2026 01:40:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795052458;
	bh=6B2uJzNXByTsQREba8FRiFgFoNrGmrOx/SMH6Gu7sG8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=BWt9SjZCjh8RvD+Mryt92u6IIYbgLpEFIl/5Hwd20g2JQKo6psE2XTdYsqCUtbP9r
	 +T2Ebfgq+FGocfozAFLZwKwcHVd+3X6bljCDzarrjXBdJ9iECr2wfIJpXSLrSI9RTW
	 7rj8WqV+sgcTRyHWQdO8+RGuFxMF6SRVuMdo/BsU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Aldo Ariel Panzardo <qwe.aldo@gmail.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 0569/2214] crypto: nx - validate ignore before subtracting in decompress
Date: Wed, 18 Nov 2026 15:37:25 +0100
Message-ID: <20261118150033.730059468@linuxfoundation.org>
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
index 2ab90ec10e61e..62ee11c8fe184 100644
--- a/drivers/crypto/nx/nx-842.c
+++ b/drivers/crypto/nx/nx-842.c
@@ -416,6 +416,8 @@ static int decompress(struct nx842_crypto_ctx *ctx,
 
 	slen -= spadding;
 
+	if (ignore > dlen)
+		return -EINVAL;
 	dlen -= ignore;
 	if (ignore)
 		pr_debug("ignoring last %x bytes\n", ignore);
-- 
2.53.0



