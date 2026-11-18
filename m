Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795040530;
	b=xnlhPrBm32FZkvbH0fYyvBtiH3bT4Ht4ARk4nCNyne9DKQGJpKFqcXh6eS9feGW2oFbi
	 YtvThRi4C/ZvJ/eyPIFnbVIpgzP3hZlTZOyhO6rZfwwDKb0TAaEaXDxkgyty8do+8sN02
	 tHlkfXalKmpN2lc4JTiObM1swrOMwy5hqcnvLg6vv2bcolX0Q3oEiSkvpMjQSgkaag1Mh
	 aQcbmGGikgYUBiM0WQ+ez3LpF8JpkVDq3Jspcz3IWI7ph7inlR3+goWYENpofUx4ub/W2
	 SE6zeAp5s1kn3ZhNU3ch3KVBssMChXmQhIM3ttL9atyCafNG+IFjsduXFUbj3TJFXjw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795040530;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=2XAiOn7bMgjWUVe9pYeT0Swfj3X8tV4+AfWHTzqR234=;
	b=KG71TFnD0Ezj8LiuO0sW9YNYvFauGdjHhFwGbc/4VAvqPOxxmizzDn1z5wl9bCjqzMk5
	 DZW7HqYjIdzf7aWZB4NFJ3v82fpf5SAcGt+eiFKdF08jLilNZBl2a8qOJdpLmM1eUGL7K
	 5BA2Tm+PItQZQvw92dUYdouAbsGVyFh9dSvDzJh6SCEWLiB8+OQGuv5zbTNBsxC0QHHpW
	 b2axuDTD6MkDdNvILH9kB8qBcOHqyzBxtlHIegydjhhwjw8sSSURXR7XqBljWDyO2AoAG
	 iX4ldWL14mc1LHYSnB52QMz83Y4P6OVRA8/Q5XRcyHcq34DehEX34JNJxjTo5mp5jUg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="iZIM/reV";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2EFCE606A325;
	Wed, 18 Nov 2026 22:22:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=iZIM/reV
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 894351F000C4;
	Wed, 18 Nov 2026 22:22:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795040530;
	bh=2XAiOn7bMgjWUVe9pYeT0Swfj3X8tV4+AfWHTzqR234=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=iZIM/reVjj/v0dMjJBJdbBsM3l591ccncj6yHZGkfYROZWr8OpvDr4xuNLKpVczi6
	 gYy/D1kpeanHAUcKR4uX2GfCeCLqdTa088MdPI8OfKA9Sg12xj50Y7zlWf8i1QlAbU
	 ihQ5/TUmi++OBoMX/dvP5vBiE54Dh+HH9hpeprwU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thomas Zimmermann <tzimmermann@suse.de>,
	Ze Huang <ze.huang@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 2488/3318] drm/imx/lcdc: avoid duplicate clk_per enable
Date: Wed, 18 Nov 2026 15:51:50 +0100
Message-ID: <20261118150436.035025037@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ze Huang <ze.huang@oss.qualcomm.com>

[ Upstream commit b08f4d9b21a7846b91bb6c4064f58c3a7ab997c7 ]

The simple-KMS helper calls the pipe update after enabling the CRTC.
On an enable commit, imx_lcdc_pipe_enable() already programs the
mode and enables clk_per. The following pipe update sees the plane move
from no CRTC to the active CRTC, treats it as a mode update, and calls
imx_lcdc_update_hw_registers() again.

That second call has no old CRTC state to disable clk_per first, but it
enables clk_per again at the end. The disable path only drops one
reference, leaving clk_per enabled after each on/off cycle.

Skip the register update from the pipe update path when the CRTC already
needs a modeset. The enable path has already programmed the hardware for
that commit; keep the event handling in pipe update unchanged.

Fixes: c87e859cdeb5 ("drm/imx/lcdc: Implement DRM driver for imx25")
Acked-by: Thomas Zimmermann <tzimmermann@suse.de>
Signed-off-by: Ze Huang <ze.huang@oss.qualcomm.com>
Signed-off-by: Thomas Zimmermann <tzimmermann@suse.de>
Link: https://patch.msgid.link/20260919-b4-imx-simple-kms-v4-v4-1-53b1fdf4589e@oss.qualcomm.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/imx/lcdc/imx-lcdc.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/imx/lcdc/imx-lcdc.c b/drivers/gpu/drm/imx/lcdc/imx-lcdc.c
index 4beb3b4bd6942..809bf188012df 100644
--- a/drivers/gpu/drm/imx/lcdc/imx-lcdc.c
+++ b/drivers/gpu/drm/imx/lcdc/imx-lcdc.c
@@ -309,7 +309,8 @@ static void imx_lcdc_pipe_update(struct drm_simple_display_pipe *pipe,
 	else if (old_crtc != crtc)
 		mode_changed = true;
 
-	imx_lcdc_update_hw_registers(pipe, old_state, mode_changed);
+	if (!drm_atomic_crtc_needs_modeset(crtc->state))
+		imx_lcdc_update_hw_registers(pipe, old_state, mode_changed);
 
 	if (event) {
 		crtc->state->event = NULL;
-- 
2.53.0



