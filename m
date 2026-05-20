Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AEF243D5642;
	Wed, 20 May 2026 16:42:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779295333; cv=none; b=MQuv7f/xBv5j1Tw8So/sQ6dxsGoK/FRxVus57D/tl0L3F2Ht0DI2SvQmnMxm7qxC/yCT8kmeIe8o917GIm7pbEusg3iBErF/WLNPhh9bBUKautm5hBCif0pClGLOaJs2b867rsb43Ip768xdqIH/ekDKDVl6iRCWrypXINbR4ec=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779295333; c=relaxed/simple;
	bh=JROfA1W7rjHXmyiKPRcPdB0wIlW3eewMZGc9Hht6m3w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ArSTlg/uGRRQa1HVmeIdwq232trbPme0NB1Z2pMxuZgERAHn20WzxICrk9IV5EuzLDznVwuDV7SFYcpydCkpBryAGskcWf1RIA64npghZt9xf2P0ky2JeLActZeYx+eWDcnkGv4UH/Awpp/b/dqURAoWSyMc64eE6OzHMzHYY9g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JOrpSnZs; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JOrpSnZs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 207191F000E9;
	Wed, 20 May 2026 16:42:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779295332;
	bh=V7svvq1T2ddm8I37rhOZvyvRQOM0s8oUZ0Qlus/rkcs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=JOrpSnZsSNYonmhJf0m/g0izVEZVXMHG0KWFUIDHYwmLP5cd8tiQy1HCkcGQBtKjr
	 GxboFOFwarlhKrJOQ5DTSvy43bvTYNu4PwO0SnPU/VCZ/a9qH6Wbpl3S6gnBJlq1ka
	 AjK9cWh912M5RqGJTJpiVnOTvgUz7VMZYyN1urh0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shengjiu Wang <shengjiu.wang@nxp.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 0378/1146] ASoC: fsl_easrc: Fix value type in fsl_easrc_iec958_get_bits()
Date: Wed, 20 May 2026 18:10:28 +0200
Message-ID: <20260520162156.755396297@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162148.390695140@linuxfoundation.org>
References: <20260520162148.390695140@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Shengjiu Wang <shengjiu.wang@nxp.com>

[ Upstream commit aa21fe4a81458cf469c2615b08cbde5997dde25a ]

The value type of controls "Context 0 IEC958 Bits Per Sample" should be
integer, not enumerated, the issue is found by the mixer-test.

Fixes: 955ac624058f ("ASoC: fsl_easrc: Add EASRC ASoC CPU DAI drivers")
Signed-off-by: Shengjiu Wang <shengjiu.wang@nxp.com>
Link: https://patch.msgid.link/20260401094226.2900532-11-shengjiu.wang@nxp.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/fsl/fsl_easrc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/sound/soc/fsl/fsl_easrc.c b/sound/soc/fsl/fsl_easrc.c
index f48e43a0edcfc..3086cb758beb6 100644
--- a/sound/soc/fsl/fsl_easrc.c
+++ b/sound/soc/fsl/fsl_easrc.c
@@ -73,7 +73,7 @@ static int fsl_easrc_iec958_get_bits(struct snd_kcontrol *kcontrol,
 	struct soc_mreg_control *mc =
 		(struct soc_mreg_control *)kcontrol->private_value;
 
-	ucontrol->value.enumerated.item[0] = easrc_priv->bps_iec958[mc->regbase];
+	ucontrol->value.integer.value[0] = easrc_priv->bps_iec958[mc->regbase];
 
 	return 0;
 }
-- 
2.53.0



