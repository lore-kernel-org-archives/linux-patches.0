Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1264C2E091E;
	Tue,  8 Jul 2025 16:58:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751993884; cv=none; b=PSQts65YN4/PZFCCBsB7i1sRTD+muP71zlwhv29ZZOWl4QpgoqkgmIJd6XgrHrurtvFEc6hGFeiuS3xclvgSclIHlzMfgsHQ/y2PzS9ddD0PuPS35BN8RkwDCkeXm+rux2EVotToDqoeD2FI4SIyaBdjZX3TXWNzf08Lv0mTRHA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751993884; c=relaxed/simple;
	bh=kx6FJAjprvejNhhebn86h4bHayhejk5tCWnHq6kGeac=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KCSfxWmzeCUkByXYGGcpC2eG60jYXZi37cZMDybnnKoYdD3wAFSVfL4dkPMh+suD4A36h97vYuZHJTEa88k8D6BEIO1vZNMDtQgw1AZks+PkBMF0N8zZ9JiPDYPRaDQxA0cD2ZbjXs//OCH4QcN7c4S7c9dgaMFKPIZOfPAYJzk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NOdoU2pl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NOdoU2pl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8DF39C4CEED;
	Tue,  8 Jul 2025 16:58:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1751993883;
	bh=kx6FJAjprvejNhhebn86h4bHayhejk5tCWnHq6kGeac=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NOdoU2plpmjsRINrVazpm5NOmI0fyuC6YRtPVvC8DcqNfWw0ErmofvKHXimaWj0iK
	 mveOWAQMxsc2Sgix9v2/ZfaqTjWADkPXb+5dVwB2PeIvGcLp5q3xJZlFNwGZN0seLT
	 O7vHSfKAh34asKkBI5qF66qxelRmlydbLqproYI0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Jiri Slaby (SUSE)" <jirislaby@kernel.org>,
	Helge Deller <deller@gmx.de>,
	linux-fbdev@vger.kernel.org,
	dri-devel@lists.freedesktop.org,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 052/160] vgacon: remove unneeded forward declarations
Date: Tue,  8 Jul 2025 18:21:29 +0200
Message-ID: <20250708162232.984234899@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250708162231.503362020@linuxfoundation.org>
References: <20250708162231.503362020@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index b2180fd183307..9bfe451050209 100644
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



