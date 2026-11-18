Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795054667;
	b=VHeWFoH+XaDZrxJ8BRF3RgYjWzBySNmpCcfYeKj9OqG6d9H2MWbgbRUdoqYWSdtiBX6j
	 iuu9ZVhOYg/LPgHZKfpSvqYII6tzo+xS/acAkCZpbgBMSPDKFJaSGskQM3so/WkWuCzCJ
	 rNR4T/+uKG92ArmI4fx2AhdadKHYv/1n5ThjgSBAvjUmnpM5QfJpLHjlduOXhvFAus6lA
	 4tLrkYpCnOa9xImKt0jh8wZHLgG39J9XobNjTRDjjbckU5VOzcO/W+NJ4AlN/6mpCwLd0
	 t+UCqu0lXuLc+WYOJuZBLyvUxc1QaNR4wm7v4h8CPAynULrKyUJ3i1EHrG9hD0eXV9g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795054667;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=TQS/2Oh44WAoRILx53dWwzmyGYxQUeQDYdHYzcIn744=;
	b=ASYCBQ97EH3nFCMrvS/DBdK3gg73mHLIQFIZSB4RM8mzGdBuDW7P3HXdwPKkqIIqW5k1
	 0uERdN1n/3K++JSHC7A5BhEuZ/tjBWm4qh3GasNg7VLVvSaIGLg6ojv91kANkUfD/bEjU
	 nwD59/yIY8Ox88UY4ggxYmt/cAv6STVAOXTgjBljUpx1jHAovMODBLAxy0K3tu6WCMBk5
	 ndz7b7k5KswV7/THpUZH5mivnS6TFBF3rUGuLpcvSMhNbwtEal8XYDgd/mzJ+Wb4CDvFO
	 6lhNkBUjxloJLjbnELxtkNK4bVcd5HKmV+jSxGqnozbKA5qG5u6uLsk9zqkZM7xfgvg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=JpX0SCbw;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8AC80606A31C;
	Thu, 19 Nov 2026 02:17:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=JpX0SCbw
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9B5A21F000C4;
	Thu, 19 Nov 2026 02:17:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795054667;
	bh=TQS/2Oh44WAoRILx53dWwzmyGYxQUeQDYdHYzcIn744=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=JpX0SCbwr4tp7wza/cDBSTioe4wt1nqXKAUjkV5D6LV2ZkH6ZTfLp09mUIGSuEHSG
	 JAFt+ogoECCdZRrU8ND9va33oV0FPrAA1jZH9UFzKORh3dDITmISJsVfxeXI5u/sv1
	 h6nvPAZl3KV0lp/Sxdsun7mTuvoRSa2eFTBfeQC8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Heidelberg <david@ixit.cz>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 1356/2214] ASoC: wcd-mbhc-v2: Fix incorrect properties names and typos
Date: Wed, 18 Nov 2026 15:50:32 +0100
Message-ID: <20261118150105.666505828@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: David Heidelberg <david@ixit.cz>

[ Upstream commit 17bca5d55446c1e21944d47354ee2f0b80db36d6 ]

Improves debugging experience.

Fixes: 0e5c9e7ff899 ("ASoC: codecs: wcd: add multi button Headset detection support")
Signed-off-by: David Heidelberg <david@ixit.cz>
Link: https://patch.msgid.link/20260823-wcd-dt-typo-fix-v1-1-a71b458e0d31@ixit.cz
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/wcd-mbhc-v2.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/sound/soc/codecs/wcd-mbhc-v2.c b/sound/soc/codecs/wcd-mbhc-v2.c
index 26f26f442d7cd..4fa0654f24bb7 100644
--- a/sound/soc/codecs/wcd-mbhc-v2.c
+++ b/sound/soc/codecs/wcd-mbhc-v2.c
@@ -788,7 +788,7 @@ static int wcd_measure_adc_continuous(struct wcd_mbhc *mbhc)
 	u8 adc_en;
 
 	/* Pre-requisites for ADC continuous measurement */
-	/* Read legacy electircal detection and disable */
+	/* Read legacy electrical detection and disable */
 	wcd_mbhc_write_field(mbhc, WCD_MBHC_ELECT_SCHMT_ISRC, 0x00);
 	/* Set ADC to continuous measurement */
 	wcd_mbhc_write_field(mbhc, WCD_MBHC_ADC_MODE, 1);
@@ -889,7 +889,7 @@ static int wcd_check_cross_conn(struct wcd_mbhc *mbhc)
 	if (wcd_mbhc_read_field(mbhc, WCD_MBHC_HPH_PA_EN))
 		return -EINVAL;
 
-	/* Read legacy electircal detection and disable */
+	/* Read legacy electrical detection and disable */
 	elect_ctl = wcd_mbhc_read_field(mbhc, WCD_MBHC_ELECT_SCHMT_ISRC);
 	wcd_mbhc_write_field(mbhc, WCD_MBHC_ELECT_SCHMT_ISRC, 0);
 
@@ -1325,14 +1325,14 @@ int wcd_dt_parse_mbhc_data(struct device *dev, struct wcd_mbhc_config *cfg)
 	ret = of_property_read_u32(np, "qcom,mbhc-headset-vthreshold-microvolt",
 				   &microvolt);
 	if (ret)
-		dev_dbg(dev, "missing qcom,mbhc-hs-mic-max-vthreshold--microvolt in dt node\n");
+		dev_dbg(dev, "missing qcom,mbhc-headset-vthreshold-microvolt in dt node\n");
 	else
 		cfg->hs_thr = microvolt/1000;
 
 	ret = of_property_read_u32(np, "qcom,mbhc-headphone-vthreshold-microvolt",
 				   &microvolt);
 	if (ret)
-		dev_dbg(dev, "missing qcom,mbhc-hs-mic-min-vthreshold-microvolt	entry\n");
+		dev_dbg(dev, "missing qcom,mbhc-headphone-vthreshold-microvolt entry\n");
 	else
 		cfg->hph_thr = microvolt/1000;
 
-- 
2.53.0



