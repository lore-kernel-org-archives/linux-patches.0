Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795038951;
	b=uEMjALOiMdli81WTduy1ZLt6vWBSpn6l9URFHPalxMx2VzLFXwxJyfUzCc1O/5j1wYv1
	 EqKMYRfh4gU7YEdzwISxG4ylzZRv0Eb+iGdxrHd4lGWapxO3i5hu4MpRLtVdzYWkg1afc
	 Qfr8JgMPdjyceIEkrU3Oxw7Yc6XuAzfmvAmCbcWYWHQQANt3bIK4+JrY49zjkUqgUcA4C
	 lQAhces/nZviin+29T8eEcBlKom/Q+O6Q696ChEdUtHxLX+WQRgLbORIQBmemJfSp4Iwi
	 vnxP7Wsx48V3plXTMWEtZHKuP1s2Ncd3spX/CksEe8djc9NrrI6uf3tJli5g8EwW+KA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795038951;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=wQU4cunt5KktluRDpr81fcR/90Meil5ooszi1Ih9cno=;
	b=a2iETiEQ7+2W52LgKz/8j/PHSnjURRBEZpAehn+G9zSI1PwaW/mEN6kketwriUebT6LY
	 kj8Zc27ukRjuZMrZeRG+DxLzTbXsaSRX/Gw0pUlQ7P8nZU1u4GAKn2f5tZmLI8uDUNrxb
	 cHT3Jol4Z/aw/0OeqwbxPfrSGvd4UvJ/K8exyWKuoOOHGKfepGcRGnGBTFE06MvGL7U6J
	 hrOVBWGIAGrW22VUXnotKqMeb3TtEPO9oqaOyixvhFzHAfgnW9n0/1M2WwVEgRwCSk90n
	 C6HvDqKNr+RwkKkglw01yPuH4excTWSKtXWy+rOBPxOaHQQz/3hZcSkoi/HWgEZQNEA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Qr5NdJUk;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E082606A31C;
	Wed, 18 Nov 2026 21:55:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Qr5NdJUk
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8E8671F000C4;
	Wed, 18 Nov 2026 21:55:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795038951;
	bh=wQU4cunt5KktluRDpr81fcR/90Meil5ooszi1Ih9cno=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Qr5NdJUkBnAFKt9HqKn2YorYZ2NDU69w/1jHHDa62WofJCj06u/PN4bLoRrUId8/K
	 LBEfy44rUe2dHtBnuyxvt0fEUtpjTWYdkwHTI6eA+k72KdobkcxchHfFfrWpS/WxaZ
	 EtxzSX/GhtNpOqk67G0vHGzEt19nyxcUhVaLWSpY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Giovanni Di Santi <giovanni.disanti.lkl@gmail.com>,
	Helge Deller <deller@gmx.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1927/3318] fbdev: kyro: Use devm_ioremap_wc() for screen mem
Date: Wed, 18 Nov 2026 15:42:29 +0100
Message-ID: <20261118150419.831818216@linuxfoundation.org>
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

From: Giovanni Di Santi <giovanni.disanti.lkl@gmail.com>

[ Upstream commit 32dfb6112ea3ca143636832cd34234f2be4830bb ]

Replace the manual pci_ioremap_wc() call for mapping screen memory with the
device-managed devm_ioremap_wc() variant.

This simplifies the driver's resource management by ensuring the memory is
automatically unmapped when the driver detaches from the device.

Signed-off-by: Giovanni Di Santi <giovanni.disanti.lkl@gmail.com>
Signed-off-by: Helge Deller <deller@gmx.de>
Stable-dep-of: d3bc005a6294 ("fbdev: kyro: Release WC setup on registration failure")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/video/fbdev/kyro/fbdev.c | 9 +++------
 1 file changed, 3 insertions(+), 6 deletions(-)

diff --git a/drivers/video/fbdev/kyro/fbdev.c b/drivers/video/fbdev/kyro/fbdev.c
index 9bfed90c7f563..06bdacf0211a1 100644
--- a/drivers/video/fbdev/kyro/fbdev.c
+++ b/drivers/video/fbdev/kyro/fbdev.c
@@ -723,7 +723,8 @@ static int kyrofb_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 	if (!currentpar->regbase)
 		goto out_free_fb;
 
-	info->screen_base = pci_ioremap_wc_bar(pdev, 0);
+	info->screen_base = devm_ioremap_wc(&pdev->dev, kyro_fix.smem_start,
+					    kyro_fix.smem_len);
 	if (!info->screen_base)
 		goto out_free_fb;
 
@@ -760,7 +761,7 @@ static int kyrofb_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 	fb_memset_io(info->screen_base, 0, size);
 
 	if (register_framebuffer(info) < 0)
-		goto out_unmap;
+		goto out_free_fb;
 
 	fb_info(info, "%s frame buffer device, at %dx%d@%d using %ldk/%ldk of VRAM\n",
 		info->fix.id,
@@ -771,8 +772,6 @@ static int kyrofb_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 
 	return 0;
 
-out_unmap:
-	iounmap(info->screen_base);
 out_free_fb:
 	framebuffer_release(info);
 
@@ -794,8 +793,6 @@ static void kyrofb_remove(struct pci_dev *pdev)
 	deviceInfo.ulNextFreeVidMem = 0;
 	deviceInfo.ulOverlayOffset = 0;
 
-	iounmap(info->screen_base);
-
 	arch_phys_wc_del(par->wc_cookie);
 
 	unregister_framebuffer(info);
-- 
2.53.0



