Received: from mail-wr1-f48.google.com (mail-wr1-f48.google.com [209.85.221.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BCDEB38F93B
	for <patches@lists.linux.dev>; Tue,  7 Apr 2026 06:59:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775545169; cv=none; b=YQhSFxm9NzmxRZAHuPxHvFcXayLlj8hMemUqafGGiTiOHmBjz2XoQ/qKliQ5SUzkbgQJvk17IvdcfCtpWD8LgO7Zx02bS+ejlwRrvGGqbpvRrIaHUC8c03Io4DxZm3OFg+1NhKfImoknKoZOYLC3avqdm9LKQc4Akv5o6wUGERw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775545169; c=relaxed/simple;
	bh=bBcpBqNdkL3GPcxQ06QpROEKI8JaHAFAoMDpbmSmwlE=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=lQmIWO0OUkPbKt63ejI+Wq8tHN/F9FGmVbzgXhebCMdIO0oDhsd6u/XVXzntvCpHvRFcWqLFJHyckXdgW8lsToKZQIuRAV2rYyAHrbaE1/OE0ge/ecaYxt9+5T4djgi8yepltxI+2qdhpMSTB0j/s9XGH7KuFpaf08HQJDqtTV0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=J0uxjcCu; arc=none smtp.client-ip=209.85.221.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="J0uxjcCu"
Received: by mail-wr1-f48.google.com with SMTP id ffacd0b85a97d-43cfbd17589so3595411f8f.0
        for <patches@lists.linux.dev>; Mon, 06 Apr 2026 23:59:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1775545164; x=1776149964; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=rQDoymknzN02+yzB9HgAmTahnsrc7TSfCPMON3BQVeA=;
        b=J0uxjcCugwRKWu/nXAzspoBOsxsieykhvFzGsrvDfWoUudwruqdplw6oA3zteM8hfS
         8kEdMhgQpcFlPtH/ZD3vHhNSkruvlzadIHo9IOhVfmZXY2bjr8KquLWA/+Wc+j+u5het
         t6wf5Z9mTk2lqcPqRPq7nTBPzs3sEzc0ySVMWfVnMQK1RBKri6AyuoTqbYReqK56Hb4M
         j5S69PXbAF4hHF2enmbIw5L6gkm7Z/um9uD1Z0zqTA34O+GTXol8TbsqGQ658PZVID/c
         65VYhimWAGvHDj8WRAzwGVlXg/M49XrqeH4N5YoxGs1W1U2lvaXUe2TgMnCfPlEfbvy4
         nNMg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775545164; x=1776149964;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=rQDoymknzN02+yzB9HgAmTahnsrc7TSfCPMON3BQVeA=;
        b=dhoisnDFBw4llyZUzfZCfMQzha4ndBUp+s4toSlW/g/0/Za/MxRzWMC1+hAJgN8xJA
         Z/lskTal9fF4UG6zJQjjoJSfQNXQyO35nshsnJrsWj80XQod7Km3qCa9/el/2i1+Lvy/
         LXatm71F6XuvRNdpxnXwjjad4pfV/AxtosnzvjHmbr/z10DO85SSG9Do2hwvnbYRbHVy
         /BNsIvbBAXIDlTF8pm5u0fr8tmKktkpjgAc1DK4cN9OM00DzKAcOjMZ1xWWpdoZTxuUi
         gc1x38fR0byh/3Gdc7+Zwt/qY4W9WP5cl8tEW/jkPTVQeSlwJzXp64pP6BVPp5fTMcKF
         bcaA==
X-Gm-Message-State: AOJu0YxkTfI5bWcoxT486r/M03mJskuYv5xWw8IQLP3NFQDDa1ACfNKX
	Pi8xewpjB/tXCKZZqpkcNm+NUEuIjBJonxX1k4YM0/XtmHL8TAc6w3BfvhPvvg==
X-Gm-Gg: AeBDieuTwLWJvHM3TgKfurKuBauI3oyADPSNe4O28b6PwzHafF7IHzYOImTzyO5Aoht
	K1GzIUT0tREt4wprUURdMncSy6BK/xmS2STYIoKVbuFWNUok/HlecY8ZMJPNNQHAZR5382TKtBJ
	xIcZjMbqAcIc+hpPBgTER5InuG8f3ZQ2COrkHHxJ1YwDnR446l4XIa1Udiyc3rtaZy2hJUZHJy2
	hoBLx5nhrXVfyReGAupWS/95WVXKj4rv24UORlLnq2Y1ybO+y4QrZAMNidxMhkuAcc3igAwpbub
	6k1ewUJ+d17bhFw+Tzu2PFXs235ReaA4WGWfwpO1tnOnjFCtY5CCfHvG7Fos4T9VZfnwt238QBp
	fNgk3LKMmR15a9gIw8T3mak4htcvg9dJEBv2vTiYKYiD++ecD+0zVD6MZv3Bg+ETGrsL1BeKTYE
	tYUQ+L+P1oyTcHPKErIpvh4Yvv4wGUMA==
X-Received: by 2002:a05:6000:208a:b0:43c:f81f:3e6f with SMTP id ffacd0b85a97d-43d2927f3f3mr19248494f8f.8.1775545164387;
        Mon, 06 Apr 2026 23:59:24 -0700 (PDT)
Received: from localhost ([212.73.77.104])
        by smtp.gmail.com with UTF8SMTPSA id ffacd0b85a97d-43d1e4f5294sm44326818f8f.35.2026.04.06.23.59.23
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 06 Apr 2026 23:59:23 -0700 (PDT)
From: Askar Safin <safinaskar@gmail.com>
To: linux-kernel@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	Christian Brauner <brauner@kernel.org>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Jan Kara <jack@suse.cz>
Cc: patches@lists.linux.dev,
	kernel-janitors@vger.kernel.org,
	Randy Dunlap <rdunlap@infradead.org>,
	initramfs@vger.kernel.org,
	David Disseldorp <ddiss@suse.de>
Subject: [PATCH v2] vfs: init/main.c: change comment and pr_err: opening /dev/console may fail
Date: Tue,  7 Apr 2026 06:59:19 +0000
Message-ID: <20260407065919.3246787-1-safinaskar@gmail.com>
X-Mailer: git-send-email 2.47.3
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This patch is for VFS.

Today comment on console_on_rootfs says that opening /dev/console never
fails. This is false. The opening may fail if /dev/console is not
present in internal initramfs. So let's update the comment and pr_err.

I tried to fix the problem itself in [1], but the patchset was rejected,
so I will fix the comment and pr_err instead. :)

v1: https://lore.kernel.org/all/20260406090815.1495095-1-safinaskar@gmail.com/

v1 -> v2 changes: changed text and also moved it to pr_err (inspired by Al Viro)

Link: https://lore.kernel.org/all/20260219210312.3468980-1-safinaskar@gmail.com/ # [1]
Signed-off-by: Askar Safin <safinaskar@gmail.com>
---
 init/main.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/init/main.c b/init/main.c
index 1cb395dd9..daf115d08 100644
--- a/init/main.c
+++ b/init/main.c
@@ -1645,13 +1645,15 @@ static int __ref kernel_init(void *unused)
 	      "See Linux Documentation/admin-guide/init.rst for guidance.");
 }
 
-/* Open /dev/console, for stdin/stdout/stderr, this should never fail */
+/* Open /dev/console, for stdin/stdout/stderr */
 void __init console_on_rootfs(void)
 {
 	struct file *file = filp_open("/dev/console", O_RDWR, 0);
 
 	if (IS_ERR(file)) {
-		pr_err("Warning: unable to open an initial console.\n");
+		pr_err("Warning: unable to open an initial console. "
+		       "You likely supplied your own internal initramfs, "
+		       "make sure /dev/console is there.\n");
 		return;
 	}
 	init_dup(file);

base-commit: bfe62a454542cfad3379f6ef5680b125f41e20f4 (mainline)
-- 
2.47.3

