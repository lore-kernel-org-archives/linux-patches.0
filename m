Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD0AD385CA8;
	Tue, 16 Dec 2025 12:36:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765888610; cv=none; b=i9KJ+v+fUHRG48xpM3aSoKdygv+MNpp4MwT26ODh4cAVY2XucF9f/xvJZh4nu49UFUHwHuVxWxOOkMm4/ZIEDnQ/ni4sI9nPqBhCaY4+90PGgikGlCGFD90bZ2wG0IB4yNwWGYdn2s5MxK1a1ieQhJrHullPtez4jFx+A9TepIU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765888610; c=relaxed/simple;
	bh=cxZEkkggVa8hfLK4DjzNP0hbIZKfqdo1eA9uBBZtml4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=nWY3hAb1wB0Qtc1Y0FkRuq9BYEh6eVgVO3BIvMWZFeSDW6vCibhL+5t4ObUlElSz00YovYJyy4ruJzwOSx5rZgSnIgb+ZppOIn347CE3i/JcYwcfDGTO+YrzetTIessRjOJpIT14NtWJezzVqEFpq7IA5nDOvvjO3TMq+XKWilI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OnjvcuL5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OnjvcuL5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 35DEEC4CEF1;
	Tue, 16 Dec 2025 12:36:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765888610;
	bh=cxZEkkggVa8hfLK4DjzNP0hbIZKfqdo1eA9uBBZtml4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OnjvcuL5ihxxP2L+4mxP/LttsEo3Ro51HT0Y3+8FOGmu8qxX8dCRL+mVVR6IQCMNN
	 imxzQ3SpHB1us/C1xwMdtJ2hvkvxIUcLuuOROaQyMbIvaN9xvqW2PZm2ikhWWxEoIk
	 dtzRn/CE93AnScQ3hsNiA7mkhJQTufXuqKhiXcZ0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Ville=20Syrj=C3=A4l=C3=A4?= <ville.syrjala@linux.intel.com>,
	Jani Nikula <jani.nikula@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 585/614] drm/xe/fbdev: use the same 64-byte stride alignment as i915
Date: Tue, 16 Dec 2025 12:15:52 +0100
Message-ID: <20251216111422.586788472@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251216111401.280873349@linuxfoundation.org>
References: <20251216111401.280873349@linuxfoundation.org>
User-Agent: quilt/0.69
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jani Nikula <jani.nikula@intel.com>

[ Upstream commit 4a36b339a14ae6f2a366125e3d64f0c165193293 ]

For reasons unknown, xe uses XE_PAGE_SIZE alignment for
stride. Presumably it's just a confusion between stride alignment and bo
allocation size alignment. Switch to 64 byte alignment to, uh, align
with i915.

This will also be helpful in deduplicating and unifying the xe and i915
framebuffer allocation.

Link: https://lore.kernel.org/r/aLqsC87Ol_zCXOkN@intel.com
Suggested-by: Ville Syrjälä <ville.syrjala@linux.intel.com>
Reviewed-by: Ville Syrjälä <ville.syrjala@linux.intel.com>
Link: https://lore.kernel.org/r/7f4972104de8b179d5724ae83892ee294d3f3fd3.1758184771.git.jani.nikula@intel.com
Signed-off-by: Jani Nikula <jani.nikula@intel.com>
Stable-dep-of: 460b31720369 ("drm/i915/fbdev: Hold runtime PM ref during fbdev BO creation")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/xe/display/intel_fbdev_fb.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/xe/display/intel_fbdev_fb.c b/drivers/gpu/drm/xe/display/intel_fbdev_fb.c
index 8ea9a472113c4..bce4cb16f6820 100644
--- a/drivers/gpu/drm/xe/display/intel_fbdev_fb.c
+++ b/drivers/gpu/drm/xe/display/intel_fbdev_fb.c
@@ -33,7 +33,7 @@ struct intel_framebuffer *intel_fbdev_fb_alloc(struct drm_fb_helper *helper,
 	mode_cmd.height = sizes->surface_height;
 
 	mode_cmd.pitches[0] = ALIGN(mode_cmd.width *
-				    DIV_ROUND_UP(sizes->surface_bpp, 8), XE_PAGE_SIZE);
+				    DIV_ROUND_UP(sizes->surface_bpp, 8), 64);
 	mode_cmd.pixel_format = drm_mode_legacy_fb_format(sizes->surface_bpp,
 							  sizes->surface_depth);
 
-- 
2.51.0



