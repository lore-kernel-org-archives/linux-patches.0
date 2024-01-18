Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 81F3C200A0;
	Thu, 18 Jan 2024 11:02:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705575721; cv=none; b=IudtoghJQN/dUDj3CiqlZ9cuuaoR5cGaZTrjhyeX/HmQsOLK0d9ZePyvqus7tWW/tYoLXbnLpS0ofCpToQolafGVACYzE4lBjhywU8iwTrqZsIIhQDq8tfwIWDcO2j3+jdOJ18Ce0oBkqeuxI/5ukeSXAE6QDFKgzrgFZzxj0rU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705575721; c=relaxed/simple;
	bh=KVxZ5l604JVDqfDmQz11GwzPw1Pm8IZDp3xOBk0IsN0=;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:
	 X-Mailer:In-Reply-To:References:User-Agent:X-stable:
	 X-Patchwork-Hint:MIME-Version:Content-Transfer-Encoding; b=gAq6vF7ptOjAsrZcPlCJ1OUXcY8So6Alp7tZY0BfYo6lt5+C+8aeLxozWoWuwDW1mtZpBSXUivih2Qyx8NlOAZPFbCCp9vWgLRRfZVZKU+Jdz8opUZNPCEkcB9KJI+XE/ka/KRBJTCSpBf5SJ3D+YeKQalxka5hFd57OyRMRKvg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=q4SVXUyg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="q4SVXUyg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F0302C433C7;
	Thu, 18 Jan 2024 11:02:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705575721;
	bh=KVxZ5l604JVDqfDmQz11GwzPw1Pm8IZDp3xOBk0IsN0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=q4SVXUygrYJkWbPfOw2OuT8XM5/jnVGJMyjmDf0QqGUi6qi/6zWwidXWFcdZgALf1
	 fyiAP5dDruXOKllEUbw/TyVjH55Z/3jsI+4JBlOGGMZa4jBMdEuFvAZUNzdaSUal7l
	 ZZxt6W6a3pjIDoMAQbK39Z9eqMqZVHnHEcmLAmeM=
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
Subject: [PATCH 6.1 081/100] drm/crtc: fix uninitialized variable use
Date: Thu, 18 Jan 2024 11:49:29 +0100
Message-ID: <20240118104314.429737186@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240118104310.892180084@linuxfoundation.org>
References: <20240118104310.892180084@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index d718c17ab1e9..cb90e70d85e8 100644
--- a/drivers/gpu/drm/drm_crtc.c
+++ b/drivers/gpu/drm/drm_crtc.c
@@ -715,7 +715,7 @@ int drm_mode_setcrtc(struct drm_device *dev, void *data,
 	struct drm_mode_set set;
 	uint32_t __user *set_connectors_ptr;
 	struct drm_modeset_acquire_ctx ctx;
-	int ret, i, num_connectors;
+	int ret, i, num_connectors = 0;
 
 	if (!drm_core_check_feature(dev, DRIVER_MODESET))
 		return -EOPNOTSUPP;
@@ -850,7 +850,6 @@ int drm_mode_setcrtc(struct drm_device *dev, void *data,
 			goto out;
 		}
 
-		num_connectors = 0;
 		for (i = 0; i < crtc_req->count_connectors; i++) {
 			connector_set[i] = NULL;
 			set_connectors_ptr = (uint32_t __user *)(unsigned long)crtc_req->set_connectors_ptr;
-- 
2.43.0



