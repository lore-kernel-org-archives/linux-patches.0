Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795047514;
	b=bDgg4Xzt/Q5lfUSOgcJjAiDltsJIpnFyfxaH5q400VnRFKezRmQb1YpYd0WEzGypDU0K
	 FEtGQma2fMl/itQOmXR7fIw2hLr+D/WWc+ia/lm2junnrS2qiGBmXMl1FNbZJjggDtaSc
	 ekTnaHnrgqzK/TcFEmbJ/gLG9AdCnOy7rPjTZ8Q5QxK0IH56717R2GyHXYeATFOQmRG9U
	 ujtrKzCbKx1YS06M5UbqsjSyQjTKv05bpGpGoo4vCUq3iCCMQhOq+PjS7ZR4T+X9x84Qo
	 iwgEaAe3UtoFDldi/sCLllVWXiLsRFCD8Tr6PP/7INX7SyNyKTibGTiVS1JPZTR7QEw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795047514;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=MMu08xVCyYutlmEKYZLbUIfjvO3n6q4irU/j19fraKw=;
	b=tvCDbttZTQ3Ik6LlxPsc7F3ng56P6c36eL+LWQ1mVqO5nHLoyLwWttLe6oHfbDXRhiSt
	 xSOzBawSIBlXvffgTfKCDVO/Sn8nTT2kfBd0Rv531QPy11YI0cJbcwI+hLVpbSMFBWHoH
	 Zlsi2xLTgEKcNqR/p1RLy8X0EA6QuYC47mV51oVwNA7UbU4LW5HBR1qd3X1ERQwB4uqGh
	 i/0rDDCAZHsHviOTKeUGGrYyrnoBDGA+x5fp57q5WAV75rrrju2eDcsguIofND576dA3d
	 8IzlI4WO2WD/zERB2uSjyuINR8xLiFMyxTakKlv9TUkzFvm8xEnCs4OzYfG0I5yVizw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Ap8ycSeK;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 841F3606A32F;
	Thu, 19 Nov 2026 00:18:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Ap8ycSeK
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D35F41F000C4;
	Thu, 19 Nov 2026 00:18:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795047514;
	bh=MMu08xVCyYutlmEKYZLbUIfjvO3n6q4irU/j19fraKw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Ap8ycSeK9KGsY/SbjbR3fPB1F+rzAmGqX7sbxOnlHATa988P1+4dt10Ujvn6RXrIz
	 tt5wwyu3jACAiYXKfJQX0e5gqs7Hjd2dwWn0d0a0nyIuGvbGFP/0hu/Sh4GirSzLuP
	 TIO0Wjg0/fzOpank1tXhX/KNNvKy+JC+nHvZr0VU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Giovanni Di Santi <giovanni.disanti.lkl@gmail.com>,
	Helge Deller <deller@gmx.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1666/2857] fbdev: kyro: Use devm_ioremap() for mmio registers
Date: Wed, 18 Nov 2026 15:45:00 +0100
Message-ID: <20261118150301.316124247@linuxfoundation.org>
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
index f3e214397ea95..38c78956b7375 100644
--- a/drivers/video/fbdev/kyro/fbdev.c
+++ b/drivers/video/fbdev/kyro/fbdev.c
@@ -720,13 +720,14 @@ static int kyrofb_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
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
@@ -775,8 +776,6 @@ static int kyrofb_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 
 out_unmap:
 	iounmap(info->screen_base);
-out_unmap_regs:
-	iounmap(currentpar->regbase);
 out_free_fb:
 	framebuffer_release(info);
 
@@ -799,7 +798,6 @@ static void kyrofb_remove(struct pci_dev *pdev)
 	deviceInfo.ulOverlayOffset = 0;
 
 	iounmap(info->screen_base);
-	iounmap(par->regbase);
 
 	arch_phys_wc_del(par->wc_cookie);
 
-- 
2.53.0



