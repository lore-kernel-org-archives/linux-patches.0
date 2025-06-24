Received: from szxga07-in.huawei.com (szxga07-in.huawei.com [45.249.212.35])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F34E322D793
	for <patches@lists.linux.dev>; Tue, 24 Jun 2025 11:57:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.35
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750766266; cv=none; b=b5KvA6bYiN+MH5CDhNNf8pNYvnk03ZVtJuqEfQyJHaNAmt/HCnLuKM3XDJSPvv+EObQwr5AOiaEZblN5jsCecTOH85xXPoRULCTkVcptwVlvQKEsL+nwDO8GVyijd7PkhbLfiIjDUj+fJe9fQrY0KzSueTHme65rJmTJhZ5cWgs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750766266; c=relaxed/simple;
	bh=KeF3pLl8RdS+IGRnNVfO3PV/raHK0R3QKaVsnOyboxw=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=Is0Va0bntOzJiTE0OW1ASNYw3g3NEjfQoHa/oMT++UfYejTngnoImABv/JslFE1TZRL9vxhG6vnsdqybWz3zJZ7R0ltRc4Qb37IMufPgdR2PzzUsZwg8iA+4/QTayO5GNsNkaP+q6bkeFTPomoAHyUX1fIK/SMEQBKOlddTsuww=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.35
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.163.17])
	by szxga07-in.huawei.com (SkyGuard) with ESMTP id 4bRNh31wQwz1QBgM;
	Tue, 24 Jun 2025 19:56:03 +0800 (CST)
Received: from kwepemf100007.china.huawei.com (unknown [7.202.181.221])
	by mail.maildlp.com (Postfix) with ESMTPS id 122631A0188;
	Tue, 24 Jun 2025 19:57:40 +0800 (CST)
Received: from [10.67.109.184] (10.67.109.184) by
 kwepemf100007.china.huawei.com (7.202.181.221) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Tue, 24 Jun 2025 19:57:39 +0800
Message-ID: <a82c4b91-9ff2-47db-821f-36d1e403f064@huawei.com>
Date: Tue, 24 Jun 2025 19:57:38 +0800
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
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: <stable@vger.kernel.org>, <patches@lists.linux.dev>, Hou Tao
	<houtao1@huawei.com>, Will Deacon <will@kernel.org>
References: <20250623130626.716971725@linuxfoundation.org>
 <20250623130636.471359981@linuxfoundation.org>
 <596e3d6b-a5ff-4914-9a5b-26603e8de8d0@huawei.com>
 <2025062453-proton-preheated-90a8@gregkh>
From: Pu Lehui <pulehui@huawei.com>
In-Reply-To: <2025062453-proton-preheated-90a8@gregkh>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: kwepems200002.china.huawei.com (7.221.188.68) To
 kwepemf100007.china.huawei.com (7.202.181.221)



On 2025/6/24 18:24, Greg Kroah-Hartman wrote:
> On Tue, Jun 24, 2025 at 11:34:02AM +0800, Pu Lehui wrote:
>>
>> On 2025/6/23 21:08, Greg Kroah-Hartman wrote:
>>> 5.10-stable review patch.  If anyone has any objections, please let me know.
>>>
>>> ------------------
>>>
>>> From: Hou Tao <houtao1@huawei.com>
>>>
>>> [ Upstream commit 97e58e395e9c074fd096dad13c54e9f4112cf71d ]
>>>
>>> If CONFIG_ARM64_LSE_ATOMICS is off, encoders for LSE-related instructions
>>> can return AARCH64_BREAK_FAULT directly in insn.h. In order to access
>>> AARCH64_BREAK_FAULT in insn.h, we can not include debug-monitors.h in
>>> insn.h, because debug-monitors.h has already depends on insn.h, so just
>>> move AARCH64_BREAK_FAULT into insn-def.h.
>>>
>>> It will be used by the following patch to eliminate unnecessary LSE-related
>>> encoders when CONFIG_ARM64_LSE_ATOMICS is off.
>>>
>>> Signed-off-by: Hou Tao <houtao1@huawei.com>
>>> Link: https://lore.kernel.org/r/20220217072232.1186625-2-houtao1@huawei.com
>>> Signed-off-by: Will Deacon <will@kernel.org>
>>> [not exist insn-def.h file, move to insn.h]
>>> Signed-off-by: Pu Lehui <pulehui@huawei.com>
>>> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
>>> ---
>>>    arch/arm64/include/asm/debug-monitors.h |   12 ------------
>>>    arch/arm64/include/asm/insn.h           |   12 ++++++++++++
>>>    2 files changed, 12 insertions(+), 12 deletions(-)
>>>
>>> --- a/arch/arm64/include/asm/debug-monitors.h
>>> +++ b/arch/arm64/include/asm/debug-monitors.h
>>> @@ -34,18 +34,6 @@
>>>     */
>>>    #define BREAK_INSTR_SIZE		AARCH64_INSN_SIZE
>>> -/*
>>> - * BRK instruction encoding
>>> - * The #imm16 value should be placed at bits[20:5] within BRK ins
>>> - */
>>> -#define AARCH64_BREAK_MON	0xd4200000
>>> -
>>> -/*
>>> - * BRK instruction for provoking a fault on purpose
>>> - * Unlike kgdb, #imm16 value with unallocated handler is used for faulting.
>>> - */
>>> -#define AARCH64_BREAK_FAULT	(AARCH64_BREAK_MON | (FAULT_BRK_IMM << 5))
>>> -
>>>    #define AARCH64_BREAK_KGDB_DYN_DBG	\
>>>    	(AARCH64_BREAK_MON | (KGDB_DYN_DBG_BRK_IMM << 5))
>>> --- a/arch/arm64/include/asm/insn.h
>>> +++ b/arch/arm64/include/asm/insn.h
>>> @@ -13,6 +13,18 @@
>>>    /* A64 instructions are always 32 bits. */
>>>    #define	AARCH64_INSN_SIZE		4
>>> +/*
>>> + * BRK instruction encoding
>>> + * The #imm16 value should be placed at bits[20:5] within BRK ins
>>> + */
>>> +#define AARCH64_BREAK_MON      0xd4200000
>>> +
>>> +/*
>>> + * BRK instruction for provoking a fault on purpose
>>> + * Unlike kgdb, #imm16 value with unallocated handler is used for faulting.
>>> + */
>>> +#define AARCH64_BREAK_FAULT    (AARCH64_BREAK_MON | (FAULT_BRK_IMM << 5))
>>
>> Hi Greg,
>>
>> Dominique just discovered a compilation problem [0] caused by not having
>> `#include <asm/brk-imm.h>` in insn.h.
>>
>> I have fixed it as shown below, should I resend the formal patch?
>>
>> Link: https://lore.kernel.org/all/aFniFC7ywCoveOts@codewreck.org/ [0]
> 
> Let me see if I can just take this as-is...
> 
> Ok, it worked for 5.10.y, is this also needed in 5.15.y?

No need. 5.15.y has covered <asm/brk-imm.h> header file.

thanks

> 
> thanks,
> 
> greg k-h
> 
