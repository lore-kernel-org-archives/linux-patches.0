Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795043022;
	b=060AOfMW8WNPfmg34j/xJTDorLLtgh/vNhv7228b/vOBCSLd3oeQrJxCnG0Y+6+Qnqsc
	 cnc75bsz5yPLK42K/wKs62U/siK81amd6h+0O0qP/yGr1463JUBJtHOIwduoY1jREXCS+
	 Bz7gGNrtznwNPErt+Pox8byBrSHjIponIz20bODSYtJPAF1x1XA719h1qKD3kOlLLKQUr
	 w/4OkweMG1rbDQTTylFf511Yz7uqWaSt+EAZxBi4mwV4nC9YkpuQAjKdyc/Wg2P+n9QyU
	 SmBiVtfA+L+M27m1ZML2BXX76+Iw9WhaN49PgHeA1tp3KiLKbdXjHALF0xD0BBuwzdA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795043022;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=AxsJb8E79c4oaOGa6lbG+qcc5Z4QS8XJOpFJ4JEtpFE=;
	b=fd0DpMy0inSrXUzP8pjKt9HchZ3vKfzkZic7Qs0pIRhwyooGvOaoPrhFKmB+FvYz+lSG
	 ckOi/G9bCkXO9HOuOZaB7AdKpzk5tqgGpGhbhaYJheiqfLFiHOQ6PtOkUEEOpfwTEXXnZ
	 nKoaWG3FUYavfVmBHyz7PvlSTI2X513N5L9MMsA879lpObJPXX8yOru4aDd5I8ze1VrND
	 iQvPPOg4tXEIuebPvkSykZXieHhy45yPvdv+TSEnFERgOiEowJ1OwepqCQG0sPJ6WWwP+
	 f8tEaKac0G8mRF/tYNRjo3P9juP2GYtGlxaagcsBScehMViRPR0VJiHTYihCYPTQ/oQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Yhjl3SeV;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A28D606A31C;
	Wed, 18 Nov 2026 23:03:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Yhjl3SeV
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5D2D71F000C4;
	Wed, 18 Nov 2026 23:03:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795043021;
	bh=AxsJb8E79c4oaOGa6lbG+qcc5Z4QS8XJOpFJ4JEtpFE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Yhjl3SeVYYNI5AqORdLy2+i6zkSASr1qoW2E4DR3vYZSjKe05aQz7aNcBLzXzcDXY
	 IuF0zB462FiaU3aZXF1gpAQlaTZSKBuAIguWl9flgFe06G+7JPexXtPFEztZXHazjK
	 6HVgfxYQdEHCSWYxxgo39DbuCK5XF92KJ5g6C3qA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Asad Kamal <asad.kamal@amd.com>,
	Lijo Lazar <lijo.lazar@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0020/2857] drm/amdgpu: Gate debugfs MMIO access on kernel lockdown
Date: Wed, 18 Nov 2026 15:17:34 +0100
Message-ID: <20261118150202.086003490@linuxfoundation.org>
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
index 952a3fb18c2d3..c51118c5003b8 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_debugfs.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_debugfs.c
@@ -26,6 +26,7 @@
 #include <linux/kthread.h>
 #include <linux/pci.h>
 #include <linux/uaccess.h>
+#include <linux/security.h>
 #include <linux/pm_runtime.h>
 
 #include "amdgpu.h"
@@ -1468,6 +1469,12 @@ int amdgpu_debugfs_regs_init(struct amdgpu_device *adev)
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



