Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795034275;
	b=IUFAU6GtUJATGomWvkHkMqRE+J2BEUD7KEJDqCCA3mAcm2Wr74E99ttZixnTfOAkrFXg
	 NoigSP4xAZDwueWDWNGZxeuTasycn7BKZNVkRNEYdewP1lxfG0G5FTCaAQefqrVU787JR
	 YzIqKoWHUAZ4cQm5aryajLfp/Xr7GUuIEIN4uDMXfeuFNAN96Ite+LL+hQpSavjpMyn9V
	 a2+/gxWxBi7zPzw3tRxuy1jb0Ck2M8rTtIABw4l5OngvQzQvhPX1LqsFqvrqUJnbl5Ody
	 npN9slhcP1RNObDlQE2oC8+J+HvklX1CPJOjeJK6VROhKgzJ946dVnWeekW/J1+jMGw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795034275;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=l5iugvRkGB/k+mTrO5Q/0QX/yteKhvPsHlbgQfuo/sA=;
	b=DBf+Tg2jkoPDAhepy04Xwg8x9pACf9yDRfkKxVvgvGjMFGSf595qUt5RtqJELxN7BUKg
	 Awh+o0jIlM1ZEmYLiKBcsgAEi317cCNMEThy9wtS5+nqJcumtY8XHLLnEF8WnO6pWQNec
	 iL+HGKMsX9IYB8qHKuq+NxE0eckATm8a1lS/oK0vQxmxTL+YWL2z8QcA/cu/XRZX3rmCD
	 x7NiJ5RLCIKh7L+DSOAsM6NF6KHLQFGw67AdFuAUbgNF2757pX0YIH/mXi8ZkMGirCIEl
	 CJYbLj6+uggbnEMtcYS4HZlDFg4Q5D2tzqnWKjjRleh1qw5coXBOYz1st7K2tREuWqg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=cE7PjTqI;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A2CCF606A330;
	Wed, 18 Nov 2026 20:37:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=cE7PjTqI
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 03F801F000C7;
	Wed, 18 Nov 2026 20:37:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795034275;
	bh=l5iugvRkGB/k+mTrO5Q/0QX/yteKhvPsHlbgQfuo/sA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=cE7PjTqIfgOp3bwst2xmMwc76nP+7i7qAJ/hrhMPMG2mBl+/yMNI2byGxqnSaCM2k
	 Z1wrilL2zcPmfv3oZk35BC+oE/WtpGv4F8iOK4V4L+IJH6CDzTrr1MaGZXVzUZ0Lty
	 S9uXZhV+SIhlIffiGEsBYDmmRj8VU7r4vmsNDehg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Randy Dunlap <rdunlap@infradead.org>,
	"Maciej W. Rozycki" <macro@orcam.me.uk>,
	Helge Deller <deller@gmx.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0312/3318] fbdev: maxine: fix 64-bit build error
Date: Wed, 18 Nov 2026 15:15:34 +0100
Message-ID: <20261118150325.165367917@linuxfoundation.org>
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

From: Randy Dunlap <rdunlap@infradead.org>

[ Upstream commit 3adec5c640dc09dca5605043e138412fd5a0629d ]

The KSEG1ADDR() macro is only defined for non-64BIT builds.
Use the CKSEG1ADDR() macro instead.

In file included from ../drivers/video/fbdev/maxinefb.c:34:
../drivers/video/fbdev/maxinefb.c: In function 'maxinefb_ims332_write_register':
../include/video/maxinefb.h:16:41: error: implicit declaration of function 'KSEG1ADDR'; did you mean 'CKSEG1ADDR'? [-Wimplicit-function-declaration]
   16 | #define MAXINEFB_IMS332_ADDRESS         KSEG1ADDR(0x1c140000)
../drivers/video/fbdev/maxinefb.c:66:49: note: in expansion of macro 'MAXINEFB_IMS332_ADDRESS'
   66 |         register unsigned char *regs = (char *) MAXINEFB_IMS332_ADDRESS;
../drivers/video/fbdev/maxinefb.c:66:40: warning: cast to pointer from integer of different size [-Wint-to-pointer-cast]
   66 |         register unsigned char *regs = (char *) MAXINEFB_IMS332_ADDRESS;

Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Acked-by: Maciej W. Rozycki <macro@orcam.me.uk>
Signed-off-by: Helge Deller <deller@gmx.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/video/maxinefb.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/include/video/maxinefb.h b/include/video/maxinefb.h
index 6aeb4acca2bdb..2b66b32f355cf 100644
--- a/include/video/maxinefb.h
+++ b/include/video/maxinefb.h
@@ -13,13 +13,13 @@
 /*
  * IMS332 video controller register base address
  */
-#define MAXINEFB_IMS332_ADDRESS		KSEG1ADDR(0x1c140000)
+#define MAXINEFB_IMS332_ADDRESS		CKSEG1ADDR(0x1c140000)
 
 /*
  * Begin of DECstation 5000/xx onboard framebuffer memory, default resolution
  * is 1024x768x8
  */
-#define DS5000_xx_ONBOARD_FBMEM_START	KSEG1ADDR(0x0a000000)
+#define DS5000_xx_ONBOARD_FBMEM_START	CKSEG1ADDR(0x0a000000)
 
 /*
  *      The IMS 332 video controller used in the DECstation 5000/xx series
-- 
2.53.0



