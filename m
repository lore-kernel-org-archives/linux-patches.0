Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 79F231A680D;
	Mon, 23 Mar 2026 14:19:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774275562; cv=none; b=LJysfh6QKhnX9L3sliWS9cwb80Qc3k/yAsh7+japS8y6aJxpLuC12jI/vFLaOkQOSJy6t8B2YaC3LwArBMGpGacUClUlGTdGr90Ocos8BroB30tY4zesIOc27shNK13zoqgRAUsFK2B2/pDR9eNWaAKl6M/dJJwztFQeI2tl68Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774275562; c=relaxed/simple;
	bh=P94LZOTKseVt7gkxdoqvr1glguGuDsemotZuikbPqkw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mh88VCBmB9ikJeiMQmKbpbZGMLDKkr63V8EJu/5Gk54k5OqQoERO01LWwoj7upWV/6GBdPrlePon5bJvyYG/TZBWZs1RPKmSCNTy2e/zRKJ1ptpa/pbJCWiZWc7U76s51m7EQi2V3LWVnWHC8Da9/eAJ0QEzeOBYBwcRLvz9qCY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JP2cMFjl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JP2cMFjl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BA238C2BCB1;
	Mon, 23 Mar 2026 14:19:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774275562;
	bh=P94LZOTKseVt7gkxdoqvr1glguGuDsemotZuikbPqkw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JP2cMFjlJENiabIcUtICFLWVygSYfssuqfnr6R6jUVAhdoi5aibM4f8wShvb75xmp
	 6kJmsJulnLE2tD589AvpHysv7x/WCHfB54av15tFy4Ou01TmJuYLskG9DJXCsNHINZ
	 D41OMWEPk274j1GzM5BvX2xezYgO+9PRmfvtPKuM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alex Deucher <alexander.deucher@amd.com>,
	Mario Limonciello <mario.limonciello@amd.com>
Subject: [PATCH 6.12 142/460] drm/amd: Disable MES LR compute W/A
Date: Mon, 23 Mar 2026 14:42:18 +0100
Message-ID: <20260323134530.075844721@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260323134526.647552166@linuxfoundation.org>
References: <20260323134526.647552166@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mario Limonciello <mario.limonciello@amd.com>

commit 6b0d812971370c64b837a2db4275410f478272fe upstream.

A workaround was introduced in commit 1fb710793ce2 ("drm/amdgpu: Enable
MES lr_compute_wa by default") to help with some hangs observed in gfx1151.

This WA didn't fully fix the issue.  It was actually fixed by adjusting
the VGPR size to the correct value that matched the hardware in commit
b42f3bf9536c ("drm/amdkfd: bump minimum vgpr size for gfx1151").

There are reports of instability on other products with newer GC microcode
versions, and I believe they're caused by this workaround. As we don't
need the workaround any more, remove it.

Fixes: b42f3bf9536c ("drm/amdkfd: bump minimum vgpr size for gfx1151")
Acked-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Mario Limonciello <mario.limonciello@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit 9973e64bd6ee7642860a6f3b6958cbf14e89cabd)
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdgpu/mes_v11_0.c |    5 -----
 drivers/gpu/drm/amd/amdgpu/mes_v12_0.c |    5 -----
 2 files changed, 10 deletions(-)

--- a/drivers/gpu/drm/amd/amdgpu/mes_v11_0.c
+++ b/drivers/gpu/drm/amd/amdgpu/mes_v11_0.c
@@ -677,11 +677,6 @@ static int mes_v11_0_set_hw_resources(st
 	mes_set_hw_res_pkt.enable_reg_active_poll = 1;
 	mes_set_hw_res_pkt.enable_level_process_quantum_check = 1;
 	mes_set_hw_res_pkt.oversubscription_timer = 50;
-	if ((mes->adev->mes.sched_version & AMDGPU_MES_VERSION_MASK) >= 0x7f)
-		mes_set_hw_res_pkt.enable_lr_compute_wa = 1;
-	else
-		dev_info_once(mes->adev->dev,
-			      "MES FW version must be >= 0x7f to enable LR compute workaround.\n");
 
 	if (amdgpu_mes_log_enable) {
 		mes_set_hw_res_pkt.enable_mes_event_int_logging = 1;
--- a/drivers/gpu/drm/amd/amdgpu/mes_v12_0.c
+++ b/drivers/gpu/drm/amd/amdgpu/mes_v12_0.c
@@ -615,11 +615,6 @@ static int mes_v12_0_set_hw_resources(st
 	mes_set_hw_res_pkt.use_different_vmid_compute = 1;
 	mes_set_hw_res_pkt.enable_reg_active_poll = 1;
 	mes_set_hw_res_pkt.enable_level_process_quantum_check = 1;
-	if ((mes->adev->mes.sched_version & AMDGPU_MES_VERSION_MASK) >= 0x82)
-		mes_set_hw_res_pkt.enable_lr_compute_wa = 1;
-	else
-		dev_info_once(adev->dev,
-			      "MES FW version must be >= 0x82 to enable LR compute workaround.\n");
 
 	/*
 	 * Keep oversubscribe timer for sdma . When we have unmapped doorbell


