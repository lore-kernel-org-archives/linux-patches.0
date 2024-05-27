Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E113317727;
	Mon, 27 May 2024 19:32:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716838380; cv=none; b=Ity9xYRcE1bkDi+JePzsQWTcSZ1x4xdFouQ+Edc7JZ7DE+4EJQ0N8mDt6bteoo4fmVWMHl7AQoxIO7tgvuRFHHaw1ISkR+EBE8XAbrlfKbhCK0HUKw6s+yuINymO7A/YCSvTXp7zzUaGDNXx0EsqBaXtlXUspUbQlEt4/6EFx+I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716838380; c=relaxed/simple;
	bh=rTik0pc86XrhDkNnYy1xIJLcUWyLGi7naGHRFfsHudU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aH+NZVGawNAay+5OQo3Pa1LNw1X3SDRRFqFDFw15UGNoEaqTcgq6F2YD7QxEyX22cnc59HOS5jvkF210z2lk9Ecdv2Jm2HV1lecZNsBEKg8vvBCacofw9PiXx0MchTLjIDRKURK2rKS6WcmkQHOiNq1GtorAvAfITN3HDUIiNi8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xtaSub6P; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xtaSub6P"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 775BCC2BBFC;
	Mon, 27 May 2024 19:32:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1716838379;
	bh=rTik0pc86XrhDkNnYy1xIJLcUWyLGi7naGHRFfsHudU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xtaSub6POiNGKbJuRX+kvg+8KgxJ6ocZGZWoYG0UwPz6tNjCU6K8mQect/M1cbcm2
	 3zLrnrprAnAtaWhnuHe5NJmS3rRQXsWbJj+zPpcPwkNt9GFAddwjywF78ldWBu/9lu
	 ZbJip5cSfClMUB68rJ+qx0QchMNa3SHIMP/7+qUE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Arnd Bergmann <arnd@arndb.de>,
	Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
	Helge Deller <deller@gmx.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.8 370/493] fbdev: shmobile: fix snprintf truncation
Date: Mon, 27 May 2024 20:56:12 +0200
Message-ID: <20240527185642.375025486@linuxfoundation.org>
X-Mailer: git-send-email 2.45.1
In-Reply-To: <20240527185626.546110716@linuxfoundation.org>
References: <20240527185626.546110716@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Arnd Bergmann <arnd@arndb.de>

[ Upstream commit 26c8cfb9d1e4b252336d23dd5127a8cbed414a32 ]

The name of the overlay does not fit into the fixed-length field:

drivers/video/fbdev/sh_mobile_lcdcfb.c:1577:2: error: 'snprintf' will always be truncated; specified size is 16, but format string expands to at least 25

Make it short enough by changing the string.

Fixes: c5deac3c9b22 ("fbdev: sh_mobile_lcdc: Implement overlays support")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Reviewed-by: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
Signed-off-by: Helge Deller <deller@gmx.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/video/fbdev/sh_mobile_lcdcfb.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/video/fbdev/sh_mobile_lcdcfb.c b/drivers/video/fbdev/sh_mobile_lcdcfb.c
index eb2297b37504c..d35d2cf999988 100644
--- a/drivers/video/fbdev/sh_mobile_lcdcfb.c
+++ b/drivers/video/fbdev/sh_mobile_lcdcfb.c
@@ -1575,7 +1575,7 @@ sh_mobile_lcdc_overlay_fb_init(struct sh_mobile_lcdc_overlay *ovl)
 	 */
 	info->fix = sh_mobile_lcdc_overlay_fix;
 	snprintf(info->fix.id, sizeof(info->fix.id),
-		 "SH Mobile LCDC Overlay %u", ovl->index);
+		 "SHMobile ovl %u", ovl->index);
 	info->fix.smem_start = ovl->dma_handle;
 	info->fix.smem_len = ovl->fb_size;
 	info->fix.line_length = ovl->pitch;
-- 
2.43.0



