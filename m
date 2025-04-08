Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2769522488E;
	Tue,  8 Apr 2025 12:34:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744115699; cv=none; b=H06PRTRGiyV2vEztkFVMBpy5DKxUNLqoTlyj2J3nOo6qzzIKkP5M1Ugu8/dwjjuhE5yB4vyo/f2LxZURm78wx087/KHR0Wpn97Kyew5vsKHaAtM4T3gBe+6bFX3Z9+rjt8JTVxBa77J4Q8/bAZfclTkM3qoEiBj+qri1FFBLii4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744115699; c=relaxed/simple;
	bh=Awlf62yO19Hl0fZuOnPDrlHMi+a5hnOicYnuExxSHHk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sMahEmu4EVRD1wQe4+dtygNSH4ookFaR0E9K00aKVC3PeQXrpftVi/kgZTqgYr0U4LyGCUj/XZ4idY9ztXAOyDB4GAON/521PnW6qJVyylLNtaR2R90LbZhNRVIFuT6LiI1YYq60h3HA/5IpGE/D37NpVP976jCpWncBPFQKty0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YCYqhHHQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YCYqhHHQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A7E37C4CEE5;
	Tue,  8 Apr 2025 12:34:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744115699;
	bh=Awlf62yO19Hl0fZuOnPDrlHMi+a5hnOicYnuExxSHHk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YCYqhHHQ6KzGMb5SbNMt2FqnDOhJUh+WMdic36L+e49+889AW2MV52ndgFXwItSsM
	 IdmTt5h7cTIQacEhSlbLNPRf8w/fWXhbVFNy7gS2yeImjmWJ+WtC6Ph8W35+Gh8ekH
	 j4MnJFhRlN5cG3LZnPGZ7r8AU/x2D56X77uMFmSE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	CK Hu <ck.hu@mediatek.com>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Chun-Kuang Hu <chunkuang.hu@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 034/204] drm/mediatek: mtk_hdmi: Fix typo for aud_sampe_size member
Date: Tue,  8 Apr 2025 12:49:24 +0200
Message-ID: <20250408104821.338466231@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104820.266892317@linuxfoundation.org>
References: <20250408104820.266892317@linuxfoundation.org>
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

From: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>

[ Upstream commit 72fcb88e7bbc053ed4fc74cebb0315b98a0f20c3 ]

Rename member aud_sampe_size of struct hdmi_audio_param to
aud_sample_size to fix a typo and enhance readability.

This commit brings no functional changes.

Fixes: 8f83f26891e1 ("drm/mediatek: Add HDMI support")
Reviewed-by: CK Hu <ck.hu@mediatek.com>
Signed-off-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Link: https://patchwork.kernel.org/project/linux-mediatek/patch/20250217154836.108895-20-angelogioacchino.delregno@collabora.com/
Signed-off-by: Chun-Kuang Hu <chunkuang.hu@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/mediatek/mtk_hdmi.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/gpu/drm/mediatek/mtk_hdmi.c b/drivers/gpu/drm/mediatek/mtk_hdmi.c
index 465f6fe93e998..058b4c042e499 100644
--- a/drivers/gpu/drm/mediatek/mtk_hdmi.c
+++ b/drivers/gpu/drm/mediatek/mtk_hdmi.c
@@ -137,7 +137,7 @@ enum hdmi_aud_channel_swap_type {
 
 struct hdmi_audio_param {
 	enum hdmi_audio_coding_type aud_codec;
-	enum hdmi_audio_sample_size aud_sampe_size;
+	enum hdmi_audio_sample_size aud_sample_size;
 	enum hdmi_aud_input_type aud_input_type;
 	enum hdmi_aud_i2s_fmt aud_i2s_fmt;
 	enum hdmi_aud_mclk aud_mclk;
@@ -1075,7 +1075,7 @@ static int mtk_hdmi_output_init(struct mtk_hdmi *hdmi)
 
 	hdmi->csp = HDMI_COLORSPACE_RGB;
 	aud_param->aud_codec = HDMI_AUDIO_CODING_TYPE_PCM;
-	aud_param->aud_sampe_size = HDMI_AUDIO_SAMPLE_SIZE_16;
+	aud_param->aud_sample_size = HDMI_AUDIO_SAMPLE_SIZE_16;
 	aud_param->aud_input_type = HDMI_AUD_INPUT_I2S;
 	aud_param->aud_i2s_fmt = HDMI_I2S_MODE_I2S_24BIT;
 	aud_param->aud_mclk = HDMI_AUD_MCLK_128FS;
@@ -1576,14 +1576,14 @@ static int mtk_hdmi_audio_hw_params(struct device *dev, void *data,
 	switch (daifmt->fmt) {
 	case HDMI_I2S:
 		hdmi_params.aud_codec = HDMI_AUDIO_CODING_TYPE_PCM;
-		hdmi_params.aud_sampe_size = HDMI_AUDIO_SAMPLE_SIZE_16;
+		hdmi_params.aud_sample_size = HDMI_AUDIO_SAMPLE_SIZE_16;
 		hdmi_params.aud_input_type = HDMI_AUD_INPUT_I2S;
 		hdmi_params.aud_i2s_fmt = HDMI_I2S_MODE_I2S_24BIT;
 		hdmi_params.aud_mclk = HDMI_AUD_MCLK_128FS;
 		break;
 	case HDMI_SPDIF:
 		hdmi_params.aud_codec = HDMI_AUDIO_CODING_TYPE_PCM;
-		hdmi_params.aud_sampe_size = HDMI_AUDIO_SAMPLE_SIZE_16;
+		hdmi_params.aud_sample_size = HDMI_AUDIO_SAMPLE_SIZE_16;
 		hdmi_params.aud_input_type = HDMI_AUD_INPUT_SPDIF;
 		break;
 	default:
-- 
2.39.5



