Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D69F82500CF;
	Wed,  5 Mar 2025 17:50:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741197019; cv=none; b=iW5iYifceUfew3oxuhkFmYWqLaZyI7QjIIdJvVpe0tHAwGTGAf3aOJQ+KFlBdPBwru64HzuOeQQz2sRpjzsT7dpePnl7Cy9VxkklnlLGih9BU/RcHqWK9K++USjW5PvmnPZfXfLmuuQShcyODQ4HlLdSpglG+Fihu/ZnQOkB8a8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741197019; c=relaxed/simple;
	bh=g8eNp81iVti1k+Zv9p6FKeDF2Xl2z1efdnZ6yicVk/k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LsGHoOcvb2QdX/rEztKkJvl28m+O+2PRIFvetIYeBPG2KiKbTSYmgKSRbXPWyrtWrfnCLDXSXAOEUX4xFuqEwxity2u+oJcnmTK/aBhs9pvnFcA88+QVVa2etztPjrUWvHSU1f8StB+1DUqW4LPY88Sw8nHotGhUJ7LHs2CBt5c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XNGaM8gd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XNGaM8gd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E3BAFC4CED1;
	Wed,  5 Mar 2025 17:50:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741197019;
	bh=g8eNp81iVti1k+Zv9p6FKeDF2Xl2z1efdnZ6yicVk/k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XNGaM8gdCoKX6PH6DoDjhuhXpNJMQuDNerXAtWCkKfRQytYLjkq/FvoWZe63Z0T45
	 Y1aMnBBhHtUoQVfZ6DD8Hrm05pUL3dpgm0+hw+pFjqg2bFd5kFMgsPFlXeosq6yRB0
	 wrBK59A18+nETcgkhKJR1qJpZdxdWNhHq1DRGVp4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yang Yingliang <yangyingliang@huawei.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 012/176] spi: atmel-quadspi: switch to use modern name
Date: Wed,  5 Mar 2025 18:46:21 +0100
Message-ID: <20250305174505.953981338@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250305174505.437358097@linuxfoundation.org>
References: <20250305174505.437358097@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yang Yingliang <yangyingliang@huawei.com>

[ Upstream commit ccbc6554ed66dc37778b8ed823bcaaabfb1731cf ]

Change legacy name master to modern name host or controller.

No functional changed.

Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
Link: https://lore.kernel.org/r/20230110131805.2827248-4-yangyingliang@huawei.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Stable-dep-of: be92ab2de0ee ("spi: atmel-qspi: Memory barriers after memory-mapped I/O")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/spi/atmel-quadspi.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/spi/atmel-quadspi.c b/drivers/spi/atmel-quadspi.c
index 58d5336b954d9..bc6dfb6d86546 100644
--- a/drivers/spi/atmel-quadspi.c
+++ b/drivers/spi/atmel-quadspi.c
@@ -406,7 +406,7 @@ static int atmel_qspi_set_cfg(struct atmel_qspi *aq,
 
 static int atmel_qspi_exec_op(struct spi_mem *mem, const struct spi_mem_op *op)
 {
-	struct atmel_qspi *aq = spi_controller_get_devdata(mem->spi->master);
+	struct atmel_qspi *aq = spi_controller_get_devdata(mem->spi->controller);
 	u32 sr, offset;
 	int err;
 
@@ -476,7 +476,7 @@ static const struct spi_controller_mem_ops atmel_qspi_mem_ops = {
 
 static int atmel_qspi_setup(struct spi_device *spi)
 {
-	struct spi_controller *ctrl = spi->master;
+	struct spi_controller *ctrl = spi->controller;
 	struct atmel_qspi *aq = spi_controller_get_devdata(ctrl);
 	unsigned long src_rate;
 	u32 scbr;
@@ -512,7 +512,7 @@ static int atmel_qspi_setup(struct spi_device *spi)
 
 static int atmel_qspi_set_cs_timing(struct spi_device *spi)
 {
-	struct spi_controller *ctrl = spi->master;
+	struct spi_controller *ctrl = spi->controller;
 	struct atmel_qspi *aq = spi_controller_get_devdata(ctrl);
 	unsigned long clk_rate;
 	u32 cs_setup;
@@ -582,7 +582,7 @@ static int atmel_qspi_probe(struct platform_device *pdev)
 	struct resource *res;
 	int irq, err = 0;
 
-	ctrl = devm_spi_alloc_master(&pdev->dev, sizeof(*aq));
+	ctrl = devm_spi_alloc_host(&pdev->dev, sizeof(*aq));
 	if (!ctrl)
 		return -ENOMEM;
 
-- 
2.39.5



