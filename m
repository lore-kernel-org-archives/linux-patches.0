Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0CDA123185D;
	Mon,  2 Jun 2025 15:06:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748876780; cv=none; b=GXubEDihpMMN4cyQwesaA78i8nb5HXpRoIc3mdQzvg17BBzItTd97RLrWOKiGFn0TGsR0ZLaWXesZeAbjA/Srh5Y/lRjZqAEIKDQJ4avbiThA4q5uolywuBIitl/sEwfHFJjRTQOmtT4jsY0A6YNxYyoDegNRylk7RiuoifN9Bc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748876780; c=relaxed/simple;
	bh=GEetga6hoxUXdnQi89U2Cz21dK1SFeeDuptw4+BvaHI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=cvx+jaeQFHpza9LAxie1w/G/b9fiZWP+a+Pdl62tHrSs1/4X4bkWJsnPcKCgIT/ENKkO/lKDzPehltYRRMyUxOQhnVRdUFRzzIZhSUCzDnlSQD6AefgZvU9CDli1kOEnYFvOoTTgNLX/yqevDvlt3wamHJpmPO6Iua/LojS3Iz8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tEWhb56b; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tEWhb56b"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 258DDC4CEEE;
	Mon,  2 Jun 2025 15:06:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748876779;
	bh=GEetga6hoxUXdnQi89U2Cz21dK1SFeeDuptw4+BvaHI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tEWhb56bQHUvgXXF7vY6mFRD8X9U1wAYSRgRwFj8nSz8SiBbLbXKzGmKQ2nOia9A8
	 Uvy1eDvPm2Gx5hU37QMcaMjXCVV1u1IjlByIOQOFh7he+9Q80ZS+BJiZY5ZwiGAC1N
	 3GSzATD0xEhXx3ATrCLl0JW7zlA5ZaF5dlFLowVs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	"=?UTF-8?q?N=C3=ADcolas=20F . =20R . =20A . =20Prado?=" <nfraprado@collabora.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 070/325] ASoC: mediatek: mt6359: Add stub for mt6359_accdet_enable_jack_detect
Date: Mon,  2 Jun 2025 15:45:46 +0200
Message-ID: <20250602134322.630686716@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250602134319.723650984@linuxfoundation.org>
References: <20250602134319.723650984@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nícolas F. R. A. Prado <nfraprado@collabora.com>

[ Upstream commit 0116a7d84b32537a10d9bea1fd1bfc06577ef527 ]

Add a stub for mt6359_accdet_enable_jack_detect() to prevent linker
failures in the machine sound drivers calling it when
CONFIG_SND_SOC_MT6359_ACCDET is not enabled.

Suggested-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Signed-off-by: Nícolas F. R. A. Prado <nfraprado@collabora.com>
Link: https://patch.msgid.link/20250306-mt8188-accdet-v3-3-7828e835ff4b@collabora.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/mt6359-accdet.h | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/sound/soc/codecs/mt6359-accdet.h b/sound/soc/codecs/mt6359-accdet.h
index c234f2f4276a1..78ada3a5bfae5 100644
--- a/sound/soc/codecs/mt6359-accdet.h
+++ b/sound/soc/codecs/mt6359-accdet.h
@@ -123,6 +123,15 @@ struct mt6359_accdet {
 	struct workqueue_struct *jd_workqueue;
 };
 
+#if IS_ENABLED(CONFIG_SND_SOC_MT6359_ACCDET)
 int mt6359_accdet_enable_jack_detect(struct snd_soc_component *component,
 				     struct snd_soc_jack *jack);
+#else
+static inline int
+mt6359_accdet_enable_jack_detect(struct snd_soc_component *component,
+				 struct snd_soc_jack *jack)
+{
+	return -EOPNOTSUPP;
+}
+#endif
 #endif
-- 
2.39.5



