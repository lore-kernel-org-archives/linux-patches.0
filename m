Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 19F3F22127B;
	Wed, 25 Feb 2026 01:46:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771983961; cv=none; b=e610ToMhGAi43xpvyvYWzuud+6QWM3DoXcj724Apkm0RnFeOFThZDIaiB55paDaz39Kec2hMSzELBmIpRgJqrJHgzyLQ1EljBemUwvNftcopQnG7KwPkMRhZXRRYKewARCCFgz84EA0I+EBtlgDp5+zpMmu2i37/r6h7ZF5WxSs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771983961; c=relaxed/simple;
	bh=hPLi9KFJy6MB9I71M0AN5EOBtV0807PlAdG1fZJU+Og=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QhFgURimyoqC+0UrV96IsbhxaMavhVwnucWrtSqaD8rRSNsYyYFdJ/b3DjBlM6FG3mP//DhL0OC2yh3T81acPS6YP4jH60fYQ2UyxevixXT+fwpWJURTC/a8ro4AG5At31HchKPUbt4snD7JxwMhvltGjD8QwHQRQyD+7Q5uxrc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JpkiTuRL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JpkiTuRL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CD217C116D0;
	Wed, 25 Feb 2026 01:46:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1771983961;
	bh=hPLi9KFJy6MB9I71M0AN5EOBtV0807PlAdG1fZJU+Og=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JpkiTuRL73VuJU5tvF40Ed5d4R+DQ1RZNtdkwbIaXGQlTXWahOc50F6/jfhwuXqwR
	 rA18sFvNjb6AoogtDFN/h3jWaBoFfC9gCS8Wl06cQQph72NRrV+lGSwHnYuFK9WC2Z
	 Ca7sLabmaDLfqNXap28AVxDcZ2Z4u1jg6APTY9WM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daniele Ceraolo Spurio <daniele.ceraolospurio@intel.com>,
	Rodrigo Vivi <rodrigo.vivi@intel.com>,
	Vinay Belgaumkar <vinay.belgaumkar@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 218/641] drm/xe/ptl: Disable DCC on PTL
Date: Tue, 24 Feb 2026 17:19:04 -0800
Message-ID: <20260225012354.210357464@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260225012348.915798704@linuxfoundation.org>
References: <20260225012348.915798704@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Vinay Belgaumkar <vinay.belgaumkar@intel.com>

[ Upstream commit 801a6e61f5fbab2c0dd76c8360f45b625b49e410 ]

On PTL, the recommendation is to disable DCC(Duty Cycle Control) as
it may cause some regressions due to added latencies. Upcoming GuC
releases will disable DCC on PTL as well, but we need to force it in
KMD so that this behavior is propagated to older kernels.

v2: Update commit message (Rodrigo)
v3: Rebase
v4: Fix typo: s/propagted/propagated

Fixes: 5cdb71d3b0db ("drm/xe/ptl: Add GuC FW definition for PTL")
Cc: Daniele Ceraolo Spurio <daniele.ceraolospurio@intel.com>
Cc: Rodrigo Vivi <rodrigo.vivi@intel.com>
Signed-off-by: Vinay Belgaumkar <vinay.belgaumkar@intel.com>
Link: https://patch.msgid.link/20260124005917.398522-1-vinay.belgaumkar@intel.com
Reviewed-by: Rodrigo Vivi <rodrigo.vivi@intel.com>
Signed-off-by: Rodrigo Vivi <rodrigo.vivi@intel.com>
(cherry picked from commit 40ee63f5df2d5c6471b583df800aac89dc0502a4)
Signed-off-by: Rodrigo Vivi <rodrigo.vivi@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/xe/xe_guc_pc.c | 34 ++++++++++++++++++++++++++++++++++
 1 file changed, 34 insertions(+)

diff --git a/drivers/gpu/drm/xe/xe_guc_pc.c b/drivers/gpu/drm/xe/xe_guc_pc.c
index 53fdf59524c41..a3e9796e6430f 100644
--- a/drivers/gpu/drm/xe/xe_guc_pc.c
+++ b/drivers/gpu/drm/xe/xe_guc_pc.c
@@ -1231,6 +1231,36 @@ int xe_guc_pc_set_power_profile(struct xe_guc_pc *pc, const char *buf)
 	return ret;
 }
 
+static int pc_action_set_dcc(struct xe_guc_pc *pc, bool enable)
+{
+	int ret;
+
+	ret = pc_action_set_param(pc,
+				  SLPC_PARAM_TASK_ENABLE_DCC,
+				  enable);
+	if (!ret)
+		return pc_action_set_param(pc,
+					   SLPC_PARAM_TASK_DISABLE_DCC,
+					   !enable);
+	else
+		return ret;
+}
+
+static int pc_modify_defaults(struct xe_guc_pc *pc)
+{
+	struct xe_device *xe = pc_to_xe(pc);
+	struct xe_gt *gt = pc_to_gt(pc);
+	int ret = 0;
+
+	if (xe->info.platform == XE_PANTHERLAKE) {
+		ret = pc_action_set_dcc(pc, false);
+		if (unlikely(ret))
+			xe_gt_err(gt, "Failed to modify DCC default: %pe\n", ERR_PTR(ret));
+	}
+
+	return ret;
+}
+
 /**
  * xe_guc_pc_start - Start GuC's Power Conservation component
  * @pc: Xe_GuC_PC instance
@@ -1288,6 +1318,10 @@ int xe_guc_pc_start(struct xe_guc_pc *pc)
 			   ktime_ms_delta(ktime_get(), earlier));
 	}
 
+	ret = pc_modify_defaults(pc);
+	if (ret)
+		return ret;
+
 	ret = pc_init_freqs(pc);
 	if (ret)
 		goto out;
-- 
2.51.0



