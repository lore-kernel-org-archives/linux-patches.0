Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795028671;
	b=nwxi/rTkKg252i72Vj+Wo5CTr3AbvYPgfKRsqsC0jmdtHEYej7ygrv8q//o0eq8HPxb6
	 mOHFZK6iWEjcVPZ37bd9rgsx1dh17nObWLeiQCLRQyT3EywgcDk1ckrwM7rbmWFwn3lLZ
	 ysgNGdxLut79wql+6HbKaqPmzG8MQc2Al7hyGTMiWGC1NhXOAMWyCEH15uZPMUUmlikTP
	 umjc7P0WQ840PyD2AIsruKwn8lUkN7aGWRJII5AVLZJrudcMPLkd739+ZY986PoL6FWaz
	 bfir1bZlIg8MHr/UQwQNPwZ7db857aqclyZ9PRIg+8sWXSyl0Go8MpUqsd1ca9ry++A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795028671;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Obi5FjjIhbZBc1uIJrsHvlM5M6raM0L3TomSRP/gw9c=;
	b=QXWzmg2M2LD6nodmj8ydQcCFA/StJjr84dLF1w3lxuXHw3s8hhBsSGAviOISwv500FYm
	 ZTwQ240WydOG9tk8epw1MYj6FABlbivw5DdJwO7SbAK53n4MX3G286hoGCd/AY+cK9/LF
	 h/+A+7Fay1BUI+6GAjUOvMPpe7AL6cECTdxQA2vPOpKBmJroMnTdQDrZJqkOT6qVayCRM
	 4N0zTwZkTCV3hRikf2d3Agn32Bh1YwZgM1h19skYPqjWVnXB/FvL5Q784P/dfDxJYPDRi
	 bllaLp7PRWS286pqmwvrcpaCVdZBQ8/bdE7iwNufJC/FYMYoSp8XBZ8D0M+LzPDovvw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=cQUZ82Tx;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 19841606A320;
	Wed, 18 Nov 2026 19:04:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=cQUZ82Tx
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 682591F000C6;
	Wed, 18 Nov 2026 19:04:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795028671;
	bh=Obi5FjjIhbZBc1uIJrsHvlM5M6raM0L3TomSRP/gw9c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=cQUZ82Txg+dcNFhXlTRLEpzjznoUN0jeWp+EBw6aGlyWycldiTrKPYishvQyC+LK4
	 mG1jjiYrnVODTq6+dHODd+wxFCiVWJNvAcUJja+MtIfHVRlLsDgMbRUYXN1O9b1aDm
	 QwBlYKInsrrLWv9VMjoTn6jppHbXix9i/LJBBDcI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Giovanni Di Santi <giovanni.disanti.lkl@gmail.com>,
	Helge Deller <deller@gmx.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0079/1756] fbdev: kyro: Use devm_ioremap() for mmio registers
Date: Wed, 18 Nov 2026 15:36:46 +0100
Message-ID: <20261118150011.431803537@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150007.957976754@linuxfoundation.org>
References: <20261118150007.957976754@linuxfoundation.org>
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

From: Giovanni Di Santi <giovanni.disanti.lkl@gmail.com>

[ Upstream commit e0bf12a43243e6afc5a03fc55c58ec48aba48088 ]

Replace the manual ioremap() call for the MMIO registers with the
device-managed devm_ioremap() variant.

This simplifies the driver's resource management by ensuring the memory is
automatically unmapped when the driver detaches from the device.

Signed-off-by: Giovanni Di Santi <giovanni.disanti.lkl@gmail.com>
Signed-off-by: Helge Deller <deller@gmx.de>
Stable-dep-of: d3bc005a6294 ("fbdev: kyro: Release WC setup on registration failure")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/video/fbdev/kyro/fbdev.c | 8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

diff --git a/drivers/video/fbdev/kyro/fbdev.c b/drivers/video/fbdev/kyro/fbdev.c
index cf6062210c8bb..c026600d5963b 100644
--- a/drivers/video/fbdev/kyro/fbdev.c
+++ b/drivers/video/fbdev/kyro/fbdev.c
@@ -718,13 +718,14 @@ static int kyrofb_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 	kyro_fix.mmio_len   = pci_resource_len(pdev, 1);
 
 	currentpar->regbase = deviceInfo.pSTGReg =
-		ioremap(kyro_fix.mmio_start, kyro_fix.mmio_len);
+		devm_ioremap(&pdev->dev, kyro_fix.mmio_start,
+			     kyro_fix.mmio_len);
 	if (!currentpar->regbase)
 		goto out_free_fb;
 
 	info->screen_base = pci_ioremap_wc_bar(pdev, 0);
 	if (!info->screen_base)
-		goto out_unmap_regs;
+		goto out_free_fb;
 
 	if (!nomtrr)
 		currentpar->wc_cookie = arch_phys_wc_add(kyro_fix.smem_start,
@@ -772,8 +773,6 @@ static int kyrofb_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 
 out_unmap:
 	iounmap(info->screen_base);
-out_unmap_regs:
-	iounmap(currentpar->regbase);
 out_free_fb:
 	framebuffer_release(info);
 
@@ -796,7 +795,6 @@ static void kyrofb_remove(struct pci_dev *pdev)
 	deviceInfo.ulOverlayOffset = 0;
 
 	iounmap(info->screen_base);
-	iounmap(par->regbase);
 
 	arch_phys_wc_del(par->wc_cookie);
 
-- 
2.53.0



