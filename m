Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 487F31C08
	for <patches@lists.linux.dev>; Wed, 28 Dec 2022 16:37:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A1D1BC433F0;
	Wed, 28 Dec 2022 16:37:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1672245478;
	bh=Mt3ekxmlDTqRJ1l1rjm3C8i3c0nhGxYJwi4DCc/D+TE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xrAf3DHOzqC1f/uNtxskIK62CDZcc0kM/XfzXRe9UuCSDuBtPfxgFbie/De2VXqLa
	 Iwb4A9sTWhVMFrq06A7PSRjqHX32f67cGEcopg/QwtBaN4ismUgEvMTkUC4YRwmZBm
	 oZ5faZu+EUaCRawIjzJz+lJzJ/Yg47VmtJX8Lw/8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daniel Golle <daniel@makrotopia.org>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	=?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= <u.kleine-koenig@pengutronix.de>,
	Thierry Reding <thierry.reding@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0868/1146] pwm: mediatek: always use bus clock for PWM on MT7622
Date: Wed, 28 Dec 2022 15:40:07 +0100
Message-Id: <20221228144353.745685991@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144330.180012208@linuxfoundation.org>
References: <20221228144330.180012208@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Daniel Golle <daniel@makrotopia.org>

[ Upstream commit aa3c668f2f98856af96e13f44da6ca4f26f0b98c ]

According to MT7622 Reference Manual for Development Board v1.0 the PWM
unit found in the MT7622 SoC also comes with the PWM_CK_26M_SEL register
at offset 0x210 just like other modern MediaTek ARM64 SoCs.
And also MT7622 sets that register to 0x00000001 on reset which is
described as 'Select 26M fix CLK as BCLK' in the datasheet.
Hence set has_ck_26m_sel to true also for MT7622 which results in the
driver writing 0 to the PWM_CK_26M_SEL register which is described as
'Select bus CLK as BCLK'.

Fixes: 0c0ead76235db0 ("pwm: mediatek: Always use bus clock")
Signed-off-by: Daniel Golle <daniel@makrotopia.org>
Reviewed-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Acked-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
Link: https://lore.kernel.org/r/Y1iF2slvSblf6bYK@makrotopia.org
Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
Signed-off-by: Thierry Reding <thierry.reding@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pwm/pwm-mediatek.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/pwm/pwm-mediatek.c b/drivers/pwm/pwm-mediatek.c
index 6901a44dc428..a337b47dc2f7 100644
--- a/drivers/pwm/pwm-mediatek.c
+++ b/drivers/pwm/pwm-mediatek.c
@@ -296,7 +296,7 @@ static const struct pwm_mediatek_of_data mt6795_pwm_data = {
 static const struct pwm_mediatek_of_data mt7622_pwm_data = {
 	.num_pwms = 6,
 	.pwm45_fixup = false,
-	.has_ck_26m_sel = false,
+	.has_ck_26m_sel = true,
 };
 
 static const struct pwm_mediatek_of_data mt7623_pwm_data = {
-- 
2.35.1



