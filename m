Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 39CBC522E
	for <patches@lists.linux.dev>; Sun,  9 Jul 2023 11:24:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A8409C433C7;
	Sun,  9 Jul 2023 11:24:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1688901881;
	bh=9mQI9P0EIdJZ0uB4pcz8h1Up7WJsP3FEMOp8pEw6fqM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GHXOeTBjpW/5pWQifJxIliDLHrt3GyJdyDZoyRb6MNccLinYn2Y1aGkNPTBZibZl1
	 d78nH08UytdlCeYN0ulKTDSzoq8iWk9ktoB+7S0FpkpeIViBx3VJzV3vWNnx6K7S+q
	 26kP43scvr83nQWKdFGqyP+3fM9IOnUDHWeZgtVM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Luc Ma <luc@sietium.com>,
	Thomas Zimmermann <tzimmermann@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.3 177/431] drm/vram-helper: fix function names in vram helper doc
Date: Sun,  9 Jul 2023 13:12:05 +0200
Message-ID: <20230709111455.322576354@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230709111451.101012554@linuxfoundation.org>
References: <20230709111451.101012554@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Luc Ma <luc@sietium.com>

[ Upstream commit b8e392245105b50706f18418054821e71e637288 ]

Refer to drmm_vram_helper_init() instead of the non-existent
drmm_vram_helper_alloc_mm().

Fixes: a5f23a72355d ("drm/vram-helper: Managed vram helpers")
Signed-off-by: Luc Ma <luc@sietium.com>
Reviewed-by: Thomas Zimmermann <tzimmermann@suse.de>
Signed-off-by: Thomas Zimmermann <tzimmermann@suse.de>
Link: https://patchwork.freedesktop.org/patch/msgid/64583db2.630a0220.eb75d.8f51@mx.google.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/drm_gem_vram_helper.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/gpu/drm/drm_gem_vram_helper.c b/drivers/gpu/drm/drm_gem_vram_helper.c
index d40b3edb52d07..f1539d4448c69 100644
--- a/drivers/gpu/drm/drm_gem_vram_helper.c
+++ b/drivers/gpu/drm/drm_gem_vram_helper.c
@@ -45,7 +45,7 @@ static const struct drm_gem_object_funcs drm_gem_vram_object_funcs;
  * the frame's scanout buffer or the cursor image. If there's no more space
  * left in VRAM, inactive GEM objects can be moved to system memory.
  *
- * To initialize the VRAM helper library call drmm_vram_helper_alloc_mm().
+ * To initialize the VRAM helper library call drmm_vram_helper_init().
  * The function allocates and initializes an instance of &struct drm_vram_mm
  * in &struct drm_device.vram_mm . Use &DRM_GEM_VRAM_DRIVER to initialize
  * &struct drm_driver and  &DRM_VRAM_MM_FILE_OPERATIONS to initialize
@@ -73,7 +73,7 @@ static const struct drm_gem_object_funcs drm_gem_vram_object_funcs;
  *		// setup device, vram base and size
  *		// ...
  *
- *		ret = drmm_vram_helper_alloc_mm(dev, vram_base, vram_size);
+ *		ret = drmm_vram_helper_init(dev, vram_base, vram_size);
  *		if (ret)
  *			return ret;
  *		return 0;
@@ -86,7 +86,7 @@ static const struct drm_gem_object_funcs drm_gem_vram_object_funcs;
  * to userspace.
  *
  * You don't have to clean up the instance of VRAM MM.
- * drmm_vram_helper_alloc_mm() is a managed interface that installs a
+ * drmm_vram_helper_init() is a managed interface that installs a
  * clean-up handler to run during the DRM device's release.
  *
  * For drawing or scanout operations, rsp. buffer objects have to be pinned
-- 
2.39.2



