Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795018034;
	b=NA7pUH0oWDp+8zUEGp8rGkCJMltM91T0qJJRJv46nQZUWPlSsTenD+o/AzwetV/uNLGu
	 y1WfSQVDAHIHshwV5uCC7+EVIDdZifrUAYVE3pEiDT3yPR/CmNoHkj2KvosFYVeevFB1K
	 ygHa6QI6bZ67BuilChQwFu6TvyqAZBdgKG6spSsisG7TF/fEfwewmzjYAGjklPoSIOqtg
	 DHnhFSqdBNBwwIml4VEsRaQT6Jz4OGJSMC+laIlkt6Vd6IAxprjSRKKOAE5/ZRG5vcXYX
	 7QIzVxhB85SPdaA08I9kiHVQYGEVZvvEQScSXXGoWO+pIfnJJtaRsk8da7YKk9w6T2w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795018034;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=qtzps6d1rgMD7Ke7NuhXwrXwMWQ0F8e0vlOvr02SBDE=;
	b=2felI6gRlZUNtMNjBsmEwtmp3Dk9nIxVW+r7DfLpjFKGbPX0zJeSnnVRYudr0ZXjeavE
	 D18abK3GA2VpCb/jyZWys1D4JnJXcQqK7achyDcPyUSHQ2qqC8+zfqnRkidRlMkK9oI66
	 222UYKc+FWqOmEihjdMOiqX5d2BbUhiB8osx7i62XjWvCoXThJBgNKWK8rorqGwDq1n0M
	 P2xpJvJ8TLjKuJCLft7Fyu0XTjJ96Uktbnsr0iWskQirpNKIz6j7HbHqtR91hdJXxJYyz
	 Tx3olNLi9p8nxnIFZmhHnTX8qBtEgeI5tQNYIjRlAJRFL22eSiGgl26IMtn35ea7epA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=b011rbnL;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB38D606A320;
	Wed, 18 Nov 2026 16:07:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=b011rbnL
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 389F71F000C5;
	Wed, 18 Nov 2026 16:07:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795018034;
	bh=qtzps6d1rgMD7Ke7NuhXwrXwMWQ0F8e0vlOvr02SBDE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=b011rbnLyQ5iUig6yz9pQVtVFBJwOCsirqfl6c7hEtvWWJt4npIzSxeaMdDIO0RIX
	 NniRMkr6nMJGJHWRnSAbuKQSLOsMXWJZiIDx1N72+lSXs+J1Gf7JoR7W834RGy3lO9
	 BeA59I8wfYjy6zm1BGnpBYJahb0VxDtmsaABQRy8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thomas Zimmermann <tzimmermann@suse.de>,
	Ze Huang <ze.huang@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1098/2651] drm/imx/lcdc: avoid duplicate clk_per enable
Date: Wed, 18 Nov 2026 15:38:58 +0100
Message-ID: <20261118150327.526498913@linuxfoundation.org>
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
index c67fe80b8115e..e00e52c1c46ec 100644
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



