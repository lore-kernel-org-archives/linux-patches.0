Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F8023C472
	for <patches@lists.linux.dev>; Wed, 15 Nov 2023 19:40:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RrpAsfjv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BBB44C433C7;
	Wed, 15 Nov 2023 19:40:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700077218;
	bh=Jqp7PqDDKntga1Z3SoBTt6lSQJBat9dnaKiMMdF6SW8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RrpAsfjvBbWomsoaBisi6aX+PElFbwthmC6cL1Slps4eLOTrHb6k1Iauw0P0w9kmQ
	 UEed/xZPQnYQTzZAEMKNjZKieKpSjMyiTvTs9HfgzE7oxN17GZe6agPdQRErY2LM5M
	 H1qRCdWZu//EoLf5NZ/Sbif8VtqMgH2aTeEaYYRs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Peng Fan <peng.fan@nxp.com>,
	Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
	Abel Vesa <abel.vesa@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 170/603] clk: imx: imx8: Fix an error handling path if devm_clk_hw_register_mux_parent_data_table() fails
Date: Wed, 15 Nov 2023 14:11:55 -0500
Message-ID: <20231115191624.968901659@linuxfoundation.org>
X-Mailer: git-send-email 2.42.1
In-Reply-To: <20231115191613.097702445@linuxfoundation.org>
References: <20231115191613.097702445@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Christophe JAILLET <christophe.jaillet@wanadoo.fr>

[ Upstream commit 9a0108acdb1b6189dcc8f9318edfc6b7e0281df4 ]

If a devm_clk_hw_register_mux_parent_data_table() call fails, it is likely
that the probe should fail with an error code.

Set 'ret' before leaving the function.

Fixes: d3a0946d7ac9 ("clk: imx: imx8: add audio clock mux driver")
Reviewed-by: Peng Fan <peng.fan@nxp.com>
Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Signed-off-by: Abel Vesa <abel.vesa@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/imx/clk-imx8-acm.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/clk/imx/clk-imx8-acm.c b/drivers/clk/imx/clk-imx8-acm.c
index 87025a6772d0e..73b3b53549517 100644
--- a/drivers/clk/imx/clk-imx8-acm.c
+++ b/drivers/clk/imx/clk-imx8-acm.c
@@ -373,6 +373,7 @@ static int imx8_acm_clk_probe(struct platform_device *pdev)
 										sels[i].shift, sels[i].width,
 										0, NULL, NULL);
 		if (IS_ERR(hws[sels[i].clkid])) {
+			ret = PTR_ERR(hws[sels[i].clkid]);
 			pm_runtime_disable(&pdev->dev);
 			goto err_clk_register;
 		}
-- 
2.42.0



