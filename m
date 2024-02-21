Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D7C062A1D7;
	Wed, 21 Feb 2024 13:42:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708522942; cv=none; b=n6Cyd8SQIJgVf/mC7VnMmYkNGjb9BzIjuQGEyP3s16kwvz1E6FED0c2YXotrEVrxTFLcbui2zSxTZsPR7fcNOGhKJ2p5ZzjW2Dy4kcgDGNQOyG1JH2Uw6y5Gy9GIK8IARbplSHs3BQPi3KvEcIT4ouYukZw+SbuCq3dZTs54cFw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708522942; c=relaxed/simple;
	bh=XQ/9lPHDE6O8iNTLR+FnYWkbEkqaYH83IDMa5AT2nUc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Hvpl+IecrjrfEuiHs+mGa5qxAwo2TNO77A/3hOPwio5Q25yhV8jCIEWk0xSwenufMIpuXl4MEsYHN0DIWNaU812NNu2J+YxPD8BikVgPDL5j2b733WsV+lLNe3ui9+bYR+ZLfy9m3EoY4JT1L+0zZMiyTYC0s6vxM4kbc1N+SlE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xm8bHLjT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xm8bHLjT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2E772C433F1;
	Wed, 21 Feb 2024 13:42:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708522942;
	bh=XQ/9lPHDE6O8iNTLR+FnYWkbEkqaYH83IDMa5AT2nUc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xm8bHLjTWkHmS+oEwc0RVrXWdGL1qUaDhKmKEaKw0QGcHj1UBSkDu/QYnhU+NSFMi
	 6t9/43ppliEAUn711Sqn+BqI1Qwwy4KG+8/nQWmounw17OxOsleIjP6+PCKkAwQUX6
	 5uAnKzPsalUJMOnXaIA3U3MZfEsgydmrB/+9DuQM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stephen Rothwell <sfr@canb.auug.org.au>,
	=?UTF-8?q?Ville=20Syrj=C3=A4l=C3=A4?= <ville.syrjala@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 269/476] drm: using mul_u32_u32() requires linux/math64.h
Date: Wed, 21 Feb 2024 14:05:20 +0100
Message-ID: <20240221130017.797620317@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240221130007.738356493@linuxfoundation.org>
References: <20240221130007.738356493@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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



