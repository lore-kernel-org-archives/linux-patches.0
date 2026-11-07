Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794061362;
	b=tKLXYJiabO3Fod3ZGueUu/N3LawKxJSsv766jPLXnxlu3k40E7OJX8FstG41eMHIBHFN
	 oekpbL77rLBQ16j8agqq4Bd9Bi21fqQL6ksiYaiurpN+48avPCoMYMYiVmxftAfPkT5To
	 gU0l9/8qKRNcahRlCUMu1i+Notck6qzfZZOObwTinCLY6/xuUGo5i1bmnlo7Ns3/5gGqW
	 mEYgC6Vf7KddPRSjePiKeP6pfWXh6F4iiwyqz4GItWTRNEkmMv1BGmI5aHcwUSEkkPzjI
	 EEFPsDS7WeT79qpmfkJvftspmT/9fWfunE2QJsZmVqfwTrNIDeTjuwfHlHNAvJRBXbQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794061362;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=A25czGYoYJzLTl+Bdrz03ftkvVYhkJGxXzryMdCZD+w=;
	b=bUD2pInP7Bnd5mjm8R3GxE+N0mK3QaMWL7Y81AomX1pb86w2rtkkVrQwHBmCzAWn6EFs
	 oLf3HOIay1PDruNHGJuVJ4Tv3DvZdD4rE3MeTGTP61nmf+8Wc5pasaqRoXngUGNPqPKRd
	 HICTlOl6VTK7AqcDSviSDUyG0Xp4oejv49Zw6YBo9cZsZPuC5DrEFzhRsuQJ9MjR1Kcj5
	 6wJU6LlOq7yQAWuDsMbWxBsra8dk49yLpRdBBAYt0s/G4KJzCFaDg2jICcL0HDmo8AjaK
	 MqUP2kkxKXotWabsH49KWCW6sGehSOFvb+l+1xpwjx0+sB5IQ2mGFVhQfvbTlhh6ctQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=AdVaL10E;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F17E7606A326;
	Sat,  7 Nov 2026 14:22:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=AdVaL10E
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A03681F008A3;
	Sat,  7 Nov 2026 14:22:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794061361;
	bh=A25czGYoYJzLTl+Bdrz03ftkvVYhkJGxXzryMdCZD+w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=AdVaL10EMMyxGfJF77Ej+uoIKP2gfSTFm+bE9+7oRtkQBDyFrorWdets80gBRA02z
	 zrms4r/RUWvxGEO/2R2YAZBHpa23nIioPKbh1zENgR/95fbt830iJq0Ed18PgdWJoX
	 Ev1i9lJQiPXn0LCj00gl+sXk/uGlFtGm1CLg9JjU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yang Wang <kevinyang.wang@amd.com>,
	Candice Li <candice.li@amd.com>,
	Kenneth Feng <kenneth.feng@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0486/1536] drm/amdgpu: Disable runtime PM for externally attached dGPUs
Date: Sat,  7 Nov 2026 08:41:42 -0500
Message-ID: <20261107135011.131436244@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134957.653319350@linuxfoundation.org>
References: <20261107134957.653319350@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
[ sashal: Adapted the context to this tree's older code, where amdgpu_device_supports_baco() takes dev (a drm_device) instead of adev. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_device.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c
index 13363330820a8..f022f8cc97306 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c
@@ -380,6 +380,13 @@ void amdgpu_device_detect_runtime_pm_mode(struct amdgpu_device *adev)
 	dev = adev_to_drm(adev);
 
 	adev->pm.rpm_mode = AMDGPU_RUNPM_NONE;
+	if (pci_is_thunderbolt_attached(adev->pdev) ||
+	    dev_is_removable(&adev->pdev->dev)) {
+		dev_info(adev->dev,
+			 "Runtime PM disabled for externally attached device\n");
+		return;
+	}
+
 	bamaco_support = amdgpu_device_supports_baco(dev);
 
 	switch (amdgpu_runtime_pm) {
-- 
2.53.0



