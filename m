Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795043887;
	b=eg0RokB6jKUhCITgfpU0zz+nce6ShbeOGRl+3r0knY1vTTpbeskt7RCGRcbXwFhh1T1T
	 Uw35/LakNjMZYexf8SSriSaY5koSHVn+oP6inpzw4AQVynUUoZRgpQ6zcwKmcSAlPqPYo
	 3aYxnHogK+zd4a7u3QM2WNHMfE3yJa4S82K9hfG7/mXVqxqRTSCQB9yFWClTztpSVdv0S
	 Z+S6FBtJdrUegERLD/KwTwTH/UXj9X4ATIB4YScBRwER4JN/WkMJLN2VlRBQyrEibPNjL
	 T0FBWqmeqhq0El9rOj8RHeGfwMJZp7ufep9f1e9uqAwXf2HuIoxQjhkwfVMXL69dvhw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795043887;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=dDWJl14YcmSY/IT+LdZhzwzJOVYLdY0n3h30JRPBA9g=;
	b=s6Q7ucs2kiM8miKgECXK8VbG/PzCPGaw/ClFKxl6ptWm143FpItIXs4V9TUFbDC711QK
	 T4kh1fxtD0aFQVupFx9izjJzlOeNTU+pVMpjaR+wSaK91RYpVwoiIonkuryizOH+usiLj
	 DI64xUtbVNOMrw3AXMjGWL7MYKYe+m7zknWP1dY3qk0Az0z72bmgVPdol6Uq+4BaKvYUz
	 YQ4qWsWpuviIJ4y9U13T53R67s/uaXJSs2NDAYnPpwtee1o/I24wXT8EphXVHzTtdoc5X
	 CY8xSd4duxnbqLkQqX7N1M6X0W3mjdn5ov+u+dcMnFd0cjImMej0cdFH1awK431LJsg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=rDaYtQ4d;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 57622606A325;
	Wed, 18 Nov 2026 23:18:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=rDaYtQ4d
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 98DF61F000C4;
	Wed, 18 Nov 2026 23:18:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795043887;
	bh=dDWJl14YcmSY/IT+LdZhzwzJOVYLdY0n3h30JRPBA9g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=rDaYtQ4dXH3uLUGRqdizg1H1U50yvjjeqwn3HfAWhwOj5VPs52D7vIrEsLARToiM1
	 Zx1aL8Ggfy2VdAfx+jzjuNCwflKQNAZV8on36PvosnwXkR55tzZ4qXR0pYSzUTbXOq
	 YoFH6hfsQokWS2S3QonCq+1ITlI+HFAJtdaqPQd8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yang Wang <kevinyang.wang@amd.com>,
	Candice Li <candice.li@amd.com>,
	Kenneth Feng <kenneth.feng@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0364/2857] drm/amdgpu: Disable runtime PM for externally attached dGPUs
Date: Wed, 18 Nov 2026 15:23:18 +0100
Message-ID: <20261118150214.533634681@linuxfoundation.org>
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
[ sashal: Applied the runtime PM externally-attached check as a new leading branch of the inline if/else if chain in amdgpu_driver_load_kms(), since the detect-runtime-pm-mode helper doesn't exist here. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_kms.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_kms.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_kms.c
index 7f850cc53ec9c..e2a46651a4633 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_kms.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_kms.c
@@ -148,7 +148,11 @@ int amdgpu_driver_load_kms(struct amdgpu_device *adev, unsigned long flags)
 	}
 
 	adev->pm.rpm_mode = AMDGPU_RUNPM_NONE;
-	if (amdgpu_device_supports_px(dev) &&
+	if (pci_is_thunderbolt_attached(adev->pdev) ||
+	    dev_is_removable(&adev->pdev->dev)) {
+		dev_info(adev->dev,
+			 "Runtime PM disabled for externally attached device\n");
+	} else if (amdgpu_device_supports_px(dev) &&
 	    (amdgpu_runtime_pm != 0)) { /* enable PX as runtime mode */
 		adev->pm.rpm_mode = AMDGPU_RUNPM_PX;
 		dev_info(adev->dev, "Using ATPX for runtime pm\n");
-- 
2.53.0



