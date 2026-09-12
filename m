Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 50E3A27EC7C;
	Sat, 12 Sep 2026 09:40:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789206019; cv=none; b=j06/0MJ9IcXyPyYi+sNLeyI2PH+33uz9r1P8W2widmhNH74kSdWtuU6r4xDfQlsLtP5JXCsO1v2uFRL1hjlGcvvJHuujQaYRtK/9v2NZU9K14+vb+yQMY8yXZ4R2BRwmGcCv1kdwos3EcFO1Q61uI1icwVoTTtE/E6x967pmKzU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789206019; c=relaxed/simple;
	bh=2XbXiB+4DThp/iUMdPckZ/VRkLsVZ6TUihTgCwv5Nlw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tmFEa7IOa3xTIIQcbCyv1NXq3FdTW7l2SlXnEzzO803LADeqS3dBvhPP7uKHuktkhIwNL2ASzQoKMx2K6UJK8tHkZedseUoXDICETyiHL6DcQFadIzSXNdHKFoG73xLwMGxjus6rZMAC2XvfKjSWDdr1ryAYsChGsfajAkOyD10=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gWqIiUWF; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gWqIiUWF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E529E1F000FF;
	Sat, 12 Sep 2026 09:40:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789206018;
	bh=6tG7WqxHy8hQ5iVMHEjuJt/8Yn5dCVYMw3f+PSpntac=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=gWqIiUWFxL4P0b8/h5c77PDe+LNTW9UasiDHsWg0wSKViMyMvieY6LD8bjzkuLde7
	 2dFDNjNvgwrnSHwW1cjTyl2Hs9uDpPWDWztOoFIOgQ+CB1YnaKZR5UupJCS2/guUwY
	 pxOSoVCovNi1AWvNKQzz17J+Qg3+6fS0pbB0qQy8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yicong Hui <yiconghui@gmail.com>,
	Thomas Zimmermann <tzimmermann@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0093/1518] drm: Remove unused header in drm_dumb_buffers.c
Date: Sat, 12 Sep 2026 08:37:42 +0200
Message-ID: <20260912065625.579429672@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065623.398859879@linuxfoundation.org>
References: <20260912065623.398859879@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yicong Hui <yiconghui@gmail.com>

[ Upstream commit 38b4ce17ef3421fb0e5e6dbdab1974282bde1165 ]

Remove the header #include "drm_internal.h" from drm_dumb_buffers.c,
which is included but not used.

Header was introduced in commit 47f10854ca89 ("drm: Don't export the
drm_gem_dumb_destroy() function") when moving functions, but was not
removed in commit 96a7b60f6ddb ("drm: remove dumb_destroy callback")
when the drm_gem_dumb_destroy function was removed.

Compiles successfully with DRM enabled, pass kunit tests and
IGT-tests in a vng virtual machine.

Fixes: 96a7b60f6ddb ("drm: remove dumb_destroy callback")
Signed-off-by: Yicong Hui <yiconghui@gmail.com>
Reviewed-by: Thomas Zimmermann <tzimmermann@suse.de>
Signed-off-by: Thomas Zimmermann <tzimmermann@suse.de>
Link: https://patch.msgid.link/20260409154826.8955-1-yiconghui@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/drm_dumb_buffers.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/gpu/drm/drm_dumb_buffers.c b/drivers/gpu/drm/drm_dumb_buffers.c
index 70032bba1c97e..7b4ba9fab299a 100644
--- a/drivers/gpu/drm/drm_dumb_buffers.c
+++ b/drivers/gpu/drm/drm_dumb_buffers.c
@@ -29,7 +29,6 @@
 #include <drm/drm_mode.h>
 
 #include "drm_crtc_internal.h"
-#include "drm_internal.h"
 
 /**
  * DOC: overview
-- 
2.53.0



