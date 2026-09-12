Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 39ED7384233;
	Sat, 12 Sep 2026 08:47:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789202849; cv=none; b=XhlWGbVOhb89oUHgAmziGPBMYi2G7J3bfY1UrEOcaioDRHZPDMDsAvDd4lY8POS5FATp3VKN8xRAxJpIKGljDFkbdlk2WtQjiYm126zHWzxx17t0kmgoF5HmYJoHw5XmGDBcrtzU6rYrGs+a0n1QSL0seCLPuEt9zbZEx6WgEuo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789202849; c=relaxed/simple;
	bh=xUzUUe2/FrbjumhVImUzyinvcuMS4w7rOvmp/V80uOY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GkgCrFP8gyxLgv4Hp4wD+1nHjtozBJqIRul4gjS73wuWW/bu3R/rlEcjRSe+xTDhEBBsSILxROZt7GyowUvVzFl7tRQrFzzWNh9loIBdA7MEMwwF07toLvxrnIyY8h/BMmp2gnNh+B+0MvCUnsH2bROgkus6kJjPT4DcrRJLdag=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RgKRkySl; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RgKRkySl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9DE361F00893;
	Sat, 12 Sep 2026 08:47:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789202844;
	bh=cUhVe6B7qYHuihV7lmWbOgFlgVsdLkDi0k9EVBgzkX4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=RgKRkySlm7TAaDlO4FmuXklj3Mnowiwi2O+JLXg0eLsTREfmbR9e4BoOz4ufFFT7G
	 wpIuRrFPXLDszYjyzBPUyAk/He0xMEAKfd9K0MTAJt7slIdu5AXawG2CLEVtLAIh1J
	 FUeWQ0sY5kvIrNwwH1NjYBKMzxV6QZFnqswFi6uA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Karl Mehltretter <kmehltretter@gmail.com>,
	Thomas Zimmermann <tzimmermann@suse.de>,
	Helge Deller <deller@gmx.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 1288/1815] fbdev: clps711x-fb: Remove unreachable unregister_framebuffer() call
Date: Sat, 12 Sep 2026 08:50:38 +0200
Message-ID: <20260912065719.251068600@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Karl Mehltretter <kmehltretter@gmail.com>

[ Upstream commit 39dd7598fbe90c5b4bb77fb34d8f3dad8385d11c ]

The unregister_framebuffer() call in clps711x_fb_probe() is unreachable.
register_framebuffer() failure jumps to the unwind label, while success
returns immediately.

Remove it.

Found with Clang's -Wunreachable-code.

Fixes: 36462ac193088 ("fbdev: clps711x-fb: Replace check_fb in favor of struct fb_info.lcd_dev")
Assisted-by: Claude:claude-fable-5
Signed-off-by: Karl Mehltretter <kmehltretter@gmail.com>
Acked-by: Thomas Zimmermann <tzimmermann@suse.de>
Signed-off-by: Helge Deller <deller@gmx.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/video/fbdev/clps711x-fb.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/video/fbdev/clps711x-fb.c b/drivers/video/fbdev/clps711x-fb.c
index 7a7db7100499e..6789773b22fbe 100644
--- a/drivers/video/fbdev/clps711x-fb.c
+++ b/drivers/video/fbdev/clps711x-fb.c
@@ -329,8 +329,6 @@ static int clps711x_fb_probe(struct platform_device *pdev)
 
 	return 0;
 
-	unregister_framebuffer(info);
-
 out_fb_dealloc_cmap:
 	regmap_update_bits(cfb->syscon, SYSCON_OFFSET, SYSCON1_LCDEN, 0);
 	fb_dealloc_cmap(&info->cmap);
-- 
2.53.0



