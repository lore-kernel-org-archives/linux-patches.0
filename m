Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2639B1BE22B;
	Tue,  2 Jul 2024 17:19:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719940755; cv=none; b=cA+cg6liaDJycP32i0XeG3wYqnOqox+qqwGlDuP+C2wkOyamg75LjKMETJCxvXR4FNNHjc4RWbiqKzDIiuxoprwXl6eU2aZ9EGm+6jbch6vx6MUc0AguTiqNpxLfeEhk3l/rYQyMawyIDK/u6K2W9kgV1Z+JJJp7QzbEe2nt+HI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719940755; c=relaxed/simple;
	bh=41Y4utmzgFHtOyp00YLABO+k55YJZo1pADXLsNqkmJ4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=b9lHbsnczRybQRcnltHzN7bI3Orh61+6X0mCrQvKs1JvlGAUpcYmawi1IaGslFkIsZ98mNBoG68yqJzSAUzLJ5WRDQnznCPw6a3vpE2p8weLhho/jZWK3YQA/GY99pnBazf2kU2Wpt6Ny8nZTYmu/MYL9lPfI6DYOeuN/KpFveE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EnonkZb9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EnonkZb9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 547F7C116B1;
	Tue,  2 Jul 2024 17:19:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1719940754;
	bh=41Y4utmzgFHtOyp00YLABO+k55YJZo1pADXLsNqkmJ4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EnonkZb9dNMnDwuV2gHz6qsazKceY2NMoJjUBtiV3k0+McleErj62P5OiIIqaI7l6
	 Og/4SrkH+kd/eyXAe1UJH/TlVpX/qlHMDN5/A6Qpke8W7/j2L6XshEP5Lq9GZxesnY
	 LFvyCJ6oamiEh5V/l/SYOcxChGfibapF7t3gPzdI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vijendar Mukunda <Vijendar.Mukunda@amd.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 026/163] ASoC: amd: acp: remove i2s configuration check in acp_i2s_probe()
Date: Tue,  2 Jul 2024 19:02:20 +0200
Message-ID: <20240702170234.049384933@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240702170233.048122282@linuxfoundation.org>
References: <20240702170233.048122282@linuxfoundation.org>
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
index df350014966a0..cf2fdde5aaa18 100644
--- a/sound/soc/amd/acp/acp-i2s.c
+++ b/sound/soc/amd/acp/acp-i2s.c
@@ -543,20 +543,12 @@ static int acp_i2s_probe(struct snd_soc_dai *dai)
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
 
-- 
2.43.0



