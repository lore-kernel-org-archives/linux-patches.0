Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795030506;
	b=X9AmIVx6+9fO34pOlOGRAXYHZVmFEkApf3Nohjk/mPBCnFF5zjgqJmRGxuaS5VyRQmxP
	 VrpMjds4Pdshhj9+q7J6ci/jRdR+N21WkHgy9qiUDP4yHk8gbcUvDm8fB0NyGbj3J7fG+
	 WD6wrs6FwgH3KlMNPupGt0wx4yXhNUkCkVe+yW7rvcQqxgtioXmhTJb45EccQlexsjZWF
	 r1ofpO1M8HIqsAdHnc2qZeDL4f3ThiJrl2ieoBKFWuZ0kgFfX9Nn0urgr8Xw+18Fkwyq0
	 iJOu1nUVwHsR2rnEM2voHOGWh1YSrfWSYMbsddOULSMTl+sN7i9801bYMbHzcJbj4Gw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795030506;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=kVeCfJSHTUrmFnMNEzVi81PY70P6xZbph6eKKTS1RNc=;
	b=FdFtWfMcSQCTAUqVOCrajpAbJH/wLARlEBqRxhL8uYKyTauAx7MLMTkLNKyxXPdKLOAJ
	 Y+WYwNB6Mr41NsPKoFfFf/4S7bjZT1Yxzrh8wqIHAORH/U1p6dRvr2EzFsf9OewM1uDgN
	 xzxWa/gsvgG1dLpXB1T1zCbqrQRiJKmZqaPbh1bwwV7GmmQdPpvlM5aojsULJXYzfS3iU
	 cgeIjNLOJBVS8QhjNZZCSQk1/2BK60XS8HFo/BxI+pqhEwx3mhOFzzL7Wl/PegRAuufQN
	 kngpYA5tvWRlmRv1FFExi2ECA9plsgvUNnq820WUzDqt8dJiEBJMLpD1860VSfa8+yQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="O91XcB/R";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D816F606BB45;
	Wed, 18 Nov 2026 19:35:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=O91XcB/R
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3502D1F000C4;
	Wed, 18 Nov 2026 19:35:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795030506;
	bh=kVeCfJSHTUrmFnMNEzVi81PY70P6xZbph6eKKTS1RNc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=O91XcB/RDY0HcnNavQCeq+J5dezvT7ucLiSQMNVoYYpwKYKeFNj+NkFzDPOEFZcl4
	 Gcf5Y5SgpIJTRoLXySjicco/3zFfRtTJtxbc5qC6AAngvJ8SbqdnE0nuENLmmLlRkb
	 GNsePKULobWgewhqY2y5NTVZvceO9ctV1W8nRgpw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thomas Zimmermann <tzimmermann@suse.de>,
	Ze Huang <ze.huang@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0728/1756] drm/imx/lcdc: avoid duplicate clk_per enable
Date: Wed, 18 Nov 2026 15:47:35 +0100
Message-ID: <20261118150038.661872726@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150007.957976754@linuxfoundation.org>
References: <20261118150007.957976754@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 36668455aee8c..18954e9d6c087 100644
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



