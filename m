Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795039206;
	b=WdwPuZZH6gKQ/Kk1USKCrC+eTzgUhfTq9Ge7KAL53LUjq9yBuEfo9c0ED8AC0TWZTycG
	 3k5GQqxMG6TJI5Dd5JBuPLwxwe5th2xM3FViqawqCifrH3EtmfW9y/A33AStvo9VM49wv
	 IuMUIXvQ6elSsQjnVMEsMDv1x6zU7FxrPCykpz3hht6W8ZFvW5v4lpRRoP/RQrmuKDKy5
	 iudq9Xq0mYW9k1ly6doQFgMuGE6rZVGoFwj26GZwb71WVSPHT5GiZr4aATQAMOl6O+ZWw
	 2LOviqZUBgKdS7DwyBqlIM1RWEeKFVbH2cTlcgpbqY8hpB1ji99eW5uxVh/7tNpsGQw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795039206;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=RMoiFw7Kx1BnpUZpUa/SPTISndtkRMBSwVBAJ3KmbqM=;
	b=GrJV9ZXo+cq9VJOw9y+BLJqQ6F6t19VlO51NTEfK7J+D94WmsaP+MzgV5dtb1LOYOycV
	 JmdP5MQQtEvvdT/JACldqlk7iN9Vvps35CnxHojB9oCJRZVaJlXFNDYK5DMtJ2rVwEtpx
	 nWzrTMtbc+rCLPfzjnbo0F6Tgy9FQdR2IfTvSqZMQukdSBq2YL2npUf83Pp+dc4Poszhv
	 ZzWqVW4Gog3GtizSHBjJdfg2E3/DmSzZaTPECKqB2cXFEBHmZgh2N1sYs9Bn2rArYb76P
	 AKFiyNdEqUETxwDmTsMxNQ7cbijSS24DKHVsktIyAa2l+AQ+uupdVqdW2xtXRWZaaOQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=IZzDsFUf;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 45A5D606A32A;
	Wed, 18 Nov 2026 22:00:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=IZzDsFUf
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 576D41F000C4;
	Wed, 18 Nov 2026 22:00:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795039205;
	bh=RMoiFw7Kx1BnpUZpUa/SPTISndtkRMBSwVBAJ3KmbqM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=IZzDsFUfOemsRPsSntyShq80V1fa0kpW8AaqdWM+WFAipwxKXE+twAn3D+4aAa7ss
	 qBmwP6cu3AvnbN+7KBAir4+sRM5VNpoovotZcKjcsuyoB5Wjxjp1csQdtE8CI6Xwlx
	 Ip7EOx5tUXAfZJ+fuOqkJ/C+pn7kZfel131twt74=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Heidelberg <david@ixit.cz>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 2018/3318] ASoC: wcd-mbhc-v2: Fix incorrect properties names and typos
Date: Wed, 18 Nov 2026 15:44:00 +0100
Message-ID: <20261118150422.581284463@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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



