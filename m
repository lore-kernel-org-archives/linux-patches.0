Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B411D3F1AD9;
	Wed, 20 May 2026 17:51:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779299514; cv=none; b=OANWqWYVdIuMy5YApw8qlZgXxcRytgF919jyB/WtJqat9YZfwNyF/m5VwR0lelTq//7bDuA0kNXHi7eA7QR33JM0bru8uvwXqtejK/ZRaJSZheFjGtxzYnqNsGnSdQJN9UezTb7RRKuXneWFFgD9a2P4o6E6jWOkFtqOtCjSfBI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779299514; c=relaxed/simple;
	bh=SMSDYw2J7V3qKPXLSmbTRL7UDKK846hd26A+wUu5DdM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kbuYH4K7FbebNQZMcLdTrprhN/jef8gD5c2hd7eZ2YynrOoiApuhBpCiPkv/M6PVSW2Adudqr2y+WEjJDSgCHaF1hhKuv0vwnCDkWXyHSGCdv1Y8YtYdg1Lhl8Kc3y+Ep0wKISa2HywZz3KWLoPQEaFJeAztyngviyz8fYM0xw0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Tl9A/QtC; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Tl9A/QtC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 276BC1F000E9;
	Wed, 20 May 2026 17:51:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779299513;
	bh=BCwZnC0L2LL7abEVYJEyfo7yS9kee8FUDhp7Yrd66SM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Tl9A/QtCav09pfl7STcDR6pFuIbf11BYZ6gJE4IDkTz/zrfK1GG6kQDd9msEGk8ua
	 Z4nRMASyuRflc8//qiiLX76m4LZ1SZRkEqi6cDknujQXzO6PcHMWcnOwpD9Wf3GrGO
	 iDfT8MBr4mpjuekPrjM5JksH5YTDTb80sAQ0MWcY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Geert Uytterhoeven <geert+renesas@glider.be>,
	Javier Martinez Canillas <javierm@redhat.com>,
	Thomas Zimmermann <tzimmermann@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 759/957] drm/color-mgmt: Typo s/R332/RGB332/
Date: Wed, 20 May 2026 18:20:42 +0200
Message-ID: <20260520162151.024635812@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162134.554764788@linuxfoundation.org>
References: <20260520162134.554764788@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Geert Uytterhoeven <geert+renesas@glider.be>

[ Upstream commit 9d5a2b8f6281f6090002517fb9272ea07038afe8 ]

Fix a typo of "RGB332" in kerneldoc for the drm_crtc_fill_palette_332()
helper.

Fixes: 7ff61177b7116825 ("drm/color-mgmt: Prepare for RGB332 palettes")
Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
Reviewed-by: Javier Martinez Canillas <javierm@redhat.com>
Reviewed-by: Thomas Zimmermann <tzimmermann@suse.de>
Signed-off-by: Thomas Zimmermann <tzimmermann@suse.de>
Link: https://patch.msgid.link/c413e45c8f752a532a4ff377f7a8b9eaab4a082a.1776757681.git.geert+renesas@glider.be
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/drm_color_mgmt.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/drm_color_mgmt.c b/drivers/gpu/drm/drm_color_mgmt.c
index 131c1c9ae92fc..302a32d050a6d 100644
--- a/drivers/gpu/drm/drm_color_mgmt.c
+++ b/drivers/gpu/drm/drm_color_mgmt.c
@@ -831,7 +831,7 @@ static void fill_palette_332(struct drm_crtc *crtc, u16 r, u16 g, u16 b,
 }
 
 /**
- * drm_crtc_fill_palette_332 - Programs a default palette for R332-like formats
+ * drm_crtc_fill_palette_332 - Programs a default palette for RGB332-like formats
  * @crtc: The displaying CRTC
  * @set_palette: Callback for programming the hardware gamma LUT
  *
-- 
2.53.0



