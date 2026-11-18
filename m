Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795040354;
	b=fKHiJOC0EMWrn/WK1iU3eEYZEIqgR00BhaDx4zBx6qcVExgV/MsWKsEvRVStFfLQ9EW2
	 F7TZC97Gq5TVYRxwcChZg7UNC6MbBROYPkz3DuIIzXq8j5vFH1fGP8N27v/m7zybSqbS8
	 ryy2olnPxkq0h2HNhfVCDpbEP7dJwN7VOtpHV1OTnqdLcNrm2wNMCD7d71pC7gWPigqJm
	 Y2ob38mIsGz9g8NfDSs9D1O3blH03KJxxWxcX2nd6qfoU4owvNpwNPHPFy5f4iv2c43GD
	 yUZt5bpXgI6ecdG4gjIxDVU8OaSBTj+Yo0u7ZNeuBvfhIKOcPvA8R+v6c49ifiEiiCg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795040354;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Q8/4Sd6OLWawfEGv/w7ee/ItcHOAPtBe8BMJRd4GU5I=;
	b=XeLvf5twmBqepe37aKt4l4G7VMTVIYIAARPeexQgY14zj62OR/0HhWrWRlCiopF2jtxc
	 tXGfa6fHjlyqJouLas14C8qKwo2Bw6KDRgUkk2MJN+B5NoLdXp7PYUYro9mw4ZNC4wrA9
	 4cRK96PZ1AZZ4W395cW79GOlDRqH91no4Tk1t7Tgb9yioGt0git+48hkrmbsxwudVHpSo
	 NLneTgG7b8cRAb6hcktXfo4osLvTDtVUHCwUulmLi52uHfXUAvojPB8BidrPjZkKImqKy
	 KnpjIlff87AgN/DdceNVQxBC2djd5/vQ8/a6j4cwMtj2rC48YMgEWMlafR9rYsjuCBg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="E/I7MKU/";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D13C4606A320;
	Wed, 18 Nov 2026 22:19:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=E/I7MKU/
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 25DAF1F000C4;
	Wed, 18 Nov 2026 22:19:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795040354;
	bh=Q8/4Sd6OLWawfEGv/w7ee/ItcHOAPtBe8BMJRd4GU5I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=E/I7MKU/B088LuL9r3bpKmBccrk0XpILWiVJ4LPGJ6ymuR0dCKq5quDsWzAM8KN4v
	 r790zYjZ88bmInrgxqkLAiRna9ldS2isz+6HLQN9ydk26U9lc/sJlyBSD6u3w1dZKp
	 sDMKPr3RoY41+sxN7otwyhBQNR9bo0Ow5COpmlEM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	bui duc phuc <phucduc.bui@gmail.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 2427/3318] ASoC: mediatek: mt8192: check return values in mt8192_afe_gpio_init()
Date: Wed, 18 Nov 2026 15:50:49 +0100
Message-ID: <20261118150434.276050431@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: bui duc phuc <phucduc.bui@gmail.com>

[ Upstream commit 7cca184ad434436e8f4648f71756bab0c3593ed9 ]

Currently, mt8192_afe_gpio_init() ignores the return values of
mt8192_afe_gpio_select() and mt8192_afe_gpio_request(). If configuring
GPIO states or requesting GPIOs fails during initialization, the function
still proceeds and returns 0, masking the initialization failure.

Fix this by checking and propagating the return values properly.

Fixes: 125ab5d588b0 ("ASoC: mediatek: mt8192: add platform driver")
Signed-off-by: bui duc phuc <phucduc.bui@gmail.com>
Link: https://patch.msgid.link/20260918133912.133799-10-phucduc.bui@gmail.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/mediatek/mt8192/mt8192-afe-gpio.c | 12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

diff --git a/sound/soc/mediatek/mt8192/mt8192-afe-gpio.c b/sound/soc/mediatek/mt8192/mt8192-afe-gpio.c
index 8e4013a18d8a2..3737583e347e3 100644
--- a/sound/soc/mediatek/mt8192/mt8192-afe-gpio.c
+++ b/sound/soc/mediatek/mt8192/mt8192-afe-gpio.c
@@ -152,13 +152,17 @@ int mt8192_afe_gpio_init(struct device *dev)
 		}
 	}
 
-	mt8192_afe_gpio_select(dev, MT8192_AFE_GPIO_CLK_MOSI_ON);
+	ret = mt8192_afe_gpio_select(dev, MT8192_AFE_GPIO_CLK_MOSI_ON);
+	if (ret)
+		return ret;
 
 	/* gpio status init */
-	mt8192_afe_gpio_request(dev, false, MT8192_DAI_ADDA, 0);
-	mt8192_afe_gpio_request(dev, false, MT8192_DAI_ADDA, 1);
+	ret = mt8192_afe_gpio_request(dev, false, MT8192_DAI_ADDA, 0);
+	if (ret)
+		return ret;
+	ret = mt8192_afe_gpio_request(dev, false, MT8192_DAI_ADDA, 1);
 
-	return 0;
+	return ret;
 }
 EXPORT_SYMBOL(mt8192_afe_gpio_init);
 
-- 
2.53.0



