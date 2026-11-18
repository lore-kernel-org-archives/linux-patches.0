Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795028160;
	b=MBjZyBWvFCulWrdATjEYbY3gq1KF06cgVE/xRgHOhAyRuFG16qpyFWw+oJmRL5iquGL3
	 6est7ZNazF7B6DtQiGjbwrFdBPLjjN01h4ggMjMcs5kCOXKmlP19MXA/zwohOsdWYxKvv
	 NXyGMXZ7nU/dViJUENdGALsmLkkmI7X6v4HFlHrg95bjxPPtAab3GTG/h74RMg+13u5mD
	 ftAW/B20H/JlWX+0U46QWSfbaKd4HC9+aUL7qPW/lv6RCKTDgUvu01gvXgsc1bLR9ykVI
	 lvedgjxB2tmQs8Fhmy3RxuHCeQ/afEPKSZfnH8cJTLgC3gLqAhsB2mY/wH42hawtUcw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795028160;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=9eZM6oOVJLwpOetRKanSYc5zmbZJrZmbjTpwX34RQn0=;
	b=sxoOamvk+cM2K6LsOK8I9CSuzMZuDRD02x5kA0wHm3kwuaRzWVysXCEY/P42gEWPTJgX
	 09wRVJY+4u1fThLv3dj+d918drMrVXJGm+FmfSsCQC9Jx6QHtt/SK0CSBta9m8aZW/p9N
	 ld4fW/7uLsyfYvfTr+fuHQdXN+hFlJtsfAuO+aRKq/RV6eOHpZ+dZyIdMGHECcjNwbofI
	 FkJ8vXb4QCoLyVQArf9QJ4Pgf1//KvRU/5yNFlYq1Rl7aFVwULfHbG5kP1goNEcqcFP2R
	 ZoSWb5DDTtTe4pbWaDjHfvX2VPBdKlJXJlKW6s3xtp83tBNd3uGZhIfG/Ja6Uh7fVtA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=2evEdhcw;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8AA0E606A31C;
	Wed, 18 Nov 2026 18:56:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=2evEdhcw
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BD7191F000C4;
	Wed, 18 Nov 2026 18:55:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795028160;
	bh=9eZM6oOVJLwpOetRKanSYc5zmbZJrZmbjTpwX34RQn0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=2evEdhcwwOwcID+R84NtC/DE0sphT4EgmGnKT2sRfQYAAiKPv1VjH7MHy53cIFbMZ
	 YQO20YC8SDTFQ4IzlseRyTtZ+7/liWtywK+CFj2QWkZI15TcP2yH8FuU004u2dMBzh
	 1PKunQ785AR4HSZjW8GrvXmcDMmvXrb58sWXCRtc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Harkirat Gill <harkirat.gill@amd.com>,
	Kenneth Feng <kenneth.feng@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 2005/2151] drm/amdgpu: re-enable GFXOFF for compute on GFX12
Date: Wed, 18 Nov 2026 16:02:20 +0100
Message-ID: <20261118150234.764101838@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index 23171bcc947fb..d47130778e2bf 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd.c
@@ -719,9 +719,8 @@ int amdgpu_amdkfd_submit_ib(struct amdgpu_device *adev,
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



