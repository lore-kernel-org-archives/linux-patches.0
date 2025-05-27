Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B78E727BF8D;
	Tue, 27 May 2025 17:50:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748368238; cv=none; b=kj3dZ/RPA+rex7v9qKEkXhn25DlEH6X1YLL/Wpt70KpyyWYtnc8u40HDaw0o2YFGMb1yXjw97L3TXI5fTP7+iRdF9OGnkiQ5WJUUZp+dchwN+7OAbo4jrHD7T7vxEqdqwVGeQSBDXjttzDMHTKEAsdHJmARNKfRTslhCwve/WqE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748368238; c=relaxed/simple;
	bh=IxwWTHNmnRf+c5Be8IWury/u3DBaaX6CWMuWktm4N7o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Pb35AQ3bJKLNdgr+wCWBflnY9SitpbjcbS9QzY1GDTp6cfUGHpY/oeKSO/PDAtQTNee1HyF8w2Tm8ou64hT7UjwNPvVYEVOTBAKz1yQp+FGV9vvg/pg2cuwC8euR5Ampc8rzk2irGR1J+UxqwlvG844VUrgU/p1XuZd7A1OfmlM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=n/Yfk4uG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="n/Yfk4uG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A95DFC4CEE9;
	Tue, 27 May 2025 17:50:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748368238;
	bh=IxwWTHNmnRf+c5Be8IWury/u3DBaaX6CWMuWktm4N7o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=n/Yfk4uGj00Vp4pkWXEkfs/wZbMpnV3t8TLkMTevkvZ/ZCD0Z/t5Nuuog7TeKDEGI
	 um+n2y4gCi+IekpAdWSrBEr4eQtjH3ncJ0NjpOlSr5tUQqlzmOZU+Mx/Hhae71NEyW
	 WFXYFOxAyoTx1pKMv/zLwP60Ws9pcocdCv4Dg0CQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Olivier Moysan <olivier.moysan@foss.st.com>,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 612/783] drm: bridge: adv7511: fill stream capabilities
Date: Tue, 27 May 2025 18:26:49 +0200
Message-ID: <20250527162538.070108665@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250527162513.035720581@linuxfoundation.org>
References: <20250527162513.035720581@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Olivier Moysan <olivier.moysan@foss.st.com>

[ Upstream commit c852646f12d4cd5b4f19eeec2976c5d98c0382f8 ]

Set no_i2s_capture and no_spdif_capture flags in hdmi_codec_pdata structure
to report that the ADV7511 HDMI bridge does not support i2s or spdif audio
capture.

Signed-off-by: Olivier Moysan <olivier.moysan@foss.st.com>
Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Link: https://patchwork.freedesktop.org/patch/msgid/20250108170356.413063-2-olivier.moysan@foss.st.com
Signed-off-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/bridge/adv7511/adv7511_audio.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/gpu/drm/bridge/adv7511/adv7511_audio.c b/drivers/gpu/drm/bridge/adv7511/adv7511_audio.c
index 657bc3dd18dff..98030500a978a 100644
--- a/drivers/gpu/drm/bridge/adv7511/adv7511_audio.c
+++ b/drivers/gpu/drm/bridge/adv7511/adv7511_audio.c
@@ -245,7 +245,9 @@ static const struct hdmi_codec_pdata codec_data = {
 	.ops = &adv7511_codec_ops,
 	.max_i2s_channels = 2,
 	.i2s = 1,
+	.no_i2s_capture = 1,
 	.spdif = 1,
+	.no_spdif_capture = 1,
 };
 
 int adv7511_audio_init(struct device *dev, struct adv7511 *adv7511)
-- 
2.39.5



