Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795017669;
	b=i9905WFnl35WxtKV3NOQum1TyNAujNC4UE+BRZs8IXKfjCwIYHW3sMB0KWmSVqcO3et1
	 1tDDYhSbeQRb5S7S1obvsIFIXIt2Rf59LCgnU6vvELdhCOIWCPSLeLh71daKzNPKYArZS
	 lBkkdnDCQLhCsHz5/oo61CCaVvRU4ygEatMWYA6k4VeOFXoDasV7T6vJ9Qb5OlguFg24k
	 nI+XGYueC+FkX8vF0QMagcpl1kqfZy5bVTUiWx5s84oS2dcKj0RaCMG5CiZ69wnYEmTLE
	 MVADhJNMtuGicLN+LJ2aj4SSRwKvl2kSYmwUmVsjQFBRunE98BSLzZEtv5f6/isyAZw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795017669;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=XVgId1mEkAfiSQ1ScvSD2JPO7t+m2k4Tai4L82JwS1k=;
	b=zQiIvWP5KCrrr2bxs7GDf3NXsa/Hc4MwK/o9rht0v8eIHwuZINCwRxvFV6gFbXw6rXnc
	 L3kK1h35Dvo/k/oT5IMqTitSf7Kf/VpF107/bsSSOOpfCQPn65DmHGZBJewA7cs5cEqam
	 FlEB9H75jiWecNEM1pE23NntJRBlAHn0omQLm4YjNaStwGcLhppDvZ2645r2rSRzSE/zg
	 aoxVa32ae7ap4CxOFRaiu0WPDmtzZUhsbuGy799cm71LCwtHA0YkOqCsT31PLFwUkWHPz
	 /z39eg7VBhAhGTLGAFIdkiMLWbsMjb+mRG22y2dBnIS746U6ygZfqKqFrAq27dX6Tvw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=l0o+qUtL;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A84DB606A325;
	Wed, 18 Nov 2026 16:01:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=l0o+qUtL
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0CE101F000C5;
	Wed, 18 Nov 2026 16:01:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795017669;
	bh=XVgId1mEkAfiSQ1ScvSD2JPO7t+m2k4Tai4L82JwS1k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=l0o+qUtLijiUQYJpg+JLtu2RUAGPF4QcRnYLoiAYJu5DSntbd2ZVnCaDQ4CIIkAkN
	 GHysagYR55KU8SSNOz+nZbStL65ZTfEInkBv57OIznT2m7Nph61+ZrOs6GApwisNJJ
	 t+0xRfLT7Dcz4pwgkzO+adUQCtYENAy12xXYOA9k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	bui duc phuc <phucduc.bui@gmail.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0968/2651] ASoC: mediatek: mt8192: check return values in mt8192_afe_gpio_init()
Date: Wed, 18 Nov 2026 15:36:48 +0100
Message-ID: <20261118150322.754101645@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

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
index ed6dfdf2589bb..f2d5e61fbb639 100644
--- a/sound/soc/mediatek/mt8192/mt8192-afe-gpio.c
+++ b/sound/soc/mediatek/mt8192/mt8192-afe-gpio.c
@@ -151,13 +151,17 @@ int mt8192_afe_gpio_init(struct device *dev)
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



