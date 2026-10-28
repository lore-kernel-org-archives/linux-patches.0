Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793213878;
	b=RyOlg1HUAzDbWPh+eJzHh2p3AiL4emEGLnbo9SB8CBth7LKXLPtF58drteRdcZIvcOX9
	 uimmLUvJAChit5imTCqABSws4F1WJ9eggnnlRfKRXiVTv5YWq6QbY+tvWqWqFpgKZvHwq
	 vF/mT2PqGu/L94j+8BzP6NjVSWCdl6D9l59/Mw+kdYBJYjzIiu5QWHUFzLB7CfZdOJ8IM
	 dvGPrG4wp3lPwZBHzadiYUynhw73Dd1vnM/Z2ILf1j4zplPYCWHmIdmw++8/TyaUp3B7k
	 WNkh+JJJQUoqZ2/1wm1+XUqRwwcqFXb3tHtqrd17yqu1tL/o8nFWJGVwzbUGKtfC+Mw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793213878;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=+k/QV1e8Oq9JTkrn+u5QYxt0ZDYHyKrlVL/7nO64Bgs=;
	b=f7/mv51fmgOZ3bc2dfXn/iFUwHI31V6Pg8zgBWy5x+jiR3XC2orcrz+U/lNdGcElUnx2
	 Dq2j4kKN0LhPr53xGoblHC8aM1PIcZN/P3fEKPF1lxSqKNCuXAe3wPGFeYgRxCg6IEKRl
	 yLppAmJEYGmO5Fi/X4Jxi/m5pUSYX/K+LGPnTAbZn0R7g2atRp+hUc6Y2q4DOAq3sCE64
	 UQpNwaqnxgt01Di7B1ry1fLYCW+srT+lgAaQNogSE6QlTM/M3dIrlY5wNCbPDRuoJTgY8
	 R+444VZ4hFZbbddKkPgYOuvN4B4/BqfdD/CiOUypMQqVR1LlsAKviVaOWiMIFe4HV+w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Vhf0YakD;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E42FC606A31A;
	Wed, 28 Oct 2026 18:57:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Vhf0YakD
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3E7D61F01825;
	Wed, 28 Oct 2026 18:57:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793213877;
	bh=+k/QV1e8Oq9JTkrn+u5QYxt0ZDYHyKrlVL/7nO64Bgs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Vhf0YakD3Y/zNtCcj7XZ1EnFfumE5LORumM500QaMFaYg+wNCSzGL6drnMJr9/Epy
	 PRIUHCL47QyyfSSvs5JLBhybZgsVe9KqBO6r33s+ioDzCRKSv8U9QYYS5aoJFBM3db
	 SQXpVQQLoDgsalcg6/twpB0tB/2sB0AztUZfY8eE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= <u.kleine-koenig@pengutronix.de>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0660/1887] spi: hisi-kunpeng: Convert to platform remove callback returning void
Date: Wed, 28 Oct 2026 17:45:56 +0100
Message-ID: <20261028170514.431762500@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>

[ Upstream commit e77ccdfe0145211b5a20ab62950894aea881bbb3 ]

The .remove() callback for a platform driver returns an int which makes
many driver authors wrongly assume it's possible to do error handling by
returning an error code. However the value returned is (mostly) ignored
and this typically results in resource leaks. To improve here there is a
quest to make the remove callback return void. In the first step of this
quest all drivers are converted to .remove_new() which already returns
void.

Trivially convert this driver from always returning zero in the remove
callback to the void returning variant.

Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
Link: https://lore.kernel.org/r/20230303172041.2103336-31-u.kleine-koenig@pengutronix.de
Signed-off-by: Mark Brown <broonie@kernel.org>
Stable-dep-of: 5127c42c77de ("spi: hisi-kunpeng: Add verification for the max_frequency provided by the firmware")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/spi/spi-hisi-kunpeng.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/spi/spi-hisi-kunpeng.c b/drivers/spi/spi-hisi-kunpeng.c
index 06c8893243b7d..2cfc820c8adcc 100644
--- a/drivers/spi/spi-hisi-kunpeng.c
+++ b/drivers/spi/spi-hisi-kunpeng.c
@@ -531,15 +531,13 @@ static int hisi_spi_probe(struct platform_device *pdev)
 	return 0;
 }
 
-static int hisi_spi_remove(struct platform_device *pdev)
+static void hisi_spi_remove(struct platform_device *pdev)
 {
 	struct spi_controller *master = platform_get_drvdata(pdev);
 	struct hisi_spi *hs = spi_controller_get_devdata(master);
 
 	debugfs_remove_recursive(hs->debugfs);
 	spi_unregister_controller(master);
-
-	return 0;
 }
 
 static const struct acpi_device_id hisi_spi_acpi_match[] = {
@@ -550,7 +548,7 @@ MODULE_DEVICE_TABLE(acpi, hisi_spi_acpi_match);
 
 static struct platform_driver hisi_spi_driver = {
 	.probe		= hisi_spi_probe,
-	.remove		= hisi_spi_remove,
+	.remove_new	= hisi_spi_remove,
 	.driver		= {
 		.name	= "hisi-kunpeng-spi",
 		.acpi_match_table = hisi_spi_acpi_match,
-- 
2.53.0



