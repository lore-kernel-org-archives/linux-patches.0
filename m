Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795059611;
	b=yDb59Ods7fMSxnpkR0AqMneBS3wikvEG/DyTPfWIPxQr2vUWO3ahrKqb4i2bByL3NkNa
	 tf+uUKb6aN5qzwFR+sMdLwNAQYTGmL9SdeS+sFTwRhi1UgE7r8vRiWSTrK5HkbFEth2m0
	 G5huhOx5RnkV76wLeovPF8rYKgQM/kLiJDsgwRp1zFmiWSB0pTS8wTmgf3lyE/rmM/U0W
	 hWMSQBAxgqDQQvD8QzjvJIFCJO22fRIli4kDyJ7rz8xwZDLfNdEYBEu6qiuWuqG24CSsh
	 w28Opyh9l1Nxhl4CKH6er3kFXovWhuktQnqHL4jRWz1p41MA1MyaKPgCZeAPR9lcqOQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795059611;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=r5SWFQXqO7+LW6SsBVCkpBPKzIA20mBLfr8bzsoM0dc=;
	b=jmcjJJmZ/Ir0kKBXWQMzD9rmla+m40GSKqad4HuV3mkNYPRQsIST92/wgTkh4ebZg0Jz
	 KCf1m6zcUdWs3RseimSy3sOVyX0pDE50qMgNu/nBfK0KolyO/peBgBzkMdZ2+C4JgAsMm
	 iV/dBVbw/3JdQUp0vsxSYfhvn+4drqwhKdUf2IdPmI2M+gszbk/pmtC8igIUocm5ku7Qb
	 y3W9LNV/fD0uhXRh+y9yUU1k0UD4xaZObCbzZNJBfuKwIlrwACdQWHDrVjef4TiMJYWmx
	 OIqNBlvZQLcHpnzBVFYnoC2OsarxKTOvSvz0/BNi/nr7r3hNXu1yG4u4uCybnF2OYOQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ckha8WF9;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B8C7660A2626;
	Thu, 19 Nov 2026 03:40:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ckha8WF9
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1C17B1F000C9;
	Thu, 19 Nov 2026 03:40:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795059611;
	bh=r5SWFQXqO7+LW6SsBVCkpBPKzIA20mBLfr8bzsoM0dc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ckha8WF99+VUk+qvAox42Wfn0+1gx1Bek19UzhR3kWazPWgSr19568vV04v6fzu+R
	 uCWVpQSa19NI+9R9/Z5X76W2RThZBy1N/fX7+L0UACtzNlYYCNTdbDekyVPhiJt4gC
	 NkyhVz0x056kc+obYoMjptHIViM9ct2IQZQI76D0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= <u.kleine-koenig@pengutronix.de>,
	Thomas Gleixner <tglx@linutronix.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 0904/1848] irqchip/imx-intmux: Convert to platform_driver::remove_new() callback
Date: Wed, 18 Nov 2026 15:49:02 +0100
Message-ID: <20261118145954.625672995@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>

[ Upstream commit 984e5c7b8d7bac9efd3818e06dcf1f7aab7701b2 ]

The .remove() callback for a platform driver returns an int which makes
many driver authors wrongly assume it's possible to do error handling by
returning an error code. However the value returned is ignored (apart
from emitting a warning) and this typically results in resource leaks.

To improve here there is a quest to make the remove callback return
void. In the first step of this quest all drivers are converted to
.remove_new(), which already returns void. Eventually after all drivers
are converted, .remove_new() will be renamed to .remove().

Trivially convert this driver from always returning zero in the remove
callback to the void returning variant.

Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Link: https://lore.kernel.org/r/edeee074956dd943d3c67da894a01dc5f0d33bd7.1703284359.git.u.kleine-koenig@pengutronix.de
Stable-dep-of: b167c1a30e9e ("irqchip/imx-intmux: Fix runtime PM teardown on remove")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/irqchip/irq-imx-intmux.c | 14 ++++++--------
 1 file changed, 6 insertions(+), 8 deletions(-)

diff --git a/drivers/irqchip/irq-imx-intmux.c b/drivers/irqchip/irq-imx-intmux.c
index 7709f9712cb3b..576f28c9ebdb3 100644
--- a/drivers/irqchip/irq-imx-intmux.c
+++ b/drivers/irqchip/irq-imx-intmux.c
@@ -286,7 +286,7 @@ static int imx_intmux_probe(struct platform_device *pdev)
 	return ret;
 }
 
-static int imx_intmux_remove(struct platform_device *pdev)
+static void imx_intmux_remove(struct platform_device *pdev)
 {
 	struct intmux_data *data = platform_get_drvdata(pdev);
 	int i;
@@ -302,8 +302,6 @@ static int imx_intmux_remove(struct platform_device *pdev)
 	}
 
 	pm_runtime_disable(&pdev->dev);
-
-	return 0;
 }
 
 #ifdef CONFIG_PM
@@ -358,11 +356,11 @@ static const struct of_device_id imx_intmux_id[] = {
 
 static struct platform_driver imx_intmux_driver = {
 	.driver = {
-		.name = "imx-intmux",
-		.of_match_table = imx_intmux_id,
-		.pm = &imx_intmux_pm_ops,
+		.name		= "imx-intmux",
+		.of_match_table	= imx_intmux_id,
+		.pm		= &imx_intmux_pm_ops,
 	},
-	.probe = imx_intmux_probe,
-	.remove = imx_intmux_remove,
+	.probe		= imx_intmux_probe,
+	.remove_new	= imx_intmux_remove,
 };
 builtin_platform_driver(imx_intmux_driver);
-- 
2.53.0



