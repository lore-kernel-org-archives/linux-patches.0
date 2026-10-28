Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793216023;
	b=2rqG1qBor5UHt0kWxrD6ecRGa9fFKYN+5nM6dJ2zqemOwX2/Rw2mvnOXm7CmWahEJB/m
	 A3tMdNUbf/0YmUXfhhqV+YWeGLZ8wiJRcq9/Ebl2LbCYSs+j1l6xAbj/7ZwTmB34gsF1F
	 +HqhuAYC+1tgypldfRmZDkeKM3towtU/fYtlkbVaNL+9WzUlf0CPdJh5938XSDVOnY31d
	 XytrCTpFi1Gg286+1nqSIagNxhe5QTJs71IaY3et+29A058ZHSooQ9gxG1J7hHUvx1Hti
	 KpK2U0oE0BQIvu5Usb2bqJ7s8gAUdoc8fEMglPKxjr1TjyLeBoRlls0qQuP7d735jNg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793216023;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=T8tNuPriWWKxkVjBK+ymEGrL07osJMYoLaaU79jZpj0=;
	b=ZY/wWmxHQhycC8xVgPfkwhdnWPFrj9qRNejbgferhzO2f/ewuSleeDkJUHRdYvDtuR6x
	 YiTTJstcu28gr7T16DxuHswKdm2nZVrAFPDedEw27qqJbdTQiVFAnfpT9BNthUGNrltJa
	 BkJQygYjv6zx/E1pf73KYc+WE8rN815crpDpebXvgUZWJP8cqnlRqYSl5E59mNN2sU/tK
	 z7BMB/d2qR1CAmkkxeUwcLUYcCkZnDc/vWWkQ94HE/joOThkFYnSgtttMuqEgIVvZJLNl
	 hcmHOxEetqNatrZQEAczu1ATmrMuSvO6+CSZX/xER943Pj3/Nf/U1iUCWqoeFED1Apw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=qiJRjIqO;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 780E5606A31C;
	Wed, 28 Oct 2026 19:33:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=qiJRjIqO
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BC4F21F01825;
	Wed, 28 Oct 2026 19:33:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793216023;
	bh=T8tNuPriWWKxkVjBK+ymEGrL07osJMYoLaaU79jZpj0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=qiJRjIqObf3ezIVEB/cp4TkkkaCAqDu2RqEETvYnT65+IfiBhL4YHND8hRnyYJ3Du
	 b70ps2OwzkMi1MsQtYMWDzz6xC27+HUVqyKezQm/C9vkqPpBEo5BNoynrPCyepWYnF
	 X87H4CyljJ3sU/erURBJeHdbprFikFM3APGtz/gI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Paul Cercueil <paul@crapouillou.net>,
	Lee Jones <lee@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1370/1887] mfd: sm501: Remove #ifdef guards for PM related functions
Date: Wed, 28 Oct 2026 17:57:46 +0100
Message-ID: <20261028170530.626772062@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
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

From: Paul Cercueil <paul@crapouillou.net>

[ Upstream commit 3833239b5ba22256389c2fd83ca70b6a9028435b ]

Use the new pm_sleep_ptr() macro to handle the .suspend/.resume
callbacks.

This macro allow the suspend and resume functions to be automatically
dropped by the compiler when CONFIG_SUSPEND is disabled, without having
to use #ifdef guards.

This has the advantage of always compiling these functions in,
independently of any Kconfig option. Thanks to that, bugs and other
regressions are subsequently easier to catch.

Signed-off-by: Paul Cercueil <paul@crapouillou.net>
Signed-off-by: Lee Jones <lee@kernel.org>
Stable-dep-of: 83feedd9d83c ("mfd: sm501: Fix potential memory leaks during remove")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mfd/sm501.c | 10 ++--------
 1 file changed, 2 insertions(+), 8 deletions(-)

diff --git a/drivers/mfd/sm501.c b/drivers/mfd/sm501.c
index fef0dc5684885..1865621d62f27 100644
--- a/drivers/mfd/sm501.c
+++ b/drivers/mfd/sm501.c
@@ -1434,8 +1434,6 @@ static int sm501_plat_probe(struct platform_device *dev)
 
 }
 
-#ifdef CONFIG_PM
-
 /* power management support */
 
 static void sm501_set_power(struct sm501_devdata *sm, int on)
@@ -1511,10 +1509,6 @@ static int sm501_plat_resume(struct platform_device *pdev)
 
 	return 0;
 }
-#else
-#define sm501_plat_suspend NULL
-#define sm501_plat_resume NULL
-#endif
 
 /* Initialisation data for PCI devices */
 
@@ -1716,8 +1710,8 @@ static struct platform_driver sm501_plat_driver = {
 	},
 	.probe		= sm501_plat_probe,
 	.remove		= sm501_plat_remove,
-	.suspend	= sm501_plat_suspend,
-	.resume		= sm501_plat_resume,
+	.suspend	= pm_sleep_ptr(sm501_plat_suspend),
+	.resume		= pm_sleep_ptr(sm501_plat_resume),
 };
 
 static int __init sm501_base_init(void)
-- 
2.53.0



