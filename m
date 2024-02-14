Received: from mail-lf1-f52.google.com (mail-lf1-f52.google.com [209.85.167.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 35E0E14AAE
	for <patches@lists.linux.dev>; Wed, 14 Feb 2024 09:59:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707904758; cv=none; b=lK1OWfHpo4VuGPmwb6LPKY/foz4QP54oJPzFpLyGapwxeuywBsV28h5ePObDwLF2DA6s1kOtHpMNOdVtXK4Qe94PmbjUQpaLvEWARvGwjIzY45OSyEH3X8iVQbIa7x3izwU1OgZYzupXeuj8/ZoKFNBDF90XdJpVDAulvKlVaco=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707904758; c=relaxed/simple;
	bh=VnEUWRXGaPgNSaGUrsKL0EJs8YHUhxjTRFs9/E8YI/A=;
	h=Message-ID:Date:MIME-Version:Subject:From:To:Cc:References:
	 In-Reply-To:Content-Type; b=Bsf9S0vP3srMpHHAkTGyakF/qIGIeCJAtoYFxSRh8JVtaCqT4jjNFceOFnAMwHujoxWn3UFj+loUWi8GistGQEbmZN0kTqD93IlHuxVUvKDgVnRy79QLRfvwnN24ZK3suCcYBzuS8UXkHogrK1dWACLQmYzBxboG4ZGt5rwzUM4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org; spf=pass smtp.mailfrom=gmail.com; arc=none smtp.client-ip=209.85.167.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-lf1-f52.google.com with SMTP id 2adb3069b0e04-5114fa38434so5864782e87.0
        for <patches@lists.linux.dev>; Wed, 14 Feb 2024 01:59:15 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1707904754; x=1708509554;
        h=content-transfer-encoding:in-reply-to:autocrypt:references:cc:to
         :from:content-language:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=WaFHEeyeS1XZOCMrcTof86cHftgnje7up7NCsuYoxG8=;
        b=T7Sqt50TMob57xBW/Cd4ybg+a+OBNBQfDWnpqvq0vwZxKxqIDr4AdG+4FEWK0+hwkr
         wt05VFQHXyFxwHATLcevF+0GE/sIHCKzRo1eXS8ZyGXkSk0ZIcfwVdzv653AWjqm0rES
         nst5VyJ/URUG1h70h6T7vCLpdylSzvZyCyrerVlkuIhq5ygE1aYe+D3SzlPfZKXpasUx
         KCJGwQGRpqrtqVSJBtQ010WJD9ltmvyAywnCeC2oOYtWIhvGun+yjrQYYbWZXS4cZWqr
         mDWQw1+IApevSc/rHgqJYGg5yCRAV8gFD/hai96ZmUCZj36dazVQIIp8EM1ib8IKpdtC
         zLWA==
X-Gm-Message-State: AOJu0Yw85vajUoVDKWicd7T6R1Q+0XuDjo4JPQ4jNXsIHGCqVkEkNHGP
	wiDnb7u/VRmP1vm9pFhU47ZdwpayHYDJT592ZFT5cXkttPxPmqmA
X-Google-Smtp-Source: AGHT+IGTXh1mVPjrPC6MYzskZYL5NtEQTr45Im2c3fSW4slXmML3bT/KJ+S5KbYLDzj4FM/7UAQOqA==
X-Received: by 2002:ac2:48b9:0:b0:511:82c3:bc58 with SMTP id u25-20020ac248b9000000b0051182c3bc58mr1563459lfg.3.1707904754144;
        Wed, 14 Feb 2024 01:59:14 -0800 (PST)
X-Forwarded-Encrypted: i=1; AJvYcCUwc+ukZhGvsiAb8khYqUzu3YBC+xj6ovXqz+pHakIIlI7g1hdwIneWXuEjxII7mJW1VBB+MHQboLG239T0bJ61jCDpI+pAXmNDA3T0G8d/Rpczrh7sUCOwdBVQSo44nSCi5UlbI2P5Tsy7yiSwmB02S+4hvPqRuCoFGPycPaOw6AEpoWA0U+jKoGG3lfQwWjoV4P7dMUmov+vX
Received: from ?IPV6:2a0b:e7c0:0:107::aaaa:59? ([2a0b:e7c0:0:107::aaaa:59])
        by smtp.gmail.com with ESMTPSA id vi4-20020a170907d40400b00a3d61775382sm84271ejc.0.2024.02.14.01.59.13
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 14 Feb 2024 01:59:13 -0800 (PST)
Message-ID: <75751649-d6b8-467e-ae52-59a6740d6145@kernel.org>
Date: Wed, 14 Feb 2024 10:59:12 +0100
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.7 073/124] mm: Introduce flush_cache_vmap_early()
Content-Language: en-US
From: Jiri Slaby <jirislaby@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, Alexandre Ghiti <alexghiti@rivosinc.com>,
 Geert Uytterhoeven <geert@linux-m68k.org>, Dennis Zhou <dennis@kernel.org>,
 Sasha Levin <sashal@kernel.org>
References: <20240213171853.722912593@linuxfoundation.org>
 <20240213171855.870608761@linuxfoundation.org>
 <04565cd3-c6ee-4678-af6e-a00fa6d415d4@kernel.org>
Autocrypt: addr=jirislaby@kernel.org; keydata=
 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
In-Reply-To: <04565cd3-c6ee-4678-af6e-a00fa6d415d4@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 14. 02. 24, 10:04, Jiri Slaby wrote:
> On 13. 02. 24, 18:21, Greg Kroah-Hartman wrote:
>> 6.7-stable review patch.  If anyone has any objections, please let me 
>> know.
>>
>> ------------------
>>
>> From: Alexandre Ghiti <alexghiti@rivosinc.com>
>>
>> [ Upstream commit 7a92fc8b4d20680e4c20289a670d8fca2d1f2c1b ]
>>
>> The pcpu setup when using the page allocator sets up a new vmalloc
>> mapping very early in the boot process, so early that it cannot use the
>> flush_cache_vmap() function which may depend on structures not yet
>> initialized (for example in riscv, we currently send an IPI to flush
>> other cpus TLB).
> ...
>> --- a/arch/riscv/mm/tlbflush.c
>> +++ b/arch/riscv/mm/tlbflush.c
>> @@ -66,6 +66,11 @@ static inline void 
>> local_flush_tlb_range_asid(unsigned long start,
>>           local_flush_tlb_range_threshold_asid(start, size, stride, 
>> asid);
>>   }
>> +void local_flush_tlb_kernel_range(unsigned long start, unsigned long 
>> end)
>> +{
>> +    local_flush_tlb_range_asid(start, end, PAGE_SIZE, 
>> FLUSH_TLB_NO_ASID);
> 
> This apparently requires also:
> commit ebd4acc0cbeae9efea15993b11b05bd32942f3f0
> Author: Alexandre Ghiti <alexghiti@rivosinc.com>
> Date:   Tue Jan 23 14:27:30 2024 +0100
> 
>      riscv: Fix wrong size passed to local_flush_tlb_range_asid()

Ah,

the very same fix is contained in 074 as:
commit d9807d60c145836043ffa602328ea1d66dc458b1
Author: Vincent Chen <vincent.chen@sifive.com>
Date:   Wed Jan 17 22:03:33 2024 +0800

     riscv: mm: execute local TLB flush after populating vmemmap


So ebd4acc0c above is redundant (nothing is needed to be done here).

sorry for the noise,
-- 
js
suse labs

