Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B399E1C5D4E;
	Wed,  5 Mar 2025 18:14:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741198489; cv=none; b=U/h4FIRU42dVueL01RiWXsACPpEBK9nRdycS/JMEQyGJhVzurE8/4aBapcAmlOtkxJb7rMrvGGuxNCxcSYT6fAFOWSE9LlxkYuC2lzUKB2tLMwnEL1yhxlJrqb5Mo20B4EySIAlvbovJVZ1hmBt77dhmdprshtDedJbVVITAUqc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741198489; c=relaxed/simple;
	bh=2wWtdTEtxJa17DdQU9WZ6DIG0aGjxJr79O8JHH446R4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IuzPIoHICn0SREvN67kakcEcbThQS7NNtQU6L2J2B8Y//x0P+iDLnF+15a4MbxWjo3bDR7cQkgqu90Nl4vg5+rDU1fg8ncJtuDeNMOCSzD2Z9/UE9K3W1kWdnNpdSXaFvYg7ObWnex0mSNdNffzwS2AsCnRoVlbxTtJv6QFgYQo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nz1+G8uD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nz1+G8uD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3C0E4C4CED1;
	Wed,  5 Mar 2025 18:14:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741198489;
	bh=2wWtdTEtxJa17DdQU9WZ6DIG0aGjxJr79O8JHH446R4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nz1+G8uDMMzZpUXzBU70SxndRnSUtwQUgrwppJnXMbJKzjKGBYRznRMesRY6JQSPI
	 fGnbc8tczOECIXMFtm/yEnuPY2V0E5eFDqremxvIioE/CRv79jIQpmH3P2SJ57x6QS
	 kVpLfglUVUHr6DqQD94LyPJm4+1TCg31RQI/s3Is=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Srinivasan Shanmugam <srinivasan.shanmugam@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Shaoyun Liu <shaoyun.liu@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 045/157] drm/amdgpu/mes: keep enforce isolation up to date
Date: Wed,  5 Mar 2025 18:48:01 +0100
Message-ID: <20250305174507.114356754@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250305174505.268725418@linuxfoundation.org>
References: <20250305174505.268725418@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alex Deucher <alexander.deucher@amd.com>

[ Upstream commit 748a1f51bb74453f1fe22d3ca68a717cb31f02e5 ]

Re-send the mes message on resume to make sure the
mes state is up to date.

Fixes: 8521e3c5f058 ("drm/amd/amdgpu: limit single process inside MES")
Acked-by: Srinivasan Shanmugam <srinivasan.shanmugam@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: Shaoyun Liu <shaoyun.liu@amd.com>
Cc: Srinivasan Shanmugam <srinivasan.shanmugam@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit 27b791514789844e80da990c456c2465325e0851)
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_gfx.c | 13 ++++---------
 drivers/gpu/drm/amd/amdgpu/amdgpu_mes.c | 20 +++++++++++++++++++-
 drivers/gpu/drm/amd/amdgpu/amdgpu_mes.h |  2 +-
 drivers/gpu/drm/amd/amdgpu/mes_v11_0.c  |  4 ++++
 drivers/gpu/drm/amd/amdgpu/mes_v12_0.c  |  4 ++++
 5 files changed, 32 insertions(+), 11 deletions(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_gfx.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_gfx.c
index 11aa55bd16d28..7ec35e3677585 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_gfx.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_gfx.c
@@ -1593,24 +1593,19 @@ static ssize_t amdgpu_gfx_set_enforce_isolation(struct device *dev,
 	}
 
 	mutex_lock(&adev->enforce_isolation_mutex);
-
 	for (i = 0; i < num_partitions; i++) {
-		if (adev->enforce_isolation[i] && !partition_values[i]) {
+		if (adev->enforce_isolation[i] && !partition_values[i])
 			/* Going from enabled to disabled */
 			amdgpu_vmid_free_reserved(adev, AMDGPU_GFXHUB(i));
-			if (adev->enable_mes && adev->gfx.enable_cleaner_shader)
-				amdgpu_mes_set_enforce_isolation(adev, i, false);
-		} else if (!adev->enforce_isolation[i] && partition_values[i]) {
+		else if (!adev->enforce_isolation[i] && partition_values[i])
 			/* Going from disabled to enabled */
 			amdgpu_vmid_alloc_reserved(adev, AMDGPU_GFXHUB(i));
-			if (adev->enable_mes && adev->gfx.enable_cleaner_shader)
-				amdgpu_mes_set_enforce_isolation(adev, i, true);
-		}
 		adev->enforce_isolation[i] = partition_values[i];
 	}
-
 	mutex_unlock(&adev->enforce_isolation_mutex);
 
+	amdgpu_mes_update_enforce_isolation(adev);
+
 	return count;
 }
 
diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_mes.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_mes.c
index 59ec20b07a6af..452ca07e7e7d2 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_mes.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_mes.c
@@ -1679,7 +1679,8 @@ bool amdgpu_mes_suspend_resume_all_supported(struct amdgpu_device *adev)
 }
 
 /* Fix me -- node_id is used to identify the correct MES instances in the future */
-int amdgpu_mes_set_enforce_isolation(struct amdgpu_device *adev, uint32_t node_id, bool enable)
+static int amdgpu_mes_set_enforce_isolation(struct amdgpu_device *adev,
+					    uint32_t node_id, bool enable)
 {
 	struct mes_misc_op_input op_input = {0};
 	int r;
@@ -1701,6 +1702,23 @@ int amdgpu_mes_set_enforce_isolation(struct amdgpu_device *adev, uint32_t node_i
 	return r;
 }
 
+int amdgpu_mes_update_enforce_isolation(struct amdgpu_device *adev)
+{
+	int i, r = 0;
+
+	if (adev->enable_mes && adev->gfx.enable_cleaner_shader) {
+		mutex_lock(&adev->enforce_isolation_mutex);
+		for (i = 0; i < (adev->xcp_mgr ? adev->xcp_mgr->num_xcps : 1); i++) {
+			if (adev->enforce_isolation[i])
+				r |= amdgpu_mes_set_enforce_isolation(adev, i, true);
+			else
+				r |= amdgpu_mes_set_enforce_isolation(adev, i, false);
+		}
+		mutex_unlock(&adev->enforce_isolation_mutex);
+	}
+	return r;
+}
+
 #if defined(CONFIG_DEBUG_FS)
 
 static int amdgpu_debugfs_mes_event_log_show(struct seq_file *m, void *unused)
diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_mes.h b/drivers/gpu/drm/amd/amdgpu/amdgpu_mes.h
index c6f93cbd6739f..f089c5087c63d 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_mes.h
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_mes.h
@@ -534,6 +534,6 @@ static inline void amdgpu_mes_unlock(struct amdgpu_mes *mes)
 
 bool amdgpu_mes_suspend_resume_all_supported(struct amdgpu_device *adev);
 
-int amdgpu_mes_set_enforce_isolation(struct amdgpu_device *adev, uint32_t node_id, bool enable);
+int amdgpu_mes_update_enforce_isolation(struct amdgpu_device *adev);
 
 #endif /* __AMDGPU_MES_H__ */
diff --git a/drivers/gpu/drm/amd/amdgpu/mes_v11_0.c b/drivers/gpu/drm/amd/amdgpu/mes_v11_0.c
index 9c905b9e93763..40750e5478efb 100644
--- a/drivers/gpu/drm/amd/amdgpu/mes_v11_0.c
+++ b/drivers/gpu/drm/amd/amdgpu/mes_v11_0.c
@@ -1635,6 +1635,10 @@ static int mes_v11_0_hw_init(struct amdgpu_ip_block *ip_block)
 		goto failure;
 	}
 
+	r = amdgpu_mes_update_enforce_isolation(adev);
+	if (r)
+		goto failure;
+
 out:
 	/*
 	 * Disable KIQ ring usage from the driver once MES is enabled.
diff --git a/drivers/gpu/drm/amd/amdgpu/mes_v12_0.c b/drivers/gpu/drm/amd/amdgpu/mes_v12_0.c
index 9ecc5d61e49ba..0921fd8c050da 100644
--- a/drivers/gpu/drm/amd/amdgpu/mes_v12_0.c
+++ b/drivers/gpu/drm/amd/amdgpu/mes_v12_0.c
@@ -1590,6 +1590,10 @@ static int mes_v12_0_hw_init(struct amdgpu_ip_block *ip_block)
 		goto failure;
 	}
 
+	r = amdgpu_mes_update_enforce_isolation(adev);
+	if (r)
+		goto failure;
+
 out:
 	/*
 	 * Disable KIQ ring usage from the driver once MES is enabled.
-- 
2.39.5



