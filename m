Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795057702;
	b=IIEWES8UtldMqYb6SksFx9vDFBkivQGo8IjSnVM2OdJSKyc1KfmgKf0gyQOtpePhgz9Y
	 0Pkf7x6zxWseNAcofVeUqux1opb415gs3xZF1eIV+AT0a9wCg4ZNQZY3i6eTxBq7CL/p8
	 6I3Eryun8K9B0fWSQ3axMe+bl9y5R+zOx6kkD9OmE1DXjxG4l9kzuzCHYVwlSFYjxMt9c
	 AEf1lM5/57zaqmYlMcCx+0mnAaAhpvMvtgWcIJXxCSTFJcAzVam0qFAF9EwO7e2g7nG/3
	 PQ17enAvhhX49Y1qk7FBGgk4kpgTBoEJcxW6/ocjFgVQOCrFbQ4mmTxHJw+tLu18eIg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795057702;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Dhh7LFINCwrTl/G7d1UMxemCPN/r9V9YAdmyiiQ+w6U=;
	b=MHMx77+NOqy3G4qPDl43+lE3Ww/ePlDlkX/Bal3JLEFTBR2ZAeyd3rYGkM2psJRT+oMl
	 58AlOZyuCx8KjpUY9GrSLy52WkqXDKPG8gxfbK6sSS8ngl1CqICsIY6fykvnf8xVUfDG0
	 jOkqjAUpKYhL8I8y6OTFUsXkC+WUetqVPeinBgIDfzh0DRmA3oGWrbxcC5aTebiIyN4oG
	 8PdEXUyxU49ckxPnFM5jyMA8AYtCT2fgkqu0WNCGeWzvfLai5rRFG42qV4JqVf/Cjt5Ix
	 4BZJfMLuQDcSoTYgfjBDLvhOBpMfX9rx+3Nj4pFMmRxqOssvTfi26S7wQ5GvgvTkCNw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=GubXQrU7;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E21F606A320;
	Thu, 19 Nov 2026 03:08:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=GubXQrU7
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D51401F000C4;
	Thu, 19 Nov 2026 03:08:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795057702;
	bh=Dhh7LFINCwrTl/G7d1UMxemCPN/r9V9YAdmyiiQ+w6U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=GubXQrU7zREwmyZj4URwRC73FeQ2YMNpFJWrgeELxS8uH4ex0Uv28LAHu28Z5NrTR
	 pbB8H2COyhQwVWxt/uJ/pCt1qpGNJAVzl1KsbRoiLkfto0TSauGje9yWXONppesXGP
	 zjO9Ctetzq5l1asxlSuKttRSck0tcrBSw8pTQ4mk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	BingKun Yue <yuebingkun@kylinos.cn>,
	Helge Deller <deller@gmx.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 0184/1848] fbdev: platinumfb: add error checking for ioremap calls
Date: Wed, 18 Nov 2026 15:37:02 +0100
Message-ID: <20261118145919.324836089@linuxfoundation.org>
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



