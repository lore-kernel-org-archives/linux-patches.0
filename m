Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 61DF51FC7DE;
	Wed,  6 Nov 2024 12:55:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730897741; cv=none; b=l0CwgB6U7oUlqUtIeQAgDd0frN38/zoisv8LQgVu5D968SCngeoc7n7dK/7vjW6vK+cnbC9JTbTjb1zAkePGsdZtoIsR/ZVvKyy+pkKcfrTZDuC11IZixeAZULGO54Dx1UUobzqJOyR6ciR9qkKHWR1ncXwkht4ax0440EGTZWY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730897741; c=relaxed/simple;
	bh=vbuN/YpMT6xnuNBAV9J+ulVGF64PzIEvDjcKtl3vvVE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Swl82Nxf7bqdeQrBlXkY85x28HZ8YRTrOnJQdj8nRPKhaxu9tZbIHFvIpOWNFDw1oWYzdHA6rNzm4YUGwEgj2etMmS7wAbThjc8CAZNVAEsBjhy/xk0GJ3JbNNupnmCdxvKT/oeO+hmsFwXFx6bfNMTpFoxcW9HsmGkATDHzzpY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1/gAv0xY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1/gAv0xY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DB591C4CED3;
	Wed,  6 Nov 2024 12:55:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730897741;
	bh=vbuN/YpMT6xnuNBAV9J+ulVGF64PzIEvDjcKtl3vvVE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1/gAv0xYWqHn46oTdIC5WimdZodKML5JgyF+XQt7GTU5FGcA3nPifhVmJgC6BZcxk
	 jkcovuXGy1nrSBeIvWCI9sBiz6IKedDoDtEHwdDCTch3h+LtnbHvjZKwHMBmZUenhm
	 GlqUM6nWlK0mChBpSejZoX696su3jUecDywM4wuM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexandre Ghiti <alexghiti@rivosinc.com>,
	Chunyan Zhang <zhangchunyan@iscas.ac.cn>,
	Palmer Dabbelt <palmer@rivosinc.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 118/151] riscv: Remove unused GENERATING_ASM_OFFSETS
Date: Wed,  6 Nov 2024 13:05:06 +0100
Message-ID: <20241106120312.113120159@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241106120308.841299741@linuxfoundation.org>
References: <20241106120308.841299741@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chunyan Zhang <zhangchunyan@iscas.ac.cn>

[ Upstream commit 46d4e5ac6f2f801f97bcd0ec82365969197dc9b1 ]

The macro is not used in the current version of kernel, it looks like
can be removed to avoid a build warning:

../arch/riscv/kernel/asm-offsets.c: At top level:
../arch/riscv/kernel/asm-offsets.c:7: warning: macro "GENERATING_ASM_OFFSETS" is not used [-Wunused-macros]
    7 | #define GENERATING_ASM_OFFSETS

Fixes: 9639a44394b9 ("RISC-V: Provide a cleaner raw_smp_processor_id()")
Cc: stable@vger.kernel.org
Reviewed-by: Alexandre Ghiti <alexghiti@rivosinc.com>
Tested-by: Alexandre Ghiti <alexghiti@rivosinc.com>
Signed-off-by: Chunyan Zhang <zhangchunyan@iscas.ac.cn>
Link: https://lore.kernel.org/r/20241008094141.549248-2-zhangchunyan@iscas.ac.cn
Signed-off-by: Palmer Dabbelt <palmer@rivosinc.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/riscv/kernel/asm-offsets.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/arch/riscv/kernel/asm-offsets.c b/arch/riscv/kernel/asm-offsets.c
index 9f535d5de33f9..6a992cba2f287 100644
--- a/arch/riscv/kernel/asm-offsets.c
+++ b/arch/riscv/kernel/asm-offsets.c
@@ -4,8 +4,6 @@
  * Copyright (C) 2017 SiFive
  */
 
-#define GENERATING_ASM_OFFSETS
-
 #include <linux/kbuild.h>
 #include <linux/mm.h>
 #include <linux/sched.h>
-- 
2.43.0



