Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D122A331220;
	Wed, 20 May 2026 18:08:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779300502; cv=none; b=ESxTc76akisDL/SyFu/N2MncA843w7mkToBtjBnSKGzcD7lh8Nr+Hr34sVDqSnDdzuZOYyuADeR/kDU3LSf9ydPuc8Bfu/Vuc5UeQunIL7ASaBX29t9AxVZuMM7yKJ2vGm1KYs0S9EWvtrjlaSTfjxLf9quH7xaP8tMw5IKZGEM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779300502; c=relaxed/simple;
	bh=5+5lBUnpPJ33s6CHKz0EhIICF+gaAouJfioEq9JzeDc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Etbk2Ol0mrKs3XEDKusL926nuK1skvv9nG4TnCo9tSaNSc1zssCqGeRon+pzts76QlN7SMIJ7j0U09EZJD7qXkSaqy8fgIFyymzNwFsGoHd2bV/dbI06FRwrCcabDoya7yy8AdaVwNZoRnpYCphbr3ZO/1ZTd+SpSt/Mzpb82tA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=F6oFILFW; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="F6oFILFW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 40AC21F000E9;
	Wed, 20 May 2026 18:08:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779300501;
	bh=GWRPbIY2g5ks5bIM+rpS9BiE9Rxp13kLslrFY7GuwFM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=F6oFILFW79sCnEPtqPMilrdpalPxl80r65Pe4lYwredV1OvrmaKfI3PUnASDWdsfg
	 EvpEA6WBSQfAX8AkG5LXgoozKMPG7ZgqZnllDLMeLVBTd2ddIWp4qeAfsQDfdbXDv+
	 1sn5QbSfrfesAbIUfzacdaYAY7zaLc/vvLfACsUE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shengjiu Wang <shengjiu.wang@nxp.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 198/666] ASoC: fsl_micfil: Add access property for "VAD Detected"
Date: Wed, 20 May 2026 18:16:49 +0200
Message-ID: <20260520162115.494684579@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162111.222830634@linuxfoundation.org>
References: <20260520162111.222830634@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Shengjiu Wang <shengjiu.wang@nxp.com>

[ Upstream commit c7661bfc7422443df394c01e069ae4e5c3a7f04c ]

Add access property SNDRV_CTL_ELEM_ACCESS_READ for control "VAD
Detected", which doesn't support put operation, otherwise there will be
issue with mixer-test.

Fixes: 29dbfeecab85 ("ASoC: fsl_micfil: Add Hardware Voice Activity Detector support")
Signed-off-by: Shengjiu Wang <shengjiu.wang@nxp.com>
Link: https://patch.msgid.link/20260401094226.2900532-2-shengjiu.wang@nxp.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/fsl/fsl_micfil.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/sound/soc/fsl/fsl_micfil.c b/sound/soc/fsl/fsl_micfil.c
index 7cfe77b57b3c2..a52e30aa6e086 100644
--- a/sound/soc/fsl/fsl_micfil.c
+++ b/sound/soc/fsl/fsl_micfil.c
@@ -395,7 +395,13 @@ static const struct snd_kcontrol_new fsl_micfil_snd_controls[] = {
 	SOC_SINGLE("HWVAD ZCD Adjustment", REG_MICFIL_VAD0_ZCD, 8, 15, 0),
 	SOC_SINGLE("HWVAD ZCD And Behavior Switch",
 		   REG_MICFIL_VAD0_ZCD, 4, 1, 0),
-	SOC_SINGLE_BOOL_EXT("VAD Detected", 0, hwvad_detected, NULL),
+	{
+		.iface = SNDRV_CTL_ELEM_IFACE_MIXER,
+		.access = SNDRV_CTL_ELEM_ACCESS_READ | SNDRV_CTL_ELEM_ACCESS_VOLATILE,
+		.name = "VAD Detected",
+		.info = snd_soc_info_bool_ext,
+		.get = hwvad_detected,
+	},
 };
 
 static int fsl_micfil_use_verid(struct device *dev)
-- 
2.53.0



