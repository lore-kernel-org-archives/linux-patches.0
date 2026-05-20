Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC3C7346E5E;
	Wed, 20 May 2026 17:28:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779298105; cv=none; b=kdKtxAyEuPKH8iCfsRydBvdSmi+ycmquBvxG+H8nqRrYFhTRWkJFp/jSzzQOlSVfVWb1L6fY8OVSRB43SzIjzfgki9pDjoXS4YAsWNBJ0YcqsnOK9KN9AcKuqcfKGZGvHc1ZIIlYYBAQ3A9k6rIsa1l9jbyslNeGqHqURiLYqDM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779298105; c=relaxed/simple;
	bh=nDLrCp1JzZR5/EqQLdwli0qsTbIF5uMUNUyA08SSEi4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=THJjKP/fM7XUxC+eCvl4Yhe6O9Lo8Vt+8WUKXzw1kQGSxJnVrAaKf2KtlcXQ8F4kKPVV5OSg87TiV8tEOO5dJKvA9a00cTX1+S1lrL2RXfh1TcfBVR2AvTT9C/3+LzVEWAD37mwA1aOrB4hLqmVlwJgj+CzpDhuJL9NX51NGTC8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KepRHpxz; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KepRHpxz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3E6E91F000E9;
	Wed, 20 May 2026 17:28:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779298104;
	bh=TcEqDSaKuf2pMP3LLiydQAKalJ3kYo6V9XCcsren9uA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=KepRHpxzdaq9jA65mR0NW9TcnCPXS+ktHMkwjA0BxpkfI/y/6dY+in8ylYVKf7KNT
	 0S+8qykDnKsGs0X8vjfzacyoF8bu253ih3LdBkmZ8jLRQfleka7p9zXbBgGVr+Fqr7
	 CsE+gj+sxhvqJi5aONDirKi7h0nErirVwvrEEFuU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shengjiu Wang <shengjiu.wang@nxp.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 284/957] ASoC: fsl_micfil: Add access property for "VAD Detected"
Date: Wed, 20 May 2026 18:12:47 +0200
Message-ID: <20260520162140.698667577@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162134.554764788@linuxfoundation.org>
References: <20260520162134.554764788@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index cac26ba0aa4b0..ddc56f77f1455 100644
--- a/sound/soc/fsl/fsl_micfil.c
+++ b/sound/soc/fsl/fsl_micfil.c
@@ -424,7 +424,13 @@ static const struct snd_kcontrol_new fsl_micfil_snd_controls[] = {
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



