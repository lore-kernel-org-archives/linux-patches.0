Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795015127;
	b=DF2CD6NlUGqc7sWlfk0OHD4wyxwqHa+u7G5mYDHZrxcZrZDF5HAv0DPGiarrxFlbKGIB
	 P2FoIKDd7xwLjUK/GeNEvDarhDAbN52cWl+x4WLv1Wpz/02FEMi2fu+VPj/wWGNTMeVr5
	 dnttfCi3K7VaMM9RtiHPqUdjFkQf15gLGCk0dPQD2gOws5Nsn/QGLLrotof/0IvdN0NkW
	 nmOIQEnHlPBMASV/HMjefYqbUgS+xjEsRfcb4vy29V9IUjhdhnYovQ5f/EeW6IuflXSmb
	 VdLAmVshZW+1r6WJ4v9IpuFMHHUltAW9Ckykedlr0jXQp/7pc2D773ml5XTt9NeZe+A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795015127;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=2+kKrQL7BzXokAJ+ZiK20qBEeFAHDnvX+0pj0rmnhhg=;
	b=Nlxl9W+RgyW2+WfLABMCBxr58X6GOBTjTXwdOzEamFQmH8jldjxWMWDX6dXpLm/YWzZI
	 aAYDDsf14zrBtGT0BBegHroHyF5xUah7Qc9pXIBlHhs/NbcvMRXuLIKwbPOw6krPntKzb
	 KYpBVETU6SiKyUN1nc5nwF16Ekw6z5N3hXHjPPfJkA8FBRxCUGIiGzCqEQ85KMT7QnaH2
	 PMG0nlHlteEMjt8RdEH7p9BqJE2zQgx7iK8NXhJuYMwKNjaiiPDLH8v0da6MOHLraupG3
	 zNnj/lQ4/vf4in9SR1RpXRME4frimQpUuApDWd+impUOt8Gw95K8EJajlYRwO5X0cfw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=zJ4ifCbV;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 285BB60A2607;
	Wed, 18 Nov 2026 15:18:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=zJ4ifCbV
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7CB551F000C5;
	Wed, 18 Nov 2026 15:18:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795015127;
	bh=2+kKrQL7BzXokAJ+ZiK20qBEeFAHDnvX+0pj0rmnhhg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=zJ4ifCbVpUYMAEWH0Y/pgZAcJnE5By69f4TGbSrXod0DAdSqBxSDhJU+rsW1aVjFs
	 2/Od7Lx4csn3ARNHliZ+kS79Tl7JW57TIzvmLwKufREMiJ+FqALzx3UYVXivob2hdn
	 4+w6Oyj5al4T45y+2+x6nS2AmGtuUAux6jKKNpxY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Icenowy Zheng <zhengxingda@iscas.ac.cn>,
	Chen-Yu Tsai <wenst@chromium.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0061/2651] drm: verisilicon: fix cursor offset field update
Date: Wed, 18 Nov 2026 15:21:41 +0100
Message-ID: <20261118150250.138449955@linuxfoundation.org>
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

From: Icenowy Zheng <zhengxingda@iscas.ac.cn>

[ Upstream commit 6575bb5d0d3c7db0d7d293428ecc07cb38e46ecc ]

The 4th argument of regmap_update_bits() expects a pre-shifted register
value instead of the field value when it's used to set a single field,
however I forgot this when writing the code setting the cursor X/Y
offset fields, thus the write operation doesn't happen at all (because
of the non-shifted values being masked by regmap_update_bits()).

Fix this problem so the cursor is correctly clipped.

The framebuffer address is also clipped so the cursor offset problem was
previously not discovered, and the framebuffer address deserves another
fix for proper cursor behavior when it's clipped.

Fixes: 8c4ae2189125 ("drm: verisilicon: add support for cursor planes")
Signed-off-by: Icenowy Zheng <zhengxingda@iscas.ac.cn>
Reviewed-by: Chen-Yu Tsai <wenst@chromium.org>
Link: https://patch.msgid.link/20260812154829.671777-1-zhengxingda@iscas.ac.cn
Signed-off-by: Chen-Yu Tsai <wenst@chromium.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/verisilicon/vs_cursor_plane.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/verisilicon/vs_cursor_plane.c b/drivers/gpu/drm/verisilicon/vs_cursor_plane.c
index da456dced88aa..472d5d70b5cc9 100644
--- a/drivers/gpu/drm/verisilicon/vs_cursor_plane.c
+++ b/drivers/gpu/drm/verisilicon/vs_cursor_plane.c
@@ -200,7 +200,7 @@ static void vs_cursor_plane_atomic_update(struct drm_plane *plane,
 	} else {
 		regmap_update_bits(dc->regs, VSDC_CURSOR_CONFIG(output),
 				   VSDC_CURSOR_CONFIG_X_OFF_MASK,
-				   -state->crtc_x);
+				   VSDC_CURSOR_CONFIG_X_OFF(-state->crtc_x));
 		regmap_update_bits(dc->regs, VSDC_CURSOR_LOCATION(output),
 				   VSDC_CURSOR_LOCATION_X_MASK, 0);
 	}
@@ -214,7 +214,7 @@ static void vs_cursor_plane_atomic_update(struct drm_plane *plane,
 	} else {
 		regmap_update_bits(dc->regs, VSDC_CURSOR_CONFIG(output),
 				   VSDC_CURSOR_CONFIG_Y_OFF_MASK,
-				   -state->crtc_y);
+				   VSDC_CURSOR_CONFIG_Y_OFF(-state->crtc_y));
 		regmap_update_bits(dc->regs, VSDC_CURSOR_LOCATION(output),
 				   VSDC_CURSOR_LOCATION_Y_MASK, 0);
 	}
-- 
2.53.0



