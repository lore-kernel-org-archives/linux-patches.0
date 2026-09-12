Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 42E7B325726;
	Sat, 12 Sep 2026 17:06:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789232797; cv=none; b=ir+KhwEw7bhjPnUgvF4q7fNTJ1w7EuBduQGQGZ2FZj28h/Fdn3MvHafzMrPiI/EGWe7JM7l27EA+JGmv8DhDctbaO88chMevIGo1VQA97iH9Bb50FDVNyV68ANDLhtYvsGnCFxdSTsHeSBgqsGASuoeBrJHu3KyaydYycaiZZU0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789232797; c=relaxed/simple;
	bh=wdS1FLgRTRYDHKnqK0/NP+JeVmxJOiS4bPedkSiW8PA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LLnruM3LekhDOFhaAYbFCRqQawcyHFG2C0NHpAZQ8hZA35ezPjhjAOGyNDEdA8/BNnlcA81K6rhEYK+fe4Z00MDhCxZTbaAGrliMdlvVaqLswdh5T+sNzsk+Lz9FEvvd1uR3ysNKxmpM8Xaa0M4noa313CAvmtf/36uWnH4Or2g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Kc5Cl+Af; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Kc5Cl+Af"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 050EA1F00893;
	Sat, 12 Sep 2026 17:06:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789232796;
	bh=TlFvP31uwhl2a+Sp78H0/1mRZaP1glUCwLB1/zfBJqI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Kc5Cl+AftV1VqiYU/Ija6hYj8JKoYG7BRr1+pH/RgUhme1J2zEIot93uUuHqsTO7w
	 tuk13wrkkrWDPBpzIX3qxozyPglAjUosn378PQloPz2KK00DMR/nH0MKup/nRgfhcy
	 nle2ATf1u7qwGi9q7NWHBrljosvyyLjLceq0FOD0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	kernel test robot <lkp@intel.com>,
	Florian Fuchs <fuchsfl@gmail.com>,
	Helge Deller <deller@gmx.de>
Subject: [PATCH 5.15 076/935] fbdev: pvr2fb: correct user pointer annotation and sentinel initializer
Date: Sat, 12 Sep 2026 08:51:46 +0200
Message-ID: <20260912065528.575696267@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065526.833703348@linuxfoundation.org>
References: <20260912065526.833703348@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
@@ -638,7 +638,7 @@ static irqreturn_t __maybe_unused pvr2fb
 }
 
 #ifdef CONFIG_PVR2_DMA
-static ssize_t pvr2fb_write(struct fb_info *info, const char *buf,
+static ssize_t pvr2fb_write(struct fb_info *info, const char __user *buf,
 			    size_t count, loff_t *ppos)
 {
 	unsigned long dst, start, end, len;
@@ -1068,7 +1068,7 @@ static struct pvr2_board {
 #ifdef CONFIG_PCI
 	{ pvr2fb_pci_init, pvr2fb_pci_exit, "PCI PVR2" },
 #endif
-	{ 0, },
+	{ },
 };
 
 static int __init pvr2fb_init(void)


