Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0DD4035B632;
	Fri,  4 Sep 2026 05:47:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788500860; cv=none; b=FuN90UtIdqeG4cyiyutRJTfSRYXZaW3bS8ObDHryPdqw8wS1QtDFyOXs4M7MwRP4+niEhPSkDdYu4a56AookxnR+eUT1K2I1Liymr74mArh/QJWKZsRep00EQRrP2k2Rr41MR7uzvLfV7e+A9tZIFfu2Flm/xDih9qBnsSF2sIw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788500860; c=relaxed/simple;
	bh=y5aNH1NI0HNDIywb2+6NsXqQd2X1AtuoJSXIFGDKSYA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IfAlwyk7hbOO2kjiMEsuNE2LHEH5Bjlwkc8AqJAmHpksMPZeSdvrj8Q00Sc109myPII2PvmsZ9co5yghLX0jAO6mvcMcRvwrLxXh/CN+qxxVoV8KUyu+MQVKoGnWj09xXSqSXpDV9SnCOGSJ1qPB2ONvJ9gf12i5UPqQ5NeXf1Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UP7IXTcf; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UP7IXTcf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 680081F00A3D;
	Fri,  4 Sep 2026 05:47:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788500858;
	bh=0KbBnt9P1XPpXCIekbH34dTFHW2vFyMc4hfDXfUjA90=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=UP7IXTcfswOeR4L+HqsCNJLRjEPuyen1lYXmDV6ZEbLUot8WR4l6MxEUV3OhHdRwI
	 55Sj03fd0/d/gtZQ/S37N5rckYsSklFIuRISNvLepm1OUIQJuQDA0R8k0m6kmOLZeZ
	 wmavmoR9tKvWn0e0rCE4ieZSwngVVEiAFQNAgEnU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	kernel test robot <lkp@intel.com>,
	Florian Fuchs <fuchsfl@gmail.com>,
	Helge Deller <deller@gmx.de>
Subject: [PATCH 6.18 203/552] fbdev: pvr2fb: correct user pointer annotation and sentinel initializer
Date: Fri,  4 Sep 2026 06:56:00 +0200
Message-ID: <20260904045753.827306808@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260904045747.813364717@linuxfoundation.org>
References: <20260904045747.813364717@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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


