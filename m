Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 76A7B33F59A;
	Sat, 12 Sep 2026 13:34:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789220085; cv=none; b=mDyzVC5Ltbe0KOkxpdi0KeVD8LEuybxPPfwhW+ctTy+m3EY5/wA4JBccHNlJvg4dKQ1EzOhJLuy6txak0nmR2ZMOKd0SJO8GRanNNuQyZi9jSdh5pybapON1M1dTuZ9oHfbAZ82pMdoUaRTp7pDAnUwf5ouxE/g7KviUNlz3l5g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789220085; c=relaxed/simple;
	bh=Ox78sxlvSNlBzSt7b1yHGxp/qkLh91/yObVE6FMABiY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nKK+WYuHOL6wpH4NTCgzK3myz9drl0RMPTL+vkSR0H9Dv2urVZ54wkuA3nYvbCy/t/PHnMELL9tqbpQ2Pw3PrZQLbjtEVNd6shGqIau5u7Ti20ZaRvWoCPrxozJQk6LbDw/C9eSLWuTN4GBVntGOEpcQv02rhd9guvuW0t9rSW4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tp4OL21F; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tp4OL21F"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 325CA1F000FF;
	Sat, 12 Sep 2026 13:34:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789220084;
	bh=ZPtPtnRnpnDp9wVZqdYDGJKGBwGBHmOsQMGrAVTnq7M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=tp4OL21FABBazlUrnbfzDaYK8u6MfUiIvrRvRP3qbfugxB3j9Zz2WhcUnVqP6ndkX
	 FQFDTQJMKKfMLnodfnNvnXzqZixOPaGv0jOHEtAqFFegB41wt8Tbeqaz8XsTxNxJkc
	 gP8PVomm1cgSuRSgNfBet0eV7Ax043Rm91joRYIk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	kernel test robot <lkp@intel.com>,
	Florian Fuchs <fuchsfl@gmail.com>,
	Helge Deller <deller@gmx.de>
Subject: [PATCH 6.6 0104/1424] fbdev: pvr2fb: correct user pointer annotation and sentinel initializer
Date: Sat, 12 Sep 2026 08:42:16 +0200
Message-ID: <20260912065609.637010786@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.279695368@linuxfoundation.org>
References: <20260912065607.279695368@linuxfoundation.org>
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
@@ -1076,7 +1076,7 @@ static struct pvr2_board {
 #ifdef CONFIG_PCI
 	{ pvr2fb_pci_init, pvr2fb_pci_exit, "PCI PVR2" },
 #endif
-	{ 0, },
+	{ },
 };
 
 static int __init pvr2fb_init(void)


