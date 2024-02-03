Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D50C8199A2;
	Sat,  3 Feb 2024 04:10:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706933449; cv=none; b=JrINkimw/tpdOkuwzUG7ZpW1fJWiFKIYebGrpla/8Sm1uNvPx7jdF9Oa/vnW/fTj52m6la7tC5njvJQm0a1CkLN3tKTVSJouPEO+3vo+kKsWqkTWlnfvGa90y8b200rzv9+W5kz53Jh0MyqKKqtb1WRFkrEk4KoWVmfDUOrDcMk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706933449; c=relaxed/simple;
	bh=FtXE+3jOCdLEkCMLfoKIpYnROVjka01bI+ZbslOqZGk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=GTVkvSJa0yFaiFSYUXFAJgysT60kevYP6TumMMgUMq+aeKTjT0olrK1bcM5hRqziEWv5+bQ1Brxkg1P3d8iY2t/qpZYlOxIwmOoqkHQvQAXje+fgEEIs3uQH0loHuFQ0NIZXdG/KVHJ+nK51/6qZ9eKiCq8dScjN46KJhH6MSAI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=p9DeDhjs; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="p9DeDhjs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9EAAEC433F1;
	Sat,  3 Feb 2024 04:10:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706933449;
	bh=FtXE+3jOCdLEkCMLfoKIpYnROVjka01bI+ZbslOqZGk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=p9DeDhjspdjdF5lHXe31cG/FfcM1eM+CKU33CeQVIwIvdKFLajDMJOEUfpZcVtFrr
	 51HVWiAetLQ444wkNUlttENovrdk90NS5t51hhrOIUoN8yD01oqdd8/wYq4dgqyTm4
	 U8PpeDanfVyKeFE2t0QhTFy0anNTZDpBIRbtC9FA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stephen Rothwell <sfr@canb.auug.org.au>,
	=?UTF-8?q?Ville=20Syrj=C3=A4l=C3=A4?= <ville.syrjala@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 184/219] drm: using mul_u32_u32() requires linux/math64.h
Date: Fri,  2 Feb 2024 20:05:57 -0800
Message-ID: <20240203035342.518174180@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240203035317.354186483@linuxfoundation.org>
References: <20240203035317.354186483@linuxfoundation.org>
User-Agent: quilt/0.67
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Stephen Rothwell <sfr@canb.auug.org.au>

[ Upstream commit 933a2a376fb3f22ba4774f74233571504ac56b02 ]

Some pending include file cleanups produced this error:

In file included from include/linux/kernel.h:27,
                 from drivers/gpu/ipu-v3/ipu-dp.c:7:
include/drm/drm_color_mgmt.h: In function 'drm_color_lut_extract':
include/drm/drm_color_mgmt.h:45:46: error: implicit declaration of function 'mul_u32_u32' [-Werror=implicit-function-declaration]
   45 |                 return DIV_ROUND_CLOSEST_ULL(mul_u32_u32(user_input, (1 << bit_precision) - 1),
      |                                              ^~~~~~~~~~~

Fixes: c6fbb6bca108 ("drm: Fix color LUT rounding")
Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: Ville Syrjälä <ville.syrjala@linux.intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20231219145734.13e40e1e@canb.auug.org.au
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/drm/drm_color_mgmt.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/include/drm/drm_color_mgmt.h b/include/drm/drm_color_mgmt.h
index 54b2b2467bfd..ed81741036d7 100644
--- a/include/drm/drm_color_mgmt.h
+++ b/include/drm/drm_color_mgmt.h
@@ -24,6 +24,7 @@
 #define __DRM_COLOR_MGMT_H__
 
 #include <linux/ctype.h>
+#include <linux/math64.h>
 #include <drm/drm_property.h>
 
 struct drm_crtc;
-- 
2.43.0



