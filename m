Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E0D13803DC;
	Sat, 17 Oct 2026 17:30:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792258245; cv=none; b=RNkR04K1+QbECA11lrVkcoQb5+iUHTdoZ9nqFcTq9KlhgCvDP1pBD6dvfqpdE/e7ir2+J4evRaH+xSi6Rcqnp6IeCrXS633Rt5XvsP9AKnVzYDMABnn2TLJGKuXdxIEkTHGjhCKQvwEXN/yptuj1AD2kPMTIGrffI8+9DftJDsE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792258245; c=relaxed/simple;
	bh=fg44RNMH2mi3uQeMiwXxuVPihSxCPMEw+aVZtzYVI7w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=u4BDjqktUiiOfsrZRD0spkaUQAXTY+/eY0fs1NY9x+XGuCuddzB7Bukx9H76CLZ2gJMG2OgvVyh1g9fbFHXVb0IS82xmdZrRCEu4r6uyqrU5bym700cVHIvpOydKJPkBkdds/hOA3vZmc/+ngsVdgjxfz1TbhUHJddiqsatBYgQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mNsMqVv/; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mNsMqVv/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6D15C1F000C4;
	Sat, 17 Oct 2026 17:30:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792258244;
	bh=nOlpd5eywLiDQcQ+ambSq3oAc7YFm7bc9NBIz/Ag3UI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=mNsMqVv/3oY8B1Hbs2uXuNvJNkvmyaPAvbt8ewky1LsbY5PyV68dsbnFBkoMcsVdg
	 +ebrDZj9fr5Q/32f6aFKHWiY3+xAoTYwDT8aoUvNu7m3zHw1jFcGZTwlrdbp2BC32d
	 vNN50sLCDQPdVjBYuEwQ6wJaD2/7sIaWONRXX8uw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lijo Lazar <lijo.lazar@amd.com>,
	Asad Kamal <asad.kamal@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0820/1674] drm/amdgpu: Restore partition mode after reset
Date: Sat, 17 Oct 2026 17:51:32 +0200
Message-ID: <20261017160452.172942650@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160431.119607952@linuxfoundation.org>
References: <20261017160431.119607952@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Lijo Lazar <lijo.lazar@amd.com>

[ Upstream commit c45e38f21754b7cf0043618ebc2c145a23ecccaf ]

On a full device reset, PSP FW gets unloaded. Hence restore the
partition mode by placing a new request.

Signed-off-by: Lijo Lazar <lijo.lazar@amd.com>
Reviewed-by: Asad Kamal <asad.kamal@amd.com>
Acked-by: Alex Deucher <alexander.deucher@amd.com>
Tested-by: Asad Kamal <asad.kamal@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Stable-dep-of: eb6e7f520d6e ("drm/amdgpu: fix gpu page fault after hibernation on PF passthrough")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_device.c |  5 ++++
 drivers/gpu/drm/amd/amdgpu/amdgpu_xcp.c    | 28 ++++++++++++++++------
 drivers/gpu/drm/amd/amdgpu/amdgpu_xcp.h    |  1 +
 drivers/gpu/drm/amd/amdgpu/aqua_vanjaram.c |  2 +-
 4 files changed, 28 insertions(+), 8 deletions(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c
index 422d086e4c583..427fb7d897a16 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c
@@ -5163,6 +5163,11 @@ int amdgpu_do_asic_reset(struct list_head *device_list_handle,
 				if (r)
 					return r;
 
+				r = amdgpu_xcp_restore_partition_mode(
+					tmp_adev->xcp_mgr);
+				if (r)
+					goto out;
+
 				r = amdgpu_device_ip_resume_phase2(tmp_adev);
 				if (r)
 					goto out;
diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_xcp.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_xcp.c
index 565a1fa436d4b..2b99eed5ba192 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_xcp.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_xcp.c
@@ -163,16 +163,11 @@ int amdgpu_xcp_init(struct amdgpu_xcp_mgr *xcp_mgr, int num_xcps, int mode)
 	return 0;
 }
 
-int amdgpu_xcp_switch_partition_mode(struct amdgpu_xcp_mgr *xcp_mgr, int mode)
+static int __amdgpu_xcp_switch_partition_mode(struct amdgpu_xcp_mgr *xcp_mgr,
+					      int mode)
 {
 	int ret, curr_mode, num_xcps = 0;
 
-	if (!xcp_mgr || mode == AMDGPU_XCP_MODE_NONE)
-		return -EINVAL;
-
-	if (xcp_mgr->mode == mode)
-		return 0;
-
 	if (!xcp_mgr->funcs || !xcp_mgr->funcs->switch_partition_mode)
 		return 0;
 
@@ -201,6 +196,25 @@ int amdgpu_xcp_switch_partition_mode(struct amdgpu_xcp_mgr *xcp_mgr, int mode)
 	return ret;
 }
 
+int amdgpu_xcp_switch_partition_mode(struct amdgpu_xcp_mgr *xcp_mgr, int mode)
+{
+	if (!xcp_mgr || mode == AMDGPU_XCP_MODE_NONE)
+		return -EINVAL;
+
+	if (xcp_mgr->mode == mode)
+		return 0;
+
+	return __amdgpu_xcp_switch_partition_mode(xcp_mgr, mode);
+}
+
+int amdgpu_xcp_restore_partition_mode(struct amdgpu_xcp_mgr *xcp_mgr)
+{
+	if (!xcp_mgr || xcp_mgr->mode == AMDGPU_XCP_MODE_NONE)
+		return 0;
+
+	return __amdgpu_xcp_switch_partition_mode(xcp_mgr, xcp_mgr->mode);
+}
+
 int amdgpu_xcp_query_partition_mode(struct amdgpu_xcp_mgr *xcp_mgr, u32 flags)
 {
 	int mode;
diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_xcp.h b/drivers/gpu/drm/amd/amdgpu/amdgpu_xcp.h
index 9142238e7791a..32775260556f4 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_xcp.h
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_xcp.h
@@ -129,6 +129,7 @@ int amdgpu_xcp_mgr_init(struct amdgpu_device *adev, int init_mode,
 int amdgpu_xcp_init(struct amdgpu_xcp_mgr *xcp_mgr, int num_xcps, int mode);
 int amdgpu_xcp_query_partition_mode(struct amdgpu_xcp_mgr *xcp_mgr, u32 flags);
 int amdgpu_xcp_switch_partition_mode(struct amdgpu_xcp_mgr *xcp_mgr, int mode);
+int amdgpu_xcp_restore_partition_mode(struct amdgpu_xcp_mgr *xcp_mgr);
 int amdgpu_xcp_get_partition(struct amdgpu_xcp_mgr *xcp_mgr,
 			     enum AMDGPU_XCP_IP_BLOCK ip, int instance);
 
diff --git a/drivers/gpu/drm/amd/amdgpu/aqua_vanjaram.c b/drivers/gpu/drm/amd/amdgpu/aqua_vanjaram.c
index fb20faa2c4ffb..7fb6350b125b1 100644
--- a/drivers/gpu/drm/amd/amdgpu/aqua_vanjaram.c
+++ b/drivers/gpu/drm/amd/amdgpu/aqua_vanjaram.c
@@ -513,7 +513,7 @@ static int aqua_vanjaram_switch_partition_mode(struct amdgpu_xcp_mgr *xcp_mgr,
 		return -EINVAL;
 	}
 
-	if (adev->kfd.init_complete)
+	if (adev->kfd.init_complete && !amdgpu_in_reset(adev))
 		flags |= AMDGPU_XCP_OPS_KFD;
 
 	if (flags & AMDGPU_XCP_OPS_KFD) {
-- 
2.53.0



