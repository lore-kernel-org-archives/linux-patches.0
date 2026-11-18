Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795035118;
	b=gPRpATcUSarYLqkKk+eHVhio8TxGMMeVIKqLogMH+14YRzVQdBGsgjik34fXdgecOW+n
	 +xhCz8F6hUB18BGJOh7rU9z10DYRBxfuKcH93J+hbORES6jsdNfDf35J3RxzMpVNw2a3L
	 vr3D1KeRRyEfCh7ZQl9b6/yva/NkeoRxMAZNGod/PS954u6i2CY1tpqSPkYCkoN39TYUg
	 KehqVAjA7xSCdxO+xfdDu0ABKWZZxGWFpru8YvbalVGTANzGVknhlDxjHbHZvLXecFSAS
	 KWR6PRE7w9OtkhhHhik0lNyk0KqjnZhPJiPnOPnCylk6fF7vRScpulb60elRCSyfsHQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795035118;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=fCJCb7sBHE7KUVIhmwlGQ8w5dCpq9Ge1+tiIK59ob0Q=;
	b=0e6SgzBO3X9XbEDo5ouj4KUDIoWGg4CpfZrmMSe7GBLFsUraX5BCs29XQhmOEXXWpB5f
	 tsr+0bi8MXuq8u1CDauf93Q7QWzqR+2DdXT0HfmxluYPJwYljJvbjhiorHBbw5u/uJgt5
	 xxUzrYzAfJZd/roMbWGK5vp04QB8vyywRuASXH9OtIYkmySdsUcj+L3at6vmA3f77ycnH
	 B7xoMXO8fUSa8p0NjqCXWPydLUjEkxjlzeZO9t4dzQFuReGVQrm7nm8APQ8ynwQ6fFsr3
	 EBQG5YsjzYK8HG/YUrOwMMXwbw4JzbcIuibblbP4yE0Q/fdieortuieqlAqKzw8+jkA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=H58mM22X;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE0B7606A320;
	Wed, 18 Nov 2026 20:51:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=H58mM22X
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2C6BE1F000C4;
	Wed, 18 Nov 2026 20:51:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795035118;
	bh=fCJCb7sBHE7KUVIhmwlGQ8w5dCpq9Ge1+tiIK59ob0Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=H58mM22XEx64EQKHuZ5dmF9Ej9HoX6gsAsTGor3L18SSXCSI2iuRy3fecR4Adsi90
	 mwESHuzqT2muePy9xZqovQpDuPFvAvPRFQwRnGyfHoxHk56QTGw/goqK/xMSEnWt/R
	 RNmt4Ti+V3/3ABvBELG6KsnN0doTSek98Z+JrtiU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yibo Tan <lhfff@tju.edu.cn>,
	Helge Deller <deller@gmx.de>
Subject: [PATCH 6.6 0612/3318] fbdev: atmel_lcdfb: Prevent FIFO work after removal
Date: Wed, 18 Nov 2026 15:20:34 +0100
Message-ID: <20261118150336.116477468@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yibo Tan <lhfff@tju.edu.cn>

commit 20b3b97cf89cb381bf07516090d99399cc9b91fd upstream.

The LCD controller IRQ schedules sinfo->task to recover from a FIFO
underflow.  Probe currently requests the IRQ before initializing the
work, so an early interrupt can schedule an uninitialized work item.

The probe error path and remove path cancel the work before freeing the
IRQ.  A FIFO-underflow interrupt can schedule the work again after that
cancellation.  framebuffer_release() may then free sinfo while the work
is still pending.

KASAN reported a use-after-free in atmel_lcdfb_task() when an underflow
interrupt occurred during removal.  With the IRQ freed before the work
was cancelled, the same test completed without a kernel diagnostic.

Initialize the work before requesting the IRQ.  In both cleanup paths,
free the IRQ before cancelling the work so that it cannot be scheduled
again after cancellation.

Fixes: d22579b83735 ("atmel_lcdfb: FIFO underflow management")
Cc: stable@vger.kernel.org
Assisted-by: Codex:GPT-5
Signed-off-by: Yibo Tan <lhfff@tju.edu.cn>
Signed-off-by: Helge Deller <deller@gmx.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/video/fbdev/atmel_lcdfb.c |   11 +++++------
 1 file changed, 5 insertions(+), 6 deletions(-)

--- a/drivers/video/fbdev/atmel_lcdfb.c
+++ b/drivers/video/fbdev/atmel_lcdfb.c
@@ -1149,6 +1149,9 @@ static int __init atmel_lcdfb_probe(stru
 	/* Initialize PWM for contrast or backlight ("off") */
 	init_contrast(sinfo);
 
+	/* Some LCDC recovery operations require process context. */
+	INIT_WORK(&sinfo->task, atmel_lcdfb_task);
+
 	/* interrupt */
 	ret = request_irq(sinfo->irq_base, atmel_lcdfb_interrupt, 0, pdev->name, info);
 	if (ret) {
@@ -1156,10 +1159,6 @@ static int __init atmel_lcdfb_probe(stru
 		goto unmap_mmio;
 	}
 
-	/* Some operations on the LCDC might sleep and
-	 * require a preemptible task context */
-	INIT_WORK(&sinfo->task, atmel_lcdfb_task);
-
 	ret = atmel_lcdfb_init_fbinfo(sinfo);
 	if (ret < 0) {
 		dev_err(dev, "init fbinfo failed: %d\n", ret);
@@ -1195,8 +1194,8 @@ reset_drvdata:
 	dev_set_drvdata(dev, NULL);
 	fb_dealloc_cmap(&info->cmap);
 unregister_irqs:
-	cancel_work_sync(&sinfo->task);
 	free_irq(sinfo->irq_base, info);
+	cancel_work_sync(&sinfo->task);
 unmap_mmio:
 	exit_backlight(sinfo);
 	iounmap(sinfo->mmio);
@@ -1233,6 +1232,7 @@ static int __exit atmel_lcdfb_remove(str
 		return 0;
 	sinfo = info->par;
 
+	free_irq(sinfo->irq_base, info);
 	cancel_work_sync(&sinfo->task);
 	exit_backlight(sinfo);
 	atmel_lcdfb_power_control(sinfo, 0);
@@ -1241,7 +1241,6 @@ static int __exit atmel_lcdfb_remove(str
 	clk_put(sinfo->lcdc_clk);
 	clk_put(sinfo->bus_clk);
 	fb_dealloc_cmap(&info->cmap);
-	free_irq(sinfo->irq_base, info);
 	iounmap(sinfo->mmio);
  	release_mem_region(info->fix.mmio_start, info->fix.mmio_len);
 	if (platform_get_resource(pdev, IORESOURCE_MEM, 1)) {


