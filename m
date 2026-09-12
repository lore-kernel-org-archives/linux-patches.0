Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C8723876C5;
	Sat, 12 Sep 2026 09:28:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789205319; cv=none; b=OQTeCPXfC8XzOc1Vl3z4hXLnhWiSmVlc534NqHb1GZQkKUA+/3Qy5ZWaZyMnSUA5/FU5zQGtfEGUtCBd+He9zNZfYglodH3TN15H9n4VLhZE0HrP8tkCT8EDTASPR/542nas6RvOz23vjmF/DsVU1c9DKdhdU+6A9ShcSyB4xoQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789205319; c=relaxed/simple;
	bh=2LOtq/jWCinMri8uUYRf8nYGt9ttLx86Y8YSo/GPH7I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=frDo9YhSRhdR90G0fX6sZBiBxdtTDJswjt/UFTTPZcasgKrR2y2ua5A+TRT/k81xEgtc8opQWJOOkt9NJLI/gMUTapeA+A6BXv4QDWXwjzAFGDCmcH9xjS2jHG4uptHmPGWDLYMx7007qlfe+LL5fRK4zGJY37KHk+G73Lvsmjw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qKY1UjcL; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qKY1UjcL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3AB171F000FF;
	Sat, 12 Sep 2026 09:28:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789205318;
	bh=WznZ8KoM7J1k/5AqGicC9jeE62DRY4BkjvxJrV8fAD4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=qKY1UjcLDPbKtxsOkEvO5cgjOQmgH16ppV4F7b9ie64XkMc6nT/18qbCmblwZBQxM
	 BeTStgACQ2l03LliauabS6GAPf8mKzoASLE7CCJt6Ag63VR1UZYyT6AapqrJpTL3wW
	 09gu+dUFSXBNCQvM3Bkj2FUwWeKIc1sRzjq42yqQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Aravind Iddamsetty <aravind.iddamsetty@linux.intel.com>,
	Mallesh Koujalagi <mallesh.koujalagi@intel.com>,
	Rodrigo Vivi <rodrigo.vivi@intel.com>,
	Riana Tauro <riana.tauro@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 1794/1815] drm/xe/uapi: Add additional error components to xe drm_ras
Date: Sat, 12 Sep 2026 08:59:04 +0200
Message-ID: <20260912065731.152523608@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Riana Tauro <riana.tauro@intel.com>

[ Upstream commit cdeb5e248de11537cf23cd5174f6c55bab2e850b ]

Add additional Error components supported by XE drm_ras (Reliability,
Availability and Serviceability).

Reviewed-by: Aravind Iddamsetty <aravind.iddamsetty@linux.intel.com>
Reviewed-by: Mallesh Koujalagi <mallesh.koujalagi@intel.com>
Acked-by: Rodrigo Vivi <rodrigo.vivi@intel.com>
Link: https://patch.msgid.link/20260618060633.2790109-9-riana.tauro@intel.com
Signed-off-by: Riana Tauro <riana.tauro@intel.com>
Stable-dep-of: a62212b35a21 ("drm/xe/sysctrl: Read mailbox phase bit from hardware")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/uapi/drm/xe_drm.h | 11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

diff --git a/include/uapi/drm/xe_drm.h b/include/uapi/drm/xe_drm.h
index 48e9f1fdb78dd..50c80af4ad4ef 100644
--- a/include/uapi/drm/xe_drm.h
+++ b/include/uapi/drm/xe_drm.h
@@ -2589,6 +2589,12 @@ enum drm_xe_ras_error_component {
 	DRM_XE_RAS_ERR_COMP_CORE_COMPUTE = 1,
 	/** @DRM_XE_RAS_ERR_COMP_SOC_INTERNAL: SoC Internal Error */
 	DRM_XE_RAS_ERR_COMP_SOC_INTERNAL,
+	/** @DRM_XE_RAS_ERR_COMP_DEVICE_MEMORY: Device Memory Error */
+	DRM_XE_RAS_ERR_COMP_DEVICE_MEMORY,
+	/** @DRM_XE_RAS_ERR_COMP_PCIE: PCIe Subsystem Error */
+	DRM_XE_RAS_ERR_COMP_PCIE,
+	/** @DRM_XE_RAS_ERR_COMP_FABRIC: Fabric Subsystem Error */
+	DRM_XE_RAS_ERR_COMP_FABRIC,
 	/** @DRM_XE_RAS_ERR_COMP_MAX: Max Error */
 	DRM_XE_RAS_ERR_COMP_MAX	/* non-ABI */
 };
@@ -2606,7 +2612,10 @@ enum drm_xe_ras_error_component {
  */
 #define DRM_XE_RAS_ERROR_COMPONENT_NAMES {				\
 	[DRM_XE_RAS_ERR_COMP_CORE_COMPUTE] = "core-compute",		\
-	[DRM_XE_RAS_ERR_COMP_SOC_INTERNAL] = "soc-internal"		\
+	[DRM_XE_RAS_ERR_COMP_SOC_INTERNAL] = "soc-internal",		\
+	[DRM_XE_RAS_ERR_COMP_DEVICE_MEMORY] = "device-memory",		\
+	[DRM_XE_RAS_ERR_COMP_PCIE] = "pcie",				\
+	[DRM_XE_RAS_ERR_COMP_FABRIC] = "fabric",			\
 }
 
 #if defined(__cplusplus)
-- 
2.53.0



