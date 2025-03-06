Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA343190051;
	Thu,  6 Mar 2025 12:03:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741262583; cv=none; b=eZOoTOgBjsf3INbdhr/PiaKBEv473LuQlLSIiAlX5/C1WbSoj4tVm6Q0MdgcyZCewMz0RVslyyXueAGINsjZQQCKPf3Nz06z22JH+n4nI7G2mxmSrc0VcA7ph5fmuJUO1hTv2xZlTQa2jmdvsV85Bd52WLlKfdkR2mUnri/tHWw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741262583; c=relaxed/simple;
	bh=Sm7kxac7CKHBKm9YZhYiCqnfeTenfTDMZMaC+pZsQ6o=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=WpPuNRztwLis7Ap3zswejbhGwFZeItpQ7B3+WeyftZ/4IuriYtIOLDwU1m3p2uhXI96jgFR2pZ8Vt294CiMNnn9Vedm4Mu5N7bpjVDkJMwC/oOLxnfw2hc8YpI1xE7F+Zhmar7groGVQ+PrRQ6Qlu9ieKwE8oEI6Xq3c1bFbeEc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=eD+Lp+m8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="eD+Lp+m8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CE78AC4CEE0;
	Thu,  6 Mar 2025 12:03:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1741262583;
	bh=Sm7kxac7CKHBKm9YZhYiCqnfeTenfTDMZMaC+pZsQ6o=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=eD+Lp+m8kQYNfY2ewgxrXQf0QIVosYgqylyClb6EPTJObQIz/DSWeSulxqUOeWjAA
	 m91I2Ay3+vO9yVyAIw/vitSr/1Uef9YCXst2p8VZgUNNESBy2IZr4hSx9+SxbiBRJE
	 2BLe/wR0zgPK3hrU0wmJlDosa3m8vkIwjq21uk7t2kB+KCM681oiab6oAnz8pdd6iQ
	 zqbFXIlxNwWzb0E096hGliGYioPjKcWwtEXqzCC3v/7AX29oeXA70GqSK1VbuOlTQD
	 YD1l+qUoExfOtrJt5Xzx2ZHPjopVlPpUo6ZteGOd1CzpjgTfcXVbZxblGgovnGTp9w
	 sV/siPY4851sQ==
Message-ID: <cf893fad-7978-4290-9e86-93aeb5accbfb@kernel.org>
Date: Thu, 6 Mar 2025 13:03:00 +0100
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.13 100/157] arm64: hugetlb: Fix
 huge_ptep_get_and_clear() for non-present ptes
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
 Ryan Roberts <ryan.roberts@arm.com>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
 Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>
References: <20250305174505.268725418@linuxfoundation.org>
 <20250305174509.330888653@linuxfoundation.org>
 <ebf8b6fc-33b8-408b-aeac-96b8495753e6@kernel.org>
 <44400ac2-4c46-498c-a5d1-5a0441dd5571@kernel.org>
 <4d1cfbc1-0bae-4d3a-a3c5-fb3668b14ae6@arm.com>
 <2025030612-polio-handclasp-49f8@gregkh>
Content-Language: en-US
From: Jiri Slaby <jirislaby@kernel.org>
Autocrypt: addr=jirislaby@kernel.org; keydata=
 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
In-Reply-To: <2025030612-polio-handclasp-49f8@gregkh>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 06. 03. 25, 12:57, Greg Kroah-Hartman wrote:
> On Thu, Mar 06, 2025 at 11:49:15AM +0000, Ryan Roberts wrote:
>> On 06/03/2025 08:08, Jiri Slaby wrote:
>>> On 06. 03. 25, 9:07, Jiri Slaby wrote:
>>>> On 05. 03. 25, 18:48, Greg Kroah-Hartman wrote:
>>>>> 6.13-stable review patch.  If anyone has any objections, please let me know.
>>>>>
>>>>> ------------------
>>>>>
>>>>> From: Ryan Roberts <ryan.roberts@arm.com>
>>>>>
>>>>> commit 49c87f7677746f3c5bd16c81b23700bb6b88bfd4 upstream.
>>> ...
>>>>> @@ -401,13 +393,8 @@ pte_t huge_ptep_get_and_clear(struct mm_
>>>>>    {
>>>>>        int ncontig;
>>>>>        size_t pgsize;
>>>>> -    pte_t orig_pte = __ptep_get(ptep);
>>>>> -
>>>>> -    if (!pte_cont(orig_pte))
>>>>> -        return __ptep_get_and_clear(mm, addr, ptep);
>>>>> -
>>>>> -    ncontig = find_num_contig(mm, addr, ptep, &pgsize);
>>>>> +    ncontig = num_contig_ptes(sz, &pgsize);
>>>>
>>>>
>>>> This fails to build:
>>>>
>>>> /usr/bin/gcc-current/gcc (SUSE Linux) 14.2.1 20250220 [revision
>>>> 9ffecde121af883b60bbe60d00425036bc873048]
>>>> /usr/bin/aarch64-suse-linux-gcc (SUSE Linux) 14.2.1 20250220 [revision
>>>> 9ffecde121af883b60bbe60d00425036bc873048]
>>>> run_oldconfig.sh --check... PASS
>>>> Build...                    FAIL
>>>> + make -j48 -s -C /dev/shm/kbuild/linux.34170/current ARCH=arm64 HOSTCC=gcc
>>>> CROSS_COMPILE=aarch64-suse-linux- clean
>>>> arch/arm64/mm/hugetlbpage.c:397:35: error: 'sz' undeclared (first use in this
>>>> function); did you mean 's8'?
>>>>         |                                   s8
>>>> arch/arm64/mm/hugetlbpage.c:397:35: note: each undeclared identifier is
>>>> reported only once for each function it appears in
>>>> make[4]: *** [scripts/Makefile.build:197: arch/arm64/mm/hugetlbpage.o] Error 1
>>>
>>> It looks like the stable tree is missing this pre-req:
>>> commit 02410ac72ac3707936c07ede66e94360d0d65319
>>> Author: Ryan Roberts <ryan.roberts@arm.com>
>>> Date:   Wed Feb 26 12:06:51 2025 +0000
>>>
>>>      mm: hugetlb: Add huge page size param to huge_ptep_get_and_clear()
>>
>> Although this patch is marked for stable there was a conflict so it wasn't
>> applied. I'll try to get the backport done in the next few days.
> 
> I'll just drop this one now, can you send me the backports for both of
> these when they are ready?

FWIW, the series were three patches, not sure if later "101/157] arm64: 
hugetlb: Fix flush_hugetlb_tlb_range() invalidation level" is affected 
when either of the two discussed here is not present...

So perhaps drop both 100+101/157 for now?

thanks,
-- 
js
suse labs
