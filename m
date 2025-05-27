Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A1452110E;
	Tue, 27 May 2025 17:04:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748365489; cv=none; b=sTRY57l7RfzSg/khF9sWvj0E6VLi4b6aKmjKr1jiMUt6cOIGPvW7d5XOxWO32iA6uA0GCgBFCs/J+4laruoH2NV1lL5t31pbPG7dgFmi2vYBCQZcuwMeR+BIFPyVscG9MTlPpFfqW7bVtKShRc9eGQPvMDtuUTN0xrBLElgUo/Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748365489; c=relaxed/simple;
	bh=WZD2drY/fv1uUVcB0SHg5FEuUmkMMoy2PiEEuYdD03Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=q0AoB19qTzioGAXHFEIxQURTigVUAuvh6n9LFWTEE+P70VrDDHpHK+ZNg8lIpAeMUDHyHD4I1mBtldMKnyN6/LHUsJpgfMSFq6ttyGv4SKk/etO6HccE0Re4rTp+3EfXKfTi1PwAe/WQC8iYDknNh7PpYbC3o3O72H9Xam2rKCY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mnwg+p5w; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mnwg+p5w"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F1678C4CEE9;
	Tue, 27 May 2025 17:04:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748365489;
	bh=WZD2drY/fv1uUVcB0SHg5FEuUmkMMoy2PiEEuYdD03Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mnwg+p5wwGGLCBNp9z4hOxzPCwA74mbqLEwu+4JKrRUqctT7Lx+oKLGjMOEI43o5Q
	 dcvX8P8DAJHN9aBmTMi4gGXEn+1eDVu+lsZ3mHi8EeTEiX7rrurKx474TAZpdBrvLJ
	 6H7KiGIg4VI1fv7aXcyfciEZ4iAFXV7Rr3ZfTrZ4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Asad Kamal <asad.kamal@amd.com>,
	Lijo Lazar <lijo.lazar@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 393/626] drm/amd/pm: Skip P2S load for SMU v13.0.12
Date: Tue, 27 May 2025 18:24:46 +0200
Message-ID: <20250527162500.991127690@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250527162445.028718347@linuxfoundation.org>
References: <20250527162445.028718347@linuxfoundation.org>
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

From: Asad Kamal <asad.kamal@amd.com>

[ Upstream commit 1fb85819d629676f1d53f40c3fffa25a33a881e4 ]

Skip P2S table load for SMU v13.0.12

Signed-off-by: Asad Kamal <asad.kamal@amd.com>
Reviewed-by: Lijo Lazar <lijo.lazar@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/pm/swsmu/smu13/smu_v13_0_6_ppt.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/amd/pm/swsmu/smu13/smu_v13_0_6_ppt.c b/drivers/gpu/drm/amd/pm/swsmu/smu13/smu_v13_0_6_ppt.c
index 55ed6247eb61f..9ac694c4f1f7a 100644
--- a/drivers/gpu/drm/amd/pm/swsmu/smu13/smu_v13_0_6_ppt.c
+++ b/drivers/gpu/drm/amd/pm/swsmu/smu13/smu_v13_0_6_ppt.c
@@ -275,8 +275,9 @@ static int smu_v13_0_6_init_microcode(struct smu_context *smu)
 	int var = (adev->pdev->device & 0xF);
 	char ucode_prefix[15];
 
-	/* No need to load P2S tables in IOV mode */
-	if (amdgpu_sriov_vf(adev))
+	/* No need to load P2S tables in IOV mode or for smu v13.0.12 */
+	if (amdgpu_sriov_vf(adev) ||
+	    (amdgpu_ip_version(smu->adev, MP1_HWIP, 0) == IP_VERSION(13, 0, 12)))
 		return 0;
 
 	if (!(adev->flags & AMD_IS_APU)) {
-- 
2.39.5



