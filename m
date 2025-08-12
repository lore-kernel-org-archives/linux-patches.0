Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A52752D3ED6;
	Tue, 12 Aug 2025 18:36:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755023768; cv=none; b=lagHIFQZ3NA8SU8hyIXfW2cQZkeZUCqls4JEx4sQm9RmE8t40dlHRdmmI1gWcqD3ddEiS+DjY6AL6at4XcdrwV0VzEhk4p6RcmYB4GCxnwOZyI+lYYYGKcqeN+n6435HnzDRDSbXkTJITDjxHn3ZAb+qwyccadaEhByiXW/pZfw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755023768; c=relaxed/simple;
	bh=guyrkRMrllV9HqkL3i+bqyRDV514Vw3V/Rt0GdsZsCw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DTl2HmMoFL7Vd97XrFLxU39zPpANngJhmpFMTIiE5hYPD9C0+7oEgc8spprIzKgcqJuoIiGy0xZNOeIlG3rpMRtOnzTA4bOkdYcpCDboGBYYW/Y4NixTpzEedvJaiAwbpYTJcphn63yJ2aw4XMXeJyXaIrqGVsZti4zSsLILexI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cDL5FtBm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cDL5FtBm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 19417C4CEF0;
	Tue, 12 Aug 2025 18:36:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755023768;
	bh=guyrkRMrllV9HqkL3i+bqyRDV514Vw3V/Rt0GdsZsCw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cDL5FtBmE42PrhMbyqqQnblaQYWmnXkfOxrUSJkicSGRSIVAkXs1QewMIVG9gkweY
	 zahyXSRqB2dvoZ2XiaXr+6jm64J3kWk1wsuhLvjql25KT/0YCE3OUsQDYjboZDtasf
	 8kwIMYd5l+FbYLYrcZd1WYY2l7I8XJTq5boEp6ZI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lucas De Marchi <lucas.demarchi@intel.com>,
	Rodrigo Vivi <rodrigo.vivi@intel.com>,
	Francois Dugast <francois.dugast@intel.com>,
	Zongyao Bai <zongyao.bai@intel.com>,
	Shuicheng Lin <shuicheng.lin@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 168/627] drm/xe/uapi: Correct sync type definition in comments
Date: Tue, 12 Aug 2025 19:27:43 +0200
Message-ID: <20250812173425.673362383@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812173419.303046420@linuxfoundation.org>
References: <20250812173419.303046420@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Shuicheng Lin <shuicheng.lin@intel.com>

[ Upstream commit 771f002ef1d6f6c2b9bddf779abd31da6b9ccd25 ]

Commit 37d078e51b4c ("drm/xe/uapi: Split xe_sync types from flags") renamed some DRM_XE_SYNC_*
defines but later commits kept using the old names. Correct them with the new definition.

v2: correct fixes tag and update commit message to explain why (Lucas)

Fixes: 9329f0667215 ("drm/xe/uapi: Use LR abbrev for long-running vms")
Fixes: 4b437893a826 ("drm/xe/uapi: More uAPI documentation additions and cosmetic updates")
Reviewed-by: Lucas De Marchi <lucas.demarchi@intel.com>
Cc: Rodrigo Vivi <rodrigo.vivi@intel.com>
Cc: Francois Dugast <francois.dugast@intel.com>
Cc: Zongyao Bai <zongyao.bai@intel.com>
Signed-off-by: Shuicheng Lin <shuicheng.lin@intel.com>
Link: https://lore.kernel.org/r/20250608230133.1250849-1-shuicheng.lin@intel.com
Signed-off-by: Rodrigo Vivi <rodrigo.vivi@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/uapi/drm/xe_drm.h | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/include/uapi/drm/xe_drm.h b/include/uapi/drm/xe_drm.h
index 6a702ba7817c..5f1524f466a7 100644
--- a/include/uapi/drm/xe_drm.h
+++ b/include/uapi/drm/xe_drm.h
@@ -925,9 +925,9 @@ struct drm_xe_gem_mmap_offset {
  *  - %DRM_XE_VM_CREATE_FLAG_LR_MODE - An LR, or Long Running VM accepts
  *    exec submissions to its exec_queues that don't have an upper time
  *    limit on the job execution time. But exec submissions to these
- *    don't allow any of the flags DRM_XE_SYNC_FLAG_SYNCOBJ,
- *    DRM_XE_SYNC_FLAG_TIMELINE_SYNCOBJ, DRM_XE_SYNC_FLAG_DMA_BUF,
- *    used as out-syncobjs, that is, together with DRM_XE_SYNC_FLAG_SIGNAL.
+ *    don't allow any of the sync types DRM_XE_SYNC_TYPE_SYNCOBJ,
+ *    DRM_XE_SYNC_TYPE_TIMELINE_SYNCOBJ, used as out-syncobjs, that is,
+ *    together with sync flag DRM_XE_SYNC_FLAG_SIGNAL.
  *    LR VMs can be created in recoverable page-fault mode using
  *    DRM_XE_VM_CREATE_FLAG_FAULT_MODE, if the device supports it.
  *    If that flag is omitted, the UMD can not rely on the slightly
@@ -1394,7 +1394,7 @@ struct drm_xe_sync {
 
 	/**
 	 * @timeline_value: Input for the timeline sync object. Needs to be
-	 * different than 0 when used with %DRM_XE_SYNC_FLAG_TIMELINE_SYNCOBJ.
+	 * different than 0 when used with %DRM_XE_SYNC_TYPE_TIMELINE_SYNCOBJ.
 	 */
 	__u64 timeline_value;
 
-- 
2.39.5



