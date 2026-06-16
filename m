Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D2123370EA;
	Tue, 16 Jun 2026 15:08:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781622536; cv=none; b=Z/axCzKBm64+CH2B83BXlm4iiktEg5kOOG+3oJgynj/Dvx3EtLULtbJa+7GbHGLun7apuAjU551MlEJ4iZg/4WlTsXyGIW8w2ygDWqznEaIVaDeRgxck+DVjdtBVzoevLS0/pyHRgpZg7QYcUACbaEPpdQtAxdnp95bnpMr2tF4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781622536; c=relaxed/simple;
	bh=sVqk+L6qSPX1OhjSiJOZrdIdKyo4U2AHaaKulaUDun0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=dcDTK/ojK60aU1mxkeHX4/3bqIXY+U1Sa0jYO4roMhFDtnFi7Ex4rL2yDr4lu77Lq/HFy7WWp3WVJy3BCOIixPkdwX3TpC7pIFRH2cdz0RaNCvCGHRLHSuSsh95biUgNpLddxKzE7aJQS0eUn15X1EX1Aw0R4juH7sfiv/nErTw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rAh/PTpE; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rAh/PTpE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 132701F00A3A;
	Tue, 16 Jun 2026 15:08:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781622535;
	bh=tZnWcXpCbVVp5CeHEkHAORJuW3hwnlbRC4RiuzaZYsM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=rAh/PTpEm5d6HoQCPYChzXUYCW72EljQCpT5LtJXLAIIRuh85ydfxZfILC5n4rtej
	 nIrEVQ1WMpdknitQIWqWZPMS4VFZ5bbt+7ftmNt1xdOZ/ZUR4Vb9nkevO3RiXHtqtH
	 7JOz/WgWgoE3Wgduz0/Sik7NPI4Nn37YmQRE+Tbw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Carlos Eduardo Gallo Filho <gcarlos@disroot.org>,
	=?UTF-8?q?Andr=C3=A9=20Almeida?= <andrealmeid@igalia.com>,
	Thomas Zimmermann <tzimmermann@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 005/411] drm: Remove plane hsub/vsub alignment requirement for core helpers
Date: Tue, 16 Jun 2026 20:24:03 +0530
Message-ID: <20260616145100.648897473@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145100.376842714@linuxfoundation.org>
References: <20260616145100.376842714@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 22aa64d07c7905..78ef00b94a4635 100644
--- a/include/drm/drm_fourcc.h
+++ b/include/drm/drm_fourcc.h
@@ -22,6 +22,7 @@
 #ifndef __DRM_FOURCC_H__
 #define __DRM_FOURCC_H__
 
+#include <linux/math.h>
 #include <linux/types.h>
 #include <uapi/drm/drm_fourcc.h>
 
@@ -276,7 +277,7 @@ int drm_format_info_plane_width(const struct drm_format_info *info, int width,
 	if (plane == 0)
 		return width;
 
-	return width / info->hsub;
+	return DIV_ROUND_UP(width, info->hsub);
 }
 
 /**
@@ -298,7 +299,7 @@ int drm_format_info_plane_height(const struct drm_format_info *info, int height,
 	if (plane == 0)
 		return height;
 
-	return height / info->vsub;
+	return DIV_ROUND_UP(height, info->vsub);
 }
 
 const struct drm_format_info *__drm_format_info(u32 format);
-- 
2.53.0



