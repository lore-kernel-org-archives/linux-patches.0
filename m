Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5BE6E101DE;
	Thu,  3 Jul 2025 15:05:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751555159; cv=none; b=pBqvSe2J5slHFXtmJFm8M1zb/Rg22/HTkCABMzu027k8/m3Fmrf37jN34Z45HQNwn2SsaVJ7c8lPMHzARoU5JjhkXN6zqkZGsLFzmBg3E0ynNFlWQWCEFn/fVSPsUNxF32IgJwaEq8GIk0wFBLKk4pwi/Jm5RGVr0RDAP8UfDbQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751555159; c=relaxed/simple;
	bh=fYYU+VNm/EEfwoYLsVdP3K25ubPQANkDix70YT1FEcw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NQfJiVoId/O5S2Ni8dI30OVu0riI6AUeUNqLzFPXxJ27Aw2VhtmIzX9wrLkec+cxEllSfS7S12PBbH+w6DPneHOBRQJZGBQJE10GhLJrii49zy2LhTOdTc4mceOoGMlwP3lxFXtSf/lCWSIZE0YqMzjFXMRnJzghA7hxeckimYs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dEN37Uzs; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dEN37Uzs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 910F4C4CEE3;
	Thu,  3 Jul 2025 15:05:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1751555159;
	bh=fYYU+VNm/EEfwoYLsVdP3K25ubPQANkDix70YT1FEcw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dEN37Uzs3CYurhP8C9m+lG1XBJISt0lKCAyTLRmudRuo2lNFJ129B+56BsJR50iIn
	 g6dB3gm1roFX3loKQW5ywWbwk1l+bH/aqPwcTCx1MJ1OrKsaBoP6bTF/LvJlvb+7+J
	 VcAMYZ5pA8OOeNYOclEhRxeWF9+oFmkv4HgbFI+0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lijo Lazar <lijo.lazar@amd.com>,
	Marcus Seyfarth <m.seyfarth@gmail.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Mario Limonciello <mario.limonciello@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 164/263] drm/amd: Adjust output for discovery error handling
Date: Thu,  3 Jul 2025 16:41:24 +0200
Message-ID: <20250703144010.938320683@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250703144004.276210867@linuxfoundation.org>
References: <20250703144004.276210867@linuxfoundation.org>
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

From: Mario Limonciello <mario.limonciello@amd.com>

[ Upstream commit 73eab78721f7b85216f1ca8c7b732f13213b5b32 ]

commit 017fbb6690c2 ("drm/amdgpu/discovery: check ip_discovery fw file
available") added support for reading an amdgpu IP discovery bin file
for some specific products. If it's not found then it will fallback to
hardcoded values. However if it's not found there is also a lot of noise
about missing files and errors.

Adjust the error handling to decrease most messages to DEBUG and to show
users less about missing files.

Reviewed-by: Lijo Lazar <lijo.lazar@amd.com>
Reported-by: Marcus Seyfarth <m.seyfarth@gmail.com>
Closes: https://gitlab.freedesktop.org/drm/amd/-/issues/4312
Tested-by: Marcus Seyfarth <m.seyfarth@gmail.com>
Fixes: 017fbb6690c2 ("drm/amdgpu/discovery: check ip_discovery fw file available")
Acked-by: Alex Deucher <alexander.deucher@amd.com>
Link: https://lore.kernel.org/r/20250617183052.1692059-1-superm1@kernel.org
Signed-off-by: Mario Limonciello <mario.limonciello@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit 49f1f9f6c3c9febf8ba93f94a8d9c8d03e1ea0a1)
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_discovery.c | 28 +++++++++----------
 1 file changed, 13 insertions(+), 15 deletions(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_discovery.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_discovery.c
index 9e738fae2b74f..6d34eac0539d4 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_discovery.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_discovery.c
@@ -311,10 +311,12 @@ static int amdgpu_discovery_read_binary_from_file(struct amdgpu_device *adev,
 	const struct firmware *fw;
 	int r;
 
-	r = request_firmware(&fw, fw_name, adev->dev);
+	r = firmware_request_nowarn(&fw, fw_name, adev->dev);
 	if (r) {
-		dev_err(adev->dev, "can't load firmware \"%s\"\n",
-			fw_name);
+		if (amdgpu_discovery == 2)
+			dev_err(adev->dev, "can't load firmware \"%s\"\n", fw_name);
+		else
+			drm_info(&adev->ddev, "Optional firmware \"%s\" was not found\n", fw_name);
 		return r;
 	}
 
@@ -449,16 +451,12 @@ static int amdgpu_discovery_init(struct amdgpu_device *adev)
 	/* Read from file if it is the preferred option */
 	fw_name = amdgpu_discovery_get_fw_name(adev);
 	if (fw_name != NULL) {
-		dev_info(adev->dev, "use ip discovery information from file");
+		drm_dbg(&adev->ddev, "use ip discovery information from file");
 		r = amdgpu_discovery_read_binary_from_file(adev, adev->mman.discovery_bin, fw_name);
-
-		if (r) {
-			dev_err(adev->dev, "failed to read ip discovery binary from file\n");
-			r = -EINVAL;
+		if (r)
 			goto out;
-		}
-
 	} else {
+		drm_dbg(&adev->ddev, "use ip discovery information from memory");
 		r = amdgpu_discovery_read_binary_from_mem(
 			adev, adev->mman.discovery_bin);
 		if (r)
@@ -1328,10 +1326,8 @@ static int amdgpu_discovery_reg_base_init(struct amdgpu_device *adev)
 	int r;
 
 	r = amdgpu_discovery_init(adev);
-	if (r) {
-		DRM_ERROR("amdgpu_discovery_init failed\n");
+	if (r)
 		return r;
-	}
 
 	wafl_ver = 0;
 	adev->gfx.xcc_mask = 0;
@@ -2569,8 +2565,10 @@ int amdgpu_discovery_set_ip_blocks(struct amdgpu_device *adev)
 		break;
 	default:
 		r = amdgpu_discovery_reg_base_init(adev);
-		if (r)
-			return -EINVAL;
+		if (r) {
+			drm_err(&adev->ddev, "discovery failed: %d\n", r);
+			return r;
+		}
 
 		amdgpu_discovery_harvest_ip(adev);
 		amdgpu_discovery_get_gfx_info(adev);
-- 
2.39.5



