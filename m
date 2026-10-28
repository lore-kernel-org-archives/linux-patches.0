Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793217308;
	b=2sQZ5pwtuS2ftDPyBQsqesvyMKhRMk3FnPFHREzCOIJNy2olF+Jw+X86dJU5FZBPANoG
	 R2wbOsVPnc3FqecTb2azv4QpUCK1ykZCJ1Gzgc+qjBnDhjNUTdC4qHU1m0v8tn4uP00kn
	 25YdovsatDRmEoYeWF4hjGoTi3FqlPWyqPFq2D/VtVW6YyWmTVTsi8wtb/kfckTSnUaVm
	 XmiXclnxgG6Hu4dzJqF3W6D6g/IZGN0r3/6tJ8l4pVkjS57rJeO47JaPGQ7ltErG6JsK2
	 Y/povscbMdhT8rBPf6/BBmh0ZKPmamHMlg5FAD9TrkqlqiiwMVcA4kETfF/3LwH4/IQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793217308;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=zwYjHKYc4WW5Q812Skul6aVD/L4zhd+IcFmZRtFxpdY=;
	b=oONnfqdwsCWHxBXM8w4BhJrUh8OZMqoganiv3TiMXveRBb6sbd/ywR2C/acofCsABPcr
	 z/gA3cTcuUYA3jTPl+7pXMiDXdk8AQlhIOJQ2M5t7RuVcnbsdT1NwkUsDS4JAcg0+87pu
	 76YGW+z5NiSBIHJp/rRmeBzG00rQVxbGl90GW6+qsovT5OmbvgnbvVhJ6TkfG2XTa7qMI
	 zOTai123qyaG84Wzl7yRqTVHAUlsVsaIbCzyGCXlrF9EY1vORj24yiG9k8mw2cuIx5Q++
	 svJAr8bUseojvAAFu+wXZFrQNs1K+WmPXmCMfsPFnDyIFrN8xexNV1HV3WK2JCP9RRQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=X4idPpXj;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 937D9606A31A;
	Wed, 28 Oct 2026 19:55:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=X4idPpXj
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E471E1F01825;
	Wed, 28 Oct 2026 19:55:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793217308;
	bh=zwYjHKYc4WW5Q812Skul6aVD/L4zhd+IcFmZRtFxpdY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=X4idPpXjA0vijD0wt4Hohq0zZVBWM+x0QH/Ywi0dUx9lQ7VJvxQVuvWkqj+fetbkQ
	 g/Rs8xp8cL+FWHRIQjChpxcyW+GqNYEfy7G8ca2KExKkZjXlXmIcpMozpjSNxZqsfU
	 zCNc9GJi61DqiDuoqyBLaYAUNwAK2q7MC9+96KRs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Perry Yuan <perry.yuan@amd.com>,
	Yifan Zhang <yifan1.zhang@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1859/1887] drm/amdgpu: ensure no_hw_access is visible before MMIO
Date: Wed, 28 Oct 2026 18:05:55 +0100
Message-ID: <20261028170541.756493877@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
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

From: Perry Yuan <perry.yuan@amd.com>

[ Upstream commit 31b153315b8702d0249aa44d83d9fbf42c5c7a79 ]

Add a full memory barrier after clearing no_hw_access in
amdgpu_device_mode1_reset() so subsequent PCI state restore
access cannot observe stale state on other CPUs.

Fixes: 7edb503fe4b6 ("drm/amd/pm: Disable MMIO access during SMU Mode 1 reset")
Signed-off-by: Perry Yuan <perry.yuan@amd.com>
Reviewed-by: Yifan Zhang <yifan1.zhang@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_device.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c
index f75937cba2953..e34e2cd8ac183 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c
@@ -4920,6 +4920,9 @@ int amdgpu_device_mode1_reset(struct amdgpu_device *adev)
 	if (!ret)
 		adev->no_hw_access = false;
 
+	/* ensure no_hw_access is updated before we access hw */
+	smp_mb();
+
 	amdgpu_device_load_pci_state(adev->pdev);
 
 	/* wait for asic to come out of reset */
-- 
2.53.0



