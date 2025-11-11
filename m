Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ADBDE1D86FF;
	Tue, 11 Nov 2025 01:15:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762823721; cv=none; b=b+TdVv7GVvnbTi/DyrHocN20eoXDL1gRJK1MrP1fYqCAS0bcDM+950OQcTCLcltjEfxj5H5WoQ1iLAyppEf3Xx/c2L1+jiiB4CVmAOif2iyP2LKIqc9RMitwzk0jXDJUyEfT6lvvzToxGinGlc7mijB/56oblpua1883/6VpxyU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762823721; c=relaxed/simple;
	bh=1rlKJPV0hdr+nPwuuzuV/ekPk1to2oCM6XCpqfkw2fM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dYbnBidzRGYJCdF0I6E1f89wDSoX8ikACRCC3As0ibBD58KzCeNGc+1D7A4xtrqqHwrgOdX7idid2iihEhYvpI6HKvETy7Ez0LrD1tRDCV0mD0uONFCnjGrCTD7+yf9Cl0uoAsuiDop/GrITbBx8u+2OIPWQhxCdCc1F5Uv0xyY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0EEDD+3Q; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0EEDD+3Q"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4DE27C113D0;
	Tue, 11 Nov 2025 01:15:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762823721;
	bh=1rlKJPV0hdr+nPwuuzuV/ekPk1to2oCM6XCpqfkw2fM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0EEDD+3QdtT2l6lTE0lk3Mjuyr1rd17hCsKc8lCBDKi04qnqRUPPMb8RBrOXYtW3o
	 wjzBsNagmxjbT1oXDcpA8b1zyCwPTN2O5/7gWEzJK3ZlqLTflHKmk2xLIcC6mRDDkZ
	 7LcHWXSsPzQCg/O4fGy84OazuEPZ8Nu0b9NhqqoM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 307/565] drm/amdgpu: dont enable SMU on cyan skillfish
Date: Tue, 11 Nov 2025 09:42:43 +0900
Message-ID: <20251111004533.790733924@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251111004526.816196597@linuxfoundation.org>
References: <20251111004526.816196597@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alex Deucher <alexander.deucher@amd.com>

[ Upstream commit 94bd7bf2c920998b4c756bc8a54fd3dbdf7e4360 ]

Cyan skillfish uses different SMU firmware.

Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_discovery.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_discovery.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_discovery.c
index e00b5e4542347..e09db65880e1a 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_discovery.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_discovery.c
@@ -2040,13 +2040,16 @@ static int amdgpu_discovery_set_smu_ip_blocks(struct amdgpu_device *adev)
 	case IP_VERSION(11, 0, 5):
 	case IP_VERSION(11, 0, 9):
 	case IP_VERSION(11, 0, 7):
-	case IP_VERSION(11, 0, 8):
 	case IP_VERSION(11, 0, 11):
 	case IP_VERSION(11, 0, 12):
 	case IP_VERSION(11, 0, 13):
 	case IP_VERSION(11, 5, 0):
 		amdgpu_device_ip_block_add(adev, &smu_v11_0_ip_block);
 		break;
+	case IP_VERSION(11, 0, 8):
+		if (adev->apu_flags & AMD_APU_IS_CYAN_SKILLFISH2)
+			amdgpu_device_ip_block_add(adev, &smu_v11_0_ip_block);
+		break;
 	case IP_VERSION(12, 0, 0):
 	case IP_VERSION(12, 0, 1):
 		amdgpu_device_ip_block_add(adev, &smu_v12_0_ip_block);
-- 
2.51.0



