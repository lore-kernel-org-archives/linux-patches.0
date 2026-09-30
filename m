Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1513A52E04E;
	Wed, 30 Sep 2026 18:42:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790793740; cv=none; b=jHX32CxXMf6kJ4zfq+jZf+MlOD6qIXU+pKaGFxVcwgVn9bZi5fBIWxCUyrzSqD72eEH2taArB6puxCQ4WgoicfT84TXWUo6sksKWh69Kp9CSJVml823TaILsibceSXCg0qKTs2cvR60Be06SI36B+7/8Q6UzgXRiHWKV3mGeXM8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790793740; c=relaxed/simple;
	bh=516oAUQrhl3VK2l+puqXwBDH1AdKL0/WdlYlp+Lp4y4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mWeJ8LRbyQO36yiAdc7OyF++J07tVgI/prgHIcbfWLM2+/jdKxq6p2JnsB1QCfa83KuAiM/kwrTzKrt6dMTVfuEwGT49n3R0MmgBmn4X/wtpMPsD+pK6TmLcEhzCrKFNXHf/GE+jTOxaCqCg94l1BLQyL26cqe3F7wpP+/U3ZjI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rZXgy1KX; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rZXgy1KX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 736351F000FF;
	Wed, 30 Sep 2026 18:42:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790793739;
	bh=ptePCLiUczyeUpVKuyJ+W6sd0hnFdaxoqFVo9K6eeLk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=rZXgy1KXjGRPebRLx5dptR8eTEG7hNKcGl1U6w2qB46b1urGnZ1gjv6/ZjmkasYH+
	 bgU/pYIUKhSEnG+OjhxVye1SmaWMZt0m0c8ElNKkXJdS30NUzVUD/uOLOA3jYcegg/
	 SwVAy6mksFLSJ+5U6avzZRBnmY8gk7PfAev5zleg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thomas Zimmermann <tzimmermann@suse.de>,
	Rodrigo Vivi <rodrigo.vivi@intel.com>,
	Petr Vorel <pvorel@suse.cz>,
	Andi Shyti <andi.shyti@linux.intel.com>,
	Danilo Krummrich <dakr@kernel.org>,
	Lyude Paul <lyude@redhat.com>,
	Jocelyn Falempe <jfalempe@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 359/395] drm/client: Remove holds_console_lock parameter from suspend/resume
Date: Wed, 30 Sep 2026 17:30:21 +0200
Message-ID: <20260930152348.474451296@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152340.591469096@linuxfoundation.org>
References: <20260930152340.591469096@linuxfoundation.org>
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

From: Thomas Zimmermann <tzimmermann@suse.de>

[ Upstream commit 7910d69376cde30e5871970d97d1a2e360568474 ]

No caller of the client resume/suspend helpers holds the console
lock. The last such cases were removed from radeon in the patch
series at [1]. Now remove the related parameter and the TODO items.

v2:
- update placeholders for CONFIG_DRM_CLIENT=n

Signed-off-by: Thomas Zimmermann <tzimmermann@suse.de>
Link: https://patchwork.freedesktop.org/series/151624/ # [1]
Reviewed-by: Rodrigo Vivi <rodrigo.vivi@intel.com>
Acked-by: Rodrigo Vivi <rodrigo.vivi@intel.com>
Reviewed-by: Petr Vorel <pvorel@suse.cz>
Reviewed-by: Andi Shyti <andi.shyti@linux.intel.com>
Acked-by: Danilo Krummrich <dakr@kernel.org>
Reviewed-by: Lyude Paul <lyude@redhat.com>
Reviewed-by: Jocelyn Falempe <jfalempe@redhat.com>
Link: https://lore.kernel.org/r/20251001143709.419736-1-tzimmermann@suse.de
Stable-dep-of: 1fca688e9443 ("drm/client: fix restore of partially initialized client")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_device.c |    8 ++++----
 drivers/gpu/drm/clients/drm_fbdev_client.c |   14 ++++----------
 drivers/gpu/drm/clients/drm_log.c          |    4 ++--
 drivers/gpu/drm/drm_client_event.c         |   16 ++++++++--------
 drivers/gpu/drm/drm_modeset_helper.c       |    6 +++---
 drivers/gpu/drm/i915/i915_driver.c         |    6 +++---
 drivers/gpu/drm/nouveau/nouveau_display.c  |    4 ++--
 drivers/gpu/drm/radeon/radeon_device.c     |    4 ++--
 drivers/gpu/drm/xe/display/xe_display.c    |    6 +++---
 include/drm/drm_client.h                   |   14 ++------------
 include/drm/drm_client_event.h             |    8 ++++----
 11 files changed, 37 insertions(+), 53 deletions(-)

--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c
@@ -5315,7 +5315,7 @@ int amdgpu_device_suspend(struct drm_dev
 		dev_warn(adev->dev, "smart shift update failed\n");
 
 	if (notify_clients)
-		drm_client_dev_suspend(adev_to_drm(adev), false);
+		drm_client_dev_suspend(adev_to_drm(adev));
 
 	cancel_delayed_work_sync(&adev->delayed_init_work);
 
@@ -5445,7 +5445,7 @@ exit:
 	flush_delayed_work(&adev->delayed_init_work);
 
 	if (notify_clients)
-		drm_client_dev_resume(adev_to_drm(adev), false);
+		drm_client_dev_resume(adev_to_drm(adev));
 
 	amdgpu_ras_resume(adev);
 
@@ -6060,7 +6060,7 @@ int amdgpu_device_reinit_after_reset(str
 				if (r)
 					goto out;
 
-				drm_client_dev_resume(adev_to_drm(tmp_adev), false);
+				drm_client_dev_resume(adev_to_drm(tmp_adev));
 
 				/*
 				 * The GPU enters bad state once faulty pages
@@ -6395,7 +6395,7 @@ static void amdgpu_device_halt_activitie
 		 */
 		amdgpu_unregister_gpu_instance(tmp_adev);
 
-		drm_client_dev_suspend(adev_to_drm(tmp_adev), false);
+		drm_client_dev_suspend(adev_to_drm(tmp_adev));
 
 		/* disable ras on ALL IPs */
 		if (!need_emergency_restart && !amdgpu_reset_in_dpc(adev) &&
--- a/drivers/gpu/drm/clients/drm_fbdev_client.c
+++ b/drivers/gpu/drm/clients/drm_fbdev_client.c
@@ -62,26 +62,20 @@ err_drm_err:
 	return ret;
 }
 
-static int drm_fbdev_client_suspend(struct drm_client_dev *client, bool holds_console_lock)
+static int drm_fbdev_client_suspend(struct drm_client_dev *client)
 {
 	struct drm_fb_helper *fb_helper = drm_fb_helper_from_client(client);
 
-	if (holds_console_lock)
-		drm_fb_helper_set_suspend(fb_helper, true);
-	else
-		drm_fb_helper_set_suspend_unlocked(fb_helper, true);
+	drm_fb_helper_set_suspend_unlocked(fb_helper, true);
 
 	return 0;
 }
 
-static int drm_fbdev_client_resume(struct drm_client_dev *client, bool holds_console_lock)
+static int drm_fbdev_client_resume(struct drm_client_dev *client)
 {
 	struct drm_fb_helper *fb_helper = drm_fb_helper_from_client(client);
 
-	if (holds_console_lock)
-		drm_fb_helper_set_suspend(fb_helper, false);
-	else
-		drm_fb_helper_set_suspend_unlocked(fb_helper, false);
+	drm_fb_helper_set_suspend_unlocked(fb_helper, false);
 
 	return 0;
 }
--- a/drivers/gpu/drm/clients/drm_log.c
+++ b/drivers/gpu/drm/clients/drm_log.c
@@ -328,7 +328,7 @@ static int drm_log_client_hotplug(struct
 	return 0;
 }
 
-static int drm_log_client_suspend(struct drm_client_dev *client, bool _console_lock)
+static int drm_log_client_suspend(struct drm_client_dev *client)
 {
 	struct drm_log *dlog = client_to_drm_log(client);
 
@@ -337,7 +337,7 @@ static int drm_log_client_suspend(struct
 	return 0;
 }
 
-static int drm_log_client_resume(struct drm_client_dev *client, bool _console_lock)
+static int drm_log_client_resume(struct drm_client_dev *client)
 {
 	struct drm_log *dlog = client_to_drm_log(client);
 
--- a/drivers/gpu/drm/drm_client_event.c
+++ b/drivers/gpu/drm/drm_client_event.c
@@ -122,7 +122,7 @@ void drm_client_dev_restore(struct drm_d
 	mutex_unlock(&dev->clientlist_mutex);
 }
 
-static int drm_client_suspend(struct drm_client_dev *client, bool holds_console_lock)
+static int drm_client_suspend(struct drm_client_dev *client)
 {
 	struct drm_device *dev = client->dev;
 	int ret = 0;
@@ -131,7 +131,7 @@ static int drm_client_suspend(struct drm
 		return 0;
 
 	if (client->funcs && client->funcs->suspend)
-		ret = client->funcs->suspend(client, holds_console_lock);
+		ret = client->funcs->suspend(client);
 	drm_dbg_kms(dev, "%s: ret=%d\n", client->name, ret);
 
 	client->suspended = true;
@@ -139,20 +139,20 @@ static int drm_client_suspend(struct drm
 	return ret;
 }
 
-void drm_client_dev_suspend(struct drm_device *dev, bool holds_console_lock)
+void drm_client_dev_suspend(struct drm_device *dev)
 {
 	struct drm_client_dev *client;
 
 	mutex_lock(&dev->clientlist_mutex);
 	list_for_each_entry(client, &dev->clientlist, list) {
 		if (!client->suspended)
-			drm_client_suspend(client, holds_console_lock);
+			drm_client_suspend(client);
 	}
 	mutex_unlock(&dev->clientlist_mutex);
 }
 EXPORT_SYMBOL(drm_client_dev_suspend);
 
-static int drm_client_resume(struct drm_client_dev *client, bool holds_console_lock)
+static int drm_client_resume(struct drm_client_dev *client)
 {
 	struct drm_device *dev = client->dev;
 	int ret = 0;
@@ -161,7 +161,7 @@ static int drm_client_resume(struct drm_
 		return 0;
 
 	if (client->funcs && client->funcs->resume)
-		ret = client->funcs->resume(client, holds_console_lock);
+		ret = client->funcs->resume(client);
 	drm_dbg_kms(dev, "%s: ret=%d\n", client->name, ret);
 
 	client->suspended = false;
@@ -172,14 +172,14 @@ static int drm_client_resume(struct drm_
 	return ret;
 }
 
-void drm_client_dev_resume(struct drm_device *dev, bool holds_console_lock)
+void drm_client_dev_resume(struct drm_device *dev)
 {
 	struct drm_client_dev *client;
 
 	mutex_lock(&dev->clientlist_mutex);
 	list_for_each_entry(client, &dev->clientlist, list) {
 		if  (client->suspended)
-			drm_client_resume(client, holds_console_lock);
+			drm_client_resume(client);
 	}
 	mutex_unlock(&dev->clientlist_mutex);
 }
--- a/drivers/gpu/drm/drm_modeset_helper.c
+++ b/drivers/gpu/drm/drm_modeset_helper.c
@@ -203,10 +203,10 @@ int drm_mode_config_helper_suspend(struc
 	if (dev->mode_config.poll_enabled)
 		drm_kms_helper_poll_disable(dev);
 
-	drm_client_dev_suspend(dev, false);
+	drm_client_dev_suspend(dev);
 	state = drm_atomic_helper_suspend(dev);
 	if (IS_ERR(state)) {
-		drm_client_dev_resume(dev, false);
+		drm_client_dev_resume(dev);
 
 		/*
 		 * Don't enable polling if it was never initialized
@@ -252,7 +252,7 @@ int drm_mode_config_helper_resume(struct
 		DRM_ERROR("Failed to resume (%d)\n", ret);
 	dev->mode_config.suspend_state = NULL;
 
-	drm_client_dev_resume(dev, false);
+	drm_client_dev_resume(dev);
 
 	/*
 	 * Don't enable polling if it is not initialized
--- a/drivers/gpu/drm/i915/i915_driver.c
+++ b/drivers/gpu/drm/i915/i915_driver.c
@@ -978,7 +978,7 @@ void i915_driver_shutdown(struct drm_i91
 	intel_runtime_pm_disable(&i915->runtime_pm);
 	intel_power_domains_disable(display);
 
-	drm_client_dev_suspend(&i915->drm, false);
+	drm_client_dev_suspend(&i915->drm);
 	if (intel_display_device_present(display)) {
 		drm_kms_helper_poll_disable(&i915->drm);
 		intel_display_driver_disable_user_access(display);
@@ -1061,7 +1061,7 @@ static int i915_drm_suspend(struct drm_d
 	/* We do a lot of poking in a lot of registers, make sure they work
 	 * properly. */
 	intel_power_domains_disable(display);
-	drm_client_dev_suspend(dev, false);
+	drm_client_dev_suspend(dev);
 	if (intel_display_device_present(display)) {
 		drm_kms_helper_poll_disable(dev);
 		intel_display_driver_disable_user_access(display);
@@ -1245,7 +1245,7 @@ static int i915_drm_resume(struct drm_de
 
 	intel_opregion_resume(display);
 
-	drm_client_dev_resume(dev, false);
+	drm_client_dev_resume(dev);
 
 	intel_power_domains_enable(display);
 
--- a/drivers/gpu/drm/nouveau/nouveau_display.c
+++ b/drivers/gpu/drm/nouveau/nouveau_display.c
@@ -764,7 +764,7 @@ nouveau_display_suspend(struct drm_devic
 {
 	struct nouveau_display *disp = nouveau_display(dev);
 
-	drm_client_dev_suspend(dev, false);
+	drm_client_dev_suspend(dev);
 
 	if (drm_drv_uses_atomic_modeset(dev)) {
 		if (!runtime) {
@@ -795,7 +795,7 @@ nouveau_display_resume(struct drm_device
 		}
 	}
 
-	drm_client_dev_resume(dev, false);
+	drm_client_dev_resume(dev);
 }
 
 int
--- a/drivers/gpu/drm/radeon/radeon_device.c
+++ b/drivers/gpu/drm/radeon/radeon_device.c
@@ -1635,7 +1635,7 @@ int radeon_suspend_kms(struct drm_device
 	}
 
 	if (notify_clients)
-		drm_client_dev_suspend(dev, false);
+		drm_client_dev_suspend(dev);
 
 	return 0;
 }
@@ -1739,7 +1739,7 @@ int radeon_resume_kms(struct drm_device
 		radeon_pm_compute_clocks(rdev);
 
 	if (notify_clients)
-		drm_client_dev_resume(dev, false);
+		drm_client_dev_resume(dev);
 
 	return 0;
 }
--- a/drivers/gpu/drm/xe/display/xe_display.c
+++ b/drivers/gpu/drm/xe/display/xe_display.c
@@ -331,7 +331,7 @@ void xe_display_pm_suspend(struct xe_dev
 	 * properly.
 	 */
 	intel_power_domains_disable(display);
-	drm_client_dev_suspend(&xe->drm, false);
+	drm_client_dev_suspend(&xe->drm);
 
 	if (intel_display_device_present(display)) {
 		drm_kms_helper_poll_disable(&xe->drm);
@@ -363,7 +363,7 @@ void xe_display_pm_shutdown(struct xe_de
 		return;
 
 	intel_power_domains_disable(display);
-	drm_client_dev_suspend(&xe->drm, false);
+	drm_client_dev_suspend(&xe->drm);
 
 	if (intel_display_device_present(display)) {
 		drm_kms_helper_poll_disable(&xe->drm);
@@ -488,7 +488,7 @@ void xe_display_pm_resume(struct xe_devi
 
 	intel_opregion_resume(display);
 
-	drm_client_dev_resume(&xe->drm, false);
+	drm_client_dev_resume(&xe->drm);
 
 	intel_power_domains_enable(display);
 }
--- a/include/drm/drm_client.h
+++ b/include/drm/drm_client.h
@@ -70,13 +70,8 @@ struct drm_client_funcs {
 	 * Called when suspending the device.
 	 *
 	 * This callback is optional.
-	 *
-	 * FIXME: Some callers hold the console lock when invoking this
-	 *        function. This interferes with fbdev emulation, which
-	 *        also tries to acquire the lock. Push the console lock
-	 *        into the callback and remove 'holds_console_lock'.
 	 */
-	int (*suspend)(struct drm_client_dev *client, bool holds_console_lock);
+	int (*suspend)(struct drm_client_dev *client);
 
 	/**
 	 * @resume:
@@ -84,13 +79,8 @@ struct drm_client_funcs {
 	 * Called when resuming the device from suspend.
 	 *
 	 * This callback is optional.
-	 *
-	 * FIXME: Some callers hold the console lock when invoking this
-	 *        function. This interferes with fbdev emulation, which
-	 *        also tries to acquire the lock. Push the console lock
-	 *        into the callback and remove 'holds_console_lock'.
 	 */
-	int (*resume)(struct drm_client_dev *client, bool holds_console_lock);
+	int (*resume)(struct drm_client_dev *client);
 };
 
 /**
--- a/include/drm/drm_client_event.h
+++ b/include/drm/drm_client_event.h
@@ -11,8 +11,8 @@ struct drm_device;
 void drm_client_dev_unregister(struct drm_device *dev);
 void drm_client_dev_hotplug(struct drm_device *dev);
 void drm_client_dev_restore(struct drm_device *dev);
-void drm_client_dev_suspend(struct drm_device *dev, bool holds_console_lock);
-void drm_client_dev_resume(struct drm_device *dev, bool holds_console_lock);
+void drm_client_dev_suspend(struct drm_device *dev);
+void drm_client_dev_resume(struct drm_device *dev);
 #else
 static inline void drm_client_dev_unregister(struct drm_device *dev)
 { }
@@ -20,9 +20,9 @@ static inline void drm_client_dev_hotplu
 { }
 static inline void drm_client_dev_restore(struct drm_device *dev)
 { }
-static inline void drm_client_dev_suspend(struct drm_device *dev, bool holds_console_lock)
+static inline void drm_client_dev_suspend(struct drm_device *dev)
 { }
-static inline void drm_client_dev_resume(struct drm_device *dev, bool holds_console_lock)
+static inline void drm_client_dev_resume(struct drm_device *dev)
 { }
 #endif
 


