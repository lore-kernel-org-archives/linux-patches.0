Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795040240;
	b=wa/vhnN62G3V8Dq7GEVpjWL+QUVwgaY6neULOA1aYuxG+ZNVTb6Mrb5Egq47C6C1o22c
	 N1Lh9XvIITB1PNx0UyPq69iwlmYzo1W/ZFcwmQwyhG1ZPRZg9yCirJW1cMyJjX0CPgHId
	 7tX6DeCOyMJhi1k6KgzJz9MP0cgnhH/ghUexsHtqYJiMMejNjXDwnsvLLichZysKKPQQI
	 +sQt1QNPYkxodkg2Xiig7s3J/d2aQwKTLN6PTjb/SAg+5XpAMlWpLlRouCoGunsLI00uN
	 jPHYNuJ+f4vCsOa7h5ZrwSCsazFZiC785WZ8ZUoh8euQj2JAibiGnPjvR3Cfd69oEjw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795040240;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=0zV8c087mKroEjA8XgBk/LiyUIDF4Pkxw3WZsMJRm+k=;
	b=c2DVAnMv6EGN+oTMhtiq4dYWm1t4aJtBqZ86fKLk74X3FJZ3L1dnYSIIZlQI8J2p1Q3v
	 Go0Nr5RUCOS7UcCRImGNcdFF+XbxZN8lQ0n4Uk29pqvUDCN5HXjd5V8xyuz+LK7Gl3OlF
	 0FdAzvBV9qdyJfKXYspVYKQUbMLr7G3hy0RlTiYnbPKn733Wp62kjAfKuh7YzgQY62TGE
	 G01hjwFseDLRZRcYNeZlnjO3SOkRPdomF5LqgO9yGeuoNRpDr5TwLgih4qjrU51sdPVAB
	 klW+ih3YHDHDCj3VSdGGex71Wsi+YwMJuokrFe92tgtvy6ExZRUICSbE4rqNGDwTYVA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=TeqX18dn;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB033606A32A;
	Wed, 18 Nov 2026 22:17:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=TeqX18dn
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2D0161F000C4;
	Wed, 18 Nov 2026 22:17:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795040240;
	bh=0zV8c087mKroEjA8XgBk/LiyUIDF4Pkxw3WZsMJRm+k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=TeqX18dnuLyk2mOdzCRPw6A9PJFtv+AIMCVWFjwLapnSSVdxUKTaRhsuoWn7Gbi22
	 HtvIJxgdmcXEsSAEpgVlRwFAtD+CXURcd+yKKyGTwjD+imrFfz6zoHrAEgz+RiRMx4
	 gyVKIpDWYTd1hIL3UinnjeXXPAudC+8TnXwRFQpA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Yury Norov <yury.norov@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 2387/3318] bitmap: Remove dead code, i.e. bitmap_copy_le()
Date: Wed, 18 Nov 2026 15:50:09 +0100
Message-ID: <20261118150433.136955236@linuxfoundation.org>
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

From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>

[ Upstream commit 7733aa893847f021c674d0d30b723d892109369d ]

Besides the fact it's not used anywhere it should be implemented
differently, i.e. via helpers from linux/byteorder/generic.h.
Yet the helpers themselves need to be introduced first.

Also note, the function lacks of the test cases, they must be provided.

Hence, drop the current dead code for good.

Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Signed-off-by: Yury Norov <yury.norov@gmail.com>
Stable-dep-of: 7cee2fb210a1 ("bitmap: bitmap_parse(): reject non-hex character before 8 digits")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/bitmap.h |  5 -----
 lib/bitmap.c           | 23 -----------------------
 2 files changed, 28 deletions(-)

diff --git a/include/linux/bitmap.h b/include/linux/bitmap.h
index 729ec2453149f..34ed9e67bb2cb 100644
--- a/include/linux/bitmap.h
+++ b/include/linux/bitmap.h
@@ -224,11 +224,6 @@ int bitmap_find_free_region(unsigned long *bitmap, unsigned int bits, int order)
 void bitmap_release_region(unsigned long *bitmap, unsigned int pos, int order);
 int bitmap_allocate_region(unsigned long *bitmap, unsigned int pos, int order);
 
-#ifdef __BIG_ENDIAN
-void bitmap_copy_le(unsigned long *dst, const unsigned long *src, unsigned int nbits);
-#else
-#define bitmap_copy_le bitmap_copy
-#endif
 int bitmap_print_to_pagebuf(bool list, char *buf,
 				   const unsigned long *maskp, int nmaskbits);
 
diff --git a/lib/bitmap.c b/lib/bitmap.c
index ddb31015e38ae..7fced1d92358a 100644
--- a/lib/bitmap.c
+++ b/lib/bitmap.c
@@ -1360,29 +1360,6 @@ int bitmap_allocate_region(unsigned long *bitmap, unsigned int pos, int order)
 }
 EXPORT_SYMBOL(bitmap_allocate_region);
 
-/**
- * bitmap_copy_le - copy a bitmap, putting the bits into little-endian order.
- * @dst:   destination buffer
- * @src:   bitmap to copy
- * @nbits: number of bits in the bitmap
- *
- * Require nbits % BITS_PER_LONG == 0.
- */
-#ifdef __BIG_ENDIAN
-void bitmap_copy_le(unsigned long *dst, const unsigned long *src, unsigned int nbits)
-{
-	unsigned int i;
-
-	for (i = 0; i < nbits/BITS_PER_LONG; i++) {
-		if (BITS_PER_LONG == 64)
-			dst[i] = cpu_to_le64(src[i]);
-		else
-			dst[i] = cpu_to_le32(src[i]);
-	}
-}
-EXPORT_SYMBOL(bitmap_copy_le);
-#endif
-
 unsigned long *bitmap_alloc(unsigned int nbits, gfp_t flags)
 {
 	return kmalloc_array(BITS_TO_LONGS(nbits), sizeof(unsigned long),
-- 
2.53.0



