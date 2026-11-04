Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793830995;
	b=5jG4w9CsRXfGifR9SI3+wVuY/ZdXS+ZExtdGMbVMmHIng1Eokwc49sTRoDYyUqIG8O3s
	 0Djmbs1cAbRWZNiqg5wAM6ZpV6uV0aMPkNI0m0dXpcD8G8XMKONEP5SAwU3zfTSZJz3G/
	 HD7R9sZG/TUCIJQMf8VkJECH1QQavWvG7ELcqYrwMpR59nnr4oT2u0hQ+CmdOC+VEEEEa
	 /OMSCXA/ocgA/JcLtXFE783CzQAudKNINpaIhyL7Qh5wKhF1DGxxVIxMhoNaMoZrUa0qN
	 Wbbj1UrSpV+n93dAN1YQ0eX6e5PoggrlfGWY4aqpSoZpMEVnkzSZs9s6ONUJJJ2Rb1A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793830995;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=d5bThy5byQQtPT2P5u8FnEc9h8JqkzKtvE4wleBlYYI=;
	b=GmzYMK6DN7CxekOiY89312XzLNNFhaXOTTBpvqehkbTFFhiiQzXcbqKC7xZ5vVxaTlGK
	 ElvO4VTiKxvFxuTY/EeyE2c1k90Lt7Nc0p2mADcqflcfYOUgrrkSOGPHuk247ZYBoOE2/
	 XPxrk8xBvWXODKlEJVZ3ppx9Ed66OUtk4IUVBeVlcaWGH4smBlRWOTxdOt6X9ZI01hdOl
	 71dMzCWRt/Tld+eh+5gIDvJxQZvt77QhsWgVOFNhbm93cALFtNIShlgkBV/ETZoPAS0q2
	 CTejYd0qeQajd6GGkHSH6Qfav9soyCOv2akpdPmRmkvHK6VPnZtAfNy8FVBqlEUcSEA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=KIUcGIr1;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A8F3C606AB06;
	Wed,  4 Nov 2026 22:23:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=KIUcGIr1
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 445F11F00919;
	Wed,  4 Nov 2026 22:23:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793830994;
	bh=d5bThy5byQQtPT2P5u8FnEc9h8JqkzKtvE4wleBlYYI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=KIUcGIr1kbJ7R56QZmGoDbDUmwpyO/9l8pHpglWcdg1O3Br3UZYzIPc4P6CQhYzCD
	 cC+zVpyXlj1RMrrTQUFW4XmIieK3i4jtPadlM3DBcjMJbtKrjvkC8xzTLovPG8SRVi
	 pc5+ciU33rFiYfNCr8oa1ccpRYe1iCBHK3chl9no=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Carlos Song <carlos.song@nxp.com>,
	Frank Li <Frank.Li@nxp.com>,
	Andi Shyti <andi.shyti@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0445/1005] i2c: imx-lpi2c: properly unwind resources on probe failure
Date: Wed,  4 Nov 2026 16:02:58 -0500
Message-ID: <20261104211056.529327861@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261104211043.516122098@linuxfoundation.org>
References: <20261104211043.516122098@linuxfoundation.org>
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
index 24c70ea371bb9..7c560a4f68319 100644
--- a/drivers/i2c/busses/i2c-imx-lpi2c.c
+++ b/drivers/i2c/busses/i2c-imx-lpi2c.c
@@ -1500,14 +1500,18 @@ static int lpi2c_imx_probe(struct platform_device *pdev)
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
@@ -1545,8 +1549,11 @@ static int lpi2c_imx_probe(struct platform_device *pdev)
 
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



