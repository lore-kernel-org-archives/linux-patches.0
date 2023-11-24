Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F352233CF2;
	Fri, 24 Nov 2023 19:17:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YZrxtXnq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7ACB9C433C8;
	Fri, 24 Nov 2023 19:17:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700853421;
	bh=4asxgE+vleOEvkKmvtx01IEZSCzC0hzKarsug29TiAM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YZrxtXnqw5nQ8kO/qjkNIj9h8BbuP9msHnYpIctvMXlM3SUdhkd1i1+xpQ7IyfONs
	 MIMM3rHmux8Wy41yrSdj7Bq3Yl7W9GTuF6CkR3AcALcu53c35HK3GEWHFzlA4E7GVO
	 DRwTckc556IqOK++malzocOWld49VoSDC3WQr0vo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tvrtko Ursulin <tvrtko.ursulin@intel.com>,
	Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>,
	Jani Nikula <jani.nikula@intel.com>
Subject: [PATCH 5.15 155/297] i915/perf: Fix NULL deref bugs with drm_dbg() calls
Date: Fri, 24 Nov 2023 17:53:17 +0000
Message-ID: <20231124172005.685972763@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231124172000.087816911@linuxfoundation.org>
References: <20231124172000.087816911@linuxfoundation.org>
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

From: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>

commit 471aa951bf1206d3c10d0daa67005b8e4db4ff83 upstream.

When i915 perf interface is not available dereferencing it will lead to
NULL dereferences.

As returning -ENOTSUPP is pretty clear return when perf interface is not
available.

Fixes: 2fec539112e8 ("i915/perf: Replace DRM_DEBUG with driver specific drm_dbg call")
Suggested-by: Tvrtko Ursulin <tvrtko.ursulin@intel.com>
Signed-off-by: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
Reviewed-by: Tvrtko Ursulin <tvrtko.ursulin@intel.com>
Cc: <stable@vger.kernel.org> # v6.0+
Signed-off-by: Tvrtko Ursulin <tvrtko.ursulin@intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20231027172822.2753059-1-harshit.m.mogalapalli@oracle.com
[tursulin: added stable tag]
(cherry picked from commit 36f27350ff745bd228ab04d7845dfbffc177a889)
Signed-off-by: Jani Nikula <jani.nikula@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/i915/i915_perf.c |   15 +++------------
 1 file changed, 3 insertions(+), 12 deletions(-)

--- a/drivers/gpu/drm/i915/i915_perf.c
+++ b/drivers/gpu/drm/i915/i915_perf.c
@@ -3795,11 +3795,8 @@ int i915_perf_open_ioctl(struct drm_devi
 	u32 known_open_flags;
 	int ret;
 
-	if (!perf->i915) {
-		drm_dbg(&perf->i915->drm,
-			"i915 perf interface not available for this system\n");
+	if (!perf->i915)
 		return -ENOTSUPP;
-	}
 
 	known_open_flags = I915_PERF_FLAG_FD_CLOEXEC |
 			   I915_PERF_FLAG_FD_NONBLOCK |
@@ -4090,11 +4087,8 @@ int i915_perf_add_config_ioctl(struct dr
 	struct i915_oa_reg *regs;
 	int err, id;
 
-	if (!perf->i915) {
-		drm_dbg(&perf->i915->drm,
-			"i915 perf interface not available for this system\n");
+	if (!perf->i915)
 		return -ENOTSUPP;
-	}
 
 	if (!perf->metrics_kobj) {
 		drm_dbg(&perf->i915->drm,
@@ -4256,11 +4250,8 @@ int i915_perf_remove_config_ioctl(struct
 	struct i915_oa_config *oa_config;
 	int ret;
 
-	if (!perf->i915) {
-		drm_dbg(&perf->i915->drm,
-			"i915 perf interface not available for this system\n");
+	if (!perf->i915)
 		return -ENOTSUPP;
-	}
 
 	if (i915_perf_stream_paranoid && !perfmon_capable()) {
 		drm_dbg(&perf->i915->drm,


