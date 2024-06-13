Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1ED59144D31;
	Thu, 13 Jun 2024 11:58:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718279886; cv=none; b=mP7lPQix7uuPPBd+Radrgi9874dQE+uSi+Q/41W2FXkY18wYvjLtxmaHqBGHGtnKwWVpMB6LkNQ4Qd3IOIraqwAHX2dDuSLoGaTJuTZvskPs1VGPi4w52nxiTEJySun3PexPC5BlLWlr19kBK92OyVt+Mx0FSNtG5mwmwJ+63Hs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718279886; c=relaxed/simple;
	bh=RkX/5V34/tVhYBo2VjysP0Zx/XT0Mx2CAqAOggcy2Yk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KzhmGntdWjBOnNYsPRtA5u+3d43i1kUB4flFC7Wwu28mVUwqHtUTObVuk8RYNwJYdxfvWK8gVZvC1n4028cUhj5L+dwpxh+xE9AlI4DgX/7QZNYS/owD+xm3h9rliQBQ/BpC0gW/gXJGYIqkGxO1hyoh80j3PlDVrBRF1BS/p2c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QiofR0En; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QiofR0En"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4103FC2BBFC;
	Thu, 13 Jun 2024 11:58:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718279885;
	bh=RkX/5V34/tVhYBo2VjysP0Zx/XT0Mx2CAqAOggcy2Yk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QiofR0EnfDoAqcLl6XdvsdEfqdHnKGcDdMHj7MtLxbn/deTh9tPHJHhhUFFtIsy5L
	 ZNP7u6m2uBxPlSC1YENAiHB5waNEgHUwNtggoReSd+ubTZBKlfIM6X3wMwYn+Blffz
	 jRnYpgxTmYh8GTKJ7YxSdng8EVFZkvoXzxwwQ6Zs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Arnd Bergmann <arnd@arndb.de>,
	Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
	Helge Deller <deller@gmx.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 070/202] fbdev: shmobile: fix snprintf truncation
Date: Thu, 13 Jun 2024 13:32:48 +0200
Message-ID: <20240613113230.479279515@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240613113227.759341286@linuxfoundation.org>
References: <20240613113227.759341286@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
index c249763dbf0bf..85af63f32d5e4 100644
--- a/drivers/video/fbdev/sh_mobile_lcdcfb.c
+++ b/drivers/video/fbdev/sh_mobile_lcdcfb.c
@@ -1580,7 +1580,7 @@ sh_mobile_lcdc_overlay_fb_init(struct sh_mobile_lcdc_overlay *ovl)
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



