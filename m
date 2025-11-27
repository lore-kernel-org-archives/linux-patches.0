Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A6258333456;
	Thu, 27 Nov 2025 15:01:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764255684; cv=none; b=pa46td4sjhgfS+7+7gASJ+pzWE/NSRveeQX3KrDg3iPkzwdYtQNy8G+JSQQtQR5trn1+TimKRS1C3lYfShEsqGD8lcoZ7UqZjfIW3uK989eMhPy3QR3S6x2sZm2uWpGBCe344YmZ4gzoQoGJFcRKSraHx0PLX14LgT0vNOUdpZ4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764255684; c=relaxed/simple;
	bh=pRmU/SbvuEFB3SqJwd51rNwx2dU9xA/P6co7Xw0BEno=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mbVa0s9LvJVi7Whcfkyu5lxcRwW3KgDdbQY9pSKVOMjvEZUyNP3U2KRPrbWhRnprInqVeJ7tegxo4D5QfzZVMofEr2+xbuapZahvpfjMUDxws8+wwA9cyUlJUpTqW6AAHLGvyMROrEllEmKy3fmBufbUFtDyx0jwHp4IJuBNn0o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gK9momCf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gK9momCf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 28896C4CEF8;
	Thu, 27 Nov 2025 15:01:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764255684;
	bh=pRmU/SbvuEFB3SqJwd51rNwx2dU9xA/P6co7Xw0BEno=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gK9momCfyhN9zaBheQqWb+1b554ymjUHlPNuX1e7UyKYyr3b8oUBFPg7XTRNZjpAl
	 H5GGkqUFPSnBik5cNnjVsmlrF52iABoiSOTtqq2/pJ62bRP/nvgXe8D139x16ArH6O
	 GYzKTc7fmkBZxtjMUYZp070Ht96SK+XybYB4HexE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Louis-Alexis Eyraud <louisalexis.eyraud@collabora.com>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Linus Walleij <linus.walleij@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 079/175] pinctrl: mediatek: mt8189: align register base names to dt-bindings ones
Date: Thu, 27 Nov 2025 15:45:32 +0100
Message-ID: <20251127144045.852191551@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251127144042.945669935@linuxfoundation.org>
References: <20251127144042.945669935@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Louis-Alexis Eyraud <louisalexis.eyraud@collabora.com>

[ Upstream commit 518919276c4119e34e24334003af70ab12477f00 ]

The mt8189-pinctrl driver requires to probe that a device tree uses
in the device node the same names than mt8189_pinctrl_register_base_names
array. But they are not matching the required ones in the
"mediatek,mt8189-pinctrl" dt-bindings, leading to possible dtbs check
issues. The mt8189_pinctrl_register_base_names entry order is also
different.
So, align all mt8189_pinctrl_register_base_names entry names and order
on dt-bindings.

Fixes: a3fe1324c3c5 ("pinctrl: mediatek: Add pinctrl driver for mt8189")
Signed-off-by: Louis-Alexis Eyraud <louisalexis.eyraud@collabora.com>
Reviewed-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pinctrl/mediatek/pinctrl-mt8189.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/pinctrl/mediatek/pinctrl-mt8189.c b/drivers/pinctrl/mediatek/pinctrl-mt8189.c
index 7028aff55ae58..f6a3e584588b0 100644
--- a/drivers/pinctrl/mediatek/pinctrl-mt8189.c
+++ b/drivers/pinctrl/mediatek/pinctrl-mt8189.c
@@ -1642,9 +1642,7 @@ static const struct mtk_pin_reg_calc mt8189_reg_cals[PINCTRL_PIN_REG_MAX] = {
 };
 
 static const char * const mt8189_pinctrl_register_base_names[] = {
-	"gpio_base", "iocfg_bm0_base", "iocfg_bm1_base", "iocfg_bm2_base", "iocfg_lm_base",
-	"iocfg_lt0_base", "iocfg_lt1_base", "iocfg_rb0_base", "iocfg_rb1_base",
-	"iocfg_rt_base"
+	"base", "lm", "rb0", "rb1", "bm0", "bm1", "bm2", "lt0", "lt1", "rt",
 };
 
 static const struct mtk_eint_hw mt8189_eint_hw = {
-- 
2.51.0



