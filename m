Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E212385CBC;
	Tue, 16 Dec 2025 12:36:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765888614; cv=none; b=aGlmTyCk6uUnmF3xnPwOfnsr5EJwH7/RE+COiI+PrN7aO6FfOhTwj5HKM+TG7Vz1MpxUKdT3Yws+o7nHqFRJlOm3NmoZMwu8PL+/JCPHBuhdQ8b7ccXhilMYTyppfXoSu+ZGIJr6vFCpmJvbivAjHGK1+ExIdH+bJavz8jSMLHg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765888614; c=relaxed/simple;
	bh=lfzHRYeTkih1oY4ercS0dNUpWUGXlOjfu1RlI8qQ3Xo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=pdOz/B8JVGlLN+DLXDKEXhMgWxAN/5oEH78BUCEzSDoQ+MFO46M8Ob1Dx1QDKKXxzxWK0k1Q2OinEHA2y8H/d+nmtXPQq8nfxODCYKVQP3vQfW4isVpMiI2axdU2jRDxy9jVDSXZy3cOUtM/QJmQj/KlczBWvG1dr4h6bA6LJyw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Vz9drJ84; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Vz9drJ84"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C2018C4CEF1;
	Tue, 16 Dec 2025 12:36:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765888614;
	bh=lfzHRYeTkih1oY4ercS0dNUpWUGXlOjfu1RlI8qQ3Xo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Vz9drJ84ue/S5NK4lci/UDeLUgIwZohwhHgv0bW0pQYPWvgT+y2oaY+vZBa26bpk6
	 1cRv1F7JxDbHbT39hH2E1Kmhn1J6qc2kMWAXWIypJFH8npsFDHzTCHF7q3KkAo2ELI
	 ic+HLjURUnsTgH/dbki9cZDs4szcJX0szgQHk/G4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Ville=20Syrj=C3=A4l=C3=A4?= <ville.syrjala@linux.intel.com>,
	Jani Nikula <jani.nikula@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 586/614] drm/i915/fbdev: make intel_framebuffer_create() error return handling explicit
Date: Tue, 16 Dec 2025 12:15:53 +0100
Message-ID: <20251216111422.623132094@linuxfoundation.org>
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

[ Upstream commit 6979d2c80c2a5b1f04157c4d6eb038bb32861cfa ]

It's sketchy to pass error pointers via to_intel_framebuffer(). It
probably works as long as struct intel_framebuffer embeds struct
drm_framebuffer at offset 0, but be explicit about it.

Reviewed-by: Ville Syrjälä <ville.syrjala@linux.intel.com>
Link: https://lore.kernel.org/r/17631db227d527d6c67f5d6b67adec1ff8dc6f8d.1758184771.git.jani.nikula@intel.com
Signed-off-by: Jani Nikula <jani.nikula@intel.com>
Stable-dep-of: 460b31720369 ("drm/i915/fbdev: Hold runtime PM ref during fbdev BO creation")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/i915/display/intel_fbdev_fb.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/gpu/drm/i915/display/intel_fbdev_fb.c b/drivers/gpu/drm/i915/display/intel_fbdev_fb.c
index 210aee9ae88b8..b9dfd00a7d05b 100644
--- a/drivers/gpu/drm/i915/display/intel_fbdev_fb.c
+++ b/drivers/gpu/drm/i915/display/intel_fbdev_fb.c
@@ -67,9 +67,16 @@ struct intel_framebuffer *intel_fbdev_fb_alloc(struct drm_fb_helper *helper,
 							  mode_cmd.pixel_format,
 							  mode_cmd.modifier[0]),
 				      &mode_cmd);
+	if (IS_ERR(fb)) {
+		i915_gem_object_put(obj);
+		goto err;
+	}
+
 	i915_gem_object_put(obj);
 
 	return to_intel_framebuffer(fb);
+err:
+	return ERR_CAST(fb);
 }
 
 int intel_fbdev_fb_fill_info(struct intel_display *display, struct fb_info *info,
-- 
2.51.0



