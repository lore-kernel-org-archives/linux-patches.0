Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 18A512AF0E;
	Thu, 12 Dec 2024 15:19:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734016799; cv=none; b=XTUf0wWDAqtTjUTIYjTZN0KW7f9YKNNNtnkSCMi5QytWPKynNnTxPQuXjtpWdsXBBiV2dPhKa86vtHlroR/L4YMznxgN5tSVkSlNWZpiqMqM6sK7akD9XISH/Xp8auii2bO4d0LKJScr3BDLx+QIwPQBLOGDLW5zJQa+MKOfhGk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734016799; c=relaxed/simple;
	bh=SCdw9yige7xsudgZtc+Vdo3lE8Dcx2zVMxtT0USrz/o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LmbricuQOGKKUjExvBEsG3ARlFC6awzGRJTiAWVTpdDrtjlpofweANV8Bk8vryb3Q1xLYz/Kg5jxoj4Z28H+6l+BPe3wFNrJSmQ5oMF+C+e/uvNA1jzNHVwB09lUuZCMVUPf5kWes9kyFm0ZglKzS3imn0UAs36GWJmCZxUojhQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qOxBwOO4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qOxBwOO4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4741CC4CECE;
	Thu, 12 Dec 2024 15:19:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734016799;
	bh=SCdw9yige7xsudgZtc+Vdo3lE8Dcx2zVMxtT0USrz/o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qOxBwOO4GWL+XCSO/nmBkw5oCkOgtew+P826888lg5zelNHLcBPlMhwwwyCHsGP8o
	 nvqtvch7XSuCXtoZfzsrsSFv9xrzWn/1O9k8aRN2hPDMrFClrdZS7nzvrR+Fw98Fq4
	 I6fx4Jr6HhT0YU3SG5/v593qepkdzQDZfY0tilYs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Charles Keepax <ckeepax@opensource.cirrus.com>,
	Liam Girdwood <liam.r.girdwood@intel.com>,
	Bard Liao <yung-chuan.liao@linux.intel.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 300/466] ASoC: sdw_utils: Add a quirk to allow the cs42l43 mic DAI to be ignored
Date: Thu, 12 Dec 2024 15:57:49 +0100
Message-ID: <20241212144318.633633155@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144306.641051666@linuxfoundation.org>
References: <20241212144306.641051666@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Charles Keepax <ckeepax@opensource.cirrus.com>

[ Upstream commit a6f7afb39362ef70d08d23e5bfc0a14d69fafea1 ]

To support some systems using host microphones add a quirk to allow the
cs42l43 microphone DAI link to be ignored.

Signed-off-by: Charles Keepax <ckeepax@opensource.cirrus.com>
Reviewed-by: Liam Girdwood <liam.r.girdwood@intel.com>
Signed-off-by: Bard Liao <yung-chuan.liao@linux.intel.com>
Link: https://patch.msgid.link/20241016030344.13535-3-yung-chuan.liao@linux.intel.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/sound/soc_sdw_utils.h       | 1 +
 sound/soc/sdw_utils/soc_sdw_utils.c | 2 ++
 2 files changed, 3 insertions(+)

diff --git a/include/sound/soc_sdw_utils.h b/include/sound/soc_sdw_utils.h
index dc7541b7b6158..0150b3735b4bd 100644
--- a/include/sound/soc_sdw_utils.h
+++ b/include/sound/soc_sdw_utils.h
@@ -28,6 +28,7 @@
  *   - SOC_SDW_CODEC_SPKR | SOF_SIDECAR_AMPS - Not currently supported
  */
 #define SOC_SDW_SIDECAR_AMPS		BIT(16)
+#define SOC_SDW_CODEC_MIC		BIT(17)
 
 #define SOC_SDW_UNUSED_DAI_ID		-1
 #define SOC_SDW_JACK_OUT_DAI_ID		0
diff --git a/sound/soc/sdw_utils/soc_sdw_utils.c b/sound/soc/sdw_utils/soc_sdw_utils.c
index 863b4d5527cbe..c06963ac7fafa 100644
--- a/sound/soc/sdw_utils/soc_sdw_utils.c
+++ b/sound/soc/sdw_utils/soc_sdw_utils.c
@@ -487,6 +487,8 @@ struct asoc_sdw_codec_info codec_info_list[] = {
 				.rtd_init = asoc_sdw_cs42l43_dmic_rtd_init,
 				.widgets = generic_dmic_widgets,
 				.num_widgets = ARRAY_SIZE(generic_dmic_widgets),
+				.quirk = SOC_SDW_CODEC_MIC,
+				.quirk_exclude = true,
 			},
 			{
 				.direction = {false, true},
-- 
2.43.0



