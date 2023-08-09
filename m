Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7432A17756
	for <patches@lists.linux.dev>; Wed,  9 Aug 2023 11:21:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E86ACC433C8;
	Wed,  9 Aug 2023 11:21:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1691580105;
	bh=tbmgvXGtuXRAZSFw/ZMQLE6Ym2s3C03kTOC1meUZgbA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tzwQvRHl3AhQBnD3d8Ib5pKMVuBNw9YZWHlx7l4a/0PGt+ISEsWKhah/LRlT9NXG/
	 ivDwZkjBBLS9CL2oRKE6+UEalndoW3q+0vXg2d71c6xQdNBf+d6OYLN9IVLDQx8uR+
	 XrUYWEcPAFNeleSgIra01xEZhnPvWU+s2NkAx1tY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Martin Kaiser <martin@kaiser.cx>,
	Helge Deller <deller@gmx.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 202/323] fbdev: imxfb: warn about invalid left/right margin
Date: Wed,  9 Aug 2023 12:40:40 +0200
Message-ID: <20230809103707.387925147@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230809103658.104386911@linuxfoundation.org>
References: <20230809103658.104386911@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Martin Kaiser <martin@kaiser.cx>

[ Upstream commit 4e47382fbca916d7db95cbf9e2d7ca2e9d1ca3fe ]

Warn about invalid var->left_margin or var->right_margin. Their values
are read from the device tree.

We store var->left_margin-3 and var->right_margin-1 in register
fields. These fields should be >= 0.

Fixes: 7e8549bcee00 ("imxfb: Fix margin settings")
Signed-off-by: Martin Kaiser <martin@kaiser.cx>
Signed-off-by: Helge Deller <deller@gmx.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/video/fbdev/imxfb.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/video/fbdev/imxfb.c b/drivers/video/fbdev/imxfb.c
index c4eb8661f7516..8ec260ed9a6f6 100644
--- a/drivers/video/fbdev/imxfb.c
+++ b/drivers/video/fbdev/imxfb.c
@@ -601,10 +601,10 @@ static int imxfb_activate_var(struct fb_var_screeninfo *var, struct fb_info *inf
 	if (var->hsync_len < 1    || var->hsync_len > 64)
 		printk(KERN_ERR "%s: invalid hsync_len %d\n",
 			info->fix.id, var->hsync_len);
-	if (var->left_margin > 255)
+	if (var->left_margin < 3  || var->left_margin > 255)
 		printk(KERN_ERR "%s: invalid left_margin %d\n",
 			info->fix.id, var->left_margin);
-	if (var->right_margin > 255)
+	if (var->right_margin < 1 || var->right_margin > 255)
 		printk(KERN_ERR "%s: invalid right_margin %d\n",
 			info->fix.id, var->right_margin);
 	if (var->yres < 1 || var->yres > ymax_mask)
-- 
2.39.2



