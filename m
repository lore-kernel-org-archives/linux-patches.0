Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 423ECDDB1;
	Thu, 13 Jun 2024 11:39:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718278781; cv=none; b=WIhNESfPmLwrW17TNuLsZKwh4c79XoUMZAlbssKeNiOq2HYCG3ZMLrCIwbFOXxLVTPylD1eL9hb8yVJaVorZ9lcH/Wvl5TmBHrquQfAwZZP79X2ySukUTgHBlH6aUj14q4PgzT+kSCIUOI7Tr7bF0N8iHw1UGHPe02DrUmsWO/Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718278781; c=relaxed/simple;
	bh=TxA6/Zx1RuvnwvIYp4cfortVmDrl2PMB1hhRIMWMfJY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CQR90R4rE9IKdLO7mr5U/1dOHWBnGj3NUcGLRiYJrQbKzdXP9AhvnHZghnGKVKiDUyX/u2pPBC9jLZzhGgkxgHBkFtk/KeJH2SS/eTUvYnCc/SydfSZvB1D770n0Q51PQ35T4IPX6eHBIbLYuBx9nfHKv6PXV+K08rea/7JdznM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=B3r393p5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="B3r393p5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BE88DC2BBFC;
	Thu, 13 Jun 2024 11:39:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718278781;
	bh=TxA6/Zx1RuvnwvIYp4cfortVmDrl2PMB1hhRIMWMfJY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=B3r393p55JcCDxWoNn69KwSv/HFXbrNxjvYl7960YbuXWp+en4gYYH2/+AUsSxOEe
	 wJt7pZ+3AjhDEEZSOQzvWAlgZiORFlZWNXKGKh+HWnpV0eCeTjEE3Nd/PHTEL69FhP
	 yY/JoBbFugkzWcm5QYeS7VnUWQHhYTNm68c5mc34=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Arnd Bergmann <arnd@arndb.de>,
	Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
	Helge Deller <deller@gmx.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 067/213] fbdev: shmobile: fix snprintf truncation
Date: Thu, 13 Jun 2024 13:31:55 +0200
Message-ID: <20240613113230.592799283@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240613113227.969123070@linuxfoundation.org>
References: <20240613113227.969123070@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

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
index dc46be38c9706..4e97525346ed3 100644
--- a/drivers/video/fbdev/sh_mobile_lcdcfb.c
+++ b/drivers/video/fbdev/sh_mobile_lcdcfb.c
@@ -1662,7 +1662,7 @@ sh_mobile_lcdc_overlay_fb_init(struct sh_mobile_lcdc_overlay *ovl)
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



