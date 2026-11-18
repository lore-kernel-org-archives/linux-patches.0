Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795047520;
	b=So3JuII64ZcrLWnrjy+LCta5pLzR5X/XLVYFtybC/BOoGNCii4VRzKwPbLD1HetUauZO
	 /Nksbzi/sIEnMwfhB6+vIO19GSSkBP99cDYatxOwttCqAHdYBM+Fwygjh8d4Dl7oY2qlH
	 nKd1ol9wfSqJNFlm+twMM8S0bMVticnko+SI4YLiVzNQpLrwW+8m/Cb0suosJy9cuOoZP
	 OEMF4ZB1xK0ptMT+5Heo5JkBXk24dtbN6FR+k+SlnJ/IYlbszAlzk3hEPREcldsFsOw+D
	 Xd13bxH9eXXFNyjWh6EtnEFAkmE2myvuXelm2FFuoMwNFGKJgE9QcUx9+EOapg1lVRg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795047520;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=HeDVNCmDYEiF1jn4Qq7oI2JLMPUylmjDEELKlGJB8fQ=;
	b=5BfJeo2rKqsgiWIS9LG2RoyzmzcOKdyBr56hN8zr1PdvvaozulS7S5hyJpjFWn6Axtk6
	 NFry2S305JDs4LxQ+lRe0OUnYn122+DaV7bXmQaVPjW03otvmFw+oZLcUpSWEmxgS5sBS
	 5YuSn8IU2bveVzcxoKBroMEP72ddOM0/voRvuGj4mZS2jPZhyymqm9Q1WwJLdSt2rzSnV
	 xNxY2wBcJ0g83f+oTy5iiwMEr26AqilJRLvRc0vwTjSqZf5CEtK5Asu/XKRGd1PMdtbDH
	 oDieZOrOn0+9DLHBZAtVt5kLvzRnYEYmc1WZSf/pF94bl8J2++jCkUbzoFbiZk+pq6Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=OqoNnvJs;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 35149606A31C;
	Thu, 19 Nov 2026 00:18:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=OqoNnvJs
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 858551F000C4;
	Thu, 19 Nov 2026 00:18:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795047520;
	bh=HeDVNCmDYEiF1jn4Qq7oI2JLMPUylmjDEELKlGJB8fQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=OqoNnvJsZOLJwj040PEJMAkShegvZQza8QZmR/YGBC3p9rMCCIgyhj+RYqmjhk8Au
	 RSapjCKGC9pxTZyGdUz3lPRtXLSwMNajFoTjD1A2ITByyTQC1KdTGS5fe5s+AJyJ3w
	 PQjS93KbLALrANvs5If+hhJz1m+iKzhE7pkjJas4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Giovanni Di Santi <giovanni.disanti.lkl@gmail.com>,
	Helge Deller <deller@gmx.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1667/2857] fbdev: kyro: Use devm_ioremap_wc() for screen mem
Date: Wed, 18 Nov 2026 15:45:01 +0100
Message-ID: <20261118150301.351498272@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 38c78956b7375..4a3928a525122 100644
--- a/drivers/video/fbdev/kyro/fbdev.c
+++ b/drivers/video/fbdev/kyro/fbdev.c
@@ -725,7 +725,8 @@ static int kyrofb_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 	if (!currentpar->regbase)
 		goto out_free_fb;
 
-	info->screen_base = pci_ioremap_wc_bar(pdev, 0);
+	info->screen_base = devm_ioremap_wc(&pdev->dev, kyro_fix.smem_start,
+					    kyro_fix.smem_len);
 	if (!info->screen_base)
 		goto out_free_fb;
 
@@ -763,7 +764,7 @@ static int kyrofb_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 	fb_memset(info->screen_base, 0, size);
 
 	if (register_framebuffer(info) < 0)
-		goto out_unmap;
+		goto out_free_fb;
 
 	fb_info(info, "%s frame buffer device, at %dx%d@%d using %ldk/%ldk of VRAM\n",
 		info->fix.id,
@@ -774,8 +775,6 @@ static int kyrofb_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 
 	return 0;
 
-out_unmap:
-	iounmap(info->screen_base);
 out_free_fb:
 	framebuffer_release(info);
 
@@ -797,8 +796,6 @@ static void kyrofb_remove(struct pci_dev *pdev)
 	deviceInfo.ulNextFreeVidMem = 0;
 	deviceInfo.ulOverlayOffset = 0;
 
-	iounmap(info->screen_base);
-
 	arch_phys_wc_del(par->wc_cookie);
 
 	unregister_framebuffer(info);
-- 
2.53.0



