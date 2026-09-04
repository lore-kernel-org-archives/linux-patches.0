Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1EBA634A77D;
	Fri,  4 Sep 2026 05:17:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788499062; cv=none; b=uZ720RUd2xEyKi3SFTj8bEVouN7Xa9q5gVvbT2KfGSoUPggOwsX+qDw9nnFSILqo8vYlztSQymcm4IxDYlX3xD256pNmGFinklDpyK3EMCHdKCdRBucZM8e4zGNxBv+eLlrtRkwkL0wA49LkZzs9dQBoRb2iudvNLyKSvti+Hi0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788499062; c=relaxed/simple;
	bh=WEpt6MCEyrPBThp43vtrekww+Vy1EeAdagajUUP/bhg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EKWiNuKlCIKfq/GYEX1qFsYGrGL5RLPHu56LhoxmTICTsxXIFYsjo6Q6c4pOgyNMOf44lcaA/14uYv6mT5Qtcyd8OmGEL6Aq54lwlJKocLYdQqLKrxcwBI+DoR8EY3Q+eJOUJCuCe/o61zpd+V8fp5voyIkbga5qCtt31rCAZ70=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MAnOMS2o; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MAnOMS2o"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4FED81F00A3D;
	Fri,  4 Sep 2026 05:17:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788499060;
	bh=uKUslXZ0AZqBWALwfGQpjVEgPn5jIkwUelPDVMGEKJ0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=MAnOMS2o9KQ92CYYeGbQ6I9WhFJivPD5wv7/BwBpavCOG5BS7O2+w1NKHbN0yv8UM
	 xsNMJWEYNmn/KkFjyBK+QqgmbI1eAjKd4uSLf1ilnMPr88PErZXMTwPYp/a318c/A3
	 BeFCyPJJWGVYwLk276uZXW3+lQvoI06pLtZW8gtk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	kernel test robot <lkp@intel.com>,
	Florian Fuchs <fuchsfl@gmail.com>,
	Helge Deller <deller@gmx.de>
Subject: [PATCH 7.2 284/713] fbdev: pvr2fb: correct user pointer annotation and sentinel initializer
Date: Fri,  4 Sep 2026 06:54:12 +0200
Message-ID: <20260904045810.204615756@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260904045803.810145556@linuxfoundation.org>
References: <20260904045803.810145556@linuxfoundation.org>
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
@@ -1077,7 +1077,7 @@ static struct pvr2_board {
 #ifdef CONFIG_PCI
 	{ pvr2fb_pci_init, pvr2fb_pci_exit, "PCI PVR2" },
 #endif
-	{ 0, },
+	{ },
 };
 
 static int __init pvr2fb_init(void)


