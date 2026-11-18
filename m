Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795029990;
	b=gK4xt6qwXOulArurVN1+Kd/BsIB4S1Rl7ntktx141RoQgCK+JxekVQyTKLeSsWU3rSaH
	 TdMUg8PT4vQUdzJNNIGR5g7XM0VBFHwkmmrrO9eCHFWFox2gyht9OAD8GSmotEi4r5mEI
	 7GWL2+HSvQwgjPsCqMM2YWc1nIPi9r5goGl07LtN6DheieTvqu4BvgteL581u/w9/5IUC
	 aLP1MtkDn78LIZUb5OQxDoh6fIX9dMxUbmPnoHeOA7bG6PnQbZL1Pf397Nw8YP7z5XcMS
	 0Kwoa6UCGDFCxxqkXLH6zCaPhrqn4qOujEWYVvHyxhRaXEXWHsFQy5PoedAl1O6CAIA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795029990;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=26q5vvSh9Uz6tkX4rfUUJH6e6kqktUKoT03Umb21ndI=;
	b=lCnDlzpvp1aUA75As/tifQh6yO2HXX252hpiZD47yBSYEMoLTzj3YoLtGY/svI1KLeuG
	 RSE3g78rvVT5scKWmF5I+IsFVEinyQfsyg+CPjYsBATp4GMStnYh6KeLJWEJQK684jshY
	 UCA3TiynWXTvJxYhvPvXUnk5hJV+KodCs8oRP1+Ozwh070UHQjLa0N6ld/D5rgOAZlFvO
	 g8sX1I0Z7SC7NLikBV2lkPfhicurFIDjdplxRoJH6uJ8PVQ/nYP2MJOdKxW+WMD+wyGIq
	 qZ65DOu+9v39k4wlEct2S+JQ3vRhNDfJf8mKS9vzjpeoI4Kk2iXLvTwNVVlzjg9LlQQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=NQxul9pM;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BFA72606A32A;
	Wed, 18 Nov 2026 19:26:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=NQxul9pM
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CE3791F000C4;
	Wed, 18 Nov 2026 19:26:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795029990;
	bh=26q5vvSh9Uz6tkX4rfUUJH6e6kqktUKoT03Umb21ndI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=NQxul9pMXwhLOiOH/Pwv0QgRSNx4gD6d0rQVUB4u28mXwMfm497LbXuik9U7b+RTG
	 Feq80KPUBmNp1qrPKruDGelTSwxEmu5K5M93M533SUXd3D6GkglEuwtJORyNLUSjMH
	 3cR3NiVGlLBTQ4gdkChGVR8rsUYmP4M1r0J2YORk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Malathi A <malathi.a2000@gmail.com>,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0545/1756] serial: 8250_uniphier: Use devm_clk_get_enabled()
Date: Wed, 18 Nov 2026 15:44:32 +0100
Message-ID: <20261118150030.833751502@linuxfoundation.org>
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
index 4874a9632db39..6d8c0098bfa55 100644
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



