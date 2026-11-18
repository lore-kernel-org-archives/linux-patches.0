Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795043027;
	b=i+3y7YbeXrIHVTbxm7yGT1HGtPIDPngEyZxf0IyczEdYN3PT/QNtLo7ehz2S84lXtwp5
	 +JREN56Qv0IU1EaQ9T21E5J40gZ1gXXUhx7Ikdw+yUbD7pp0LBp1h9Ocqpzf5IEgLM4lU
	 W27jhp5chruQwZeHaoDPmLdGnWaqZsjLq7UwLbCwoBJ0hRh5qhIVA08e5AEzzgW201yDt
	 Pdl9d12493L/nWphe35CoawGOwacn6XR/BKFtxpAYcs0krj7Rlh+wbpODsF6ha9mjY9Yn
	 GLV+G04ToJmN97VEJPD6tUOn/J0Rk115zdoZQ4pCQwDUK2I4olZXm7KD6gNuXoSlnAw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795043027;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=O0pHGyEJnd9Z/cHqEa3Pftm+VIaJ1pHmhCS2EpWatuY=;
	b=DyMmvZGYUpvIYZ2vxn76J/NEP2ICzc8+vK7U3PPHO8W+qQ41cdm3RAgjxIZNTWJAGz3s
	 81va/eOOPBgEhlf0JsSpbNAlbaHDpuKPVXXFdW1nxvrcr7vbPDpnExpOHkjizIiCnFhlY
	 VR916CZRI44dPib3b9bR494Vyx55RozsRq6H1HV0vHUEbQYIxNlXbew4gEhkJ87G5C1jf
	 RrF8ExXfHVZx1+PkUbuUWMpSpM3rCU9IFbXPotFwgz/hndIYQxyPjUh4qmgfWMYvSzVIQ
	 xljPe1OggwWmX3KANojujIlv1CFIxqLm0iyZ5EwMKKh8qQG4dW4iNrxAQBXr3wvQ04Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="mi/ErXtd";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE726606A31C;
	Wed, 18 Nov 2026 23:03:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=mi/ErXtd
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 051BD1F000C4;
	Wed, 18 Nov 2026 23:03:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795043027;
	bh=O0pHGyEJnd9Z/cHqEa3Pftm+VIaJ1pHmhCS2EpWatuY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=mi/ErXtd5bQGC/sMLr0BhGs3bt9yxgs58o9bVly3XX34NBfGaGXRIAkWrPj4rjjCd
	 2nyBqSpmQ/yxCVUI+Q4YPwCa83QoS9i+63fgfBEmdIkDHeir4t2cLHVT9v+k94mrvX
	 4c4Pwd6m5SJCrFjtqGIgiQZDrL/LbovYXygiFHs8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	YiPeng Chai <YiPeng.Chai@amd.com>,
	Tao Zhou <tao.zhou1@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0022/2857] drm/amdgpu: add bounds check to prevent array overflow
Date: Wed, 18 Nov 2026 15:17:36 +0100
Message-ID: <20261118150202.162510291@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: YiPeng Chai <YiPeng.Chai@amd.com>

[ Upstream commit db15c49a17b8fab9ada38f3a548e5353d7d6b1a8 ]

Add bounds check to prevent array overflow.

v2:
  Add warning messages.

Signed-off-by: YiPeng Chai <YiPeng.Chai@amd.com>
Reviewed-by: Tao Zhou <tao.zhou1@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_ras.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_ras.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_ras.c
index 4b7b3278a05f1..969477118df31 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_ras.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_ras.c
@@ -2937,6 +2937,13 @@ static void amdgpu_register_bad_pages_mca_notifier(struct amdgpu_device *adev)
 	 * Use this list instead of mgpu_info to find the amdgpu
 	 * device on which the UMC error was reported.
 	 */
+	if (mce_adev_list.num_gpu >= MAX_GPU_INSTANCE) {
+		dev_warn_ratelimited(adev->dev,
+			"mce_adev_list full, skip notifier registration (max=%d)\n",
+			MAX_GPU_INSTANCE);
+		return;
+	}
+
 	mce_adev_list.devs[mce_adev_list.num_gpu++] = adev;
 
 	/*
-- 
2.53.0



