Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3392D155CBA;
	Mon, 16 Sep 2024 12:04:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726488296; cv=none; b=kvagGaHwsV1VN8ElYEH/LGl1EYVtwFcyeFUr7aWc8bd9loB+QcFXgMl6sbuHJ7lwjHCj6c7gQeRlKVplxT5QiIkFXZ3d57PHr/5b5M/IG9El2vlFx2kolhlewS+CfDnNffay/bxPcML2Yt49cR20LNgGMvTDXop2hWKTllEdgNg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726488296; c=relaxed/simple;
	bh=E1JI0cCX5akb6grfeoaiKh2+0q5qSG5uR+6cUoxbXSY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XZ3gDtd9AOTpu2WC46CccGj1e/8FmHjjDnlC/oyWZ3r71zFzdTlh0VBExERQhYNGHsYcQGgaYyIMiFg57DSbbrDOas+/ezM1aR9pq6Y3JlC3bTGIFiq0tOGbXZnTIgo6zD4r85wz5zFFqWlOw5rDbSIsJ6P3vQ7qTgeC2Q3TeIU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uTIY6sgz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uTIY6sgz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A1803C4CEC4;
	Mon, 16 Sep 2024 12:04:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1726488296;
	bh=E1JI0cCX5akb6grfeoaiKh2+0q5qSG5uR+6cUoxbXSY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uTIY6sgzsj09vghbBcFNGQI6oYvMhutN9NMOU/l/ug3NGvjd9GDVOENtPPdJtEkqK
	 MMs4w79SSr5tgbWHpQp9bEETM08DBcAIj1EQkvjOsLOfYOR3Dc8YLxutHWC0jmZr9P
	 N7GdkoMVt3DBHGIMrV3VysIkFnWnSd2kKQHbpqaQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daniele Ceraolo Spurio <daniele.ceraolospurio@intel.com>,
	Lucas De Marchi <lucas.demarchi@intel.com>,
	Matthew Auld <matthew.auld@intel.com>,
	Rodrigo Vivi <rodrigo.vivi@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 037/121] drm/xe: use devm instead of drmm for managed bo
Date: Mon, 16 Sep 2024 13:43:31 +0200
Message-ID: <20240916114230.353456064@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240916114228.914815055@linuxfoundation.org>
References: <20240916114228.914815055@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Daniele Ceraolo Spurio <daniele.ceraolospurio@intel.com>

[ Upstream commit 8636a5c29be1f05b5162a5c82c874338b6717759 ]

The BO cleanup touches the GGTT and therefore requires the HW to be
available, so we need to use devm instead of drmm.

Closes: https://gitlab.freedesktop.org/drm/xe/kernel/-/issues/1160
Signed-off-by: Daniele Ceraolo Spurio <daniele.ceraolospurio@intel.com>
Cc: Lucas De Marchi <lucas.demarchi@intel.com>
Cc: Matthew Auld <matthew.auld@intel.com>
Reviewed-by: Matthew Auld <matthew.auld@intel.com>
Reviewed-by: Lucas De Marchi <lucas.demarchi@intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20240809231237.1503796-2-daniele.ceraolospurio@intel.com
Signed-off-by: Lucas De Marchi <lucas.demarchi@intel.com>
(cherry picked from commit 8d3a2d3d766a823c7510cdc17e6ff7c042c63b61)
Signed-off-by: Rodrigo Vivi <rodrigo.vivi@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/xe/xe_bo.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/gpu/drm/xe/xe_bo.c b/drivers/gpu/drm/xe/xe_bo.c
index b6f3a43d637f..f5e3012eff20 100644
--- a/drivers/gpu/drm/xe/xe_bo.c
+++ b/drivers/gpu/drm/xe/xe_bo.c
@@ -1539,7 +1539,7 @@ struct xe_bo *xe_bo_create_from_data(struct xe_device *xe, struct xe_tile *tile,
 	return bo;
 }
 
-static void __xe_bo_unpin_map_no_vm(struct drm_device *drm, void *arg)
+static void __xe_bo_unpin_map_no_vm(void *arg)
 {
 	xe_bo_unpin_map_no_vm(arg);
 }
@@ -1554,7 +1554,7 @@ struct xe_bo *xe_managed_bo_create_pin_map(struct xe_device *xe, struct xe_tile
 	if (IS_ERR(bo))
 		return bo;
 
-	ret = drmm_add_action_or_reset(&xe->drm, __xe_bo_unpin_map_no_vm, bo);
+	ret = devm_add_action_or_reset(xe->drm.dev, __xe_bo_unpin_map_no_vm, bo);
 	if (ret)
 		return ERR_PTR(ret);
 
@@ -1602,7 +1602,7 @@ int xe_managed_bo_reinit_in_vram(struct xe_device *xe, struct xe_tile *tile, str
 	if (IS_ERR(bo))
 		return PTR_ERR(bo);
 
-	drmm_release_action(&xe->drm, __xe_bo_unpin_map_no_vm, *src);
+	devm_release_action(xe->drm.dev, __xe_bo_unpin_map_no_vm, *src);
 	*src = bo;
 
 	return 0;
-- 
2.43.0



