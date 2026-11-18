Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795052621;
	b=OvIs09xysmEXGSfnpNrgPv3S5+789bU8IsEH9AGZujqiidJBDzx80Ggk/I+IqCmz6fse
	 3HWoKxTPgPRhifOXLyk/0nM+UzqwrpP0rzcqsvjgU5Q5dbOjhHjtpXr5WSpjaoueRlJWZ
	 cDVvlnL60XIwSwY2B241WChN7KfnBvAknTJL/b1CkhhyR+lvne+SVBKxGRp9K4FFqF8qr
	 s5NGqQq85xNPsnd1M8wIS3IXz1MRyRYGn/q73FMh3ErPVMvbyY1QqZVcwXKtUv0g4ugCb
	 DSXmZl1/GNuAF4b01W2xF1tw5Ks4iDaBzMhiASWNuEpdqSc0HoOWwbrlnajBGH12WbA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795052621;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=VJZ9cZRQeOXyraDEt/hc9MuWagg3DJ70bRuEEFHMCUE=;
	b=NDMWyQ0Qdi7KgRPPeDYacGlclIm367OB48R3NlwbXlOdgUQ+sZDLC+pkgi5K1EnCzZQR
	 sVsXGlMe/Tf4v9y2o/1r1pp48EyQHCXHJ4fPdYLFW7+mQMEniV6sxqaPjGgS3ArAX8Jzh
	 vfmKTZsa6pn3NPyfIXa+NY6BMPzEBdB+JBzrovcJ/kFJKus0r7UEwUZ0aV4hGB3U+Np1x
	 2UXy6drTmGfIzOxKftTzOA19XQ0rsPIp5Ox8BxrqBwoBG0DaEF3oMmzGr1WkJ1yQ/cO88
	 ZTCwz3GtXthTX8iQBVT+WNeN8hn+ahUtdjiv3UzeJNyVChX26d/gjo3U4r8HL55Y/CA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=BAFqhXd+;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9FCB0606A330;
	Thu, 19 Nov 2026 01:43:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=BAFqhXd+
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 00B561F000C4;
	Thu, 19 Nov 2026 01:43:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795052621;
	bh=VJZ9cZRQeOXyraDEt/hc9MuWagg3DJ70bRuEEFHMCUE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=BAFqhXd+bhqf6jHfDctUHkky0Hsz1SyLaVufHL2/u6TSApD2ujwdfQBgIc27PKFHS
	 S/e783haxnDiOGQWCXpITjVGorgEjn7w8mR2UUg2Kw9JYzRXf+KAiNS6SxXCTNwdil
	 txRBXh8rLVa+I63Hr3QbQNA6rMtKLjWnOVLhuRZY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Lorenzo Stoakes (ARM)" <ljs@kernel.org>,
	Helge Deller <deller@gmx.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 0626/2214] fbdev: sh_mobile_lcdc: check for fb_deferred_io_init() error
Date: Wed, 18 Nov 2026 15:38:22 +0100
Message-ID: <20261118150036.410320290@linuxfoundation.org>
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

From: Lorenzo Stoakes (ARM) <ljs@kernel.org>

[ Upstream commit 5192201aaac2a923ff98306e3ccda58718ee395f ]

fb_deferred_io_init() allocates deferred I/O state, populating
info->fbdefio_state, or leaving it NULL if an error occurs.

Currently sh_mobile_lcdc_start() ignores its return value.

Therefore if an error arises in fb_deferred_io_init() (for instance, due
to an allocation failure) info->fbdefio_state is left NULL.

When the file is subsequently opened, fb_open() will dereference a NULL
pointer (calling fb_deferred_io_open()).

Fix this by checking for the error.

Also clear info->fbdefio in that case, so that sh_mobile_lcdc_stop() does
not attempt to clean up deferred I/O state that was never initialised.

Fixes: 56c134f7f1b5 ("fbdev: Track deferred-I/O pages in pageref struct")
Cc: stable@vger.kernel.org
Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
Signed-off-by: Helge Deller <deller@gmx.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/video/fbdev/sh_mobile_lcdcfb.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/video/fbdev/sh_mobile_lcdcfb.c b/drivers/video/fbdev/sh_mobile_lcdcfb.c
index 74a013c398b14..08e28dc282bf5 100644
--- a/drivers/video/fbdev/sh_mobile_lcdcfb.c
+++ b/drivers/video/fbdev/sh_mobile_lcdcfb.c
@@ -1047,7 +1047,11 @@ static int sh_mobile_lcdc_start(struct sh_mobile_lcdc_priv *priv)
 			ch->defio.deferred_io = sh_mobile_lcdc_deferred_io;
 			ch->defio.delay = msecs_to_jiffies(tmp);
 			ch->info->fbdefio = &ch->defio;
-			fb_deferred_io_init(ch->info);
+			ret = fb_deferred_io_init(ch->info);
+			if (ret) {
+				ch->info->fbdefio = NULL;
+				return ret;
+			}
 		}
 
 		sh_mobile_lcdc_display_on(ch);
-- 
2.53.0



