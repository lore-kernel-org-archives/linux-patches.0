Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793830998;
	b=h7wE1cZI8MbRL5faF65T3qxICwSQ5SJ6nDrFAXg+4Ueg4yLLgopmd6A1CW0vHeDoQwGw
	 wo/tmeivFaIHbAWW5bIoIE1QqWQuu6GPq3kamgFYfpiGeVs+RE82xNB7CY+8vuw+BfdmR
	 rtkJalWKSQcwK1aORLsTKfYoolHfJnDONTXy8uFR42ykJnvswc2YobZOJ1uPA/9dmCl3d
	 RgIayRl5kQ6Dk6gQWDFCzuwcv6eQToYG1GyoBfzuzocA5hT4VdiIgpmXbez2gGTQMt+Cr
	 l07qpKeLw1lV9sZxgKrBfqqoPb6y2s/DN+GBuGWWRqEQr1GCRjSZciYhZqX7ThSa1pw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793830998;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=bPiflMLw0s3Kf7Sskr3CXLgm/iU3iu6i+kVin3Lh1F8=;
	b=fWz0gnV8l4hLcRRInWwuKV/Zt8dSjKhLkEPsb2q0H0a4x5koxU878vSvPVCy8bHaoaCo
	 ZyJPu7OKRa+dYpy80Y8DrHSUzDxRxV+NQdW918cxXUbUGnB+4BPYP3b+ARUdEaRY10dZR
	 ZVH9zhzCl8mTqJF1CPrrSfSEXOYbd4DPqLtiZgaORuOB79bHg6czW8/6PAbhEiUchUXuF
	 jRWu3+OZUJDaDMsMFKCdlVXase76PnbbLcGacP/8Wbz707538teJBfdJ1TcVCiviEE+ki
	 YivL62EqYxuC/02YMz5c8bhkyh3vawQ+Rp3uXozi9SA/b/bjP576s/WBBOW5sC7mSzQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=YsCfN5Gc;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD5B7606AB06;
	Wed,  4 Nov 2026 22:23:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=YsCfN5Gc
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 69E7E1F000C1;
	Wed,  4 Nov 2026 22:23:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793830997;
	bh=bPiflMLw0s3Kf7Sskr3CXLgm/iU3iu6i+kVin3Lh1F8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=YsCfN5Gc8bfyhZTsf3C7q07bRjmgn6aqxbZl4MNOrEIBAhDC36GzZREkT2BSdFo8t
	 174FUsXsNFPJ6gOW9IgtxLfYMIl3hTRaHZ8Ez9P1G0bfzCWoFFCSPoQb5RO5rHGIQ0
	 YNYVEtD1kNFvuU01XYGa1sMhGPHyrX/+oNGfYDNM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	BingKun Yue <yuebingkun@kylinos.cn>,
	Helge Deller <deller@gmx.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0447/1005] fbdev: platinumfb: add error checking for ioremap calls
Date: Wed,  4 Nov 2026 16:03:00 -0500
Message-ID: <20261104211056.579896369@linuxfoundation.org>
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



