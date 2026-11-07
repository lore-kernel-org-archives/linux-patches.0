Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794063318;
	b=yhpBlmr0Hyk+YfHM5+D+cDBh3WmLFcppbyhitpPa0WmPPiKK/afm1E6F4L7lhjTTRhXL
	 6ONTyFXYsV3pC1HiGDiOdJQJ4OQhDOpKCBAjTuuubODdpqvOHYC2SqBSOuFRA9utqoK8n
	 I4l9aqyt9PtQqlGeyZLI/bRZ+tDeKBvxFusRcjL6RJf+J8xhcZQGTksAsRI5ivalfpOIR
	 s1jvrDpZCvys8p2eGnAImSptD06pMk2SGpdLdvkGnIV4i3yKe/70OvKf2w0COUa1h7sq2
	 cNV3rToUFPuRGC5qLPpkp80rEWPLIFqPV0GwJQ5y2pp2kYoCXWtgUBipkCgnsq9KY5g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794063318;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=e5Z3UO/+98IxhQX7Ws+H+bwwTXDCswjWqJ8m/rXqUsw=;
	b=1C4nIxLOrXwBn1oZul49JLyC/6DXK8UukEXJsHUsB7d19z3GglUckX6rc6yEFFl8WOtM
	 X89RAJ+E+Qlb4kfs6+XjYursvBoISai28Iek9mUSGd2+2Po7d3XBADtrSkbcaG59jZX1y
	 Jg0VTJVlz1UT5YTrkfDGERpj1MWEtWwL/z8apWL4Ky5CQtvU+m/vTk62fCpMkJvs6ghx5
	 igvfwdsLbr7dP8PJ0uKrSlOnBjEmjU0C4cQNN4nVJOJINoFWLCPS0mo0Op1SchPU2cZ0f
	 qfMTogo5eCUyzDxt7M0hGUZ6XY+wS5A9KoHRkYCUFWCIqrW8tKa4Q19XpTAGxCdgTPA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=wPxgOemz;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 99F69606A32C;
	Sat,  7 Nov 2026 14:55:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=wPxgOemz
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 483EC1F008A2;
	Sat,  7 Nov 2026 14:55:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794063318;
	bh=e5Z3UO/+98IxhQX7Ws+H+bwwTXDCswjWqJ8m/rXqUsw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=wPxgOemz2dQXfxFqmR5MzDq5sVpR156p+UmLXKKyFskVJraeSmnBdOgQR+YvfvdQH
	 qKQ5zPl2wCekWfT/T8tEg3d3agGSJ+5gJgSLwsqIZr9xSjvqO3WOmvcCzLLUgTegqF
	 igz/E4+A9sY8DyCMtDrHmBqwe67PzeJFiJN4pqrM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Lorenzo Stoakes (ARM)" <ljs@kernel.org>,
	Helge Deller <deller@gmx.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 504/869] fbdev: sh_mobile_lcdc: check for fb_deferred_io_init() error
Date: Sat,  7 Nov 2026 08:53:06 -0500
Message-ID: <20261107134910.694976193@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134852.069646174@linuxfoundation.org>
References: <20261107134852.069646174@linuxfoundation.org>
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
index 6038f217ab427..c6da5a62f8c5f 100644
--- a/drivers/video/fbdev/sh_mobile_lcdcfb.c
+++ b/drivers/video/fbdev/sh_mobile_lcdcfb.c
@@ -1042,7 +1042,11 @@ static int sh_mobile_lcdc_start(struct sh_mobile_lcdc_priv *priv)
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



