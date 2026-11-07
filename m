Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794063095;
	b=BXznWHGGfMikp1tSDAfdHnsk8SVMELK2zSQOhVdMqfV/rvJlVopC7m1MuyCE/EmrsEuo
	 0KZE6kZnNMXWVnsbG+4crps3ddaW/DRT9v8EWX/tCy90yjYeFn4xhsP1xTsAFpB9U6+/P
	 SD06OqfVuBL/G5XfKFc0HVrkeciUl39Ou9nT1D1xDQxbuo5d2VDtCohmD2HIz+ORRNViK
	 unjd0bG4DUwcWmJpL/v8Q9MIZS/FfHd1G9TcMa1PrzA9iGfMcq5xas0xxEd87GhzwNOy9
	 s2OviLhnRei8V/qnKOVQYL1a6QOf0FcvGAqOk92ZxvXlMFDKA7USGlzOTPsQaSOYm/g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794063095;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Rdt5F9wVmHWDKuCTwS/cKzmvDRXJ5tzYFvkvDpa/rlg=;
	b=H6WIiIF2Gv1+6j3eZ5O9qSeqrrrv3dssWzJlOSwjORP/GmlR4N/lCkjn94kLRdKpKdrG
	 QPhREXODcc+z9IijOsUL2IgMe38bOh2eq01Xa1e1zCQzAJ5YQcEJoN7BUpL9xCL04ncEP
	 LP24AKDf5hDXncwpaHu3//wTOvPVIqR8ErzC8gOP3TNHmEhilJ0XZkepcbgyRiw3v8SP8
	 ij3LfIqCcKQErtBbBA0S9x473vXPPRCeHNpYhLtwLo40zavtkSi0/iBmTMniwT5V0L7MP
	 yEK9aGoNSiPaFM5JlEqVPMHb7j8g+SCFFmEql0FupvyK9Tv0c6f44gNgexdR//ytCjA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=khVolFs6;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A059B606D804;
	Sat,  7 Nov 2026 14:51:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=khVolFs6
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4F61F1F0089F;
	Sat,  7 Nov 2026 14:51:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794063095;
	bh=Rdt5F9wVmHWDKuCTwS/cKzmvDRXJ5tzYFvkvDpa/rlg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=khVolFs6hiYqU93ae6d/nTh7rdEh9GO48Fa34AfYzKHF+sakGc7qTCPSJ4DPPugaS
	 rlJ+94M126zDhGZnLa9jFBChuHaqLxqcB+ucrDFPka7ynfsMb44RJEeCz17wdrDa/4
	 cN2kHf+ABs7lNe8nY4MbkxkYRXU6EMf1yxhBvTFw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Aldo Ariel Panzardo <qwe.aldo@gmail.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 331/869] crypto: nx - validate ignore before subtracting in decompress
Date: Sat,  7 Nov 2026 08:50:13 -0500
Message-ID: <20261107134903.651301899@linuxfoundation.org>
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
index 8b1dc05df8c8d..ade5361571f14 100644
--- a/drivers/crypto/nx/nx-842.c
+++ b/drivers/crypto/nx/nx-842.c
@@ -421,6 +421,8 @@ static int decompress(struct nx842_crypto_ctx *ctx,
 
 	slen -= spadding;
 
+	if (ignore > dlen)
+		return -EINVAL;
 	dlen -= ignore;
 	if (ignore)
 		pr_debug("ignoring last %x bytes\n", ignore);
-- 
2.53.0



