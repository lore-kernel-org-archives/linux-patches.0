Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8017626B09F;
	Tue,  8 Apr 2025 12:12:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744114359; cv=none; b=QvHbOXzP1U1IPywgbW7Da0FzxzaDosmSdq0YN7W5XXcVjJ0x/ns7KC0TeqxNf1pmvDAfhJamSbLFKc6FfYZD6wgY4CZ8+zksm9AiPTLMB9kSUVap0aGx8a+zcyCds+H2NmSl+8/94H8GgaqTimkaSDpoSVQHxpQJll6kvC6+ZOg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744114359; c=relaxed/simple;
	bh=c2voS/rU077nFdZu469/dqwkBLRhIPjK/LV3HBFMPNI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FJRRBQ0S15HdjBlEhDQ3wzNdc4eddLNk2XB9TWRRIdCSJZEoVeob9SSlHJ9v2Ug5O6+5XvAMATzN36AVQgAVADAfzTntaxoqdeSuKtYcXLOadMuEXxkxfwLqnB/JXqE561GxTX6pEeRMSsXMAYgfwvlOOu6n8ScHWlgcFwA/38Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CsO5lBSP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CsO5lBSP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 08E9EC4CEE7;
	Tue,  8 Apr 2025 12:12:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744114359;
	bh=c2voS/rU077nFdZu469/dqwkBLRhIPjK/LV3HBFMPNI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CsO5lBSPsdN7/AhAtkxsM/htzVs0if3F9YnAKhWDsKDKAilFL0jT6sW0N5y7NOSC3
	 iSyi2zED3NOfICZ7nuOTKyNDZITjAlQiLZY9hH/AGhR9YebV+y3DfSNdJjhTKzkJHh
	 4hqXSJDLg7Jpvs0gvJnWVAv6C9SNUCyDeYlamhwc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	CK Hu <ck.hu@mediatek.com>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Chun-Kuang Hu <chunkuang.hu@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 076/499] drm/mediatek: mtk_hdmi: Fix typo for aud_sampe_size member
Date: Tue,  8 Apr 2025 12:44:48 +0200
Message-ID: <20250408104853.121358703@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104851.256868745@linuxfoundation.org>
References: <20250408104851.256868745@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

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
index 835b6fc53a520..0b486575ee3c3 100644
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
@@ -1573,14 +1573,14 @@ static int mtk_hdmi_audio_hw_params(struct device *dev, void *data,
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



