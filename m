Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A0F5F2EE60C;
	Tue, 17 Jun 2025 16:02:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750176137; cv=none; b=GLw/Dm8/V6rhVNePpHIjIxbGpu+O6XHStB/PovU2ud4QoRFY7bwMKvdTkMYPuCVScohEmn/VSOs7kQcqfFrgrY41nZovn5Mcx1vbO+SlF3Bre30cF2DfE93ec2xAdHOKtPzNRPfZCibSEbuehP6/boJScEf75K7fSM8EhWZfP70=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750176137; c=relaxed/simple;
	bh=PP1pQ4GXSfQEpapJORZHvF+b/DAZ0Ne5domX7G53UJQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=NxUmCbqxDEnNzUqBq2g2j1fKUw8w7NYI3au3LAm7VGRbO98pdGKy4wOH8j6F/3vrILS31yFehw3AFAAZuT4ysyN12bWilKophKFxSBojJPQp+wpKb43FYIOgDs/ErJklyUkGn6xRijmxHlfyUl8oMPwA2lik+ofRFvHtS4IlGog=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=diKsvbSw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="diKsvbSw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D26A7C4CEE3;
	Tue, 17 Jun 2025 16:02:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750176137;
	bh=PP1pQ4GXSfQEpapJORZHvF+b/DAZ0Ne5domX7G53UJQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=diKsvbSw10cRo8O0WWeBA/z97L7/xnQnbjpHhIKBSxjHR0TBRS1KasKb1Hm83vZmA
	 sMKiPTQ5E9nCO7tqtF91wNOQMQv7q77emi/alyr3cTI3r33EES+bfZT2XmWRa/REXv
	 SLkN+DjnPBH6D53mPvLj1A+F+cZ1XfNWlANFdOrQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Matt Roper <matthew.d.roper@intel.com>,
	Tejas Upadhyay <tejas.upadhyay@intel.com>,
	Stuart Summers <stuart.summers@intel.com>,
	Aradhya Bhatia <aradhya.bhatia@intel.com>,
	=?UTF-8?q?Thomas=20Hellstr=C3=B6m?= <thomas.hellstrom@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 158/780] drm/xe/guc: Make creation of SLPC debugfs files conditional
Date: Tue, 17 Jun 2025 17:17:46 +0200
Message-ID: <20250617152457.928718891@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617152451.485330293@linuxfoundation.org>
References: <20250617152451.485330293@linuxfoundation.org>
User-Agent: quilt/0.68
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

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Aradhya Bhatia <aradhya.bhatia@intel.com>

[ Upstream commit e22d7acf9f47b01c9a538f3dac5c8e8d46fbca96 ]

Platforms that do not support SLPC are exempted from the GuC PC support.
The GuC PC does not get initialized, and neither do its BOs get created.

This causes a problem because the GuC PC debugfs file is still being
created. Whenever the file is attempted to read, it causes a NULL
pointer dereference on the supposed BO of the GuC PC.

So, make the creation of SLPC debugfs files conditional to when SLPC
features are supported.

Fixes: aaab5404b16f ("drm/xe: Introduce GuC PC debugfs")
Suggested-by: Matt Roper <matthew.d.roper@intel.com>
Reviewed-by: Tejas Upadhyay <tejas.upadhyay@intel.com>
Reviewed-by: Stuart Summers <stuart.summers@intel.com>
Signed-off-by: Aradhya Bhatia <aradhya.bhatia@intel.com>
Link: https://lore.kernel.org/r/20250516141902.5614-1-aradhya.bhatia@intel.com
Signed-off-by: Matt Roper <matthew.d.roper@intel.com>
(cherry picked from commit 17486cf3df5320752cc67ee8bcb2379d1b9de76c)
Signed-off-by: Thomas Hellström <thomas.hellstrom@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/xe/xe_guc_debugfs.c | 17 ++++++++++++++---
 1 file changed, 14 insertions(+), 3 deletions(-)

diff --git a/drivers/gpu/drm/xe/xe_guc_debugfs.c b/drivers/gpu/drm/xe/xe_guc_debugfs.c
index f33013f8a0f38..0b102ab46c4df 100644
--- a/drivers/gpu/drm/xe/xe_guc_debugfs.c
+++ b/drivers/gpu/drm/xe/xe_guc_debugfs.c
@@ -113,23 +113,34 @@ static const struct drm_info_list vf_safe_debugfs_list[] = {
 	{ "guc_ctb", .show = guc_debugfs_show, .data = guc_ctb },
 };
 
+/* For GuC debugfs files that require the SLPC support */
+static const struct drm_info_list slpc_debugfs_list[] = {
+	{ "guc_pc", .show = guc_debugfs_show, .data = guc_pc },
+};
+
 /* everything else should be added here */
 static const struct drm_info_list pf_only_debugfs_list[] = {
 	{ "guc_log", .show = guc_debugfs_show, .data = guc_log },
 	{ "guc_log_dmesg", .show = guc_debugfs_show, .data = guc_log_dmesg },
-	{ "guc_pc", .show = guc_debugfs_show, .data = guc_pc },
 };
 
 void xe_guc_debugfs_register(struct xe_guc *guc, struct dentry *parent)
 {
-	struct drm_minor *minor = guc_to_xe(guc)->drm.primary;
+	struct xe_device *xe =  guc_to_xe(guc);
+	struct drm_minor *minor = xe->drm.primary;
 
 	drm_debugfs_create_files(vf_safe_debugfs_list,
 				 ARRAY_SIZE(vf_safe_debugfs_list),
 				 parent, minor);
 
-	if (!IS_SRIOV_VF(guc_to_xe(guc)))
+	if (!IS_SRIOV_VF(xe)) {
 		drm_debugfs_create_files(pf_only_debugfs_list,
 					 ARRAY_SIZE(pf_only_debugfs_list),
 					 parent, minor);
+
+		if (!xe->info.skip_guc_pc)
+			drm_debugfs_create_files(slpc_debugfs_list,
+						 ARRAY_SIZE(slpc_debugfs_list),
+						 parent, minor);
+	}
 }
-- 
2.39.5



