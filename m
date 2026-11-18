Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795024924;
	b=N26CoeXvJZ4Gtl7cXkUO2hm5AumvVLXWJX9g4afpf72MZ/Y1jmFfEAFU1MEJSw+LpgNg
	 RywsiPE6P2e5iBhn2qIyjd7l3koRqtYxMrUwhBxybg33ASAnCUy61Abrzse2Ze7+Wo6NG
	 V7pyb9NVulibnnJASVOXhB8I4pXCGdJTCgBFqXCKaP1e+FXQE6yTr2YI6Nq8qGa553fzf
	 D0969z2am5LYweSMeK1Y3/PKpSX5mwsG84SVawUonKiPW4vxCVK9gGmcCoi8Et/SHdUeV
	 ZnthRK6f4dp1uxaaK1UjqefJXVGpngPt5FuVz3PO32X4dEdwYeQyXiUTb12qjY0Vl1A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795024924;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=neWsZn9Q51fF3u3C1/i04ZkQDeOSzBXIdc0hwPMiDTc=;
	b=mpCU/t17WOR1IPwBco0wQgp0qjzSqPTtkUhwcpfzHicObQFUb81U9Qu3shIKUmSN8411
	 l07KNk/W9TFgodb/IS3tuex8hk9NcefpqaD5faDAVW8GlJiiacuce0/GUEOFaq9+QLmIs
	 YxvAjvXf7SF7p37sVZwOFtcnFYsQCJ9BYTUcsTTYHESsJKqwkKUlu+/X9UaMrSo059fZO
	 Q0zqoIoGl/nt+cMDinWFQpL/vHkdAaNMx6Z6l3NqlxUN7xEoNT3p8E51zu5bzFJ8lZ7w5
	 0wlpXGKjPs8L46QFxrf2brYphAOI+3W0vrnb6lzMQTm4ANxa4ORRNt6r8yotAzqznZg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=fS7Zs1Jp;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D63F606A31C;
	Wed, 18 Nov 2026 18:02:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=fS7Zs1Jp
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 513341F000C4;
	Wed, 18 Nov 2026 18:02:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795024923;
	bh=neWsZn9Q51fF3u3C1/i04ZkQDeOSzBXIdc0hwPMiDTc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=fS7Zs1JpYypF5QrxOEBNtA1jeaId/AA9Da6Pv14SsLsB4QskSps4KHA6T7FK53awi
	 Z23D4OWk76kbWQajgEmqQ1oda59eiXceJw/6QhR4j+ug5FoH1v/98dCghfPM7QYvMK
	 OXDWcezCmFjBzFn9NeUlUN2DPPhgUOigkfBE9m5w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wentao Liang <vulab@iscas.ac.cn>,
	Linus Walleij <linusw@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0896/2151] pinctrl: nuvoton: Fix clock reference leak in ma35_get_bank_data()
Date: Wed, 18 Nov 2026 15:43:51 +0100
Message-ID: <20261118150154.936579270@linuxfoundation.org>
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

From: Wentao Liang <vulab@iscas.ac.cn>

[ Upstream commit a854aa8e550502ef05c2836a4b426141d735bed1 ]

ma35_get_bank_data() obtains the bank clock with of_clk_get() and
stores it in bank->clk, but returns clk_prepare_enable() directly.  If
that call fails, the reference taken by of_clk_get() is never dropped,
and the driver has no other clk_put() for it.

Drop the reference when clk_prepare_enable() fails.

Fixes: f805e356313b ("pinctrl: nuvoton: Add ma35d1 pinctrl and GPIO driver")
Signed-off-by: Wentao Liang <vulab@iscas.ac.cn>
Signed-off-by: Linus Walleij <linusw@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pinctrl/nuvoton/pinctrl-ma35.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/drivers/pinctrl/nuvoton/pinctrl-ma35.c b/drivers/pinctrl/nuvoton/pinctrl-ma35.c
index f5efa6725c405..3da7e517d1b6e 100644
--- a/drivers/pinctrl/nuvoton/pinctrl-ma35.c
+++ b/drivers/pinctrl/nuvoton/pinctrl-ma35.c
@@ -561,6 +561,8 @@ static int ma35_gpiolib_register(struct platform_device *pdev, struct ma35_pinct
 
 static int ma35_get_bank_data(struct ma35_pin_bank *bank)
 {
+	int ret;
+
 	bank->reg_base = fwnode_iomap(bank->fwnode, 0);
 	if (!bank->reg_base)
 		return -ENOMEM;
@@ -573,7 +575,11 @@ static int ma35_get_bank_data(struct ma35_pin_bank *bank)
 	if (IS_ERR(bank->clk))
 		return PTR_ERR(bank->clk);
 
-	return clk_prepare_enable(bank->clk);
+	ret = clk_prepare_enable(bank->clk);
+	if (ret)
+		clk_put(bank->clk);
+
+	return ret;
 }
 
 static int ma35_pinctrl_get_soc_data(struct ma35_pinctrl *pctl, struct platform_device *pdev)
-- 
2.53.0



