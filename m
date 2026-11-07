Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794061094;
	b=Uiqgl4keZiD3g6KGJHe7rU5jPtberWogsi5IJ2iJnnqhfLOu/voStyl0E6PAwJSSqxcE
	 TfH0YIUTz+Do4GzIRdtZIqJDtEi1DhE/Eb05/5o/p6aYcz+gwxUIvOZ63t/Rr6TRxcOhh
	 KiD/6yetdEs4ljjFKDiaCKlZCFlkTkHvpbOwgtF8g/oF//wWAZKSuP/YaCLtnnViH2M+7
	 qzpPmIOJ+fjN4FEZtPvfSbQZkaDwSctCGu4bYuHZ8kftCVPXis1xRFccsbQspRs/R/h5B
	 QQNYT3g7w8wO3gYgt/wSjiFGoYgQIQCx4d/bpvW65bI7CmPNQs6ROrbCzNWeEIkSfnw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794061094;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=YWSJwvwyvNBm//Up9qH0U9NSUnu2p4/SvgIEz+d1CF0=;
	b=koUvp6gT1VRAptMD+OU53kny8KW2w3QM/QNw5RdMOi5OMcqmhq1VzLz1t6h7IzLhyfyu
	 4SvZfeMgQJ/FMloydChPvlX56p3dHOKkVaeROD21yxumIdlcMhoX552oAhmz1dPjnVLn2
	 jkPMljNdsxHYX8AV/hWAjmeBWNCA2KM3sd9ose4mmVhjPjf7AQPe9GESnzdYGxSK+RAR2
	 XZ/TXtt4CZWmC1+VFMctEbz8cWmPcqN+SzSYavaTWGrG0zNNhw/MkgJdgJp2JJ2fC12RD
	 AFgWHBbPKElx4bEMD0abSeDzpQgcUzAe/DDsEHLsPZ8wGvYcs9zXqJQDpAOnMfAsILA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=yyeXD+hm;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D8F3606D838;
	Sat,  7 Nov 2026 14:18:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=yyeXD+hm
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D74381F008A1;
	Sat,  7 Nov 2026 14:18:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794061094;
	bh=YWSJwvwyvNBm//Up9qH0U9NSUnu2p4/SvgIEz+d1CF0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=yyeXD+hmv81mVxA6eP4HZ8IbPMAX4qeLOSXQ2RErzAVssysEvfc01CpBG1pZu5BvS
	 1FWooyRsd4N3//Vr6zhbmhrE2Hy2UPhR9y7tgxbie1cYIdoy+zbVhhQtpBZ2lJJOSC
	 IE/vbdbk+5X08FdJ4CXQCc8Li7bTpZsJoC0lvj1I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	BingKun Yue <yuebingkun@kylinos.cn>,
	Helge Deller <deller@gmx.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0376/1536] fbdev: platinumfb: add error checking for ioremap calls
Date: Sat,  7 Nov 2026 08:39:52 -0500
Message-ID: <20261107135008.194595165@linuxfoundation.org>
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
index a08d955d9b439..81fdaa3541db9 100644
--- a/drivers/video/fbdev/platinumfb.c
+++ b/drivers/video/fbdev/platinumfb.c
@@ -567,15 +567,30 @@ static int platinumfb_probe(struct platform_device* odev)
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
@@ -623,13 +638,21 @@ static int platinumfb_probe(struct platform_device* odev)
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



