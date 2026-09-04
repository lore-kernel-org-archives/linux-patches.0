Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 140463F4101;
	Fri,  4 Sep 2026 06:10:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788502258; cv=none; b=DpHEbkooPt3JYKgbPtF4MUf58doHVds6/Js4CgRbPLUXD0Q9QvSgLI7ktAtU3RdXxaRxrd69fvtwRLXn6unorbtV/xrR/Se5MclZdD9RJwsobS/SvExwQmnvTA/V0++j3dQBs3CgjRZJXat8rN3UHek76ZaHoUA4tio4HTXtNt4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788502258; c=relaxed/simple;
	bh=/uWHh97aj7Ac0GrjRGCQcVv3v7y74IXSRnPz0EtRytU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=i3H817ZXCQH9nm7ZsTq+nQrDmg1W3ZRX6SN6q6VkcAq4+TefvcJeot0ug1cfpRNWvjB61hr/tgh+Yye8SSE74Cr39jj4GOGnUrZNeRQpR8hdht8u48oJgn/PoKZD0SanbDHeatUdq+vZwlcpMg9vfaUw59ohvbvHStmovUrtV3g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2EbMP+tH; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2EbMP+tH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 62BB91F00A3D;
	Fri,  4 Sep 2026 06:10:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788502256;
	bh=haSUoladwuaWVkFzt9/hrnL4tMYw4FMO7Zk97QBmsAk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=2EbMP+tH9U6UG3iV2qUBAgG1qnSxGbl9c3jJAQzoEdG2gVbnW3aM2jTFjuPx5vBzr
	 qkaMkWtvyb5ZNqM3c0eTW+y6J+et21usEhVXWmL7ZjA2BwZTMSFcKpeTk5P4vgPaEa
	 15aRpJPY7AS+caqRkod4dR6Xr/dZHAVJLZM/nSf8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	kernel test robot <lkp@intel.com>,
	Florian Fuchs <fuchsfl@gmail.com>,
	Helge Deller <deller@gmx.de>
Subject: [PATCH 6.12 145/403] fbdev: pvr2fb: correct user pointer annotation and sentinel initializer
Date: Fri,  4 Sep 2026 06:59:08 +0200
Message-ID: <20260904045738.144703907@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260904045734.806166532@linuxfoundation.org>
References: <20260904045734.806166532@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Florian Fuchs <fuchsfl@gmail.com>

commit 5dc2e70dd74b1f03e2e13bfb6922111d9e0adf90 upstream.

Add __user annotation to buf, as it is passed as a user pointer in
pin_user_pages_fast(). Use an empty initializer for the sentinel
board-table entry to avoid initializing a function pointer with an
integer literal.

Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/oe-kbuild-all/202607131247.fpQ6eTc7-lkp@intel.com/
Cc: stable@vger.kernel.org
Signed-off-by: Florian Fuchs <fuchsfl@gmail.com>
Signed-off-by: Helge Deller <deller@gmx.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/video/fbdev/pvr2fb.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/video/fbdev/pvr2fb.c
+++ b/drivers/video/fbdev/pvr2fb.c
@@ -639,7 +639,7 @@ static irqreturn_t __maybe_unused pvr2fb
 }
 
 #ifdef CONFIG_PVR2_DMA
-static ssize_t pvr2fb_write(struct fb_info *info, const char *buf,
+static ssize_t pvr2fb_write(struct fb_info *info, const char __user *buf,
 			    size_t count, loff_t *ppos)
 {
 	unsigned long dst, start, end, len;
@@ -1078,7 +1078,7 @@ static struct pvr2_board {
 #ifdef CONFIG_PCI
 	{ pvr2fb_pci_init, pvr2fb_pci_exit, "PCI PVR2" },
 #endif
-	{ 0, },
+	{ },
 };
 
 static int __init pvr2fb_init(void)


