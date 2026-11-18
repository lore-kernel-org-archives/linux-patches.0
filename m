Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795051491;
	b=CzKh4pK12QnRuX7b42z+n6tOSCJmgaTqiSG607acLoNCwwrZznMjQ2Jved3kSdG/2C2b
	 hChlxQBtsdKrC/dN4ic7RgiZ+88/UPx8FM28+pT3A/1NmOSafNb29XXM3BWmde45emD0K
	 Vub/2gmW/9a3De8GNNTHzk1djdpUmi+9ckEkLLhQfO62QMmXQq1e8Wj/nxYWTNWWLLfCC
	 +oT3MKtmZEkmnez3rMLMvLO46+UHvN4q6Hz2ug6ouVBqEopmLzRlJepSGKmhSBlaMMjcr
	 GQbHFWAYf4vUZXTcmWaJJ1yt7MmmujcKdgpkuI4uV0dzrSMkF9wuUJzxUS1F+sBVscw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795051491;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=NKF9EVafpyfm9K71KFHY0d+YBiK0TvLRZPxgg3UtW0A=;
	b=xMGsf4RD8c01QACaODEXrAaW/XUYhCbT+P56LdvDb6xgzd+gfkt3kr0GIBlW6tR70KOr
	 macg9Gfv9ds+1oEKvJ33iJiAJXoKNoOcUEKTH2QJx+rAhBMZp6LpEeLJ0gUpv7TmLVG1V
	 1Talq5eRzvdSsptG1hnJXZ7SlqYYxHirDuAMk9kcs6Rj7IiuHG+euIZXSOMV1fTIZeWU/
	 6SiAwI5d7GQkH1FtEJ38mAs1CdF1Gci06lMPo3kivtPRP/yOwXGFmzMij7i6G5XWke+qH
	 FVmYFCo/sELFk1Odg0CNETH0q+nEjw/60k7YR5dyjdtT2PswNYbzLYMKk717K1Ue1Vg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=HvTo3zZx;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C1A7E606A320;
	Thu, 19 Nov 2026 01:24:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=HvTo3zZx
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1AB4A1F000C4;
	Thu, 19 Nov 2026 01:24:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795051491;
	bh=NKF9EVafpyfm9K71KFHY0d+YBiK0TvLRZPxgg3UtW0A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=HvTo3zZxWqNHMLNMiPCw0GMUGyUe5jzC8KJRAWthi0ZUBaOCMzZWJCocdUtSRe7qc
	 oUFALtekN3MmUEsQGnRtO2lwbFTIFvtDcaFpU3/FFLJXnw078MkyuPXNYA8WIwfa7A
	 nnzUiAzNKPnsp/Spjvu2Kd4DssKeAseMFnNxeuF8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	BingKun Yue <yuebingkun@kylinos.cn>,
	Helge Deller <deller@gmx.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 0227/2214] fbdev: platinumfb: add error checking for ioremap calls
Date: Wed, 18 Nov 2026 15:31:43 +0100
Message-ID: <20261118150019.321046264@linuxfoundation.org>
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

From: BingKun Yue <yuebingkun@kylinos.cn>

[ Upstream commit ba13226fc966004713aed47931db8922b84d1960 ]

The ioremap() and ioremap_wt() calls in platinumfb_probe() were not
checked for failure. If any of these mappings fail, the driver would
dereference NULL pointers, leading to a kernel panic.

Add proper error checking and use goto-based cleanup to avoid code
duplication across the error paths.

Signed-off-by: BingKun Yue <yuebingkun@kylinos.cn>
Signed-off-by: Helge Deller <deller@gmx.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/video/fbdev/platinumfb.c | 35 ++++++++++++++++++++++++++------
 1 file changed, 29 insertions(+), 6 deletions(-)

diff --git a/drivers/video/fbdev/platinumfb.c b/drivers/video/fbdev/platinumfb.c
index ce413a9df06e4..d2fd6725d5c2b 100644
--- a/drivers/video/fbdev/platinumfb.c
+++ b/drivers/video/fbdev/platinumfb.c
@@ -570,15 +570,30 @@ static int platinumfb_probe(struct platform_device* odev)
 	/* frame buffer - map only 4MB */
 	pinfo->frame_buffer_phys = pinfo->rsrc_fb.start;
 	pinfo->frame_buffer = ioremap_wt(pinfo->rsrc_fb.start, 0x400000);
+	if (!pinfo->frame_buffer) {
+		dev_err(&odev->dev, "failed to ioremap frame buffer\n");
+		rc = -ENOMEM;
+		goto err_release_fb;
+	}
 	pinfo->base_frame_buffer = pinfo->frame_buffer;
 
 	/* registers */
 	pinfo->platinum_regs_phys = pinfo->rsrc_reg.start;
 	pinfo->platinum_regs = ioremap(pinfo->rsrc_reg.start, 0x1000);
+	if (!pinfo->platinum_regs) {
+		dev_err(&odev->dev, "failed to ioremap registers\n");
+		rc = -ENOMEM;
+		goto err_unmap_fb;
+	}
 
 	pinfo->cmap_regs_phys = 0xf301b000;	/* XXX not in prom? */
 	request_mem_region(pinfo->cmap_regs_phys, 0x1000, "platinumfb cmap");
 	pinfo->cmap_regs = ioremap(pinfo->cmap_regs_phys, 0x1000);
+	if (!pinfo->cmap_regs) {
+		dev_err(&odev->dev, "failed to ioremap cmap registers\n");
+		rc = -ENOMEM;
+		goto err_release_cmap;
+	}
 
 	/* Grok total video ram */
 	out_be32(&pinfo->platinum_regs->reg[16].r, (unsigned)pinfo->frame_buffer_phys);
@@ -626,13 +641,21 @@ static int platinumfb_probe(struct platform_device* odev)
 	dev_set_drvdata(&odev->dev, info);
 	
 	rc = platinum_init_fb(info);
-	if (rc != 0) {
-		iounmap(pinfo->frame_buffer);
-		iounmap(pinfo->platinum_regs);
-		iounmap(pinfo->cmap_regs);
-		framebuffer_release(info);
-	}
+	if (rc != 0)
+		goto err_unmap_cmap;
+
+	return 0;
 
+err_unmap_cmap:
+	iounmap(pinfo->cmap_regs);
+err_release_cmap:
+	release_mem_region(pinfo->cmap_regs_phys, 0x1000);
+	iounmap(pinfo->platinum_regs);
+err_unmap_fb:
+	iounmap(pinfo->frame_buffer);
+err_release_fb:
+	release_mem_region(pinfo->rsrc_fb.start, resource_size(&pinfo->rsrc_fb));
+	framebuffer_release(info);
 	return rc;
 }
 
-- 
2.53.0



