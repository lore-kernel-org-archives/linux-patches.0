Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795017100;
	b=39Zn85pvnIdO60mS442tkS9lGtT2mrqDiLl/9CR1uSzcT1hBcyR5jccxpMK8PHZ+MxFx
	 du63cR4uq4IyTP5SqnjdLUxuefuSEST9V8JrQnBzonElSMXOT8WHatXSpm7+tUAA4MHn7
	 WLC79UNBN6VxXwMlw/hPUo19pVs25ZcEL0KJXAfIrFcZEiL8eo1MN84Xj8ZB9sCZqkEku
	 /LXUAZhn1QuiPTVEa2kTeM8sb58O9bZPSyA9dr9P4g3d2gR3UInsYAjt5dgmUgjZh82Gk
	 cbaT6K5XgG49o7bYE2NIHR0X3EM6KPsRTyHjUq1Xn6cl3DpVQ9DUs9el6N6+qg3gWag==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795017100;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=MgeBffdAD1PSwqB9z/TJu/Wvv3J/EtpMDa1T5x3BO/8=;
	b=znHDiWgLuKf8qphgzh6FUpqkNSQK24E1fnM+xZ2UpYNC1aWJ0KZAIdGiExkM80vdziD7
	 jNJHDHoPWI3NWzQDqRW1J9d1JwQfhW0u37ExWEOEzoFQl4FoAAIj9TeGK13bgUkDcbni8
	 pbwnOjgUDCC8WP0cwV6Ou6VD47rGz9+nQ87CnrVMuqqdWP0S7dLvLNPeusibcJGb0HuDT
	 WFxysEh4tWYhqp8W2RemSTIyWFcd3h7OTYM+ZWRPEXBTijeAH+fszwOIitVLf4wP32TML
	 tEUgMGB9i1K0gjslJVBfSzgSLs28V3ClzrvKX8jdKrdVA0bAqruAvKOmfmhu3S/SIVg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=LPO4ci4c;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4FC51606A32C;
	Wed, 18 Nov 2026 15:51:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=LPO4ci4c
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6E8791F000C4;
	Wed, 18 Nov 2026 15:51:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795017099;
	bh=MgeBffdAD1PSwqB9z/TJu/Wvv3J/EtpMDa1T5x3BO/8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=LPO4ci4ctZe6afSHipox6kk1P+29pyLQyOVeTGxEejYxfX7ArdjPW4WuSeX/0O3of
	 pOH0LANbHyIB7eyxNClH7jiZIEaf62ylJNs20szX58G2yTAezEPekE1ZmWf1oVUdmo
	 K9ezL+2mX+MhhlGp87SreTKU5nOhK7pOPi3E8PQA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Malathi A <malathi.a2000@gmail.com>,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0737/2651] serial: 8250_uniphier: Use devm_clk_get_enabled()
Date: Wed, 18 Nov 2026 15:32:57 +0100
Message-ID: <20261118150314.407571102@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Malathi A <malathi.a2000@gmail.com>

[ Upstream commit 790aacba3fdfd3a227cdd5e4952c596ed66a0ed8 ]

uniphier_uart_probe() enables priv->clk by hand and is then responsible
for disabling it again on every error path. It misses one: when
uart_read_port_properties() fails the function returns directly, leaving
the clock prepared and enabled. The neighbouring path, taken when
serial8250_register_8250_port() fails, does call clk_disable_unprepare(),
which shows the leak is an oversight rather than intent.

Rather than adding another manual unwind, switch to
devm_clk_get_enabled() so the clock is released by devres. That removes
the error path entirely, along with the explicit disables in the
register failure path and in uniphier_uart_remove().

The clock is still disabled and re-enabled by hand across system sleep,
which stays balanced: only SET_SYSTEM_SLEEP_PM_OPS is used, so the
device cannot be unbound while suspended and devres always sees an
enabled clock at detach.

Found by smatch:

  drivers/tty/serial/8250/8250_uniphier.c:232 uniphier_uart_probe() warn: 'priv->clk' from clk_prepare_enable() not released on lines: 205.

Fixes: 26e8349c0d76 ("serial: 8250_uniphier: Switch to use uart_read_port_properties()")
Signed-off-by: Malathi A <malathi.a2000@gmail.com>
Reviewed-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Link: https://patch.msgid.link/20260917040511.103232-1-malathi.a2000@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/tty/serial/8250/8250_uniphier.c | 10 ++--------
 1 file changed, 2 insertions(+), 8 deletions(-)

diff --git a/drivers/tty/serial/8250/8250_uniphier.c b/drivers/tty/serial/8250/8250_uniphier.c
index e3db60bf50c93..6fffac12277ac 100644
--- a/drivers/tty/serial/8250/8250_uniphier.c
+++ b/drivers/tty/serial/8250/8250_uniphier.c
@@ -180,16 +180,12 @@ static int uniphier_uart_probe(struct platform_device *pdev)
 
 	memset(&up, 0, sizeof(up));
 
-	priv->clk = devm_clk_get(dev, NULL);
+	priv->clk = devm_clk_get_enabled(dev, NULL);
 	if (IS_ERR(priv->clk)) {
-		dev_err(dev, "failed to get clock\n");
+		dev_err(dev, "failed to get and enable clock\n");
 		return PTR_ERR(priv->clk);
 	}
 
-	ret = clk_prepare_enable(priv->clk);
-	if (ret)
-		return ret;
-
 	up.port.uartclk = clk_get_rate(priv->clk);
 
 	spin_lock_init(&priv->atomic_write_lock);
@@ -222,7 +218,6 @@ static int uniphier_uart_probe(struct platform_device *pdev)
 	ret = serial8250_register_8250_port(&up);
 	if (ret < 0) {
 		dev_err(dev, "failed to register 8250 port\n");
-		clk_disable_unprepare(priv->clk);
 		return ret;
 	}
 	priv->line = ret;
@@ -237,7 +232,6 @@ static void uniphier_uart_remove(struct platform_device *pdev)
 	struct uniphier8250_priv *priv = platform_get_drvdata(pdev);
 
 	serial8250_unregister_port(priv->line);
-	clk_disable_unprepare(priv->clk);
 }
 
 static int __maybe_unused uniphier_uart_suspend(struct device *dev)
-- 
2.53.0



