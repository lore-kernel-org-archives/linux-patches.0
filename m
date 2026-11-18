Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795044189;
	b=JKmrlnlxwToGCVKkMkxuw+6kuAHerxOuu9/6BKtC5Jr4JmOOZefBXZbAPAQseNwvOcoB
	 R1gExk/vAwLmWdm5LAsNscsX5otaEadnSLmEb+r0brCZj0/FpyXHUTvySd6EYAqnwT6KM
	 O4vPDFbUWUkOjCERHNtjvPE5Ij5HOvNkFp78b5fhARDqoKWy9PAmeKqizBtzt8nm0S9g3
	 otuyQMTUeD9rbRMppTE+W6JZG7mGetyPSbbDlCnsG2RAs6NCXyjwgl52rTfsPuVMcfaMy
	 oh2roJKZ3n4ugXuWFNUq3CWQF3lsU12CaCZBfrcDhbbn0aA2BmTEZD34wrJJiFno7jg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795044189;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=5QNXXVOf75RwxMnMGfzIbAID383r+Eh47iim/kTuUpY=;
	b=qf/sTNeGJM9sIj/rhhj6SmZxQJkTwfAP6cKeXxYJfMS3hIv/557/Vejui7OZQSqI/L1L
	 cuHvipO3PJX5lHNiwEOqiEZbtdPehDeQM7FpFow5R9eJnA7GA1SKbpqeQfmr6uxtb7jOG
	 lHdiphww0M+4rAJz4kpu6RSwLlLsd4S5P7SxfuJwT/SoUbWf314NfBFyJuH7cg6xQuSCO
	 XhMZw5XQtICfp7vP+nNyPDhYR0ptK8+yal1ZonBdSzTLwLFo5E4tOQ1NrWcqURogj2KbR
	 nFDZs65bFaUwaeVVtpmfPQAx0l0orJOkP+XdJODeyIWSds++s3dngEX384xvCRuJn8A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="XW/p3La6";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 92AAC606A320;
	Wed, 18 Nov 2026 23:23:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=XW/p3La6
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 926591F000C4;
	Wed, 18 Nov 2026 23:23:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795044189;
	bh=5QNXXVOf75RwxMnMGfzIbAID383r+Eh47iim/kTuUpY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=XW/p3La6J74oImqqWxdrBPNbnPmGL+0VoO0MhuaZ3u6HwObZGD654LCkInc75bxya
	 Jgvo5+JlJyQKTTsnGD0d5bqemq50NZJjTTQYmwYweweKhHpsRRheQcLit0upLdSKq0
	 DanzKsiibQPz9ovyI35pjeXQ3sZF2Ca3a2jmk2yE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Theo Andersen Carton <andersen.theo@gmail.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0480/2857] drm/amdgpu: skip the noirq suspend reset for a switcheroo-parked GPU
Date: Wed, 18 Nov 2026 15:25:14 +0100
Message-ID: <20261118150218.718619202@linuxfoundation.org>
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
[ sashal: Rebased the early-return guard onto this branch's older suspend_noirq body, which has no local r and no reset-domain locking, and placed it before suspend_complete = true. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_drv.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_drv.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_drv.c
index 67b5d0017fd04..3b6688d6687b1 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_drv.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_drv.c
@@ -2441,6 +2441,14 @@ static int amdgpu_pmops_suspend_noirq(struct device *dev)
 	struct drm_device *drm_dev = dev_get_drvdata(dev);
 	struct amdgpu_device *adev = drm_to_adev(drm_dev);
 
+	/*
+	 * A GPU parked by vga_switcheroo has no power and no PCIe link, so the
+	 * ASIC reset below would fail and abort the whole noirq suspend phase.
+	 * Bail out like amdgpu_device_prepare/suspend/resume() already do.
+	 */
+	if (drm_dev->switch_power_state == DRM_SWITCH_POWER_OFF)
+		return 0;
+
 	adev->suspend_complete = true;
 	if (amdgpu_acpi_should_gpu_reset(adev))
 		return amdgpu_asic_reset(adev);
-- 
2.53.0



