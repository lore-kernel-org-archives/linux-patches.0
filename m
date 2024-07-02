Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F316F1514DC;
	Tue,  2 Jul 2024 17:27:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719941280; cv=none; b=JnlGsI02Mv72CI6HcJ8mtbAwVSakSiZVganhe1ZKKWYx8gR3sk1E0B0Unk/LcxGpF/xeXulYd82hDeYn9UpB40CA1fc8w0wG6lm3kXqDCRmuZN1fnTVVaoC9oajHC0bOLKgJtq9gNqq3KbBeUP21If08DEIVDGgs4jYKMMZ8k8Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719941280; c=relaxed/simple;
	bh=8+kwuofvz5G1uV2tyb1n4nntbvFqXdfoMcMuwUmTIuY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ayc0XKAuGQfdcGGS2taoOJmYZuVZEXCPVh8iV+76rpT04xJGNLgfPu2NFHkJFzm4ltaYfueMAeSBfQMaRIT923n94OUvkBvKNGLk8OLGCnDrpAoi7RDrqRXrvPcxZzTSMAo7Vinj7SxgLgSQg9qB+mIzkqBiGGJJCPQyuiA87sg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QUVbQz/T; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QUVbQz/T"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 65C25C116B1;
	Tue,  2 Jul 2024 17:27:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1719941279;
	bh=8+kwuofvz5G1uV2tyb1n4nntbvFqXdfoMcMuwUmTIuY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QUVbQz/TeQ3K5P8oB31oZH1jllzZHSLcJUBZzl6XiGbe25sgXO8VfWOyGCUM+iFDz
	 swPnZEfGApBC8b02HM1xXDcQB3O9u5Mw/TMYHtnSbNGdEcdwDKwQ7Sx8X6pDSt6GIv
	 F8BvDGaYCT/AhvZkHW7RzbqomXBJby72n3cLezMQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vijendar Mukunda <Vijendar.Mukunda@amd.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 018/128] ASoC: amd: acp: remove i2s configuration check in acp_i2s_probe()
Date: Tue,  2 Jul 2024 19:03:39 +0200
Message-ID: <20240702170226.920261596@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240702170226.231899085@linuxfoundation.org>
References: <20240702170226.231899085@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Vijendar Mukunda <Vijendar.Mukunda@amd.com>

[ Upstream commit 70fa3900c3ed92158628710e81d274e5cb52f92b ]

ACP supports different pin configurations for I2S IO. Checking ACP pin
configuration value against specific value breaks the functionality for
other I2S pin configurations. This check is no longer required in i2s dai
driver probe call as i2s configuration check will be verified during acp
platform device creation sequence.
Remove i2s_mode check in acp_i2s_probe() function.

Fixes: b24484c18b10 ("ASoC: amd: acp: ACP code generic to support newer platforms")
Signed-off-by: Vijendar Mukunda <Vijendar.Mukunda@amd.com>
Link: https://msgid.link/r/20240617072844.871468-2-Vijendar.Mukunda@amd.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/amd/acp/acp-i2s.c | 8 --------
 1 file changed, 8 deletions(-)

diff --git a/sound/soc/amd/acp/acp-i2s.c b/sound/soc/amd/acp/acp-i2s.c
index ac416572db0d3..3c78207f9ad9d 100644
--- a/sound/soc/amd/acp/acp-i2s.c
+++ b/sound/soc/amd/acp/acp-i2s.c
@@ -537,20 +537,12 @@ int asoc_acp_i2s_probe(struct snd_soc_dai *dai)
 {
 	struct device *dev = dai->component->dev;
 	struct acp_dev_data *adata = dev_get_drvdata(dev);
-	struct acp_resource *rsrc = adata->rsrc;
-	unsigned int val;
 
 	if (!adata->acp_base) {
 		dev_err(dev, "I2S base is NULL\n");
 		return -EINVAL;
 	}
 
-	val = readl(adata->acp_base + rsrc->i2s_pin_cfg_offset);
-	if (val != rsrc->i2s_mode) {
-		dev_err(dev, "I2S Mode not supported val %x\n", val);
-		return -EINVAL;
-	}
-
 	return 0;
 }
 EXPORT_SYMBOL_NS_GPL(asoc_acp_i2s_probe, SND_SOC_ACP_COMMON);
-- 
2.43.0



