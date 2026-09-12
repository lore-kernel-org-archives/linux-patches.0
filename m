Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6565738AC92;
	Sat, 12 Sep 2026 11:59:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789214349; cv=none; b=h87pDsAb4TWEFNpDq3TQjk9kcngO2TD7Uq5ap4tUbPoWcnLFp3XbmaIXYoEyHqQk9GQ+R4qDdvbhndSUqBIKXvGPJsEsmI/JMLep4rz0tMToLLc9mtA76dY0u1vxK4fdanRDXwGHjUoGLnspc663sQNoQqdzc/0oVZOIic/nZao=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789214349; c=relaxed/simple;
	bh=uAMqyxROtylSvUB87AGQ/z4k3j1DcsVUuWQT1fTMzNc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=j4otvC0Rag/oQIBkS+vMHShNcJm9wY4V9uEVUuX2vXlRhV23SJkqZ7+eZvVCh0ekibn9lVeIUbTZYsDMwas1y/tRuCDBtKn4S/XJqcYBrjWhjeqwXmtPYb4tRF1QWbH3oXQ6eecLoQ49YyPqsTAZgJcb03Ih+rU2mfUZN7aFHOs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ztw19sOh; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ztw19sOh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 051E51F000FF;
	Sat, 12 Sep 2026 11:59:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789214348;
	bh=yVIw9c1FK0rb5xxew3zqcblTXnPoK5XzOcKU2LaXOng=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ztw19sOhfGJIFsSGXS6Yw+N/GxxuDmsifUQOHV62PZg1VNcVCOQOd4WQvyPg6ghKh
	 uonAsQRV2bC7GINeb3STd2NJt4soZPxDL0lj/KLEYZ5FlvhYGj96KN2VK3vdR3qQo7
	 lfQDrk/JcfhwQEv7gVz2+RoFO8nWq/hwwk153fhE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yicong Hui <yiconghui@gmail.com>,
	Thomas Zimmermann <tzimmermann@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0308/1376] drm: Remove unused header in drm_dumb_buffers.c
Date: Sat, 12 Sep 2026 08:45:34 +0200
Message-ID: <20260912065614.414501035@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.535295758@linuxfoundation.org>
References: <20260912065607.535295758@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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



