Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795049779;
	b=H6vG9RQoGMZo5W/DJk44qCFdNrzrOHq18oDAb4rZlvMC4PRRkS1IGDnoTd1xykcGB5o9
	 pzc/Qt0LBu6lvsJS/V8VzSohZhPDlQR8uwWurBAHahPf9NblVwRntwQXAkkdoZs66veai
	 oAdrawe/2OMa3am8SOU+HB0uc4au2/zXlvyGRDVAjsdP0Eletc8Go8Kufu3yN5lLcIsk3
	 HGI2uQgPXQi3faft5hy6cLCMP17LmQWJw6ZSwCtKXeUIwF0aY6jXFhSuIMa87w39Dpvqm
	 iTAlOEc9exsih9xacMDlIcvnDDi7Z0r4lCHCcQVxfRUjXrrf3C2bqQyEqnKxmjnvj6A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795049779;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=JWVIM8jRAgU3TJB0uikELEuUnBRDMMq61SwEd7O1SA0=;
	b=mwyFdsU7HojhD025O2cSixnZq7GY62/VkNSlrhE3lP1SWS7kJMK9fNxgRdfFKhbAa3VZ
	 zhPwkoSrToDQ6BQkg8t68b/1jiFf90CW04CeZZx9RH8TIQQm2U2c0wDSK2QY7aWfoKq39
	 bGxbfr1Qa4ym+ZkExVL7Hn//k8IAqNQu+VkF8uRSXkaapQpK/xKuu/f885JbaVCzpoaiz
	 +/WCbI0JMXn+nZmKRlGcqVZBy5837mhEshpi1Y8n8EN+fK21i9ZR1R0lAoqL/KAasQuVX
	 E3anNPnFts00umJW+W5SMfv9xl0lCv5Lf9Fk9mS3G2Xd8lp4WhIJovyokfv0wGSf6sQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=emfVnfg0;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D5C61606A320;
	Thu, 19 Nov 2026 00:56:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=emfVnfg0
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D1C5D1F000C4;
	Thu, 19 Nov 2026 00:56:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795049779;
	bh=JWVIM8jRAgU3TJB0uikELEuUnBRDMMq61SwEd7O1SA0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=emfVnfg0TtaBTKJ5V/Ggv5BbJwRGp83iUbVQWS+u9lRzWK4Qy2scxR8cFhrwTl/kS
	 EdUbfD63onNyPMISMFiFi1Z+LddOEHvdJtFg8RvIZ8fg1VC0vvwFp0Sxg5z1+OnGq8
	 zMUtJOZgo+6J2ZLP4j8cPf8wH2SbpsCOA3hTJfas=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	HyeongJun An <sammiee5311@gmail.com>,
	Charles Keepax <ckeepax@opensource.cirrus.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 2473/2857] ASoC: codecs: wm8994: Fix definition of WM8958 noise gate hold time controls
Date: Wed, 18 Nov 2026 15:58:27 +0100
Message-ID: <20261118150330.606729202@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: HyeongJun An <sammiee5311@gmail.com>

[ Upstream commit 291d81d628f3453026b029507a26b856056e4fdc ]

The noise gate hold time (NG_HLD) is at bits 6:5 of each WM8958 DAC
noise gate register, not at bits 3:1, which hold the threshold
(NG_THR).

Fixes: 1ddc07d0f13a ("ASoC: Add WM8958 noise gate support")
Assisted-by: Claude:claude-opus-5-5
Signed-off-by: HyeongJun An <sammiee5311@gmail.com>
Reviewed-by: Charles Keepax <ckeepax@opensource.cirrus.com>
Link: https://patch.msgid.link/8acff0f7314eef9eb3d290ca7855a87052d7e706.1791959026.git.sammiee5311@gmail.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/wm8994.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/sound/soc/codecs/wm8994.c b/sound/soc/codecs/wm8994.c
index bb8e311f33d2f..3012b25e26d55 100644
--- a/sound/soc/codecs/wm8994.c
+++ b/sound/soc/codecs/wm8994.c
@@ -700,17 +700,17 @@ static const char *wm8958_ng_text[] = {
 
 static SOC_ENUM_SINGLE_DECL(wm8958_aif1dac1_ng_hold,
 			    WM8958_AIF1_DAC1_NOISE_GATE,
-			    WM8958_AIF1DAC1_NG_THR_SHIFT,
+			    WM8958_AIF1DAC1_NG_HLD_SHIFT,
 			    wm8958_ng_text);
 
 static SOC_ENUM_SINGLE_DECL(wm8958_aif1dac2_ng_hold,
 			    WM8958_AIF1_DAC2_NOISE_GATE,
-			    WM8958_AIF1DAC2_NG_THR_SHIFT,
+			    WM8958_AIF1DAC2_NG_HLD_SHIFT,
 			    wm8958_ng_text);
 
 static SOC_ENUM_SINGLE_DECL(wm8958_aif2dac_ng_hold,
 			    WM8958_AIF2_DAC_NOISE_GATE,
-			    WM8958_AIF2DAC_NG_THR_SHIFT,
+			    WM8958_AIF2DAC_NG_HLD_SHIFT,
 			    wm8958_ng_text);
 
 static const struct snd_kcontrol_new wm8958_snd_controls[] = {
-- 
2.53.0



