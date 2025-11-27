Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BAC96213254;
	Thu, 27 Nov 2025 15:01:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764255681; cv=none; b=gIFDh/yQEYKooAbTxfJKa42T/L0uyiVLctmc1VgkLtr/0ZvJYmW7SNmDtJLMU2Be2itTMGZdtHOfxQ7qMwMlggKx6D4HIX+ODDM1xX8NIK8CTm1WFUB2erbD8SNKE9SkMqxqF8XHIsFw5Kkmj5Q2z1fJkdfesSRyWpe/KxgjNtU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764255681; c=relaxed/simple;
	bh=s4rGPM56Jlp85GIxg/FImrYn2GImYb/e8WMiRD8PLCQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pAuVRdtSNp1fNK613L++GFaYbs3zJt/utJfvJJNiEkePEzbKvnKbQpoeTjoGWlknsBYoTGYgbKf2d6Z2e/BKuEzbuLPzKNfaR1QA0Xw/lonHyvOAYGxQvwYZCLIvKsiTdJoTxMVZNe7h3gmJm7L4yG97WxCQ/D7wb5cC0mRT+EM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CSS/mJLT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CSS/mJLT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 31D60C4CEF8;
	Thu, 27 Nov 2025 15:01:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764255681;
	bh=s4rGPM56Jlp85GIxg/FImrYn2GImYb/e8WMiRD8PLCQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CSS/mJLTKe9c7jbDnAf6pXlChqK03FnORdeRYGfpstIePs6tAOxidGmPIprqvkjU8
	 edbhlAitQUibdeJdcR+wMqgsY4Ev34ThGIUyKAtwkYZ1W/MFoQupc7p5mQodmxZtCI
	 x0IFaVOodszYmLEg83rduFDENxCAqLz5zEzmZhLo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Louis-Alexis Eyraud <louisalexis.eyraud@collabora.com>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Linus Walleij <linus.walleij@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 078/175] pinctrl: mediatek: mt8196: align register base names to dt-bindings ones
Date: Thu, 27 Nov 2025 15:45:31 +0100
Message-ID: <20251127144045.816080972@linuxfoundation.org>
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

[ Upstream commit 404ee89b4008cf2130554dac2c64cd8412601356 ]

The mt8196-pinctrl driver requires to probe that a device tree uses
in the device node the same names than mt8196_pinctrl_register_base_names
array. But they are not matching the required ones in the
"mediatek,mt8196-pinctrl" dt-bindings, leading to possible dtbs check
issues.
So, align all mt8196_pinctrl_register_base_names entries on dt-bindings
ones.

Fixes: f7a29377c253 ("pinctrl: mediatek: Add pinctrl driver on mt8196")
Signed-off-by: Louis-Alexis Eyraud <louisalexis.eyraud@collabora.com>
Reviewed-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pinctrl/mediatek/pinctrl-mt8196.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/pinctrl/mediatek/pinctrl-mt8196.c b/drivers/pinctrl/mediatek/pinctrl-mt8196.c
index 82a73929c7a0f..dec957c1724b0 100644
--- a/drivers/pinctrl/mediatek/pinctrl-mt8196.c
+++ b/drivers/pinctrl/mediatek/pinctrl-mt8196.c
@@ -1801,10 +1801,8 @@ static const struct mtk_pin_reg_calc mt8196_reg_cals[PINCTRL_PIN_REG_MAX] = {
 };
 
 static const char * const mt8196_pinctrl_register_base_names[] = {
-	"iocfg0", "iocfg_rt", "iocfg_rm1", "iocfg_rm2",
-	"iocfg_rb", "iocfg_bm1", "iocfg_bm2", "iocfg_bm3",
-	"iocfg_lt", "iocfg_lm1", "iocfg_lm2", "iocfg_lb1",
-	"iocfg_lb2", "iocfg_tm1", "iocfg_tm2", "iocfg_tm3",
+	"base", "rt", "rm1", "rm2", "rb", "bm1", "bm2", "bm3",
+	"lt", "lm1", "lm2", "lb1", "lb2", "tm1", "tm2", "tm3",
 };
 
 static const struct mtk_eint_hw mt8196_eint_hw = {
-- 
2.51.0



