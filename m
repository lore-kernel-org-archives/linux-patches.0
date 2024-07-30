Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B27D1A76B3;
	Tue, 30 Jul 2024 17:17:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722359873; cv=none; b=E4UX8gW6B3R2XcXdTaiySf41/CY6MANX2nQhwI6/Qx4Awt0qESVDJVipKbRFnyhNLX9ibnyPyfMbwW6EypEHNG6YxdSpdplFl1qmQELIO0Px5W7XZQSWKaOfVpEaOJkoK3HRlOueuI9oixJaAhg32tLA+jwFTdQ3YYNNpxQYv/s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722359873; c=relaxed/simple;
	bh=Larc2o8tF49U2YvkTY1beXt8aeLZiGkcVraLxiCSLBw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fQEE7JM5ZqeMCIiowJjxgwzBfl04C5LU3soqXBSqsCjX2a9Qw0yM4XZfAWAWVl0gcwzIRAspuHJCiwCRbOx+g1gnEvfGzITgNgPLtEgJXY/FC1gY2PgeykhwSUarEfay5qB2acFBcKRSWqx2JFYysvvEh+7kFYHCgou6PoU8woE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PCeSpqmC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PCeSpqmC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 706E4C32782;
	Tue, 30 Jul 2024 17:17:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722359872;
	bh=Larc2o8tF49U2YvkTY1beXt8aeLZiGkcVraLxiCSLBw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PCeSpqmCKOdZMD12bDAgBDgZINZxNkxznu/nz6Cv1XztGNvVOulBf5w0I/0aYDe69
	 DDGz3GsnF1kPP8srG6gliC41V1bKW4s7WYsoB/cp3uxKZyLPLKFBpROM/ihfvMBGT0
	 aM4Kf53C40xbaDN76d8coIHZj7wCEmu5UVUHpPbk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daniel Baluta <daniel.baluta@nxp.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 549/568] ASoC: SOF: imx8m: Fix DSP control regmap retrieval
Date: Tue, 30 Jul 2024 17:50:56 +0200
Message-ID: <20240730151701.620115816@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151639.792277039@linuxfoundation.org>
References: <20240730151639.792277039@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 1243f8a6141ea..186ba4bbb5b26 100644
--- a/sound/soc/sof/imx/imx8m.c
+++ b/sound/soc/sof/imx/imx8m.c
@@ -243,7 +243,7 @@ static int imx8m_probe(struct snd_sof_dev *sdev)
 	/* set default mailbox offset for FW ready message */
 	sdev->dsp_box.offset = MBOX_OFFSET;
 
-	priv->regmap = syscon_regmap_lookup_by_compatible("fsl,dsp-ctrl");
+	priv->regmap = syscon_regmap_lookup_by_phandle(np, "fsl,dsp-ctrl");
 	if (IS_ERR(priv->regmap)) {
 		dev_err(sdev->dev, "cannot find dsp-ctrl registers");
 		ret = PTR_ERR(priv->regmap);
-- 
2.43.0



