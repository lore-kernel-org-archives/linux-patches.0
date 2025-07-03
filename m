Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F0A1C19F43A;
	Thu,  3 Jul 2025 14:50:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751554202; cv=none; b=KOBccs3xOHFU7vJEBLg54o6kv8i+ObWpAzlHXNNG7RNNo3U7CIJwUbbJdp1vr6VISGlt3+dbODQhfee4+y2K/tyhroSBpNnJ8onYGYTDnoSdhmJm7eMjIoc6PNKgSfiPJ7DB0Lc2+wmErSgV3B/IdlxQo3ujeH+5UdNg90nVEWg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751554202; c=relaxed/simple;
	bh=OCsOAVy6TpF9mlGGLdIkh/QyQs0yW1znZkLPBfWUyZ4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WwEAAer6afAtm9J+tGCFJ2FClYsL4vh0VK/4ffVkH3rP5XTDD4Vyc9vARvX0AVfxfbmd0h5NVjOGA/B3214iiZW8c8LqwNnTirH2ArM4Wd4g7RZ1PkmCQbYte0+RPg1AmeXMYx1laR9aN9JLUaGZeKJISINYWqU5jcrZlWNk/Zk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GeolWIDh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GeolWIDh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5C36CC4CEE3;
	Thu,  3 Jul 2025 14:50:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1751554201;
	bh=OCsOAVy6TpF9mlGGLdIkh/QyQs0yW1znZkLPBfWUyZ4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GeolWIDhNtpY4J1vNr1qKMZmGUdsukZOYgKUKuQ7tHpSvkSwF+wnlpL91jr2kHxTB
	 5z9Z/F++ioQOir2E0ypkFoxPQBRSiCg2dBq5UQcwkZUfYBEWPx/M8JeWZOZduQ5PcP
	 znkgwkqcR+e7r5TJ9d656TVDgtaGITFtCis+keFM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lijo Lazar <lijo.lazar@amd.com>,
	Marcus Seyfarth <m.seyfarth@gmail.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Mario Limonciello <mario.limonciello@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 112/218] drm/amd: Adjust output for discovery error handling
Date: Thu,  3 Jul 2025 16:41:00 +0200
Message-ID: <20250703144000.418183441@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250703143955.956569535@linuxfoundation.org>
References: <20250703143955.956569535@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 8929478a8f45c..34d41e3ce3474 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_discovery.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_discovery.c
@@ -301,10 +301,12 @@ static int amdgpu_discovery_read_binary_from_file(struct amdgpu_device *adev,
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
 
@@ -419,16 +421,12 @@ static int amdgpu_discovery_init(struct amdgpu_device *adev)
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
@@ -1286,10 +1284,8 @@ static int amdgpu_discovery_reg_base_init(struct amdgpu_device *adev)
 	int r;
 
 	r = amdgpu_discovery_init(adev);
-	if (r) {
-		DRM_ERROR("amdgpu_discovery_init failed\n");
+	if (r)
 		return r;
-	}
 
 	adev->gfx.xcc_mask = 0;
 	adev->sdma.sdma_mask = 0;
@@ -2451,8 +2447,10 @@ int amdgpu_discovery_set_ip_blocks(struct amdgpu_device *adev)
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



