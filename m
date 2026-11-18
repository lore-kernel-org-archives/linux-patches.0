Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795045766;
	b=T2oIvTeEFx69R6jAEICFych+Hs72Ay7zoW1M6yDTA4lrqS+fJ1/LoZ8wxOVLT74t1l3N
	 ZGVQAkmAranRpKzVtNGNRz1hX6Jb4QHgThd/3cTScRq/Td+q2We6kj+1lGiZ77zClAKwT
	 NyA2MZszYvqhnnrlV9Pni/ewZX+gaDQQ1FapWAFMhj7ASrSi+gY2RZROiMP9p6TwbRb9X
	 q0CYB9btPxaXitmNv4Db8bimQU/fkDw17W2w3iIDY34neULAsCbUKZIbPjqOFrzoi0KWr
	 r6AXtuZEX+5ZzVufn6c9DevDQw8wmJ2tcu51dfhSIhrnI5/htmh8FdtAp2tFRmHksWA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795045766;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=ppxZ0alAwW/8O7XQs0VEqLUN6F1r2KDj4ha1bBMt7OU=;
	b=zwJnR7dgKZMPFl4gxi1FAGbny3F6CKrkJ0/Ifqu/a0LROx6efsnr7wH5p+FBLGXs/344
	 x8JV9I00xNoEFQHrjNZZjDBSPPJLV5CoYfEu/iadsQroOBMYObnZVHIrDiiJrydUvqqXm
	 KmOk7amH1ZVjrtMj7hzpmStg1Bnr8eG4MoWQDh4teqm9MvgkoK+VeqUbghEH+2msT45zQ
	 Wb541iD0gFQnnDt+8EXSZHCxF7yblNZdtE8eB6YfeIotLWm22dprEDYgN00Xa91UwKqNJ
	 JvC66z7K0zYnQ1QiUC7nK0z8sTfZNPjWonw/UBb+Mf+SE0r669BabEZ77iVRB6J2B0w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=OXnokY1G;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 449D1606A31C;
	Wed, 18 Nov 2026 23:49:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=OXnokY1G
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 960FD1F000C4;
	Wed, 18 Nov 2026 23:49:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795045766;
	bh=ppxZ0alAwW/8O7XQs0VEqLUN6F1r2KDj4ha1bBMt7OU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=OXnokY1GDCXud5XsRBMd/MkVYbcBaZY5lM5c3xQyu+gy3pHU1RHjyFC9vCLa4cq7g
	 1tsl8smYEX8umT6JJJeShVBZjH9CmF1l8TTHE5Gqm/bQKK6bKyOTZI3w+0FCNj58+E
	 tG+2lYKaw33wOOyK+3+kL3MQOLYBcuMdnsK1qlnA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wang Haoran <haoranwangsec@gmail.com>,
	Li Ximo <lixicaicai@gmail.com>,
	Helge Deller <deller@gmx.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1042/2857] fbdev: atmel_lcdfb: fix list_first_entry() on possibly empty modelist in probe
Date: Wed, 18 Nov 2026 15:34:36 +0100
Message-ID: <20261118150239.114840347@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Wang Haoran <haoranwangsec@gmail.com>

[ Upstream commit 01d1204582f16e8b7bfce29648e5cf77a585d962 ]

list_first_entry() does not return NULL on an empty list; it returns a
bogus pointer computed by container_of() from the list head.
atmel_lcdfb_probe() initializes info->modelist with INIT_LIST_HEAD()
and later takes its first entry with list_first_entry(), assuming
atmel_lcdfb_of_init() populated it. However, atmel_lcdfb_of_init()
drops the return value of fb_add_videomode() — unlike every other
fallible call in the same function — so if fb_add_videomode() fails
(its internal kmalloc can return -ENOMEM under memory pressure or
fault injection), the list stays empty while of_init() reports
success. The probe path then dereferences the bogus pointer in
fb_videomode_to_var(&info->var, &modelist->mode). Because the bogus
pointer lands inside the contiguous fb_info allocation, this may not
fault immediately; instead it silently reads adjacent memory as a
struct fb_videomode and programs garbage timing parameters into the
LCD controller. This was found by code audit; we do not have Atmel
hardware to reproduce it.

Fix this on two levels: check the return value of fb_add_videomode()
in atmel_lcdfb_of_init() so the failure is propagated (root cause),
and use list_first_entry_or_null() in atmel_lcdfb_probe() with a NULL
check that fails probe gracefully with -EINVAL (defense in depth),
consistent with the surrounding error handling which bails out to
stop_clk.

Reported-by: Wang Haoran <haoranwangsec@gmail.com>
Reported-by: Li Ximo <lixicaicai@gmail.com>
Cc: stable@vger.kernel.org
Signed-off-by: Wang Haoran <haoranwangsec@gmail.com>
Signed-off-by: Helge Deller <deller@gmx.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/video/fbdev/atmel_lcdfb.c | 13 ++++++++++---
 1 file changed, 10 insertions(+), 3 deletions(-)

diff --git a/drivers/video/fbdev/atmel_lcdfb.c b/drivers/video/fbdev/atmel_lcdfb.c
index f2b63f13e2444..707a0a0cd74e7 100644
--- a/drivers/video/fbdev/atmel_lcdfb.c
+++ b/drivers/video/fbdev/atmel_lcdfb.c
@@ -1032,7 +1032,9 @@ static int atmel_lcdfb_of_init(struct atmel_lcdfb_info *sinfo)
 	if (ret < 0)
 		goto put_display_node;
 
-	fb_add_videomode(&fb_vm, &info->modelist);
+	ret = fb_add_videomode(&fb_vm, &info->modelist);
+	if (ret < 0)
+		goto put_display_node;
 
 put_display_node:
 	of_node_put(display_np);
@@ -1100,8 +1102,13 @@ static int __init atmel_lcdfb_probe(struct platform_device *pdev)
 	}
 	atmel_lcdfb_start_clock(sinfo);
 
-	modelist = list_first_entry(&info->modelist,
-			struct fb_modelist, list);
+	modelist = list_first_entry_or_null(&info->modelist,
+					    struct fb_modelist, list);
+	if (!modelist) {
+		dev_err(dev, "no video mode available\n");
+		ret = -EINVAL;
+		goto stop_clk;
+	}
 	fb_videomode_to_var(&info->var, &modelist->mode);
 
 	atmel_lcdfb_check_var(&info->var, info);
-- 
2.53.0



