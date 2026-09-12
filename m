Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 07B513AD534;
	Sat, 12 Sep 2026 07:06:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789196786; cv=none; b=oatacYC7kh7xBAh6vavCi89BO8hcb5K2CGJTd9PVBKKKOppMvPgEYOL+0yeI9EuY/9e9OlKyUOc/ORxdSQtYCurt0GPjxsD6I0ajNP8kE1WdgVTqgi+anOdv/H4D6g7to6AgRh5HlGgJNSiTtUkW8Kdp2T22ycnWSeg0Tg4Eiis=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789196786; c=relaxed/simple;
	bh=PsrJGhXDzgAsG3xfvjB8cjDzG1WnxoNJzXIDo/LmQmY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cHBLXii3/7K/4zvVBXnOVmAdTV327PqOOEAUDNyxi/Ch/mndy3yD11Yy4OLo55vH6mdLUrWfAo6NVU/+r2LqF+VccvR+mshN4lgNURdKCjfKuFzDqTCh0Tc8+trewwlYshvbuYHWaaHuXGC3iLYxmhi8XcI3BHym9peH8jMtNVI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=A+gzE+Mj; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="A+gzE+Mj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 839BD1F00893;
	Sat, 12 Sep 2026 07:06:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789196782;
	bh=HzcFmEWIteGGEgYvsD05J0ux2DB5fZAktIXuqxjR6II=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=A+gzE+MjfhrhkeDyXnWVZ8Y2qEC6xPbH1JvQ8Ozt+5A+y/uE4BszxN4m3o3Umdw5G
	 WimXL3s288lro7QCNgU3LRFEqTh4Q8UyzuvjZmUpmzlhr8TxhorWHYneXyTRl+9nSe
	 fPK/+PKulkCXucgyg4P3laZI0VwsYq1Kp9EqIUKU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yicong Hui <yiconghui@gmail.com>,
	Thomas Zimmermann <tzimmermann@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 0035/1815] drm: Remove unused header in drm_dumb_buffers.c
Date: Sat, 12 Sep 2026 08:29:45 +0200
Message-ID: <20260912065649.843940201@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

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
index 2156dbe601c9c..8e9ff17538e73 100644
--- a/drivers/gpu/drm/drm_dumb_buffers.c
+++ b/drivers/gpu/drm/drm_dumb_buffers.c
@@ -32,7 +32,6 @@
 #include <drm/drm_print.h>
 
 #include "drm_crtc_internal.h"
-#include "drm_internal.h"
 
 /**
  * DOC: overview
-- 
2.53.0



