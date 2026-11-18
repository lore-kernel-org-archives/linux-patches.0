Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795034590;
	b=YLlmeT8llDu3EEgGM9hq0QJ6GJbZeZ6lZDm2cI2817unU/mnndR104Ds5AV/41HFWeCC
	 q+piNac/QsMjDDAX+UZPogWZRUUuqpWRU12WqITqelGxt8dC94fR6KJWyIp7Y8SyiPRad
	 PrxHLMI9v4mHB9JLq/IdQNXg/EZXZU1jwMa7+AQZGE0WE3nnGxAk39oySg0sPxNIgguhg
	 l7+yT3ifTh5NyaGYipiO7R9TbNCv75PL4aSHiMIYtvd6U+bWMiFniE4VqDuAtI218IgLo
	 6lab9QTFe7Dudec2Z5OfqK8hayLzlDR2WNnV8dhP+FR7Al+eEGPOH45pM4CKpZpEpQA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795034590;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=wHuDtwwBLO7Fkbal/lqOlsoAxMjGVcUER2TrCUch5R4=;
	b=n4i1VjSXyRZEwktKinCN550GXeuO4vdbYkl8yJ+lAGUmI807ksFwy32sWMiRqmQEqrg+
	 tjdZjbVdDC90m9ZMGjIhVJoli1NS+4KsxeAx5WYbzUptKW2nhJZXxOtbCM/frtRaXW30O
	 8Z4jA4EnkNcC6nzYRIDIrbT1MA3YynyKwAQXTfh/PaHTIAbG1VHGrebEkFR4a1Q2I0VvK
	 dqfWV3ywhO+wTbJHnHTA6YKMlKLso6ei3Lrz+XZemcv3p9eDRNnxXZUOs8Bgf8IrDJOq3
	 4tzeBsasfWSwCDXfPhBKNnEQOcjqSSph86+XHFQrfOP+sby8W+ets1fPp/kq8SY7inQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="hL1MQml/";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BBD24606A32A;
	Wed, 18 Nov 2026 20:43:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=hL1MQml/
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 143A31F000C4;
	Wed, 18 Nov 2026 20:43:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795034590;
	bh=wHuDtwwBLO7Fkbal/lqOlsoAxMjGVcUER2TrCUch5R4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hL1MQml/s3dVbyAgjOtXqC9+6I6i/Nzhbo4AXvlV5mLPDN7jKXNTgaz5q7I03eE3G
	 KT3AeLZYPnMkK8ac+UJfs2VIcXIn3HLWk/unjWjje5ocAIznHmuvR8Fp6hYQQMuLdw
	 h6Uxisq5pKXDsyW5LKi0ETrC2ueGeBpqU6Fclgrc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jesse Zhang <Jesse.Zhang@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0422/3318] drm/amdgpu: force complete the MES ring fences on reset
Date: Wed, 18 Nov 2026 15:17:24 +0100
Message-ID: <20261118150329.230491457@linuxfoundation.org>
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

From: Jesse Zhang <Jesse.Zhang@amd.com>

[ Upstream commit 48dc279c3010ac8f91b1845b2abb3a1e9943a0f5 ]

The MES scheduler ring has no drm scheduler (no_scheduler = true), so it is
skipped by the force-completion loop in amdgpu_device_pre_asic_reset(). It uses
a polling fence whose hw value lives in wb (GTT) memory and survives a MODE1
reset, while fence_drv.sync_seq keeps advancing for every packet.

When the reset is triggered because MES itself stopped responding, the
timed-out packets advance sync_seq past the last hw fence value MES wrote.
After resume the first MES submission polls forever on a seq that is never
written back, failing the resume and wedging the box on a second reset:

  amdgpu: MES ring buffer is full.
  amdgpu: *ERROR* ring gfx_0.0.0 test failed (-110)
  amdgpu: resume of IP block <gfx_v11_0> failed -110
  amdgpu: GPU reset end with ret = -110

Force complete the MES scheduler ring fences together with the scheduler rings
so their hw fence is realigned to sync_seq.

v2: cover all XCCs (one scheduler ring each), not just mes.ring[0].

Cc: stable@vger.kernel.org
Signed-off-by: Jesse Zhang <Jesse.Zhang@amd.com>
Reviewed-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
[ sashal: Replaced the upstream loop over per-instance MES rings with a single check on adev->mes.ring, and called amdgpu_fence_driver_force_completion() with its one-argument form. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_device.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c
index 23e14c01bc995..b122e6aa474b8 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c
@@ -4950,6 +4950,15 @@ int amdgpu_device_pre_asic_reset(struct amdgpu_device *adev,
 			amdgpu_fence_driver_force_completion(kiq_ring);
 	}
 
+	/*
+	 * MES scheduler rings have no drm scheduler, so they are missed by the
+	 * loop above. Realign their polling fence too, otherwise the
+	 * first post-reset submission polls forever on a stale seq. sched.ready is
+	 * only set while the driver owns the ring.
+	 */
+	if (adev->mes.ring.fence_drv.initialized && adev->mes.ring.sched.ready)
+		amdgpu_fence_driver_force_completion(&adev->mes.ring);
+
 	amdgpu_fence_driver_isr_toggle(adev, false);
 
 	if (job && job->vm)
-- 
2.53.0



