Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795049555;
	b=PW87DqSpNutmMDVsN78g4XNPk6UNg86m+TLAeTY8NgknOeRD9B/Vbbbf4H2okv9MK6D2
	 Csd60zN/NmgcLv1xd/je/0sf3MpGYc/zgVvBiXqqGaae9MfTMzozKScDhKkSCJWcMLPY9
	 76sowQCNS+fVZv0tT5B8dU6bThmkpWhtmYmKAsJvqtTjYDrxRbIdz11xuDx1MKd5/sjVz
	 QzLkxRTJx66TfoT0XKQeY4OvlsW5WxdmAY4JNg0UYFuq1UOQIGr5cblQ5hfEfHz6tbWrg
	 Xq0P4vONH8D/07D85v6zh7dfNk2e28DP9kSJWM1JqguzpVh4u5K5YWOfsBnEqwkFuqw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795049555;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=xrO5us0v6c+zfPqX8KbbqpJ55HGBnQEI042LamyKnDk=;
	b=DImxa32LkhPSRhKJBccdNXAr0K8bN+VdncyVPSPaxbQuOYsLcEcX9v4AgcUWSbfyWgEo
	 G7FYVUrp02P7+6n//F4QmLtpa39pAYw/3Kwt8zixn2UP3cobJpUnH3y/UtDHfI/ypvN3K
	 k8b88WVjDN9DDWYWjQB4dZARO8hBl/vtsTc7bgKYJKnGnS9dYPEALMDOfta6ungklWyBR
	 5OJoXhUKfrFfLijIn1+TPkyL1iC2cPFBDvOZebsQIwuT+wp1JrJ+1QOEfurNyiRiY5RNW
	 bglJDEKfrHiTz1udmB7yXZHok/5F6BgiOPhK6/CssK5IpWPWIvVTqP5y69RKKWoUnQw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Xm94SjGy;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2CC67606A325;
	Thu, 19 Nov 2026 00:52:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Xm94SjGy
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 85A6D1F000C4;
	Thu, 19 Nov 2026 00:52:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795049555;
	bh=xrO5us0v6c+zfPqX8KbbqpJ55HGBnQEI042LamyKnDk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Xm94SjGyg+JJdE23cUFwcbDeCp8Z8fF6MvPPlLuVjo++6gedeq17HPI9neUxiUZPy
	 +IrDPAo2X+vMFm4khjTlqRBRfZOgEaISpYxs+vAozDqBVjKliREtmP82aGcyHx6cW+
	 GpeOkYWjLSzT//s6NPYdwlpp4hO1tViAKae3+uAM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ijae Kim <ae878000@gmail.com>,
	Myeonghun Pak <mhun512@gmail.com>,
	Helge Deller <deller@gmx.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 2392/2857] fbdev: gxt4500: Release WC setup on probe failure
Date: Wed, 18 Nov 2026 15:57:06 +0100
Message-ID: <20261118150327.649021460@linuxfoundation.org>
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

From: Myeonghun Pak <mhun512@gmail.com>

[ Upstream commit b71e0bb7ad40c005b167e9b48be3af5a3fa51974 ]

gxt4500_probe() adds a write-combining range before allocating the cmap
and registering the framebuffer. If a later step fails, the range is
not released. Add the missing cleanup before unmapping the framebuffer,
matching the successful remove path.

This issue was identified during our ongoing static-analysis research
while reviewing kernel code.

Fixes: 38fc4d45fae5 ("gxt4500: Use arch_phys_wc_* for framebuffer")
Assisted-by: LLM
Co-developed-by: Ijae Kim <ae878000@gmail.com>
Signed-off-by: Ijae Kim <ae878000@gmail.com>
Signed-off-by: Myeonghun Pak <mhun512@gmail.com>
Signed-off-by: Helge Deller <deller@gmx.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/video/fbdev/gxt4500.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/video/fbdev/gxt4500.c b/drivers/video/fbdev/gxt4500.c
index 0dcef4bec8d7c..fc7e7562d38f7 100644
--- a/drivers/video/fbdev/gxt4500.c
+++ b/drivers/video/fbdev/gxt4500.c
@@ -722,6 +722,7 @@ static int gxt4500_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
  err_free_cmap:
 	fb_dealloc_cmap(&info->cmap);
  err_unmap_all:
+	arch_phys_wc_del(par->wc_cookie);
 	iounmap(info->screen_base);
  err_unmap_regs:
 	iounmap(par->regs);
-- 
2.53.0



