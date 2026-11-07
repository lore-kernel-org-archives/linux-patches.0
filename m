Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794061444;
	b=DdZTaQRmILjmOGiw+Q0Bye/mgABPkane5CXBh4ga7BimROr2KsJL9SIqH/9tbGRPJJut
	 spixpzeb+v1TnqFvl2yGM7bE/v46Vxq96VXyYfWCYW8lnzOX4hrNww/nrXSCYypYdGeux
	 QcW8h1bLSdirt8eGu68m8BkUAcvlIRYrmcaE1+WF2bR6Wsf3jPZshPx8WW5Re1r7bHl3D
	 HQaaAhdZFd1ngZr04nar7H319bmnEbuRW6QTwlvhlEj6dVXP1zXKjvsW0HsLnAODiwmV6
	 8fQYfNFK4P3Cm2zaGx3aYxD1mMoEjpbduzEONUkQPwrSnFhq+GCNRE+r2n9US0331Sw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794061444;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=H0XWl/hsgzk23//UCb9Y57BR6q6X8LkO0mRD7TxlmyY=;
	b=IUfIfM77TVnbdFSbQ+y7XPVg4XeOjy+dyiDPdn3ElAuK0jIyzorF/iv9YcXtPc7TLGl6
	 RJZ9sRoEg9vkwEU1ge7hEh/1cWYqiSou62BeW48mIQt5OenflLit2t29laCPf9iKooQAT
	 UdnMQYpQi+bHDu+46eMU8nbUecO54q7QBNt9WK8IU5VOkEUIHWRbJxE7MnoGN0D3CTSgH
	 V9HrB/tA/YD01UID4Ouvz2jGlGMMWLL+TXL3QsM1lUo0zkXbCNuF282BbmzyvaaQWjJxv
	 wBOjdg911u5rDd5Szcx4Kppg66alKJORq+urx2/4SduVunZTkWWGRpK5SW6u6N6PQcA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="u50/vJCX";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC610606A326;
	Sat,  7 Nov 2026 14:24:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=u50/vJCX
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 783F01F0089F;
	Sat,  7 Nov 2026 14:24:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794061443;
	bh=H0XWl/hsgzk23//UCb9Y57BR6q6X8LkO0mRD7TxlmyY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=u50/vJCXDx0Uh8ryzdt/bcfzNvM+wclIiSbI0GI7KGFLec1i+dDhl5X6B/3VwzYpb
	 RZI4mC5TXCyJ8KAbjfL4mCUuKmazEMSj2RuqiFuVBmyj8Jj5iH2hAFSbai/2hJ9qzS
	 ELAQL+gf2uvBMxjUZqnSWCal500CxQVR5D/3oDzQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Theo Andersen Carton <andersen.theo@gmail.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0551/1536] drm/amdgpu: skip the noirq suspend reset for a switcheroo-parked GPU
Date: Sat,  7 Nov 2026 08:42:47 -0500
Message-ID: <20261107135013.077030784@linuxfoundation.org>
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

From: Theo Andersen Carton <andersen.theo@gmail.com>

[ Upstream commit eadb85cca111152bd334b861fb53747ab851d13a ]

amdgpu_pmops_suspend_noirq() resets the ASIC unconditionally. When the GPU
has been parked by vga_switcheroo it has neither power nor a PCIe link, so
the reset cannot reach it: pci_set_power_state() reports the device as
inaccessible and amdgpu_asic_reset() returns -EINVAL. A failure there
aborts the entire noirq suspend phase, and with it the system suspend, so
the machine cannot sleep at all while the GPU is switched off.

amdgpu_device_prepare(), amdgpu_device_suspend() and amdgpu_device_resume()
all bail out early on DRM_SWITCH_POWER_OFF. This callback was added later,
for an unrelated reason, and did not inherit the check. nouveau guards
every one of its PM callbacks the same way.

Bail out the same way here. On a single-GPU system switch_power_state is
never DRM_SWITCH_POWER_OFF, so this is a no-op there.

Found on a MacBookPro11,5, where the Radeon is powered down through
apple-gmux so that the internal panel can be driven by the iGPU instead.
Every suspend failed in amdgpu_pmops_suspend_noirq() while the card was
off; with this check a full S3 cycle completes.

Fixes: 9e051720f9d3 ("drm/amdgpu: Ensure HDA function is suspended before ASIC reset")
Signed-off-by: Theo Andersen Carton <andersen.theo@gmail.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit 539d0558638a6dcc066f1cf592b6b9a52adc8ea4)
Cc: stable@vger.kernel.org
[ sashal: Adjusted context because the older function lacks the reset-domain lock and int r;, so the switcheroo power-off early return is placed after adev->suspend_complete = true;. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_drv.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_drv.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_drv.c
index cc95cc43a3e86..1a112a3617576 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_drv.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_drv.c
@@ -2623,6 +2623,15 @@ static int amdgpu_pmops_suspend_noirq(struct device *dev)
 	struct amdgpu_device *adev = drm_to_adev(drm_dev);
 
 	adev->suspend_complete = true;
+
+	/*
+	 * A GPU parked by vga_switcheroo has no power and no PCIe link, so the
+	 * ASIC reset below would fail and abort the whole noirq suspend phase.
+	 * Bail out like amdgpu_device_prepare/suspend/resume() already do.
+	 */
+	if (drm_dev->switch_power_state == DRM_SWITCH_POWER_OFF)
+		return 0;
+
 	if (amdgpu_acpi_should_gpu_reset(adev))
 		return amdgpu_asic_reset(adev);
 
-- 
2.53.0



