Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795061501;
	b=CyAt6BiYwx1oqe/sNkTo8LrdLH0Ihui/+D5zXTnWnb5Mm0QayYGYk/lt8Qjz/cDDc0AS
	 82jokLTbxvQSuj+QMX9MIMotcc4l8Ayr+JKo97D0g6Np26LMioiOgY7kCguYI0Lqv+h7/
	 H3tWaf3gbG8CIlBWQJrg17ZKBeA1mZYpkc6RCBQUShWz0eeqEnMulSFAZm1RJlL5hQNy9
	 4FLgInQZkoMMo4gZ5tTyIXaGf9XqoCPQaG9BCY5UQymPsWIe7Gs1rK7/0VOfJYiTtfKL7
	 IDicvh1tnU2ypcea86xC5bfKn027HSqLUuzSx2iCBuHpbEL5lYDacuilM4HRjbv4YAg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795061501;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Y7I9ctfliSKp8ZC7Exn/71kFcCe5l2U+WLgQktWWj7Q=;
	b=D1qpNn9hyAii6HJ3quoqovVb+jIcXtImErXXQBB7DWhneQge6N/JcFbUXTUOja6SIysv
	 W8NnH41Hif4DVS1//DHYkX0DfyAU7Kozt3ZP3bQ7tp70T8Ia1/ghwG/nIe7Nye7bEzISZ
	 bt6mpJwzA3laOE8UBwedvoczEFWKI+P0FnnJF5gzjud0gKB9ma5+4Tp8xJUcCCO0eAWy0
	 0AfQWuaddBniFuTKlROe7dmOkzd1arpOwom2mzSjQChbatCw2kwzB9VaNiFetOJdbeJpT
	 g0FAEFdgMYes0z7yNvN0/duxSf0kZ/OnYUqovn+VQCI2LWMvT/ePVKVL0JNqk5t1GDA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=YYquhHIq;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 31CC1606A33B;
	Thu, 19 Nov 2026 04:11:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=YYquhHIq
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4FB5F1F000C4;
	Thu, 19 Nov 2026 04:11:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795061500;
	bh=Y7I9ctfliSKp8ZC7Exn/71kFcCe5l2U+WLgQktWWj7Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=YYquhHIqQmM3P1kvlQSN1D7A8yHi39ARqH45dwKFY1wvYFLvqSBZ5/cKeShjzQxk2
	 r1qp54zS33PmtHr1vSp4BBnnfqt/tbuhkoYE+/oELoGSOgE6bDSSRY5HgSOEzNSMuN
	 o3cRGeZf6OrrXrA3ibF2/GtV2s7uNPLsmOJKrDbU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ijae Kim <ae878000@gmail.com>,
	Myeonghun Pak <mhun512@gmail.com>,
	Helge Deller <deller@gmx.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 1575/1848] fbdev: gxt4500: Release WC setup on probe failure
Date: Wed, 18 Nov 2026 16:00:13 +0100
Message-ID: <20261118150025.526362569@linuxfoundation.org>
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
index e5475ae1e1587..a9124e1dcbde4 100644
--- a/drivers/video/fbdev/gxt4500.c
+++ b/drivers/video/fbdev/gxt4500.c
@@ -717,6 +717,7 @@ static int gxt4500_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
  err_free_cmap:
 	fb_dealloc_cmap(&info->cmap);
  err_unmap_all:
+	arch_phys_wc_del(par->wc_cookie);
 	iounmap(info->screen_base);
  err_unmap_regs:
 	iounmap(par->regs);
-- 
2.53.0



