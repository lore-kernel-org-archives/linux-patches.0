Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E70A978B7C;
	Wed, 21 Feb 2024 14:07:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708524447; cv=none; b=eVhBoOS3sAIrGOtAFlH8SSulH+HpxvuN4YvrSGEQujOn9S8Mdv3bMoNTEW2LCE9k52VMtWgRj2MRH8FqphGedzAlzaqMiMD4Yihs11XNr63NuWdppFYwOUSxF9XZVFKIaoeyZRa7duz0G4QlvtfaXA9vQNgLtx18t+zLuaW3mDo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708524447; c=relaxed/simple;
	bh=PtngySrfTBpKbfpvllwb36DmL3TwADLVZJKyxwGy0+k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=qIlNswRxL15cKsic9ylm1Ga96/PRQxKOxl4wYw/PMfjN7GOwwIqQhP8olFsHn9ohSzqkFzK7xswg70tf/CuLddWeBw5jknMXy+ff2jS9APA8E/QWA45s/E1jVcFLaJTue8X2pBo+vSqhLvkcWChtG+09Q2wL3bJWXKaTLA/xtVM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bGdGyf4m; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bGdGyf4m"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 58A4AC433F1;
	Wed, 21 Feb 2024 14:07:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708524446;
	bh=PtngySrfTBpKbfpvllwb36DmL3TwADLVZJKyxwGy0+k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bGdGyf4mowsBeffRgD7bRxJwWekgdkBdBioBldvYtwZyALBkLU1e47S9c0HLNIyv7
	 PuHoWmOrmBn3aO9M/8OgPexTg8vCKQsdg8h7w+LFJk1peH0srLnONhrYL0QYwHeVqR
	 PtuvVnoy75NMEAhEdPfslhef0QH4L9fQCkZ3l76I=
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
Subject: [PATCH 5.10 219/379] drm/amdgpu: Release adev->pm.fw before return in amdgpu_device_need_post()
Date: Wed, 21 Feb 2024 14:06:38 +0100
Message-ID: <20240221130001.380540168@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240221125954.917878865@linuxfoundation.org>
References: <20240221125954.917878865@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index a093f1b27724..e833c02fabff 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c
@@ -1184,6 +1184,7 @@ bool amdgpu_device_need_post(struct amdgpu_device *adev)
 				return true;
 
 			fw_ver = *((uint32_t *)adev->pm.fw->data + 69);
+			release_firmware(adev->pm.fw);
 			if (fw_ver < 0x00160e00)
 				return true;
 		}
-- 
2.43.0



