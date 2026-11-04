Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793831456;
	b=w7qRh4O+W/RwsegLZlT0lOdK+/oCwm+3FbWR9u3h5xLgnPKeeoRhxnlaXegPfLU3cjz8
	 iHEDhw2okyxKOvFGolVfMUlXP8ckzHahWyMglhpOoA0iWfPXZvEMQUudLW4PjTxxGePwK
	 8ty7ilDvvAuAknILBFqRO0XamEBkv2dUVVKlWVJdcilWE8Zo/gKH+DuFfJiEfK64uogcZ
	 21FwUk3rLGx1dkLaeMEuNGUMYhz8JdZxjaBngWNpqj0vx36HOezUMEiFTDGhDdB2sa3y5
	 DRLNtQYCVtqe7Xs8xugHaP/coQzWTFrvQBOJeA7oDIJarM4/2gCeOI+xWjCVmkbJX4Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793831456;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=GBHDS+32DYfM0QQ9K6clQZNbuwOdPNzOnMJCrEwZYoU=;
	b=hTr0y6UWgUuZgtfUbgT0RrVX4eOfZXmZPoaqFNvRrdjTAYUNkKsZA2fsvuaBoxCNE7j2
	 aUtm7x1MWAtRhyosn1TNm8nR15nhzX0jIYX83FsMwAZDdyeKeLsSZGdaaLwZ3r7XHHBf7
	 dOq2TYW+Q/FcZuuZJtI1t/F7lArnrAAcKBeXp3rdMKrfkmqaV/f7TDSG6wJXD9aXFJ9yv
	 F5Y1zcID9RGq2SjogOclIhtyctRaCeDH8Fp0DYYYB6SaPWHB8sozkPsRP4k7nPfLVlj7k
	 FwiTRxBUHSSMOrn0G3p+4dnm0RNfg9jK10q9x8A7A2aa0qiqlQQfKvOUiMjPQ9koyRQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=FnQeRAS4;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A7EA4606A328;
	Wed,  4 Nov 2026 22:30:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=FnQeRAS4
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3E4A71F000C1;
	Wed,  4 Nov 2026 22:30:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793831455;
	bh=GBHDS+32DYfM0QQ9K6clQZNbuwOdPNzOnMJCrEwZYoU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=FnQeRAS463gmBHReVu6/WJdOKxCFvgQp8Yv7hpmstzCJyw+a6EVIa55a7BzgaYSHI
	 DLMST9+ECald6HQXu+cuSUQ1i9RXLySirBa1WUI2Es8cKkzqSlQpN6iJYtGclX3I5l
	 B6/m1IYDPqBZJ6v5AimjyzwSM6R5lzLy/v7KWgjs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yibo Tan <lhfff@tju.edu.cn>,
	Helge Deller <deller@gmx.de>
Subject: [PATCH 6.18 0711/1005] fbdev: atmel_lcdfb: Prevent FIFO work after removal
Date: Wed,  4 Nov 2026 16:07:24 -0500
Message-ID: <20261104211103.475114784@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261104211043.516122098@linuxfoundation.org>
References: <20261104211043.516122098@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1148,6 +1148,9 @@ static int atmel_lcdfb_probe(struct plat
 	/* Initialize PWM for contrast or backlight ("off") */
 	init_contrast(sinfo);
 
+	/* Some LCDC recovery operations require process context. */
+	INIT_WORK(&sinfo->task, atmel_lcdfb_task);
+
 	/* interrupt */
 	ret = request_irq(sinfo->irq_base, atmel_lcdfb_interrupt, 0, pdev->name, info);
 	if (ret) {
@@ -1155,10 +1158,6 @@ static int atmel_lcdfb_probe(struct plat
 		goto unmap_mmio;
 	}
 
-	/* Some operations on the LCDC might sleep and
-	 * require a preemptible task context */
-	INIT_WORK(&sinfo->task, atmel_lcdfb_task);
-
 	ret = atmel_lcdfb_init_fbinfo(sinfo);
 	if (ret < 0) {
 		dev_err(dev, "init fbinfo failed: %d\n", ret);
@@ -1194,8 +1193,8 @@ reset_drvdata:
 	dev_set_drvdata(dev, NULL);
 	fb_dealloc_cmap(&info->cmap);
 unregister_irqs:
-	cancel_work_sync(&sinfo->task);
 	free_irq(sinfo->irq_base, info);
+	cancel_work_sync(&sinfo->task);
 unmap_mmio:
 	exit_backlight(sinfo);
 	iounmap(sinfo->mmio);
@@ -1232,6 +1231,7 @@ static void atmel_lcdfb_remove(struct pl
 		return;
 	sinfo = info->par;
 
+	free_irq(sinfo->irq_base, info);
 	cancel_work_sync(&sinfo->task);
 	exit_backlight(sinfo);
 	atmel_lcdfb_power_control(sinfo, 0);
@@ -1240,7 +1240,6 @@ static void atmel_lcdfb_remove(struct pl
 	clk_put(sinfo->lcdc_clk);
 	clk_put(sinfo->bus_clk);
 	fb_dealloc_cmap(&info->cmap);
-	free_irq(sinfo->irq_base, info);
 	iounmap(sinfo->mmio);
  	release_mem_region(info->fix.mmio_start, info->fix.mmio_len);
 	if (platform_get_resource(pdev, IORESOURCE_MEM, 1)) {


