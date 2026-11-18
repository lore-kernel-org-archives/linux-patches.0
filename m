Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795045269;
	b=A1lr4vkE3Ct9+WfX9rpaFhTtsXUSz1s+gARt6yZKYSTGNS9dysgZAntB5HZ75xcORtnP
	 Vtw0go+mfsrK4SEwRfkqDgRb/yIxZYEfqciosJcL7/mrU/TJEDdF1S0CIdE5HsM0zSnuU
	 YmVb1pLneZ1vK6O9ZU1wr/ivp3Da5CHpzoM3lGHfuNhFqRKjIBKWeORztH0bDw5OIR59k
	 mPuMzsArTzwSJDg3J2kv76kMAdiASbxhvN6mNUVbfMu14Jgo1oNOUsDBKonPQQyc8n3OY
	 tKpXKXKQ3Z9VeM/T6qWnIGVwQkkzD6lqYzPoLPVgEouEbOGnRgjZLr1RMNbTxiJHLhA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795045269;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=HcvHyZC03Ghl255fwKR47ltCbFdonmk/MH3a9uXHiZY=;
	b=zCcDHbk3PKw43b3+QW56mjlVaQEAyTl7+zdYyMacF/saXSJ7We8Is+gU/jnKVoZZNhLm
	 xeXMdpctMSckDOreeDtds+NvmdQVFC2HyVcvjJmJTiBAEq+mvorxqNAPx1265a2JAPqfn
	 0+p7IBVvPtDw0MankDWNoaVYkMYH7ikDsFZ/JTLl7bAXSAMziPOUhsLSt7Vayvz6A/DJf
	 xx7IXTdf8Z8Uh9goZeq0yta5jt1hSKHFEiKJerADcpxEJMwyuKGy6yPgWfyiXTACoPuLs
	 x/5AIph9/AN9OpL8LtL/ob2vuhrUb2tQx2LOrTO404LK3/MbWrf+yeO+wqQYiEX90dw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=z2VZULj0;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF88C606A32A;
	Wed, 18 Nov 2026 23:41:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=z2VZULj0
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 306971F000C4;
	Wed, 18 Nov 2026 23:41:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795045269;
	bh=HcvHyZC03Ghl255fwKR47ltCbFdonmk/MH3a9uXHiZY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=z2VZULj06uP3WP2AigTTUwcRlFbegsZFg8NPCOsEQlq9hOl5Y0x2NAQxwIlC0zf2G
	 Tar8SFAhMirZz9bxU+Z3roth/G4Ngp11p0+hwhKl2Kf1RMnzUOi+r62Ek10CIim4pr
	 8EbTEG2JfrHZijd5XCRWlwJG1zlaODhIe7yLfTng=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Aldo Ariel Panzardo <qwe.aldo@gmail.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0863/2857] crypto: nx - validate ignore before subtracting in decompress
Date: Wed, 18 Nov 2026 15:31:37 +0100
Message-ID: <20261118150232.637996605@linuxfoundation.org>
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



