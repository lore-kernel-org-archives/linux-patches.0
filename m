Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 997593921FB;
	Sat, 17 Oct 2026 17:31:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792258296; cv=none; b=WKwMopwuhOsaWnQnisp5bdMo9AsK7AtUc0DAYaf7biiNJUFgpm30lPZEAZRZiFm2RImgHzcTWD/JM8FwATgSCQp1/q8SXwfDPxe4ffvyJz4rAOt6etHMOSy4QGH9z+bVo8mtSuBUxqaM744gMGfk5qkREdJ0RC/Jvm1F0t5DKF0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792258296; c=relaxed/simple;
	bh=m8JqdHsX5HDO4nvX1s9o2JP5tR+ak932allv3JEpRPs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KOuUd0mRZ0gDIMZuxcoNsDqbzRUw5iIeCk7zEk41D7ysAludEWk6wjCSLe2TgcR/lKqm1dAJsER0F28/zvNAdPbS3LXuS9e0PloVHyyQJpQtph13C5SGCl2sk2bLyZhrBbgFcfrUV79sb77AEKt/z6bWQbBKQKn/3zLwD2A9LX8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=e07vaAbf; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="e07vaAbf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 04A691F000C4;
	Sat, 17 Oct 2026 17:31:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792258295;
	bh=LaEUVhtO64Snvnrni1I8k6jQW7tdVBKKIigpaOikHx0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=e07vaAbfktfxtu2PxR8gFkQ8NDfPzloeg100RyiNrC8YJQQ1NjBBKgcp01EXVoHEn
	 g7SKj5VzF3Y+Yn/PEXMtZ5auyEUFNi9dLq27VAsO2vGbz+V9XgvxzoUdyJ5PRTnLlM
	 FNqMH34G4j6nUo0/0qSYDSm7lm9hGQeupjpzPvk0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nutty Liu <nutty.liu@hotmail.com>,
	Troy Mitchell <troy.mitchell@linux.spacemit.com>,
	"Guo Ren (Alibaba DAMO Academy)" <guoren@kernel.org>,
	Fangyu Yu <fangyu.yu@linux.alibaba.com>,
	Anup Patel <anup@brainfault.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0800/1674] RISC-V: KVM: Write hgatp register with valid mode bits
Date: Sat, 17 Oct 2026 17:51:12 +0200
Message-ID: <20261017160451.644782764@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160431.119607952@linuxfoundation.org>
References: <20261017160431.119607952@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Fangyu Yu <fangyu.yu@linux.alibaba.com>

[ Upstream commit 2b351e3d04be9e1533f26c3464f1e44a5beace30 ]

According to the RISC-V Privileged Architecture Spec, when MODE=Bare
is selected,software must write zero to the remaining fields of hgatp.

We have detected the valid mode supported by the HW before, So using a
valid mode to detect how many vmid bits are supported.

Fixes: fd7bb4a251df ("RISC-V: KVM: Implement VMID allocator")
Reviewed-by: Nutty Liu <nutty.liu@hotmail.com>
Reviewed-by: Troy Mitchell <troy.mitchell@linux.spacemit.com>
Reviewed-by: Guo Ren (Alibaba DAMO Academy) <guoren@kernel.org>
Signed-off-by: Fangyu Yu <fangyu.yu@linux.alibaba.com>
Signed-off-by: Guo Ren (Alibaba DAMO Academy) <guoren@kernel.org>
Link: https://lore.kernel.org/r/20250821142542.2472079-2-guoren@kernel.org
Signed-off-by: Anup Patel <anup@brainfault.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/riscv/kvm/vmid.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/riscv/kvm/vmid.c b/arch/riscv/kvm/vmid.c
index ddc98714ce8ed..38f30f5a608cf 100644
--- a/arch/riscv/kvm/vmid.c
+++ b/arch/riscv/kvm/vmid.c
@@ -26,7 +26,7 @@ void __init kvm_riscv_gstage_vmid_detect(void)
 
 	/* Figure-out number of VMID bits in HW */
 	old = csr_read(CSR_HGATP);
-	csr_write(CSR_HGATP, old | HGATP_VMID);
+	csr_write(CSR_HGATP, (kvm_riscv_gstage_mode() << HGATP_MODE_SHIFT) | HGATP_VMID);
 	vmid_bits = csr_read(CSR_HGATP);
 	vmid_bits = (vmid_bits & HGATP_VMID) >> HGATP_VMID_SHIFT;
 	vmid_bits = fls_long(vmid_bits);
-- 
2.53.0



