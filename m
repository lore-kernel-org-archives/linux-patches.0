Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794061091;
	b=DOIzprKBZ3NjLNCDWHB6UUpUYiNT0szRqG9b9V9XVYrtmSZ8kHshgvoZ9/yJEELaa4Gl
	 +DSu/bg0pMjTUuGTeS3wSWuNuTsdiuJ/tksvBDFtPbSW5GXeiYvRCRW/eqgQFgQajX8QB
	 mF7+TUzv9Ze9vww8P3j9Z282oIWKqc1yPSPQ5ehfLk94h0LKUbCuFaAyvntpeBHYHKgUb
	 uelSZ/oNfbmqB+f/e9nlOsk7ePM5Ryq+b0427HHokm0qWBXiZVcr7G2YrpYaCwvIglr3j
	 PBtqw++RLcA+ZKzl+L7fNU8nlVTX8uGelaL/bogIOsDD3m5Y6OJ05MfOFx+0RbF51Dw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794061091;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=HFW0JzSjz+107Bld7nHtDezCyuDAEo3FnLnJQ96+3g4=;
	b=SxyePYQ2Hklz09SRMOFc1B7BKJeUP5jhj/S+r7MhtvcVoFkHD+LFoI1jdR9n8BfJZDEI
	 +yE6Qk+rE/hm3gfr6J8YBTEewtD85j2iOAV/JjpNG1Km237ZrmIKJ5o2pJsSfjpR9T5g2
	 a5M4llKAKT6ix7NW8p7tJMkFhMyBA42ZyvIA20ITxR7tVJFGKivKEsv/epSzNrxId0vk9
	 vapG27I+2zoD67AOmJaV/5xZLeZobzh3mMoVdfe2SM3cR7dEEq2X7AtYmjEE1+rfhadq5
	 ZBk5j0aOlBujucjTGG3Flq/3g1tpezi0CADpNGzwMVirVn1LCAEwa4r/twzLMIiIwIg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ofcbbF3e;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D2EA7606D833;
	Sat,  7 Nov 2026 14:18:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ofcbbF3e
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 742481F008A4;
	Sat,  7 Nov 2026 14:18:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794061090;
	bh=HFW0JzSjz+107Bld7nHtDezCyuDAEo3FnLnJQ96+3g4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ofcbbF3e6aVM47XYaxmldkRVeR+vBWwTPuyFCsxyzSQcWtwILwgCDlDeonN4ab7WU
	 Ak+KMfjgrBhWOZoTJSTw3ChxYJwH6BeSV4vA5i4YWGhmBsvntCs750D2P5tq5v52RU
	 mMfQ17iFyhmVEJMwk7pE2nT9bR1AB/zGWI33hjKs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Carlos Song <carlos.song@nxp.com>,
	Frank Li <Frank.Li@nxp.com>,
	Andi Shyti <andi.shyti@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0374/1536] i2c: imx-lpi2c: properly unwind resources on probe failure
Date: Sat,  7 Nov 2026 08:39:50 -0500
Message-ID: <20261107135008.144710343@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134957.653319350@linuxfoundation.org>
References: <20261107134957.653319350@linuxfoundation.org>
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

From: Carlos Song <carlos.song@nxp.com>

[ Upstream commit cbd043b00ee3f542c115c8809c4d9a67465c07d5 ]

When probe fails at devm_clk_rate_exclusive_get() or clk_get_rate(),
which occur before runtime PM is initialized, the clocks enabled by
clk_bulk_prepare_enable() are never disabled.

When probe fails after runtime PM is initialized, the previous error
path called pm_runtime_put_sync(), which triggers the runtime suspend
callback. However, due to different clock management strategies on
different SoCs[1] (to avoid deadlocks between the global prepare_lock
and runtime PM), the callback may only disable clocks without
unpreparing them, causing an incomplete unwind.

Introduce a new error label 'clk_disable' to explicitly invoke
clk_bulk_disable_unprepare(). Replace pm_runtime_put_sync() with the
sequence of pm_runtime_disable(), pm_runtime_set_suspended() and
pm_runtime_put_noidle() to bypass the runtime suspend callback during
error recovery. During the LPI2C driver probe phase, clock APIs are
used exclusively to manage clocks. Once probing succeeds, clock
management is handed over to the runtime PM core.

[1] https://lore.kernel.org/all/20251125084718.2156168-1-carlos.song@nxp.com/

Signed-off-by: Carlos Song <carlos.song@nxp.com>
Reviewed-by: Frank Li <Frank.Li@nxp.com>
Signed-off-by: Andi Shyti <andi.shyti@kernel.org>
Link: https://lore.kernel.org/r/20260716071957.2670263-2-carlos.song@oss.nxp.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/i2c/busses/i2c-imx-lpi2c.c | 21 ++++++++++++++-------
 1 file changed, 14 insertions(+), 7 deletions(-)

diff --git a/drivers/i2c/busses/i2c-imx-lpi2c.c b/drivers/i2c/busses/i2c-imx-lpi2c.c
index 86b41cd48ad4c..8103c14876d57 100644
--- a/drivers/i2c/busses/i2c-imx-lpi2c.c
+++ b/drivers/i2c/busses/i2c-imx-lpi2c.c
@@ -615,14 +615,18 @@ static int lpi2c_imx_probe(struct platform_device *pdev)
 	 * each transfer
 	 */
 	ret = devm_clk_rate_exclusive_get(&pdev->dev, lpi2c_imx->clks[0].clk);
-	if (ret)
-		return dev_err_probe(&pdev->dev, ret,
-				     "can't lock I2C peripheral clock rate\n");
+	if (ret) {
+		ret = dev_err_probe(&pdev->dev, ret,
+				    "can't lock I2C peripheral clock rate\n");
+		goto clk_disable;
+	}
 
 	lpi2c_imx->rate_per = clk_get_rate(lpi2c_imx->clks[0].clk);
-	if (!lpi2c_imx->rate_per)
-		return dev_err_probe(&pdev->dev, -EINVAL,
-				     "can't get I2C peripheral clock rate\n");
+	if (!lpi2c_imx->rate_per) {
+		ret = dev_err_probe(&pdev->dev, -EINVAL,
+				    "can't get I2C peripheral clock rate\n");
+		goto clk_disable;
+	}
 
 	pm_runtime_set_autosuspend_delay(&pdev->dev, I2C_PM_TIMEOUT);
 	pm_runtime_use_autosuspend(&pdev->dev);
@@ -653,8 +657,11 @@ static int lpi2c_imx_probe(struct platform_device *pdev)
 
 rpm_disable:
 	pm_runtime_dont_use_autosuspend(&pdev->dev);
-	pm_runtime_put_sync(&pdev->dev);
 	pm_runtime_disable(&pdev->dev);
+	pm_runtime_set_suspended(&pdev->dev);
+	pm_runtime_put_noidle(&pdev->dev);
+clk_disable:
+	clk_bulk_disable_unprepare(lpi2c_imx->num_clks, lpi2c_imx->clks);
 
 	return ret;
 }
-- 
2.53.0



