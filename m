Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D5741774B;
	Thu, 18 Jan 2024 10:58:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705575499; cv=none; b=WMi94KNx/eNzjsfNfyObQmDifTEwnxwJFBrz85uT4795JTjIIU6fdc8wsTQhVtUewhc4ct0RrBBGNOoCioenrwQQ54g7dPQlm9g7iDjB7WdBjPthuAhrZEZna0FRfLWgceIeoI2xg0e3KMHa4/dgP3GWNXy+farRJf1uKjzuN0s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705575499; c=relaxed/simple;
	bh=FB1+2i3WAqx+CJWzeWPuMJmHQYPU/ioFx9V+V1cmHJE=;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:
	 X-Mailer:In-Reply-To:References:User-Agent:X-stable:
	 X-Patchwork-Hint:MIME-Version:Content-Transfer-Encoding; b=mQsDvT0ZRiamILKMRVkLZd6RWg3zrMUAaK5pmZBkduVq1CoT+FXN4NudcSPFY4NqhRasMYn0+hLlp+mm6i0+MG8XhgF9mg7bGdOD99XOiI4LkxVgineZRGDuCYYmMGDRAcbFrtpOIygiLd4ARuHnWzqIl/dDfPRz/sjGWGhMl0c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yCOeKnFi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yCOeKnFi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1399DC433F1;
	Thu, 18 Jan 2024 10:58:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705575499;
	bh=FB1+2i3WAqx+CJWzeWPuMJmHQYPU/ioFx9V+V1cmHJE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yCOeKnFiLQRHvZYaLj93oDbczFVs3z1ChTdwo7pAiC0qzyhjFE/vrdGo+v1tJNxiQ
	 yKEUf4lmHayItew88ysPTRV3wDDbGiNjRX1UWK0hd5GoHJ8Y1vkcmbi49RTyABYvWn
	 YFFCcRc4gcQXaqtJYEeuBI4wI5bmRUNEHerjqI7U=
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
Subject: [PATCH 6.6 128/150] drm/crtc: fix uninitialized variable use
Date: Thu, 18 Jan 2024 11:49:10 +0100
Message-ID: <20240118104325.982170994@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240118104320.029537060@linuxfoundation.org>
References: <20240118104320.029537060@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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



