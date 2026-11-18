Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795057148;
	b=Dum6hIQKvr0/FT89TGP627fUAH/t78u7gUIwtw0pkqQ4H+KiDtzVuH3kmOHKODWOQck0
	 Gqb9hcbQZZFvUQyJMRjGWoGFNUXeJFtJjdZ+Ya2ctJNqFDMyWaeTMm2L7m9bcDAsr0abo
	 FJ1Hlprkx6I8+wTXhlwJs3Xa00z6XKueP74N4NVUhzqICczueAvutf7gHFRT6TRFGE0W3
	 /J81kxvj9pBZ7UaCWeIh66DdwzxOZnGtIdO6e4OqrgO3IO9NhPK921B+M1HBV3NvOJRS4
	 iASbwYZQt9N2d0nUCd+eN4TOSguKck69kFipg/GOgP+KxHtWJCo3P3EcfBrFgKLR76w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795057148;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=9alYnNzENcajZNQW9pTA86rf5QAf5f/kMPf6nDdLGwM=;
	b=viO1UUC4HDzDK0Wu5KHUBwUB/8XU0T6TSxeIg/jKdIFJE6N5NIjKy86cUjFxWRo0FLk0
	 /8rql8h5Jr/r0K5BDo/gzOTe44RwckO/221vXeI4PobxdCEYWSG1A1NLj8/+hl4iaxInn
	 46FXBb9HJ+e+HFnszpTlMzQGkqzBlC4Ukk5BGOli6xC9ddzt7sN+EpG0vsM4+TEHR+9et
	 cKDcXPHwfE5wxVkjqtV/kE1+YIjBnmC+icRfr3hTijni356h7HuE8bn8w9uMSXJCtuEmQ
	 1NKU279vbfd/lGQ4xK36g13/gFNMps3DSciNsFF6FRfMkrlm96ANjnYmQBauQQs+MMA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=hr8pwhLc;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EFE16606A31C;
	Thu, 19 Nov 2026 02:59:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=hr8pwhLc
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 556F41F000C4;
	Thu, 19 Nov 2026 02:59:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795057147;
	bh=9alYnNzENcajZNQW9pTA86rf5QAf5f/kMPf6nDdLGwM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hr8pwhLcWrBKLkjDP6pK23l8gG/My9zzkF06Dwq8by3a/CFvjuonOuAp6iL2Ve5C9
	 W5FKfbzHrEAbn63TZCMaMVzbxEzOTTjz43r/AwvE5S5fh7BXISWyP0DNN1nabsYj+U
	 nH3HZ6X9G9wmh8EGPIDU5wSdGjCXXtPCZqqkmxlQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Asad Kamal <asad.kamal@amd.com>,
	Lijo Lazar <lijo.lazar@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 0028/1848] drm/amdgpu: Gate debugfs MMIO access on kernel lockdown
Date: Wed, 18 Nov 2026 15:34:26 +0100
Message-ID: <20261118145912.349080376@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 06f1c2970b58b..d7e8fe4dce0db 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_debugfs.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_debugfs.c
@@ -26,6 +26,7 @@
 #include <linux/kthread.h>
 #include <linux/pci.h>
 #include <linux/uaccess.h>
+#include <linux/security.h>
 #include <linux/pm_runtime.h>
 #include <linux/poll.h>
 #include <drm/drm_debugfs.h>
@@ -1217,6 +1218,12 @@ int amdgpu_debugfs_regs_init(struct amdgpu_device *adev)
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



