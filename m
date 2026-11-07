Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794060564;
	b=JIKroR7KPMbQbKecuguF0XCYqAk36/yeEZt8naaMim7xVrf27YcEe/OMfDhQAAYG9pRa
	 EqqEV5PvgBVe0ry7r9UGApOKNG9HDh78xGv3cikUK1Nazr11K7NTtE1VVWt3ZISH807Xy
	 tFZ2XfkRD4HYF1naeWQ6tpy5NznRqEK9qBUUPFfyOGk0BfJK7oThFytHNwp/w8Bns8S/G
	 NNyvKuTVd0AHbmwjMa4sKspmy8RGp5LeTdhH88y0QypNwGQeW4VdV4eCRwi2vmoLeplKI
	 Swgv7o8yAAimA+SGBmdmTTkK84DsAh9m1gPfwKQS8eIv58xsAcOyMxVbKCWZU5iz91w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794060564;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=yuFVQ944ey6ZSzQzZCm9gAf/qYQk6ts33E7xhCu12kk=;
	b=GotTqifuiyuVqGyy0TzsrG/3KKEh5Pd6wMwwF4FfGCYPsTOetJvWDeV5lm2/Ma5zbuYl
	 NISdEHRqRNwtZsDzKG9GXdnmnXEjFqiRg9HvY1TjwFW5tCqr+QDEYyXiOUwyDEKubdhbw
	 9wkq42KiU5r9gVaSb4fcDS9eDItAih61j7VwQIE4PaJEH2q6JtvojUG7raXJV3AM361O2
	 DAHDrhi5ElTN1zPDxritWw5mYR4TE2l6+GKJ44W80u2xXUDK2glmI848ppLFUbNNvJYQB
	 w1vNScjyJiqJkM2xuqENVqyx7bIuOr2/kQc+gXQCUdKthTpCw1+83gpJfXSDAWHXkqA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="BTRTV/CB";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 13232606A326;
	Sat,  7 Nov 2026 14:09:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=BTRTV/CB
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AD4261F0089F;
	Sat,  7 Nov 2026 14:09:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794060563;
	bh=yuFVQ944ey6ZSzQzZCm9gAf/qYQk6ts33E7xhCu12kk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=BTRTV/CBwk81o2POiuBAkuWbqobeQrM90tXnKMAZCT0Eg/7SmIHyGujDsJu2x+308
	 8wpGhevGvU6uqnsa6FhAKFq21Vy/8hYi30PSKl3T4TSaG+PVJcQTWVo8z2vYgYnEFM
	 dNUPEJhYPuctrsFJ7+h8yl2vxU1lMSP+qgV86YqM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Asad Kamal <asad.kamal@amd.com>,
	Lijo Lazar <lijo.lazar@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0026/1536] drm/amdgpu: Gate debugfs MMIO access on kernel lockdown
Date: Sat,  7 Nov 2026 08:34:02 -0500
Message-ID: <20261107134958.411985828@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134957.653319350@linuxfoundation.org>
References: <20261107134957.653319350@linuxfoundation.org>
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
index aab7b75ebc3fe..3e4a6c13bb7b7 100644
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



