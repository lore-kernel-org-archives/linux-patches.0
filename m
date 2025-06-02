Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0ED5E1E3772;
	Mon,  2 Jun 2025 14:18:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748873909; cv=none; b=kdF1P+fqD9AyWDHxwoMu/qTPdIPRS4gqGk/L+VL3QftDhJm35qvthtHJI0wEOLXSDai4s1jNUVwRnl/pGB7oxm5vk7rxKA9TZ7BuSQRsSDcFlY1HXWkf+Iuhqtd+p5KkGKQ2A7ElONiaZfydbvxu69Ev9VO5pzMnbhmCeUMwmMA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748873909; c=relaxed/simple;
	bh=TYsSits4AMR3mpNFdMyfibvlnNRYkep1bKoxfbaGfWY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Uz/2zf7lx0ekqyB27clJH9ANqacJyhpnJujs8/aY/my2MKwOVgbEFaEMMoufteoI2Pmt/k5hdXU/tYROb36nl2iFhaV8xRr0NMa5iwZwB1SgRb8S4pf77c1KbbWcu0dby5Y11gC5TzfBMNjWjT+Ycqw8XgcM5A4qHrYmhLScNJM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Y69lCFSZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Y69lCFSZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9555BC4CEEB;
	Mon,  2 Jun 2025 14:18:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748873908;
	bh=TYsSits4AMR3mpNFdMyfibvlnNRYkep1bKoxfbaGfWY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Y69lCFSZPLVbUvle/B1gHRqcYBOVYuhS9zhhxnvqyBpGY7izj6Y4ouWh/5VXIDOeA
	 BriiQNyWeCYfVPWVSIoZZF3MknmsiBWrbT2pszDAcWlAe4sJPgO9WOVQMJuvTZZCm+
	 70ZyUk4jDJnVgmSQKpofiqRSld5rzqpQMGzmdKXw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shuming Fan <shumingf@realtek.com>,
	Charles Keepax <ckeepax@opensource.cirrus.com>,
	Pierre-Louis Bossart <pierre-louis.bossart@linux.dev>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 293/444] ASoC: rt722-sdca: Add some missing readable registers
Date: Mon,  2 Jun 2025 15:45:57 +0200
Message-ID: <20250602134352.846825509@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250602134340.906731340@linuxfoundation.org>
References: <20250602134340.906731340@linuxfoundation.org>
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

From: Charles Keepax <ckeepax@opensource.cirrus.com>

[ Upstream commit f9a5c4b6afc79073491acdab7f1e943ee3a19fbb ]

Add a few missing registers from the readable register callback.

Suggested-by: Shuming Fan <shumingf@realtek.com>
Signed-off-by: Charles Keepax <ckeepax@opensource.cirrus.com>
Reviewed-by: Pierre-Louis Bossart <pierre-louis.bossart@linux.dev>
Link: https://patch.msgid.link/20250107154408.814455-6-ckeepax@opensource.cirrus.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/rt722-sdca-sdw.c | 49 +++++++++++++++++++++++++++++--
 1 file changed, 46 insertions(+), 3 deletions(-)

diff --git a/sound/soc/codecs/rt722-sdca-sdw.c b/sound/soc/codecs/rt722-sdca-sdw.c
index c382cb6be6025..c0bb1b4b2dcb5 100644
--- a/sound/soc/codecs/rt722-sdca-sdw.c
+++ b/sound/soc/codecs/rt722-sdca-sdw.c
@@ -28,9 +28,50 @@ static bool rt722_sdca_readable_register(struct device *dev, unsigned int reg)
 			0):
 	case SDW_SDCA_CTL(FUNC_NUM_JACK_CODEC, RT722_SDCA_ENT_GE49, RT722_SDCA_CTL_DETECTED_MODE,
 			0):
-	case SDW_SDCA_CTL(FUNC_NUM_HID, RT722_SDCA_ENT_HID01, RT722_SDCA_CTL_HIDTX_CURRENT_OWNER,
-			0) ... SDW_SDCA_CTL(FUNC_NUM_HID, RT722_SDCA_ENT_HID01,
-			RT722_SDCA_CTL_HIDTX_MESSAGE_LENGTH, 0):
+	case SDW_SDCA_CTL(FUNC_NUM_JACK_CODEC, RT722_SDCA_ENT_XU03, RT722_SDCA_CTL_SELECTED_MODE,
+			0):
+	case SDW_SDCA_CTL(FUNC_NUM_JACK_CODEC, RT722_SDCA_ENT_USER_FU05,
+			  RT722_SDCA_CTL_FU_MUTE, CH_L) ...
+	     SDW_SDCA_CTL(FUNC_NUM_JACK_CODEC, RT722_SDCA_ENT_USER_FU05,
+			  RT722_SDCA_CTL_FU_MUTE, CH_R):
+	case SDW_SDCA_CTL(FUNC_NUM_JACK_CODEC, RT722_SDCA_ENT_XU0D,
+			  RT722_SDCA_CTL_SELECTED_MODE, 0):
+	case SDW_SDCA_CTL(FUNC_NUM_JACK_CODEC, RT722_SDCA_ENT_USER_FU0F,
+			  RT722_SDCA_CTL_FU_MUTE, CH_L) ...
+	     SDW_SDCA_CTL(FUNC_NUM_JACK_CODEC, RT722_SDCA_ENT_USER_FU0F,
+			  RT722_SDCA_CTL_FU_MUTE, CH_R):
+	case SDW_SDCA_CTL(FUNC_NUM_JACK_CODEC, RT722_SDCA_ENT_PDE40,
+			  RT722_SDCA_CTL_REQ_POWER_STATE, 0):
+	case SDW_SDCA_CTL(FUNC_NUM_JACK_CODEC, RT722_SDCA_ENT_PDE12,
+			  RT722_SDCA_CTL_REQ_POWER_STATE, 0):
+	case SDW_SDCA_CTL(FUNC_NUM_JACK_CODEC, RT722_SDCA_ENT_CS01,
+			  RT722_SDCA_CTL_SAMPLE_FREQ_INDEX, 0):
+	case SDW_SDCA_CTL(FUNC_NUM_JACK_CODEC, RT722_SDCA_ENT_CS11,
+			  RT722_SDCA_CTL_SAMPLE_FREQ_INDEX, 0):
+	case SDW_SDCA_CTL(FUNC_NUM_MIC_ARRAY, RT722_SDCA_ENT_USER_FU1E,
+			  RT722_SDCA_CTL_FU_MUTE, CH_01) ...
+	     SDW_SDCA_CTL(FUNC_NUM_MIC_ARRAY, RT722_SDCA_ENT_USER_FU1E,
+			  RT722_SDCA_CTL_FU_MUTE, CH_04):
+	case SDW_SDCA_CTL(FUNC_NUM_MIC_ARRAY, RT722_SDCA_ENT_IT26,
+			  RT722_SDCA_CTL_VENDOR_DEF, 0):
+	case SDW_SDCA_CTL(FUNC_NUM_MIC_ARRAY, RT722_SDCA_ENT_PDE2A,
+			  RT722_SDCA_CTL_REQ_POWER_STATE, 0):
+	case SDW_SDCA_CTL(FUNC_NUM_MIC_ARRAY, RT722_SDCA_ENT_CS1F,
+			  RT722_SDCA_CTL_SAMPLE_FREQ_INDEX, 0):
+	case SDW_SDCA_CTL(FUNC_NUM_HID, RT722_SDCA_ENT_HID01,
+			  RT722_SDCA_CTL_HIDTX_CURRENT_OWNER, 0) ...
+	     SDW_SDCA_CTL(FUNC_NUM_HID, RT722_SDCA_ENT_HID01,
+			  RT722_SDCA_CTL_HIDTX_MESSAGE_LENGTH, 0):
+	case SDW_SDCA_CTL(FUNC_NUM_AMP, RT722_SDCA_ENT_USER_FU06,
+			  RT722_SDCA_CTL_FU_MUTE, CH_L) ...
+	     SDW_SDCA_CTL(FUNC_NUM_AMP, RT722_SDCA_ENT_USER_FU06,
+			  RT722_SDCA_CTL_FU_MUTE, CH_R):
+	case SDW_SDCA_CTL(FUNC_NUM_AMP, RT722_SDCA_ENT_OT23,
+			  RT722_SDCA_CTL_VENDOR_DEF, CH_08):
+	case SDW_SDCA_CTL(FUNC_NUM_AMP, RT722_SDCA_ENT_PDE23,
+			  RT722_SDCA_CTL_REQ_POWER_STATE, 0):
+	case SDW_SDCA_CTL(FUNC_NUM_AMP, RT722_SDCA_ENT_CS31,
+			  RT722_SDCA_CTL_SAMPLE_FREQ_INDEX, 0):
 	case RT722_BUF_ADDR_HID1 ... RT722_BUF_ADDR_HID2:
 		return true;
 	default:
@@ -74,6 +115,7 @@ static bool rt722_sdca_mbq_readable_register(struct device *dev, unsigned int re
 	case 0x5600000 ... 0x5600007:
 	case 0x5700000 ... 0x5700004:
 	case 0x5800000 ... 0x5800004:
+	case 0x5810000:
 	case 0x5b00003:
 	case 0x5c00011:
 	case 0x5d00006:
@@ -81,6 +123,7 @@ static bool rt722_sdca_mbq_readable_register(struct device *dev, unsigned int re
 	case 0x5f00030:
 	case 0x6100000 ... 0x6100051:
 	case 0x6100055 ... 0x6100057:
+	case 0x6100060:
 	case 0x6100062:
 	case 0x6100064 ... 0x6100065:
 	case 0x6100067:
-- 
2.39.5



