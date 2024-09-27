Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0DCD418A95D;
	Fri, 27 Sep 2024 12:27:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727440034; cv=none; b=JMhTPq161SvMKmimpUGazP7aTLHaaBaOgBxwUq6/8IFIX3MJBfcgT2QBXc+l3NKSdd3qj1E4m9pTxIMNlX/lGfBViKmxXGKwlhuqExpIaD082oq4OfWhZ2S90lma1FY0AGwEFxUeUCCEIKRqg7sIb0JEiDIA02igk0ZXF5bMAUQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727440034; c=relaxed/simple;
	bh=2zisp8x68nN8yLdJpOg0bW65qyyf5lc1GMwwnYEdcVs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=OmPXykVfleogAfiascFK7J05HXQzs/Q1p5yzmKIJKGaFqyrNS7px15VpBHwaeqazMH2RBJqd5l3yY+AM1recXT+ObRydnKsIeftC12QWiCPjwVG2Rp5lCDAbLtMGwFz2+KIzhY/CGWizUtEW9Nk2sTeuGeJRCVwc3VJxlDydYfE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lzwqXJIz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lzwqXJIz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 92037C4CEC4;
	Fri, 27 Sep 2024 12:27:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727440033;
	bh=2zisp8x68nN8yLdJpOg0bW65qyyf5lc1GMwwnYEdcVs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lzwqXJIz6rEQwSIAeD0jrUIimAstGuYUbHPbrXen/vpR4M8bdv5KUR1brNy0AiE8J
	 lqFw+ToL6AhKDHellSaKpDA8Ei0Xecn1IUNpMFsvPVkRnmrdCAs4g7s4jYn+vHbyZI
	 9bmYaEXrGBBGvM5BE7+1r7YjYIdLEknK+i/AL5oE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Albert=20Jakie=C5=82a?= <jakiela@google.com>,
	Chen-Yu Tsai <wenst@chromium.org>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 01/58] ASoC: SOF: mediatek: Add missing board compatible
Date: Fri, 27 Sep 2024 14:23:03 +0200
Message-ID: <20240927121718.844285413@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20240927121718.789211866@linuxfoundation.org>
References: <20240927121718.789211866@linuxfoundation.org>
User-Agent: quilt/0.67
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Albert Jakieła <jakiela@google.com>

[ Upstream commit c0196faaa927321a63e680427e075734ee656e42 ]

Add Google Dojo compatible.

Signed-off-by: Albert Jakieła <jakiela@google.com>
Reviewed-by: Chen-Yu Tsai <wenst@chromium.org>
Link: https://patch.msgid.link/20240809135627.544429-1-jakiela@google.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/sof/mediatek/mt8195/mt8195.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/sound/soc/sof/mediatek/mt8195/mt8195.c b/sound/soc/sof/mediatek/mt8195/mt8195.c
index 8d3fc167cd810..b9d4508bbb85d 100644
--- a/sound/soc/sof/mediatek/mt8195/mt8195.c
+++ b/sound/soc/sof/mediatek/mt8195/mt8195.c
@@ -574,6 +574,9 @@ static struct snd_sof_of_mach sof_mt8195_machs[] = {
 	{
 		.compatible = "google,tomato",
 		.sof_tplg_filename = "sof-mt8195-mt6359-rt1019-rt5682.tplg"
+	}, {
+		.compatible = "google,dojo",
+		.sof_tplg_filename = "sof-mt8195-mt6359-max98390-rt5682.tplg"
 	}, {
 		.compatible = "mediatek,mt8195",
 		.sof_tplg_filename = "sof-mt8195.tplg"
-- 
2.43.0



