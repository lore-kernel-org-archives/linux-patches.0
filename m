Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 42DF613BC0C;
	Mon, 23 Dec 2024 16:06:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734970005; cv=none; b=D/z5Cxrr1uMSQIy3NckSJZMBC/tOZ82OI5XqNND4CQ6bRVipZjVLI7tUDaG9i7DtqqXZnsWNdanlnfCrOY3AVhk55PrVLD3kLPfDD5H3lY4+NcWRzLpGV9STrx8Vwn9XxrtK9c1NpHzYOBQakz96uIlIcBQmGIVBDvgKDjjMhB8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734970005; c=relaxed/simple;
	bh=mDFFdIMmgeXLLABjJ/bCJu+QYKXQZ5kROREHqUJqkgE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UWnPuNxclGXlzV2IMMTsltevUmosnHeQLcoGetrqva7OZpTfPRg6Jjam6nAH+qFzhiuE9EfpwTVvi0kziicuKQmNrXuVR06ocrwnZlOUDAXhj8YDBQLtrvY/yciVB4vEjrD4gyQNtQVeDYuNlT0bNvp6oDZZHP/tOxdHxbsEbLM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=csU87te5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="csU87te5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A5B50C4CED3;
	Mon, 23 Dec 2024 16:06:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734970005;
	bh=mDFFdIMmgeXLLABjJ/bCJu+QYKXQZ5kROREHqUJqkgE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=csU87te5XN3c9xGqCG/SM7FOQ55sRvsDkzhvGv9W67lXkXqDs5Q325YLKA1TRSAUn
	 ijfgoaU5Yz76ugdgRZev5z376nqDx3eBHkT5GgPmDGkTbQRaAPBVvcNPpfAtTaVtZe
	 8kNOKCsBPCKzf93jyh95aFmkwfYO+KyYBHFAeCyw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Imre Deak <imre.deak@intel.com>,
	Krzysztof Karas <krzysztof.karas@intel.com>,
	Andi Shyti <andi.shyti@linux.intel.com>
Subject: [PATCH 6.12 085/160] drm/display: use ERR_PTR on DP tunnel manager creation fail
Date: Mon, 23 Dec 2024 16:58:16 +0100
Message-ID: <20241223155411.981243190@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241223155408.598780301@linuxfoundation.org>
References: <20241223155408.598780301@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Krzysztof Karas <krzysztof.karas@intel.com>

commit 080b2e7b5e9ad23343e4b11f0751e4c724a78958 upstream.

Instead of returning a generic NULL on error from
drm_dp_tunnel_mgr_create(), use error pointers with informative codes
to align the function with stub that is executed when
CONFIG_DRM_DISPLAY_DP_TUNNEL is unset. This will also trigger IS_ERR()
in current caller (intel_dp_tunnerl_mgr_init()) instead of bypassing it
via NULL pointer.

v2: use error codes inside drm_dp_tunnel_mgr_create() instead of handling
 on caller's side (Michal, Imre)

v3: fixup commit message and add "CC"/"Fixes" lines (Andi),
 mention aligning function code with stub

Fixes: 91888b5b1ad2 ("drm/i915/dp: Add support for DP tunnel BW allocation")
Cc: Imre Deak <imre.deak@intel.com>
Cc: <stable@vger.kernel.org> # v6.9+
Signed-off-by: Krzysztof Karas <krzysztof.karas@intel.com>
Reviewed-by: Andi Shyti <andi.shyti@linux.intel.com>
Signed-off-by: Imre Deak <imre.deak@intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/7q4fpnmmztmchczjewgm6igy55qt6jsm7tfd4fl4ucfq6yg2oy@q4lxtsu6445c
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/display/drm_dp_tunnel.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/gpu/drm/display/drm_dp_tunnel.c b/drivers/gpu/drm/display/drm_dp_tunnel.c
index 48b2df120086..90fe07a89260 100644
--- a/drivers/gpu/drm/display/drm_dp_tunnel.c
+++ b/drivers/gpu/drm/display/drm_dp_tunnel.c
@@ -1896,8 +1896,8 @@ static void destroy_mgr(struct drm_dp_tunnel_mgr *mgr)
  *
  * Creates a DP tunnel manager for @dev.
  *
- * Returns a pointer to the tunnel manager if created successfully or NULL in
- * case of an error.
+ * Returns a pointer to the tunnel manager if created successfully or error
+ * pointer in case of failure.
  */
 struct drm_dp_tunnel_mgr *
 drm_dp_tunnel_mgr_create(struct drm_device *dev, int max_group_count)
@@ -1907,7 +1907,7 @@ drm_dp_tunnel_mgr_create(struct drm_device *dev, int max_group_count)
 
 	mgr = kzalloc(sizeof(*mgr), GFP_KERNEL);
 	if (!mgr)
-		return NULL;
+		return ERR_PTR(-ENOMEM);
 
 	mgr->dev = dev;
 	init_waitqueue_head(&mgr->bw_req_queue);
@@ -1916,7 +1916,7 @@ drm_dp_tunnel_mgr_create(struct drm_device *dev, int max_group_count)
 	if (!mgr->groups) {
 		kfree(mgr);
 
-		return NULL;
+		return ERR_PTR(-ENOMEM);
 	}
 
 #ifdef CONFIG_DRM_DISPLAY_DP_TUNNEL_STATE_DEBUG
@@ -1927,7 +1927,7 @@ drm_dp_tunnel_mgr_create(struct drm_device *dev, int max_group_count)
 		if (!init_group(mgr, &mgr->groups[i])) {
 			destroy_mgr(mgr);
 
-			return NULL;
+			return ERR_PTR(-ENOMEM);
 		}
 
 		mgr->group_count++;
-- 
2.47.1



