Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A8B7D1C2317;
	Tue, 27 Aug 2024 15:21:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724772089; cv=none; b=UxN4BIhIxnMq/a59hzjT8YDeEyMWyyo37kgu+vA4oXrGyINfn55BEAVYj5ak24FEiGa52MPKrAvfPoijUbSoXOyQIXa22wjMMPyk4vRlnzmhFBCW/Xo/9gm3iCULAUPkCRu4zqfmQjRNtg6JKYZb4NWtOaFiNN/02rqK5N0W+7I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724772089; c=relaxed/simple;
	bh=MfWsnnL7ExarNgkufm0yw15lDJinELGG1eHwR1wQImI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=nmEeHQ+O1DD/pZ6qngMAtQKyLpf+/H7gfsRRc7xNSeuncBz6/Xyn+GARYT+gvd8+ke49K9yjX2ZNUgGuytGfA7EqFPgYOpVhwNPfXTpUAKvL57XaWrBng1Ivf7Vep0vvVbV0v1e503SaTORyF7hBv1btymYDkCOIxmZNShybvM4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gx3Kn30h; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gx3Kn30h"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 28F86C4FE08;
	Tue, 27 Aug 2024 15:21:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1724772089;
	bh=MfWsnnL7ExarNgkufm0yw15lDJinELGG1eHwR1wQImI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gx3Kn30hcGeTXPic3SxPd55eKPKwr3buHTDHfsyKX2v80Kp0MwSBgnsywCiCE79YT
	 DX3C4NawXGYzKjbsB3FFix8MNPcknGMgDq17KvwyB8K1PrpA//spZ93dwwsVUrueVY
	 lppTKp/dynP+C6I3b4WEaQkhaLb+jyvVlMI+SOuU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lee Jones <lee@kernel.org>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 111/321] drm/amd/amdgpu/imu_v11_0: Increase buffer size to ensure all possible values can be stored
Date: Tue, 27 Aug 2024 16:36:59 +0200
Message-ID: <20240827143842.470873042@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240827143838.192435816@linuxfoundation.org>
References: <20240827143838.192435816@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Lee Jones <lee@kernel.org>

[ Upstream commit a728342ae4ec2a7fdab0038b11427579424f133e ]

Fixes the following W=1 kernel build warning(s):

 drivers/gpu/drm/amd/amdgpu/imu_v11_0.c: In function ‘imu_v11_0_init_microcode’:
 drivers/gpu/drm/amd/amdgpu/imu_v11_0.c:52:54: warning: ‘_imu.bin’ directive output may be truncated writing 8 bytes into a region of size between 4 and 33 [-Wformat-truncation=]
 drivers/gpu/drm/amd/amdgpu/imu_v11_0.c:52:9: note: ‘snprintf’ output between 16 and 45 bytes into a destination of size 40

Signed-off-by: Lee Jones <lee@kernel.org>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/imu_v11_0.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/imu_v11_0.c b/drivers/gpu/drm/amd/amdgpu/imu_v11_0.c
index 95548c512f4fb..3c21128fa1d82 100644
--- a/drivers/gpu/drm/amd/amdgpu/imu_v11_0.c
+++ b/drivers/gpu/drm/amd/amdgpu/imu_v11_0.c
@@ -38,7 +38,7 @@ MODULE_FIRMWARE("amdgpu/gc_11_0_3_imu.bin");
 
 static int imu_v11_0_init_microcode(struct amdgpu_device *adev)
 {
-	char fw_name[40];
+	char fw_name[45];
 	char ucode_prefix[30];
 	int err;
 	const struct imu_firmware_header_v1_0 *imu_hdr;
-- 
2.43.0



