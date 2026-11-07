Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794061552;
	b=sQ2NHt1Q/ni/OXI7zGPedJS8iu8iVHuZU3idK/GrdYv8YKoW0/O5i1e+cDU6dopAYIvO
	 7pkoASBsCskPEc0RIqx+2lwMJ2/NccyFzOit5R02SJahlM+2/RGnVw/lNXkavajbmU7KQ
	 Y6VHjKLP1ICwrfPvVCC5Wp2ecNRAMZGhOUrjqnnCoiXOMTsS1sDx9laxaBPHaUHoUoKkB
	 lIzzVpq0807wl6yeDnaVb9gTAiQOseFdzVipefzGdmqiX7IeV/L5kYbcrDgjXdMNy/a9c
	 0MNXg9GxcVTbSf+gyKxkRaehWFJvn+Xe9teoPIl9Tn1pqQ73sY+I3+NewcbWaA6gElQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794061552;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=3nzv+EH+BEcL1MAIKYT/qMQ9tHOxoJXRz9oPKaCa7vM=;
	b=mOOk4H9AOlHZl/dtCYY6IiXePRw4Eu55JLiKP3WCo5+5rcgJniAAnY3JtvZRDP2mxDLr
	 e1AcfTxhu0Wf3jXR61Fv4K6YebB2HJ6rxRsIUtpAKovYFyV/BibKztQykkAG0vGbpWvrd
	 dKBeNEtDQ11mXa0jCy3Fgu3tPeT0RtLGSfAcldjQ2h1imB1I34pmkdMblU41vMN7FJss7
	 LjF73NMm3PxWqI0xQa8QJ8HMf08d+ACzdmypf4dYz1rAoUjPiMyObgDfXQn04AvKA+9kY
	 LKJ7AIHpRA1tgb+AR9/qZF7nlg8asBdAH0Y08oqw6lLLNyTcZTODiCQzLgbVBIZe+Fw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=CvZhuZmY;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD62B606A326;
	Sat,  7 Nov 2026 14:25:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=CvZhuZmY
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 64BB31F0089F;
	Sat,  7 Nov 2026 14:25:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794061551;
	bh=3nzv+EH+BEcL1MAIKYT/qMQ9tHOxoJXRz9oPKaCa7vM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=CvZhuZmY7uR6Vjqj5AlgKHxv6EFXOr81UuQedLBlZhO67xQ4AvAGz64UPgV4qHRWI
	 IF3WhbaH43IaCL79p4peoJQG3PMAJu20ygZu2ZCp0/DT5Cv16tu5GP5MYlqPkhZzoL
	 sjqtOU4W/5Rh8DZlou2vUq26K5+Szq/CF4UFl9aQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yibo Tan <lhfff@tju.edu.cn>,
	Helge Deller <deller@gmx.de>
Subject: [PATCH 6.12 0635/1536] fbdev: atmel_lcdfb: Prevent FIFO work after removal
Date: Sat,  7 Nov 2026 08:44:11 -0500
Message-ID: <20261107135015.371141817@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134957.653319350@linuxfoundation.org>
References: <20261107134957.653319350@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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


