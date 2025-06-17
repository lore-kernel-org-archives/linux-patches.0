Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E5B302ED147;
	Tue, 17 Jun 2025 16:12:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750176755; cv=none; b=CHMlYlNIdlSSPKSO+VFBhLyT10FDn1aTvPTwywFqOkIkoX9rz1QpqOdSy3prcXXOZwBOQSL2nUhcxODiQHCkzFoKCDNI4gulZYdG5V7yk/s+PjIhx8dWhe1h7MogJCXrsTHkR7ACJZVHnKBYSfNsLOC4OENiFv0l1WayBExjeM0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750176755; c=relaxed/simple;
	bh=iQH/ap1t6hI3C3hrPqoxOR0upVFeVOI4gN5+s1LgtbM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=r62BYaz0OI4DK5Mj+X6sa/PgXm4jgEkZJx+c6RMl5L4cYHvk+2W1Vgdwv9NCbUwx7w6fxPDlqPoxszuLUjH7MRPOo/HTO6HHeflPbyxvl5gkbsAgpTGxio2vfIy6aoVEtopd4CKqNCx9PD6FOZrUBpVZ2EEWRk9Ss1YsNs0akjw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bCECj/JL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bCECj/JL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 536A1C4CEE3;
	Tue, 17 Jun 2025 16:12:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750176754;
	bh=iQH/ap1t6hI3C3hrPqoxOR0upVFeVOI4gN5+s1LgtbM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bCECj/JLUt73afwjLW/3QZdF4RET/wS4PRYg4x3SyDN8MnHbzXLD6xYsfPSCKpY2M
	 nPQeWgGgmawzUkHDl5JqeAYElQZiT8vb8jP9l5S5RLKDNHypAoRyMH0NKXaK3yLfZW
	 6aO5hjz308rq91rA9wie/DJW1WwHpUJLXxgxXIVY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Martin Blumenstingl <martin.blumenstingl@googlemail.com>,
	Neil Armstrong <neil.armstrong@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 310/356] drm/meson: fix debug log statement when setting the HDMI clocks
Date: Tue, 17 Jun 2025 17:27:05 +0200
Message-ID: <20250617152350.643970097@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617152338.212798615@linuxfoundation.org>
References: <20250617152338.212798615@linuxfoundation.org>
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

From: Martin Blumenstingl <martin.blumenstingl@googlemail.com>

[ Upstream commit d17e61ab63fb7747b340d6a66bf1408cd5c6562b ]

The "phy" and "vclk" frequency labels were swapped, making it more
difficult to debug driver errors. Swap the label order to make them
match with the actual frequencies printed to correct this.

Fixes: e5fab2ec9ca4 ("drm/meson: vclk: add support for YUV420 setup")
Signed-off-by: Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Reviewed-by: Neil Armstrong <neil.armstrong@linaro.org>
Signed-off-by: Neil Armstrong <neil.armstrong@linaro.org>
Link: https://lore.kernel.org/r/20250606203729.3311592-1-martin.blumenstingl@googlemail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/meson/meson_encoder_hdmi.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/meson/meson_encoder_hdmi.c b/drivers/gpu/drm/meson/meson_encoder_hdmi.c
index cd0e9e2d59ee7..73ec7ae48510a 100644
--- a/drivers/gpu/drm/meson/meson_encoder_hdmi.c
+++ b/drivers/gpu/drm/meson/meson_encoder_hdmi.c
@@ -108,7 +108,7 @@ static void meson_encoder_hdmi_set_vclk(struct meson_encoder_hdmi *encoder_hdmi,
 		venc_freq /= 2;
 
 	dev_dbg(priv->dev,
-		"vclk:%lluHz phy=%lluHz venc=%lluHz hdmi=%lluHz enci=%d\n",
+		"phy:%lluHz vclk=%lluHz venc=%lluHz hdmi=%lluHz enci=%d\n",
 		phy_freq, vclk_freq, venc_freq, hdmi_freq,
 		priv->venc.hdmi_use_enci);
 
-- 
2.39.5



