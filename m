Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795028962;
	b=n6r9El7PJk/XuIDHgwwKbcNA8fcNIq1ZcQmP4Km3jYetJ3+N4s6St468xELyFH6sv5/Z
	 omr/pOCNnHG36+khmIdXF85aTaz4v4YWuji1N4arPUSfCM3f5WqiFUaukCJF3zvNSnpXT
	 9tZgWtJPwuCkBD1pNIS0PYuoWgp6OSAc5nPEaV5J/0SNZxDeildXyCWIEn+553JQFz0eN
	 X+8oEFwglT3wjTVHNkOuCgiAhCxqODN10gR5m1C+SQ4Mh9myDhsCdsiNRDs/3xEUtYRqM
	 qDpTEGdNfQ7XzCuvb51rOvsmgwRbRH2v1/ZpFASSooeKRz9ns/hcVnr1TI3odTIMLXA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795028962;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=2jAtfk+4YtWTQHg+K9/mywAzx8Em+UIzMZeL70Dd6dI=;
	b=zbLAkz/TpnuFKD7kWrvN3NiOPk75X7Xag+c2kmhIEkTZSxE754RuQ1Ys3Sr63SQURZOl
	 l8EFSmnukoT8nwpWR3XCqOvAkSC9slM1hdur2K2u/0U3kbbFwOF17RxNrreAfEZyYZZx9
	 ttn4YmR+U3Xill3kJFWcb9uwunsjJcA3yPPgWUXnCwuL4S5oqy8N25/7FZHt/7KKEsqTB
	 csiB6WM+Dwv1y8nGpgj4IAh+5sHoq5/oQ9mv1cGjOD/zJTX/yk/j6/2uV4DzNCa04U1kj
	 dh33VY/7AHkdFjYKSRL8SNR1bdtCkZzQ6OkL7qX8EXLgMK0VBXdrxl9XTvVTZoWO7Tw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=D37UYqN1;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 957EF606A33F;
	Wed, 18 Nov 2026 19:09:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=D37UYqN1
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D586C1F000C4;
	Wed, 18 Nov 2026 19:09:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795028962;
	bh=2jAtfk+4YtWTQHg+K9/mywAzx8Em+UIzMZeL70Dd6dI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=D37UYqN1TJRIdbhnSF34Y1bgc53iW3w1XVsjrOXfR+99b/cu704gofnDnVD4L6r3o
	 4/31/ypvlDrPLOlXlNK8GBYi+whRpXhzjqqvJ+1OGplR8lNbxVrMhLnyC8P4VE3DBG
	 Qrnn+KGnLme9My5/dRSoa9koUYmkckA+p6flC828=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Heidelberg <david@ixit.cz>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0181/1756] ASoC: wcd-mbhc-v2: Fix incorrect properties names and typos
Date: Wed, 18 Nov 2026 15:38:28 +0100
Message-ID: <20261118150015.633837281@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150007.957976754@linuxfoundation.org>
References: <20261118150007.957976754@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index d589a212b7688..bfd20303c9cc5 100644
--- a/sound/soc/codecs/wcd-mbhc-v2.c
+++ b/sound/soc/codecs/wcd-mbhc-v2.c
@@ -865,7 +865,7 @@ static int wcd_measure_adc_continuous(struct wcd_mbhc *mbhc)
 	u8 adc_en;
 
 	/* Pre-requisites for ADC continuous measurement */
-	/* Read legacy electircal detection and disable */
+	/* Read legacy electrical detection and disable */
 	wcd_mbhc_write_field(mbhc, WCD_MBHC_ELECT_SCHMT_ISRC, 0x00);
 	/* Set ADC to continuous measurement */
 	wcd_mbhc_write_field(mbhc, WCD_MBHC_ADC_MODE, 1);
@@ -966,7 +966,7 @@ static int wcd_check_cross_conn(struct wcd_mbhc *mbhc)
 	if (wcd_mbhc_read_field(mbhc, WCD_MBHC_HPH_PA_EN))
 		return -EINVAL;
 
-	/* Read legacy electircal detection and disable */
+	/* Read legacy electrical detection and disable */
 	elect_ctl = wcd_mbhc_read_field(mbhc, WCD_MBHC_ELECT_SCHMT_ISRC);
 	wcd_mbhc_write_field(mbhc, WCD_MBHC_ELECT_SCHMT_ISRC, 0);
 
@@ -1472,14 +1472,14 @@ int wcd_dt_parse_mbhc_data(struct device *dev, struct wcd_mbhc_config *cfg)
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



