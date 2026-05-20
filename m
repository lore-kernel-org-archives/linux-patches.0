Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6375A3BED1E;
	Wed, 20 May 2026 16:41:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779295307; cv=none; b=MufT8bC6CpSB6VTC4QTUsoTne7/0FZKwjMFPu4aBsQGeER+41epSkIrWzPGvQlLCWUMO7GFVdwBMjOTCmCsbjmCszjHGb9dBuVRnZf7rDDT2nGJo+ge1HRLPG92cTW6iNGzdhdtNn4OyD+UHdJPChsTDYia7oDIoYCJrdaMqeYA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779295307; c=relaxed/simple;
	bh=822Et5abSHBgBbB0lOSJHCBYsWDiKjjpzySdYhoKgMM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tXnNL7ggXkXpDEBSB6iscjMGrO1SFckgD6VA5jJVMKNV10bauQjwq7pu4XcADWPjvNDPv4xw6FG837rHksoSzIPFWPWT0mwcdyo1Hdcmyj+TPX8CD+qPQG5G1uIKlZo4SFOl0+CvaMCmIVy/84HHQvmSqrYasRUvZ1WTZjgD0Xc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=okuALz4C; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="okuALz4C"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C363D1F000E9;
	Wed, 20 May 2026 16:41:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779295306;
	bh=GwmI+Hob7LI7Ys8LrfJbAR9RmXndStvHSydLgU/12tw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=okuALz4CNCzjnVf72/z0xv1ZG83cB/jbmm2k/pr+ogeHZVxrD/Y7NsfDDjNkuqQLP
	 5ew9zy0PjiYRgTms6jL6C57+vGAjoT2HAL8BNcQPhQpx3erQZMHmRjWj62DK/5fEg9
	 AfKpxQ1n4+rb8LuRHICLn2T8Xg6qtWWTk+tf4NTU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shengjiu Wang <shengjiu.wang@nxp.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 0369/1146] ASoC: fsl_micfil: Add access property for "VAD Detected"
Date: Wed, 20 May 2026 18:10:19 +0200
Message-ID: <20260520162156.552257474@linuxfoundation.org>
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
index d6cde2757c6d5..79850211742cb 100644
--- a/sound/soc/fsl/fsl_micfil.c
+++ b/sound/soc/fsl/fsl_micfil.c
@@ -503,7 +503,13 @@ static const struct snd_kcontrol_new fsl_micfil_snd_controls[] = {
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



