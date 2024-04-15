Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B43C87581A;
	Mon, 15 Apr 2024 14:28:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713191303; cv=none; b=BYDfWdvMb/NUbg8HusV6obkV1dXmx8dBPTcD6/7SHzdedkEoItqgHkPddDWhT4FvlGzq+EFIv4h+q0Yyvth5AaGv9vEg41jqX2kq3ZjEu8p3+L1q9GV3kDugo5dD/37/MdSxip1PC9Wtw7WjgjKLQF5NYC4JP/Q92zhMX4QHF2I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713191303; c=relaxed/simple;
	bh=2+87QiyfkOPrOEZucXxXMKMiX183VQ9or0wWx3x0+c4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=PcMJ98J9ZuSpMInlN/VsOuiiNYLGR9faU6V/H7DrkrUwnBLmqvBTtnsHu9QhgUI52nekOoIoYgZi/x7YhMRdOdXLGUtBluEYRyK41ukaKiJHm1HS1KfE/qF80/D4KGV5uyUJt+BNWMsdmZt7n3EKPiIDwfjZr7BoAnA57reqruQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NltpyBqK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NltpyBqK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 37F78C113CC;
	Mon, 15 Apr 2024 14:28:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1713191303;
	bh=2+87QiyfkOPrOEZucXxXMKMiX183VQ9or0wWx3x0+c4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NltpyBqKeked0rz1Tn32E7CU9SIneyugtrwVF9DwL7k01rRRRQuRa9JwDzqntU5TI
	 X88ZphnoOM2ee9Xn6A0JhneSebUE3oDet2ouvZYs+6Jj//ijXJUaCs6fHQ96MVr1LN
	 OT6gIoRo0KtYZqR1YuQzwQlzJmdO8+dYYZxCBTHk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jani Nikula <jani.nikula@linux.intel.com>,
	Arun R Murthy <arun.r.murthy@intel.com>,
	Jani Nikula <jani.nikula@intel.com>,
	Lucas De Marchi <lucas.demarchi@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.8 100/172] drm/xe/display: Fix double mutex initialization
Date: Mon, 15 Apr 2024 16:19:59 +0200
Message-ID: <20240415142003.435373194@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240415141959.976094777@linuxfoundation.org>
References: <20240415141959.976094777@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Lucas De Marchi <lucas.demarchi@intel.com>

[ Upstream commit 50a9b7fc151e67b9e642232d32e8c5a5ac13e64a ]

All of these mutexes are already initialized by the display side since
commit 3fef3e6ff86a ("drm/i915: move display mutex inits to display
code"), so the xe shouldn´t initialize them.

Fixes: 44e694958b95 ("drm/xe/display: Implement display support")
Cc: Jani Nikula <jani.nikula@linux.intel.com>
Cc: Arun R Murthy <arun.r.murthy@intel.com>
Reviewed-by: Jani Nikula <jani.nikula@intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20240405200711.2041428-1-lucas.demarchi@intel.com
Signed-off-by: Lucas De Marchi <lucas.demarchi@intel.com>
(cherry picked from commit 117de185edf2c5767f03575219bf7a43b161ff0d)
Signed-off-by: Lucas De Marchi <lucas.demarchi@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/xe/xe_display.c | 5 -----
 1 file changed, 5 deletions(-)

diff --git a/drivers/gpu/drm/xe/xe_display.c b/drivers/gpu/drm/xe/xe_display.c
index e4db069f0db3f..6ec375c1c4b6c 100644
--- a/drivers/gpu/drm/xe/xe_display.c
+++ b/drivers/gpu/drm/xe/xe_display.c
@@ -108,11 +108,6 @@ int xe_display_create(struct xe_device *xe)
 	xe->display.hotplug.dp_wq = alloc_ordered_workqueue("xe-dp", 0);
 
 	drmm_mutex_init(&xe->drm, &xe->sb_lock);
-	drmm_mutex_init(&xe->drm, &xe->display.backlight.lock);
-	drmm_mutex_init(&xe->drm, &xe->display.audio.mutex);
-	drmm_mutex_init(&xe->drm, &xe->display.wm.wm_mutex);
-	drmm_mutex_init(&xe->drm, &xe->display.pps.mutex);
-	drmm_mutex_init(&xe->drm, &xe->display.hdcp.hdcp_mutex);
 	xe->enabled_irq_mask = ~0;
 
 	err = drmm_add_action_or_reset(&xe->drm, display_destroy, NULL);
-- 
2.43.0



