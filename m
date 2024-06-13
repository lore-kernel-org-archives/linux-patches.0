Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AFE71142E84;
	Thu, 13 Jun 2024 12:16:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718280968; cv=none; b=e6H3IJ0voFgL9dcy2jjBn78oTq+ICIigmpI2WShtJosM9IvJQhS0xNeDhaHweAlYTGlEDVENAaxu7OWYrlgoiHKNbDAGHu17GSbpjyzLrAY4qShuPcT+DlM3O53U1I52e0p5+DixdUlMNUSNqzl8+UlHANs1+g9ruvNO0lCw4bE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718280968; c=relaxed/simple;
	bh=X5XwfDi8bihHSWg8IHwrR8Gp6AZwpqZVpcqjB5qGWoE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dIAOVvXq1LFslcbqg08BZVlv7FHNXakALiNU4a3gY5D2YhCUkUc83flzCmEDhTBzgzYK9q17LKhTTAIasVd4IYS/t/zd+jlzwRP4h8AgCgkvvro2ulBfIga0+EEbkE7eNTdyGSDyrbFif7b2N19sVXJCeQtLnotBJc+FQ0IxSQw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=aNBrOvKK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="aNBrOvKK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 36078C2BBFC;
	Thu, 13 Jun 2024 12:16:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718280968;
	bh=X5XwfDi8bihHSWg8IHwrR8Gp6AZwpqZVpcqjB5qGWoE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=aNBrOvKKhIUqc0aZQzHRMp1BtGBvbQ0W4FSteXS7jqLcfQGewsbC57jPT6G07E01v
	 9ZiH0UKkTuoToEAkd43FWMz/G+sJXODB9L2NjsVkiEvZu176DX1HkWwz3uFoRakHi5
	 MBR+b0oYlg3bYo/n7n24SYsDq9g4lleU2jk+pZ/o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Arnd Bergmann <arnd@arndb.de>,
	Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
	Helge Deller <deller@gmx.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 094/317] fbdev: shmobile: fix snprintf truncation
Date: Thu, 13 Jun 2024 13:31:52 +0200
Message-ID: <20240613113251.187313152@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240613113247.525431100@linuxfoundation.org>
References: <20240613113247.525431100@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index c1043420dbd3e..21d13d16f973c 100644
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



