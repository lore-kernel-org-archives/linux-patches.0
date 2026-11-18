Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795048767;
	b=zLcE5iv3TkAVnsalXhu2uDF+jKLAMFF8h/q5jcS0o0JzfV+Tx23/p/7AO+a57yaEdY/0
	 bO5W+hcXC+ANUXwJWndhB79oOlim5kkToRh/CeCa3Ebt041izhK4FpVdtEYeABIfAiNg4
	 V3BnsZ0Z9fLlkRgu0Gp+yAScUeHHqPN4R+XnWFxDGo9N4GehFmANJCFp3lNoyjGoYLxEN
	 P95J/yougn2HJVtMhcoMX+H7P7XfQ+m8KslkBwwVX4nO/5vDH2pAOVS/4rhQ4HEDwExKy
	 P4O3CYofwkw0PywL7dfNr9myMPwWhoNE5IXNDaLRvXO96m4p2goeXAcgUU6PDUx9PUQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795048767;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=VwbG0DpLTQaYhpYvjHEnVpf+Te3uHGkLorfrmE1UJVg=;
	b=3Vdion19XAMfY0Utqo0WZXl8aNojCOZTSBJtroXJgaQ+eYZQLaeFk/KnGcwbddB78SiS
	 kpiUGWFqI2Kr2wzasV9qerGn50AJN2Xs/oZENaNy2DjeAxTnMXk6ij+ccuDxn7C8Ie1+q
	 BZnjB0Ycw4PCwGN1KaFobjIEmPvREIGPmpz/J8VeYHmCXPsEm9mNNjCCjiJFTQya1s/3p
	 mL0VIcZOR8XJd6/4YAApM9a8xUHurRaKWF8WBOyqgTkufLKDYTtpFVGyuJEFDoAN5Yky0
	 ++G7C+YOHZUf8DUJ2ACi/MH3g4p2yGkwRbrHIFOM5y80WAM/CwqHP1JP79JYEgQjOXA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=uO0phah4;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E894C606A325;
	Thu, 19 Nov 2026 00:39:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=uO0phah4
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 448281F000C4;
	Thu, 19 Nov 2026 00:39:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795048766;
	bh=VwbG0DpLTQaYhpYvjHEnVpf+Te3uHGkLorfrmE1UJVg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=uO0phah4JMTiOb1hOfNhI2ijjWvPVHoiwfqWQPRMik8eFZ9+sCMiRlfwyB3Xoldh5
	 ctmiI89/r288kFm0qTHbIOg1U6mh8ZUlMw5eN4DIynyKFCTQE611VrPWi+XJNuX/oT
	 WVuo4UxFtcD5M4/KdTaGDXELjFOvowdpLeueVIa0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	bui duc phuc <phucduc.bui@gmail.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 2111/2857] ASoC: mediatek: mt8192: check return values in mt8192_afe_gpio_init()
Date: Wed, 18 Nov 2026 15:52:25 +0100
Message-ID: <20261118150317.420964657@linuxfoundation.org>
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



