Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D2888389;
	Thu, 13 Jun 2024 12:33:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718281994; cv=none; b=udQTjqb64W0x+CbAsyFxUjb43CrxexYPKAl3RuWuXGuK9QDOfxkiAy2vaKIs8zWWfgcuHBdLqIRkt4tg2pK7poiQpHh1x3pQ5fBwkaSE3WMbCUx+I1vnp/Y0P7lLKY7xh+OUAay0vB+ay9fn/OtsJ/zR+nd4Jrs9HL/yZc8bves=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718281994; c=relaxed/simple;
	bh=BxtpqioJOlbZn33XgJcltQk73t/pZSchRIebU9jqZ3Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AbWVao++megxyghidxEjzjmlwErexZj3B4FBy4yp6hIR1i1R4EKIoZsW9mzRt0JZ2++Tc5e7rQJurBUG0A17CLMskAzMjXrRK1sqdcOyYUt5FUZK14Rc2Qr76y5VWwlk0MMTQlpokKZb2BBgpqJzrM/qRcvSqKh1X6J3Yzz3L2o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OV3kpNIR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OV3kpNIR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4EEF4C4AF1A;
	Thu, 13 Jun 2024 12:33:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718281994;
	bh=BxtpqioJOlbZn33XgJcltQk73t/pZSchRIebU9jqZ3Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OV3kpNIRck8CvkEwvEMtfxwfbSCXIAyYw5ETEEbkaHsGQET63JfY9lDC7WRkHF5FZ
	 6Jl0RR9bUUH7nxhKPdaYbT46E/MU2wndQOliUTwe55SOUIP8J0lhOzn/m14WRhzFiH
	 GdcEaGX3lWZD0Z97W6rydBouDKur+zRcb1TzYgKQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Arnd Bergmann <arnd@arndb.de>,
	Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
	Helge Deller <deller@gmx.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 127/402] fbdev: shmobile: fix snprintf truncation
Date: Thu, 13 Jun 2024 13:31:24 +0200
Message-ID: <20240613113307.094258687@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240613113302.116811394@linuxfoundation.org>
References: <20240613113302.116811394@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index e33c016c5428c..74a013c398b14 100644
--- a/drivers/video/fbdev/sh_mobile_lcdcfb.c
+++ b/drivers/video/fbdev/sh_mobile_lcdcfb.c
@@ -1577,7 +1577,7 @@ sh_mobile_lcdc_overlay_fb_init(struct sh_mobile_lcdc_overlay *ovl)
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



