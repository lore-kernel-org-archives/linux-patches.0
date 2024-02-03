Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D31CE12B9A;
	Sat,  3 Feb 2024 04:14:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706933667; cv=none; b=C2HSbR/dpg4/FlcJv72rDIBDAGdNTQGlMoJOzSttTOqMMdb2fW5Sbj8YBh1lJr+01Bui9ZrNyH+LlB/4wnvEAYpu1lN6ZCRCUc1wlleLql4WYhNcpopv/tGIr9pNLvKjLSLHx4Hdx5zEuEQaCOXX8Oc60lADj8z+CUtwqyxQs2w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706933667; c=relaxed/simple;
	bh=AI4bVDxKEynGd8k4bW7JH5gIkj11dvoftYlMqfUPr5k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Soivtw6veIPyq8wN6w//Ju84ou8GT6H1kpUvMAV7hE8i7i8axK00tumSDZMjvoWf1QXG2meuF1pT723jjxFy4owapr48faLnYv3J3oZE9SzJa8jUKBpp3ARHYxeG063fZwIwErkbGzbKElvorD/mQg3thaF608BG2Pu39Lzn8iE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Y4AaTByb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Y4AaTByb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9B06BC43394;
	Sat,  3 Feb 2024 04:14:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706933667;
	bh=AI4bVDxKEynGd8k4bW7JH5gIkj11dvoftYlMqfUPr5k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Y4AaTBybtDRNf32G2XAW7ZBTxI6nacoru7MWQW5BCwC47q/SoMR5e9q3qDJejwEum
	 47m1zgNtEqu8iGb9V3Xcgbrh6BMzomxFoB3dtCwuX48LfuElvH718C8bu2PCYYHfUO
	 gY2HpPRMOANAm0nLp08azLPO3dKlEcOFmhd9Ubkg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Monk Liu <Monk.Liu@amd.com>,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Srinivasan Shanmugam <srinivasan.shanmugam@amd.com>,
	Lijo Lazar <lijo.lazar@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 256/322] drm/amdgpu: Release adev->pm.fw before return in amdgpu_device_need_post()
Date: Fri,  2 Feb 2024 20:05:53 -0800
Message-ID: <20240203035407.419312004@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240203035359.041730947@linuxfoundation.org>
References: <20240203035359.041730947@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Srinivasan Shanmugam <srinivasan.shanmugam@amd.com>

[ Upstream commit 8a44fdd3cf91debbd09b43bd2519ad2b2486ccf4 ]

In function 'amdgpu_device_need_post(struct amdgpu_device *adev)' -
'adev->pm.fw' may not be released before return.

Using the function release_firmware() to release adev->pm.fw.

Thus fixing the below:
drivers/gpu/drm/amd/amdgpu/amdgpu_device.c:1571 amdgpu_device_need_post() warn: 'adev->pm.fw' from request_firmware() not released on lines: 1554.

Cc: Monk Liu <Monk.Liu@amd.com>
Cc: Christian König <christian.koenig@amd.com>
Cc: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Srinivasan Shanmugam <srinivasan.shanmugam@amd.com>
Suggested-by: Lijo Lazar <lijo.lazar@amd.com>
Reviewed-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_device.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c
index 56d99ffbba2e..7791367e7c02 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c
@@ -1218,6 +1218,7 @@ bool amdgpu_device_need_post(struct amdgpu_device *adev)
 				return true;
 
 			fw_ver = *((uint32_t *)adev->pm.fw->data + 69);
+			release_firmware(adev->pm.fw);
 			if (fw_ver < 0x00160e00)
 				return true;
 		}
-- 
2.43.0



