Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 81866267F6E;
	Tue,  8 Apr 2025 11:00:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744110023; cv=none; b=uA2jeR/3RQ1ouTrrCX3JNamgwPj0guNAMOBDifUEmzA441JSW+9yWcESx9lHJy91QO4Abg6goVGXyC6zqXZGTTIW7EeMoUVwnQXqFm2i61MJxSkwEFVuvcf+pL9rda6Zpw6NErBNaHCwAdNIh+VKvs+GFhoyOrUc2oV6Trw3ASo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744110023; c=relaxed/simple;
	bh=LkQoU/Up0aYTclKLFkVSQsqTVx3sELIzWbqG1NYD1a0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=LOY8QmwLwu1inDBEWnKBg0mZZXzxNA4f59hUtKSixSTzQy+U3uGFBWfMZ1DObD7s/n5Ks2lbxibTtwtVEZFpeGQhEV59778MUEJ34m/ZoPgxt00tatNKt+V4IZEcV1OoA8/SuaFAGEr7hHQNOf5xdJYPkeZsU1y/zB9aJp4k6wc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LCBQW8E8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LCBQW8E8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E17DEC4CEE5;
	Tue,  8 Apr 2025 11:00:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744110023;
	bh=LkQoU/Up0aYTclKLFkVSQsqTVx3sELIzWbqG1NYD1a0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LCBQW8E8jfa+VXJE7AOJz76K9maUtNRhMrxBy/1ivbSqqE3k0uhnwgB+irkupw37I
	 OY4CS3JLbItmBxq6IQqTl96DYXOEWTFRP9iMrLZXMvRBjtM+XySsOwRbJ3BP2TTyGB
	 HIZJrp1CoN/AzCLVzimSQkjgSRcAeW1R3If60GkM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Markus Elfring <elfring@users.sourceforge.net>,
	=?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= <u.kleine-koenig@baylibre.com>,
	Helge Deller <deller@gmx.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 141/227] fbdev: au1100fb: Move a variable assignment behind a null pointer check
Date: Tue,  8 Apr 2025 12:48:39 +0200
Message-ID: <20250408104824.534540565@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104820.353768086@linuxfoundation.org>
References: <20250408104820.353768086@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Markus Elfring <elfring@users.sourceforge.net>

[ Upstream commit 2df2c0caaecfd869b49e14f2b8df822397c5dd7f ]

The address of a data structure member was determined before
a corresponding null pointer check in the implementation of
the function “au1100fb_setmode”.

This issue was detected by using the Coccinelle software.

Fixes: 3b495f2bb749 ("Au1100 FB driver uplift for 2.6.")
Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
Acked-by: Uwe Kleine-König <u.kleine-koenig@baylibre.com>
Signed-off-by: Helge Deller <deller@gmx.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/video/fbdev/au1100fb.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/video/fbdev/au1100fb.c b/drivers/video/fbdev/au1100fb.c
index 37a6512feda0f..abb769824840e 100644
--- a/drivers/video/fbdev/au1100fb.c
+++ b/drivers/video/fbdev/au1100fb.c
@@ -137,13 +137,15 @@ static int au1100fb_fb_blank(int blank_mode, struct fb_info *fbi)
 	 */
 int au1100fb_setmode(struct au1100fb_device *fbdev)
 {
-	struct fb_info *info = &fbdev->info;
+	struct fb_info *info;
 	u32 words;
 	int index;
 
 	if (!fbdev)
 		return -EINVAL;
 
+	info = &fbdev->info;
+
 	/* Update var-dependent FB info */
 	if (panel_is_active(fbdev->panel) || panel_is_color(fbdev->panel)) {
 		if (info->var.bits_per_pixel <= 8) {
-- 
2.39.5



