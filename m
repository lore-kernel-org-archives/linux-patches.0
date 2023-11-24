Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7BA932FC36;
	Fri, 24 Nov 2023 18:35:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tru57CUi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 087E3C433C7;
	Fri, 24 Nov 2023 18:35:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700850938;
	bh=/ZhBrqptgEDY9djZdZVh36WcpKeNJIJahzIGu5fE7+E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tru57CUiU8v8VBQhoThoA0sTRNfFEzPVwW5+4nYz30JQ788/z/dVTT6jMmaUYZxwZ
	 DDDKNyeLTewA2Wx8hJmLHObf83xSoxb2zJXRCrNBoZtCkI4IDzPw3lt4kOYGgN6lV4
	 J1iFcrUKsoTpU71Y47/cA6xH6QY3RO2glSYrAAZ4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tvrtko Ursulin <tvrtko.ursulin@intel.com>,
	Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>,
	Jani Nikula <jani.nikula@intel.com>
Subject: [PATCH 6.5 224/491] i915/perf: Fix NULL deref bugs with drm_dbg() calls
Date: Fri, 24 Nov 2023 17:47:40 +0000
Message-ID: <20231124172031.284993665@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231124172024.664207345@linuxfoundation.org>
References: <20231124172024.664207345@linuxfoundation.org>
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

6.5-stable review patch.  If anyone has any objections, please let me know.

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
@@ -4286,11 +4286,8 @@ int i915_perf_open_ioctl(struct drm_devi
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
@@ -4666,11 +4663,8 @@ int i915_perf_add_config_ioctl(struct dr
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
@@ -4832,11 +4826,8 @@ int i915_perf_remove_config_ioctl(struct
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


