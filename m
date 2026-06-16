Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E6D993BED69;
	Tue, 16 Jun 2026 15:08:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781622504; cv=none; b=DpHik1qQtBt3r0IfWJaKHWVW3eXLZZdYRPy1sWxfFNwOYrcT8klQPBYW4AQ/UL8xCQcs+YYabRipfTqfKMsaOsnTpoEG7dabTuHJuYp+xxEqqAs95PNIAgz2pZanwrqqsiP0BMmc4K1VEsxOWBpcFjGBiE7d4lSG4xSinT+jqdU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781622504; c=relaxed/simple;
	bh=XVOpqMdofMUZGvi3EQ54ZWw7vNxR3uwz5Bv4b72Dq00=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=h4+YV+ZRlw0pJ9oYF2kBUzt3mtNtjPKlNS/A54FKqS04HHjd/WFAmu/QihODOyHVZN8awakdDFVfC7MN3gAQQ2m5yLyVGdUIJ9ryR+KKZ51GAvg1yyBAeHwzm9CFw8ZdulqmOH7uSjXjN6XLH5zuFZ1DRUYKKZ0BVVJyKCjzykM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xGU1iTYL; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xGU1iTYL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A8E8D1F000E9;
	Tue, 16 Jun 2026 15:08:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781622502;
	bh=nn29J02JMhHcWCnmIcbzi2kips3nEN/O/Uqinylr/iI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=xGU1iTYLT21iT0Yr0I1nsA3g64rhlGP/Vfu2ortXL4T/UzP7VtmdawaJLF5gZKYnm
	 x/aO242qdN16NQly4mRPe1L9Zam8BYlkcpKIOpUxtAceCSUbTWIIsWy4QPTSCcMq4+
	 z1W5yksI1JpW7ksfqHHKZvVmHOmWTw+8jYSnMdM4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Carlos Eduardo Gallo Filho <gcarlos@disroot.org>,
	=?UTF-8?q?Andr=C3=A9=20Almeida?= <andrealmeid@igalia.com>,
	Thomas Zimmermann <tzimmermann@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 005/452] drm: Remove plane hsub/vsub alignment requirement for core helpers
Date: Tue, 16 Jun 2026 20:23:52 +0530
Message-ID: <20260616145118.075313328@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145117.796205997@linuxfoundation.org>
References: <20260616145117.796205997@linuxfoundation.org>
User-Agent: quilt/0.69
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Carlos Eduardo Gallo Filho <gcarlos@disroot.org>

[ Upstream commit f2f455981a34ce8ca88a41458c09494b387d344f ]

The drm_format_info_plane_{height,width} functions was implemented using
regular division for the plane size calculation, which cause issues [1][2]
when used on contexts where the dimensions are misaligned with relation
to the subsampling factors. So, replace the regular division by the
DIV_ROUND_UP macro.

This allows these functions to be used in more drivers, making further
work to bring more core presence on them possible.

[1] http://patchwork.freedesktop.org/patch/msgid/20170321181218.10042-3-ville.syrjala@linux.intel.com
[2] https://patchwork.freedesktop.org/patch/msgid/20211026225105.2783797-2-imre.deak@intel.com

Signed-off-by: Carlos Eduardo Gallo Filho <gcarlos@disroot.org>
Reviewed-by: André Almeida <andrealmeid@igalia.com>
Signed-off-by: Thomas Zimmermann <tzimmermann@suse.de>
Link: https://patchwork.freedesktop.org/patch/msgid/20230926141519.9315-2-gcarlos@disroot.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/drm/drm_fourcc.h | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/include/drm/drm_fourcc.h b/include/drm/drm_fourcc.h
index 532ae78ca747e6..ccf91daa430702 100644
--- a/include/drm/drm_fourcc.h
+++ b/include/drm/drm_fourcc.h
@@ -22,6 +22,7 @@
 #ifndef __DRM_FOURCC_H__
 #define __DRM_FOURCC_H__
 
+#include <linux/math.h>
 #include <linux/types.h>
 #include <uapi/drm/drm_fourcc.h>
 
@@ -279,7 +280,7 @@ int drm_format_info_plane_width(const struct drm_format_info *info, int width,
 	if (plane == 0)
 		return width;
 
-	return width / info->hsub;
+	return DIV_ROUND_UP(width, info->hsub);
 }
 
 /**
@@ -301,7 +302,7 @@ int drm_format_info_plane_height(const struct drm_format_info *info, int height,
 	if (plane == 0)
 		return height;
 
-	return height / info->vsub;
+	return DIV_ROUND_UP(height, info->vsub);
 }
 
 const struct drm_format_info *__drm_format_info(u32 format);
-- 
2.53.0



