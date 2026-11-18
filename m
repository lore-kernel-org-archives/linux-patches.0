Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795051719;
	b=0L3mK7LVbcBwCcxAf1oAYLjtLOU5xhoqGBT/Lu/dcKT/sMUYTy3y//pLYrg0rczXjELX
	 wUEx2GZnQI7uJnkxbaytglmyOLsPwEP/l4G0gt6z8yZmw+9ENC8O4g35omk3lZizOXlLV
	 BLwR0mPLYrmGGBHY7dL3oBDU/I4naH5LGvFQFWnsyecsOvnHSjzRgXquqYrP4kV++6VNp
	 YTmvvacyUbzDRH0J9L696n1OHk2Ej6jtf2Y8vnVunSliJPGrk9NjaxNc2yCky9LOU7aiL
	 Lk4/hejo42kl6sjL+2q47l+vjq/xI11Cp/hH4KM07GWaYYH0rB4ciQ6/G0H/kt2sw4w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795051719;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Cu08CVspIZ71zlC9R4hDzZSFoV9/xl9bmXpArVIgLSM=;
	b=QM+JIJI2KasNcqZErMWCssHuhh2fv6TILueQrifhu0Y9uTZZxCyqJ5cnHy7I/L5FCEJG
	 rIcgIV95vLrWqfGB87MsRkFEHgHUAvvwIsJ8K+aB+pYZY0sClK7xljameKwTgt27l3Q2A
	 jozIJ254G/qG/uyWUVVBXi2KTY4Ylybgu8QGs+M1YGqb8PKAytYjOGGcw9FS7szynZAc3
	 gkGVIjEdJ7CTD/dXe2LLVWkiz9mpaJTyCYrVQ+DXN6wkU7Y8REodi4C3ETjTL/AsE96MO
	 5JcM+hLu2Ulq9POp+C4CDPEQSNcmFjfSOGtBdqh6VXvbIN66t/HS/weQC9oEmFk+6hA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=MhftjFQM;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 967E7606A31C;
	Thu, 19 Nov 2026 01:28:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=MhftjFQM
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E75361F000C4;
	Thu, 19 Nov 2026 01:28:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795051719;
	bh=Cu08CVspIZ71zlC9R4hDzZSFoV9/xl9bmXpArVIgLSM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=MhftjFQM1N0+ATyPonRq9fVPeq3FHc9/0Cx4XlOeBjpO7eCkt/pcodA9v54jPoHHK
	 xH4Y9Rcx/eah8YgVhv4H3X8WvW2EE+m3Q8w39N/TxheJdCjKEZjZZoScd/FW0lLcFG
	 Pq28OtH+E+4GjaIJcyhae7xy9KJdp/gzIPXBtF0M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yibo Tan <lhfff@tju.edu.cn>,
	Helge Deller <deller@gmx.de>
Subject: [PATCH 5.15 0306/2214] fbdev: atmel_lcdfb: Prevent FIFO work after removal
Date: Wed, 18 Nov 2026 15:33:02 +0100
Message-ID: <20261118150022.412726532@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1171,6 +1171,9 @@ static int __init atmel_lcdfb_probe(stru
 	/* Initialize PWM for contrast or backlight ("off") */
 	init_contrast(sinfo);
 
+	/* Some LCDC recovery operations require process context. */
+	INIT_WORK(&sinfo->task, atmel_lcdfb_task);
+
 	/* interrupt */
 	ret = request_irq(sinfo->irq_base, atmel_lcdfb_interrupt, 0, pdev->name, info);
 	if (ret) {
@@ -1178,10 +1181,6 @@ static int __init atmel_lcdfb_probe(stru
 		goto unmap_mmio;
 	}
 
-	/* Some operations on the LCDC might sleep and
-	 * require a preemptible task context */
-	INIT_WORK(&sinfo->task, atmel_lcdfb_task);
-
 	ret = atmel_lcdfb_init_fbinfo(sinfo);
 	if (ret < 0) {
 		dev_err(dev, "init fbinfo failed: %d\n", ret);
@@ -1217,8 +1216,8 @@ reset_drvdata:
 	dev_set_drvdata(dev, NULL);
 	fb_dealloc_cmap(&info->cmap);
 unregister_irqs:
-	cancel_work_sync(&sinfo->task);
 	free_irq(sinfo->irq_base, info);
+	cancel_work_sync(&sinfo->task);
 unmap_mmio:
 	exit_backlight(sinfo);
 	iounmap(sinfo->mmio);
@@ -1255,6 +1254,7 @@ static int __exit atmel_lcdfb_remove(str
 		return 0;
 	sinfo = info->par;
 
+	free_irq(sinfo->irq_base, info);
 	cancel_work_sync(&sinfo->task);
 	exit_backlight(sinfo);
 	atmel_lcdfb_power_control(sinfo, 0);
@@ -1263,7 +1263,6 @@ static int __exit atmel_lcdfb_remove(str
 	clk_put(sinfo->lcdc_clk);
 	clk_put(sinfo->bus_clk);
 	fb_dealloc_cmap(&info->cmap);
-	free_irq(sinfo->irq_base, info);
 	iounmap(sinfo->mmio);
  	release_mem_region(info->fix.mmio_start, info->fix.mmio_len);
 	if (platform_get_resource(pdev, IORESOURCE_MEM, 1)) {


