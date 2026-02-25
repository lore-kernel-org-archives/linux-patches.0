Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 462D918DB2A;
	Wed, 25 Feb 2026 01:32:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771983131; cv=none; b=atcTXJOe4pgqP+JoZypX3as9+7vYVTDCbfVmQztg5oSEmy2FkDbr9S8zi4ROZ/SUhcpK91tysGSGFa4lIiSBcC1A7aJpAO02QC8WBD9jnNknUhAJ1P8+wlXcatWqnuO/mZHazu2IVvbUZ9GRORJeoM/v655LRRSM/Gg74W74X6k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771983131; c=relaxed/simple;
	bh=XnP1VfhNDa0M/AsqZS0uF6IpiuDDySt2DUz2eW2OIRE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nD15kC5RG0XGYDVrQStcIEj2zLyMd5uS8ABbMQET4GH1qP1bAKZUk4XgTv4RgyBJebfuE1qfTNnwCeGC70fVZ3mrhVPaJ9nwah2yaGad/OVFhBwyU5BYmjCp5sZjgNpT0hreQ1q/yRHZVEYeYfqnn5i1NzLFeDwVMkEA6WKer5E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lihMZIZz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lihMZIZz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0C397C116D0;
	Wed, 25 Feb 2026 01:32:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1771983131;
	bh=XnP1VfhNDa0M/AsqZS0uF6IpiuDDySt2DUz2eW2OIRE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lihMZIZz2nH0Uy7QWdcO9F6Cbx88RhZyXFqtNQxKBvhCCcxLqfhQuMkZ+70TTIque
	 0+VbsDvawWScqwmSk7rNCmJlxzveeQA6zrWSGKz9rfBbTwIQvwb6AwIscv0KFwogRR
	 d+FzhHV/bNN+R2ptyHqfFQcGcoW6iJ6uZK91IRUQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daniele Ceraolo Spurio <daniele.ceraolospurio@intel.com>,
	Rodrigo Vivi <rodrigo.vivi@intel.com>,
	Vinay Belgaumkar <vinay.belgaumkar@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 288/781] drm/xe/ptl: Disable DCC on PTL
Date: Tue, 24 Feb 2026 17:16:37 -0800
Message-ID: <20260225012406.770843758@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260225012359.695468795@linuxfoundation.org>
References: <20260225012359.695468795@linuxfoundation.org>
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

6.19-stable review patch.  If anyone has any objections, please let me know.

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
index 951a49fb1d3e4..7f09cf0e495fe 100644
--- a/drivers/gpu/drm/xe/xe_guc_pc.c
+++ b/drivers/gpu/drm/xe/xe_guc_pc.c
@@ -1214,6 +1214,36 @@ int xe_guc_pc_set_power_profile(struct xe_guc_pc *pc, const char *buf)
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
@@ -1271,6 +1301,10 @@ int xe_guc_pc_start(struct xe_guc_pc *pc)
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



