Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1FE3437C;
	Tue, 23 Jan 2024 01:09:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705972147; cv=none; b=L4dkAGWz+aTFkGO8hpFqnYkodfOg6jeIJWCeTuEz45PaFoSe59eyJBc6E5OQ1WdyctDaCVHeYYanNGVKgk91ropP4alQAFJrNtMi+MKljZYKEtIHa0GWe6dh+r9t00sjUgoDvMDjsHsyqfacutw7APhOrLu0v1fj9SKnbN2vR24=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705972147; c=relaxed/simple;
	bh=Vvc6bxipxAHMUEfFFsOmgQOSZwyAY5ALbP9+9IniLu0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=T8bZcokhlnx8yD+g/1zqj10fqs3IOnp4SFIfhL7/49/p7rfZozxQviygDKeJQq3sKqX4VpkLX1eVVJ8/yIZDS8Rt851ItgInwy4SwUL65b8ct35MFA98pmq+P3euls/bp/NDW1KhNiLOi011j5HiI2NdnxNqHHVH+89YX8kOy00=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=acd/I/4p; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="acd/I/4p"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D5A22C43399;
	Tue, 23 Jan 2024 01:09:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705972147;
	bh=Vvc6bxipxAHMUEfFFsOmgQOSZwyAY5ALbP9+9IniLu0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=acd/I/4pezRTPwo2DpKkaedObjD8ToLx1ZB5I5wT45y8HxrSndml2MycNxdjYs17n
	 waYICaSwlFWHsVe8r1OaRcarmK1BdefvU1ffrF37peZBCYcH6AfkIiXw81kgFzX0WF
	 g3wqLvDJivJJkRIcXQB10Q1aGYKY8P555c63WzOY=
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
Subject: [PATCH 5.15 049/374] drm/crtc: fix uninitialized variable use
Date: Mon, 22 Jan 2024 15:55:05 -0800
Message-ID: <20240122235746.308877187@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235744.598274724@linuxfoundation.org>
References: <20240122235744.598274724@linuxfoundation.org>
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
index 8b50ab4c5581..c5e0c652766c 100644
--- a/drivers/gpu/drm/drm_crtc.c
+++ b/drivers/gpu/drm/drm_crtc.c
@@ -643,7 +643,7 @@ int drm_mode_setcrtc(struct drm_device *dev, void *data,
 	struct drm_mode_set set;
 	uint32_t __user *set_connectors_ptr;
 	struct drm_modeset_acquire_ctx ctx;
-	int ret, i, num_connectors;
+	int ret, i, num_connectors = 0;
 
 	if (!drm_core_check_feature(dev, DRIVER_MODESET))
 		return -EOPNOTSUPP;
@@ -778,7 +778,6 @@ int drm_mode_setcrtc(struct drm_device *dev, void *data,
 			goto out;
 		}
 
-		num_connectors = 0;
 		for (i = 0; i < crtc_req->count_connectors; i++) {
 			connector_set[i] = NULL;
 			set_connectors_ptr = (uint32_t __user *)(unsigned long)crtc_req->set_connectors_ptr;
-- 
2.43.0



