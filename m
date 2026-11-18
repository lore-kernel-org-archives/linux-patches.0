Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795015333;
	b=kEp15LSqmcDbab6nUo79gmPDpXpGQkAvNfxKEux00s0NaTXrrUh/ZrHHMRVWujd/MsKJ
	 mjlhvw8AqhInCZ/AklbF3Obs5qMhcL0wz4FW72T+XKa4WtsJQm564+IXV1yEwp021IZME
	 /aWHIml4ZpgnDF4EM1yXkiZbp9D6GtEcf37a0DCB292hghM+zhQ7iVTJyGmOirTlRA4zt
	 RFgm4ECsgn4TAAM6IKUOnW/UcTe9nrVBe6IxW2wzYR1AhnfuNQ4UcJum09GfM4hSuKCLd
	 WYMhcOr+l0sXtoPkd3KFj9unxop/BU7fhFXJwaFzf/tM+/mN6uxM4ZgRVzV3Rmca8Pw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795015333;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=QaQTqkU4JgLuUtFDevKl0huCxByENTVBTxa8W1BqkP0=;
	b=YdVQ1ah5yo5ghYfuHwRg2RmdVdNPx8/nDXj/Q4Pnsz2ym+LhqSxAt6FhweD3X+TjJ/ZO
	 sRD1OaWflqFMzYoH2MqBUpyaFht3/cTon7gjRkK6GYFE7vzgYkw8TfxaeDWVqJVPu+4A/
	 n0zzVPqm5MBgw6nlq8iWrkdJGnoIKzCO20ZsZzzjrKOyOaf1zcrtDf1N/gyfH29dbPLPy
	 6xKGKuMONfw8g4XQCEDX2zd+OuafLtKux6wNlWllwRSm08ThoiOxYkbULbB5acAsvQkev
	 jx6MLONT9kNHKiCRD3t74JB6T2IUmYhVo28dZkkGJA5u4thaB0k0kDKmGceih5c23Aw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=XUZa6zlq;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D4FB8606A33B;
	Wed, 18 Nov 2026 15:22:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=XUZa6zlq
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 30A511F000C4;
	Wed, 18 Nov 2026 15:22:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795015333;
	bh=QaQTqkU4JgLuUtFDevKl0huCxByENTVBTxa8W1BqkP0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=XUZa6zlqT3kPPul/WPEVZdpMzsju+m8vNLnfSef3bi9DF3Rw4ZJK+T/8q18SgGh3i
	 fhncyq6+Zjb6bF8xTN+u+lxi/Hf+BLw5i+FJpvJB4rJzqEVXIcst9EPCIUV6or/xy0
	 M5N6EnC/UzEDgGjtbdxH2dMamTgUs8Qfn/X3kyjw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Heidelberg <david@ixit.cz>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0136/2651] ASoC: wcd-mbhc-v2: Fix incorrect properties names and typos
Date: Wed, 18 Nov 2026 15:22:56 +0100
Message-ID: <20261118150252.748512528@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

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
index bb0c8478a8eb5..850be84d65ceb 100644
--- a/sound/soc/codecs/wcd-mbhc-v2.c
+++ b/sound/soc/codecs/wcd-mbhc-v2.c
@@ -864,7 +864,7 @@ static int wcd_measure_adc_continuous(struct wcd_mbhc *mbhc)
 	u8 adc_en;
 
 	/* Pre-requisites for ADC continuous measurement */
-	/* Read legacy electircal detection and disable */
+	/* Read legacy electrical detection and disable */
 	wcd_mbhc_write_field(mbhc, WCD_MBHC_ELECT_SCHMT_ISRC, 0x00);
 	/* Set ADC to continuous measurement */
 	wcd_mbhc_write_field(mbhc, WCD_MBHC_ADC_MODE, 1);
@@ -965,7 +965,7 @@ static int wcd_check_cross_conn(struct wcd_mbhc *mbhc)
 	if (wcd_mbhc_read_field(mbhc, WCD_MBHC_HPH_PA_EN))
 		return -EINVAL;
 
-	/* Read legacy electircal detection and disable */
+	/* Read legacy electrical detection and disable */
 	elect_ctl = wcd_mbhc_read_field(mbhc, WCD_MBHC_ELECT_SCHMT_ISRC);
 	wcd_mbhc_write_field(mbhc, WCD_MBHC_ELECT_SCHMT_ISRC, 0);
 
@@ -1470,14 +1470,14 @@ int wcd_dt_parse_mbhc_data(struct device *dev, struct wcd_mbhc_config *cfg)
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



