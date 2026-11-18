Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795032992;
	b=5KSaHoqDbHijv6YhXyuLR8DM6XguwTRx4phgj6vpa2oQpNxkd+aHXv5PjAuGGCBfmet6
	 nXa3xPZky1GQsDklBfa1PIyOgdxkMDfSdk25+bWi5SJ8K99zef2kmOE56QVoz9a4CmlJ8
	 PXD6KlHoYEJodWQ9nwZCgpJqn1T9L0HFJyFtCAKT867lC/hRoZBVrD/euLcr9suus+YRK
	 TpsXwl2c70kPPK3TD+CKJnk1KDA3v/W+XgLqtTJ7Jb3IcdG9+R+hNIgS8ky28WskKJ7nK
	 ZttXfTJMWjP1S4Cnhh6ONP1LA0+s9UAJ9/G1UzeSjVLV24bONhIgqOJwdrHyE0XUi6A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795032992;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=0ok3vWLPVV85mnIHbXWhp4KMPw976PaJMT4mgldEhtE=;
	b=W/aFPPZp8ieJBhhopwYcBBRpEOUO/ocJRTfMFfLkScjsDJm/1lTLCjSW3gTcPtE2OxKT
	 mJUq3RKw3uYRZwKpQ0sWXKwHGnjEkABsW4bJ5Srsl3jGwCZq323cIEvIbx/Ov4JPjpoVQ
	 8cLK91fr0OOUxkpyDPgvgsNHy1Uq5VloTxPEX/qp54o+kq3UqLT9kSCfhZXExCtCtzKLU
	 ERIOrjecXZ8f7tS4N2E90gNqn3UzilEFuXeAVCDDAHFyCUkcD9jUnKjwpnkNTMVSyiqYX
	 5ge/pHXPpXMJUT5yEFDfcw3Su4Fl1M0w/jwEsQiBD45MBmowpKofVC53Yb7fcnIhNaw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=l6igUTrt;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9105F606A320;
	Wed, 18 Nov 2026 20:16:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=l6igUTrt
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E29F81F000C4;
	Wed, 18 Nov 2026 20:16:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795032992;
	bh=0ok3vWLPVV85mnIHbXWhp4KMPw976PaJMT4mgldEhtE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=l6igUTrtJmqGKg/LgiA7plFCVGr17Y7D5Z8Z7seowRaZmk/nsX3yV/GXNTMEoKp+I
	 qTSIdn8xpLmQPkP7fL/n2OBj7lI/xtnWFpZYOy9JsCcq5tmLqD/TA8q/9xhH3roOE1
	 IB1L1nB/TaHG0knWtsN3wcDkkznX3oGzuPjoQmm8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Harkirat Gill <harkirat.gill@amd.com>,
	Kenneth Feng <kenneth.feng@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1610/1756] drm/amdgpu: re-enable GFXOFF for compute on GFX12
Date: Wed, 18 Nov 2026 16:02:17 +0100
Message-ID: <20261118150113.960480945@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150007.957976754@linuxfoundation.org>
References: <20261118150007.957976754@linuxfoundation.org>
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
index 2de2895e3850b..3e946b61df152 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd.c
@@ -737,9 +737,8 @@ int amdgpu_amdkfd_submit_ib(struct amdgpu_device *adev,
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



