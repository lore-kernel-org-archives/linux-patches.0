Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F2D5B16D9B8;
	Mon, 12 Aug 2024 16:30:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723480258; cv=none; b=BnmSSAqanfSTxL8EvMTPwhYrnJ9xyzjzNAHBt6LPemL6yiSRQkUidVZA0UF1drFsqxV/4/CNqLe6Ro2um+gHPpAstSVFXSi0JYchmByzFzLYYY6Mp5u1VpUcD115qpgyWP+Y6vYkCoRIuj9XbWju+shHdDYqCAqem+Ueq1aK+DU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723480258; c=relaxed/simple;
	bh=iWY3Oq3W6Frqm/NCj2EJ4PUiTsUV1STMY0SWOfwliKA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=b1D1l+OyRbSt7Rdzpsi0C9qALajTLdMdxbY+LZyHw/3eREilO9UMxCT70wLvsDbb9neo5uLyRluSBHk8UNIYNOFypyUnWlz3PZtOdH+8cisXVCwv4pBDgxS0j7DHVsjAmpQIz4uahQbOeOpupWHDe+x9bpKIaSjvn3hOhURvsrw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rnF7J2xC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rnF7J2xC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 63CBAC32782;
	Mon, 12 Aug 2024 16:30:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723480257;
	bh=iWY3Oq3W6Frqm/NCj2EJ4PUiTsUV1STMY0SWOfwliKA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rnF7J2xCiW1P16uZDTcILtVTVk3EUhZiAJMR0rN8JrRxZ92dGciQQ+xEonVYsmG3o
	 GvsoxKDoAaZfoG56oStniCxyRlF+dMOaIRBo764SteAXY5MUwlA8Hj83pp2A6Pjj2a
	 sARHyxQf04SSqICj6F7mNswX5hads1YSCXqBA2QI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
	Srinivas Kandagatla <srinivas.kandagatla@linaro.org>,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	Neil Armstrong <neil.armstrong@linaro.org>
Subject: [PATCH 6.10 142/263] ASoC: codecs: wsa883x: parse port-mapping information
Date: Mon, 12 Aug 2024 18:02:23 +0200
Message-ID: <20240812160151.982776960@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240812160146.517184156@linuxfoundation.org>
References: <20240812160146.517184156@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>

[ Upstream commit 1cf3295bd108abbd7f128071ae9775fd18394ca9 ]

Add support to parse static master port map information from device tree.

Reviewed-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Tested-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Tested-by: Neil Armstrong <neil.armstrong@linaro.org> # on SM8650-HDK
Signed-off-by: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Link: https://patch.msgid.link/20240626-port-map-v2-2-6cc1c5608cdd@linaro.org
Signed-off-by: Mark Brown <broonie@kernel.org>
Stable-dep-of: 6801ac36f256 ("ASoC: codecs: wsa883x: Correct Soundwire ports mask")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/wsa883x.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/sound/soc/codecs/wsa883x.c b/sound/soc/codecs/wsa883x.c
index a2e86ef7d18f5..5443a5c4100c0 100644
--- a/sound/soc/codecs/wsa883x.c
+++ b/sound/soc/codecs/wsa883x.c
@@ -1399,6 +1399,14 @@ static int wsa883x_probe(struct sdw_slave *pdev,
 	wsa883x->sconfig.direction = SDW_DATA_DIR_RX;
 	wsa883x->sconfig.type = SDW_STREAM_PDM;
 
+	/**
+	 * Port map index starts with 0, however the data port for this codec
+	 * are from index 1
+	 */
+	if (of_property_read_u32_array(dev->of_node, "qcom,port-mapping", &pdev->m_port_map[1],
+					WSA883X_MAX_SWR_PORTS))
+		dev_dbg(dev, "Static Port mapping not specified\n");
+
 	pdev->prop.sink_ports = GENMASK(WSA883X_MAX_SWR_PORTS, 0);
 	pdev->prop.simple_clk_stop_capable = true;
 	pdev->prop.sink_dpn_prop = wsa_sink_dpn_prop;
-- 
2.43.0



