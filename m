Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795054424;
	b=LUbPsVKhxKh/xvjCfH34LQG/oj6JXVk5eKC0+la5URiy5aT63lZQPdE15yM9RdVRLWo0
	 pcMjLNendKfUTPHEFPf0NBCdpyxIprR7nW+3HenhoUYk9h+EiP4CAbb4FSeYeHq4p+6B8
	 /ECZs/Hch4gvttI0sxX1AWnSEIKTD2yZs/V86yCwoRb2GmQwSoDatdAensYHc8xSVlhQC
	 +I1GGsWGQz0GnAr3usVDjYMHWXGoQYHKu2VgWU1x03KHdPEIPHeDWQi1N1Y3PtHzRGpHg
	 HY19cwu55TrRIcVi2B/kYCe5Cr4t9ls50oPBMf4Mqijrgo/rqtpdRDMd9D6DJbwKrcg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795054424;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=BnSQJEreACODK7eVeCvvMVO/GI7seCX71dwriEf8rZ8=;
	b=5X+lVf8U/iq+YHY5YJn5DXagI+YSRWgInXB2xshqZVmFe6Q+6+281d7235M6U7D/nCfU
	 QmuN8EANqR0Aa2fzQOGqKj+SodEvh0vnnBuDjz8DBxGLLRXvvUdQ7/y4dGW4TwF/IRNqL
	 9FGQVk04+to/bWcZRKxcrBUN7ZFr1I8OkuKsqr37bUBb2C0ks/0esGz73ySvVwnYI0j8e
	 qmcw6pkv72ioSYKpn69Ez9KPPIZmMUmBl+ivi7egLEFNeluR4wY2t8iJ0ytkxNTP6/5g5
	 7qFsB+p4cHwkeHS9SrEk5zh5IEUC0wboqKQ5V1VzN4ofHD/kJAytEFoONykAeGeX33A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=PAvG6CRI;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 05E4C606A31C;
	Thu, 19 Nov 2026 02:13:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=PAvG6CRI
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 543021F000C4;
	Thu, 19 Nov 2026 02:13:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795054423;
	bh=BnSQJEreACODK7eVeCvvMVO/GI7seCX71dwriEf8rZ8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=PAvG6CRIZDojK7Hp/TkAG5Xw+2hQmNi5tyUYJhN9R+zuKnIGE7tgAhaFB2hIvKb8K
	 yjpWZUYo6lyfZLoN0Zo+0K8rSHQ9WTHypPqusoi9vGUPGxgNVEhcGIC/WKvuwh1YnS
	 9fRWGrVnI0WBg4/aKJlOTrJselsb38LLwEZ+6DtM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ijae Kim <ae878000@gmail.com>,
	Myeonghun Pak <mhun512@gmail.com>,
	Helge Deller <deller@gmx.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 1269/2214] fbdev: kyro: Release WC setup on registration failure
Date: Wed, 18 Nov 2026 15:49:05 +0100
Message-ID: <20261118150102.373481017@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Myeonghun Pak <mhun512@gmail.com>

[ Upstream commit d3bc005a62945aec57059201092b12b7c955e5a7 ]

If register_framebuffer() fails, kyrofb_probe() frees the framebuffer
without releasing its write-combining range. Release the range before
freeing the framebuffer. Earlier failures still skip this cleanup.

The missing cleanup already exists in the initial Git import, before
the conversion from mtrr_add() to arch_phys_wc_add().

This issue was identified during our ongoing static-analysis research
while reviewing kernel code.

Cc: stable@vger.kernel.org
Assisted-by: LLM
Co-developed-by: Ijae Kim <ae878000@gmail.com>
Signed-off-by: Ijae Kim <ae878000@gmail.com>
Signed-off-by: Myeonghun Pak <mhun512@gmail.com>
Signed-off-by: Helge Deller <deller@gmx.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/video/fbdev/kyro/fbdev.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/video/fbdev/kyro/fbdev.c b/drivers/video/fbdev/kyro/fbdev.c
index b298e9a1b4510..c9f8875e34d91 100644
--- a/drivers/video/fbdev/kyro/fbdev.c
+++ b/drivers/video/fbdev/kyro/fbdev.c
@@ -757,7 +757,7 @@ static int kyrofb_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 	fb_memset(info->screen_base, 0, size);
 
 	if (register_framebuffer(info) < 0)
-		goto out_free_fb;
+		goto out_free_wc;
 
 	fb_info(info, "%s frame buffer device, at %dx%d@%d using %ldk/%ldk of VRAM\n",
 		info->fix.id,
@@ -768,6 +768,8 @@ static int kyrofb_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 
 	return 0;
 
+out_free_wc:
+	arch_phys_wc_del(currentpar->wc_cookie);
 out_free_fb:
 	framebuffer_release(info);
 
-- 
2.53.0



