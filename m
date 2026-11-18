Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795060167;
	b=hdKllbP3Js/MssbOcHzgsMNI5p2bar571jEcZrtR8oDNG1kSyLRJozHqhPzTNxNdB+n+
	 xV2FYXCrBh+DQQxTv/iHN9SrfTCzS1ycaYF8qSP7HgvI0bMzK6+PZnqXQVDEepzjgkb+B
	 dubUcdsXMx3wexXEUo9H9rYeD+cE8Eu780TqpgBxIRhaSuDPXALbHGsElzoYZLTlLwdzr
	 YLahYWanqjoE43olS0WuV633VRuUQNmbv9zBDaDxw/qcuapYiYEN8YooTobKmynBgeLtP
	 SuREqJp6mRrouv9GICvQM9jOBhqnyJu7TfXNZ8dNgNQfcq5PIC3kdhUCq3GehvgB2rg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795060167;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=h7nrtVdw1W0WBCyOla1LJasbDjcN85YkyJaOhAa2vTQ=;
	b=xOgV0078aR8PTQ7/1rJZZzJx0IizbwEJC1bzJDOndyQ/VjoQhAzSQcY2PVAZRMysU+gP
	 hkVOHCq+8JGshzL3K9chHqPcC2Y22VrJR9x/Dsh0z+eGfYtxO9i0svv+WlCg+fm9O0xKW
	 b379NS7eyfFbsn03Owx/P8ILsIJFRPu9P3GZuFd52FmiOwTOBYSnAnSWTs+aqO/g1PHEH
	 6D9PJsDSgZQWhuYVy8G/FXxRMvXzzIsEDp4NX2MC7Q+ne6yrQk1melD2ryJT14/dOvGOk
	 cwGXxrjxLBqPP45moje5Vzjn2irUQoc3GHOk4lQ/IFGclR9Q0UOHzgS89vpgd6hablw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=MH8nJkTs;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 25474606A320;
	Thu, 19 Nov 2026 03:49:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=MH8nJkTs
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7660B1F000C4;
	Thu, 19 Nov 2026 03:49:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795060167;
	bh=h7nrtVdw1W0WBCyOla1LJasbDjcN85YkyJaOhAa2vTQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=MH8nJkTs/8TIFLXeJOB48ZpZXxzyTc3QPa9rrUM1g33up4//q860au3B12BssS3Y3
	 Acn5/YfutwD5fsEwwCFTTPNXnMcOwqf70a6nAm01i97IlzA0ln1bETQOnxZn6ABKOh
	 k0vuTl0iOAwWglowYNrGu/pkObgUwENKcxGMjNTM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Giovanni Di Santi <giovanni.disanti.lkl@gmail.com>,
	Helge Deller <deller@gmx.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 1065/1848] fbdev: kyro: Use devm_ioremap() for mmio registers
Date: Wed, 18 Nov 2026 15:51:43 +0100
Message-ID: <20261118150002.232930109@linuxfoundation.org>
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
index 4979339dbc008..7441d48faea77 100644
--- a/drivers/video/fbdev/kyro/fbdev.c
+++ b/drivers/video/fbdev/kyro/fbdev.c
@@ -713,13 +713,14 @@ static int kyrofb_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
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
@@ -768,8 +769,6 @@ static int kyrofb_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 
 out_unmap:
 	iounmap(info->screen_base);
-out_unmap_regs:
-	iounmap(currentpar->regbase);
 out_free_fb:
 	framebuffer_release(info);
 
@@ -792,7 +791,6 @@ static void kyrofb_remove(struct pci_dev *pdev)
 	deviceInfo.ulOverlayOffset = 0;
 
 	iounmap(info->screen_base);
-	iounmap(par->regbase);
 
 	arch_phys_wc_del(par->wc_cookie);
 
-- 
2.53.0



