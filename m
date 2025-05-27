Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 20243139579;
	Tue, 27 May 2025 17:09:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748365799; cv=none; b=AVxJo5Meitg0aM18YPh+NBUux1w8KIU3ukAvxUSArUT1xpaGMs9EPKzpeizAC80xal+8tiJoW0uZeIvXhO6/lDxB1YBaC2BzVbU1g1m3eq7dEdmoy/9TpV2PcXR1TMCy1TyhBqazRq4/c3hRJLEN5VkHwGgdOS+uYLBEKX1K788=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748365799; c=relaxed/simple;
	bh=Hy0IWDFeiTkvsC7id8Pk2hl3pIylz7w9wrqvY8DX70E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=un6AaP8b6AQql4youxle2cUyBvpmsHg0afdE+nRaq+HF1UrN5c8a7RpwHkcVrs9ESAj2k1KxZdywQdYIgveXp7aacSqn+BpGFSLpXNX1UOoE004MQyawxvKD91UAfv0x8CRz424nYagBB8G3ydLu1fZH1ljFZQEBWAsrerbno5E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lIVyRLru; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lIVyRLru"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 91092C4CEE9;
	Tue, 27 May 2025 17:09:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748365799;
	bh=Hy0IWDFeiTkvsC7id8Pk2hl3pIylz7w9wrqvY8DX70E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lIVyRLruw50yS0dyr5+WneA8dlVUWywNcU2S3JUk6Grz7UE+ekbmFwlUfSm21wdrT
	 FLu1xsyVD+HKGh4PDtysWN8FfYxSGoBffV0EiM6cbxqUbYyBE79jgES/B1jW+x0pkv
	 HniOXzyAQbfXD05bpFu365u7ivf7Za6v9uoCJn/I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Olivier Moysan <olivier.moysan@foss.st.com>,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 493/626] drm: bridge: adv7511: fill stream capabilities
Date: Tue, 27 May 2025 18:26:26 +0200
Message-ID: <20250527162505.013070171@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250527162445.028718347@linuxfoundation.org>
References: <20250527162445.028718347@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 8f786592143b6..24e1e11acf697 100644
--- a/drivers/gpu/drm/bridge/adv7511/adv7511_audio.c
+++ b/drivers/gpu/drm/bridge/adv7511/adv7511_audio.c
@@ -244,7 +244,9 @@ static const struct hdmi_codec_pdata codec_data = {
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



