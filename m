Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3CC99340280;
	Fri,  7 Aug 2026 15:03:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786115029; cv=none; b=ET0v+d+VSIY4dyyTolkakMgc9qNhL3IPErhruhrIz1BzfJSYVkBH8sw0K11qsgOcF7oNJfagUfbKoLKmhfrJKYkN3PzoJ17Bw+uio5AGBnWtjvCXHB891tcw3MfIT2vHSEPo9kTLstbPl+3s3RUMp99qdysG3ESXWeuYHWl1hu8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786115029; c=relaxed/simple;
	bh=EAe/yvLlNkpIHwnRE4GNQxZJlT+SHOn0EKjhpthE8BY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=elvZKvaCFiriZEOntFRnj5QzbTibx9jNqk6r/OH4i5M3GVgfVw4+DPpW1blCCbmXAqded7yzjBlZYqq3KBqjSAjUX/1vFeKL2nfelHwS+RCfn6pNuvDXCPXpusgyxn7p6XF5sDlA9PHMyaoEnsfIH+YyKZkwlg7q8F2AKeS9o+E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=17lWWM5C; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="17lWWM5C"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8C7261F00A3A;
	Fri,  7 Aug 2026 15:03:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786115028;
	bh=15BXIVRjUM/7/tFzfsGjLVHFx3O1Z0gK5AyzPsDCHqs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=17lWWM5ChY9tI5pqCJH3FIyoMaiZ/RWhHZ9lilB9W1bemRxhM1cj/JP7mgsIxk5OI
	 qzQS0I358REmfAs2JpkY8Mjvs95x+gmWHUf7kY6y/V69BP7KrPglS0t1Iews5fHyNQ
	 zTwfek05maDALj343mWrxqOTSjWJL0iEh7HD/7l0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Neil Armstrong <neil.armstrong@linaro.org>,
	=?UTF-8?q?=E5=AD=99=E9=AD=81=20 ?= <kui.sun@unisoc.com>,
	=?UTF-8?q?Andr=C3=A9=20Draszik?= <andre.draszik@linaro.org>,
	Gregory CLEMENT <gregory.clement@bootlin.com>,
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
	Bart Van Assche <bvanassche@acm.org>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 131/396] scsi: ufs: core: Revert "Delegate the interrupt service routine to a threaded IRQ handler"
Date: Fri,  7 Aug 2026 16:34:51 +0200
Message-ID: <20260807143427.131122188@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260807143424.272339768@linuxfoundation.org>
References: <20260807143424.272339768@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Bart Van Assche <bvanassche@acm.org>

[ Upstream commit 8a309036f557d3ff4efb2beea5132ba91172d934 ]

There have been multiple reports of performance regressions caused by
commit 3c7ac40d7322 ("scsi: ufs: core: Delegate the interrupt service
routine to a threaded IRQ handler"). Hence this revert.

This patch reverts most of the following commits:

 * 3c7ac40d7322 ("scsi: ufs: core: Delegate the interrupt service
   routine to a threaded IRQ handler")

 * 6475cfb81fc4 ("scsi: ufs: core: Avoid IRQ thread wakeup during active
   UIC command")

This patch preserves the following commits:

 * 034d319c8899 ("scsi: ufs: core: Fix interrupt handling for MCQ Mode")

 * eabcac808ca3 ("scsi: ufs: core: Fix IRQ lock inversion for the SCSI
   host lock")

Cc: Neil Armstrong <neil.armstrong@linaro.org>
Cc: 孙魁 (Kui Sun) <kui.sun@unisoc.com>
Cc: André Draszik <andre.draszik@linaro.org>
Cc: Gregory CLEMENT <gregory.clement@bootlin.com>
Cc: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Fixes: 3c7ac40d7322 ("scsi: ufs: core: Delegate the interrupt service routine to a threaded IRQ handler")
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
Reviewed-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Tested-by: André Draszik <andre.draszik@linaro.org> # on Pixel 6
Reviewed-by: André Draszik <andre.draszik@linaro.org>
Link: https://patch.msgid.link/b70eb60a01f971bed68c42c5b555929db5f835df.1784135511.git.bvanassche@acm.org
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/ufs/core/ufshcd.c | 39 +++------------------------------------
 1 file changed, 3 insertions(+), 36 deletions(-)

diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index 482a9299a5894..504600f1e08cd 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -7128,7 +7128,7 @@ static irqreturn_t ufshcd_sl_intr(struct ufs_hba *hba, u32 intr_status)
 }
 
 /**
- * ufshcd_threaded_intr - Threaded interrupt service routine
+ * ufshcd_intr - Main interrupt service routine
  * @irq: irq number
  * @__hba: pointer to adapter instance
  *
@@ -7136,7 +7136,7 @@ static irqreturn_t ufshcd_sl_intr(struct ufs_hba *hba, u32 intr_status)
  *  IRQ_HANDLED - If interrupt is valid
  *  IRQ_NONE    - If invalid interrupt
  */
-static irqreturn_t ufshcd_threaded_intr(int irq, void *__hba)
+static irqreturn_t ufshcd_intr(int irq, void *__hba)
 {
 	u32 last_intr_status, intr_status, enabled_intr_status = 0;
 	irqreturn_t retval = IRQ_NONE;
@@ -7175,38 +7175,6 @@ static irqreturn_t ufshcd_threaded_intr(int irq, void *__hba)
 	return retval;
 }
 
-/**
- * ufshcd_intr - Main interrupt service routine
- * @irq: irq number
- * @__hba: pointer to adapter instance
- *
- * Return:
- *  IRQ_HANDLED     - If interrupt is valid
- *  IRQ_WAKE_THREAD - If handling is moved to threaded handled
- *  IRQ_NONE        - If invalid interrupt
- */
-static irqreturn_t ufshcd_intr(int irq, void *__hba)
-{
-	struct ufs_hba *hba = __hba;
-	u32 intr_status, enabled_intr_status;
-
-	/*
-	 * Handle interrupt in thread if MCQ or ESI is disabled,
-	 * and no active UIC command.
-	 */
-	if ((!hba->mcq_enabled || !hba->mcq_esi_enabled) &&
-	    !hba->active_uic_cmd)
-		return IRQ_WAKE_THREAD;
-
-	intr_status = ufshcd_readl(hba, REG_INTERRUPT_STATUS);
-	enabled_intr_status = intr_status & ufshcd_readl(hba, REG_INTERRUPT_ENABLE);
-
-	ufshcd_writel(hba, intr_status, REG_INTERRUPT_STATUS);
-
-	/* Directly handle interrupts since MCQ ESI handlers does the hard job */
-	return ufshcd_sl_intr(hba, enabled_intr_status);
-}
-
 static int ufshcd_clear_tm_cmd(struct ufs_hba *hba, int tag)
 {
 	int err = 0;
@@ -10835,8 +10803,7 @@ int ufshcd_init(struct ufs_hba *hba, void __iomem *mmio_base, unsigned int irq)
 	ufshcd_readl(hba, REG_INTERRUPT_ENABLE);
 
 	/* IRQ registration */
-	err = devm_request_threaded_irq(dev, irq, ufshcd_intr, ufshcd_threaded_intr,
-					IRQF_ONESHOT | IRQF_SHARED, UFSHCD, hba);
+	err = devm_request_irq(dev, irq, ufshcd_intr, IRQF_SHARED, UFSHCD, hba);
 	if (err) {
 		dev_err(hba->dev, "request irq failed\n");
 		goto out_disable;
-- 
2.53.0



