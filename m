Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795050926;
	b=q39bgqaSr4sOlR5uDIrX4/861sl57EkxrQjMZx3MvIJcsNCahE+DJihCLXJhwwHILeRr
	 N6ModMnj7atWbH6Psd7LBIvA8y+gMCPDY8mKC2R8Gnp/S9R+o56Qy7clZc0DrqWHu2hG8
	 PWcx+cC7gkD0jS7/MLluavXfatZdiC6lSdoEKyK43mG8bwJU3IVWizKrSN4MvShMbKDpk
	 8E9psRSIzs/5/H6ErcSBJOg4wHjt6UR2GoXsFfJoL7+5225BG/FqwD3rsVPV0GrZVN/8p
	 lyvDvjiLsUk9QkXDxAmtPJH+dCzTUvhOdUqTMnSnRCCY6SpwlGCuhZHTg5MThh2CbiQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795050926;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=rpkGbdXTTB38sIru8KOP9gzQKOl8TRv3VOJ6LDeTy3Q=;
	b=EAqBiwSEb4hSrzHTxzOUhKgpN3kGLRDN9OUMHekQr7S5oNMVoS+pMj1O+8spG9r5PAQp
	 SfypyyAdqqT5gB8yvZrd258heternSiYbIT97mJil31x0QIK3IGhbOo32cd2dYr/yhc5J
	 3W9sKcIKFCQJP8oyXHFqK7arGlnzzKwq5MDevyKdL6tmecfqZPhzKIefK/KAXjp28Drcg
	 fDHRoGfMFIy7U7sljDmFlZpz+ULQw60sw1pBvako9b9dxDQniufUR4uoBWM/9ujTGLw04
	 VFlNvLRyqp22GXQlH1zy8U/D2QjcqTFBYqfrCYUpVmz0oU6+5h0gLKG4ddhsgyijyYg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=wEx9onGL;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A5443606A32C;
	Thu, 19 Nov 2026 01:15:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=wEx9onGL
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0DEF61F000CA;
	Thu, 19 Nov 2026 01:15:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795050926;
	bh=rpkGbdXTTB38sIru8KOP9gzQKOl8TRv3VOJ6LDeTy3Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=wEx9onGL2h5Dufq+LexMGCnfm2cgoIFqOrjU2/vITrGE+BzW8YMmbQP+12jWDIc8v
	 g7gcJE79LjKKGiDUM56yIYqzSTxyM1z+KGkSwQlLB+fyfJz30srg8SkwR/qooLGhRd
	 7XqZPucdhEhDfJpddSBDOXcS0Qy2V4FVA9kWVwtY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Asad Kamal <asad.kamal@amd.com>,
	Lijo Lazar <lijo.lazar@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 0027/2214] drm/amdgpu: Gate debugfs MMIO access on kernel lockdown
Date: Wed, 18 Nov 2026 15:28:23 +0100
Message-ID: <20261118150011.195383749@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index f4f5dc704c701..ea6a246479b34 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_debugfs.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_debugfs.c
@@ -26,6 +26,7 @@
 #include <linux/kthread.h>
 #include <linux/pci.h>
 #include <linux/uaccess.h>
+#include <linux/security.h>
 #include <linux/pm_runtime.h>
 
 #include "amdgpu.h"
@@ -1107,6 +1108,12 @@ int amdgpu_debugfs_regs_init(struct amdgpu_device *adev)
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
 					  S_IFREG | S_IRUGO, root,
-- 
2.53.0



