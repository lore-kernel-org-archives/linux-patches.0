Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795047778;
	b=iWM0FoyG1D6ralV7sbUU1Yeab7QnaYc+wr/XJ9Ba8+NKruQVvmkOmq03NxzVFgB1Z+OT
	 QH8di2AiX4+hXSaXEnKRC2RqjCgAyPld2yNLr7u3U9I/ol4B7TirQJyzT0wgCEi2EWRu1
	 AwIEcso4GCmEE1VTiW9bBVVOrk3HTwqZmzW8mqTvTWKoRNMYa39a8dKH02D1kNUxl4tpB
	 wO7iZk3pallcWk4AYN2fJOw9tBAikpCUBO8abFospMORuds0SZn8ERtyguE1jkEO59bjS
	 ek90SN8t56h4IxWMckGPZxXvhX7XRBClXIy11FDZIgFjTQoTPQqgCFell9dMZ26wKfg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795047778;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=v+AoDfrJT8zZjYPskycmaEruV9VakAN/Msu8rTk2MGM=;
	b=5oZTjR7324CnlJFS3tKGSgYeg8o9Le3mFfNkwgRVoTbTg+YvTOeLx2++KSqDESto5gGW
	 IUvhaui+YKvhaKrUyIhZ8p64uyuLx8NAXZu6ggosEryezCAbYSEEvaBWiJyBvwKmqDYMh
	 QRLhuYTmlctkvneogS5yfW1cyHMFPLDvk+zpwJ/U/YsLTOBkbvpjo2yPmLzASPjWldHUp
	 izqt5+hYLb0sG0c/WGpticGnP01pcnS4pck/4Txrmcgttjr9z5ChDhPCAkGwygyssgkgv
	 ZgwgbX0T81JlJvW5ckNlN4UMBr5jm6LnHy3aru+TOf6Vmfj03hgB94PGUq9Z3tiFRCA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=X+Jf0Flh;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 45E80606A31C;
	Thu, 19 Nov 2026 00:22:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=X+Jf0Flh
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 59B1F1F000C4;
	Thu, 19 Nov 2026 00:22:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795047777;
	bh=v+AoDfrJT8zZjYPskycmaEruV9VakAN/Msu8rTk2MGM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=X+Jf0FlhbqQio6MGSxk+7mtUX18ofABc1+u4pD0tpAd1T8a1FCUReF+KaTbEZAtvz
	 FU/+MCPslecJyRB09TkRrReWXmG9RTiPViAvdDsc2A3uUB5psP5735/Yx9iyT4SKFy
	 vshgCtlBX2P7UQ5rbYLzijFFSlt9ujnYRkgvocOA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Heidelberg <david@ixit.cz>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1759/2857] ASoC: wcd-mbhc-v2: Fix incorrect properties names and typos
Date: Wed, 18 Nov 2026 15:46:33 +0100
Message-ID: <20261118150304.626850681@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 5da1934527f34..d5e9c28b5c496 100644
--- a/sound/soc/codecs/wcd-mbhc-v2.c
+++ b/sound/soc/codecs/wcd-mbhc-v2.c
@@ -802,7 +802,7 @@ static int wcd_measure_adc_continuous(struct wcd_mbhc *mbhc)
 	u8 adc_en;
 
 	/* Pre-requisites for ADC continuous measurement */
-	/* Read legacy electircal detection and disable */
+	/* Read legacy electrical detection and disable */
 	wcd_mbhc_write_field(mbhc, WCD_MBHC_ELECT_SCHMT_ISRC, 0x00);
 	/* Set ADC to continuous measurement */
 	wcd_mbhc_write_field(mbhc, WCD_MBHC_ADC_MODE, 1);
@@ -903,7 +903,7 @@ static int wcd_check_cross_conn(struct wcd_mbhc *mbhc)
 	if (wcd_mbhc_read_field(mbhc, WCD_MBHC_HPH_PA_EN))
 		return -EINVAL;
 
-	/* Read legacy electircal detection and disable */
+	/* Read legacy electrical detection and disable */
 	elect_ctl = wcd_mbhc_read_field(mbhc, WCD_MBHC_ELECT_SCHMT_ISRC);
 	wcd_mbhc_write_field(mbhc, WCD_MBHC_ELECT_SCHMT_ISRC, 0);
 
@@ -1409,14 +1409,14 @@ int wcd_dt_parse_mbhc_data(struct device *dev, struct wcd_mbhc_config *cfg)
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



