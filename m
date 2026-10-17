Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 22F023B8BBB;
	Sat, 17 Oct 2026 17:41:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792258882; cv=none; b=OPCRIHJEkmKD9qvq37kNgUKoCowUBh1PHo4EtGusK9VtuR+xIvfe8uA4O3u2YFmjBQZI6E/aIBz8ffFzLwA5TENaDvwzIF9DqXUx2atGe4LhHqEQXL0zpLh7EwwJ7Wt5WjHys2Ngf6AAu0WdgRbYz2mZFG8i7ooNp1u7ElrbQ+Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792258882; c=relaxed/simple;
	bh=TnbK82kOg4kixdO1LYFWBmWxMK+ZogP5hDEcOuOdKXY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lIh5ZszhLoMH1MQfQo5t0w2sJc8sFtCTOZ+Mloj1nR/bRpa+n3vFIXwMPlCF0/cmDBnj57HwPIQfX7mR6KcggM9hFofGiDN3MVbrMkP3KAkAa7NgOCsEQhS1s/KEmmBkdEXuI7sOPNag6FsLkhhQ8FGttjX5EdhAGCcxOtBJOQo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=apjJXE4h; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="apjJXE4h"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7BB881F000C4;
	Sat, 17 Oct 2026 17:41:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792258881;
	bh=dBu4SPyo45iuTgyTk7P7dwGuOuCDH3mY/n3Sbax5kbo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=apjJXE4hJEc1T8w9FmIUIXccrE32ukZsMaqU0u4URdAY6Q49DZ70eYLVPebFhlU3h
	 2vnu0zePhbXILuL8jPYsEu4tJj+09fJsursuP5AFMVtB/CokEK0wOjm35+31wvj4xS
	 emPGFNnoyC2fqLXLs+qHTx1/qcpZzKdWot4kEFX0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	kernel test robot <lkp@intel.com>,
	Hongling Zeng <zenghongling@kylinos.cn>,
	Helge Deller <deller@gmx.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1031/1674] fbdev: omap2: fix inconsistent lock returns in omapfb_mmap
Date: Sat, 17 Oct 2026 17:55:03 +0200
Message-ID: <20261017160457.595383423@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160431.119607952@linuxfoundation.org>
References: <20261017160431.119607952@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hongling Zeng <zenghongling@kylinos.cn>

[ Upstream commit 98cf7df6e0844f7076df1db690c1ede9d69b61ff ]

Fix the warning about inconsistent returns for '&rg->lock' in
omapfb_mmap() function. The warning arises because the error path
uses 'ofbi->region' while the normal path uses 'rg'.

smatch warnings:
drivers/video/fbdev/omap2/omapfb/omapfb-main.c:1126 omapfb_mmap()
warn: inconsistent returns '&rg->lock'.

Reported-by: kernel test robot <lkp@intel.com>
Signed-off-by: Hongling Zeng <zenghongling@kylinos.cn>
Signed-off-by: Helge Deller <deller@gmx.de>
Stable-dep-of: 7958e67375aa ("fbdev: omap2: fix use-after-free in omapfb_mmap")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/video/fbdev/omap2/omapfb/omapfb-main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/video/fbdev/omap2/omapfb/omapfb-main.c b/drivers/video/fbdev/omap2/omapfb/omapfb-main.c
index b5acad8eb2796..23e7566bb49e3 100644
--- a/drivers/video/fbdev/omap2/omapfb/omapfb-main.c
+++ b/drivers/video/fbdev/omap2/omapfb/omapfb-main.c
@@ -1119,7 +1119,7 @@ static int omapfb_mmap(struct fb_info *fbi, struct vm_area_struct *vma)
 	return 0;
 
 error:
-	omapfb_put_mem_region(ofbi->region);
+	omapfb_put_mem_region(rg);
 
 	return r;
 }
-- 
2.53.0



