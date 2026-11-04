Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793829563;
	b=BNXkUgW6cTcv7Rs9edfg/mDA+jchP67yDZhJYtJRuzl8Sk7OFIYkoOm68xqHDvrEZN/C
	 YfOJGcznnQCKEKmECSP2wkTQsO5qgqtneP6q5Oa+tvGFcrvcZT4qHXf9YYYBKrAEuloMc
	 979KFTTYljPKw6adugGpsPEJ74lqoA/CEqPIIWAzLlsdTi8hK94zAtquzq7XxtN+7O7/2
	 z2flCJBeI9d/0GRC+vQwXzI5jf3MAhFTHcNare9uIRE2VF2Xt/gzmwENuCeyYFh0Zplne
	 IGs9OEwCS1sY0ipjEy0r3T5lA8elgoQVvAW8rU5UEhuuoBf9PniqY8VIzFvlxKSKEuw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793829563;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=CmYS/qdqQwyKajKofigjMWYHWiDh0i/LJ/Uxe4vimO0=;
	b=rGPTfuWola9F/NaUx+SsZjx8RHAZAEHZnk6UZOF2TRvTgD+3mxoeAIUuw4Ln4phSkTqA
	 Azyx2teBKGRM1Hics6jFKJxosusx+X/7xD0j4FYIXl8jxP4GcS4sVPj/P/JafjcJ7S2pN
	 53E274SKAh446WtrKkK8vfdzJq9ih0ejAqztOTtxja/+X/ttDX2Z2hrejl/Al5O2rw8dg
	 ZSY3/44Mvqo9+scxEpGKYXsz+fBSH5NDg9Rdjq7gdx1uaw7zI1MQ6esAii/XjWKprPHDk
	 aUi5O6RpLXCyhDOQeIzTUfeC7ueZCtPSLaaWkstZ8ZLbC25tkVub1WI8ozrbUe+Ld9A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="c/IwjwIw";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 00719606A33E;
	Wed,  4 Nov 2026 21:59:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=c/IwjwIw
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 742291F0093A;
	Wed,  4 Nov 2026 21:59:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793829562;
	bh=CmYS/qdqQwyKajKofigjMWYHWiDh0i/LJ/Uxe4vimO0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=c/IwjwIwK7ADaxrYCigpatE5QkUIJrTvBqi9NOcUdwo6lh1OjP9n6MgoLTxCXyJqB
	 wWNWL6/g5iMf+ukGFeOkGcHdqtWCZ4J0fd4ngB4BgnXhEr/7I9fOffrA9rbBXiJS8a
	 UA1Sfx3yKJQzbAkULLkicvYHfybYUhXzAS6kU3k8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dio Zhang <dioyc_zhang@compal.corp-partner.google.com>,
	Douglas Anderson <dianders@chromium.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0204/1005] drm/panel: panel-edp: Adjust T8 timing for AUO B116XAK01.6 and B140XTK02.4
Date: Wed,  4 Nov 2026 15:58:57 -0500
Message-ID: <20261104211049.512130364@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261104211043.516122098@linuxfoundation.org>
References: <20261104211043.516122098@linuxfoundation.org>
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

From: Dio Zhang <dioyc_zhang@compal.corp-partner.google.com>

[ Upstream commit 0d40cab39158704e372240ed9821a00bfe117125 ]

Screen garbage or flickering can be observed during mode changes (such
as VT switches) on systems using the AUO B116XAK01.6 and B140XTK02.4
panels.

This occurs because the backlight is enabled before the video signal
stabilizes. Waveform measurements show that the panel signal takes
around 140ms to stabilize after a mode change, meaning the previous 50ms T8
timing was insufficient.

To resolve this issue, adjust the eDP panel delay entry from
delay_200_500_e50 to delay_200_500_e200 (increasing T8 from 50ms to 200ms).
This matches the updated panel specifications from AUO, which now formally
define T8 as 200ms to mask any display abnormalities during mode changes.

Signed-off-by: Dio Zhang <dioyc_zhang@compal.corp-partner.google.com>
Reviewed-by: Douglas Anderson <dianders@chromium.org>
Signed-off-by: Douglas Anderson <dianders@chromium.org>
Link: https://patch.msgid.link/20260720025358.2781136-1-dioyc_zhang@compal.corp-partner.google.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/panel/panel-edp.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/panel/panel-edp.c b/drivers/gpu/drm/panel/panel-edp.c
index 0da04d75e4e96..614c63e95c357 100644
--- a/drivers/gpu/drm/panel/panel-edp.c
+++ b/drivers/gpu/drm/panel/panel-edp.c
@@ -1901,7 +1901,7 @@ static const struct edp_panel_entry edp_panels[] = {
 	EDP_PANEL_ENTRY('A', 'U', 'O', 0x145c, &delay_200_500_e50, "B116XAB01.4"),
 	EDP_PANEL_ENTRY('A', 'U', 'O', 0x1999, &delay_200_500_e50, "Unknown"),
 	EDP_PANEL_ENTRY('A', 'U', 'O', 0x1e9b, &delay_200_500_e50, "B133UAN02.1"),
-	EDP_PANEL_ENTRY('A', 'U', 'O', 0x1ea5, &delay_200_500_e50, "B116XAK01.6"),
+	EDP_PANEL_ENTRY('A', 'U', 'O', 0x1ea5, &delay_200_500_e200, "B116XAK01.6"),
 	EDP_PANEL_ENTRY('A', 'U', 'O', 0x203d, &delay_200_500_e50, "B140HTN02.0"),
 	EDP_PANEL_ENTRY('A', 'U', 'O', 0x208d, &delay_200_500_e50, "B140HTN02.1"),
 	EDP_PANEL_ENTRY('A', 'U', 'O', 0x235c, &delay_200_500_e50, "B116XTN02.3"),
@@ -1921,7 +1921,7 @@ static const struct edp_panel_entry edp_panels[] = {
 	EDP_PANEL_ENTRY('A', 'U', 'O', 0x635c, &delay_200_500_e50, "B116XAN06.3"),
 	EDP_PANEL_ENTRY('A', 'U', 'O', 0x639c, &delay_200_500_e50, "B140HAK02.7"),
 	EDP_PANEL_ENTRY('A', 'U', 'O', 0x643d, &delay_200_500_e50, "B140HAN06.4"),
-	EDP_PANEL_ENTRY('A', 'U', 'O', 0x67a8, &delay_200_500_e50, "B140XTK02.4"),
+	EDP_PANEL_ENTRY('A', 'U', 'O', 0x67a8, &delay_200_500_e200, "B140XTK02.4"),
 	EDP_PANEL_ENTRY('A', 'U', 'O', 0x723c, &delay_200_500_e50, "B140XTN07.2"),
 	EDP_PANEL_ENTRY('A', 'U', 'O', 0x73aa, &delay_200_500_e50, "B116XTN02.3"),
 	EDP_PANEL_ENTRY('A', 'U', 'O', 0x8594, &delay_200_500_e50, "B133UAN01.0"),
-- 
2.53.0



