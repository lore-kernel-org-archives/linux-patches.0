Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794590785;
	b=AVvGv+e8tj7SIAWKlBeU9nRLaZDhBDTTvF13nCWIy7hOcjFowowG6lg3J7NQ/7sFDxxY
	 F1wl1rSp5DxZCoeqcLjH4AG/NzVVyeoBax7RWH0BPoItR36D8WLxkKS4cIym61IWzn4Zl
	 z4FQH5HTDy/Uekeq4RFbMmY+wqUJgr4bOFUwnNfwC1eXUQrBqbGKrFEu3j+BOjnRfQHdJ
	 5xxI1K3A/enldk/4cgUtTHUWvjtvSbeeUsrRj7sMAKsecwOsAB0a++Qb8SzxR0el8024y
	 5xt/dtKbq43TaaadwGLq8/OmO06/WI0Pcf1mhGXaj8AMoOgXJI31WqOb449ueyWGZjA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794590785;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=9FXFeJunU7scU84Or4Qn0JazY/1BhfygQv6+2aTwMVw=;
	b=g2jLI8schPSCFVxmLQCv1sFX1K6x9ln3IN2jb5mF6dI/cOAp9kZ15jwa1hd6DSmZTEXf
	 FmbLlN76tHrr+rA/7wPj/XjhB5lkoXVvoOIeJOrNw3S4wEdPkgHATt2QCvMNTjSUHs0yt
	 cQisZXCEejC63MkKePmhAPkochPjQOaVDstmtDa7fXaikleDLUYWFPGkBlK4/6i9g1rtO
	 3n1pR1aE0kY1MRQeyyzYIond9ZHnvGUSa4E3nOf71mTA7zj0ycoA4IPrYD2oQ0ic6QoUM
	 BgcgDECAWxHFibuzELe7ltZ4TlJXAXmjMw5EJWkNk1xXaQUfL7pICoGgyLrEfgJObCA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=P7XtT+KY;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3EB58607D2CA;
	Fri, 13 Nov 2026 17:26:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=P7XtT+KY
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DDBF11F000C5;
	Fri, 13 Nov 2026 17:26:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794590785;
	bh=9FXFeJunU7scU84Or4Qn0JazY/1BhfygQv6+2aTwMVw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=P7XtT+KYBZU1OTui5iRUcXm/ljN2IAzGehCZCCFn0JJALoprJhFPKEaAd9+DBQrBw
	 fqb3GCjh5/J+2C6c8Bis2liMv5Rhkr47nuUFKt75AVyytYJ0/xgamIZReg8Smo0LuU
	 hVx6HFaJZ1MVdjo/m3xrY3p/tWyfWpjnTCrZ+8n0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Helge Deller <deller@gmx.de>,
	Chintan Patel <chintanlike@gmail.com>,
	Thomas Zimmermann <tzimmermann@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 678/686] fbdev: sh_mobile_lcdc: Make FB_DEVICE dependency optional
Date: Fri, 13 Nov 2026 10:53:31 -0500
Message-ID: <20261113153844.629746472@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153820.902362109@linuxfoundation.org>
References: <20261113153820.902362109@linuxfoundation.org>
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

From: Chintan Patel <chintanlike@gmail.com>

[ Upstream commit c2925992232fdc4e90f030b77e7867921db071b5 ]

The sh_mobile_lcdc driver exposes overlay configuration via sysfs, but the
core driver does not require CONFIG_FB_DEVICE.

Make overlay sysfs optional so that the driver can build and operate
even when FB_DEVICE is disabled. The kernel naturally ignores the
missing attribute group, preserving buildability and type safety.

Suggested-by: Helge Deller <deller@gmx.de>
Signed-off-by: Chintan Patel <chintanlike@gmail.com>
Reviewed-by: Thomas Zimmermann <tzimmermann@suse.de>
Signed-off-by: Helge Deller <deller@gmx.de>
Stable-dep-of: 317a8be73091 ("fbdev: sh_mobile_lcdcfb: Restore the per-overlay sysfs attributes")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/video/fbdev/sh_mobile_lcdcfb.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/video/fbdev/sh_mobile_lcdcfb.c b/drivers/video/fbdev/sh_mobile_lcdcfb.c
index c6da5a62f8c5f..1b7b9dd19b623 100644
--- a/drivers/video/fbdev/sh_mobile_lcdcfb.c
+++ b/drivers/video/fbdev/sh_mobile_lcdcfb.c
@@ -1346,14 +1346,17 @@ static DEVICE_ATTR_RW(overlay_mode);
 static DEVICE_ATTR_RW(overlay_position);
 static DEVICE_ATTR_RW(overlay_rop3);
 
-static struct attribute *overlay_sysfs_attrs[] = {
+static struct attribute *overlay_sysfs_attrs[] __maybe_unused = {
 	&dev_attr_overlay_alpha.attr,
 	&dev_attr_overlay_mode.attr,
 	&dev_attr_overlay_position.attr,
 	&dev_attr_overlay_rop3.attr,
 	NULL,
 };
+
+#ifdef CONFIG_FB_DEVICE
 ATTRIBUTE_GROUPS(overlay_sysfs);
+#endif
 
 static const struct fb_fix_screeninfo sh_mobile_lcdc_overlay_fix  = {
 	.id =		"SH Mobile LCDC",
-- 
2.53.0



