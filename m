Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 15B791E04B2;
	Tue,  8 Oct 2024 13:23:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728393818; cv=none; b=Ng18htr/XwuUfUtZy6dt9zRuAzGkRNgup/obsoUAORk9AvylQlho9MYS1nU9XcE46N4rkqoNCz1lbAPFKYL1banfDLTA2Y40Ks3FZATV2OVklZzu1TOs+RsBiwPpzqvqskkzbd8hoUNsSy26UEwiD/BZO4j+b0rJyVhgs+2wbOY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728393818; c=relaxed/simple;
	bh=UMrVL9HNWrPPU1dYG23VI6f9/yBNxXk9XmMftg87bJ8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=lvkR3iU/+p3/akiLwNeOtGaDGSsVdJtM6z26/1YULwoRr0dlSMnlCTAofcVJcizIZO3GoSrUd6gM1ajkad/TlFCkBxWhd4MCK0upG/ArS++MuzHcAn+yhGV3tC6t30bBYgBA802RwQmyEKMHIQEdD5jt/iWcqxAojA19eqEp73s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=G0XZSJ8K; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="G0XZSJ8K"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 41EABC4CECE;
	Tue,  8 Oct 2024 13:23:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728393817;
	bh=UMrVL9HNWrPPU1dYG23VI6f9/yBNxXk9XmMftg87bJ8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=G0XZSJ8KLIfvnRlC0LcB8To8KUplE37/bafQUBLhWf+3ljvIHnlBQUPN6HhmpO/MO
	 zG71wbgJIy3puAMd3+kH0E0RGKrTGWGSrT6GsN2qZpesZcdU/sS4tDpq34la0frh5T
	 bx5mWOtPoImGGQ66TLjQkZqG7fS+nguY748GWxAs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Ville=20Syrj=C3=A4l=C3=A4?= <ville.syrjala@linux.intel.com>,
	Thomas Zimmermann <tzimmermann@suse.de>,
	Lukasz Spintzyk <lukasz.spintzyk@displaylink.com>,
	Deepak Rawat <drawat@vmware.com>,
	Daniel Vetter <daniel.vetter@ffwll.ch>,
	Thomas Hellstrom <thellstrom@vmware.com>,
	David Airlie <airlied@gmail.com>,
	Simona Vetter <simona@ffwll.ch>,
	Maarten Lankhorst <maarten.lankhorst@linux.intel.com>,
	Maxime Ripard <mripard@kernel.org>,
	dri-devel@lists.freedesktop.org,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Subject: [PATCH 6.6 223/386] drm: Consistently use struct drm_mode_rect for FB_DAMAGE_CLIPS
Date: Tue,  8 Oct 2024 14:07:48 +0200
Message-ID: <20241008115638.180401853@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241008115629.309157387@linuxfoundation.org>
References: <20241008115629.309157387@linuxfoundation.org>
User-Agent: quilt/0.67
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Thomas Zimmermann <tzimmermann@suse.de>

commit 8b0d2f61545545ab5eef923ed6e59fc3be2385e0 upstream.

FB_DAMAGE_CLIPS is a plane property for damage handling. Its UAPI
should only use UAPI types. Hence replace struct drm_rect with
struct drm_mode_rect in drm_atomic_plane_set_property(). Both types
are identical in practice, so there's no change in behavior.

Reported-by: Ville Syrjälä <ville.syrjala@linux.intel.com>
Closes: https://lore.kernel.org/dri-devel/Zu1Ke1TuThbtz15E@intel.com/
Signed-off-by: Thomas Zimmermann <tzimmermann@suse.de>
Fixes: d3b21767821e ("drm: Add a new plane property to send damage during plane update")
Cc: Lukasz Spintzyk <lukasz.spintzyk@displaylink.com>
Cc: Deepak Rawat <drawat@vmware.com>
Cc: Daniel Vetter <daniel.vetter@ffwll.ch>
Cc: Thomas Hellstrom <thellstrom@vmware.com>
Cc: David Airlie <airlied@gmail.com>
Cc: Simona Vetter <simona@ffwll.ch>
Cc: Maarten Lankhorst <maarten.lankhorst@linux.intel.com>
Cc: Maxime Ripard <mripard@kernel.org>
Cc: Thomas Zimmermann <tzimmermann@suse.de>
Cc: dri-devel@lists.freedesktop.org
Cc: <stable@vger.kernel.org> # v5.0+
Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Link: https://patchwork.freedesktop.org/patch/msgid/20240923075841.16231-1-tzimmermann@suse.de
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/drm_atomic_uapi.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/gpu/drm/drm_atomic_uapi.c
+++ b/drivers/gpu/drm/drm_atomic_uapi.c
@@ -585,7 +585,7 @@ static int drm_atomic_plane_set_property
 					&state->fb_damage_clips,
 					val,
 					-1,
-					sizeof(struct drm_rect),
+					sizeof(struct drm_mode_rect),
 					&replaced);
 		return ret;
 	} else if (property == plane->scaling_filter_property) {


