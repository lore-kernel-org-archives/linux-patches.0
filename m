Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 91C9C8801;
	Tue, 30 Apr 2024 11:17:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714475877; cv=none; b=ALO67O2UnIzLOCnDAcwkHhPSSU68H5T3E7GXxXYRDBExgDg+BZM4PSM9wBQ8sHTj1Yk6+gxXNjYzpBZtDA8DvEs22LX+UhKK/0hHqhltn3eoVBjA3n8Uc7oACLbVy96qjpm1OaJvylLL7T64tUfjxfYHKdFL7aOPIDZ//ZhFsxE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714475877; c=relaxed/simple;
	bh=aDn7CEskH/niRsIE2UFHLSrHzLbEkc4iWCmQhLP9LCs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aPRZN8Ab61/t9jQs8SoOCgYlkfgZbEGtXa3EXDJfwlkUZ4UVLRM3LaPZtDrgE2nyhRtoXf4F/XlrkKA89LsOryHc1i1t9TIGTUcoN1n/RU6fXnZz86QQfadcW4GzOpJWnNnZ+onz3XnNBS79+wKfwUE/qbykCn6BfIJklGFyOdY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RhrpfUw9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RhrpfUw9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ACF9EC2BBFC;
	Tue, 30 Apr 2024 11:17:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1714475877;
	bh=aDn7CEskH/niRsIE2UFHLSrHzLbEkc4iWCmQhLP9LCs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RhrpfUw9YwZ2wId4v7DoRhaLODHftZl0Dt6pj4Rwk5FOYmwJuLC4whXQdK6B7WPnE
	 TIsUF3uLs8ttC2oaTMKPC6n4Py836gObKyiPHGVpGDMhxyCgcXcoO7nNqXgUyRQtzS
	 r6a2D6EImT/YQvUzlBbwQc5KunWV0m9lj8ntwPew=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jim Cromie <jim.cromie@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 46/80] drm-print: add drm_dbg_driver to improve namespace symmetry
Date: Tue, 30 Apr 2024 12:40:18 +0200
Message-ID: <20240430103044.779441109@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240430103043.397234724@linuxfoundation.org>
References: <20240430103043.397234724@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jim Cromie <jim.cromie@gmail.com>

[ Upstream commit 95a77b6331c2d2313aa843fa77ec91cd092ab0e4 ]

drm_print defines all of these:
    drm_dbg_{core,kms,prime,atomic,vbl,lease,_dp,_drmres}

but not drm_dbg_driver itself, since it was the original drm_dbg.

To improve namespace symmetry, change the drm_dbg defn to
drm_dbg_driver, and redef grandfathered name to symmetric one.

This will help with nouveau, which uses its own stack of macros to
construct calls to dev_info, dev_dbg, etc, for which adaptation means
drm_dbg_##driver constructs.

Signed-off-by: Jim Cromie <jim.cromie@gmail.com>
Link: https://lore.kernel.org/r/20220912052852.1123868-7-jim.cromie@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Stable-dep-of: a60ccade88f9 ("drm/vmwgfx: Fix crtc's atomic check conditional")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/drm/drm_print.h | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/include/drm/drm_print.h b/include/drm/drm_print.h
index 15a089a87c225..f7ece14b10227 100644
--- a/include/drm/drm_print.h
+++ b/include/drm/drm_print.h
@@ -444,7 +444,7 @@ void drm_dev_dbg(const struct device *dev, enum drm_debug_category category,
 
 #define drm_dbg_core(drm, fmt, ...)					\
 	drm_dev_dbg((drm) ? (drm)->dev : NULL, DRM_UT_CORE, fmt, ##__VA_ARGS__)
-#define drm_dbg(drm, fmt, ...)						\
+#define drm_dbg_driver(drm, fmt, ...)						\
 	drm_dev_dbg((drm) ? (drm)->dev : NULL, DRM_UT_DRIVER, fmt, ##__VA_ARGS__)
 #define drm_dbg_kms(drm, fmt, ...)					\
 	drm_dev_dbg((drm) ? (drm)->dev : NULL, DRM_UT_KMS, fmt, ##__VA_ARGS__)
@@ -463,6 +463,7 @@ void drm_dev_dbg(const struct device *dev, enum drm_debug_category category,
 #define drm_dbg_drmres(drm, fmt, ...)					\
 	drm_dev_dbg((drm) ? (drm)->dev : NULL, DRM_UT_DRMRES, fmt, ##__VA_ARGS__)
 
+#define drm_dbg(drm, fmt, ...)	drm_dbg_driver(drm, fmt, ##__VA_ARGS__)
 
 /*
  * printk based logging
-- 
2.43.0



