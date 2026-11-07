Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794064350;
	b=qm3inihVQ73TOj7k4Q7ycKPC/dksQJiCrshx4RMrdoiNoIW/x/s1kNd00LVRTYcyq+Ge
	 seQPLTevBo4RCKm0+rcB+/fpz0YAZ89PQFcd3CCsAYTBcOnjb2qsvP+JV7HY2Q7FWs9SU
	 o/W2V2+p/E8vIWxdZgCuLQV1ICYXD94NqOG0CPRRzuLiJN6Cx9uw7qDZacrQ8808ZgtlS
	 gSrRA/OyIJBXES+0cIM/SQiwoIId0Y3Sm5u3fFzWwaelh7C/XOG/9bJzrTJLylxkNk9+Z
	 uiZ1h9aPHhOHOnFLo+IILAuiJU8Ol2iY0rotP9cHOc9yLFhKtSHoscZJT6bthCOaA/g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794064350;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=xo1UxfkYZMbBBCmNRSFRO0ce6Zshha/k4l/zrkTgy5g=;
	b=AU+q+yCMiDCFJyDFO9D60LdCIyxCGprz7d+/ehK6JHe7mER1LmIRZyYqExtog9weLo/r
	 ptGVwOcrFkLnUtVtMDDXIpBknXqoT+JqEADUPYPcD5D7VTqiHcYR2P6T8d9pypoA8GAuj
	 boGXl5XXkyBs8SDQKXrBGV1zC1bIL97DAaqDC+CINwvvZBFnrG6L1lOKCPR2TGx9lIMvs
	 q+Vu+tmH1oK9uPEQsKoP1V1boNWuHF69kqRX82jF8kVWm8Opj1PtjpHGlFX97CsjVqoJS
	 SYLrrzQXnCyXnsuTCKa/vYA29yzq9obnKv+mYSoG0lopt8P/er5oivP/7Y+iF0P52xw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=u5SYk6FV;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B0FF4606CE7F;
	Sat,  7 Nov 2026 15:12:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=u5SYk6FV
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5D9111F0089F;
	Sat,  7 Nov 2026 15:12:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794064349;
	bh=xo1UxfkYZMbBBCmNRSFRO0ce6Zshha/k4l/zrkTgy5g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=u5SYk6FV6Ern3Y+9BtRz6APxtZC7DYeFIA6Hx8is0LyvrIJrtiAEGDJb/rCNzcgKc
	 7K4WySMEf0oECH4bmyDkYjMZtV3vI+M6DcKivIBVIfEvPKkXf2gehN3QVNW5U5EdrL
	 mtC3kHodrPr7cVOE42COZtRRd4rCOhmlVywY+9Pw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Aldo Ariel Panzardo <qwe.aldo@gmail.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0434/1257] crypto: nx - validate ignore before subtracting in decompress
Date: Sat,  7 Nov 2026 08:45:30 -0500
Message-ID: <20261107134951.469053445@linuxfoundation.org>
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
index a61208cbcd279..b4404a1389621 100644
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



