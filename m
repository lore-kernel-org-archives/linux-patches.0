Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794064347;
	b=C4bVHCMmzdNwe2ONIe9aQWaIuRZa3aMHGqcahjNp3iEN/ReV4dm33dhor7kVnqKEjxrz
	 bPcXqr+nSd7wN7fMrWoDTYgrYUIMw2UBblQTpzqFvQGYnWjB3HgtGYw22tlbz6GDLpx03
	 45NyfES+jyUBp6gZBfLVtZi60cm9BVEPyLFFPJ9lFR0sayOH2zke5T3+raD+KWZ6S8RHb
	 xbmVckGNsDRqktQwyD3JQIL+FyeX50/JgTFFpnWFHcWwMRz4bLd6Hr5y9tdzxT3pGz2L2
	 b3LBxKtwt6w2+0NrWIpmxiT5FDd1KsjwQ8V9RgzQZmlMFItcIsNtfIJsqvZoDgru3Bw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794064347;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=2iY3Qu3z2bhTghopEOS7v3W3C8jgO2UjpWh4rv0rtao=;
	b=OVbbfyo6fruPTTVkz1ltr8tVm0s5kOi+I0ANgBQsiQdfuU4o50whJVjU42QCionyL8or
	 4QzDRATKexj+X5S5pBHYCaZuT6aZzi9UZvk7Kbh5sOgK1I+R1//7RxRTczlm8LLd93J3B
	 0jUCDEDIUHVDpZHU4rx9N/YoaDAIKZj16dlho/xwZt3utckl9vM3jUD5r5mSztTocDSCa
	 oXTIsx40pDgajsO9llWbC2ehOZg52eBS+cUi2eEO3EV/SFuLypRb+TxjEs5fEoIFYZdNk
	 YFqtU/lmF/IQW20QcwckmtmpvHNpRbzdsQSjc40nVuFdknqHJAFux6xjfakdBvppFLA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=TXa4ikSB;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 453E1606CE6E;
	Sat,  7 Nov 2026 15:12:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=TXa4ikSB
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E78361F008A1;
	Sat,  7 Nov 2026 15:12:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794064347;
	bh=2iY3Qu3z2bhTghopEOS7v3W3C8jgO2UjpWh4rv0rtao=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=TXa4ikSBG09mYzu+DNj5cDeMFuxWgPvGkOHfKWT50lCDHVc3iH+Ozp05JngLFq8Ja
	 ZyI2lvD2Hm7tQDMHGoykWgcXGdr2WuaIviKVujQR5+Rd6aqOZboqxeigjcd58RdTW8
	 8CEXpbA/ZycR9B9GNUgBdj3t/4TbT3IkDsbH7Kjw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thorsten Blum <blum@kernel.org>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0432/1257] hwrng: ba431 - fix reported byte count
Date: Sat,  7 Nov 2026 08:45:28 -0500
Message-ID: <20261107134951.416230532@linuxfoundation.org>
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
index b0a39032c6107..810c8cd5629a9 100644
--- a/drivers/char/hw_random/ba431-rng.c
+++ b/drivers/char/hw_random/ba431-rng.c
@@ -147,7 +147,7 @@ static int ba431_trng_read(struct hwrng *rng, void *buf, size_t max, bool wait)
 		}
 	}
 
-	n *= sizeof(data);
+	n *= sizeof(*data);
 	return (n || !wait) ? n : -EIO;
 }
 
-- 
2.53.0



