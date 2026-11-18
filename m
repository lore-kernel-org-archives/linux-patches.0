Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795030714;
	b=AMVhlvhhNwY/LtTuenbv/W3EPEXdmXA/Sy/ckHbamGbg+thJEzTHCaPHwXB98ly6pDpi
	 UIY43HIn7PYJFnQEOM2vN0SquBHz/iuYzFkzipW5+GF+tr6FYiCJCm/0qjs9zwfYA2/KX
	 O2YG5hqB3JRj2Py12Ft3wFno0Whlmo4QYR7KsqqHPCvT3Z++Dw7HuJU12sCS9oEtyF5ZH
	 FmKOpTKNffBnY63RImMMddfVTVskwwENvu4C0PAnnYXmdb1NxptkDOaNFf+w9dBrYivkK
	 Jdkk0uwtXr9AS5z0J6iTNT9KWlGWbt7t57rgLLDbK2Lnw0WgU/D3YfUe8MV67AwDg3A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795030714;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=0e1X77e29irC43T4uYgy5fjQSYFi7hUS8Zag9KMuT4U=;
	b=DdU7pAHrb3W5DiwL6SchBLkbynm1zEWpyi4aVXLZDTePJUrzRwuttJMkUB2Tp+fCHXK1
	 Fyx0Ehxf3tZWbzmZ8QoqCtqwIlZpyzVfDVIE94y8CJToA+lG2Q1EnoeJnX1J50SjUntdi
	 5PnlnWiiy2fj3iUgngi5jSrhIUGW4DMhY2X+2DJxhYocz7x+mHcbzedBork6xrek77GjL
	 qai/VzPAZdg4npGKF6+lcwRNPdQm0OfYWDo7QkyVVHmWq9O9+WpRksFJWRuoaQXclqE3J
	 AalevMz9XzLDPiGqnuQLqDxRX88r9K8fFDuFJsJCihEmBhmi/DaGdpXcHLINfvPaq4Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=gU4px0cR;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 26D84606A333;
	Wed, 18 Nov 2026 19:38:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=gU4px0cR
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7A01B1F000C6;
	Wed, 18 Nov 2026 19:38:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795030714;
	bh=0e1X77e29irC43T4uYgy5fjQSYFi7hUS8Zag9KMuT4U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=gU4px0cRqxM7qtb0Q1Xgz/GM/dT3C6SYJlM1amu3tvh5ILTEwGvntFD+7beuZSWBM
	 UsvgJRmfH4InnSds2MacVchuza/IalXyr69ttAxDotJKcWi36UlRkITnBtbaciACKN
	 XvG0vv180PwtnZhetekFt3eHJR4sGYRoIgd3bsiQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pei Xiao <xiaopei01@kylinos.cn>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0803/1756] phy: freescale: fsl-samsung-hdmi: Use helper function devm_clk_get_enabled()
Date: Wed, 18 Nov 2026 15:48:50 +0100
Message-ID: <20261118150041.639425628@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150007.957976754@linuxfoundation.org>
References: <20261118150007.957976754@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pei Xiao <xiaopei01@kylinos.cn>

[ Upstream commit 279950205dde78bc0e3ca73a8dfee6842f0e1edc ]

Since commit 7ef9651e9792 ("clk: Provide new devm_clk helpers for prepared
and enabled clocks"), devm_clk_get() and clk_prepare_enable() can now be
replaced by devm_clk_get_enabled() when driver enables the clocks for the
whole lifetime of the device. Moreover, it is no longer necessary to
unprepare and disable the clocks explicitly.

Signed-off-by: Pei Xiao <xiaopei01@kylinos.cn>
Link: https://lore.kernel.org/r/tencent_9087BCE04E38E6AA5C4B2252B82FA99C2009@qq.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Stable-dep-of: c01ccf91b257 ("phy: freescale: fsl-samsung-hdmi: initialize default rate")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/phy/freescale/phy-fsl-samsung-hdmi.c | 10 +---------
 1 file changed, 1 insertion(+), 9 deletions(-)

diff --git a/drivers/phy/freescale/phy-fsl-samsung-hdmi.c b/drivers/phy/freescale/phy-fsl-samsung-hdmi.c
index 029de69fbeaf4..0c7a107bba307 100644
--- a/drivers/phy/freescale/phy-fsl-samsung-hdmi.c
+++ b/drivers/phy/freescale/phy-fsl-samsung-hdmi.c
@@ -706,7 +706,7 @@ static int fsl_samsung_hdmi_phy_probe(struct platform_device *pdev)
 	if (IS_ERR(phy->regs))
 		return PTR_ERR(phy->regs);
 
-	phy->apbclk = devm_clk_get(phy->dev, "apb");
+	phy->apbclk = devm_clk_get_enabled(phy->dev, "apb");
 	if (IS_ERR(phy->apbclk))
 		return dev_err_probe(phy->dev, PTR_ERR(phy->apbclk),
 				     "failed to get apb clk\n");
@@ -716,12 +716,6 @@ static int fsl_samsung_hdmi_phy_probe(struct platform_device *pdev)
 		return dev_err_probe(phy->dev, PTR_ERR(phy->refclk),
 				     "failed to get ref clk\n");
 
-	ret = clk_prepare_enable(phy->apbclk);
-	if (ret) {
-		dev_err(phy->dev, "failed to enable apbclk\n");
-		return ret;
-	}
-
 	pm_runtime_get_noresume(phy->dev);
 	pm_runtime_set_active(phy->dev);
 	pm_runtime_enable(phy->dev);
@@ -737,8 +731,6 @@ static int fsl_samsung_hdmi_phy_probe(struct platform_device *pdev)
 	return 0;
 
 register_clk_failed:
-	clk_disable_unprepare(phy->apbclk);
-
 	return ret;
 }
 
-- 
2.53.0



