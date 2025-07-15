Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 53BBD2ED842;
	Tue, 15 Jul 2025 13:45:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752587121; cv=none; b=c6RzV8UD1sPuicSDeZXs39MeW7JvAs7IufHPm3lVENjGF0YSJO18g9xCRXDOBINAYS8jQaOHeibvvTgUfl/kzGruYbmmYlb1ji4P8ragds2dlQoPlrDv7d7++Ruyl9uHfoKJpGjElHI2lcVCKKKYz1841k8fLsxND38kOOtKh3Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752587121; c=relaxed/simple;
	bh=+g0egLZsHVyqR78vnv4VvzupLX5M6zar+55aDG6/X2o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZjzPz2BW/NTrrwrBXGAPzpNoyaMVljdYf5GiMEMaZ1V46xyEffHDPOZeJw3BhJ5zjQH1vXuCXXb5lVCmJkT40Iyxy+nTjyRpqvYdCS9IpTFhieLaX34Z5YfuComrbCwYtuOCs5jEkUOGdBhik9kEUujYr9PtoEmcCvpQweAAZiE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2Otds1ck; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2Otds1ck"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D16A6C4CEF6;
	Tue, 15 Jul 2025 13:45:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1752587121;
	bh=+g0egLZsHVyqR78vnv4VvzupLX5M6zar+55aDG6/X2o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2Otds1ckCqiFwxLx59viVlQcmzGrJ8ji+bojbVnR6v540MZnAOeA3WN3XAM0ap6VT
	 j8a3E/v2Ei2SkR+yrozra36mndZHVugEh9NA70SuGFQlPfr/8B82KC8dHA6vSUtHam
	 soj6xuPwTGRcM5f4/r/4uAtQBz3sdfq6Vm3R8n9M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Maarten Lankhorst <maarten.lankhorst@linux.intel.com>,
	Daniele Ceraolo Spurio <daniele.ceraolospurio@intel.com>,
	John Harrison <John.C.Harrison@Intel.com>,
	Shuicheng Lin <shuicheng.lin@intel.com>,
	Rodrigo Vivi <rodrigo.vivi@intel.com>,
	Lucas De Marchi <lucas.demarchi@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 157/192] drm/xe/pm: Restore display pm if there is error after display suspend
Date: Tue, 15 Jul 2025 15:14:12 +0200
Message-ID: <20250715130821.219207321@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250715130814.854109770@linuxfoundation.org>
References: <20250715130814.854109770@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Shuicheng Lin <shuicheng.lin@intel.com>

[ Upstream commit 6d33df611a39a1b4ad9f2b609ded5d6efa04d97e ]

xe_bo_evict_all() is called after xe_display_pm_suspend(). So if there
is error with xe_bo_evict_all(), display pm should be restored.

Fixes: 51462211f4a9 ("drm/xe/pxp: add PXP PM support")
Fixes: cb8f81c17531 ("drm/xe/display: Make display suspend/resume work on discrete")
Cc: Maarten Lankhorst <maarten.lankhorst@linux.intel.com>
Cc: Daniele Ceraolo Spurio <daniele.ceraolospurio@intel.com>
Cc: John Harrison <John.C.Harrison@Intel.com>
Signed-off-by: Shuicheng Lin <shuicheng.lin@intel.com>
Reviewed-by: Daniele Ceraolo Spurio <daniele.ceraolospurio@intel.com>
Link: https://lore.kernel.org/r/20250708035424.3608190-2-shuicheng.lin@intel.com
Signed-off-by: Rodrigo Vivi <rodrigo.vivi@intel.com>
(cherry picked from commit 83dcee17855c4e5af037ae3262809036de127903)
Signed-off-by: Lucas De Marchi <lucas.demarchi@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/xe/xe_pm.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/xe/xe_pm.c b/drivers/gpu/drm/xe/xe_pm.c
index 7b6b754ad6eb7..c499c86382858 100644
--- a/drivers/gpu/drm/xe/xe_pm.c
+++ b/drivers/gpu/drm/xe/xe_pm.c
@@ -135,7 +135,7 @@ int xe_pm_suspend(struct xe_device *xe)
 	/* FIXME: Super racey... */
 	err = xe_bo_evict_all(xe);
 	if (err)
-		goto err_pxp;
+		goto err_display;
 
 	for_each_gt(gt, xe, id) {
 		err = xe_gt_suspend(gt);
@@ -152,7 +152,6 @@ int xe_pm_suspend(struct xe_device *xe)
 
 err_display:
 	xe_display_pm_resume(xe);
-err_pxp:
 	xe_pxp_pm_resume(xe->pxp);
 err:
 	drm_dbg(&xe->drm, "Device suspend failed %d\n", err);
-- 
2.39.5



