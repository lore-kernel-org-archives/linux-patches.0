Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795043918;
	b=MRIETVHvGwekjc424KvzApNU+mQkdDXlDh0H8kRALcGfIqwG4ceSAJSomUw1s0JgeEEE
	 pPQDbY0VGx7X3c3+yQXExbvclTygUesgGzZf+dAllTokjcClZW3tm4h3/In2I4WCCSFQz
	 3vK/WnlxIva8OYEFJo8sUOdTFQTgLR6vPPWdBwwtbDEhKmC+2ZYvKwY2LiFYBFjfmITF5
	 hm6rVx8YDS9zpfuaxAUkbJDu3rS+GlBd9qKmfHGPDpzIwpq3klpMja+YshEBBm1IRu4Hq
	 60qWIHK5vdtDcg4KgaKGJTSVxb9bqEcMjVvadYlByhGtWrtoW7uaw5zw4Xg5hHbbvKA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795043918;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=srvHawINC2Px6PtEBJa+eTXb836Aa0o+vkFryHM5jVY=;
	b=ra+OC1oskkZvq2G9jus8mnjBBgBh+micz6fJXhLXO6/BS1vGCjKPF1wug9DjRZU5yPXU
	 TWm+1qBGDZXGdnYWp9VwKuWEg2gl2k/hWH4d7bAFAb6wr+mqGTVeHuQNSZYET9twstjdx
	 BKaGWB5ZwHt/AwieOfe5g5qIrISKV8TUTBxtEGxL0ZaCIuhLuGvkTujvcrzb3+TUUWeK8
	 YlpyQ/yRpCFXvqrNNYYI4ENrRQhum73RwQed39ws5rwEEfeq+vycx1wx3qFR1sqE0jEfd
	 wZ28sS32KhmV5TyAWERXNvzFWrwATBBUrBGPi0kUFNS28bLjIcmhVFhoa37rp36Z31Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="AIrT/4l4";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 25B49606A31C;
	Wed, 18 Nov 2026 23:18:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=AIrT/4l4
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 77DD31F000C4;
	Wed, 18 Nov 2026 23:18:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795043918;
	bh=srvHawINC2Px6PtEBJa+eTXb836Aa0o+vkFryHM5jVY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=AIrT/4l49yMZQVOfLlg4xvVUOemlj0h2t+fhJMJde+7yQ9JRxVoBKoADbagbY2Bne
	 cbgVGHkhae7rj0xFGl4hIu2PwScj+wbjexmhNxb0f4S0uZMhI/GLd1Wblil5DEjEPj
	 c5uw8/CrdIu+AOxwp/0OKhLu3aBn/w1wJ2PFm0Cg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jesse Zhang <Jesse.Zhang@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0365/2857] drm/amdgpu: force complete the MES ring fences on reset
Date: Wed, 18 Nov 2026 15:23:19 +0100
Message-ID: <20261118150214.569641927@linuxfoundation.org>
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
[ sashal: Dropped the fence argument from amdgpu_fence_driver_force_completion() and replaced the per-instance MES ring loop with a single guarded call on adev->mes.ring, placed after the existing KIQ block. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_device.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c
index e34e2cd8ac183..25748ca1c3d5c 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c
@@ -4979,6 +4979,15 @@ int amdgpu_device_pre_asic_reset(struct amdgpu_device *adev,
 	if (adev->gfx.kiq.ring.fence_drv.initialized && adev->gfx.kiq.ring.sched.ready)
 		amdgpu_fence_driver_force_completion(&adev->gfx.kiq.ring);
 
+	/*
+	 * MES scheduler rings have no drm scheduler, so they are missed by the
+	 * loop above. Realign their polling fence too (one per XCC), otherwise the
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



