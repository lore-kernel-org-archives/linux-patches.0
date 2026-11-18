Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795033454;
	b=TSwjOR6x/WpBSol4B4NpRtCcWnrNzVoReEXoSwYZui41xKQcNwC5q9LcLC6yTV4m9KoE
	 cZYqdN3k/NBAOhSDS4k4XECYgsG4w0Puq7bBZwwAVU/eWRcEi3MQ/ANta/Jl/rD6URrOh
	 4LKu1blB/241qx6ystFrxZ0XVU5UH0IrCq8BGQ6qCmb6zsde1/RcL6C1uFvmXgCFo+4pn
	 nLLant91kN6t9RkGLAw2WNlypNKRXv6vzKpj+rZLKgVwJxm1Za8fblNA9INmwAQEwv20f
	 X9yVo+7wjP3O3/Mzugu6Do8jZkRWm2w9qZehl3dCV8OFhMP+m2LcU3LMqqtcnwGIubA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795033454;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=a/W/rST6URNaQ+XEbjF2JImWPzSz7CfBi8IvZJUgBwg=;
	b=P7R4WT3xuYN54hIlQgHRNRtsAfCC9rDBVRjIaShBPGE7VDG/JG9AUaUfd/tPw5+RkBWv
	 zGeIRD8rTVdJlA/zZs+TsrlR/MrS0VAwkv6eKxvhE8CUkMs3XO8POi6y5b3C9eZoMS0ez
	 hayMCWDpxdVDAR571Q8buqnRGu+EyZjxqrnKq/icznZxk9UxGOf5jiZgITNpRcKW4Mgbw
	 mk4L5v3i+PvQ/iIoj4pMhZtmYBTIPAPJ7YSgzzOG+jxmc4b6KNVCPBk2Q4Y0P08tsT6Vk
	 PoryVr0S2s2R6hVPoSC/UeBOXFYZOVr/2+eEXeEp6s2sqtuA4E79r89VAU3hMv9AekA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=DEPJzZPV;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 18F1F606A31C;
	Wed, 18 Nov 2026 20:24:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=DEPJzZPV
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1FD0A1F000C4;
	Wed, 18 Nov 2026 20:24:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795033453;
	bh=a/W/rST6URNaQ+XEbjF2JImWPzSz7CfBi8IvZJUgBwg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=DEPJzZPVh7HivgGjqO5RcxkTj7N0hPc2JG3LAxZ2S6PBkfeAd3zYiCEsWfgmvSK2/
	 PbeHorX3ZZo/Id4W9m7WURklZ93TR0q/GrsM/KJpB+jsuh9oKHb+bGXyDDYBKGiUpF
	 1lXaIJucAbH9CtdgJWZ5Fkmuj74fGh4KI0/ikCBI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Asad Kamal <asad.kamal@amd.com>,
	Lijo Lazar <lijo.lazar@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0021/3318] drm/amdgpu: Gate debugfs MMIO access on kernel lockdown
Date: Wed, 18 Nov 2026 15:10:43 +0100
Message-ID: <20261118150314.361689015@linuxfoundation.org>
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

From: Asad Kamal <asad.kamal@amd.com>

[ Upstream commit 17ac73b24006700f50972d37e297dec1f523c14a ]

amdgpu_regs, amdgpu_regs2, and related debugfs nodes allow
arbitrary MMIO read/write via RREG32/WREG32 without checking
security_locked_down(). On kernel_lockdown=integrity systems
this bypasses the same restrictions as /dev/mem and PCI config
space sysfs.

Check LOCKDOWN_PCI_ACCESS (matching pci-sysfs) at the entry of every
debugfs handler that performs direct register access.

v2: Use consistent check as per previous check to use
LOCKDOWN_DEBUGFS(Lijo)

v3: Do not create any entry from amdgpu_debugfs_regs_init() if
LOCKDOWN_PCI_ACCESS is active and log once. (Lijo)

Signed-off-by: Asad Kamal <asad.kamal@amd.com>
Reviewed-by: Lijo Lazar <lijo.lazar@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_debugfs.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_debugfs.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_debugfs.c
index e6fe4aa8ceac8..5d4ec3e965ba2 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_debugfs.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_debugfs.c
@@ -26,6 +26,7 @@
 #include <linux/kthread.h>
 #include <linux/pci.h>
 #include <linux/uaccess.h>
+#include <linux/security.h>
 #include <linux/pm_runtime.h>
 
 #include "amdgpu.h"
@@ -1639,6 +1640,12 @@ int amdgpu_debugfs_regs_init(struct amdgpu_device *adev)
 	struct dentry *ent, *root = minor->debugfs_root;
 	unsigned int i;
 
+	if (security_locked_down(LOCKDOWN_PCI_ACCESS)) {
+		drm_info(adev_to_drm(adev),
+			 "amdgpu: HW debugfs nodes disabled (kernel lockdown)\n");
+		return 0;
+	}
+
 	for (i = 0; i < ARRAY_SIZE(debugfs_regs); i++) {
 		ent = debugfs_create_file(debugfs_regs_names[i],
 					  S_IFREG | 0400, root,
-- 
2.53.0



