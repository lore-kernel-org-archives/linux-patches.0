Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0AAB31869;
	Tue, 23 Jan 2024 00:03:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705968219; cv=none; b=VhTGpxwEdgb8Mh+2br6LP7iaXuH02Lh/tQe9vt6RGNpjjaRDLcKphRf2XDhmbAkhwEFLtuXS416QP4bBLYC8ezGCbaf/WseqrmuYn9/f8wbZTW8IhwNcYeG+w91utRFAqDxs32d3ZXy5Jxsb7KDDDVHyXLBR1AmgcauaqDPA9f4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705968219; c=relaxed/simple;
	bh=fZ11druE/PQzYoSj8y0eBQ87l88mrgWtRVHFNV5DQAw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nnylJKtOM/LKwY/uRahZjqMvDiOPfhtqZcANf19uQU3dKfu4/OvQlwDLZyd/97kECG2MnbfpjcW01rOQyw1MXn5xxoAs3FBbEq/xwQSgFmwBubHK0LmlKFHVzgwwYSRsVMbsu7642hKiGEllTIuGlemBrR0QsuA/SU0m+1XSbJY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IApNRtzy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IApNRtzy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 75933C433F1;
	Tue, 23 Jan 2024 00:03:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705968218;
	bh=fZ11druE/PQzYoSj8y0eBQ87l88mrgWtRVHFNV5DQAw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IApNRtzyqzEzRKSE7Wl01Rw0AdgjURNhho/FM+0zkF+0wWDaL8hVF6xQHqIRL76Zz
	 jZ5ecV6eRxsl0k9MVdogPhoX+HwxvbwBSbweCLcIGKD2doJnsWgfvP/ix+CR1TVvLP
	 YfOohbIkKxoeqgVCUrVtWcP6jsZJbXQmzw4otzBc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+4fad2e57beb6397ab2fc@syzkaller.appspotmail.com,
	Ziqi Zhao <astrajoan@yahoo.com>,
	Maxime Ripard <mripard@kernel.org>,
	Maarten Lankhorst <maarten.lankhorst@linux.intel.com>,
	Thomas Zimmermann <tzimmermann@suse.de>,
	Jani Nikula <jani.nikula@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 022/148] drm/crtc: fix uninitialized variable use
Date: Mon, 22 Jan 2024 15:56:18 -0800
Message-ID: <20240122235713.328891909@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235712.442097787@linuxfoundation.org>
References: <20240122235712.442097787@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jani Nikula <jani.nikula@intel.com>

[ Upstream commit 6e455f5dcdd15fa28edf0ffb5b44d3508512dccf ]

Commit 3823119b9c2b ("drm/crtc: Fix uninit-value bug in
drm_mode_setcrtc") was supposed to fix use of an uninitialized variable,
but introduced another.

num_connectors is only initialized if crtc_req->count_connectors > 0,
but it's used regardless. Fix it.

Fixes: 3823119b9c2b ("drm/crtc: Fix uninit-value bug in drm_mode_setcrtc")
Cc: syzbot+4fad2e57beb6397ab2fc@syzkaller.appspotmail.com
Cc: Ziqi Zhao <astrajoan@yahoo.com>
Cc: Maxime Ripard <mripard@kernel.org>
Cc: Maarten Lankhorst <maarten.lankhorst@linux.intel.com>
Cc: Thomas Zimmermann <tzimmermann@suse.de>
Signed-off-by: Jani Nikula <jani.nikula@intel.com>
Signed-off-by: Maxime Ripard <mripard@kernel.org>
Link: https://patchwork.freedesktop.org/patch/msgid/20231208131238.2924571-1-jani.nikula@intel.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/drm_crtc.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/drivers/gpu/drm/drm_crtc.c
+++ b/drivers/gpu/drm/drm_crtc.c
@@ -573,7 +573,7 @@ int drm_mode_setcrtc(struct drm_device *
 	struct drm_mode_set set;
 	uint32_t __user *set_connectors_ptr;
 	struct drm_modeset_acquire_ctx ctx;
-	int ret, i, num_connectors;
+	int ret, i, num_connectors = 0;
 
 	if (!drm_core_check_feature(dev, DRIVER_MODESET))
 		return -EINVAL;
@@ -718,7 +718,6 @@ retry:
 			goto out;
 		}
 
-		num_connectors = 0;
 		for (i = 0; i < crtc_req->count_connectors; i++) {
 			connector_set[i] = NULL;
 			set_connectors_ptr = (uint32_t __user *)(unsigned long)crtc_req->set_connectors_ptr;


