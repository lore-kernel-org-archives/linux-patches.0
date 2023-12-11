Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E7F2851C44;
	Mon, 11 Dec 2023 18:35:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="n+RWI8On"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6CB1EC433C9;
	Mon, 11 Dec 2023 18:35:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1702319753;
	bh=LCoHE1ZQQzaGVAWoISfhH/pnbdOtcePClSwQY93EXxs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=n+RWI8OnqY0OpRdVz1fLZbDV9D/PKussiEUpwNXAbjgiP9iC9lZi26RRB7KwZyMpD
	 l5hcpRTjkeW7CURweKKsV9zxxvSIihWhkM3lqEnPXtNbLkfHsc08lN7gTQfnYFqV11
	 MBOLKadKYLDMIF4KPHtJGDMPE2p3dkDydFsNzoEE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiadong Zhu <Jiadong.Zhu@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 204/244] drm/amdgpu: disable MCBP by default
Date: Mon, 11 Dec 2023 19:21:37 +0100
Message-ID: <20231211182055.093618617@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231211182045.784881756@linuxfoundation.org>
References: <20231211182045.784881756@linuxfoundation.org>
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

From: Jiadong Zhu <Jiadong.Zhu@amd.com>

[ Upstream commit d6a57588666301acd9d42d3b00d74240964f07f6 ]

Disable MCBP(mid command buffer preemption) by default as old Mesa
hangs with it. We shall not enable the feature that breaks old usermode
driver.

Fixes: 50a7c8765ca6 ("drm/amdgpu: enable mcbp by default on gfx9")
Signed-off-by: Jiadong Zhu <Jiadong.Zhu@amd.com>
Acked-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_device.c | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c
index a164857bdb9f4..94e91516952c4 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c
@@ -3478,10 +3478,6 @@ static void amdgpu_device_set_mcbp(struct amdgpu_device *adev)
 		adev->gfx.mcbp = true;
 	else if (amdgpu_mcbp == 0)
 		adev->gfx.mcbp = false;
-	else if ((adev->ip_versions[GC_HWIP][0] >= IP_VERSION(9, 0, 0)) &&
-		 (adev->ip_versions[GC_HWIP][0] < IP_VERSION(10, 0, 0)) &&
-		 adev->gfx.num_gfx_rings)
-		adev->gfx.mcbp = true;
 
 	if (amdgpu_sriov_vf(adev))
 		adev->gfx.mcbp = true;
-- 
2.42.0



