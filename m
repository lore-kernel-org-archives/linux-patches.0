Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EFEB8346E7B;
	Tue, 11 Nov 2025 01:06:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762823206; cv=none; b=NsAL2ZxnaDDiNLZqyAPZxowM0FNUwdujmZiQRmTmuL1iXCutOUPsjw04kB8IqSRZpIpu5D7GTOKJq8cH4uFuPtuEeIh0Mko83EM5ozEe5iNr/icyx69uNDkvnhkuq3Mor34QsIoBAEjJPFDdPcaCRzY1JGuQ6lB8vdS4H8SVbeE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762823206; c=relaxed/simple;
	bh=CbwnMV6J9nnqGJZRUDvCHW18TDyw/qNYyslG/RD/HDc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=d+QuKdpKv//qel7LpJcM2HzETZuembPk7ubm2+vRi9ork1OppdF6waeXqznDpSjiI/Mc1mEaZtmxZjwqWOSy8Y7WYY+HdIeDCf0ytdNS9YjD3B+2E56HRinahVZ+CBA/JVwodqfUkM/QVf1eA9PcoYBrLG1DGhnrrTzmejsEwdY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DE7klhsP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DE7klhsP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3FBD1C2BC9E;
	Tue, 11 Nov 2025 01:06:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762823205;
	bh=CbwnMV6J9nnqGJZRUDvCHW18TDyw/qNYyslG/RD/HDc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DE7klhsPAul6TSigKfQv6LoVF/MuHG0gNJUAyplqzBpSSn2SoIZ4DcXnCa0pN5IQR
	 ZiUCk/uTrQKTDVXrWRXWx5gIN+bfIwVLTidWq/WwVeiwici7XImxVpMs5s6CN1q76U
	 jgOUAlNZX3QXkG5iK1pxwZ6bkr4wjtU0s/0s4z7U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mangesh Gadre <Mangesh.Gadre@amd.com>,
	"Stanley.Yang" <Stanley.Yang@amd.com>,
	Tao Zhou <tao.zhou1@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 253/849] drm/amdgpu: Initialize jpeg v5_0_1 ras function
Date: Tue, 11 Nov 2025 09:37:03 +0900
Message-ID: <20251111004542.545268313@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251111004536.460310036@linuxfoundation.org>
References: <20251111004536.460310036@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mangesh Gadre <Mangesh.Gadre@amd.com>

[ Upstream commit 01fa9758c8498d8930df56eca36c88ba3e9493d4 ]

Initialize jpeg v5_0_1 ras function

Signed-off-by: Mangesh Gadre <Mangesh.Gadre@amd.com>
Reviewed-by: Stanley.Yang <Stanley.Yang@amd.com>
Reviewed-by: Tao Zhou <tao.zhou1@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/jpeg_v5_0_1.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/gpu/drm/amd/amdgpu/jpeg_v5_0_1.c b/drivers/gpu/drm/amd/amdgpu/jpeg_v5_0_1.c
index 03ec4b741d194..8d74455dab1e2 100644
--- a/drivers/gpu/drm/amd/amdgpu/jpeg_v5_0_1.c
+++ b/drivers/gpu/drm/amd/amdgpu/jpeg_v5_0_1.c
@@ -196,6 +196,14 @@ static int jpeg_v5_0_1_sw_init(struct amdgpu_ip_block *ip_block)
 		}
 	}
 
+	if (amdgpu_ras_is_supported(adev, AMDGPU_RAS_BLOCK__JPEG)) {
+		r = amdgpu_jpeg_ras_sw_init(adev);
+		if (r) {
+			dev_err(adev->dev, "Failed to initialize jpeg ras block!\n");
+			return r;
+		}
+	}
+
 	r = amdgpu_jpeg_reg_dump_init(adev, jpeg_reg_list_5_0_1, ARRAY_SIZE(jpeg_reg_list_5_0_1));
 	if (r)
 		return r;
-- 
2.51.0



