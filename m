Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795034278;
	b=vgY9tHLpdTDJxtXra2v1a/Wy6LX58gX5UARRpVYDaB0EYYO735mcow6IOhfpsd5G1JI2
	 QE5tXrnBLi2/JhebFq72efuuMn4lsqgeDAC8g0+pFt29VErenbPTMW/fpjhIith+dWMYD
	 OhbEF8R/Uj2UZ0vzMjXdOQljD73G9y6dX8+kTwEwLd2BkIz2m7q0uKALg19f2rBu78sad
	 1naO08/B3K/igzOdFjU5j7C1CF3av4oqvfvRzy2UTtB6WCqGBnulqoUt+LAWokaWmAQk+
	 UlsrMuyEf6Smpmh565pkJ6dCkQrarRHj5awnFWtcrwpk6xTrDpLhC1eTMJ8MmopZR+g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795034278;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=m4CumHgXN4nmCpStu7Y2Ez0Eh+O2IzIej4UnkZ7eZoM=;
	b=Z/RplQZt0FeTsJvSy3Munbd7RsClTh1FBhrDVQ4C5TE+vxngRdPosz6q2upcibXY73ky
	 kybE9FHbi1JsBYH+qYFTH8YxeOgmGg2q4MwXdrMaLSDyoq5jCqk6nw3fFiRNNTez44O7u
	 rxcMV4xIiIEwW1+cEoQud71/oOqJMy3r1EZN3T1ulVakTcAGsL8Kxno05ls3I1uOWXyFp
	 zjc98D+QkRrF38oqotKYYOWRNn4PETs2zMg/00hnzESMCfUBxcZxLlqMK2fYrKKhMhTEc
	 50KybaDDuGMoYqbXJvxsUSRqqg044e6iPCH4IhYMl01NpGDzvUzqOQMPTOOpjMWfb1w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=n1blAxAR;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6FC6A606A31C;
	Wed, 18 Nov 2026 20:37:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=n1blAxAR
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C29521F000C7;
	Wed, 18 Nov 2026 20:37:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795034278;
	bh=m4CumHgXN4nmCpStu7Y2Ez0Eh+O2IzIej4UnkZ7eZoM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=n1blAxARzxPAuhJLJdOaVS1hB5mROTMsVyC65aadFLbenLElqSAY2z/zfZbx42j7p
	 pyZO8hDieRXy1XSu9vr040BOkPQa6/eEwZT53vO1oFsQRVjxcb+fPM4C7eHzNUW9On
	 NhD8an4GCmfUKkJrsrdjFoMgVv+VAcWAphgHLKlI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	BingKun Yue <yuebingkun@kylinos.cn>,
	Helge Deller <deller@gmx.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0313/3318] fbdev: platinumfb: add error checking for ioremap calls
Date: Wed, 18 Nov 2026 15:15:35 +0100
Message-ID: <20261118150325.199127606@linuxfoundation.org>
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
index cb6fcc64c8e20..41b69fa7c189f 100644
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



