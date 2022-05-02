Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A4F082F32
	for <patches@lists.linux.dev>; Mon,  2 May 2022 19:17:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:Content-Type:
	In-Reply-To:From:References:Cc:To:Subject:MIME-Version:Date:Message-ID:Sender
	:Reply-To:Content-ID:Content-Description;
	bh=VYAtT7Wc6akYlZBDiczFbpL+sZ7HYXf9H5aNtwhdx2g=; b=PKjZ44WX0vwM76g5LrHso2dITS
	l9pYhPhhWoMPqkOlZ2YDSbChWcsZMxDBEktFr2kjZbCqNNOfv0ogf7nczCmjEvkWqPU1c0/UXCqfZ
	P8g2KWYLXSBSbmel5AI2Vovk7cPt4yqhgbsSsuFuuvJPtbP+gv0b81j1o9lDm8ObCkAOmGHKipDMl
	8sUkX2Sn+gK3nBC6se65mNXB4cLpjGWvts3I8spMXwMYrd9mDKAVteOH1XD7RyLfIej0AHdWt+EZe
	5vVmpPvY1XiJelIDGMT+ne2WzmPEgYjm5fQ6Ug5Mkm5AEamEFC25SLfug0skxfAKzSZJwmYWQT/YF
	PtiUwJFg==;
Received: from [2601:1c0:6280:3f0::aa0b]
	by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
	id 1nlbXi-00F3hO-Ok; Mon, 02 May 2022 19:17:11 +0000
Message-ID: <067d57b7-f25f-43aa-91a9-297fcadde65b@infradead.org>
Date: Mon, 2 May 2022 12:17:05 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.1
Subject: Re: [PATCH] POWERPC: idle: fix return value of __setup handler
Content-Language: en-US
To: Christophe Leroy <christophe.leroy@csgroup.eu>,
 Michael Ellerman <mpe@ellerman.id.au>,
 "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>
Cc: Paul Mackerras <paulus@samba.org>,
 "patches@lists.linux.dev" <patches@lists.linux.dev>,
 Arnd Bergmann <arnd@arndb.de>
References: <20220313065848.2150-1-rdunlap@infradead.org>
 <87r15c8439.fsf@mpe.ellerman.id.au>
 <a3cb014d-96e0-c681-7347-a5c1d185d9fc@infradead.org>
 <dfe0a791-025b-421f-8cab-9919a50afeb9@csgroup.eu>
From: Randy Dunlap <rdunlap@infradead.org>
In-Reply-To: <dfe0a791-025b-421f-8cab-9919a50afeb9@csgroup.eu>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit



On 5/2/22 11:45, Christophe Leroy wrote:
> 
> 
> Le 02/05/2022 à 17:50, Randy Dunlap a écrit :
>>
>>
>> On 5/2/22 06:19, Michael Ellerman wrote:
>>> Randy Dunlap <rdunlap@infradead.org> writes:
>>>> __setup() handlers should return 1 to obsolete_checksetup() in
>>>> init/main.c to indicate that the boot option has been handled.
>>>> A return of 0 causes the boot option/value to be listed as an Unknown
>>>> kernel parameter and added to init's (limited) argument or environment
>>>> strings. Also, error return codes don't mean anything to
>>>> obsolete_checksetup() -- only non-zero (usually 1) or zero.
>>>> So return 1 from powersave_off().
>>>>
>>>> Fixes: 302eca184fb8 ("[POWERPC] cell: use ppc_md->power_save instead of cbe_idle_loop")
>>>> Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
>>>> From: Igor Zhbanov <i.zhbanov@omprussia.ru>
>>>
>>> What happened here? Is the patch actually from Igor? If so he should be
>>> the author, and it should include his SoB shouldn't it?
>>
>> I don't know what happened. I did the patches.
>> I'll resend them.
>>
> 
> Some erroneous copy/paste from 
> https://patchwork.ozlabs.org/project/linuxppc-dev/patch/20220308024228.20477-1-rdunlap@infradead.org/ 
> ?

Yes, it should have been Reported-by:

> 
>> Thanks.
>>
>>> Same comment for "[PATCH] powerpc/4xx: cpm: fix return value of __setup handler".
>>>
>>> cheers
>>>
>>>> Link: lore.kernel.org/r/64644a2f-4a20-bab3-1e15-3b2cdd0defe3@omprussia.ru
>>>> Cc: Arnd Bergmann <arnd@arndb.de>
>>>> Cc: Paul Mackerras <paulus@samba.org>
>>>> Cc: Michael Ellerman <mpe@ellerman.id.au>
>>>> Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
>>>> ---
>>>>   arch/powerpc/kernel/idle.c |    2 +-
>>>>   1 file changed, 1 insertion(+), 1 deletion(-)
>>>>
>>>> --- linux-next-20220310.orig/arch/powerpc/kernel/idle.c
>>>> +++ linux-next-20220310/arch/powerpc/kernel/idle.c
>>>> @@ -37,7 +37,7 @@ static int __init powersave_off(char *ar
>>>>   {
>>>>   	ppc_md.power_save = NULL;
>>>>   	cpuidle_disable = IDLE_POWERSAVE_OFF;
>>>> -	return 0;
>>>> +	return 1;
>>>>   }
>>>>   __setup("powersave=off", powersave_off);
>>>>   

-- 
~Randy
