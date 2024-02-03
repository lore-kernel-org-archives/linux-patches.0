Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BBE9717571;
	Sat,  3 Feb 2024 04:19:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706933946; cv=none; b=e48qO0HVakKPNQU85P6CwEpE/9wQmkXIrkFnDYGZ35o4haPsxypcbGUB+do3g+Lb7QHqBb3Kj18q8O7K0/CM51eLaxS/bFFS/+UMnqdSZrXgq9SqYtOWGmJuVrjgsNpx0ZBRwp1+/mIdVXkp26267fPZfUfeCkZeUxBDPPX9vcc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706933946; c=relaxed/simple;
	bh=QDL4dRSy5czu/RIQIUCQbqgH5QGeSP/arc3sOJk9SPs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Fgk/SUuxzPyf7LyfcM09qxYF+QqXNrflww4Zm7qPOCtvbOGzF/YBHxRyAluMLr5f4avlft0kQijwW6w799R/h+5stFxcq6GZc70x9lgb/PCNctzJhXBFyLZ5LzWAttba4poKZ8yIS463eub7qufgDdqgv82gywVpSY6fFjvS03I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oEolhd9G; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oEolhd9G"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 853D4C43390;
	Sat,  3 Feb 2024 04:19:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706933946;
	bh=QDL4dRSy5czu/RIQIUCQbqgH5QGeSP/arc3sOJk9SPs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=oEolhd9GjN9bD7CP1/v44XYNpFi5U8nZldxjmhJbvzxYptr4Iy7E+o1wJ583Yqrua
	 5xrvJh8lIZRfgAmF4ljv2xbH9CfodfVTIXRcrfefu27N980k75VIQfqqWAGfuCvr8O
	 mBcwEx0196eqh5q+RjUcuqhouHK4ESdKVrLBq/Do=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stephen Rothwell <sfr@canb.auug.org.au>,
	=?UTF-8?q?Ville=20Syrj=C3=A4l=C3=A4?= <ville.syrjala@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 289/353] drm: using mul_u32_u32() requires linux/math64.h
Date: Fri,  2 Feb 2024 20:06:47 -0800
Message-ID: <20240203035412.930545485@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240203035403.657508530@linuxfoundation.org>
References: <20240203035403.657508530@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

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



