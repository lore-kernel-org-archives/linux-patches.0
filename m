Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793214190;
	b=rmktsFnsraiezOfroBsgboeMp9DwVm/1TogMmHiFBEAdZMTx+9LwiyX8JgwHX+Jyeu/f
	 LnbZR0w2tIc0L6qibQz/rP/NykngDtHcNzsvGbrAmwJADwqnrctMqQO1IdkE5OoGlimBv
	 3pqGgz4XewGqCLqWOu7Pmp9jOWhI+70Q+IhqUmpeO4AxX8q4j/ctVGFWpqvat6XmoLhx0
	 FDoNA8nmkbRxlk5nlKrQEiZ05etgWt8l2bpEUx9FojxUUssgeg4Ei+p6HT+SpnwaDJ6rK
	 4CR/K2V8xYJjWnGzTyF+BSd0TCMSovWgKeNhRCGjRmcfERqbBIZ4Z3/U2jQup2H56zg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793214190;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=MUEJotimO2SpwfGHvghMBhsU/NR/hwaOP+21Z/nBrl8=;
	b=kbTo1DM5wGLpIYczwgKgA9Wkn0CjP8FCv2xzeQAeMbB+ULOjs2ix9j2WzSkTWRHgfuO1
	 ljLDecaS7tDFalqxmhhXacMeaW/xF1pKDZEbdeYcvJD57BhUMcjktZGH5ysn9DUDGHjsK
	 cMCmZl+V6bWYhoslAM3H7vniCU5VklkVeVyOhRCl/YdIWSTrHPT5eVo7rvX2+6CKlNqTJ
	 fsaM3kSOH31b9xWZPcZMIiw9Nqw0xRpICPE3QxtvRyRZUa07OW8FCYeQptkcfTWmAo9ry
	 Yun1CLEHEe9n1L52v61K7N3B/IFmHdJbwbAMP+MJOA7Prh5m0OZigUzLNj9Q70rqKYQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=FkZ7xcG6;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D68960A5BC5;
	Wed, 28 Oct 2026 19:03:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=FkZ7xcG6
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5B9BB1F031F1;
	Wed, 28 Oct 2026 19:03:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793214189;
	bh=MUEJotimO2SpwfGHvghMBhsU/NR/hwaOP+21Z/nBrl8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=FkZ7xcG6MkCymyV/bcj3j+rfH3WhtswTfBoqO2jjUdaxg4u4x+s4nkvUKA3iDi44P
	 UsBPZRjGH33Tn/HordSc2GrmPkehn7kmW1CkTpBUxAPZ/Ii0Gzv02SR2Zd4dv7a48/
	 //r4Oe7mxJGpPM5oHlSFC+nVIXebJb2FXKLvthTk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kevin Hao <haokexin@gmail.com>,
	Han Xu <han.xu@nxp.com>,
	Frank Li <Frank.Li@nxp.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0772/1887] spi: fsl-qspi: use devm function instead of driver remove
Date: Wed, 28 Oct 2026 17:47:48 +0100
Message-ID: <20261028170517.008143496@linuxfoundation.org>
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
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Han Xu <han.xu@nxp.com>

[ Upstream commit 40369bfe717e96e26650eeecfa5a6363563df6e4 ]

Driver use devm APIs to manage clk/irq/resources and register the spi
controller, but the legacy remove function will be called first during
device detach and trigger kernel panic. Drop the remove function and use
devm_add_action_or_reset() for driver cleanup to ensure the release
sequence.

Trigger kernel panic on i.MX8MQ by
echo 30bb0000.spi >/sys/bus/platform/drivers/fsl-quadspi/unbind

Cc: stable@vger.kernel.org
Fixes: 8fcb830a00f0 ("spi: spi-fsl-qspi: use devm_spi_register_controller")
Reported-by: Kevin Hao <haokexin@gmail.com>
Signed-off-by: Han Xu <han.xu@nxp.com>
Reviewed-by: Frank Li <Frank.Li@nxp.com>
Link: https://patch.msgid.link/20250326224152.2147099-1-han.xu@nxp.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/spi/spi-fsl-qspi.c | 42 +++++++++++++++++---------------------
 1 file changed, 19 insertions(+), 23 deletions(-)

diff --git a/drivers/spi/spi-fsl-qspi.c b/drivers/spi/spi-fsl-qspi.c
index aee9993fe09db..665ce836c72f6 100644
--- a/drivers/spi/spi-fsl-qspi.c
+++ b/drivers/spi/spi-fsl-qspi.c
@@ -840,6 +840,19 @@ static const struct spi_controller_mem_ops fsl_qspi_mem_ops = {
 	.get_name = fsl_qspi_get_name,
 };
 
+static void fsl_qspi_cleanup(void *data)
+{
+	struct fsl_qspi *q = data;
+
+	/* disable the hardware */
+	qspi_writel(q, QUADSPI_MCR_MDIS_MASK, q->iobase + QUADSPI_MCR);
+	qspi_writel(q, 0x0, q->iobase + QUADSPI_RSER);
+
+	fsl_qspi_clk_disable_unprep(q);
+
+	mutex_destroy(&q->lock);
+}
+
 static int fsl_qspi_probe(struct platform_device *pdev)
 {
 	struct spi_controller *ctlr;
@@ -849,7 +862,7 @@ static int fsl_qspi_probe(struct platform_device *pdev)
 	struct fsl_qspi *q;
 	int ret;
 
-	ctlr = spi_alloc_master(&pdev->dev, sizeof(*q));
+	ctlr = devm_spi_alloc_master(&pdev->dev, sizeof(*q));
 	if (!ctlr)
 		return -ENOMEM;
 
@@ -930,40 +943,24 @@ static int fsl_qspi_probe(struct platform_device *pdev)
 
 	ctlr->dev.of_node = np;
 
+	ret = devm_add_action_or_reset(dev, fsl_qspi_cleanup, q);
+	if (ret)
+		goto err_put_ctrl;
+
 	ret = devm_spi_register_controller(dev, ctlr);
 	if (ret)
-		goto err_destroy_mutex;
+		goto err_put_ctrl;
 
 	return 0;
 
-err_destroy_mutex:
-	mutex_destroy(&q->lock);
-
 err_disable_clk:
 	fsl_qspi_clk_disable_unprep(q);
 
 err_put_ctrl:
-	spi_controller_put(ctlr);
-
 	dev_err(dev, "Freescale QuadSPI probe failed\n");
 	return ret;
 }
 
-static int fsl_qspi_remove(struct platform_device *pdev)
-{
-	struct fsl_qspi *q = platform_get_drvdata(pdev);
-
-	/* disable the hardware */
-	qspi_writel(q, QUADSPI_MCR_MDIS_MASK, q->iobase + QUADSPI_MCR);
-	qspi_writel(q, 0x0, q->iobase + QUADSPI_RSER);
-
-	fsl_qspi_clk_disable_unprep(q);
-
-	mutex_destroy(&q->lock);
-
-	return 0;
-}
-
 static int fsl_qspi_suspend(struct device *dev)
 {
 	return 0;
@@ -1001,7 +998,6 @@ static struct platform_driver fsl_qspi_driver = {
 		.pm =   &fsl_qspi_pm_ops,
 	},
 	.probe          = fsl_qspi_probe,
-	.remove		= fsl_qspi_remove,
 };
 module_platform_driver(fsl_qspi_driver);
 
-- 
2.53.0



