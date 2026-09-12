Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D3F832ECD1D;
	Sat, 12 Sep 2026 14:11:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789222313; cv=none; b=M53TyVp2BMILQNQQEgz3i27u7FQGG6kAHuVGmu8S8iR+5pVWglkLiAsco/3fvMmLOwtoGGV7YUjMJVP0i5DOsJAvSu28XiP2LkYbVey+VWXoaYVWysKI3B23j2gXftXc0R96D40rn6s+DHtMXwWa3S7mU09ZyBsQDuA/ZUucjpk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789222313; c=relaxed/simple;
	bh=FndpYypaaeb6o2kL9xYZxwt8vVo+VAoeD0pDTY3TgZ8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rx2nPQxSnCVwWzQCITutM+ljZQbR8zsqISu+Z8NA+lC+OpHiA+niASVah7i3Rqx1mB2SpJLfvUUmf9M538dJ5M9QRpl6OR7KA/+wis/a3Q47hGUfJMGjoWW2WqVRrXRaUsrlf46c21E4DAXkZSotBKQnVQugsy0bd/OCHmNEpSM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UZhXkXTa; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UZhXkXTa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9E6E21F000FF;
	Sat, 12 Sep 2026 14:11:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789222312;
	bh=Fq3H6495h6f13PuGSU+hap+ZGntkNjDggo3YnRjwHKE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=UZhXkXTaxjCf52KKPaqWbgRl03iyPFpMeuEvENuiH2C3ZrRTCVhB3ZOM3Gz2rfTDF
	 s6gCMbNHAhS4OvyNZcAY5uJg9y4eUfQYnGNZrVcWBgO/LEXeD24XDG/YsGTJqp5o0O
	 qC+k+DCLsbEV7tM61kRe063Cmi6PPU3k63/+Rnzg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yicong Hui <yiconghui@gmail.com>,
	Thomas Zimmermann <tzimmermann@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0561/1424] drm: Remove unused header in drm_dumb_buffers.c
Date: Sat, 12 Sep 2026 08:49:53 +0200
Message-ID: <20260912065619.867306815@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.279695368@linuxfoundation.org>
References: <20260912065607.279695368@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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



