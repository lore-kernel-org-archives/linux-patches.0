Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A4FB226CF1;
	Thu,  3 Jul 2025 15:22:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751556159; cv=none; b=gxZn1haqEuG9lXpdVbQrG3E3F+7gNJUMioqn/cmKdyO8xOMmaP1XRnv1Nw7RGlpz5AyxHkRp3Z5qj2oU2hkLcCyXpEiy/MhVAVRj5dS+nJJCyPuI29jw37LHen5Fq22Ohll88G0y6L7ZZ3c7G6xfXxKoyAJPGo+bm/TiRrEUM+4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751556159; c=relaxed/simple;
	bh=V+pH3XO9nKwiO/o2VhZUCqJmxYoigW77zAeSAZhnX7M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VzQvDQcgBDOMy9iNABTcYuGfPwmvjnUWW1nH/zD8PfJCMoPW/mhLNBTqbWJjqzO4vfEQ4VlFv9LXYlr8LEy+oFti4ss34vIOl69nKTYuRrhXaVU01BkLNgGPfyGUhCP/wGoyH3MKUhbAKpb1qENZkePi4Zg7EEJ1GAt8oURcrWo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SW88V0n0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SW88V0n0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6CFEEC4CEE3;
	Thu,  3 Jul 2025 15:22:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1751556157;
	bh=V+pH3XO9nKwiO/o2VhZUCqJmxYoigW77zAeSAZhnX7M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SW88V0n0ECjB7nxaKHeQfaEcxxbOPtYQrL6WaByoRvPRnJvxr+osFu7o5d9oHKqlS
	 llajgoUEsFVLHG1ZAFTrmsHb8UGVN8HszwYkn49+ExyilzyKpuLKTI+ij8/IQtb8BG
	 li8ljfnY9s/hIBzH3gTL9XNb9b8dPnK6u4Kwa9NI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Jiri Slaby (SUSE)" <jirislaby@kernel.org>,
	Helge Deller <deller@gmx.de>,
	linux-fbdev@vger.kernel.org,
	dri-devel@lists.freedesktop.org,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 063/132] vgacon: switch vgacon_scrolldelta() and vgacon_restore_screen()
Date: Thu,  3 Jul 2025 16:42:32 +0200
Message-ID: <20250703143941.888335092@linuxfoundation.org>
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

[ Upstream commit 03b89a08484a88fb9e0604cab2b3eb0c2f265c74 ]

Switch vgacon_scrolldelta() and vgacon_restore_screen() positions, so
that the former is not needed to be forward-declared.

Signed-off-by: "Jiri Slaby (SUSE)" <jirislaby@kernel.org>
Cc: Helge Deller <deller@gmx.de>
Cc: linux-fbdev@vger.kernel.org
Cc: dri-devel@lists.freedesktop.org
Signed-off-by: Helge Deller <deller@gmx.de>
Stable-dep-of: 03bcbbb3995b ("dummycon: Trigger redraw when switching consoles with deferred takeover")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/video/console/vgacon.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/video/console/vgacon.c b/drivers/video/console/vgacon.c
index e960b27caadab..065da55f20d89 100644
--- a/drivers/video/console/vgacon.c
+++ b/drivers/video/console/vgacon.c
@@ -142,12 +142,6 @@ static inline void vga_set_mem_top(struct vc_data *c)
 	write_vga(12, (c->vc_visible_origin - vga_vram_base) / 2);
 }
 
-static void vgacon_restore_screen(struct vc_data *c)
-{
-	if (c->vc_origin != c->vc_visible_origin)
-		vgacon_scrolldelta(c, 0);
-}
-
 static void vgacon_scrolldelta(struct vc_data *c, int lines)
 {
 	vc_scrolldelta_helper(c, lines, vga_rolled_over, (void *)vga_vram_base,
@@ -155,6 +149,12 @@ static void vgacon_scrolldelta(struct vc_data *c, int lines)
 	vga_set_mem_top(c);
 }
 
+static void vgacon_restore_screen(struct vc_data *c)
+{
+	if (c->vc_origin != c->vc_visible_origin)
+		vgacon_scrolldelta(c, 0);
+}
+
 static const char *vgacon_startup(void)
 {
 	const char *display_desc = NULL;
-- 
2.39.5



