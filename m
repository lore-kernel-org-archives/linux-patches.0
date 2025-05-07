Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB5BC214813;
	Wed,  7 May 2025 19:12:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746645149; cv=none; b=YSJUFJNakaVBviOt4pafAftjoGGkVR/u7U4vr9fx5bcx3vMIcIypBzRXMLUPAoia4oSLKnZrtKBvxhi0JIiRCJk/5rT1/xIM///7I8rPti+Yyo2s4yv5VT5UQhQusUkBsaztGcye9X5EC8XPunr3lELsENzhpypldSwTazQkoeU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746645149; c=relaxed/simple;
	bh=aKA/92AR95tCU/XFHdnicOJ1ByKWpKx5LcER6TmpG8Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=h598bCHToR2VWS1cbuMSgSUfQVZZP2UpnsddM5MHVgKxyJjudvj89AYYrrMpaC28Z7iCHNupaSEsNkAuEDr15GG/q9xekrcIxHXpMJffI6SaAHCbnqRKYEqWWwDMav370gcvm3dxKYhiGPp7+tlGYBwGkznrfOM18/j6G15iJRk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=C3aJFfF5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="C3aJFfF5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3391DC4CEE2;
	Wed,  7 May 2025 19:12:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1746645149;
	bh=aKA/92AR95tCU/XFHdnicOJ1ByKWpKx5LcER6TmpG8Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=C3aJFfF5F9c5aRlJrJ5HOnn7zuC6vTvIJNVVuBmcH7rlWI5Wce3TFcvi9FFWFwjla
	 m0SKthHK7RIbBeP7GARCDXk8hDHVwSMWyF/VFwFxpFSqB1gfkLKzjcNIhPcOAuG1oZ
	 Rf+xesiHhMF1LO4d3c/Lq9mgZFncblNFPfNfAA/k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christian Hewitt <christianshewitt@gmail.com>,
	Martin Blumenstingl <martin.blumenstingl@googlemail.com>,
	Neil Armstrong <neil.armstrong@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 109/129] Revert "drm/meson: vclk: fix calculation of 59.94 fractional rates"
Date: Wed,  7 May 2025 20:40:45 +0200
Message-ID: <20250507183817.910132993@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250507183813.500572371@linuxfoundation.org>
References: <20250507183813.500572371@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Christian Hewitt <christianshewitt@gmail.com>

[ Upstream commit f37bb5486ea536c1d61df89feeaeff3f84f0b560 ]

This reverts commit bfbc68e.

The patch does permit the offending YUV420 @ 59.94 phy_freq and
vclk_freq mode to match in calculations. It also results in all
fractional rates being unavailable for use. This was unintended
and requires the patch to be reverted.

Fixes: bfbc68e4d869 ("drm/meson: vclk: fix calculation of 59.94 fractional rates")
Cc: stable@vger.kernel.org
Signed-off-by: Christian Hewitt <christianshewitt@gmail.com>
Signed-off-by: Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Reviewed-by: Neil Armstrong <neil.armstrong@linaro.org>
Link: https://lore.kernel.org/r/20250421201300.778955-2-martin.blumenstingl@googlemail.com
Signed-off-by: Neil Armstrong <neil.armstrong@linaro.org>
Link: https://lore.kernel.org/r/20250421201300.778955-2-martin.blumenstingl@googlemail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/meson/meson_vclk.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/gpu/drm/meson/meson_vclk.c b/drivers/gpu/drm/meson/meson_vclk.c
index 2a942dc6a6dc2..2a82119eb58ed 100644
--- a/drivers/gpu/drm/meson/meson_vclk.c
+++ b/drivers/gpu/drm/meson/meson_vclk.c
@@ -790,13 +790,13 @@ meson_vclk_vic_supported_freq(struct meson_drm *priv, unsigned int phy_freq,
 				 FREQ_1000_1001(params[i].pixel_freq));
 		DRM_DEBUG_DRIVER("i = %d phy_freq = %d alt = %d\n",
 				 i, params[i].phy_freq,
-				 FREQ_1000_1001(params[i].phy_freq/1000)*1000);
+				 FREQ_1000_1001(params[i].phy_freq/10)*10);
 		/* Match strict frequency */
 		if (phy_freq == params[i].phy_freq &&
 		    vclk_freq == params[i].vclk_freq)
 			return MODE_OK;
 		/* Match 1000/1001 variant */
-		if (phy_freq == (FREQ_1000_1001(params[i].phy_freq/1000)*1000) &&
+		if (phy_freq == (FREQ_1000_1001(params[i].phy_freq/10)*10) &&
 		    vclk_freq == FREQ_1000_1001(params[i].vclk_freq))
 			return MODE_OK;
 	}
@@ -1070,7 +1070,7 @@ void meson_vclk_setup(struct meson_drm *priv, unsigned int target,
 
 	for (freq = 0 ; params[freq].pixel_freq ; ++freq) {
 		if ((phy_freq == params[freq].phy_freq ||
-		     phy_freq == FREQ_1000_1001(params[freq].phy_freq/1000)*1000) &&
+		     phy_freq == FREQ_1000_1001(params[freq].phy_freq/10)*10) &&
 		    (vclk_freq == params[freq].vclk_freq ||
 		     vclk_freq == FREQ_1000_1001(params[freq].vclk_freq))) {
 			if (vclk_freq != params[freq].vclk_freq)
-- 
2.39.5



