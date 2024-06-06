Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8494C19883C;
	Thu,  6 Jun 2024 14:10:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717683035; cv=none; b=Iz/dBU2PSAE1iDdoiLEBJcCgc9doIxj+S/MckDjeQvsG7zugvhV+PdpVxcbl8y7HewNyvTqmRUgtwC3FWCTu7bnQL1+k2ALbV3rqihD1HWdEr8FJgyFaYV07XF+zAZXGd8+wZDG4eMu7BDBddKq1D4crOMyBMddIDWW1RQiq/Aw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717683035; c=relaxed/simple;
	bh=6LfRo7IEzzdjSsvzsC/EaMo18Q2/CUWOjzvahgJW82k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=d5NmDxn4cUFL9fWz+JV1WHfsj0L8ZV2YMehCbOA/1MnCzbNsXpoXllOqTpJQ0sKJ4QhvVMzYHs3po6n4QdneYq+qjIW618aQOQx4YVdDHrZPP929cTzYWgeYC5MDe5RwCYUWkRTMRGPQjkmHmo3UZ1muYOkHsdNG9yvHh/Q5nyw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mxDkYDYz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mxDkYDYz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 634B0C4AF48;
	Thu,  6 Jun 2024 14:10:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717683035;
	bh=6LfRo7IEzzdjSsvzsC/EaMo18Q2/CUWOjzvahgJW82k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mxDkYDYzE87bVty8Qb5fHhSoeao2XYerVQ1F1LqK7aIkHvWyBCbhTh3IC+uuhtyHV
	 i/LDij5IY/weEmLbDFdkiluzEXO1l18RulSAfzDtuWSS0nz1g1sfKzfLarQKQU+zL/
	 1unRkxh2GIzXouAlOvYwz/RPwJosiYccOQyimN9M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Charlie Jenkins <charlie@rivosinc.com>,
	Conor Dooley <conor.dooley@microchip.com>,
	Alexandre Ghiti <alexghiti@rivosinc.com>,
	Andrew Jones <ajones@ventanamicro.com>,
	Palmer Dabbelt <palmer@rivosinc.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.9 262/374] riscv: cpufeature: Fix extension subset checking
Date: Thu,  6 Jun 2024 16:04:01 +0200
Message-ID: <20240606131700.668931934@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240606131651.683718371@linuxfoundation.org>
References: <20240606131651.683718371@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Charlie Jenkins <charlie@rivosinc.com>

[ Upstream commit e67e98ee8952c7d5ce986d1dc6f8221ab8674afa ]

This loop is supposed to check if ext->subset_ext_ids[j] is valid, rather
than if ext->subset_ext_ids[i] is valid, before setting the extension
id ext->subset_ext_ids[j] in isainfo->isa.

Signed-off-by: Charlie Jenkins <charlie@rivosinc.com>
Reviewed-by: Conor Dooley <conor.dooley@microchip.com>
Reviewed-by: Alexandre Ghiti <alexghiti@rivosinc.com>
Reviewed-by: Andrew Jones <ajones@ventanamicro.com>
Fixes: 0d8295ed975b ("riscv: add ISA extension parsing for scalar crypto")
Link: https://lore.kernel.org/r/20240502-cpufeature_fixes-v4-2-b3d1a088722d@rivosinc.com
Signed-off-by: Palmer Dabbelt <palmer@rivosinc.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/riscv/kernel/cpufeature.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/riscv/kernel/cpufeature.c b/arch/riscv/kernel/cpufeature.c
index 13d4fc0d1817e..5ef48cb20ee11 100644
--- a/arch/riscv/kernel/cpufeature.c
+++ b/arch/riscv/kernel/cpufeature.c
@@ -603,7 +603,7 @@ static int __init riscv_fill_hwcap_from_ext_list(unsigned long *isa2hwcap)
 
 			if (ext->subset_ext_size) {
 				for (int j = 0; j < ext->subset_ext_size; j++) {
-					if (riscv_isa_extension_check(ext->subset_ext_ids[i]))
+					if (riscv_isa_extension_check(ext->subset_ext_ids[j]))
 						set_bit(ext->subset_ext_ids[j], isainfo->isa);
 				}
 			}
-- 
2.43.0



