Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795028674;
	b=xTnKq1oBr2PWOcumZ5fkvda6l8OHZ7+1tPouCYPJN85Mmwt0IfPHNtyqZDFoMrSXNQO4
	 +lvzFVXc1Ygyq50aSjNa+HvYSF8Irf/0I+biAOsefYPj7J2xoVhqgAysLWYPolI4b4jXi
	 /WIP8nwGIl9PeY1zpJ40UhkVo6I3b7C8FV8jQTccdnkd8rQbhTeWE1SigDPd/Ps+KG3Ov
	 zVsbRN/9rz6JzM/8IRadA9ysFmf4rp5Mq+Tf5344EmjDnAbnxRpK5DwlUgIQNRR6pQZsS
	 w9H+C4NBhx0kCb1LqDSyYERXDzYuu2r/zUWGykSZ6GSMqAPg3zeiAUacOL7CAdJsEYg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795028674;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=zc5NlZ/xr/YQQh7RTrlPLO1WSXcZO0km4VelAe7OcNw=;
	b=H6AdZsvsBeJTb81Xhtbi2F5cewRV4pwPUma5gMlzxlM506rhO3p1xWMLOvnZFswy96zQ
	 S6Loc5i7i3whrPWzBfBr7UQ8WPYHwA0u7QOL4n0ILfJSZK56YU6b/oZ5vzUT3vYRDuxAO
	 M5Z/2ln4eIPaSIdRQmzKa6PLxXy8YVe7KAZi+eMs5eZyz+w+pk3DMjbEvcX6hJGV3sV95
	 mcB+akB6Ek7q9syBGTKY9oC7llL1idSgM4Q6/SOIgnK7bp/Gaez0wBwxOPanoZElx98cB
	 1nTIC3xf40r3MImOb0YlK/JSlM6nERBmd3XgCxdY7O81i2b5o54YPjzkL6rbz8SOKcg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=KUgLNYqj;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C83F606A320;
	Wed, 18 Nov 2026 19:04:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=KUgLNYqj
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4EA521F000C5;
	Wed, 18 Nov 2026 19:04:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795028673;
	bh=zc5NlZ/xr/YQQh7RTrlPLO1WSXcZO0km4VelAe7OcNw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=KUgLNYqj8/9aCSEeTROd6J8mn3vi8L2ZdOZjlF7Z4xpReJFaN1DC+zRQWfiQUIcjv
	 v+SVv65/YWoDIV4J8qGaZqIDejKyISlmKo293eeNvgWHKad0rvHpBjloyiHbRF9kGV
	 3kTG2sbL8i+ZUEs/6+nIh/W0S67+AbpIujk2fMOk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Giovanni Di Santi <giovanni.disanti.lkl@gmail.com>,
	Helge Deller <deller@gmx.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0080/1756] fbdev: kyro: Use devm_ioremap_wc() for screen mem
Date: Wed, 18 Nov 2026 15:36:47 +0100
Message-ID: <20261118150011.468107092@linuxfoundation.org>
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
index c026600d5963b..c387bdb1e515f 100644
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



