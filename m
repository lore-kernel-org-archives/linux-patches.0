Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795034587;
	b=2W0hcNrDuM4XvaHP8Z9TfnXoAvqPv68ZeGKuZAO1oJkyGZquyiO2CmOUdOkrJDSUayC/
	 aHFB1wMECExmbwIbey58+LHBezmcjCDpdfWdVLNuR+iLW+gNKDN9xkYkYS62mdsRIrU+/
	 aFoM8LSGPpsh5AnXHIDlnYn7ttomFZxvs76oKUbDyCwewUg8m3+1b+d/fr8dHOYtNfmno
	 HMgiywxSmyqW0rAdIdN+v6GYwE9lk5rOF0k3sdRBQlgnuWcXrW5xEmUxuwivgDif07GtF
	 OAAkhrqwhWtqeaPZYhAcqLvMFHUae0GhlK/qK9Bl3Fu0rKufsIzcMamm2FER2WDdOQg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795034587;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=OS0KHp6LHKyjXdnbdkgIr/V+KMabQIpPeDrxxOOQIvI=;
	b=zOGIkF4SKeN8UKgcRZMtES19jKLtM/zjty+heKFe+4GwLtG6KIp6mJ8Yz4tU0aIxS4B1
	 f5DtDFL2SEnxLc0+6h50rxiej/csTzKFDUpqMkKXd+p5ksGrrGEoBc//HhPVQ6cBSmGLQ
	 k3fxMQnMyyliXKVV5mSsf5onM1JFxfYwK4ZFKkARAbAyzNAfJTkMo7ukUAiDT0UuFzcfP
	 frUfYV0tgeLbDbqH24d7dm+9xaQjKUfUBapYxFyeqqFfGTjE/eS6FZJN4O7YpjnJscwSG
	 5UQCE7FGQrQRw0JtEgF/fDoOxtWZKWqN1aXpYgTx5u0dRLcqwp2hppTv1aaf3gaRMXw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=WY2WM+Re;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D07F8606A320;
	Wed, 18 Nov 2026 20:43:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=WY2WM+Re
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 30E361F000C4;
	Wed, 18 Nov 2026 20:43:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795034587;
	bh=OS0KHp6LHKyjXdnbdkgIr/V+KMabQIpPeDrxxOOQIvI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=WY2WM+Re55wZ3E57VA1ChobOJlLb0tYfpr95seymHToLYC1QFPmoENIKQXlPt4Bfj
	 wD3miKkJD3Bdidl0iUCgHsCfLu5O/BlVjgVXdpsfMBTKFFfNU06IQGZfksAL4Zrd1t
	 UGvWRr9lk15i/cfUPT/bM5EFo/e0DkT7ZI0HgiVI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yang Wang <kevinyang.wang@amd.com>,
	Candice Li <candice.li@amd.com>,
	Kenneth Feng <kenneth.feng@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0421/3318] drm/amdgpu: Disable runtime PM for externally attached dGPUs
Date: Wed, 18 Nov 2026 15:17:23 +0100
Message-ID: <20261118150329.195359698@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yang Wang <kevinyang.wang@amd.com>

[ Upstream commit c52feb4365396b6a881b5e8a95540517ffabb3b7 ]

pci_is_thunderbolt_attached() requires an upstream PCI bridge with
is_thunderbolt set from an Intel Thunderbolt VSEC. This does not cover
the affected ASM4242 USB4 PCI hierarchy:

  00:02.2
    \- 0f:00.0 [1b21:2421]
       +- 10:01.0 [1b21:2423] -> 45:00.0 -> 46:00.0
       |  -> 47:00.0 -> 48:00.0 -> 49:00.0 [1002:7590]
       \- 10:03.0 -> 76:00.0 [1b21:2425] USB4 Host Router

The host router is outside the GPU upstream bridge chain, leaving no
ancestor with is_thunderbolt set. PCI core propagates DEVICE_REMOVABLE
below the external-facing PCIe tunnel. Disable Runtime PM when either
pci_is_thunderbolt_attached() or dev_is_removable() is true.

Cc: stable@vger.kernel.org
Signed-off-by: Yang Wang <kevinyang.wang@amd.com>
Reviewed-by: Candice Li <candice.li@amd.com>
Reviewed-by: Kenneth Feng <kenneth.feng@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
[ sashal: Moved the externally-attached check into the inline runtime-PM setup in amdgpu_driver_load_kms() as the first else if branch, since the detect function doesn't exist here and an early return would skip later init. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_kms.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_kms.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_kms.c
index 11e8370176258..cb7a74286e54d 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_kms.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_kms.c
@@ -152,8 +152,12 @@ int amdgpu_driver_load_kms(struct amdgpu_device *adev, unsigned long flags)
 	}
 
 	adev->pm.rpm_mode = AMDGPU_RUNPM_NONE;
-	if (amdgpu_device_supports_px(dev) &&
-	    (amdgpu_runtime_pm != 0)) { /* enable PX as runtime mode */
+	if (pci_is_thunderbolt_attached(adev->pdev) ||
+	    dev_is_removable(&adev->pdev->dev)) {
+		dev_info(adev->dev,
+			 "Runtime PM disabled for externally attached device\n");
+	} else if (amdgpu_device_supports_px(dev) &&
+		   (amdgpu_runtime_pm != 0)) { /* enable PX as runtime mode */
 		adev->pm.rpm_mode = AMDGPU_RUNPM_PX;
 		dev_info(adev->dev, "Using ATPX for runtime pm\n");
 	} else if (amdgpu_device_supports_boco(dev) &&
-- 
2.53.0



