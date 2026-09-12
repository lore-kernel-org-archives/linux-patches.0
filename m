Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B391282F1B;
	Sat, 12 Sep 2026 07:44:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789199044; cv=none; b=crEy6MzAU8jHV9V5sxwMClvjXMi+jYN9YC/Zomsf6hZtWdi9z4TSdWdjdFUxwXFFliTvk4x/upaBdgFrHefCTMa2CJekmlZxyrSD9HYc0pAKl7ZXIq0qbUE8SzWXI3uFtqrnYbIzdg4A89Qqnv9klUI1NWBH+Lt6/tot8kN2+d8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789199044; c=relaxed/simple;
	bh=2j4f+7hgGA0NpFKWN47Lbss5g2PBML+oPQUeYwVQ2h4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iOB9A67EryS4SB+IlOIggdsa9n0EUYc+KJcIofsgMVexRTE9F9oX6yYIoe3DqrLTRxWi3UyZG9nsgcp8h2ZuW+eICqjjdQr6SVP2JrveyDqF3lrJuQGHGHqIiBlcYL0fUBS9GCr0/NQW+xWr9kQqxmteJycJvVFk/xdqWU4IoMk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pkYOfvi1; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pkYOfvi1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 088241F000FF;
	Sat, 12 Sep 2026 07:44:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789199043;
	bh=wAEeouUk8/99eBEeuIj3ht6RU2LAKOSLPkuOOUfSEyU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=pkYOfvi12LwNVUhb0Hsz2sEWpLuOiBJRvcvL0pPegu2LMXfw6+FLmZEUS3MMan4yL
	 v5HCmp4MPWtkMRmbF5x6DNZElFkwSXnHP8n5B/8qTtObqUlF1EjEB373dJvhFz7Qxo
	 jGwYrOhP541F8zMdo0zs7lD5WdF+6+spy2trSBUg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	kernel test robot <lkp@intel.com>,
	Iker Pedrosa <ikerpedrosam@gmail.com>,
	Javier Martinez Canillas <javierm@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 0461/1815] drm/solomon: remove unneeded variables in blit functions
Date: Sat, 12 Sep 2026 08:36:51 +0200
Message-ID: <20260912065659.712681802@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Iker Pedrosa <ikerpedrosam@gmail.com>

[ Upstream commit e5320be8a585a9286f231305d0d443d59c24e46c ]

Remove unneeded 'ret' variables in ssd130x_fb_blit_rect(),
ssd132x_fb_blit_rect(), and ssd133x_fb_blit_rect() functions.
These functions initialize ret to 0 and return it unchanged,
so return 0 directly instead.

Fixes: 2258f03989af ("drm/solomon: Move calls to drm_gem_fb_end_cpu*()")
Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/oe-kbuild-all/202606301409.I0ctsf41-lkp@intel.com/
Signed-off-by: Iker Pedrosa <ikerpedrosam@gmail.com>
Reviewed-by: Javier Martinez Canillas <javierm@redhat.com>
Link: https://patch.msgid.link/20260709-fix-ssd130x-v1-1-1272cb3dc85e@gmail.com
Signed-off-by: Javier Martinez Canillas <javierm@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/solomon/ssd130x.c | 9 +++------
 1 file changed, 3 insertions(+), 6 deletions(-)

diff --git a/drivers/gpu/drm/solomon/ssd130x.c b/drivers/gpu/drm/solomon/ssd130x.c
index 784f7000fad26..df67a1759bb3c 100644
--- a/drivers/gpu/drm/solomon/ssd130x.c
+++ b/drivers/gpu/drm/solomon/ssd130x.c
@@ -1008,7 +1008,6 @@ static int ssd130x_fb_blit_rect(struct drm_framebuffer *fb,
 	struct ssd130x_device *ssd130x = drm_to_ssd130x(fb->dev);
 	struct iosys_map dst;
 	unsigned int dst_pitch;
-	int ret = 0;
 
 	/* Align y to display page boundaries */
 	rect->y1 = round_down(rect->y1, SSD130X_PAGE_HEIGHT);
@@ -1021,7 +1020,7 @@ static int ssd130x_fb_blit_rect(struct drm_framebuffer *fb,
 
 	ssd130x_update_rect(ssd130x, rect, buf, data_array);
 
-	return ret;
+	return 0;
 }
 
 static int ssd132x_fb_blit_rect(struct drm_framebuffer *fb,
@@ -1033,7 +1032,6 @@ static int ssd132x_fb_blit_rect(struct drm_framebuffer *fb,
 	struct ssd130x_device *ssd130x = drm_to_ssd130x(fb->dev);
 	unsigned int dst_pitch;
 	struct iosys_map dst;
-	int ret = 0;
 
 	/* Align x to display segment boundaries */
 	rect->x1 = round_down(rect->x1, SSD132X_SEGMENT_WIDTH);
@@ -1047,7 +1045,7 @@ static int ssd132x_fb_blit_rect(struct drm_framebuffer *fb,
 
 	ssd132x_update_rect(ssd130x, rect, buf, data_array);
 
-	return ret;
+	return 0;
 }
 
 static int ssd133x_fb_blit_rect(struct drm_framebuffer *fb,
@@ -1059,7 +1057,6 @@ static int ssd133x_fb_blit_rect(struct drm_framebuffer *fb,
 	const struct drm_format_info *fi = drm_format_info(DRM_FORMAT_RGB332);
 	unsigned int dst_pitch;
 	struct iosys_map dst;
-	int ret = 0;
 
 	if (!fi)
 		return -EINVAL;
@@ -1071,7 +1068,7 @@ static int ssd133x_fb_blit_rect(struct drm_framebuffer *fb,
 
 	ssd133x_update_rect(ssd130x, rect, data_array, dst_pitch);
 
-	return ret;
+	return 0;
 }
 
 static int ssd130x_primary_plane_atomic_check(struct drm_plane *plane,
-- 
2.53.0



