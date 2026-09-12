Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 63E41288B2;
	Sat, 12 Sep 2026 10:44:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789209890; cv=none; b=u0PhzIsefhiQWTA7TpKb85qts+j1qlXvHi8Vqrceir5dHXA1D304cImSxqweyzRV2YrTCWifGgBRmY8h43Y9TKmDKXaCF1sUUmBD4Dagh4xSnHkcoDC+NZ5p6gzJ/lHnR5/sSNtOD0OJsDgRGo+FiK1Vyvwmy3e5t1MqTpVtyYs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789209890; c=relaxed/simple;
	bh=KFlL9d3hh+EjetaV/0zjINcb41lO3tFLmJIqDu2odZs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WL08DBBZ7ktNvMPyBX9973vzTAhCp3GJn5volfUokX5pUQGg/x+uVXG2DNS2UqijOsljepGmYlX2YGSj+lwKl5Ev85KoMLmFULWk2nSGu+97RCX/rweA6EjKOe1DcJ0uDr3eM/OEpj9p6NV1mH9JgEy2KgBwBXGVNvEGKMwAHA4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uYNr8Mzi; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uYNr8Mzi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F15ED1F000FF;
	Sat, 12 Sep 2026 10:44:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789209889;
	bh=4f/EqPWIuzMkJsTmba4SBz/wpkAsDOxI6fqeoCyGs4Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=uYNr8MziLvUHgNTDAwZwGPLX/0HKYXlqqSr8S/0vWTRUBfsUeUfMqv7OGnGi4fYhB
	 eZUnHKmSuGfK6mXgaXZXVbrMerbzhf6OGfTih9vhsbAKCSmP8HgtaU8y9iWa9J1pyQ
	 FXP5VwNnlLcuwhDUqc7OB+1/x6VuN+P5MHi1nK6I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jernej Skrabec <jernej.skrabec@gmail.com>,
	Chen-Yu Tsai <wens@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0912/1518] drm/sun4i: tcon: Set output mux for DSI and LVDS
Date: Sat, 12 Sep 2026 08:51:21 +0200
Message-ID: <20260912065644.085951951@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065623.398859879@linuxfoundation.org>
References: <20260912065623.398859879@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jernej Skrabec <jernej.skrabec@gmail.com>

[ Upstream commit 9c90199b39637ad94253c4fd8e7b1333ca1d3e0d ]

DSI and LVDS skip output mux setup, so TCON TOP cannot route the selected
mixer. Configure them like other channel 0 outputs.

In practice this matters for D1, where channel 0 TCONs are fed through
TCON TOP. The remaining set_mux implementations only handle TMDS and
return an error for other encoder types, as before.

Fixes: b9b52d2f4aaf ("drm/sun4i: Add support for D1 TCONs")
Signed-off-by: Jernej Skrabec <jernej.skrabec@gmail.com>
Acked-by: Chen-Yu Tsai <wens@kernel.org>
Link: https://patch.msgid.link/7e9dad9eed2e91a79c4e1202caa8fed7c2427531.1785772659.git.jernej.skrabec@gmail.com
Signed-off-by: Chen-Yu Tsai <wens@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/sun4i/sun4i_tcon.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/gpu/drm/sun4i/sun4i_tcon.c b/drivers/gpu/drm/sun4i/sun4i_tcon.c
index 960e83c8291da..ea7c90fef316b 100644
--- a/drivers/gpu/drm/sun4i/sun4i_tcon.c
+++ b/drivers/gpu/drm/sun4i/sun4i_tcon.c
@@ -717,9 +717,11 @@ void sun4i_tcon_mode_set(struct sun4i_tcon *tcon,
 	case DRM_MODE_ENCODER_DSI:
 		/* DSI is tied to special case of CPU interface */
 		sun4i_tcon0_mode_set_cpu(tcon, encoder, mode);
+		sun4i_tcon_set_mux(tcon, 0, encoder);
 		break;
 	case DRM_MODE_ENCODER_LVDS:
 		sun4i_tcon0_mode_set_lvds(tcon, encoder, mode);
+		sun4i_tcon_set_mux(tcon, 0, encoder);
 		break;
 	case DRM_MODE_ENCODER_NONE:
 		sun4i_tcon0_mode_set_rgb(tcon, encoder, mode);
-- 
2.53.0



