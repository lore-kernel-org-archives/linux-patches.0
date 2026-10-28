Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793214998;
	b=PX/NehoE6IRB3PHcK+NuMpWI1ZTILs+NWxqkJnZxXqsKs7TmPzFtyBSmka4Q7SzG7OFM
	 HJpUhTCeO9ShVRNtW5j1ymBzwICIQZzzIo89K8L7nbsVP7RdQWRr00SRBgo/HMaJHih11
	 PftoXzkFe2Mj2bsibQAaREmiUJP9yv/hQ5UERCK5tEMU6OfzboaHTIvagIlnxrsn37pTe
	 NoUrY11w23yTCUAdtnSXE36oMY6Dw+0WtIjGWgKsfSwFZWt6EIVwNgS+vkjl3qr9ld44K
	 b+E2VCd4IjmCF8tvXmiGJm8NOQaMZbw3iAQBRBH2bapcdIi+jDsATNfN3nmVSw4mJhw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793214998;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=qsSaYpN/9ia8peo8G2hvDWH16Y3CgxnsarVM18JmEmc=;
	b=PFBgVzYBUC2eySKGYia5X89e6IiC+2zHmr+DR6W5KryFSGgSq66i5ZAxaVO7Q7u+xbf0
	 4agjjLWzyTV1gCv58R1FDvks9Qs6RwCr37RcUOp5A5I+6FdCRU1l7UNfV3BEqaT3+vLOw
	 1YZ2TEu2R3R7d0LUrdfVCJ6iFXVK3HUmn/8Dy9d4atEWECjJgfzjhp+mSoRLjX7r9NFrR
	 GvMoPELqB0q4o1aVdEPEDvSewZd96dc94TwuteVCbCYSk8ZtWx3ax7wbfBFmrXVA2c1K7
	 HhvxA+4YsKVvrBOpaaccFITcz5qa8tyeYPzoayZwC7EZvXxU38f/apS4bFUYVIdsLAg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=LGORol8l;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DCDB9606A31D;
	Wed, 28 Oct 2026 19:16:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=LGORol8l
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3AF341F01825;
	Wed, 28 Oct 2026 19:16:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793214997;
	bh=qsSaYpN/9ia8peo8G2hvDWH16Y3CgxnsarVM18JmEmc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=LGORol8lEmcRg8Y682cJdjc5C0yt2iOvV+JXd3WxHVHuhDAqcPjpjuGT9GvSUKEGb
	 K7qTnlYG5UiewhdMSwwYqZhcx/7u/zk0Ycs/uYS7K51BIk/RcQJ/X6s8L5KsqJXQZq
	 zxsxvYYZHin/iemy8Fa4fmH8WWKQpJN/OI31423I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= <u.kleine-koenig@pengutronix.de>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1057/1887] spi: rspi: Convert to platform remove callback returning void
Date: Wed, 28 Oct 2026 17:52:33 +0100
Message-ID: <20261028170523.459998620@linuxfoundation.org>
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

[ Upstream commit 72ec0e8f89a1536e4594606d60a946636ee7d94b ]

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
Link: https://lore.kernel.org/r/20230303172041.2103336-62-u.kleine-koenig@pengutronix.de
Signed-off-by: Mark Brown <broonie@kernel.org>
Stable-dep-of: 9944fa6726af ("spi: rspi: fix controller deregistration")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/spi/spi-rspi.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/spi/spi-rspi.c b/drivers/spi/spi-rspi.c
index 411b1307b7fd8..f494c86bafea4 100644
--- a/drivers/spi/spi-rspi.c
+++ b/drivers/spi/spi-rspi.c
@@ -1172,14 +1172,12 @@ static void rspi_release_dma(struct spi_controller *ctlr)
 		dma_release_channel(ctlr->dma_rx);
 }
 
-static int rspi_remove(struct platform_device *pdev)
+static void rspi_remove(struct platform_device *pdev)
 {
 	struct rspi_data *rspi = platform_get_drvdata(pdev);
 
 	rspi_release_dma(rspi->ctlr);
 	pm_runtime_disable(&pdev->dev);
-
-	return 0;
 }
 
 static const struct spi_ops rspi_ops = {
@@ -1440,7 +1438,7 @@ static SIMPLE_DEV_PM_OPS(rspi_pm_ops, rspi_suspend, rspi_resume);
 
 static struct platform_driver rspi_driver = {
 	.probe =	rspi_probe,
-	.remove =	rspi_remove,
+	.remove_new =	rspi_remove,
 	.id_table =	spi_driver_ids,
 	.driver		= {
 		.name = "renesas_spi",
-- 
2.53.0



