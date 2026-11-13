Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794585579;
	b=QLs/q3l3OgVmge9WSnjI+Vm6lVkNimbwVCLYh8YQ+8pfRCzwtfnSepGH6H+w8qRAMnQl
	 UeZzKTyMNXqt21Nj6k4kiVTD/7JapO3239uRhhAJ8NQQStYQI4E6Wug8YUnGLn5BA90m0
	 n/4gB1SnCLv2mPz+MBx/oUwtnAgbkLUBk7GntOmCSMyWtxPfhZqPckuvVhMGOnqKhcAHX
	 Jp7+2R73Vw1bSIuvysbdqCJwBuOrx18/FM0Y1ww2Ot0N26A+FUrXiQttkVElM8dbh+i04
	 zkkhrjHPUmwYF2GivBTq9cwXhLwF7ZhOnOwhVhzGUuUJx49QfM7lz9JynjeGtI1+A7w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794585579;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=M78a6RkxpYPf+ikbUXyeQiEadt4TIQWET+9ydtRFqEo=;
	b=HfaGpA+klIFQq2VMwWbP9JjIvMlK6p1YM1+ATJjTU5loXYgQj3yHHsB/j1BzOcIHSOet
	 UHUAs1HyAFlSwDYxb6vgMyYZO3wG3PUxfqQtgz5sAKIlyOop7pjOPFZ2vh3tVXGu2RxWx
	 QlwPGOpgllz9/SrkiSbSeOqXXuKzFF1uH8Dp9O3PhhGLlPttoqp50Dws3NxGNdEXyZeup
	 Dzh7ZUb0pO34WdX80CCaFsr/JDjmKldlH7R4AAcO85bMhOMBy3TGgtGPf2oI7LQqr8fVY
	 m/c6kZjglF4nyf1tjytNWnvujz2MpaTCmEfxFSf9w7y2N3B4OtphHzbvvlRVNf+eI5Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=0r4JtRqk;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F413606EA84;
	Fri, 13 Nov 2026 15:59:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=0r4JtRqk
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EEFC91F000C6;
	Fri, 13 Nov 2026 15:59:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794585579;
	bh=M78a6RkxpYPf+ikbUXyeQiEadt4TIQWET+9ydtRFqEo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=0r4JtRqkZ1L2mVy2jPH1eUVXKxaPT2oYfwoXuWAuXxZtitkSRiBAq8pSxdccJwveT
	 2kkxSH9/+318ZQB8P4uG6CzcVEwWuYwDFMyPAt8+MePkD1/HQ0PsPf79fj/gK4Wrj5
	 V9sAZZXCrRIdsxrEi0npTi8KQpKiP3S9hm6REYN4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	James Calligeros <jcalligeros99@gmail.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 211/507] ASoC: tas2770: Fix error detection in tas2770_set_dai_tdm_idle
Date: Fri, 13 Nov 2026 10:48:35 -0500
Message-ID: <20261113153801.639075035@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153753.358973689@linuxfoundation.org>
References: <20261113153753.358973689@linuxfoundation.org>
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

From: James Calligeros <jcalligeros99@gmail.com>

[ Upstream commit f65f866dacbb10a37e4fae4076627c767afd3cbb ]

snd_soc_component_update_bits returns 1 on a successful update, and
we were returning from tas2770_set_dai_tdm_idle early on any nonzero
return code. Change this so that only negative return codes are
treated as errors.

Fixes: af176d0787d2 ("ASoC: tas2770: expose SDOUT bus keeper via set_tdm_idle")
Cc: stable@vger.kernel.org
Signed-off-by: James Calligeros <jcalligeros99@gmail.com>
Link: https://patch.msgid.link/20261025-tas2770-idle-fix-v2-1-6c8096a87f44@gmail.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/tas2770.c | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/sound/soc/codecs/tas2770.c b/sound/soc/codecs/tas2770.c
index e79754edac5ca..355fcbfd01c79 100644
--- a/sound/soc/codecs/tas2770.c
+++ b/sound/soc/codecs/tas2770.c
@@ -513,7 +513,7 @@ static int tas2770_set_dai_tdm_idle(struct snd_soc_dai *dai,
 		ret = snd_soc_component_update_bits(component, TAS2770_DIN_PD,
 						    TAS2770_DIN_PD_SDOUT,
 						    TAS2770_DIN_PD_SDOUT);
-		if (ret)
+		if (ret < 0)
 			return ret;
 
 		break;
@@ -521,12 +521,12 @@ static int tas2770_set_dai_tdm_idle(struct snd_soc_dai *dai,
 		ret = snd_soc_component_update_bits(component, TAS2770_TDM_CFG_REG4,
 						    TAS2770_TDM_CFG_REG4_TX_KEEPER,
 						    TAS2770_TDM_CFG_REG4_TX_KEEPER);
-		if (ret)
+		if (ret < 0)
 			return ret;
 
 		ret = snd_soc_component_update_bits(component, TAS2770_TDM_CFG_REG4,
 						    TAS2770_TDM_CFG_REG4_TX_FILL, 0);
-		if (ret)
+		if (ret < 0)
 			return ret;
 
 		break;
@@ -534,25 +534,25 @@ static int tas2770_set_dai_tdm_idle(struct snd_soc_dai *dai,
 		ret = snd_soc_component_update_bits(component, TAS2770_TDM_CFG_REG4,
 						    TAS2770_TDM_CFG_REG4_TX_KEEPER,
 						    TAS2770_TDM_CFG_REG4_TX_KEEPER);
-		if (ret)
+		if (ret < 0)
 			return ret;
 
 		ret = snd_soc_component_update_bits(component, TAS2770_TDM_CFG_REG4,
 						    TAS2770_TDM_CFG_REG4_TX_FILL,
 						    TAS2770_TDM_CFG_REG4_TX_FILL);
-		if (ret)
+		if (ret < 0)
 			return ret;
 
 		break;
 	case SND_SOC_DAI_TDM_IDLE_OFF:
 		ret = snd_soc_component_update_bits(component, TAS2770_DIN_PD,
 						    TAS2770_DIN_PD_SDOUT, 0);
-		if (ret)
+		if (ret < 0)
 			return ret;
 
 		ret = snd_soc_component_update_bits(component, TAS2770_TDM_CFG_REG4,
 						    TAS2770_TDM_CFG_REG4_TX_KEEPER, 0);
-		if (ret)
+		if (ret < 0)
 			return ret;
 
 		break;
-- 
2.53.0



