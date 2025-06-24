Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7BF8FEC5
	for <patches@lists.linux.dev>; Tue, 24 Jun 2025 03:34:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.188
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750736049; cv=none; b=lf+ryKzQo2KjFdBPh9jpsoWUF4furRxACXxpxxJgQgnUK5DuEdajxt7NkKzvq7XKxxTbvgHOIa42fps5kvbvudQMBlOQTXcTgw7ewWuAo3e4HMCrqCPau2lirwc7RE5RxEUmDdL+x3ctlfngWLKn1YZWW7zPCVetbAe/PsYjqz8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750736049; c=relaxed/simple;
	bh=+jv93nnAvev8Ht3MTHPIPYA8OWi19DM62BlyGr4FVkQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=k/mHjruMx5hFfsKqpjNdrHrQyQzKtDVK5zW01Kms3/W4QXqTcEm/ckPLxiYwfhUX09aWRhqbo/9UfVXUw1sJwn+zcuBV47yYbyJVlADp23pfVQEqGk7QaKLhsWZV/Lt33iilXieSKaS6+bY2wD2aQ9h53wO4IRAT+45kApIpOTw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.188
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.163.48])
	by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4bR9Rr4WQJzTgwT;
	Tue, 24 Jun 2025 11:29:44 +0800 (CST)
Received: from kwepemf100007.china.huawei.com (unknown [7.202.181.221])
	by mail.maildlp.com (Postfix) with ESMTPS id 8EB75180087;
	Tue, 24 Jun 2025 11:34:03 +0800 (CST)
Received: from [10.67.109.184] (10.67.109.184) by
 kwepemf100007.china.huawei.com (7.202.181.221) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Tue, 24 Jun 2025 11:34:03 +0800
Message-ID: <596e3d6b-a5ff-4914-9a5b-26603e8de8d0@huawei.com>
Date: Tue, 24 Jun 2025 11:34:02 +0800
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 5.10 323/355] arm64: move AARCH64_BREAK_FAULT into
 insn-def.h
Content-Language: en-US
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, <stable@vger.kernel.org>
CC: <patches@lists.linux.dev>, Hou Tao <houtao1@huawei.com>, Will Deacon
	<will@kernel.org>
References: <20250623130626.716971725@linuxfoundation.org>
 <20250623130636.471359981@linuxfoundation.org>
From: Pu Lehui <pulehui@huawei.com>
In-Reply-To: <20250623130636.471359981@linuxfoundation.org>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: kwepems100002.china.huawei.com (7.221.188.206) To
 kwepemf100007.china.huawei.com (7.202.181.221)


On 2025/6/23 21:08, Greg Kroah-Hartman wrote:
> 5.10-stable review patch.  If anyone has any objections, please let me know.
> 
> ------------------
> 
> From: Hou Tao <houtao1@huawei.com>
> 
> [ Upstream commit 97e58e395e9c074fd096dad13c54e9f4112cf71d ]
> 
> If CONFIG_ARM64_LSE_ATOMICS is off, encoders for LSE-related instructions
> can return AARCH64_BREAK_FAULT directly in insn.h. In order to access
> AARCH64_BREAK_FAULT in insn.h, we can not include debug-monitors.h in
> insn.h, because debug-monitors.h has already depends on insn.h, so just
> move AARCH64_BREAK_FAULT into insn-def.h.
> 
> It will be used by the following patch to eliminate unnecessary LSE-related
> encoders when CONFIG_ARM64_LSE_ATOMICS is off.
> 
> Signed-off-by: Hou Tao <houtao1@huawei.com>
> Link: https://lore.kernel.org/r/20220217072232.1186625-2-houtao1@huawei.com
> Signed-off-by: Will Deacon <will@kernel.org>
> [not exist insn-def.h file, move to insn.h]
> Signed-off-by: Pu Lehui <pulehui@huawei.com>
> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> ---
>   arch/arm64/include/asm/debug-monitors.h |   12 ------------
>   arch/arm64/include/asm/insn.h           |   12 ++++++++++++
>   2 files changed, 12 insertions(+), 12 deletions(-)
> 
> --- a/arch/arm64/include/asm/debug-monitors.h
> +++ b/arch/arm64/include/asm/debug-monitors.h
> @@ -34,18 +34,6 @@
>    */
>   #define BREAK_INSTR_SIZE		AARCH64_INSN_SIZE
>   
> -/*
> - * BRK instruction encoding
> - * The #imm16 value should be placed at bits[20:5] within BRK ins
> - */
> -#define AARCH64_BREAK_MON	0xd4200000
> -
> -/*
> - * BRK instruction for provoking a fault on purpose
> - * Unlike kgdb, #imm16 value with unallocated handler is used for faulting.
> - */
> -#define AARCH64_BREAK_FAULT	(AARCH64_BREAK_MON | (FAULT_BRK_IMM << 5))
> -
>   #define AARCH64_BREAK_KGDB_DYN_DBG	\
>   	(AARCH64_BREAK_MON | (KGDB_DYN_DBG_BRK_IMM << 5))
>   
> --- a/arch/arm64/include/asm/insn.h
> +++ b/arch/arm64/include/asm/insn.h
> @@ -13,6 +13,18 @@
>   /* A64 instructions are always 32 bits. */
>   #define	AARCH64_INSN_SIZE		4
>   
> +/*
> + * BRK instruction encoding
> + * The #imm16 value should be placed at bits[20:5] within BRK ins
> + */
> +#define AARCH64_BREAK_MON      0xd4200000
> +
> +/*
> + * BRK instruction for provoking a fault on purpose
> + * Unlike kgdb, #imm16 value with unallocated handler is used for faulting.
> + */
> +#define AARCH64_BREAK_FAULT    (AARCH64_BREAK_MON | (FAULT_BRK_IMM << 5))

Hi Greg,

Dominique just discovered a compilation problem [0] caused by not having 
`#include <asm/brk-imm.h>` in insn.h.

I have fixed it as shown below, should I resend the formal patch?

Link: https://lore.kernel.org/all/aFniFC7ywCoveOts@codewreck.org/ [0]



 From 23001baa7607fb28d3fc8a96006111503ee2b536 Mon Sep 17 00:00:00 2001
From: Hou Tao <houtao1@huawei.com>
Date: Sat, 7 Jun 2025 15:25:09 +0000
Subject: [PATCH] arm64: move AARCH64_BREAK_FAULT into insn-def.h

[ Upstream commit 97e58e395e9c074fd096dad13c54e9f4112cf71d ]

If CONFIG_ARM64_LSE_ATOMICS is off, encoders for LSE-related instructions
can return AARCH64_BREAK_FAULT directly in insn.h. In order to access
AARCH64_BREAK_FAULT in insn.h, we can not include debug-monitors.h in
insn.h, because debug-monitors.h has already depends on insn.h, so just
move AARCH64_BREAK_FAULT into insn-def.h.

It will be used by the following patch to eliminate unnecessary LSE-related
encoders when CONFIG_ARM64_LSE_ATOMICS is off.

Signed-off-by: Hou Tao <houtao1@huawei.com>
Link: https://lore.kernel.org/r/20220217072232.1186625-2-houtao1@huawei.com
Signed-off-by: Will Deacon <will@kernel.org>
[not exist insn-def.h file, move to insn.h]
Signed-off-by: Pu Lehui <pulehui@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
  arch/arm64/include/asm/debug-monitors.h | 12 ------------
  arch/arm64/include/asm/insn.h           | 13 +++++++++++++
  2 files changed, 13 insertions(+), 12 deletions(-)

diff --git a/arch/arm64/include/asm/debug-monitors.h 
b/arch/arm64/include/asm/debug-monitors.h
index c16ed5b68768..e1d166beb99b 100644
--- a/arch/arm64/include/asm/debug-monitors.h
+++ b/arch/arm64/include/asm/debug-monitors.h
@@ -34,18 +34,6 @@
   */
  #define BREAK_INSTR_SIZE		AARCH64_INSN_SIZE

-/*
- * BRK instruction encoding
- * The #imm16 value should be placed at bits[20:5] within BRK ins
- */
-#define AARCH64_BREAK_MON	0xd4200000
-
-/*
- * BRK instruction for provoking a fault on purpose
- * Unlike kgdb, #imm16 value with unallocated handler is used for faulting.
- */
-#define AARCH64_BREAK_FAULT	(AARCH64_BREAK_MON | (FAULT_BRK_IMM << 5))
-
  #define AARCH64_BREAK_KGDB_DYN_DBG	\
  	(AARCH64_BREAK_MON | (KGDB_DYN_DBG_BRK_IMM << 5))

diff --git a/arch/arm64/include/asm/insn.h b/arch/arm64/include/asm/insn.h
index e16e43a1702b..8757107d3877 100644
--- a/arch/arm64/include/asm/insn.h
+++ b/arch/arm64/include/asm/insn.h
@@ -9,10 +9,23 @@
  #define	__ASM_INSN_H
  #include <linux/build_bug.h>
  #include <linux/types.h>
+#include <asm/brk-imm.h>

  /* A64 instructions are always 32 bits. */
  #define	AARCH64_INSN_SIZE		4

+/*
+ * BRK instruction encoding
+ * The #imm16 value should be placed at bits[20:5] within BRK ins
+ */
+#define AARCH64_BREAK_MON      0xd4200000
+
+/*
+ * BRK instruction for provoking a fault on purpose
+ * Unlike kgdb, #imm16 value with unallocated handler is used for faulting.
+ */
+#define AARCH64_BREAK_FAULT    (AARCH64_BREAK_MON | (FAULT_BRK_IMM << 5))
+
  #ifndef __ASSEMBLY__
  /*
   * ARM Architecture Reference Manual for ARMv8 Profile-A, Issue A.a
-- 
2.34.1


> +
>   #ifndef __ASSEMBLY__
>   /*
>    * ARM Architecture Reference Manual for ARMv8 Profile-A, Issue A.a
> 
> 
> 
