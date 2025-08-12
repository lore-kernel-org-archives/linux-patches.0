Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A7282FE582;
	Tue, 12 Aug 2025 18:30:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755023403; cv=none; b=kbASAk20D3rdyHhDPrBisdzGy3+ksFAMXT+FOxQpUO0lyX66Ckiinb6FEcHeFrzI/OOeg8e9gPMCaALaVzsHW3g0ohb0GFKAbHc/+CQRrswgIWBeQrDJgctesN6DQ2PqLMZZEzS7rqWQ+iDK+b9gQMxJ4MPh+49JtBQZgYowAf0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755023403; c=relaxed/simple;
	bh=ikQdNsSLyJaATHVspyj5f+aEX/4uTlsjnrw53uo0jfk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SDPyK+t+8ZVB+1uggZ9ZuSoK6nsFtQob03k7A8X6Tfs7XgG/FkCbGPgNdmPD2A08BJCIs9yBIe/F5sGsvRPcMsAYXoGUKHhuitbO4ffv/ttC0kng0it71/Q2fVkOEegnokZ1o0jUw34n3IwPOeOV46xpS+3Wfm9YnYWMz0Jw2as=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bW7VwlO0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bW7VwlO0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8D028C4CEF0;
	Tue, 12 Aug 2025 18:30:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755023403;
	bh=ikQdNsSLyJaATHVspyj5f+aEX/4uTlsjnrw53uo0jfk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bW7VwlO0Ilt+edcwuqT9c6J1KK9DNDG+mVWxLBV/EQiYRQPrKFUtt9trVcpLnKZB8
	 j8KBtSNhd9oFVOjZL3nC64TwFbg544+xBXgrh1zcO4SrQBR4BYN84NDn2ARcRGcPDt
	 62bo3JXOSa1JpYDlOGwrW7Wc4FTUQhgD/oJrBepE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hans de Goede <hansg@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 070/627] mei: vsc: Drop unused vsc_tp_request_irq() and vsc_tp_free_irq()
Date: Tue, 12 Aug 2025 19:26:05 +0200
Message-ID: <20250812173421.978365169@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812173419.303046420@linuxfoundation.org>
References: <20250812173419.303046420@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hans de Goede <hansg@kernel.org>

[ Upstream commit a49159aa80207d49569b7453b4838f2f9501a17c ]

Drop the unused vsc_tp_request_irq() and vsc_tp_free_irq() functions.

Signed-off-by: Hans de Goede <hansg@kernel.org>
Link: https://lore.kernel.org/r/20250623085052.12347-2-hansg@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Stable-dep-of: de88b02c94db ("mei: vsc: Run event callback from a workqueue")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/misc/mei/vsc-tp.c | 31 -------------------------------
 drivers/misc/mei/vsc-tp.h |  3 ---
 2 files changed, 34 deletions(-)

diff --git a/drivers/misc/mei/vsc-tp.c b/drivers/misc/mei/vsc-tp.c
index 97df3077175d..d0450c80316c 100644
--- a/drivers/misc/mei/vsc-tp.c
+++ b/drivers/misc/mei/vsc-tp.c
@@ -409,37 +409,6 @@ int vsc_tp_register_event_cb(struct vsc_tp *tp, vsc_tp_event_cb_t event_cb,
 }
 EXPORT_SYMBOL_NS_GPL(vsc_tp_register_event_cb, "VSC_TP");
 
-/**
- * vsc_tp_request_irq - request irq for vsc_tp device
- * @tp: vsc_tp device handle
- */
-int vsc_tp_request_irq(struct vsc_tp *tp)
-{
-	struct spi_device *spi = tp->spi;
-	struct device *dev = &spi->dev;
-	int ret;
-
-	irq_set_status_flags(spi->irq, IRQ_DISABLE_UNLAZY);
-	ret = request_threaded_irq(spi->irq, vsc_tp_isr, vsc_tp_thread_isr,
-				   IRQF_TRIGGER_FALLING | IRQF_ONESHOT,
-				   dev_name(dev), tp);
-	if (ret)
-		return ret;
-
-	return 0;
-}
-EXPORT_SYMBOL_NS_GPL(vsc_tp_request_irq, "VSC_TP");
-
-/**
- * vsc_tp_free_irq - free irq for vsc_tp device
- * @tp: vsc_tp device handle
- */
-void vsc_tp_free_irq(struct vsc_tp *tp)
-{
-	free_irq(tp->spi->irq, tp);
-}
-EXPORT_SYMBOL_NS_GPL(vsc_tp_free_irq, "VSC_TP");
-
 /**
  * vsc_tp_intr_synchronize - synchronize vsc_tp interrupt
  * @tp: vsc_tp device handle
diff --git a/drivers/misc/mei/vsc-tp.h b/drivers/misc/mei/vsc-tp.h
index 14ca195cbddc..f9513ddc3e40 100644
--- a/drivers/misc/mei/vsc-tp.h
+++ b/drivers/misc/mei/vsc-tp.h
@@ -37,9 +37,6 @@ int vsc_tp_xfer(struct vsc_tp *tp, u8 cmd, const void *obuf, size_t olen,
 int vsc_tp_register_event_cb(struct vsc_tp *tp, vsc_tp_event_cb_t event_cb,
 			     void *context);
 
-int vsc_tp_request_irq(struct vsc_tp *tp);
-void vsc_tp_free_irq(struct vsc_tp *tp);
-
 void vsc_tp_intr_enable(struct vsc_tp *tp);
 void vsc_tp_intr_disable(struct vsc_tp *tp);
 void vsc_tp_intr_synchronize(struct vsc_tp *tp);
-- 
2.39.5



