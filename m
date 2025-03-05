Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 942C82512D7;
	Wed,  5 Mar 2025 17:51:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741197106; cv=none; b=ld8eiPw1bLp+/O1rN4NWaa+lq3V3aSh+E98c3E1UkqdbDZ8w7tvQNJO95otAcmKEVtx581N8uBBLBTl/VODZeSG0tHAA/p5FZ7/VhQ0PD9SgZXLIkZyid0QN/StQCD7zeVt2JO1K0oJyEEWFMCC0dGnPPdrwTY1u//oFkZnI2fY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741197106; c=relaxed/simple;
	bh=mg/z/+ckuZZDfUd4htDVOVw+2Hb8F3XkxG3Jg/1+y00=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BE90SfWa8PuCjdelE+8MBt/FQ6jRn/D2s4cbwZvP4q4fwKY3Ooo+8mwJEXw1e8Cntm+ck9TyDoQUNE6gm1OyVVZ0owSx2evYbmmvRusBvPJuLcV2nSSMo8YG6pAiYVFAqv5BcRy7l1a3/bznBaUSuykWEkDJcY9Ylg4jb+shB8k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fbxuJaGR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fbxuJaGR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1CA7CC4CEE0;
	Wed,  5 Mar 2025 17:51:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741197106;
	bh=mg/z/+ckuZZDfUd4htDVOVw+2Hb8F3XkxG3Jg/1+y00=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fbxuJaGRTFg/7APNcYDs2RYzq9KWZjY1XeXdy7jpT0cUWjQOVjVlNLaryla6Zya8G
	 26MjBMpNDRnUN3nS5/yEBQtfeYj5gnzZKjoZ143SR9c2GB3/mBNEcICo86Xe3xRq0L
	 8ZT1gmBaRrFeyHTKjpWODS39wh+VExkolx7yn4Vc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	John Keeping <jkeeping@inmusicbrands.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 042/176] ASoC: rockchip: i2s-tdm: fix shift config for SND_SOC_DAIFMT_DSP_[AB]
Date: Wed,  5 Mar 2025 18:46:51 +0100
Message-ID: <20250305174507.156270866@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250305174505.437358097@linuxfoundation.org>
References: <20250305174505.437358097@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: John Keeping <jkeeping@inmusicbrands.com>

[ Upstream commit 6b24e67b4056ba83b1e95e005b7e50fdb1cc6cf4 ]

Commit 2f45a4e289779 ("ASoC: rockchip: i2s_tdm: Fixup config for
SND_SOC_DAIFMT_DSP_A/B") applied a partial change to fix the
configuration for DSP A and DSP B formats.

The shift control also needs updating to set the correct offset for
frame data compared to LRCK.  Set the correct values.

Fixes: 081068fd64140 ("ASoC: rockchip: add support for i2s-tdm controller")
Signed-off-by: John Keeping <jkeeping@inmusicbrands.com>
Link: https://patch.msgid.link/20250204161311.2117240-1-jkeeping@inmusicbrands.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/rockchip/rockchip_i2s_tdm.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/sound/soc/rockchip/rockchip_i2s_tdm.c b/sound/soc/rockchip/rockchip_i2s_tdm.c
index d20438cf8fc4a..ff743ba0a9441 100644
--- a/sound/soc/rockchip/rockchip_i2s_tdm.c
+++ b/sound/soc/rockchip/rockchip_i2s_tdm.c
@@ -453,11 +453,11 @@ static int rockchip_i2s_tdm_set_fmt(struct snd_soc_dai *cpu_dai,
 			break;
 		case SND_SOC_DAIFMT_DSP_A:
 			val = I2S_TXCR_TFS_TDM_PCM;
-			tdm_val = TDM_SHIFT_CTRL(0);
+			tdm_val = TDM_SHIFT_CTRL(2);
 			break;
 		case SND_SOC_DAIFMT_DSP_B:
 			val = I2S_TXCR_TFS_TDM_PCM;
-			tdm_val = TDM_SHIFT_CTRL(2);
+			tdm_val = TDM_SHIFT_CTRL(4);
 			break;
 		default:
 			ret = -EINVAL;
-- 
2.39.5



