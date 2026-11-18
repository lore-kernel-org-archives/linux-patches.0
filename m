Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795025027;
	b=pH5VVsNJYjFrTt2reljln3ytB7VREClGfebouvvXBlogluXV6Q2XpbZwQLTHs20NUAf1
	 51lXiV16EO0F2bjWeqlPPOAR+nWirXhG45yjL6v0kAVsB6n4tN3yHzCQTyMleEIloh3tk
	 PDVzSgfP7yKk6NsTujFSBzIdgFQodSHhb14GJl4dzqRM4ZQoHI/7eVr1dgTq8AnEMBt5b
	 2E5b4rtMLlLV5xX9hR7iVGBVDwT/+fpcfbzwO5S+28hMGpQvLhCF1zlebKzhLy7HLqd9C
	 i07KwSaPNkvq/+P+oShgtYfHIGlS/Wu2fy+Kh+qnM9Pg4bAN5jggiVIO9U7Nb5QQOEQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795025027;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=lHtYEEGBnxKluMacXfZpyyPjxWKB9kGkEz+GfGgnHjw=;
	b=V7iuVtvVE1glW0aACJMa+FB9/AUrnfin8lPJbwHsAQupvjpf7g8kYWHKowo+JKdKKXxH
	 pMGps8g16MBmLVQREln2/nM+etOY3oHgjwbrFkQMgz3Bfbief7tyc42RE4ybla0c/Mur2
	 j7vaSP2JwqIDUofJhh2pWxlQUBUZDXRz7DKCvXcIw4umU1etn2y+Knf03O9cfdpZ2Yb0M
	 y5ndvrN/7UylenLfc8BbVQpCbL7LxCvqDGPq7YQXlNAaAQkS5uRDVqYn0IdpNuKs35xm8
	 8DTkLi/GJT/6dtSYwNRhQG/JbZ+hDy2IWIdGyujiz7bLd9TJ+OSS5hAbI6vdAAZrGnA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="enm/uqTG";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD06A606A31C;
	Wed, 18 Nov 2026 18:03:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=enm/uqTG
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1DD141F000C4;
	Wed, 18 Nov 2026 18:03:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795025027;
	bh=lHtYEEGBnxKluMacXfZpyyPjxWKB9kGkEz+GfGgnHjw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=enm/uqTGj+ZALnhkWcb53JjALlyMbZvq8azPocV0D+LDZixw3Dg0C3BaCmyQY3IZN
	 toezdnD8hOa2aa0ajM/9jHfI1Om844MZ8fN92/BbH5i6G0HmmwgQZh0nm01MpE/6k+
	 OaejdneWQOP1mTyNN+v4cIHXQsC2BSGmxkkydEU4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thomas Zimmermann <tzimmermann@suse.de>,
	Ze Huang <ze.huang@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0919/2151] drm/imx/lcdc: avoid duplicate clk_per enable
Date: Wed, 18 Nov 2026 15:44:14 +0100
Message-ID: <20261118150155.931248760@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
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
index 8d6a0bb31c481..bdb63cc9b4362 100644
--- a/drivers/gpu/drm/imx/lcdc/imx-lcdc.c
+++ b/drivers/gpu/drm/imx/lcdc/imx-lcdc.c
@@ -310,7 +310,8 @@ static void imx_lcdc_pipe_update(struct drm_simple_display_pipe *pipe,
 	else if (old_crtc != crtc)
 		mode_changed = true;
 
-	imx_lcdc_update_hw_registers(pipe, old_state, mode_changed);
+	if (!drm_atomic_crtc_needs_modeset(crtc->state))
+		imx_lcdc_update_hw_registers(pipe, old_state, mode_changed);
 
 	if (event) {
 		crtc->state->event = NULL;
-- 
2.53.0



