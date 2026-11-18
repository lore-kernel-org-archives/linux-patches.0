Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795016402;
	b=vf4+oN623Uo6MPoY91c+QWrlrEuw9rEE51ijUesdlXEh/TYtJl9OHJ8SC1HR0Ifd6pYd
	 IOFjCZVGsqneyGVJ0mfwsEk2XEqBWlhTe00UjiNzINlNx01Op/afEd5tWHhRaEakaLsyI
	 +sHTpPN7+Bwim/TR8qSO9LZ17ut+qYxRmeqUyaqOGpC7p6yUSjfyHvBHQhFBbV8yjflUT
	 FJnsjjF56XBJUUz7BVqX4RSNEb09TRGcujkG7FV6gJww+bmkz1QmzidT+FWbqoET2UwZz
	 m5LB1nvt2EU++X05own9IU6VcZ7m85NXLFb3xSyD5Lhdbr6GbbmG/N+OJYmGNBfo40w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795016402;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=5+bPLB6yC/QPM5jlJ1lDksTUELAuIb9DS1bBochMruo=;
	b=LYqOufdTuu9f/ict5vH1x8BvnTdfAzBxnTP8Kej26HqKcs6cfqBGcjWGla5BsvO5O6B3
	 70trD+cZ9+I8XVqcWIz+U+qXub5WP8v1gNQH3V2bwXlQ/3gS2IrNpyXO77qmbs88VlV2l
	 YCl9s0a8bqqJ4znUVvp+8DTaFdWrd+y+zjtsWwDj7FispQC1JndvPJkwusbz2LrtbQzxg
	 5sEWTFAWD6Ao4V/yDOcLOoZDqjTAN3x5qsXjLwtAHA6ld3zjMKOgu3jozdmUCd2VORl3r
	 uE/d+Su37r61H/fF8bheMPyeg2drsTTT4Ugo0rNN5F5ZNojAjgIIlAUI+50RP12cueg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=WUro5Gmy;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E58060A260A;
	Wed, 18 Nov 2026 15:40:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=WUro5Gmy
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 59B7C1F000C4;
	Wed, 18 Nov 2026 15:40:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795016401;
	bh=5+bPLB6yC/QPM5jlJ1lDksTUELAuIb9DS1bBochMruo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=WUro5GmyAW7FqnQEhR/bCtncWe/X3xviRqwnLphPNHyhQgMI5sqnqZAUQLreT205G
	 BUa1mtphGkYWVBO7jLrpDkD3Ih4RfLjJJdPjuAtdezwopYx2sCIrocZjb4ROMW+Qk0
	 9iXn5MriBsK1vPseohyshmsro7YcjVDQy2tqVxHY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thomas Zimmermann <tzimmermann@suse.de>,
	Maxime Ripard <mripard@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0475/2651] drm/atmel-hlcdc: Drop spurious csc_init call from reset
Date: Wed, 18 Nov 2026 15:28:35 +0100
Message-ID: <20261118150304.888757588@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Maxime Ripard <mripard@kernel.org>

[ Upstream commit 4699bb3b1dbd8ccd25cd678acb4ca12da7bd45dd ]

The lcdc_csc_init callback was introduced in commit aa71584b323a ("drm:
atmel-hlcdc: add driver ops to differentiate HLCDC and XLCDC IP") and
called only once, at init time, from atmel_hlcdc_plane_init_properties().

commit 81af99cbd9e4 ("drm/atmel-hlcdc: destroy properly the plane state
in the reset callback") then reworked the reset hook to use
atmel_hlcdc_plane_atomic_destroy_state() instead of duplicating the
code. However, it also introduced a new call to lcdc_csc_init in the
reset path that wasn't there before and wasn't mentioned in the commit
log.

Since CSC coefficients are hardware constants that only need to be
written once at init time. This also prevents the conversion to
atomic_create_state, which must not have any hardware side-effect.

Fixes: 81af99cbd9e4 ("drm/atmel-hlcdc: destroy properly the plane state in the reset callback")
Acked-by: Thomas Zimmermann <tzimmermann@suse.de>
Link: https://patch.msgid.link/20260908-drm-no-more-plane-reset-v4-28-a31b3fcfc989@kernel.org
Signed-off-by: Maxime Ripard <mripard@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/atmel-hlcdc/atmel_hlcdc_plane.c | 5 -----
 1 file changed, 5 deletions(-)

diff --git a/drivers/gpu/drm/atmel-hlcdc/atmel_hlcdc_plane.c b/drivers/gpu/drm/atmel-hlcdc/atmel_hlcdc_plane.c
index f17a832351e9d..70a1cef24388f 100644
--- a/drivers/gpu/drm/atmel-hlcdc/atmel_hlcdc_plane.c
+++ b/drivers/gpu/drm/atmel-hlcdc/atmel_hlcdc_plane.c
@@ -1186,8 +1186,6 @@ static void atmel_hlcdc_plane_atomic_destroy_state(struct drm_plane *p,
 static void atmel_hlcdc_plane_reset(struct drm_plane *p)
 {
 	struct atmel_hlcdc_plane_state *state;
-	struct atmel_hlcdc_dc *dc = p->dev->dev_private;
-	struct atmel_hlcdc_plane *plane = drm_plane_to_atmel_hlcdc_plane(p);
 
 	if (p->state) {
 		atmel_hlcdc_plane_atomic_destroy_state(p, p->state);
@@ -1204,9 +1202,6 @@ static void atmel_hlcdc_plane_reset(struct drm_plane *p)
 		}
 		__drm_atomic_helper_plane_reset(p, &state->base);
 	}
-
-	if (plane->layer.desc->layout.csc)
-		dc->desc->ops->lcdc_csc_init(plane, plane->layer.desc);
 }
 
 static const struct drm_plane_funcs layer_plane_funcs = {
-- 
2.53.0



