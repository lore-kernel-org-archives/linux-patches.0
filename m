Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C3A6C19925E;
	Thu,  6 Jun 2024 14:09:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717682993; cv=none; b=lgEzUaBuKGdsk4VbfXAKLGXZYblI9ba/fK6XgKUvA7Rt5Ohq8NzS21okicC8PQrrjpLYwAU7eO4HDJNHIbKXPBp2CNjU5g1XWfpxs3icnt+g5TJy9PrccE03q0X5tMS5lyRoRAja9mnzXAkKPm1vtnmqd0KE7nyBCXRga9j4fYk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717682993; c=relaxed/simple;
	bh=3/hf0RdSxaYSAgOeoAweyTYhe7wJD/L2sakpBF2VsJQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rBM2cqPDlTX9LiFOhsVnvXLbxwmHTl+7Q5/TjfbIvXXSBF/9Sbgzio06FqU/k0YpdJroPjmYKvtkZFQCNJmw/If5HL7U6AK3+BudKxWMghfS4RmTu02MnXsADUjtgjCdS1chTVbLSAzif+x9U+ekn6tgcSZ/5FmQfxs63Ta05TU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pD5K6sqa; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pD5K6sqa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A3A17C32782;
	Thu,  6 Jun 2024 14:09:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717682993;
	bh=3/hf0RdSxaYSAgOeoAweyTYhe7wJD/L2sakpBF2VsJQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pD5K6sqaWVT/fzKZyg57muRP9T+rsSW3nii95sM62MQFAYT0woahN56GMTW2SB4fw
	 selttAaKid0ZOFeV6/li+afWYbLAPebWOAD+aWHTynXFgP6IFhsyL2Fltw3M/F4U9G
	 Zlja5IitPL16lDp3LBdG7vVCn+Occd8bABKX4qfQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Le Ma <le.ma@amd.com>,
	Hawking Zhang <Hawking.Zhang@amd.com>,
	Lijo Lazar <lijo.lazar@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.9 182/374] drm/amdgpu: init microcode chip name from ip versions
Date: Thu,  6 Jun 2024 16:02:41 +0200
Message-ID: <20240606131657.970371370@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240606131651.683718371@linuxfoundation.org>
References: <20240606131651.683718371@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

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
index b53c8fd4e8cf3..f4d48d6d7e777 100644
--- a/drivers/gpu/drm/amd/amdgpu/gfx_v9_4_3.c
+++ b/drivers/gpu/drm/amd/amdgpu/gfx_v9_4_3.c
@@ -431,16 +431,16 @@ static int gfx_v9_4_3_init_cp_compute_microcode(struct amdgpu_device *adev,
 
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



