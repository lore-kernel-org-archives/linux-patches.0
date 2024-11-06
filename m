Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E6871E04B3;
	Wed,  6 Nov 2024 12:35:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730896528; cv=none; b=Hu6zcA+Qx7w1QSM6cOlTRHx9MYjKojI5JyUD5nMrbgRfXykkHAGo+kltKYthKZSpWVuI2/ve/KpTfQNepWMXVI9ZxkporwEnvl0S1grr+m8/KYbClcOxiba55pgjHVDGg0HEGOtfhI4erVxSx5+6nqFBfl2EOPevIOHkiJXn5xM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730896528; c=relaxed/simple;
	bh=0lXNtmDJSvBelYjV9DHu5MC34k5IGXYuc6iQVJk8R04=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Doc8m1PwjWkp6NBVV1cTtvpP1YDy0MLwlWnpxqI2WW9G3/YvkbwVjP12b1PGxn0q7RaYkAWFuDl+0sNfOJc3Hme5jpDsVQYrOkDXC6y8IKLaEzHCGPWdRzfK6ngGvel6uWXxTLDrnJ0aaQ3FUk4Vy0qY9NuQbNmqp35Y9dvemEU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qkSSlvNj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qkSSlvNj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C34B5C4CED3;
	Wed,  6 Nov 2024 12:35:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730896528;
	bh=0lXNtmDJSvBelYjV9DHu5MC34k5IGXYuc6iQVJk8R04=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qkSSlvNjMHyR0z3PslruoYnO3HLzrRaqYY5rlv5BuDxfQVE+TCTx9FflXcORwCu6a
	 JGac36sJkG4+DeH/OVDejlarlWVf8FFLn59CxUr70eD7OwI5jIF6cbUHp5uxhywjTa
	 sxj6UGxXfxILy0SS8UGKjH8ca3w38nvNc8K2NtKw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Ville=20Syrj=C3=A4l=C3=A4?= <ville.syrjala@linux.intel.com>,
	Maarten Lankhorst <maarten.lankhorst@linux.intel.com>,
	Jani Nikula <jani.nikula@intel.com>,
	Lucas De Marchi <lucas.demarchi@intel.com>
Subject: [PATCH 6.11 231/245] drm/xe/display: drop unused rawclk_freq and RUNTIME_INFO()
Date: Wed,  6 Nov 2024 13:04:44 +0100
Message-ID: <20241106120324.948007579@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241106120319.234238499@linuxfoundation.org>
References: <20241106120319.234238499@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jani Nikula <jani.nikula@intel.com>

commit f15e5587448989a55cf8b4feaad0df72ca3aa6a0 upstream.

With rawclk_freq moved to display runtime info, xe has no users left for
them.

Reviewed-by: Ville Syrjälä <ville.syrjala@linux.intel.com>
Reviewed-by: Maarten Lankhorst <maarten.lankhorst@linux.intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/9f09274bddc14f555c0102f37af6df23b4433102.1724144570.git.jani.nikula@intel.com
Signed-off-by: Jani Nikula <jani.nikula@intel.com>
Signed-off-by: Lucas De Marchi <lucas.demarchi@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/xe/compat-i915-headers/i915_drv.h |    1 -
 drivers/gpu/drm/xe/xe_device_types.h              |    6 ------
 2 files changed, 7 deletions(-)

--- a/drivers/gpu/drm/xe/compat-i915-headers/i915_drv.h
+++ b/drivers/gpu/drm/xe/compat-i915-headers/i915_drv.h
@@ -116,7 +116,6 @@ struct i915_sched_attr {
 #define i915_gem_fence_wait_priority(fence, attr) do { (void) attr; } while (0)
 
 #define pdev_to_i915 pdev_to_xe_device
-#define RUNTIME_INFO(xe)		(&(xe)->info.i915_runtime)
 
 #define FORCEWAKE_ALL XE_FORCEWAKE_ALL
 
--- a/drivers/gpu/drm/xe/xe_device_types.h
+++ b/drivers/gpu/drm/xe/xe_device_types.h
@@ -297,12 +297,6 @@ struct xe_device {
 		u8 has_atomic_enable_pte_bit:1;
 		/** @info.has_device_atomics_on_smem: Supports device atomics on SMEM */
 		u8 has_device_atomics_on_smem:1;
-
-#if IS_ENABLED(CONFIG_DRM_XE_DISPLAY)
-		struct {
-			u32 rawclk_freq;
-		} i915_runtime;
-#endif
 	} info;
 
 	/** @irq: device interrupt state */


