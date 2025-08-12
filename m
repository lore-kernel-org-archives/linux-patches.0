Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F054B2FF154;
	Tue, 12 Aug 2025 18:04:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755021860; cv=none; b=QnU+eSYe3hC7s3X2D61PZEq7B6A+DT2axQRug6qr3AjL+SzoR1/BDoKRP2meYStQPkq8/spboJeDNQysFvMsvFGCFHPtcOmWet5k+a/QSuyZgzEjHQ/toS7+595TZ9l8Z2oUKj27GeJ9+m1eeu2dIlx5bu50CxB+r7gPEgkWqlQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755021860; c=relaxed/simple;
	bh=aJMnPjejzZP+ezk9My8S8ojSNcnu1ydthg/nNAB6YH8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PitPjilZmduAe8b4pzBUpCkcBacTfMhzZOXFE5/4qOUoN40jAAqJn9QuUX38TQ4sQWWA0Eof8KOxoCfbkpYL71YRZ2NdbWNNbe/4hNipEgrxz7piTJyA9mgFUZSJmpG2XicvE4xS2yi+b33XX2qifnucX50EzjV9Kk3bB4TcuCc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=A7dTAVSL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="A7dTAVSL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6013FC4CEF0;
	Tue, 12 Aug 2025 18:04:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755021859;
	bh=aJMnPjejzZP+ezk9My8S8ojSNcnu1ydthg/nNAB6YH8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=A7dTAVSLaHKEhWLiyU2Jw6bpCtxK/aRdegnLJ8AVQjLCTgWuie7FpJJze8c5u7xnc
	 eKGMAfACf4Gfn0YtVKphv0nGiWK3SgU1UKa3vNttCJJ2uFbepTTZ3eV6Md7kU31HJX
	 1Zp2gNsDW2yW91w/TxHgUYvQlSiwamML4IxOXWUQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alain Volmat <alain.volmat@foss.st.com>,
	Andi Shyti <andi.shyti@kernel.org>,
	Wolfram Sang <wsa@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 246/262] i2c: stm32f7: simplify status messages in case of errors
Date: Tue, 12 Aug 2025 19:30:34 +0200
Message-ID: <20250812173003.625875512@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812172952.959106058@linuxfoundation.org>
References: <20250812172952.959106058@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alain Volmat <alain.volmat@foss.st.com>

[ Upstream commit 33a00d919253022aabafecae6bc88a6fad446589 ]

Avoid usage of __func__ when reporting an error message
since dev_err/dev_dbg are already providing enough details
to identify the source of the message.

Signed-off-by: Alain Volmat <alain.volmat@foss.st.com>
Reviewed-by: Andi Shyti <andi.shyti@kernel.org>
Signed-off-by: Wolfram Sang <wsa@kernel.org>
Stable-dep-of: 6aae87fe7f18 ("i2c: stm32f7: unmap DMA mapped buffer")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/i2c/busses/i2c-stm32f7.c |   12 +++++-------
 1 file changed, 5 insertions(+), 7 deletions(-)

--- a/drivers/i2c/busses/i2c-stm32f7.c
+++ b/drivers/i2c/busses/i2c-stm32f7.c
@@ -1601,6 +1601,7 @@ static irqreturn_t stm32f7_i2c_isr_error
 {
 	struct stm32f7_i2c_dev *i2c_dev = data;
 	struct stm32f7_i2c_msg *f7_msg = &i2c_dev->f7_msg;
+	u16 addr = f7_msg->addr;
 	void __iomem *base = i2c_dev->base;
 	struct device *dev = i2c_dev->dev;
 	struct stm32_i2c_dma *dma = i2c_dev->dma;
@@ -1610,8 +1611,7 @@ static irqreturn_t stm32f7_i2c_isr_error
 
 	/* Bus error */
 	if (status & STM32F7_I2C_ISR_BERR) {
-		dev_err(dev, "<%s>: Bus error accessing addr 0x%x\n",
-			__func__, f7_msg->addr);
+		dev_err(dev, "Bus error accessing addr 0x%x\n", addr);
 		writel_relaxed(STM32F7_I2C_ICR_BERRCF, base + STM32F7_I2C_ICR);
 		stm32f7_i2c_release_bus(&i2c_dev->adap);
 		f7_msg->result = -EIO;
@@ -1619,21 +1619,19 @@ static irqreturn_t stm32f7_i2c_isr_error
 
 	/* Arbitration loss */
 	if (status & STM32F7_I2C_ISR_ARLO) {
-		dev_dbg(dev, "<%s>: Arbitration loss accessing addr 0x%x\n",
-			__func__, f7_msg->addr);
+		dev_dbg(dev, "Arbitration loss accessing addr 0x%x\n", addr);
 		writel_relaxed(STM32F7_I2C_ICR_ARLOCF, base + STM32F7_I2C_ICR);
 		f7_msg->result = -EAGAIN;
 	}
 
 	if (status & STM32F7_I2C_ISR_PECERR) {
-		dev_err(dev, "<%s>: PEC error in reception accessing addr 0x%x\n",
-			__func__, f7_msg->addr);
+		dev_err(dev, "PEC error in reception accessing addr 0x%x\n", addr);
 		writel_relaxed(STM32F7_I2C_ICR_PECCF, base + STM32F7_I2C_ICR);
 		f7_msg->result = -EINVAL;
 	}
 
 	if (status & STM32F7_I2C_ISR_ALERT) {
-		dev_dbg(dev, "<%s>: SMBus alert received\n", __func__);
+		dev_dbg(dev, "SMBus alert received\n");
 		writel_relaxed(STM32F7_I2C_ICR_ALERTCF, base + STM32F7_I2C_ICR);
 		i2c_handle_smbus_alert(i2c_dev->alert->ara);
 		return IRQ_HANDLED;


