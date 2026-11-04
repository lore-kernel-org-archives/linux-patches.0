Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793829319;
	b=TykhkNyttmKDwfxNMbYFb6NbzrDlfqs5IXnrUA9ZR7JmIUtgrJj3vWFSEjt8tdcmlQ+Z
	 qgLrHxvim62RW4i6s3dKtr4Tjyl0JzfI/GtC0aqHY2Z/sb6pG72o7kAdmQA6uGuWcixb+
	 ZjOou7CdaZX6kB9jMIs2wLwNixd3pdwj/Q/CrQyt7JaUxzq9GAgYEFcrSHd5zsaz3+Gt3
	 mHZuYiRCvy6IlMUZ9kepfOFjPa7jd4ejslGI2fC/Hl72KLLhE/XqYhE3lb91ZsEiw6kEg
	 unIWuvBpiUiD+bjGvvY1+YSDz7MN2Rf55qDJQlKTGLFZtowfv8pnbLIvfhkNcWSVsnA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793829319;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=GZP8/kcsLsUEjTtM4gAYAMvJuvrNKt+3CCqPIlo954w=;
	b=vzfumrRAt50sVQKg0Wa/wivSvB+bcddnksYy5TE4tJRM2wgaLPAaRSwnpcpHdXnr95L5
	 aA8Xwuvpdq+zX0VyoHrRZd543r6xpRYs+OH/WP7Prwv8eRI0LlfdAdryHPPc5ada8KZ6n
	 sTkq5QjgXAdDWy21D0yW47kkkP1Aq/5h1W6T7bNqCIvK+Xr7pe+dO3wmtK4HD/9Pb2dWb
	 2Euyx/A7qIAgHZkXXwoEJ1B8zmyqxCnZj4lC07T6+wFdS7nXVD8VRfc7NxiCmOLDkJRP4
	 4EHVHpLbzcE0am43uVRLK2jJQi2gEcz8nuGh5Sk0Nx6YozV3owQiHPKyhyhWzvR+1TA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=GdJUq7EU;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 053B16074917;
	Wed,  4 Nov 2026 21:55:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=GdJUq7EU
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9A3891F000C1;
	Wed,  4 Nov 2026 21:55:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793829318;
	bh=GZP8/kcsLsUEjTtM4gAYAMvJuvrNKt+3CCqPIlo954w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=GdJUq7EUmOVtK9s851Q2RviftiXFY6+ES046NGSyrdQKSiw6T+OqFPtOw/z7npMRl
	 9DVOvMwMJx6IKwvE7jAHH/UZAb1g2M9CWP5neaVvZdhNRK2RHTYICLdz3enuYeJJi0
	 ArJ6AAnyd5be9Dkr/rpPvqz/X/1uMLTJ4vf5wTWQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Asad Kamal <asad.kamal@amd.com>,
	Lijo Lazar <lijo.lazar@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0020/1005] drm/amdgpu: Gate debugfs MMIO access on kernel lockdown
Date: Wed,  4 Nov 2026 15:55:53 -0500
Message-ID: <20261104211044.117663998@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261104211043.516122098@linuxfoundation.org>
References: <20261104211043.516122098@linuxfoundation.org>
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
index 04939a9711e95..c7535ef0ae401 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_debugfs.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_debugfs.c
@@ -26,6 +26,7 @@
 #include <linux/kthread.h>
 #include <linux/pci.h>
 #include <linux/uaccess.h>
+#include <linux/security.h>
 #include <linux/pm_runtime.h>
 
 #include "amdgpu.h"
@@ -1646,6 +1647,12 @@ int amdgpu_debugfs_regs_init(struct amdgpu_device *adev)
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



