Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C9E0259CBD;
	Tue, 17 Feb 2026 20:48:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771361313; cv=none; b=PTwsQ5nb1R8HhRlHB97ofhEPtjPMWQrBc37C+pBvU53xID/iHFeZYDla5wKX2nqpKIoNA3jm+459FGtT2AAvWvMdPH0RlYqwtjXcB4eToFtaayz07A7aCAp8/f1FJYcmHfYp4UGZZjnAoEMwu1xZuhAGA7OeGLhtxzROy3bSR6I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771361313; c=relaxed/simple;
	bh=XMk+8Z/2i3o4aoLiYOybYFmaeTKFqeo90aLjbMYdt20=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lGmNLET6q7wHiw3TAJtcXk0OTfiiYt3oAa8YBc+NTl4QaO/BLoZ+hfchFtImEzRfyCjD6VAdCgI07AdLfiHdooa9cdleQlHjynVgO73JpTJ+uqmuAO9F6o6fE3Y+BGyxUawcqOaJwStLKlO9sb1lIufVn6cSd2S4eRP40n2RCqs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pCEaNRl1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pCEaNRl1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E53CBC4CEF7;
	Tue, 17 Feb 2026 20:48:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1771361313;
	bh=XMk+8Z/2i3o4aoLiYOybYFmaeTKFqeo90aLjbMYdt20=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pCEaNRl1v9T1+qs3IRqaRPLWNtIFp4Hv0GvMX7GFOCgA4NqORO7AMWSfrRIT7Swbw
	 zfGbmHFwaVCW3fu5TbMPSA+DhGzVgPidxlUAuh6V045Gli+SG/6LkaY+kZ0gX2ThUV
	 o48yRSBTi59k8qoBHSROixwev/jlU12IALIXm2Fk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Charles Keepax <ckeepax@opensource.cirrus.com>,
	Ricardo Rivera-Matos <rriveram@opensource.cirrus.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 32/64] ASoC: cs35l45: Corrects ASP_TX5 DAPM widget channel
Date: Tue, 17 Feb 2026 21:31:28 +0100
Message-ID: <20260217200008.719607749@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260217200007.505931165@linuxfoundation.org>
References: <20260217200007.505931165@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ricardo Rivera-Matos <rriveram@opensource.cirrus.com>

[ Upstream commit 6dd0fdc908c02318c28ec2c0979661846ee0a9f7 ]

ASP_TX5 was incorrectly mapped to a channel value of 3 corrects,
the channel value of 4.

Reviewed-by: Charles Keepax <ckeepax@opensource.cirrus.com>
Signed-off-by: Ricardo Rivera-Matos <rriveram@opensource.cirrus.com>
Link: https://patch.msgid.link/20260115192523.1335742-2-rriveram@opensource.cirrus.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/cs35l45.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/sound/soc/codecs/cs35l45.c b/sound/soc/codecs/cs35l45.c
index d15b3b77c7eb0..29aed07443866 100644
--- a/sound/soc/codecs/cs35l45.c
+++ b/sound/soc/codecs/cs35l45.c
@@ -131,7 +131,7 @@ static const struct snd_soc_dapm_widget cs35l45_dapm_widgets[] = {
 	SND_SOC_DAPM_AIF_OUT("ASP_TX2", NULL, 1, CS35L45_ASP_ENABLES1, CS35L45_ASP_TX2_EN_SHIFT, 0),
 	SND_SOC_DAPM_AIF_OUT("ASP_TX3", NULL, 2, CS35L45_ASP_ENABLES1, CS35L45_ASP_TX3_EN_SHIFT, 0),
 	SND_SOC_DAPM_AIF_OUT("ASP_TX4", NULL, 3, CS35L45_ASP_ENABLES1, CS35L45_ASP_TX4_EN_SHIFT, 0),
-	SND_SOC_DAPM_AIF_OUT("ASP_TX5", NULL, 3, CS35L45_ASP_ENABLES1, CS35L45_ASP_TX5_EN_SHIFT, 0),
+	SND_SOC_DAPM_AIF_OUT("ASP_TX5", NULL, 4, CS35L45_ASP_ENABLES1, CS35L45_ASP_TX5_EN_SHIFT, 0),
 
 	SND_SOC_DAPM_MUX("ASP_TX1 Source", SND_SOC_NOPM, 0, 0, &cs35l45_asp_muxes[0]),
 	SND_SOC_DAPM_MUX("ASP_TX2 Source", SND_SOC_NOPM, 0, 0, &cs35l45_asp_muxes[1]),
-- 
2.51.0



