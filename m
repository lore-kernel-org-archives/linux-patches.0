Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795024842;
	b=iCSk6Zf3fbWowzVuhERxMzd6ekFVJZ0OHSKE1o795wxE0jmxHkPR8oXT1oxYERE7BpC/
	 mqcqvLcBJVtZ+M93PdbZf1o/H1hIx+VlxBI6lz4VtZLONiadwJKfZY8TdT25D7o5W3snu
	 4nW0eKkhjYXS37R9YjYwWtOIdcCs3hShAvRNX4INnH/ZiN7uX5LYOpXJINsX9NUzM9msQ
	 jDoTQX1Ep9sdJPKcESWGVAXvLruJ/bQVHgXzsFW9KwWEd7554KFhAaSiULJmp8MdAKE37
	 fwDHc4SalBG04Wf8KC6TaOGcQX85RrS00iBUA/D+Ro62BclJ7S04qXeDFptmFWJqF0g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795024842;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=J32R8+oGBvxCfrq62+p8PWTPNUXuw4R49g9EGreCGSY=;
	b=LVyPt39x78n28NSYN4F1YuXwzr1Seapm7pMiO+r5GwqXO5ZOAnhQH0zpm5idOqLHD1ht
	 ynBQhZhp9eQMT87LeP4prrU5e373dPjS3UYLFA3iM7oUenp0wqI//R6yj0Ll8T/NigeRt
	 5VjtVmuH6QWyBoQLy91Bdls7GN4ep8Ia+ybsdvez11pk9JjZvX2sZZh/6TxMDximeeUdZ
	 gJsANZ+UOECCVSNOKd5MyT/D2dekg2dUlLRJ8wSplmyp7/W0ir8SXgecNhGanTZ1oiqTr
	 1s0v2l4t0L9N5gNmknHmEHqm9cza8xZ+fT2qovkTztXK7j+B4PWZHMvzV+LukQP3e0A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=V2fcGvTU;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 67614606A320;
	Wed, 18 Nov 2026 18:00:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=V2fcGvTU
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B6BD41F000C4;
	Wed, 18 Nov 2026 18:00:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795024842;
	bh=J32R8+oGBvxCfrq62+p8PWTPNUXuw4R49g9EGreCGSY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=V2fcGvTU548Somi5y7VeHfkzGK2alwN4kJ2hv2FV+b9XvMaoJH1/Q2HJzV+qwusgK
	 atAU0Gd7oZTvoPjjQIbp2PXSlL84LXMlff7DWACltwWfKsUCEk1BI1CuFU6/udhA0S
	 WNtp3jvEGa5DsvGGliMP8/dUxLGuBTDoBRY3KGEg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	bui duc phuc <phucduc.bui@gmail.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0826/2151] ASoC: mediatek: mt8192: check return values in mt8192_afe_gpio_init()
Date: Wed, 18 Nov 2026 15:42:41 +0100
Message-ID: <20261118150152.225096339@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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



