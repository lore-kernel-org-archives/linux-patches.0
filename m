Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795054133;
	b=hsNVst8QlWgQ+DfrnrS7emAVGrxq0c9Br8TiUvgWZCRJzwxyTVzWnQnDktzpQWZ86yTU
	 ep7QNqfiRqK6fbgh08MQn6Q2m2y4S0Cbm3j/lxBsKcArbwGlnbKexVmBKeeMqq14ZG0wH
	 yhsXeH9R7Hz87Gt6GlhYBlaldzNzmIBUNSUU5iez1O7iNXAQcuVPdeKWQGQJ7dnn00f2w
	 h/6ZnVgmZxoFLHKhIzefN8BN53xn7c9dezFEulOZg6WZTu5e5lXpyD+2oaSZb8zbfcR+V
	 h8+Sdy5+5iKoctzxUJQxSkvlu9VEKFXWJWCr5N3XJP0SBhQL0UbjxPY52yd+/CsMffA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795054133;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=gnf0OgCLTzUFLP4xmVStHtIXL5MAv/6MDmMYCbggQWs=;
	b=FUF4u5xzaw1QSYyEMsHs2XTR0iVTCgI46HIxtGrzrsXEdyRkf60lfvVs3BgqBVtldb/P
	 awn6h7JBHEsB3166rqkyTaKqZxcdy9LtyW87pBGGsTmwrYL5cCxXEHcS5YCMrjjt8Fkt7
	 d4F1wJS11CN8P8iaNN9ZiqW4Ah4GWdHmIjiwaX6L0pW8GDxafnu3nI+k4gZirIAxIIU/v
	 LHM7tzvRurraeaRX2QihWwFPnfyy5E1JHk+/mte38njaJ3g3vXWCLcSXR2YSX1adGDRp4
	 Z7N6jTj2Y8K4Tljc6ZykTMDTMQUZgCyNh1l9GvkvE516KKVlT8zYhMcC+OSAtnqOC8w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=fXlLKKOT;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 63808606A320;
	Thu, 19 Nov 2026 02:08:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=fXlLKKOT
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B8E061F000C4;
	Thu, 19 Nov 2026 02:08:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795054133;
	bh=gnf0OgCLTzUFLP4xmVStHtIXL5MAv/6MDmMYCbggQWs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=fXlLKKOT+wbS2Kf4lmnp0dQ4BWoF99Xf90T9q/Uqw82ViiTxUHqor3wLgXNUZcBJo
	 KTanZwDI3msIjNToerKTJdZMs5+bqBzp+SswLrXOnHNeqGJmr75M1TlLecPq4nZqtW
	 bg9Ft83gSYLN+Vsth8BkkZ01x2DSg1PfX8gtWwXs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Stephen Boyd <swboyd@chromium.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 1167/2214] drm/msm/hdmi: fill the pwr_regs bulk regulators
Date: Wed, 18 Nov 2026 15:47:23 +0100
Message-ID: <20261118150058.698645819@linuxfoundation.org>
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

From: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>

[ Upstream commit a18a44e9262d5c7f7fbccbc9458df64d69185d41 ]

Conversion to use bulk regulator API omitted filling the pwr_regs with
proper regulator IDs. This was left unnoticed, since none of my testing
platforms has used the pwr_regs. Fix this by propagating regulator ids
properly.

Fixes: 31b3b1f5e352 ("drm/msm/hdmi: use bulk regulator API")
Signed-off-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Reviewed-by: Stephen Boyd <swboyd@chromium.org>
Patchwork: https://patchwork.freedesktop.org/patch/488847/
Link: https://lore.kernel.org/r/20220609113148.3149194-1-dmitry.baryshkov@linaro.org
Signed-off-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/msm/hdmi/hdmi.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/gpu/drm/msm/hdmi/hdmi.c b/drivers/gpu/drm/msm/hdmi/hdmi.c
index eb11fac881334..dee25a049e8f0 100644
--- a/drivers/gpu/drm/msm/hdmi/hdmi.c
+++ b/drivers/gpu/drm/msm/hdmi/hdmi.c
@@ -183,6 +183,9 @@ static struct hdmi *msm_hdmi_init(struct platform_device *pdev)
 		goto fail;
 	}
 
+	for (i = 0; i < config->pwr_reg_cnt; i++)
+		hdmi->pwr_regs[i].supply = config->pwr_reg_names[i];
+
 	ret = devm_regulator_bulk_get(&pdev->dev, config->pwr_reg_cnt, hdmi->pwr_regs);
 	if (ret) {
 		DRM_DEV_ERROR(&pdev->dev, "failed to get pwr regulator: %d\n", ret);
-- 
2.53.0



