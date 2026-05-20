Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ACBF63EE1FD;
	Wed, 20 May 2026 17:07:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779296857; cv=none; b=gaYhdGe0US3tLuEYP3gGzsyOq1lE5Q2C/MAB3cvTW1Ckd7tc61BCzRGNwtbwPAqNMB5Txp9jEQIhEkohvSCW6yjp9DPn6TvM9a1cs8QRWwwUIftQ3yb2bLIuIox5XpsY7hIIxgS08g9rx6XYOXZV2giHQCLxFJbg5mLne8Z0Ndw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779296857; c=relaxed/simple;
	bh=w12xz5OLbkKX0UbO31SyDhWTemcPFLnWwyiig0vlHBg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oTBWOrGfWMBzkpG/oudDka7+Js/Bwe0z5ukCuxqKbAjh7d/2jIHX6kmePQ+eOxx87qF4S67MixtkqHkPqXJZwsGFGrMqXFRbV2SLSgkbEC+wYa+GHyJ5ZphLfJvKeIWJs2ldxtzKdPJ/27O2eI7/NelCuT2A+MmhsevaqkQzsig=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=B/pk979w; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="B/pk979w"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1651D1F000E9;
	Wed, 20 May 2026 17:07:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779296856;
	bh=lZF2eZLHuQWsAFy3csHM8Gk741qwfRIbdoG/uDY8wg4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=B/pk979wRKVTw7vxxb+PryFblF4/Oi3efDnPRS213Ks0KDWmFSATlQs1LvG/d1GfJ
	 1J63GIEs+rUdCGx7ouj9zWUAbxAkcnwLf2Hi9ybjOo6wMiS2xZKJ1HEsVQpbZeMtpp
	 KZiSSoAaRMvmJ9sXP49EY/IMc6EXbb/PotsZy6Tg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Geert Uytterhoeven <geert+renesas@glider.be>,
	Javier Martinez Canillas <javierm@redhat.com>,
	Thomas Zimmermann <tzimmermann@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 0917/1146] drm/color-mgmt: Typo s/R332/RGB332/
Date: Wed, 20 May 2026 18:19:27 +0200
Message-ID: <20260520162208.993784561@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162148.390695140@linuxfoundation.org>
References: <20260520162148.390695140@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Geert Uytterhoeven <geert+renesas@glider.be>

[ Upstream commit 9d5a2b8f6281f6090002517fb9272ea07038afe8 ]

Fix a typo of "RGB332" in kerneldoc for the drm_crtc_fill_palette_332()
helper.

Fixes: 7ff61177b7116825 ("drm/color-mgmt: Prepare for RGB332 palettes")
Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
Reviewed-by: Javier Martinez Canillas <javierm@redhat.com>
Reviewed-by: Thomas Zimmermann <tzimmermann@suse.de>
Signed-off-by: Thomas Zimmermann <tzimmermann@suse.de>
Link: https://patch.msgid.link/c413e45c8f752a532a4ff377f7a8b9eaab4a082a.1776757681.git.geert+renesas@glider.be
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/drm_color_mgmt.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/drm_color_mgmt.c b/drivers/gpu/drm/drm_color_mgmt.c
index c598b99673fc1..e7db4e4ea700f 100644
--- a/drivers/gpu/drm/drm_color_mgmt.c
+++ b/drivers/gpu/drm/drm_color_mgmt.c
@@ -831,7 +831,7 @@ static void fill_palette_332(struct drm_crtc *crtc, u16 r, u16 g, u16 b,
 }
 
 /**
- * drm_crtc_fill_palette_332 - Programs a default palette for R332-like formats
+ * drm_crtc_fill_palette_332 - Programs a default palette for RGB332-like formats
  * @crtc: The displaying CRTC
  * @set_palette: Callback for programming the hardware gamma LUT
  *
-- 
2.53.0



