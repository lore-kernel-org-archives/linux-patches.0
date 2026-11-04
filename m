Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793830996;
	b=WpkYfM/rjlaNeQD13rmBk3Yg62l9JayEKeS3umpjKtD3Yas1DW86rhKFDb3/bsSf7TL6
	 rXHT137YkwhJ2cl36g0V2FYXIGTtRpHdaLLmFWsAaShXEhkrc5SkW2f3OzoH6yqIBZXo7
	 wRfeBRzVzSyCROllSmGrer4kdZJYpqT/f+L+/bduKHsdZfMzMTMTc41EiZCB1CRZxu7Rw
	 cFKJ8uxN3TovjpAkd9EWD4AGflUFrG9nIae4iPy5tZOmVwHQtX6FN0QZiQ1EBWcCXCoKP
	 TbeqRu2dLiJTvVqtGuOAPPVKjTyYB59Mo9qz9tq/YT1h+ZcU/LdSepQ8TujRG0vx9Bg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793830996;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=EO0MYaWec1YRZ18N+efLk0oKaGv9aQ7F1hriJIed4wo=;
	b=GjSL2xIfcSsqru2CmaMgyDVawnNbMYXIMB6cYPrirvXLJp8W+ezm5hVaF6LGvIT76Pin
	 q0plF1peZdbizrEtE9RLS3zEhZMNGtulTALKj0Jx5fr6y65PpkUZd1UmUelsyRAgw5m8j
	 F/lX3C/O2eVmNJgAoSciXwaoDx0RmZmpwYhufyZp5ZZ49lurdviry5gVQ4Aa5Af1mG7vC
	 ZvOJFOVQC6ZE0Es4whP8pYo3W2KuKKt72LHESZOE8VB4cgeXuy1NN+LeznZWibcD9I8xR
	 3RDexD7p+2V0dN8yZltIXwkXDiw4U7dI4+AEoezfthRof0YXnH6fmW5HGuuPgdULFAQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=izeiti0+;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4AA69606AB06;
	Wed,  4 Nov 2026 22:23:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=izeiti0+
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DDABE1F000C1;
	Wed,  4 Nov 2026 22:23:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793830996;
	bh=EO0MYaWec1YRZ18N+efLk0oKaGv9aQ7F1hriJIed4wo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=izeiti0+xMRT4oZ1E7DKTGV6aiz2TJCVk58Gnb98K9F6yxZ5jJAhdVa0hRTdgM7+0
	 slHm5aOH5aou60eSsvF9e2GtOkOk9tOAJsHNuvVNz0+1GvW8weX6UCnE3Mcx8pv3jK
	 zGvRbZu/zCXLiK9AWOCJVUC6lrq0ubhlPO6vGbD8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Randy Dunlap <rdunlap@infradead.org>,
	"Maciej W. Rozycki" <macro@orcam.me.uk>,
	Helge Deller <deller@gmx.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0446/1005] fbdev: maxine: fix 64-bit build error
Date: Wed,  4 Nov 2026 16:02:59 -0500
Message-ID: <20261104211056.554578938@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261104211043.516122098@linuxfoundation.org>
References: <20261104211043.516122098@linuxfoundation.org>
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



