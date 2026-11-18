Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795022092;
	b=D2oGGB3Iylpe3IFBpzq816clw2fywYdBWFJ/rogQ6TCF3jwx8WDzrlGU0rhVlGV0HBoJ
	 Aj7sIfVvWBw+A9Ol7p2O48K8D5xDtOcBUUvlALFvreqm8x1739oWXF4GoSqeA1GHRXRdc
	 DqsSFWl1rUk65wataiCqaBAnQ9cPM9GqsY5wriHM5NpqQWBRdNUOkdY7tkF2PYgb9p+Nm
	 F9IUB1P3fQYpGH8dnsoCiuMqr9Z3VfUQnVxNJZsCq0HKKCK6eni8SoTPjXY0QQrV2kHad
	 +PBpkvDZ2Ujar7vDmtTQeSaCgTEPgyzfqpY8VvfvTp9acj5ZIx13I7VJrfCkXlP/6Xw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795022092;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=3WudnvtYwqWUHtThJIuhxYhvFMW22X0HiunfcCTsOn8=;
	b=QoGSQcVHmeIqhFMj2IHRh+ZwiySLboOGFU0bTJ0Cp820oS2bQpnH9/kbx1IukYvh57Cq
	 7wiOpmIe+unxltCTZ3m0iZV5pJ6XqJridql/o0gJ1ej/VeIkOeHVSxWP1QAU2MvE38vIl
	 S+65iFf9olJE2YJgkSyewRY8Vp6iNBJI3eHdLBg73xLvBSfczk0S0E8BUpwGhhXP7vFmK
	 UTeOYtiSxRNL8B1XA0RXyfY+takXsBaIa8wdRGT01WhbjR2wchE8oiHwyLKD468xqm+SK
	 yiNdYy0/Ttqr8u8UzFDDbnoPbQeuYZrK3OcaHBC5siwibMzkdWK3U4b4aB8+uG2cGhw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=YD8oYrIC;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C7998606A33B;
	Wed, 18 Nov 2026 17:14:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=YD8oYrIC
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1214A1F000C6;
	Wed, 18 Nov 2026 17:14:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795022092;
	bh=3WudnvtYwqWUHtThJIuhxYhvFMW22X0HiunfcCTsOn8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=YD8oYrIC0cUvULeKBmUSK7kaZzpYIoTu8vaEIR5jGoC84MMIAeQ4q5bAi+/LnI344
	 CwYRouwjuy7YJiIysqUESkHz7uWM5Z4JJvKnixqe1At/5cTCUlvHmuhhS02Ec6FqgO
	 CbKqHAihcRx85YxieaF/CkWKXvsLwRpUB4sThID0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Harkirat Gill <harkirat.gill@amd.com>,
	Kenneth Feng <kenneth.feng@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 2499/2651] drm/amdgpu: re-enable GFXOFF for compute on GFX12
Date: Wed, 18 Nov 2026 16:02:19 +0100
Message-ID: <20261118150414.776246591@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Harkirat Gill <harkirat.gill@amd.com>

[ Upstream commit 6a1dbb006056ad1ce6df0d6d5f2155767c20f410 ]

Commit 2affe2bbc997 ("drm/amdgpu: disable gfxoff with the compute
workload on gfx12") disabled GFXOFF whenever a user-mode compute queue
exists, as a workaround for an OpenCL test failure. The MES firmware
issue behind that failure has since been addressed, so the workaround
is no longer required.

Without this change, idle inference servers that hold a context for
hours never let the graphics block power down, costing roughly 3-4%
reported GPU activity and ~3 W per GPU at idle.

Measured on gfx1200 with an idle HIP process holding one stream and
two resident KFD queues:

  before:  VDDGFX 695 mV, GPU load 2%, ~9-10 W
  after:   VDDGFX  35 mV, GPU load 0%, ~8 W (idle baseline)

The resident queue count is unchanged in both cases; only GFXOFF
availability differs. The ocltst runtime suite (40 tests) passes with
and without this change.

Fixes: 2affe2bbc997 ("drm/amdgpu: disable gfxoff with the compute workload on gfx12")
Signed-off-by: Harkirat Gill <harkirat.gill@amd.com>
Reviewed-by: Kenneth Feng <kenneth.feng@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit f6d97ecb68b8623da2f83997a9c8c57a1a9649f9)
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd.c
index ca5860e493a60..6e5709e641c26 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd.c
@@ -751,9 +751,8 @@ int amdgpu_amdkfd_submit_ib(struct amdgpu_device *adev,
 void amdgpu_amdkfd_set_compute_idle(struct amdgpu_device *adev, bool idle)
 {
 	enum amd_powergating_state state = idle ? AMD_PG_STATE_GATE : AMD_PG_STATE_UNGATE;
-	if ((IP_VERSION_MAJ(amdgpu_ip_version(adev, GC_HWIP, 0)) == 11 &&
-	    ((adev->mes.kiq_version & AMDGPU_MES_VERSION_MASK) <= 64)) ||
-		(IP_VERSION_MAJ(amdgpu_ip_version(adev, GC_HWIP, 0)) == 12)) {
+	if (IP_VERSION_MAJ(amdgpu_ip_version(adev, GC_HWIP, 0)) == 11 &&
+	    ((adev->mes.kiq_version & AMDGPU_MES_VERSION_MASK) <= 64)) {
 		pr_debug("GFXOFF is %s\n", idle ? "enabled" : "disabled");
 		amdgpu_gfx_off_ctrl(adev, idle);
 	} else if ((IP_VERSION_MAJ(amdgpu_ip_version(adev, GC_HWIP, 0)) == 9) &&
-- 
2.53.0



