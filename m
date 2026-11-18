Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795057780;
	b=g0zn+2BDoK9x3u1CN+1lVPZtt5dw9cIFOPL2M3NLCveIV0wAB9KOJuGxbEWbpsFzKCM3
	 Fmhj8eOuIRvMRmafjtPNrLVGXxHnpspOUyAf0f1jypPHtuDBM43lZacR+EtxeAo+zNGfN
	 pz3GcNJzg7hbb0kxT3EYmEyggATBq0aKZf5ppv5koT74Zydrrx1AnviqRQJrxlBaGY5at
	 OXoz58Mk+Vz402CrQ1kEZ3iMoo1EV2odZfiAy9lRW6TmoMtC57McaFAjY9gczypNTNLFt
	 kWA5oo9J00iGH7d/Ahxi8uwjaAjg3fKqL07DPzHqIEHdyKkPd9fNQCYbGH6P+wtzNUA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795057780;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=n4PJqBLawDDU8e/j/P05a/1MXorWPKi8bBcxvZ5F3sg=;
	b=gzbnh9Uliey/2QNBP1952+5EPcKth+zk9M/bCHcYcmvIBIbBsIenXwjpfhlbxX6h+574
	 DUMKFXV94SdAzrFy1y/UcaQb91rC8rxfa8z1eb3WDeS7gpkO3z15w0tAo2LjGKy2Fhb/z
	 zXsF7TqZAblv46//qJrfAkSQxrs5/LpN7fqRcmSh1xLBcSf03AOSiuaZ+iLiui+u0Ku87
	 Wy7072s+2BJrs6Xxa+f/MrmWWe4KyIEj9VdmpIZJ4rqemC6zHxyACxG31jtpfvp0IAMbE
	 sqIhUxJ6J7g8BJixiZY9w0QAmm+6j9Jduk9hZ5o+8L6hhiFD5E+DbIuKaf38QBWf4hg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=iSRp67PH;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 45A63606A32A;
	Thu, 19 Nov 2026 03:09:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=iSRp67PH
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9A49F1F000C4;
	Thu, 19 Nov 2026 03:09:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795057780;
	bh=n4PJqBLawDDU8e/j/P05a/1MXorWPKi8bBcxvZ5F3sg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=iSRp67PHpEyO5e0Osf9xnkKcqgI0HbtMaBE2//TYBNMtKU/s4K5lBD/6mwvUf6QRe
	 k8a+xAItwyK4jxK/lIksz88N+O7j809qyNqGlugDE/GnVh52BDnIzUztGgNZUB3JXc
	 aXDtF8+mIe3hB55FrVC4i2rJwdbKfun6ivqH8yGw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yibo Tan <lhfff@tju.edu.cn>,
	Helge Deller <deller@gmx.de>
Subject: [PATCH 5.10 0250/1848] fbdev: atmel_lcdfb: Prevent FIFO work after removal
Date: Wed, 18 Nov 2026 15:38:08 +0100
Message-ID: <20261118145922.473490238@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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


