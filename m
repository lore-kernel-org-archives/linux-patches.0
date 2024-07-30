Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 734E41078F;
	Tue, 30 Jul 2024 16:51:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722358287; cv=none; b=YPiMzb96PLn1DSwiDaXSf1z4vGJRIUloGHQQo4/is2xxLjlqFQFh4577W8CiUJ5LOZz/4WyI8821KHCuLOmxrWxKpboEx05YiOpQ9bcQOEVUbrzKJmhatEg9hLJxnL5muYMQQ7WMgDupoSYsTbCHKqyxlQ2/gic7CwAAP2Dg6+Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722358287; c=relaxed/simple;
	bh=B2mFk8mg8TpZXtlzjDoI2RB6h/PDYxkpXZXLhp9Gxf0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KYMa5qe236rC+R9RtOuZeSt8nsW6E+jkhCd865dMfEHnnRdzqwG4c464+GDkv6Guj9k8IOIzu4FavFl56ghHBTn8VMeH/vCbDcuJskf7HThh5Iunk2fAnIDGz7c733zHj+jF07QKwNfGUqu1lX6uV267z9fX84gh/lEP2uadSsI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=b+1hRx06; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="b+1hRx06"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CFE2CC4AF0E;
	Tue, 30 Jul 2024 16:51:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722358287;
	bh=B2mFk8mg8TpZXtlzjDoI2RB6h/PDYxkpXZXLhp9Gxf0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=b+1hRx06Vx3iPhFosZDuN5Ykv5jU65K8KS15RG0wge8knmRPvaJpq0D1eSN2qS+nH
	 wvbE0VP5bGnsgen6bwc8baeZO1QC8DGG7PvxUHfU9nulHsl8uuUok6Fbf2ymcVtTEj
	 JIjbfqvb9FqAxgUqbmFN+/0mHA84WWEkf/AzpFlA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Geert Uytterhoeven <geert+renesas@glider.be>,
	Jocelyn Falempe <jfalempe@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 342/809] drm/panic: Fix off-by-one logo size checks
Date: Tue, 30 Jul 2024 17:43:38 +0200
Message-ID: <20240730151738.143056712@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151724.637682316@linuxfoundation.org>
References: <20240730151724.637682316@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Geert Uytterhoeven <geert+renesas@glider.be>

[ Upstream commit 94ff11d3bd32506710ca43569d38420e7fc790c1 ]

Logos that are either just as wide or just as high as the display work
fine.

Fixes: bf9fb17c6672868d ("drm/panic: Add a drm panic handler")
Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
Reviewed-by: Jocelyn Falempe <jfalempe@redhat.com>
Signed-off-by: Jocelyn Falempe <jfalempe@redhat.com>
Link: https://patchwork.freedesktop.org/patch/msgid/1c9d02463cef3eac22cfac3ac6d1adad369f367b.1718305355.git.geert+renesas@glider.be
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/drm_panic.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/drm_panic.c b/drivers/gpu/drm/drm_panic.c
index 056494ae1edef..e1c4796685692 100644
--- a/drivers/gpu/drm/drm_panic.c
+++ b/drivers/gpu/drm/drm_panic.c
@@ -439,7 +439,7 @@ static void draw_panic_static(struct drm_scanout_buffer *sb)
 		       bg_color, sb->format->cpp[0]);
 
 	if ((r_msg.x1 >= drm_rect_width(&r_logo) || r_msg.y1 >= drm_rect_height(&r_logo)) &&
-	    drm_rect_width(&r_logo) < sb->width && drm_rect_height(&r_logo) < sb->height) {
+	    drm_rect_width(&r_logo) <= sb->width && drm_rect_height(&r_logo) <= sb->height) {
 		draw_txt_rectangle(sb, font, logo, logo_lines, false, &r_logo, fg_color);
 	}
 	draw_txt_rectangle(sb, font, panic_msg, msg_lines, true, &r_msg, fg_color);
-- 
2.43.0



