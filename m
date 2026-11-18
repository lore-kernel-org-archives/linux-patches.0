Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795034896;
	b=MRYtO7UgneNICILeDyTh2MJkeqPSlb5BfzKicLCdnureEasGs86yOV8ioBErylHuxJSF
	 xAhuBlYWyQMnfmZK3ShPxOVeiNrwvsjKLPMLTgVMp6ieMsRxedtXEFJTKBjFxQoMLOsZj
	 uIS3kURUm9EoQgqLgKftBE8OGgYw9bHwbZZWLnX7heSFnfO/dgZf8PHeJrIbKzNFiDJ9j
	 xsHnZjAgXY2qgES9Xx3GcD6Vt0KlA29/WcBhJwHr04teR7gYnM1tAekIJEzG4FDQxZJRX
	 DA9kPTb/ss79koiczf6sR4mbXxQ3wwrXYAZOvP3Gf3Q6R9W6vwcIV69qKSQs5395zIw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795034896;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=hYRDC3F1eLtTCoWg59zwwxvIVxyB0V5cWuNsL/eUc34=;
	b=io1GAgJtsDUvePlIXK2q6ryypljhyxxUUWlQIna8btV31wqrmZBc15vApXn+qCvS9Rj0
	 7TlYmFX/5dLPAzKfBybobkH6YnUxvCCuHFQoxF2MybCtOtJ7oy0AsDEzP8W6RlnF0cziP
	 8WQSAyOslf30MZ24vZ/9/dorwij/+jAAIQz01Y8MTH+OgmHVn2OyVas2M8hNLbMolZFCE
	 Z/YvviCKBvJp/+CS4pZD9OZ1kVAOW9qdX124MlCH9qRQL9SF0f05v9C67uVh25W3c6ruQ
	 XTUMi4X4oHtfqJMSaYZXTME+CmdrHQSGVteGzTz3CACvlDCUJTu0Ml98Q+peqZ6Tv/Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="m5+HqIC/";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 64040606A31C;
	Wed, 18 Nov 2026 20:48:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=m5+HqIC/
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B702F1F000C5;
	Wed, 18 Nov 2026 20:48:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795034896;
	bh=hYRDC3F1eLtTCoWg59zwwxvIVxyB0V5cWuNsL/eUc34=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=m5+HqIC/Aku4oC8LJMDzjuo6NK73PwkQObYiXVCYXbmTvovl8lW4u2etLve6/dORK
	 2huhG2UT4tJYk1HouLvv255tQZHm2ch/QQYCGWcYa4IIS9iIt8QDi1i5nxYncNUxxv
	 PwKF2pFu3akV3hnoGP0xLoDlT3NzLeWrX+nLLe8A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Theo Andersen Carton <andersen.theo@gmail.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0531/3318] drm/amdgpu: skip the noirq suspend reset for a switcheroo-parked GPU
Date: Wed, 18 Nov 2026 15:19:13 +0100
Message-ID: <20261118150333.154366450@linuxfoundation.org>
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
[ sashal: Kept the local amdgpu_pmops_suspend_noirq() body (no int r, no reset-domain locking, bare amdgpu_asic_reset()) and inserted the switcheroo power-off early return after suspend_complete = true;. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_drv.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_drv.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_drv.c
index 1712c399c962d..1f8171c148ee6 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_drv.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_drv.c
@@ -2437,6 +2437,15 @@ static int amdgpu_pmops_suspend_noirq(struct device *dev)
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



