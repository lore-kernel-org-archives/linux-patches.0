Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795015294;
	b=aaTif+f+Ps6MA9eMkFXPHAOY23rL4IllEWkF1xLvvrA89Zo31WsaHtKPUYQ4iPOrP8JI
	 8jcgYSQAPiM9yUWcVnpuXriRnB2GLdme/o6oxFCZn9ELqdedGfxbfUJ909gs+pypyEwtz
	 3TaCmecxAJd+qLs9gT+m62tW/LQua92IENS0YaRc8xRjsozuLZaqiyuwJZcGwGn7gSB2x
	 +vf903wEakDfO8gu4gwZMl66KLpQLbycx7H9q0BBBIMDHtOZLObcGWoB8xlCynVShAwYQ
	 4Zvxzgpyck5XTxQt9NdU40eKlA37rLfXv/LH3CEl6/uNF7w1o0FjQRCjZaX8N0EJ4aA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795015294;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=004IqgnevRlMEmsN70K/x0McxLtF2USPhPwg57Hox6g=;
	b=LtIixVs7L+SYLU3/7Ua7uMdG2cI0dPPZLNSTq83aDiZ/T5ZaY7oeo6yL8FAsrEE2XrcX
	 eu9Pr183KSNvNtIzkFJngxGYOVvbhMfagwCS0uqARJpVfB7AwrqCjUN75iyufy/T55s/1
	 FxmTJJaETyDltdSwDGOKb47Ko68FLndDKiYEnvBApNn9IZv+cyoyfVLj9y3Cnc4g1H+Qt
	 T2RvmM5v7El6UOUDofuxrpB3Dod/nZIzjpUQojZ411ahn0bDtcpw012eirWeLmlfEjSh3
	 RMMV5DpCG4Sp+DRQpw3NizHZKikOn39ozPVT+nNHzRIcAbqjmcK4i7h1pDZJ4SoOGqA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=XZ4RQlUa;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C2DA5606A325;
	Wed, 18 Nov 2026 15:21:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=XZ4RQlUa
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2A80D1F000C4;
	Wed, 18 Nov 2026 15:21:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795015294;
	bh=004IqgnevRlMEmsN70K/x0McxLtF2USPhPwg57Hox6g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=XZ4RQlUa19oNc/OzgMQYfVdhDk+q7YUmSzIxHSgpcrVe1ey+G8O0OGaghJF/g+sqM
	 r9ZzFfEs5vO+9CF5tGuxlzcgVWSwylBHYg6mmVAceiVsPliyLkZpXxupiirousaXSF
	 3gI/B6Xp2ouHErId/k6iYR3kVmGZtqoCUutWPu/w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Timur Tabi <ttabi@nvidia.com>,
	Alexandre Courbot <acourbot@nvidia.com>,
	John Hubbard <jhubbard@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0070/2651] gpu: nova-core: write initial RPCs before booting GSP-RM
Date: Wed, 18 Nov 2026 15:21:50 +0100
Message-ID: <20261118150250.458900230@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Timur Tabi <ttabi@nvidia.com>

[ Upstream commit 6556f7556d622dbbc5c936df9d39c2f33600adfb ]

Make sure that the two setup RPCs, SetSystemInfo and SetRegistry, are in
the command queue before booting GSP-RM.  These message are expected to
already be present, because GSP-RM will process the queue early in boot
but will silently ignore the error if absent.  GSP-RM then continues
booting, but since the registry is not set up, it fails to initialize.

Fixes: 0e42ec83d46a ("gpu: nova-core: gsp: shuffle boot code a bit to keep chipset-specific parts close")
Signed-off-by: Timur Tabi <ttabi@nvidia.com>
Reviewed-by: Alexandre Courbot <acourbot@nvidia.com>
Reviewed-by: John Hubbard <jhubbard@nvidia.com>
Link: https://patch.msgid.link/20260810181243.3036669-1-ttabi@nvidia.com
Signed-off-by: Alexandre Courbot <acourbot@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/nova-core/gsp/boot.rs | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/gpu/nova-core/gsp/boot.rs b/drivers/gpu/nova-core/gsp/boot.rs
index e03700ee7beaf..874f6e9499f01 100644
--- a/drivers/gpu/nova-core/gsp/boot.rs
+++ b/drivers/gpu/nova-core/gsp/boot.rs
@@ -44,6 +44,11 @@ pub(crate) fn boot(
 
         let gsp_fw = KBox::pin_init(GspFirmware::new(dev, chipset), GFP_KERNEL)?;
 
+        self.cmdq
+            .send_command_no_wait(bar, commands::SetSystemInfo::new(pdev, chipset))?;
+        self.cmdq
+            .send_command_no_wait(bar, commands::SetRegistry::new(ctx.vgpu.state())?)?;
+
         // Perform the chipset-specific boot sequence, and retrieve the unload bundle.
         let unload_bundle = hal.boot(&self, &mut ctx, &gsp_fw)?.or_else(|| {
             dev_warn!(dev, "The GSP won't be able to unload properly on unbind.\n");
@@ -73,11 +78,6 @@ pub(crate) fn boot(
 
         dev_dbg!(pdev, "RISC-V active? {}\n", gsp_falcon.is_riscv_active(),);
 
-        self.cmdq
-            .send_command_no_wait(bar, commands::SetSystemInfo::new(pdev, chipset))?;
-        self.cmdq
-            .send_command_no_wait(bar, commands::SetRegistry::new(ctx.vgpu.state())?)?;
-
         hal.post_boot(&self, ctx, &gsp_fw)?;
 
         // Wait until GSP is fully initialized.
-- 
2.53.0



