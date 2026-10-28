Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793216597;
	b=jUmP4yGDlzLcQGeE/q3GxgavcZV2Rv8aq62BKl6wMl/YaNq16mDsYGOnwS+wsOCh2QUK
	 iKOA8W2+cx02bJyfl81ekSq3lVa5E9L36bneurSiap0qBCqMU4dLH5iqJi8SmsKfAptMi
	 OjoF/6RkJhM3RplJLDcaT/ss/lLctI0yMJhxFUR1WH9bnHuWP6QSdmNC4PKhOVYiYhjnV
	 WbLTqlk0WYMGhC4qX0GIbZS3j0HRHTgR+zfPUU5ivBzYd31t9gNL7WW+XBllAtKCrt1fA
	 Mff9fIsgW+BlWRQpEym4R23/pnmFd5zkutZoknipIsmgBo69jTHKeJuPCqCDkRhNqNA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793216597;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Oty3+MFJLQinTP1tLbZhFR0v1JHu1U6L3cnCGA/vVEs=;
	b=m0I31MXt1Ikw/AE3v77Ycyqj7EbFbesSwn30K1mTuUFr/xhmLuoN25/7515ol+5aK5Ja
	 c6iuDt2LVz/Ii6pTR6hMi66BaKhLIi6ZxX4AfBWNbaUmN7Uu97Rti19z3lerRQr4uAlLO
	 3RP7HnV0ynKnmQMQAm2olGI3b/qXUwd0eTJay1+uWOuMCTV0/ZRQS7uQf6Pqgb0rWJn8L
	 nJkyIgjRNaRr2MggRQ7TF1OSDchUQ1b/OEN21UUSpYFHI2LWJYt9dS5zM1gB5htmHXi57
	 QKtXioIe6OyDoQeviglIgvdqenp5Rm46OOzyJ6uYSdqrEZR0zeQnzlpLx29EKnXDTAA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=be1dhTEg;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 78507606A31C;
	Wed, 28 Oct 2026 19:43:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=be1dhTEg
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CC7651F01825;
	Wed, 28 Oct 2026 19:43:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793216597;
	bh=Oty3+MFJLQinTP1tLbZhFR0v1JHu1U6L3cnCGA/vVEs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=be1dhTEggrf3/79H5PiMk0f4UDiQtOZpUtSAwR7bE3in48Yz/8mEX1l79frynkxYj
	 NmUU7bExbgMx/mYhkHid0buKhX5C+uLvatjkYhVJzVf6R8+JOEgUSJka3pIj433Xaq
	 STgmp01n6ycWCTRdCRA2QCrMjjBXEkWR1tS41M+Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Justin Yeh <justin.yeh@mediatek.com>,
	Chen-Yu Tsai <wenst@chromium.org>,
	Linus Walleij <linusw@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1613/1887] pinctrl: mediatek: use devm_gpiochip_add_data() for GPIO chip
Date: Wed, 28 Oct 2026 18:01:49 +0100
Message-ID: <20261028170536.173078180@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
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

From: Justin Yeh <justin.yeh@mediatek.com>

[ Upstream commit 9c650317ba553d297f3fc5f0ae40ec53d86f9dab ]

The gpio_chip is allocated with device-managed memory but registered with
the non-managed gpiochip_add_data(). This was harmless while the drivers
were built-in, but once they can be built as modules and unbound/rmmod'd,
devm frees the gpio_chip's memory while it is still registered, causing a
use-after-free.

Register it with devm_gpiochip_add_data() so it shares the same
device-managed lifecycle, which also lets the manual gpiochip_remove()
error paths go away.

Fixes: a6df410d420a ("pinctrl: mediatek: Add Pinctrl/GPIO driver for mt8135.")
Fixes: 805250982bb5 ("pinctrl: mediatek: add pinctrl-paris that implements the vendor dt-bindings")
Fixes: e78d57b2f87c ("pinctrl: mediatek: add pinctrl-moore that implements the generic pinctrl dt-bindings")
Signed-off-by: Justin Yeh <justin.yeh@mediatek.com>
Reviewed-by: Chen-Yu Tsai <wenst@chromium.org>
Signed-off-by: Linus Walleij <linusw@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pinctrl/mediatek/pinctrl-moore.c      |  6 ++----
 drivers/pinctrl/mediatek/pinctrl-mtk-common.c | 14 ++++----------
 drivers/pinctrl/mediatek/pinctrl-paris.c      |  2 +-
 3 files changed, 7 insertions(+), 15 deletions(-)

diff --git a/drivers/pinctrl/mediatek/pinctrl-moore.c b/drivers/pinctrl/mediatek/pinctrl-moore.c
index 319da66d4f329..e91987d33fc65 100644
--- a/drivers/pinctrl/mediatek/pinctrl-moore.c
+++ b/drivers/pinctrl/mediatek/pinctrl-moore.c
@@ -538,7 +538,7 @@ static int mtk_build_gpiochip(struct mtk_pinctrl *hw)
 	chip->ngpio		= hw->soc->npins;
 	chip->of_gpio_n_cells	= 2;
 
-	ret = gpiochip_add_data(chip, hw);
+	ret = devm_gpiochip_add_data(hw->dev, chip, hw);
 	if (ret < 0)
 		return ret;
 
@@ -552,10 +552,8 @@ static int mtk_build_gpiochip(struct mtk_pinctrl *hw)
 	if (!of_find_property(hw->dev->of_node, "gpio-ranges", NULL)) {
 		ret = gpiochip_add_pin_range(chip, dev_name(hw->dev), 0, 0,
 					     chip->ngpio);
-		if (ret < 0) {
-			gpiochip_remove(chip);
+		if (ret < 0)
 			return ret;
-		}
 	}
 
 	return 0;
diff --git a/drivers/pinctrl/mediatek/pinctrl-mtk-common.c b/drivers/pinctrl/mediatek/pinctrl-mtk-common.c
index fe44867b4c289..1dada2b64b9e2 100644
--- a/drivers/pinctrl/mediatek/pinctrl-mtk-common.c
+++ b/drivers/pinctrl/mediatek/pinctrl-mtk-common.c
@@ -1121,30 +1121,24 @@ int mtk_pctrl_init(struct platform_device *pdev,
 	pctl->chip->parent = &pdev->dev;
 	pctl->chip->base = -1;
 
-	ret = gpiochip_add_data(pctl->chip, pctl);
+	ret = devm_gpiochip_add_data(&pdev->dev, pctl->chip, pctl);
 	if (ret)
 		return -EINVAL;
 
 	/* Register the GPIO to pin mappings. */
 	ret = gpiochip_add_pin_range(pctl->chip, dev_name(&pdev->dev),
 			0, 0, pctl->devdata->npins);
-	if (ret) {
-		ret = -EINVAL;
-		goto chip_error;
-	}
+	if (ret)
+		return -EINVAL;
 
 	/* Only initialize EINT if we have EINT pins */
 	if (data->eint_hw.ap_num > 0) {
 		ret = mtk_eint_init(pctl, pdev);
 		if (ret)
-			goto chip_error;
+			return ret;
 	}
 
 	return 0;
-
-chip_error:
-	gpiochip_remove(pctl->chip);
-	return ret;
 }
 
 int mtk_pctrl_common_probe(struct platform_device *pdev)
diff --git a/drivers/pinctrl/mediatek/pinctrl-paris.c b/drivers/pinctrl/mediatek/pinctrl-paris.c
index ab1c34e5a582e..464bedc0fe454 100644
--- a/drivers/pinctrl/mediatek/pinctrl-paris.c
+++ b/drivers/pinctrl/mediatek/pinctrl-paris.c
@@ -970,7 +970,7 @@ static int mtk_build_gpiochip(struct mtk_pinctrl *hw)
 	chip->ngpio		= hw->soc->npins;
 	chip->of_gpio_n_cells	= 2;
 
-	ret = gpiochip_add_data(chip, hw);
+	ret = devm_gpiochip_add_data(hw->dev, chip, hw);
 	if (ret < 0)
 		return ret;
 
-- 
2.53.0



