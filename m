Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 594E51A76A5;
	Tue, 30 Jul 2024 17:31:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722360694; cv=none; b=n1ZdMYw10vjwy9fpj4dBFOgEcSVK7UqtmCAuNwevG7maEhvCYtcw/SIcZoOijZpjQrODu2M/11eBtr1roomflyEO2V+roy7E4H/slfjLe9ZQAuaRz39QPz1Ivu3nhSI5ksvU0+z0ibytHsx6t0OtG7cBGaooX0DmoXf3lweL9C4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722360694; c=relaxed/simple;
	bh=/W8t4e3FRhH4xgOjx0E0L/xGfLmdAjE4bFGftQEQd3E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=M8ElRC1xl31gdLOZn48z8dV5FrOExZ9gyIhPFWw0vjCBMXe9BSuslJqBu4kysU9AGqwINEc/q4RDrigrubpqSuNBl7nikCn898vVbIfmq/RIb6J/NHBYsvdrrx4j+ElZoyswo83RW8+qKu2naM5s+tJyPRwSEsVjUOcgQ/Cc7zM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ImaC3c+Q; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ImaC3c+Q"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4AF41C4AF0A;
	Tue, 30 Jul 2024 17:31:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722360694;
	bh=/W8t4e3FRhH4xgOjx0E0L/xGfLmdAjE4bFGftQEQd3E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ImaC3c+Q2QScI9TGWE64lPr0cMpuWj55/MdUB/PICmmvuDkFFhS4FXkdQdjI51pB6
	 uV38ODPiDvuJBGQhnZnueAQt1rCI4asjgrU4USINuEQ0S6xHAJ5dT6SSgzSTgAwVOt
	 0RDXr17fZM/J+L1hrR38x2a93GSOmw77tOnC3DAg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daniel Baluta <daniel.baluta@nxp.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 778/809] ASoC: SOF: imx8m: Fix DSP control regmap retrieval
Date: Tue, 30 Jul 2024 17:50:54 +0200
Message-ID: <20240730151755.695747138@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151724.637682316@linuxfoundation.org>
References: <20240730151724.637682316@linuxfoundation.org>
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

From: Daniel Baluta <daniel.baluta@nxp.com>

[ Upstream commit 2634f745eac25a33f032df32cf98fca8538a534a ]

According to Documentation/devicetree/bindings/dsp/fsl,dsp.yaml
fsl,dsp-ctrl is a phandle to syscon block so we need to use correct
function to retrieve it.

Currently there is no SOF DSP DTS merged into mainline so there is no
need to support the old way of retrieving the dsp control node.

Fixes: 9ba23717b292 ("ASoC: SOF: imx8m: Implement DSP start")
Signed-off-by: Daniel Baluta <daniel.baluta@nxp.com>
Link: https://patch.msgid.link/20240715151653.114751-1-daniel.baluta@oss.nxp.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/sof/imx/imx8m.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/sound/soc/sof/imx/imx8m.c b/sound/soc/sof/imx/imx8m.c
index 1c7019c3cbd38..cdd1e79ef9f6a 100644
--- a/sound/soc/sof/imx/imx8m.c
+++ b/sound/soc/sof/imx/imx8m.c
@@ -234,7 +234,7 @@ static int imx8m_probe(struct snd_sof_dev *sdev)
 	/* set default mailbox offset for FW ready message */
 	sdev->dsp_box.offset = MBOX_OFFSET;
 
-	priv->regmap = syscon_regmap_lookup_by_compatible("fsl,dsp-ctrl");
+	priv->regmap = syscon_regmap_lookup_by_phandle(np, "fsl,dsp-ctrl");
 	if (IS_ERR(priv->regmap)) {
 		dev_err(sdev->dev, "cannot find dsp-ctrl registers");
 		ret = PTR_ERR(priv->regmap);
-- 
2.43.0



