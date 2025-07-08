Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2AE9D2E091E;
	Tue,  8 Jul 2025 16:58:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751993881; cv=none; b=N9osA1VJAG0TBmU3WUgGdp3XEucQ00f6p4BHJNeV0TSyzLlu0y3OPdRU4pvxBJh0hKXylLprVRfWcsiG587LZ/ooF46XYUMIen749rcz2tozuatUQY/x+18+0tNgDiFe1yneuvtWEgvdt2dVIPzv2bUIVPH8KNk2/HJ98gYuUPs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751993881; c=relaxed/simple;
	bh=O8DY9iQvQuri9ETtgEtgVX+GYzEbahHXVwYWnNZ/LgM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JokDQhnw1LZAi0SuUWvk1UvxO+s+7tCR0sfrCKt135HzJfWBIgjRdr0Tdu0hwX4+8DDlHjdGW0sJRbHezVHcLTap9L6GjnHIK6B7FKaJSvtvzGH7lZDMbrOjr0wlYfvxNAiQg+P54NUet+JIoMLlB9FYXlhA3r9J/d0j3tdMjUg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SW75u4yX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SW75u4yX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A6F31C4CEED;
	Tue,  8 Jul 2025 16:58:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1751993881;
	bh=O8DY9iQvQuri9ETtgEtgVX+GYzEbahHXVwYWnNZ/LgM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SW75u4yXfuGz4+cKzD4PijbaRETyCpIe1r6IOu7CWsslFc/X+Nwy9StmXAKrWqape
	 V95zDxIHXdMWQo8ztGIGCHhFojeVA45f4OZKWX3HqIMbVvpSEqx969I7wZldSiS3/h
	 NkVKKdnZOcekPHfkEoD4KONyLt/tT7xjpqf2RPtM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Jiri Slaby (SUSE)" <jirislaby@kernel.org>,
	Helge Deller <deller@gmx.de>,
	linux-fbdev@vger.kernel.org,
	dri-devel@lists.freedesktop.org,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 051/160] vgacon: switch vgacon_scrolldelta() and vgacon_restore_screen()
Date: Tue,  8 Jul 2025 18:21:28 +0200
Message-ID: <20250708162232.956317981@linuxfoundation.org>
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
index 7bce5a174f388..b2180fd183307 100644
--- a/drivers/video/console/vgacon.c
+++ b/drivers/video/console/vgacon.c
@@ -163,12 +163,6 @@ static inline void vga_set_mem_top(struct vc_data *c)
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
@@ -176,6 +170,12 @@ static void vgacon_scrolldelta(struct vc_data *c, int lines)
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



