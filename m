Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795019191;
	b=i4a5OTi98H21CmS9icoQp09XAGf9Q0OBot5WJNtcdlDO3fK5YgpXykpjk7iZIyMJod3Q
	 0Uavf8Zqstqe9LXedSVwNJtGmnZWkFPf++KoSAHdSRJtOQmu4VclGUBFTPXumcKs/lH4F
	 1lF8Gq5oijt5fxxwepEM3iKSHw9Z/H9I7UTbcbul3dVF0Gwe9AqOUgZvBBhBs7dfFjJk8
	 CIhdA/f4qgWaccMTqCYUBjr8oUpQwOQT3u8OlUiIK29d9uxf3CQSBBDphAF12eeZa3zz/
	 MuXbUeJMxPMgW5pShulEmvqVxlvyIK2nOlLRBUJrykqcMdBrRUS9vLxi4ASy5MGlvKw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795019191;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=PgScq6OFBd4WgWSdciZ1BCp7Jg3FhXctT4VW6hDLCNc=;
	b=V0D09Twp5hkMpMFlyCIe1O4J0XDT+ccUlK9vdi7dcLLbKbJB+lKBWzF7IEDiX6sBIc1G
	 4B22KUmrMgeAo1g4UmG1U1zX/zjUWGwG2DZohePZX94vntyadrXrLItHpRPiHcs36C5Cy
	 TECiuSH650X9SbW6FW4nS/haIpIZI4JDRBPVuxe9aPnT9lFsHTi1Pjpt/JRnyaCNJBeUH
	 k0646olXtjWqVG5GH+OFmbzNv0C18Xjw+TIUXKME8B3t5x3bBoumc7GbEb/J57sNz0zvR
	 1+YfW5CIAyBunmIkFlznF5I0CfYcCi7XNnXuT+zFilWbmWRa+B0jEyv4es+OWvGMGxQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=mt6Bl80r;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B3340606A320;
	Wed, 18 Nov 2026 16:26:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=mt6Bl80r
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B08851F000C4;
	Wed, 18 Nov 2026 16:26:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795019191;
	bh=PgScq6OFBd4WgWSdciZ1BCp7Jg3FhXctT4VW6hDLCNc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=mt6Bl80rObfK21rTDXxGN6GSxxEK+lF3Dxdu13CsdXvEfAc4EMhsx8tJhtMp4OnU/
	 xZ/pe45YQ1mSJIcBq+kJuOJisEblsCMJc1TzNRjsFSdOAN36BgfqvuY9l6rmU5kwlM
	 Q5JUSuX4YGVsok3ZQk7edPxQN6lVUq59Db8+CgRA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	bui duc phuc <phucduc.bui@gmail.com>,
	Cezary Rojewski <cezary.rojewski@intel.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1508/2651] ASoC: mediatek: mt8365: Handle constraint return value in FE startup
Date: Wed, 18 Nov 2026 15:45:48 +0100
Message-ID: <20261118150342.300214654@linuxfoundation.org>
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

From: bui duc phuc <phucduc.bui@gmail.com>

[ Upstream commit 8de3f4e8e81148dd4cdd19e622d4be1fe07a7f52 ]

snd_pcm_hw_constraint_integer() may return 1, which is then returned
from mt8365_afe_fe_startup(). ASoC only treats 0 as success when marking
the DAI as started, so .shutdown() can be skipped on rollback.

Return 0 explicitly on success.

Fixes: e1991d102bc2 ("ASoC: mediatek: mt8365: Add the AFE driver support")
Signed-off-by: bui duc phuc <phucduc.bui@gmail.com>
Reviewed-by: Cezary Rojewski <cezary.rojewski@intel.com>
Link: https://patch.msgid.link/20261007110858.509341-5-phucduc.bui@gmail.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/mediatek/mt8365/mt8365-afe-pcm.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/sound/soc/mediatek/mt8365/mt8365-afe-pcm.c b/sound/soc/mediatek/mt8365/mt8365-afe-pcm.c
index e9497246f37c0..314235557fdf8 100644
--- a/sound/soc/mediatek/mt8365/mt8365-afe-pcm.c
+++ b/sound/soc/mediatek/mt8365/mt8365-afe-pcm.c
@@ -514,11 +514,14 @@ static int mt8365_afe_fe_startup(struct snd_pcm_substream *substream,
 	snd_soc_set_runtime_hwparams(substream, afe->mtk_afe_hardware);
 
 	ret = snd_pcm_hw_constraint_integer(runtime, SNDRV_PCM_HW_PARAM_PERIODS);
-	if (ret < 0)
+	if (ret < 0) {
 		dev_err(afe->dev, "snd_pcm_hw_constraint_integer failed\n");
+		return ret;
+	}
 
 	mt8365_afe_enable_main_clk(afe);
-	return ret;
+
+	return 0;
 }
 
 static void mt8365_afe_fe_shutdown(struct snd_pcm_substream *substream,
-- 
2.53.0



