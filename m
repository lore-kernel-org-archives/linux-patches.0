Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F3CBF1991CA;
	Thu,  6 Jun 2024 14:21:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717683686; cv=none; b=PfnGN41/cy0wiSQ0tR6AkNW+50pCOe/v8mjyG41fipUhJGpwkMCDRae3qmGZfhg1H3ohvd2E8hQNNombdaR2LPa8sF92J24baAhWaTxsqoICGZBEMvRrFeVividCBpMhChTo/VahK6lRtm9PhEH3Ki5C+dlRaBBgK0ikN9Ufok0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717683686; c=relaxed/simple;
	bh=SIv1BoWX2eJxIYHvQUSW/bmkOapTjCOUrZCD16vQBJA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=g2GhkJ93GXSTDsWDZLvENsdJsLUC67HzuIaGjV+txsr1jIoAoFo9FqoLFtThOlJdK1IR6+t16FLeV8rRmaJ4JPnHi7gPqKVg6s/2rXXzgUCBV0a56FsWaB07KNegSAqHzhw9vukDxTYDDCo2/1NuwM4Yap0yOA3HaWiqbsQVrTM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=t7GuPnlo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="t7GuPnlo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 87857C2BD10;
	Thu,  6 Jun 2024 14:21:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717683685;
	bh=SIv1BoWX2eJxIYHvQUSW/bmkOapTjCOUrZCD16vQBJA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=t7GuPnloIJY60wpxAXUnM9r45iXNCj/WYEYl+H7m3XsZxQxKAQblX1sAB4arvB3EN
	 G6mGD5aIfkmsTXaMOwaxzdshDruf01gU9K2gAUuxmD0EWXDMbIr4QmwFYkBZ69YbBY
	 XV4hJL1Ku0OhEk6WyYsMTpxctgnT2/H18ipYULCw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Le Ma <le.ma@amd.com>,
	Hawking Zhang <Hawking.Zhang@amd.com>,
	Lijo Lazar <lijo.lazar@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 591/744] drm/amdgpu: init microcode chip name from ip versions
Date: Thu,  6 Jun 2024 16:04:23 +0200
Message-ID: <20240606131751.423121099@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240606131732.440653204@linuxfoundation.org>
References: <20240606131732.440653204@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Le Ma <le.ma@amd.com>

[ Upstream commit 92ed1e9cd5f6cc4f8c9a9ba6c4d2d2bbc6221296 ]

To adapt to different gc versions in gfx_v9_4_3.c file.

Signed-off-by: Le Ma <le.ma@amd.com>
Reviewed-by: Hawking Zhang <Hawking.Zhang@amd.com>
Reviewed-by: Lijo Lazar <lijo.lazar@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Stable-dep-of: acce6479e30f ("drm/amdgpu: Fix buffer size in gfx_v9_4_3_init_ cp_compute_microcode() and rlc_microcode()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/gfx_v9_4_3.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/gfx_v9_4_3.c b/drivers/gpu/drm/amd/amdgpu/gfx_v9_4_3.c
index e481ef73af6e5..7c9a7ab9df3bb 100644
--- a/drivers/gpu/drm/amd/amdgpu/gfx_v9_4_3.c
+++ b/drivers/gpu/drm/amd/amdgpu/gfx_v9_4_3.c
@@ -425,16 +425,16 @@ static int gfx_v9_4_3_init_cp_compute_microcode(struct amdgpu_device *adev,
 
 static int gfx_v9_4_3_init_microcode(struct amdgpu_device *adev)
 {
-	const char *chip_name;
+	char ucode_prefix[30];
 	int r;
 
-	chip_name = "gc_9_4_3";
+	amdgpu_ucode_ip_version_decode(adev, GC_HWIP, ucode_prefix, sizeof(ucode_prefix));
 
-	r = gfx_v9_4_3_init_rlc_microcode(adev, chip_name);
+	r = gfx_v9_4_3_init_rlc_microcode(adev, ucode_prefix);
 	if (r)
 		return r;
 
-	r = gfx_v9_4_3_init_cp_compute_microcode(adev, chip_name);
+	r = gfx_v9_4_3_init_cp_compute_microcode(adev, ucode_prefix);
 	if (r)
 		return r;
 
-- 
2.43.0



