Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B3DFA2F260C;
	Thu, 28 May 2026 20:06:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779998820; cv=none; b=qOAygbBZ1UF0AXLqM0LbWKxcubVTrUibbjYEKu+hhK7CGpY9F7s6dn0HbHCMi0E9/87mLbru9mlpbK/NE1rBMpTUapAmp64DLZUD6IxypEtkiwVLncBfSffAYud6z5ZsTHjnXJ8YvAF+J3S1J+r1zjVAOtZ7YfFYqRR6AY40mKI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779998820; c=relaxed/simple;
	bh=DeoiKbWlagdmsTuwBO6ORZp/hpR81pBPflW4ZDwfIz8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HHrWkRQEqny6B0TWBfxNMevrubT1nLqEF/n2f0XpWdP9G9D43SUTg+zRFhkxv8RI74+r55T1P70zijOy0qR1GgmwNzYbPKFJPhaDsXxv9KS8xkTKH7ADatk1sgdq1PcXB8htO6NxZ1mw9+Nd3T7Vj8aMgt9GlavyS2aWfuEifwI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wyCaR2YG; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wyCaR2YG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1E1881F000E9;
	Thu, 28 May 2026 20:06:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779998819;
	bh=JFHAifFNzPKD1ePx6trOREGbJmwGo9o21eGhkJo2FsE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=wyCaR2YGwUKdaxYqhBkioRLCn0HEcdrD7qpiWqTl41AXvMHktdIOYc9YB0yfFOHVI
	 ESfK1Ee7nNG/MkjejNmj5uBDkqWG995zmmfa40FMgCWkVBU8Qq04kb/KTHEnj3xgLK
	 UnNXAIe/wUrkWh1wYHc3VwH0Sps3Athhl6JCIPQg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rob Clark <robin.clark@oss.qualcomm.com>,
	Akhil P Oommen <akhilpo@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 308/461] drm/msm/a6xx: Restore sysprof_active
Date: Thu, 28 May 2026 21:47:17 +0200
Message-ID: <20260528194656.193929602@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260528194646.819809818@linuxfoundation.org>
References: <20260528194646.819809818@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Rob Clark <robin.clark@oss.qualcomm.com>

[ Upstream commit 7a529ff48b99011c946e6d8addd071c06d3ccdae ]

This got lost in the shuffle somehow when moving the vfunc table to
catalogue.  Fixes inhibiting IFPC when userspace is collecting perfcntr
data.

Fixes: 491fadb2b818 ("drm/msm/adreno: Move adreno_gpu_func to catalogue")
Signed-off-by: Rob Clark <robin.clark@oss.qualcomm.com>
Reviewed-by: Akhil P Oommen <akhilpo@oss.qualcomm.com>
Patchwork: https://patchwork.freedesktop.org/patch/717780/
Message-ID: <20260411150312.257937-1-robin.clark@oss.qualcomm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/msm/adreno/a6xx_gpu.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/gpu/drm/msm/adreno/a6xx_gpu.c b/drivers/gpu/drm/msm/adreno/a6xx_gpu.c
index 02a776ac9ab43..3e26b60d7f678 100644
--- a/drivers/gpu/drm/msm/adreno/a6xx_gpu.c
+++ b/drivers/gpu/drm/msm/adreno/a6xx_gpu.c
@@ -2725,6 +2725,7 @@ const struct adreno_gpu_funcs a6xx_gpu_funcs = {
 		.create_private_vm = a6xx_create_private_vm,
 		.get_rptr = a6xx_get_rptr,
 		.progress = a6xx_progress,
+		.sysprof_setup = a6xx_gmu_sysprof_setup,
 	},
 	.init = a6xx_gpu_init,
 	.get_timestamp = a6xx_gmu_get_timestamp,
@@ -2793,6 +2794,7 @@ const struct adreno_gpu_funcs a7xx_gpu_funcs = {
 		.create_private_vm = a6xx_create_private_vm,
 		.get_rptr = a6xx_get_rptr,
 		.progress = a6xx_progress,
+		.sysprof_setup = a6xx_gmu_sysprof_setup,
 	},
 	.init = a6xx_gpu_init,
 	.get_timestamp = a6xx_gmu_get_timestamp,
-- 
2.53.0



