Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A7B04352017;
	Sat, 12 Sep 2026 15:29:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789226997; cv=none; b=kqD53EY1eDxjzw1sur6vknGlQwqNwy+w8fPf2m+2WOYLmeTOPxKAx64dQl7mQEFESnShCW852OiA9Kqqa4y9rEscts2O0MTUhKWC+LbUHGGutruuQr2WGrY88MQ8ZkblwS7ykN+Fw30j0e1DW0ZB6OJZ3cLbMVyXETT4spryxqw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789226997; c=relaxed/simple;
	bh=fqwPw8RQUs7udZN/ddIhHXX4RnwBibs+bNyLck377l0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EMIMclXUMy59rtu4Ho5VQN/BSPP/D7cD/Z+DfsxzHaw4WKnGFYoQWcSgzYUonrlA/lfp7lNdYMORofTjqX0xNq5L5WtHnwkZ3ltRXfVoilDk6ywGjq69RiMwndi/bL8dNvhhjAP0dY0Rhqem5YEr0QxJ0sFKWJOoopFY5QfI5eY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BbzqCie5; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BbzqCie5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3D3531F000FF;
	Sat, 12 Sep 2026 15:29:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789226988;
	bh=y1y5yNEz49PgE7FinD5jxogWjEUSBJ1fwQL4jLC7Wfk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=BbzqCie5bXyjkKJBc/3AqxGguSdl3ZKrw2b2u9WpFrZ9/rpOTM6z/zXMtb47wRB96
	 I5Cj9GqInblRFPHxV4Njar4o5BjF+Gj7JhRZREJKy5RfzLJxPww4JQ8S9jt1+Au35D
	 dYaw2QwXaDdiaJec2Zp+AhCTk0NzKu0VdXeGEtxk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	kernel test robot <lkp@intel.com>,
	Florian Fuchs <fuchsfl@gmail.com>,
	Helge Deller <deller@gmx.de>
Subject: [PATCH 6.1 0088/1191] fbdev: pvr2fb: correct user pointer annotation and sentinel initializer
Date: Sat, 12 Sep 2026 08:46:56 +0200
Message-ID: <20260912065550.155956007@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065548.086904252@linuxfoundation.org>
References: <20260912065548.086904252@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1073,7 +1073,7 @@ static struct pvr2_board {
 #ifdef CONFIG_PCI
 	{ pvr2fb_pci_init, pvr2fb_pci_exit, "PCI PVR2" },
 #endif
-	{ 0, },
+	{ },
 };
 
 static int __init pvr2fb_init(void)


