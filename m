Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2CA1F16D9BF;
	Mon, 23 Jun 2025 21:46:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750715218; cv=none; b=W2O9iEFT/RATFk+NjXH/0nC1am1Vkp4VSWEjF8Qi9yez8ktZGAyb3uMFT/GQIROiA0dpwaVXAY6D0Qj4ZGnV+/nHAJqnhxXIvdPGySeoySFLdUORm3Mas4m3/U72PGmEdfQk05eCy+YTPA//ztExJrQElLUOE4+HqtiF0weYSTI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750715218; c=relaxed/simple;
	bh=9DYfyOEKnUaXPDCjBQewdLnj1g7+/DZeEx2wcNfyhSs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WGuW5RwjxEUn2TH3x+jHd26eMyvn3ykjcCUhyLvrNZMkX+lroiw3ZGy65AdPRtQTCndHM/99MLwLCu6sYbxf8WXTtIF+zxeyWTGHrO9xbV0z9zx7UzBVxcuBZx5WDeXJrmQASPZMMlkoR1eO0qSSWux46AYRIvxxSK6VpyOaQAk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=eCPnGVlm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="eCPnGVlm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B7EA5C4CEEA;
	Mon, 23 Jun 2025 21:46:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750715218;
	bh=9DYfyOEKnUaXPDCjBQewdLnj1g7+/DZeEx2wcNfyhSs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=eCPnGVlmB9Ms5XAGsLONO23/nIaRnueq2yqoXgYOqS1M2v6gbzJNZGKpJTntS+sXd
	 RibjmB0e34TeR1H+g1XFiExAbv7wFe4TR8QHMqjtsbzTl8Ui+judHohsQZHKKANch/
	 B4/sUhoIu0G+nGn/IN4KJLrKTeD63N8/UbNGqppM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Martin Blumenstingl <martin.blumenstingl@googlemail.com>,
	Neil Armstrong <neil.armstrong@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 242/508] drm/meson: fix debug log statement when setting the HDMI clocks
Date: Mon, 23 Jun 2025 15:04:47 +0200
Message-ID: <20250623130651.208240015@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130645.255320792@linuxfoundation.org>
References: <20250623130645.255320792@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index c1401ec1354d1..e34dc1e405882 100644
--- a/drivers/gpu/drm/meson/meson_encoder_hdmi.c
+++ b/drivers/gpu/drm/meson/meson_encoder_hdmi.c
@@ -106,7 +106,7 @@ static void meson_encoder_hdmi_set_vclk(struct meson_encoder_hdmi *encoder_hdmi,
 		venc_freq /= 2;
 
 	dev_dbg(priv->dev,
-		"vclk:%lluHz phy=%lluHz venc=%lluHz hdmi=%lluHz enci=%d\n",
+		"phy:%lluHz vclk=%lluHz venc=%lluHz hdmi=%lluHz enci=%d\n",
 		phy_freq, vclk_freq, venc_freq, hdmi_freq,
 		priv->venc.hdmi_use_enci);
 
-- 
2.39.5



