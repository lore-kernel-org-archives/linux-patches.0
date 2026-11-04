Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793827141;
	b=AHWFIM0ud6eT+hUfnB6fsX71otGxCN97f6XSDcAi+KSI6+fZ3FJ5CdRmRWO8OSxIpKms
	 DF6uc/qb1WMYsG1I6KR/mjFxDnsIy78H/Oj1GO0V0DU3qekc4k2SyJc3NQhuECgA5svWx
	 QJWvu5DgAM0gvjdB72JRAz/rO4P0tcPm285UP4scBL89h88SeOT/GHBMRWKo/ZkVRVRbv
	 WinKBgv6GwAvYGfL3KeN9Z6p6PdAOmWVzYcqfBIIF0P/xYAZjEklfrE30S4X2sJZcQv5w
	 AxzL5Z5SLuzXSTgE4TeWHsJ2wZVYzm6DEaJl0GVJeayKj2gISaT40h5TyHFrvYGKtpw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793827141;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=OfYuHikkpymzQMD893rtxUK1Mb+I0ryC4hxz+YVXPic=;
	b=I5rVO60iUWCeQlv2KzUesRpfkKwZqhdOtt7a+AIMtEHmxwoGE5cOnC8Ye1JfIYIWhW3o
	 MRUKPEoVdzcDhBT3JJ8ofM5jUviTUgxJYns7z4S3lf4+ZBmi2oOWopQduKfM/9ccx4wAs
	 VjSzfizskoASxa/oIvzHHubvESyMA7KcTOvZfVAnJBNmLz1X4lTDSSJJ1WkuC5HtKzHn0
	 2RE5i8p9crQlpeH1GOTnJyfbPM/CqUbywKHwmdpIJNHJvMkJtQtaFMOfS7/iq0Fl6x2PH
	 gChF1pJkuL6OuNsTJCMVSpBOoR+AXUIKIhGAt0GPGCAeYJAuSvvsD/hpaqnpVN/yZZQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="iRETG/3T";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CAFCD606AB0D;
	Wed,  4 Nov 2026 21:19:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=iRETG/3T
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6A8261F00A1B;
	Wed,  4 Nov 2026 21:19:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793827140;
	bh=OfYuHikkpymzQMD893rtxUK1Mb+I0ryC4hxz+YVXPic=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=iRETG/3TIhe73ozyLq0m9Gl8IToViGOgkvvUF/h37nS+3PSenUE5IAyEffv1AqomF
	 ieSK9aJKDmT64Pb7rjLHPq6PMj80JJMXn3QzcJY2lqM0OhincZvI2QihA0s5OtaOvY
	 /EooUNsiWCK4U2NfHDZ7Z3pW9JLAZKKiXTp+B6+s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yibo Tan <lhfff@tju.edu.cn>,
	Helge Deller <deller@gmx.de>
Subject: [PATCH 7.3 211/547] fbdev: atmel_lcdfb: Prevent FIFO work after removal
Date: Wed,  4 Nov 2026 16:06:35 -0500
Message-ID: <20261104211044.147011921@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261104211038.406938024@linuxfoundation.org>
References: <20261104211038.406938024@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1146,6 +1146,9 @@ static int atmel_lcdfb_probe(struct plat
 	/* Initialize PWM for contrast or backlight ("off") */
 	init_contrast(sinfo);
 
+	/* Some LCDC recovery operations require process context. */
+	INIT_WORK(&sinfo->task, atmel_lcdfb_task);
+
 	/* interrupt */
 	ret = request_irq(sinfo->irq_base, atmel_lcdfb_interrupt, 0, pdev->name, info);
 	if (ret) {
@@ -1153,10 +1156,6 @@ static int atmel_lcdfb_probe(struct plat
 		goto unmap_mmio;
 	}
 
-	/* Some operations on the LCDC might sleep and
-	 * require a preemptible task context */
-	INIT_WORK(&sinfo->task, atmel_lcdfb_task);
-
 	ret = atmel_lcdfb_init_fbinfo(sinfo);
 	if (ret < 0) {
 		dev_err(dev, "init fbinfo failed: %d\n", ret);
@@ -1192,8 +1191,8 @@ reset_drvdata:
 	dev_set_drvdata(dev, NULL);
 	fb_dealloc_cmap(&info->cmap);
 unregister_irqs:
-	cancel_work_sync(&sinfo->task);
 	free_irq(sinfo->irq_base, info);
+	cancel_work_sync(&sinfo->task);
 unmap_mmio:
 	exit_backlight(sinfo);
 	iounmap(sinfo->mmio);
@@ -1230,6 +1229,7 @@ static void atmel_lcdfb_remove(struct pl
 		return;
 	sinfo = info->par;
 
+	free_irq(sinfo->irq_base, info);
 	cancel_work_sync(&sinfo->task);
 	exit_backlight(sinfo);
 	atmel_lcdfb_power_control(sinfo, 0);
@@ -1238,7 +1238,6 @@ static void atmel_lcdfb_remove(struct pl
 	clk_put(sinfo->lcdc_clk);
 	clk_put(sinfo->bus_clk);
 	fb_dealloc_cmap(&info->cmap);
-	free_irq(sinfo->irq_base, info);
 	iounmap(sinfo->mmio);
  	release_mem_region(info->fix.mmio_start, info->fix.mmio_len);
 	if (platform_get_resource(pdev, IORESOURCE_MEM, 1)) {


