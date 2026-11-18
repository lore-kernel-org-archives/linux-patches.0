Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795050097;
	b=uNXqde4f7UfwlbnOdeCwpmDx4qni/HvCgdvxfWkhcs80Yv9k937XrEuR2O7ytdt1Deop
	 SvyD1m/CQaWnzHNDvscbh02rKjdUnp7nGYK6Lo3npD9+2YaICyCGRletWG3Ny1PHNy3nU
	 uqExPhfRl7MG73NK0XP6ZFp3AAa7KySWFyf5go/dJfzGdjILYPP4JI0ZtupVe5UzWp43B
	 bHHWRCiBYLlMZnyFyiAh4tPJM8ToXV3XDqforNlyXyb8MX6tkZVnt+gxm8FVr9YADB9Bk
	 0dDB3dD0YfZFc5EHeWwAyxsACzbvyYcu1w1A+eDctOuSRFG92XpmPh5xyMVDzodfePA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795050097;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=KRgj1VtXK72uELvjZvNSGYhpR6awRSsi8wa0b0lKNmc=;
	b=GvVmF/tMWqmr/ezJ9BO8B8w8ct3VlGGVcFJJJyKuwOVzTKUFnHnjts38lKxv2N28UXsw
	 mvntB20LI8mPJMIkztzQtV3NBNGZAQwNNEqf2psP0RvTGt5LzQokN0pC6z3GiipJtUFEj
	 v/2w7uaxVCgILTJTESZnP6XSgVpBYUhBlkyrRMT4onlqgnQKz7U2ZhD42kyG+hwZYBz8l
	 qkrBS/AnnRXIVZMePzf8Nvjl++bbjizovbwied8tVPPBozZI28Lg5XtZpgCRXjX9DwS/0
	 lNqgDO0HXkox+vYKRA/2OLkMFqgP+3LSnFMbW5VAihNlzC7UPXTOue+fs7rKOZoIKjA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=WuTRypKQ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 771F960A2600;
	Thu, 19 Nov 2026 01:01:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=WuTRypKQ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7C8781F000C4;
	Thu, 19 Nov 2026 01:01:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795050097;
	bh=KRgj1VtXK72uELvjZvNSGYhpR6awRSsi8wa0b0lKNmc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=WuTRypKQoAxWYyOAqO/I+vh1oVC1fJS7eVmchhSNIXaEenz6k4Ni6NT+fy4ENUpUh
	 uM3K1ZPPNX5ubXSr0nfR/Q9ks7GN4iRMVO0DvpI37eXCXmmaYfxlH0WlIlxIeTI4uS
	 /24uibBkYGgcIPhMVqeHJ6bWD6hdNr5x1ecIQlDA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	HyeongJun An <sammiee5311@gmail.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 2579/2857] ASoC: codecs: tlv320adc3xxx: Fix definition of AGC Target Level control
Date: Wed, 18 Nov 2026 16:00:13 +0100
Message-ID: <20261118150334.356165863@linuxfoundation.org>
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

[ Upstream commit 0a9efcb663b5a4d468cbb90de29c6dd3794af124 ]

The right channel AGC target level is in RIGHT_CHN_AGC_1, as on the
left, not in RIGHT_CHN_AGC_2, which holds the right noise threshold
and hysteresis.

Fixes: e9a3b57efd28 ("ASoC: codec: tlv320adc3xxx: New codec driver")
Assisted-by: Claude:claude-opus-5-5
Signed-off-by: HyeongJun An <sammiee5311@gmail.com>
Link: https://patch.msgid.link/09cad9ec9bb382e44cad079a680bdf0f6163567e.1792135144.git.sammiee5311@gmail.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/tlv320adc3xxx.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/sound/soc/codecs/tlv320adc3xxx.c b/sound/soc/codecs/tlv320adc3xxx.c
index 6bd6da01aafac..7e9ae4bce30d5 100644
--- a/sound/soc/codecs/tlv320adc3xxx.c
+++ b/sound/soc/codecs/tlv320adc3xxx.c
@@ -690,7 +690,7 @@ static const struct snd_kcontrol_new adc3xxx_snd_controls[] = {
 	SOC_DOUBLE_R("AGC Capture Switch", ADC3XXX_LEFT_CHN_AGC_1,
 		     ADC3XXX_RIGHT_CHN_AGC_1, 7, 1, 0),
 	SOC_DOUBLE_R_TLV("AGC Target Level Capture Volume", ADC3XXX_LEFT_CHN_AGC_1,
-		     ADC3XXX_RIGHT_CHN_AGC_2, 4, 0x07, 1, agc_target_tlv),
+		     ADC3XXX_RIGHT_CHN_AGC_1, 4, 0x07, 1, agc_target_tlv),
 	SOC_DOUBLE_R_TLV("AGC Noise Threshold Capture Volume", ADC3XXX_LEFT_CHN_AGC_2,
 		     ADC3XXX_RIGHT_CHN_AGC_2, 1, 0x1f, 1, agc_thresh_tlv),
 	SOC_DOUBLE_R_TLV("AGC Hysteresis Capture Volume", ADC3XXX_LEFT_CHN_AGC_2,
-- 
2.53.0



