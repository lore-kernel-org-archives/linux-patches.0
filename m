Received: from szxga08-in.huawei.com (szxga08-in.huawei.com [45.249.212.255])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2229B2AD20
	for <patches@lists.linux.dev>; Tue, 24 Jun 2025 02:06:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.255
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750730768; cv=none; b=kxQNY+W8B7sGb+E2DSLm85r8DPpKNPCA2rqsdSnAfaCp71+uhPrVPcw8D3vCBPVC1PA9ROR3B16zEK6nLahtWjxeuQWcL8GNiqIWvC+8azcB0uF6gtGI4PJx0Bts0WaWAkulZfoLjYzDVbwme4FNJpxq3XEyfN3CYi8UKo/KEE0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750730768; c=relaxed/simple;
	bh=PdzGn8GpEE7c1ExT4673Pc2TbwMJMWVWeFk7wIMCJNo=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=VCiNKOsBwIO2zNR3tjCJKzN/MW6DGifxHo+gkxUCmtU+I1a9On7+mus6/LYmzq+ukITT9/7zhBp5+c+k0QMXQH7keDxBEZtvKR3A2GCSIVIvPEEYK7HyGHhtRiC3VL5btC1Tc7oBUWRD3FeGHuyHDzBV8oWopigOgxZMOl6dOJk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.255
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.162.254])
	by szxga08-in.huawei.com (SkyGuard) with ESMTP id 4bR7XZ3HVjz1d1YG;
	Tue, 24 Jun 2025 10:03:42 +0800 (CST)
Received: from kwepemf100007.china.huawei.com (unknown [7.202.181.221])
	by mail.maildlp.com (Postfix) with ESMTPS id 46960180493;
	Tue, 24 Jun 2025 10:06:01 +0800 (CST)
Received: from [10.67.109.184] (10.67.109.184) by
 kwepemf100007.china.huawei.com (7.202.181.221) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Tue, 24 Jun 2025 10:06:00 +0800
Message-ID: <b6c88c2a-08ae-43b6-906e-1258c741eb34@huawei.com>
Date: Tue, 24 Jun 2025 10:05:59 +0800
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
To: Dominique Martinet <asmadeus@codewreck.org>, Greg Kroah-Hartman
	<gregkh@linuxfoundation.org>
CC: <stable@vger.kernel.org>, <patches@lists.linux.dev>, Hou Tao
	<houtao1@huawei.com>, Will Deacon <will@kernel.org>
References: <20250623130626.716971725@linuxfoundation.org>
 <20250623130636.471359981@linuxfoundation.org>
 <aFniFC7ywCoveOts@codewreck.org>
From: Pu Lehui <pulehui@huawei.com>
In-Reply-To: <aFniFC7ywCoveOts@codewreck.org>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: kwepems200001.china.huawei.com (7.221.188.67) To
 kwepemf100007.china.huawei.com (7.202.181.221)



On 2025/6/24 7:24, Dominique Martinet wrote:
> Greg Kroah-Hartman wrote on Mon, Jun 23, 2025 at 03:08:44PM +0200:
>> 5.10-stable review patch.  If anyone has any objections, please let me
>> know.
> 
> This fails to build on arm64 with the attached config
> (in particular arm64 defconfig works, I didn't check what's required to
> make this fail)
> 
>    CC      arch/arm64/kernel/asm-offsets.s
> In file included from ../arch/arm64/include/asm/alternative.h:6,
>                   from ../arch/arm64/include/asm/sysreg.h:1050,
>                   from ../arch/arm64/include/asm/cputype.h:194,
>                   from ../arch/arm64/include/asm/cache.h:8,
>                   from ../include/linux/cache.h:6,
>                   from ../include/linux/printk.h:9,
>                   from ../include/linux/kernel.h:17,
>                   from ../include/linux/list.h:9,
>                   from ../include/linux/kobject.h:19,
>                   from ../include/linux/of.h:17,
>                   from ../include/linux/irqdomain.h:35,
>                   from ../include/linux/acpi.h:13,
>                   from ../include/acpi/apei.h:9,
>                   from ../include/acpi/ghes.h:5,
>                   from ../include/linux/arm_sdei.h:8,
>                   from ../arch/arm64/kernel/asm-offsets.c:10:
> ../arch/arm64/include/asm/insn.h: In function ‘aarch64_insn_gen_atomic_ld_op’:
> ../arch/arm64/include/asm/insn.h:26:54: error: ‘FAULT_BRK_IMM’ undeclared (first use in this function)
>     26 | #define AARCH64_BREAK_FAULT    (AARCH64_BREAK_MON | (FAULT_BRK_IMM << 5))
>        |                                                      ^~~~~~~~~~~~~
> ../arch/arm64/include/asm/insn.h:573:16: note: in expansion of macro ‘AARCH64_BREAK_FAULT’
>    573 |         return AARCH64_BREAK_FAULT;
>        |                ^~~~~~~~~~~~~~~~~~~
> ../arch/arm64/include/asm/insn.h:26:54: note: each undeclared identifier is reported only once for each function it appears in
>     26 | #define AARCH64_BREAK_FAULT    (AARCH64_BREAK_MON | (FAULT_BRK_IMM << 5))
>        |                                                      ^~~~~~~~~~~~~
> ../arch/arm64/include/asm/insn.h:573:16: note: in expansion of macro ‘AARCH64_BREAK_FAULT’
>    573 |         return AARCH64_BREAK_FAULT;
>        |                ^~~~~~~~~~~~~~~~~~~
> ../arch/arm64/include/asm/insn.h: In function ‘aarch64_insn_gen_cas’:
> ../arch/arm64/include/asm/insn.h:26:54: error: ‘FAULT_BRK_IMM’ undeclared (first use in this function)
>     26 | #define AARCH64_BREAK_FAULT    (AARCH64_BREAK_MON | (FAULT_BRK_IMM << 5))
>        |                                                      ^~~~~~~~~~~~~
> ../arch/arm64/include/asm/insn.h:583:16: note: in expansion of macro ‘AARCH64_BREAK_FAULT’
>    583 |         return AARCH64_BREAK_FAULT;
>        |                ^~~~~~~~~~~~~~~~~~~
> make[2]: *** [../scripts/Makefile.build:117: arch/arm64/kernel/asm-offsets.s] Error 1
> make[1]: *** [/home/martinet/code/linux-5.15/Makefile:1262: prepare0]
> Error 2
> 
> 
> 
>> ------------------
>>
>> From: Hou Tao <houtao1@huawei.com>
>>
>> [ Upstream commit 97e58e395e9c074fd096dad13c54e9f4112cf71d ]
>>
>> If CONFIG_ARM64_LSE_ATOMICS is off, encoders for LSE-related instructions
>> can return AARCH64_BREAK_FAULT directly in insn.h. In order to access
>> AARCH64_BREAK_FAULT in insn.h, we can not include debug-monitors.h in
>> insn.h, because debug-monitors.h has already depends on insn.h, so just
>> move AARCH64_BREAK_FAULT into insn-def.h.
>>
>> It will be used by the following patch to eliminate unnecessary LSE-related
>> encoders when CONFIG_ARM64_LSE_ATOMICS is off.
>>
>> Signed-off-by: Hou Tao <houtao1@huawei.com>
>> Link: https://lore.kernel.org/r/20220217072232.1186625-2-houtao1@huawei.com
>> Signed-off-by: Will Deacon <will@kernel.org>
>> [not exist insn-def.h file, move to insn.h]
> 
> insn-def.h has `#include <asm/brk-imm.h>` which defines FAULT_BRK_IMM,
> it'd make sense to add the same to insn.h

Hi Dominiqu,

Thanks for reporting. Yeah, make sense to add `#include <asm/brk-imm.h>` 
to insn.h

> 
> 
> Thanks,
