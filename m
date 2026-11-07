Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794062617;
	b=XBWrB4+x41r4qtQX5ZDCMF1xegLE2ZXslcps6mJ8kXLaMA2ogDQREDfukrA9xgPLvwke
	 oF2Xv63XrRhjJ0jSBC7OlOrCFUL59L2kwdpfD14aMxt0x4q4kYd0jEVybPybmCtWRxlNT
	 GGNPv5CVqFnyOIdJIbS8A1FbzeXKjeXfnlaWrK7ILzQtV4sTfBvqa67Ru1An9foOpZDT5
	 41bJCUHAZlbsUQ318N+7SiQnUXojJrRoWHy3D82xnDiF17U8daZt5n0f2xxDGDCpfJNML
	 oFCovrFhTT4W7u/M5zqhMsCzrIpoBFm2xM5B9xCVCqOplhjzhGufj9fsTZFCVxuAYSw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794062617;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=zhOjlPgheumBke4qbOWZ49tVpfBTz4/ig1ZzIzkD8JU=;
	b=nbnGAoB4Moc2Oz/V/w9vEI/mbFfrOZdvyM0mu9I+9hiJJUPRmlqVY5n+y/sOrmKXdwy+
	 /3uau+7f5wY1qi+sToOumKsKZdgGDTf352CnYVFvwJgSHjDJTMkgklI749cHnfOPMDI0n
	 IS4M1zI2Mgk1vSGkaejlB9uBqq383wE1zPmj8U65oexJzJUP0VJT1epStEZnzGK3FBwNq
	 +ABqUwh1n05Mvs3ZhkxDPPdUr/x8Ru55N9NP6rkm5ARWFq24j6+9vXRCfY+4zoy0smc9v
	 9B9jjnyRcE12nn5EQJxZBCsm4PDfUpNJzpSN805ZniOqDmEQ+wNyjWqPkCpQhWq8jKA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=u0srpHvv;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 487B5606A333;
	Sat,  7 Nov 2026 14:43:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=u0srpHvv
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EBCA91F0089F;
	Sat,  7 Nov 2026 14:43:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794062617;
	bh=zhOjlPgheumBke4qbOWZ49tVpfBTz4/ig1ZzIzkD8JU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=u0srpHvv7NjESXdO7o8jbYY4qaxu50IYjRzID6f0czZP4Pon5OkfMxwW2VB1jHVkN
	 q/6Onwy7wijADdvmnQXQLB6T18ZzZdoFfFUiqQJrNcC0ZSoi9V8NWogouAf/6McAvX
	 Xh+Im/BlXNNh6jSoE2qp8uM3gR4nuwZm+ymhxyeM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wang Haoran <haoranwangsec@gmail.com>,
	Li Ximo <lixicaicai@gmail.com>,
	Helge Deller <deller@gmx.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1450/1536] fbdev: atmel_lcdfb: fix list_first_entry() on possibly empty modelist in probe
Date: Sat,  7 Nov 2026 08:57:46 -0500
Message-ID: <20261107135038.564349548@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134957.653319350@linuxfoundation.org>
References: <20261107134957.653319350@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index ecf805b5c7801..934f76410b03a 100644
--- a/drivers/video/fbdev/atmel_lcdfb.c
+++ b/drivers/video/fbdev/atmel_lcdfb.c
@@ -1009,7 +1009,9 @@ static int atmel_lcdfb_of_init(struct atmel_lcdfb_info *sinfo)
 	if (ret < 0)
 		goto put_display_node;
 
-	fb_add_videomode(&fb_vm, &info->modelist);
+	ret = fb_add_videomode(&fb_vm, &info->modelist);
+	if (ret < 0)
+		goto put_display_node;
 
 put_display_node:
 	of_node_put(display_np);
@@ -1077,8 +1079,13 @@ static int atmel_lcdfb_probe(struct platform_device *pdev)
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



