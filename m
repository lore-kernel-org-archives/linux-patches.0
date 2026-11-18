Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795038948;
	b=ADg4SFEKziqeeZbwbj5p8/v1bmecSKazKvsLlVYQgWDjtbxgHwjSythwzQvN7sPc1Ke2
	 x6NrV1MMm8+Q45DwkFz+x7Uq+gzrvvSnagZLM3Oo/Dtd7XUuwm/BF2MaiFLno9JeYSjw5
	 JD+bXPSuTH5wcEOmYmeso+E/M7StuAi69dH6+TVtKH2QJEFZNbyD9gx6x3RCWgFMGXilJ
	 3OWv0slMspB6G07Ne1/jsmnT9mc0m6K9Uwm2r1NzcrLd/jlSEuZUlsJLXNbrEGrrB84K0
	 FTn3/STNBWLnTLA3aWKzlwWmHwaKFuybphzfd5UE721NeH1tEdDBF8d6V1tvdP24Mkg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795038948;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=WcQUAqQEXPoO2ZQ3MXrlX0icgJjsGoAKCEBbWas4ZYI=;
	b=fHP6EP6+SqQpo+7S8jNgChVpjdfG/cWbEZcE6fhHygP/LCNRcuow0rg3vTezHb4LI8up
	 +7ZY7dE4yIjtef3S0DqmXFNXBf893yQlfZxZLSYIHe+J0MfoW5DsaHOgHB3c0n7roROgG
	 AaSa3Dmp7895HLNW9P1naDhln4j+b4AiSypbGmxEp0dCMc/zCBeYvxC8w75hcO40d5XgA
	 uQRSXlK4IvGA8aeI+lEzuOwxWuKRWcnf3TWtvRlP138ElIRS1tkSGl9smv3ssi3RLByju
	 dKSQCZIRbEMdegQB81VWrGRp3NBSHuxy1jz0yXStBzWKcIwW23c0t+jkK0VOZFgVc1A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=uTqEROBE;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 76124606A320;
	Wed, 18 Nov 2026 21:55:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=uTqEROBE
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C59FD1F000C4;
	Wed, 18 Nov 2026 21:55:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795038948;
	bh=WcQUAqQEXPoO2ZQ3MXrlX0icgJjsGoAKCEBbWas4ZYI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=uTqEROBE81THuhaog5Pdg68TonO2qkDpVN6Igs0e5QGBiCc6BIcEs7KtgqrpOMQBo
	 xB4NkLjI9FJJ0BLiyEnahgGuslE7BslApDHGAX0Hh+VJ20qefWIE9nBRK2FaL6bx2I
	 AECTF0d0Ms5OU9aTNn3z8a8H15ABtPnnwD8NXwd0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Giovanni Di Santi <giovanni.disanti.lkl@gmail.com>,
	Helge Deller <deller@gmx.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1926/3318] fbdev: kyro: Use devm_ioremap() for mmio registers
Date: Wed, 18 Nov 2026 15:42:28 +0100
Message-ID: <20261118150419.798217457@linuxfoundation.org>
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
index 868b028d12348..9bfed90c7f563 100644
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



