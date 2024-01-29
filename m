Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 861FF15D5DF;
	Mon, 29 Jan 2024 17:13:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706548420; cv=none; b=RA8H+NXAWqWTLVQisArp37Vp5McIfAK2snwkyKsJdxrnz5YfjynTC6NE1CpTCXWwnB85c06PvUTR0VzDNFj6tyHnOXTllUtIN8Eu5xREBXHaIi/ycbuZUvNuxVqlQq3rdZZr5lpOu5Gukda0VdO7Jmend5u8w24u8/SiJdNjlVc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706548420; c=relaxed/simple;
	bh=nzQpkC5CmssvHEQ/6IbIQ/gJFtPyBOJEohBloBRB7F8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=HC+9fItsBBHgjkHtGT7ZvP+ew9zDss7K2a9YnWJ3lG6zN9mxhgjen5SbM04C1wmts9JSwq4QbT/tq+MUCRPIvjCAnCEY4tR4fyJPr9+ZjDSxv6gc55HuXvRL175o/E8RDKO1gCRbf5vh8GvwdpQmiqECILaUKeBfzUFjPFAwINQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=neuiwtw+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="neuiwtw+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4B253C43390;
	Mon, 29 Jan 2024 17:13:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706548420;
	bh=nzQpkC5CmssvHEQ/6IbIQ/gJFtPyBOJEohBloBRB7F8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=neuiwtw+1iwndMXhgCvBZb4hkrTTflf6U7Fisvt58HjbKkahC+f5FqKLSLFXXbAE2
	 KxAvb8H26kc3mQa1l07tMqMkPID/Fv7ryZy8klRdcu+noUx1poReEWdpC5icq/9Pil
	 iQbnIj1t4Xw4Bw9+C5J88q6Y+j2OuEz/7t8E/SNs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	kernel test robot <lkp@intel.com>,
	Geert Uytterhoeven <geert+renesas@glider.be>,
	Thomas Zimmermann <tzimmermann@suse.de>,
	John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 019/331] sh: ecovec24: Rename missed backlight field from fbdev to dev
Date: Mon, 29 Jan 2024 09:01:23 -0800
Message-ID: <20240129170015.526132429@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240129170014.969142961@linuxfoundation.org>
References: <20240129170014.969142961@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Geert Uytterhoeven <geert+renesas@glider.be>

[ Upstream commit d87123aa9a7920e88633ffc5c5a0a22ab08bdc06 ]

One instance of gpio_backlight_platform_data.fbdev was renamed, but the
second instance was forgotten, causing a build failure:

    arch/sh/boards/mach-ecovec24/setup.c: In function ‘arch_setup’:
    arch/sh/boards/mach-ecovec24/setup.c:1223:37: error: ‘struct gpio_backlight_platform_data’ has no member named ‘fbdev’; did you mean ‘dev’?
     1223 |                 gpio_backlight_data.fbdev = NULL;
	  |                                     ^~~~~
	  |                                     dev

Fix this by updating the second instance.

Fixes: ed369def91c1579a ("backlight/gpio_backlight: Rename field 'fbdev' to 'dev'")
Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/oe-kbuild-all/202309231601.Uu6qcRnU-lkp@intel.com/
Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
Acked-by: Thomas Zimmermann <tzimmermann@suse.de>
Reviewed-by: John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>
Link: https://lore.kernel.org/r/20230925111022.3626362-1-geert+renesas@glider.be
Signed-off-by: John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/sh/boards/mach-ecovec24/setup.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/sh/boards/mach-ecovec24/setup.c b/arch/sh/boards/mach-ecovec24/setup.c
index 3be293335de5..7a788d44cc73 100644
--- a/arch/sh/boards/mach-ecovec24/setup.c
+++ b/arch/sh/boards/mach-ecovec24/setup.c
@@ -1220,7 +1220,7 @@ static int __init arch_setup(void)
 		lcdc_info.ch[0].num_modes		= ARRAY_SIZE(ecovec_dvi_modes);
 
 		/* No backlight */
-		gpio_backlight_data.fbdev = NULL;
+		gpio_backlight_data.dev = NULL;
 
 		gpio_set_value(GPIO_PTA2, 1);
 		gpio_set_value(GPIO_PTU1, 1);
-- 
2.43.0



