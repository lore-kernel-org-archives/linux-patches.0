Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A8FA331BC8D;
	Mon, 13 Oct 2025 15:36:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760369796; cv=none; b=gnPY38VbhfO66nolXLYs/tdcXcUYCB1V/7kpS9v+uqjWl+JxgJ81cEN92GsayArer4tNiDwACLp1cg16qQOeEHkckEp6cZQIWZfp+H0VkYD7Za+7iGPVqXVY+AeVYiUrSdIOp3bvuwyMAXsMbKsa8hV5bczP8RgwDjRyqhUOQMg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760369796; c=relaxed/simple;
	bh=b2P+d/MtZVEOq9/biN70kWvKm78d6DIr5NAXW82Gg5U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aIxjXSa3Pg3XvuXYDLyh81pf7oQ00Te3PmqxazsAPyxHQQ3ockf6PPTyZA9dm9Lqvj8jTBglpCN7PoXPQCkPqQY6cLZIHAj9iQpF12MbkoH5bQryNJFFg/krtsH+4Y5BbmLVTNx35Z7IN+u7NqfdpnR9GTZ6KGZXdliRHDv2CL8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=M62RlJWT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="M62RlJWT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2D7A0C116B1;
	Mon, 13 Oct 2025 15:36:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760369796;
	bh=b2P+d/MtZVEOq9/biN70kWvKm78d6DIr5NAXW82Gg5U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=M62RlJWTpHAeiPg9k/Z3tu1MU1uQUfm/HhI5p7zFpzynTGtv66LguRwcm5zIL9yZv
	 eyoqglmrQ79vHV4oInt9U6luEgIyPvXQfEbjm68he57aEXoOm4eeiEv9Z3kX7tBbtt
	 VCw2E4FlwIYsw3v66P5JlHCg3hmEgBNJF9vDkpyM=
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
Subject: [PATCH 6.17 370/563] RISC-V: KVM: Write hgatp register with valid mode bits
Date: Mon, 13 Oct 2025 16:43:51 +0200
Message-ID: <20251013144424.680292371@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251013144411.274874080@linuxfoundation.org>
References: <20251013144411.274874080@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

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
 arch/riscv/kvm/vmid.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/arch/riscv/kvm/vmid.c b/arch/riscv/kvm/vmid.c
index 3b426c800480c..5f33625f40706 100644
--- a/arch/riscv/kvm/vmid.c
+++ b/arch/riscv/kvm/vmid.c
@@ -14,6 +14,7 @@
 #include <linux/smp.h>
 #include <linux/kvm_host.h>
 #include <asm/csr.h>
+#include <asm/kvm_mmu.h>
 #include <asm/kvm_tlb.h>
 #include <asm/kvm_vmid.h>
 
@@ -28,7 +29,7 @@ void __init kvm_riscv_gstage_vmid_detect(void)
 
 	/* Figure-out number of VMID bits in HW */
 	old = csr_read(CSR_HGATP);
-	csr_write(CSR_HGATP, old | HGATP_VMID);
+	csr_write(CSR_HGATP, (kvm_riscv_gstage_mode << HGATP_MODE_SHIFT) | HGATP_VMID);
 	vmid_bits = csr_read(CSR_HGATP);
 	vmid_bits = (vmid_bits & HGATP_VMID) >> HGATP_VMID_SHIFT;
 	vmid_bits = fls_long(vmid_bits);
-- 
2.51.0



