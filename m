Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794061092;
	b=4pLnOpfAQGFiGfmqpG3/V+dSnCR0eUouTjgS1SG0ojFn40ijE0AuXMX8E391vYMDSXkS
	 366dXuGg0sIGIYdyMOH+e3DAruylj7pMoPxg+41vNC9Hi8wcHr6njz9Omg6jeahPGpm+i
	 NyNpWQReSgckPov/I1VtSr6SoROGAwwOmaHLaDu0E5/zc1Ydn1q2zZSg6/pi1CF4TVJui
	 SNF8XYQi1ViX0BAOb+kQNH9laLn/fXNkXcxXW8arvnuwpeEWSgmbhZrhHrIa7lY4we3d6
	 SZX+21sExSj8I7NnJvoPtLc7h1Y2lG48CfKThHP6Ch3l8tcmSncp3ghyD9sYV+BAU6Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794061092;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=7/tW0Qio/UJj9TL3dpV4C7x8Woh9Jch/i+I+UdsyX/E=;
	b=RmjagPMdmITAEDgi1EniJ7LpjFLm+DDA9i8koCCvG88xQJlG8/dpOFQzCIk7U6X+eGm6
	 YCM1nErCIU0yzUimh0a8ty9TUiquVe9FZGiyL3kPtO3xJ+7VhRfHCUM/OA8kOHSXBNmAU
	 nyXAA93onSxovgRdy91/E9pDA40XcMzbfmP1BE7TtxizFSulGCZyVPYW2uxsR6duWzh4i
	 efCvIQit9IgtANp9VAK+dJ6nq+0LMKgfgINZToGV4oJ1G+cwO57qCy3NTP+Jixd+x5MXt
	 N2xKaJ+2bzC4kCmnh2fq4v3d7mmF/YU5T8dE+FfplSJLKeSIXJo8YJKciDpp0hcTsnA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=vKPIDFMH;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 38D2660A2605;
	Sat,  7 Nov 2026 14:18:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=vKPIDFMH
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D40041F008A4;
	Sat,  7 Nov 2026 14:18:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794061092;
	bh=7/tW0Qio/UJj9TL3dpV4C7x8Woh9Jch/i+I+UdsyX/E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=vKPIDFMHAO06v41HQacIAJrPsYcHdqPNSpeW3OL/7zuxNcYJ3e2bSAGGXUth8pm9B
	 BiLjVsPNvW9YeQf8sKsnTNTggtozAPSv5tnnvFYvEQUHvrzeornB38y9d0oVw2b2gO
	 pTMip+fq+dMA0HnnFpkmJ4BAnbj0pwzrKmKJVvq0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Randy Dunlap <rdunlap@infradead.org>,
	"Maciej W. Rozycki" <macro@orcam.me.uk>,
	Helge Deller <deller@gmx.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0375/1536] fbdev: maxine: fix 64-bit build error
Date: Sat,  7 Nov 2026 08:39:51 -0500
Message-ID: <20261107135008.169294042@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134957.653319350@linuxfoundation.org>
References: <20261107134957.653319350@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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



