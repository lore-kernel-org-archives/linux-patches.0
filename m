Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795043594;
	b=kGZyoP8/WhElZPcnWgHdxKblC9Bnr8ZeI9tapRV02QyzJQdmrEtGaJQyFLTfYrmcdI/h
	 GWb0ZgWMosxaVk6qzx1rfMJXdHjszHOwOVzAThFFU5gCYm7Qpb8M26M2ml/0O5uo/A1NT
	 Ap8EbJhbeFSIOn6mXgUuhxgYjpYl6AUQXOR2REu65A6JN7PjwZIUi0MxNKLD6F1wAJpdO
	 li9867iM6rnxFapRcVhroFm8zQM6Cs+hCG3t/wjupIc4wcedXNVqvsM28aKxf1U26C4IS
	 0jZQy7gKzOs1cpLrPdz5qyUH5AgsLdPwgBlskLy3yykFOKkVDqFniJnd/Y3bZHQ93yw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795043594;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=BX3BjTfOZijvzqZfRUV9H90zCYTjXdhmxwPcBeQaW9c=;
	b=cBddVe5QXd4oiaWKGlGQCc8qPy7gjHVzps/6APC+hJKcVwKAnyOSJHddNLex6wQRK6aN
	 NOCc358AFCYDEPcvSBsBFQtVItpxxlkIglIgVDV8RSZjl7WgUP2FxoJIU++x7O4Uyv9sP
	 4v+kVzMK8XlLUghT7yzl38Nd9KbWf3qXV0TDiCpW2wfPMpBam7eLbjdPH6Jf+kzGgM4/n
	 WavL0ML3+s0HNh/BjezLwfXuXaRhEfIE4a5IpVMKHa3zzljoIGhmyj1TVNKqIYB/QJxmf
	 dVS0oEUpxax1H6EE9FyhsJK5V99n/EIM25Ts7Qkl5qFoR/lOMGGZQMyvEdk6d+bb/ZQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Zyrfs9Uz;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 88687606A320;
	Wed, 18 Nov 2026 23:13:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Zyrfs9Uz
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DCEC61F000C4;
	Wed, 18 Nov 2026 23:13:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795043594;
	bh=BX3BjTfOZijvzqZfRUV9H90zCYTjXdhmxwPcBeQaW9c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Zyrfs9UzcPntNQ4HwXVOz8XxmE7jq+d/Z970/Vj1mkFbmJ1iWT2P/iZNu2cdNJJnm
	 ABMSdkkJI9WmV4wgqgR6/rIo736LSq0u3i072c90hrlhzDBce/52J3Cke8jjeI16TO
	 Znu0/G9R/+rk2GnVFVBhqFm8nZj+5QWep29Ta5Wo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Randy Dunlap <rdunlap@infradead.org>,
	"Maciej W. Rozycki" <macro@orcam.me.uk>,
	Helge Deller <deller@gmx.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0265/2857] fbdev: maxine: fix 64-bit build error
Date: Wed, 18 Nov 2026 15:21:39 +0100
Message-ID: <20261118150210.973630561@linuxfoundation.org>
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



