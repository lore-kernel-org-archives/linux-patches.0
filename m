Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795621834;
	b=sOpTFibt/wrRPzTUbwvwE33rvq5kbu2CSUkLTLAuY+53tHwr/sgWSd/fPGNT4l++j9/Q
	 FzgDsuNtP6Jakhwh9R0x1G8VlGSyr7EVuVIEyyS2Qk+vptG6vkoXB4DKbcAF9rGAe7X1v
	 7LhqyQBuI7dLkFItYlWoClb0YXZWVZqUf5CzYj2k2i1bVfG+GJ6uW8wLJwIJq/nAfBax3
	 AASM5+9RG+LXYLl7bcp1jQbm7X+69R3qjK4tck/2qfS92iPflgbbWYgSqC43ybFon+YqK
	 PROHyjMj2tnf6VsAd59dWd+JI0nnZNXeFFFljpALyysmX3mSnairs63x3dujvwHUV4g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795621834;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=vGP32jZaEG7FrBLIL15Lzpm8Zf10A/vo4lFQKHt1NI0=;
	b=5n2CsshYoGi+PLRy1B3QMg5EFPibkntx0g31Wbuf0A0R/U0FqIC2ScSsuMEThnzMTo9N
	 sht7RUhXJ4Y9bv24VGKjWkwgDYx7UkINmPy+Uhl9F9Swiz7Lw66sypYGUi/ypW7e3jjX4
	 Yj61VjDy/x26NLdP+ySBh6jhOTOWJCUIPU6+Cf6e/Xe1biF7CVBr36aHghnlsROuISv8V
	 q1uorYObuu5dSzLIq5XgjIRiS/g7bpfmbJs9D61VzkZ70Hf8EbtnqqAZPcL57d6VwCckc
	 cowa8TNOzMnIfhySMulv7lJ/PXl+ogugmki2DJU2eaThHA6/S3f+fp6B8wmUToQmSQA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=WLQ7l9S7;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 22B74606A33B;
	Wed, 25 Nov 2026 15:50:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=WLQ7l9S7
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B90A51F000D1;
	Wed, 25 Nov 2026 15:50:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795621833;
	bh=vGP32jZaEG7FrBLIL15Lzpm8Zf10A/vo4lFQKHt1NI0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=WLQ7l9S7CSgmRa8LK3cv7g3MyFhLD6gsPYnvUHe0gmgIYZAGnEvxcdlfrf+hxI3xN
	 cnkd4Q29VZjoUA0J/zAd8UPPxL7eDpuQtcIQArEuPMFjlNYsMxfQKqYWiHxuW42X2Z
	 RJhxIpy/hzgUoSXOYwg+LYW2LCcQvOVMdY03MoWE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mallesh Koujalagi <mallesh.koujalagi@intel.com>,
	Raag Jadav <raag.jadav@intel.com>,
	Rodrigo Vivi <rodrigo.vivi@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 347/990] drm/xe/xe_survivability: Simplify runtime survivability error handling
Date: Wed, 25 Nov 2026 15:28:34 +0100
Message-ID: <20261125143830.221107061@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143822.072087159@linuxfoundation.org>
References: <20261125143822.072087159@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mallesh Koujalagi <mallesh.koujalagi@intel.com>

[ Upstream commit 2b8c1d7fe0d521f9d264ef08c15760235e61c341 ]

xe_survivability_mode_runtime_enable() returns an int, but its caller
csc_hw_error_work() ignores the return value and cannot take any
meaningful recovery action on failure. The function logs errors via
dev_err() and proceeds to declare the device wedged regardless of
sysfs creation failure, making the return value redundant.

Change the return type to void and remove the unnecessary
error handling in the caller.

v2:
- Return is not require after the sysfs creation fail. (Rodrigo/Riana)
- Change int to void return type. (Rodrigo)
- Remove extra message from csc_hw_error_work().

v3:
- Remove ret variable. (Raag)

v4:
- Drop ret variable from other part of code.

v5:
- Reframe as refactoring instead of bug fix. (Raag)
- Remove Fixes tag and update subject line.

Signed-off-by: Mallesh Koujalagi <mallesh.koujalagi@intel.com>
Reviewed-by: Raag Jadav <raag.jadav@intel.com>
Link: https://patch.msgid.link/20260504110300.1467303-2-mallesh.koujalagi@intel.com
Signed-off-by: Rodrigo Vivi <rodrigo.vivi@intel.com>
Stable-dep-of: a890a885b982 ("drm/xe/hw_error: Guard csc_hw_error_work() with runtime PM")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/xe/xe_hw_error.c           |  5 +----
 drivers/gpu/drm/xe/xe_survivability_mode.c | 14 ++++----------
 drivers/gpu/drm/xe/xe_survivability_mode.h |  2 +-
 3 files changed, 6 insertions(+), 15 deletions(-)

diff --git a/drivers/gpu/drm/xe/xe_hw_error.c b/drivers/gpu/drm/xe/xe_hw_error.c
index 8c65291f36fc0..3c105269e6fa8 100644
--- a/drivers/gpu/drm/xe/xe_hw_error.c
+++ b/drivers/gpu/drm/xe/xe_hw_error.c
@@ -55,11 +55,8 @@ static void csc_hw_error_work(struct work_struct *work)
 {
 	struct xe_tile *tile = container_of(work, typeof(*tile), csc_hw_error_work);
 	struct xe_device *xe = tile_to_xe(tile);
-	int ret;
 
-	ret = xe_survivability_mode_runtime_enable(xe);
-	if (ret)
-		drm_err(&xe->drm, "Failed to enable runtime survivability mode\n");
+	xe_survivability_mode_runtime_enable(xe);
 }
 
 static void csc_hw_error_handler(struct xe_tile *tile, const enum hardware_error hw_err)
diff --git a/drivers/gpu/drm/xe/xe_survivability_mode.c b/drivers/gpu/drm/xe/xe_survivability_mode.c
index b6ff5da86a4df..ee4225d57972b 100644
--- a/drivers/gpu/drm/xe/xe_survivability_mode.c
+++ b/drivers/gpu/drm/xe/xe_survivability_mode.c
@@ -374,25 +374,21 @@ bool xe_survivability_mode_is_requested(struct xe_device *xe)
  * Runtime survivability mode is enabled when certain errors cause the device to be
  * in non-recoverable state. The device is declared wedged with the appropriate
  * recovery method and survivability mode sysfs exposed to userspace
- *
- * Return: 0 if runtime survivability mode is enabled, negative error code otherwise.
  */
-int xe_survivability_mode_runtime_enable(struct xe_device *xe)
+void xe_survivability_mode_runtime_enable(struct xe_device *xe)
 {
 	struct xe_survivability *survivability = &xe->survivability;
 	struct pci_dev *pdev = to_pci_dev(xe->drm.dev);
-	int ret;
 
 	if (!IS_DGFX(xe) || IS_SRIOV_VF(xe) || xe->info.platform < XE_BATTLEMAGE) {
 		dev_err(&pdev->dev, "Runtime Survivability Mode not supported\n");
-		return -EINVAL;
+		return;
 	}
 
 	populate_survivability_info(xe);
 
-	ret = create_survivability_sysfs(pdev);
-	if (ret)
-		dev_err(&pdev->dev, "Failed to create survivability mode sysfs\n");
+	if (create_survivability_sysfs(pdev))
+		dev_err(&pdev->dev, "Failed to create survivability sysfs\n");
 
 	survivability->type = XE_SURVIVABILITY_TYPE_RUNTIME;
 	dev_err(&pdev->dev, "Runtime Survivability mode enabled\n");
@@ -400,8 +396,6 @@ int xe_survivability_mode_runtime_enable(struct xe_device *xe)
 	xe_device_set_wedged_method(xe, DRM_WEDGE_RECOVERY_VENDOR);
 	xe_device_declare_wedged(xe);
 	dev_err(&pdev->dev, "Firmware flash required, Please refer to the userspace documentation for more details!\n");
-
-	return 0;
 }
 
 /**
diff --git a/drivers/gpu/drm/xe/xe_survivability_mode.h b/drivers/gpu/drm/xe/xe_survivability_mode.h
index 1cc94226aa82d..cd040e4d18bb8 100644
--- a/drivers/gpu/drm/xe/xe_survivability_mode.h
+++ b/drivers/gpu/drm/xe/xe_survivability_mode.h
@@ -11,7 +11,7 @@
 struct xe_device;
 
 int xe_survivability_mode_boot_enable(struct xe_device *xe);
-int xe_survivability_mode_runtime_enable(struct xe_device *xe);
+void xe_survivability_mode_runtime_enable(struct xe_device *xe);
 bool xe_survivability_mode_is_boot_enabled(struct xe_device *xe);
 bool xe_survivability_mode_is_requested(struct xe_device *xe);
 
-- 
2.53.0



