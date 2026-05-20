Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 212C4371CEA;
	Wed, 20 May 2026 18:34:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779302092; cv=none; b=mRU2nl2+DoK8stCq7gzIIbYYaJpsto2lhun2BH4XJp3NapyDidBnstA8UnQCXoQxpQJhyX8xkaCEQ19g1hKedWXh4lNKnCYWL7JpzJkgV7Y7UqpM9IlIje929cYPyqt9sGhRNmwnw717Syzit4dhVuAglzble5InP6C/WEEGb1Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779302092; c=relaxed/simple;
	bh=EmD3luPsTEmtgKgygohDGCBKG2aftB11lvEmM1N2WLo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hYmFk3p6tj9aIdrmv7NO06ztT5Rmb1wliQRNY2H6moCJwF5HwiVxl8EG77eIemPYCmx6kLb6MTb7+wcb5fYpir0pICYbFgzvJH0b1zjOx3v4X3GoDOQi4NyVm2IX2bMeCVp7GxFEfD5c8V3pk8jlUhoBPtbSU8SarvxZ562yqJA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kjwkahqO; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kjwkahqO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3F58A1F0089C;
	Wed, 20 May 2026 18:34:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779302090;
	bh=7mHx4ByVksZfhiIe0DGg8atFNERwRYo/0ZfBohGSA+g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=kjwkahqOpv7opQ1zL5yfyDODj3SixofTnkXi8BWFItiKK2ThENvTqan68D4s6Itia
	 2X3ktfWjlYov43JshuGZOtUqZpigyjB06ctYKxGx6LxuRWHjxItJGBz+oKQGoOMtqw
	 e/fxJRrj+DjU5//vRsMb0SSCwpc3M3mVdExVVb9g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shengjiu Wang <shengjiu.wang@nxp.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 136/508] ASoC: fsl_micfil: Add access property for "VAD Detected"
Date: Wed, 20 May 2026 18:19:19 +0200
Message-ID: <20260520162101.576528794@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162058.573354582@linuxfoundation.org>
References: <20260520162058.573354582@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 80ff1d1359f64..56ee7cbf371c1 100644
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



