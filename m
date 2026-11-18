Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795056493;
	b=i3T60pTGlUWsAyiAR7ZVFTexXTeogNqrM9lMkxwilzhLzQnTN0XBv8c33xktOUtd6SdD
	 s7UQGTYyts1r7Ibw34UM1/Hr9SXsCmddEhpmfi52WIionFjg0bvaZZIH2tnbIzU9ya6Xe
	 gK3KX09Qcxr9BC2dBaiRiRu7JhzQo9LAcHY9jlTiUGrrJYkX0Won03teiTzzkmkZPeKls
	 QFJPIpi3sJjgmxnubcPacXWxsJ2tl0xEOQ6U5gqY6Z16nbnLFXoQGkLtlXwDCyKrEDHP3
	 QRhOt4Mc8Og9HDzdxQx5E+1xpodQeBtUpn7lQQ1nDFKW54K76LQGSP1jrMx/n3CRpGw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795056493;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=3Bc+2AGFa8e+nd8MG2dKQIlj8Ek+hbAur1VOk4bTmak=;
	b=VlSgIciN7IogHdFnZ+mw+uyoAiqxSx2huhtu5LV/V01mX6gW2OXEf2cNoOk06FkvU8Uk
	 bx1jPUcv5Jtz4hOCeF6hQFSit3d3qxInrjNIYBJXWdSjBis4q14Plhyx6v7bsxP12Dki0
	 bPz2xUQPxgGH9225rcSrq33upYxCG1byaNr/o3wDKE6mT6f1YVmQD8JNSEepaxT8rWQke
	 2uRthVKjrSgZXpRNsTks+fvoHGKDjAwQH+MAXH1jMsf2/KftgVpo28uWtY3EBR7fEtNrv
	 iLKCSgzZcjanbBGJlifWT05+R4OvJEgYoo7M40JGaC3jsYrzYVT6vvU3mh3ahWzVHAw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=eJ6ujd3t;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D35B60A2609;
	Thu, 19 Nov 2026 02:48:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=eJ6ujd3t
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C68E11F000C5;
	Thu, 19 Nov 2026 02:48:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795056493;
	bh=3Bc+2AGFa8e+nd8MG2dKQIlj8Ek+hbAur1VOk4bTmak=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=eJ6ujd3tiIZq1eOyRaNt8TBO0YOXF9VhQ518mFMSTiB+oVpwTkbWnFlxy68yD9xJD
	 5GuWpzXbOBH/Ec9CgycNEcnY1FGWzr2XrFw4xddKCfqd2oS70ePwLYEO//w+Ubnhj8
	 YlTiSeaSWCocb28cRrXs0DBWwS1VkpBpOCFE+zyU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Abaci Robot <abaci@linux.alibaba.com>,
	Yang Li <yang.lee@linux.alibaba.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 1991/2214] ASoC: mediatek: mt8195: Remove unnecessary print function dev_err()
Date: Wed, 18 Nov 2026 16:01:07 +0100
Message-ID: <20261118150130.475473647@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yang Li <yang.lee@linux.alibaba.com>

[ Upstream commit 7d642c9c14b6fae0c05b91a92a86fae6674a2126 ]

The print function dev_err() is redundant because platform_get_irq()
already prints an error.

Eliminate the follow coccicheck warning:
./sound/soc/mediatek/mt8195/mt8195-afe-pcm.c:3126:2-9: line 3126 is
redundant because platform_get_irq() already prints an error

Reported-by: Abaci Robot <abaci@linux.alibaba.com>
Signed-off-by: Yang Li <yang.lee@linux.alibaba.com>
Link: https://lore.kernel.org/r/20220224011046.76904-1-yang.lee@linux.alibaba.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Stable-dep-of: 9d5dedb285fb ("ASoC: mediatek: mt8195: Propagate IRQ lookup errors")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/mediatek/mt8195/mt8195-afe-pcm.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/sound/soc/mediatek/mt8195/mt8195-afe-pcm.c b/sound/soc/mediatek/mt8195/mt8195-afe-pcm.c
index 4558c1059433c..f894e74317756 100644
--- a/sound/soc/mediatek/mt8195/mt8195-afe-pcm.c
+++ b/sound/soc/mediatek/mt8195/mt8195-afe-pcm.c
@@ -3167,10 +3167,8 @@ static int mt8195_afe_pcm_dev_probe(struct platform_device *pdev)
 
 	/* request irq */
 	irq_id = platform_get_irq(pdev, 0);
-	if (irq_id < 0) {
-		dev_err(dev, "%s no irq found\n", dev->of_node->name);
+	if (irq_id < 0)
 		return -ENXIO;
-	}
 
 	ret = devm_request_irq(dev, irq_id, mt8195_afe_irq_handler,
 			       IRQF_TRIGGER_NONE, "asys-isr", (void *)afe);
-- 
2.53.0



