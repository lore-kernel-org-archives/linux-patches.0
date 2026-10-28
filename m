Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793216592;
	b=RiZcft5oumOawtH+SbzpS1hC0hozJ9r5W6E7Hw/zi3ikhzyrwuKf/7AZYPuwYsNJtG9b
	 jGbTaJXYXtLO6qA+89IYp5eHAoqvopB5Nqzsi94HvZxP90bBQUO2VtuEH0jQyMfscydAv
	 kmiApIyBxNpjG2MsUFgePrF693KQ2TEjD3hvWTLTXlJwJzEgP2o4/kav6TZTtVDJ4Nv4t
	 9CVGTloFvvoZQxtt8bHMP3kGly8tub8wmKYumc61YLfJ2N8k+pv25EULPE+wBxHaF69gf
	 iUzsWoNmLH0+EijmyRrpsPWc1zepjkNNUMljlA9xh7+F6vX1PHnS51UE3+mF6vb99Hg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793216592;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=fHEXv3dWpDkeT76K074Juky06XAfzEQqhlCUXnIzE5k=;
	b=gv7sC0GLJjdVMItmqcDNTH76Q1L1rR/9msTdieDb4+ofa+ZZ9WHEqZKjXj0StF761Em4
	 GcVi0Q6Z1O2Jz9ihMTjzOD8Qchd7BbgeKKnHwN0jX59NgkM1zrjG0ere8kWqYw9HQuzsr
	 Bob1fZLmeCFokfIB2kQc8CZZOZzZSlLaTOOS6Y/XdvQDg7J5+74/N/rNjJqO9EETTsv89
	 PT0kD+ENdQV55hl3LACVVOQTX2sy7eyxoI6XTZdxeNEpN03F2NWWgH3ckME/QMkRBCnBL
	 Bhxl2QLY+jQf974B+W0jDXsn2/2OComP9lkpr66+cjliVtv+o+h4DwPVH3M31bA6eQQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=xFKZv6+k;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD396606A31E;
	Wed, 28 Oct 2026 19:43:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=xFKZv6+k
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 391531F01825;
	Wed, 28 Oct 2026 19:43:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793216591;
	bh=fHEXv3dWpDkeT76K074Juky06XAfzEQqhlCUXnIzE5k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=xFKZv6+kk0i8dSiaqy1Ke5yjZIZ/9vn1EjU0kfe994zZJyUKzqJAoYfJVrEmDL7wW
	 DsyZegXRveVEqfFTp/HLUOFB1QVA63QaUnO36rcLtD/TsRFudUJlvLQpLhEJDLbbVg
	 WxqmYqLr+7AbSnyYA0yryLM+9d0WGcAXt2Uvjq3o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Fan Wu <fanwu01@zju.edu.cn>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1611/1887] spi: oc-tiny: switch to managed controller allocation
Date: Wed, 28 Oct 2026 18:01:47 +0100
Message-ID: <20261028170536.127100272@linuxfoundation.org>
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

From: Fan Wu <fanwu01@zju.edu.cn>

[ Upstream commit d710f43ce30975d197f73c543bfe47b958d8ba17 ]

The controller is allocated with the non-managed spi_alloc_host() while
the interrupt is registered with devm_request_irq().  During removal,
spi_bitbang_stop() only unregisters the controller; the subsequent
spi_controller_put() then frees the controller together with its
embedded driver-private devdata, which is the IRQ handler's dev_id.  The
devm_request_irq() release action (free_irq()), which drains the
handler, does not run until after .remove() returns.  A late or latched
interrupt can therefore reach tiny_spi_irq() and dereference
already-freed memory (e.g. hw->base).

Switch to devm_spi_alloc_host() so that the devres LIFO order releases
the controller only after free_irq() has drained the handler, and drop
the now-redundant spi_controller_put() from .remove().  The probe error
path is simplified to direct returns.

This issue was found by an in-house static analysis tool.

Fixes: ce792580ea2c ("spi: add OpenCores tiny SPI driver")
Assisted-by: Codex:gpt-5.6
Signed-off-by: Fan Wu <fanwu01@zju.edu.cn>
Link: https://patch.msgid.link/20260719010014.3163356-1-fanwu01@zju.edu.cn
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/spi/spi-oc-tiny.c | 24 ++++++++----------------
 1 file changed, 8 insertions(+), 16 deletions(-)

diff --git a/drivers/spi/spi-oc-tiny.c b/drivers/spi/spi-oc-tiny.c
index 38c14c4e4e212..e1c984a80ed25 100644
--- a/drivers/spi/spi-oc-tiny.c
+++ b/drivers/spi/spi-oc-tiny.c
@@ -213,11 +213,11 @@ static int tiny_spi_probe(struct platform_device *pdev)
 	struct tiny_spi_platform_data *platp = dev_get_platdata(&pdev->dev);
 	struct tiny_spi *hw;
 	struct spi_master *master;
-	int err = -ENODEV;
+	int err;
 
-	master = spi_alloc_master(&pdev->dev, sizeof(struct tiny_spi));
+	master = devm_spi_alloc_master(&pdev->dev, sizeof(struct tiny_spi));
 	if (!master)
-		return err;
+		return -ENOMEM;
 
 	/* setup the master state. */
 	master->bus_num = pdev->id;
@@ -235,10 +235,8 @@ static int tiny_spi_probe(struct platform_device *pdev)
 
 	/* find and map our resources */
 	hw->base = devm_platform_ioremap_resource(pdev, 0);
-	if (IS_ERR(hw->base)) {
-		err = PTR_ERR(hw->base);
-		goto exit;
-	}
+	if (IS_ERR(hw->base))
+		return PTR_ERR(hw->base);
 	/* irq is optional */
 	hw->irq = platform_get_irq(pdev, 0);
 	if (hw->irq >= 0) {
@@ -246,7 +244,7 @@ static int tiny_spi_probe(struct platform_device *pdev)
 		err = devm_request_irq(&pdev->dev, hw->irq, tiny_spi_irq, 0,
 				       pdev->name, hw);
 		if (err)
-			goto exit;
+			return err;
 	}
 	/* find platform data */
 	if (platp) {
@@ -255,29 +253,23 @@ static int tiny_spi_probe(struct platform_device *pdev)
 	} else {
 		err = tiny_spi_of_probe(pdev);
 		if (err)
-			goto exit;
+			return err;
 	}
 
 	/* register our spi controller */
 	err = spi_bitbang_start(&hw->bitbang);
 	if (err)
-		goto exit;
+		return err;
 	dev_info(&pdev->dev, "base %p, irq %d\n", hw->base, hw->irq);
 
 	return 0;
-
-exit:
-	spi_master_put(master);
-	return err;
 }
 
 static int tiny_spi_remove(struct platform_device *pdev)
 {
 	struct tiny_spi *hw = platform_get_drvdata(pdev);
-	struct spi_master *master = hw->bitbang.master;
 
 	spi_bitbang_stop(&hw->bitbang);
-	spi_master_put(master);
 	return 0;
 }
 
-- 
2.53.0



