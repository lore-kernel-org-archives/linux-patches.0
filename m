Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F26E22B8AB;
	Thu,  3 Jul 2025 15:22:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751556161; cv=none; b=Elc4XQOMTMh/GfjYKPQ4Pi02mUroHBVmWAS5g90MDcR4Mue2BwSMH1GBA5237KDdh6BI3k0F+JLzyL5wMCdAB93EmufzacuBN4U3ZgFJtjunZGvb5sLlq/4JRSzlKrZ8Wy4gh23QZxc5uencMEK5Tu6OpzWA9ANBRG2zOuS9U/M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751556161; c=relaxed/simple;
	bh=cK7JSSFkhgi9iigpTKVr/Ejq5glbrnlzWQz9Yf1SmDg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XR6Yf4OPo8aDVgFFxEXGlbAq5rXZjsOvPKUdExFR4G+U4huyIQAAUIigBVuCLLBj+okeOyDRNnpOcTH6Bt+GifLL/Yd/UG4TvB9RTFWaWb1EsoOqtFzurqLNOJ6/hGzCfrSayD3abHRPFUDLnc6vTMAe7lnkrWuCvIde21qe7CA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Hd7JibnY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Hd7JibnY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 98C3CC4CEE3;
	Thu,  3 Jul 2025 15:22:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1751556161;
	bh=cK7JSSFkhgi9iigpTKVr/Ejq5glbrnlzWQz9Yf1SmDg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Hd7JibnY2CpxEEzSUzTvXJBQXCRdmrxt8adMQdUGb5KsX6NBhSPNdkZ+aSWgM+JER
	 JX2B9YuUwmrnLyYWXJhbRAIOZcJCFogh/fJMh7ms+Eb5VDMaqkMlx/ENcZE9QYPGor
	 NmQRF0PPEL9qXHs7NHWPJxP4PGsxCo4mLozmAOrI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Jiri Slaby (SUSE)" <jirislaby@kernel.org>,
	Helge Deller <deller@gmx.de>,
	linux-fbdev@vger.kernel.org,
	dri-devel@lists.freedesktop.org,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 064/132] vgacon: remove unneeded forward declarations
Date: Thu,  3 Jul 2025 16:42:33 +0200
Message-ID: <20250703143941.926661906@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250703143939.370927276@linuxfoundation.org>
References: <20250703143939.370927276@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Jiri Slaby (SUSE) <jirislaby@kernel.org>

[ Upstream commit 6ceed69cde8fe4a78fe50d62d7a88a5c1eed4709 ]

Most of the forward declarations in vgacon are not needed. Drop them.

Signed-off-by: "Jiri Slaby (SUSE)" <jirislaby@kernel.org>
Cc: Helge Deller <deller@gmx.de>
Cc: linux-fbdev@vger.kernel.org
Cc: dri-devel@lists.freedesktop.org
Signed-off-by: Helge Deller <deller@gmx.de>
Stable-dep-of: 03bcbbb3995b ("dummycon: Trigger redraw when switching consoles with deferred takeover")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/video/console/vgacon.c | 10 +---------
 1 file changed, 1 insertion(+), 9 deletions(-)

diff --git a/drivers/video/console/vgacon.c b/drivers/video/console/vgacon.c
index 065da55f20d89..e0d340f5c2dd5 100644
--- a/drivers/video/console/vgacon.c
+++ b/drivers/video/console/vgacon.c
@@ -65,16 +65,8 @@ static struct vgastate vgastate;
  *  Interface used by the world
  */
 
-static const char *vgacon_startup(void);
-static void vgacon_init(struct vc_data *c, int init);
-static void vgacon_deinit(struct vc_data *c);
-static void vgacon_cursor(struct vc_data *c, int mode);
-static int vgacon_switch(struct vc_data *c);
-static int vgacon_blank(struct vc_data *c, int blank, int mode_switch);
-static void vgacon_scrolldelta(struct vc_data *c, int lines);
 static int vgacon_set_origin(struct vc_data *c);
-static void vgacon_save_screen(struct vc_data *c);
-static void vgacon_invert_region(struct vc_data *c, u16 * p, int count);
+
 static struct uni_pagedict *vgacon_uni_pagedir;
 static int vgacon_refcount;
 
-- 
2.39.5



