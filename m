Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E735A4E1BC;
	Tue, 23 Jan 2024 00:48:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705970890; cv=none; b=B8u4PR6SzHs2JHNH/jeLLrRNAue3OINw078KQZmSm45wKQIRvZIg2Zj5yRWoCKER77dMo9yuz++BFen/6k99PKBYtxSZYdzWOloVvwBA65Gq3ri+ZTuDGLXCpSr/JTk6MrhOOdZkE98ik8Nz+9fdcrXIIYQJF+W53WbG8qsbfpQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705970890; c=relaxed/simple;
	bh=SEE9sJ4ibXlwrun+N+xzM/wku9jDcnERRkHux28eXQU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uMMdYwFXjWKyB+95VvfXTPuczPP4E+LF8qlomqECWwRIr5zr0SKz9SOIs1rHX8eujB4fQJvaNmw5TDvVgMj3TkZOEvQrMZLAWefv/ydYQj+c9xT196J8Z55T661vups5gBqWm5PDXARKo7pqUZfGTMuOs6tFPQzLShYpfkKXnpc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KzdbdJkH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KzdbdJkH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 97A3AC433C7;
	Tue, 23 Jan 2024 00:48:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705970889;
	bh=SEE9sJ4ibXlwrun+N+xzM/wku9jDcnERRkHux28eXQU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KzdbdJkH57AHDotEm+eL8PIxuFLUFp7/cx+eBrtXL96QVHP6QO26894SndEV80wxy
	 ik1ip6NiCedG5fk3eQD4RkvXBTLFa3e4pIATU0EB1ykgDDVBp2oJnp3LAJiuTXFe1x
	 o2MWwjoZbI/aCFi1xywh+mW+AVgJxZt/yHowWDhU=
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
Subject: [PATCH 5.10 039/286] drm/crtc: fix uninitialized variable use
Date: Mon, 22 Jan 2024 15:55:45 -0800
Message-ID: <20240122235733.522397654@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235732.009174833@linuxfoundation.org>
References: <20240122235732.009174833@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
 drivers/gpu/drm/drm_crtc.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/drm_crtc.c b/drivers/gpu/drm/drm_crtc.c
index b3c0a9ea8c6f..4ed3fc28d4da 100644
--- a/drivers/gpu/drm/drm_crtc.c
+++ b/drivers/gpu/drm/drm_crtc.c
@@ -562,7 +562,7 @@ int drm_mode_setcrtc(struct drm_device *dev, void *data,
 	struct drm_mode_set set;
 	uint32_t __user *set_connectors_ptr;
 	struct drm_modeset_acquire_ctx ctx;
-	int ret, i, num_connectors;
+	int ret, i, num_connectors = 0;
 
 	if (!drm_core_check_feature(dev, DRIVER_MODESET))
 		return -EOPNOTSUPP;
@@ -700,7 +700,6 @@ int drm_mode_setcrtc(struct drm_device *dev, void *data,
 			goto out;
 		}
 
-		num_connectors = 0;
 		for (i = 0; i < crtc_req->count_connectors; i++) {
 			connector_set[i] = NULL;
 			set_connectors_ptr = (uint32_t __user *)(unsigned long)crtc_req->set_connectors_ptr;
-- 
2.43.0



