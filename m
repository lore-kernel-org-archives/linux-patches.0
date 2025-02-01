Received: from mail-pl1-f179.google.com (mail-pl1-f179.google.com [209.85.214.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6688F17BA5
	for <patches@lists.linux.dev>; Sat,  1 Feb 2025 15:03:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738422219; cv=none; b=d7yZfMbvvoywxPqTNSHsI5Bcjrsrn+8MF8t1wTqxWo62P/Er59X5EwzBrgShsB7CAVJk72nof32HOkYpiNcsKO6BgIGERxntDb4rR0DdyJG+CRY+S5frPo4DgL8hNBBPRDLgFEZ8qHlzFq7PIDd3JCGm78+ELLPRfVPDZEVDMVo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738422219; c=relaxed/simple;
	bh=DD8VfW9o2r8rJEd+IEUqi9Z/ZvLmjHNSjQsGK6H25yQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=hoS7o0+wvJsF6VR9OyzeBMGl/kWMBD0gNUccutrEEZp6t16BWAVSGvQzOGxwnW5dmvbWRHnLkamnNQS32Zta1/vdPF/Z1MAdw2uTDixsU+K366mUD8FvEuKZjZtqrcajN8r4kFChRwGYErvGz9bFcbdtJD6U1ykqWO3CUj6Jhqw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=roeck-us.net; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=iMBsPIPh; arc=none smtp.client-ip=209.85.214.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=roeck-us.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="iMBsPIPh"
Received: by mail-pl1-f179.google.com with SMTP id d9443c01a7336-2162c0f6a39so72329265ad.0
        for <patches@lists.linux.dev>; Sat, 01 Feb 2025 07:03:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1738422217; x=1739027017; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:sender:from:to:cc:subject:date:message-id:reply-to;
        bh=ZcDmH7gsgEJWi12SQ0kBDnjX26Y8Vw0rc0aE3RRxPdg=;
        b=iMBsPIPhjIvGrmbdjBc7QiBOo/3NCK9/ZJhcSlhW88L/zhXbSEquQVyaA8MlAC3tA2
         1mqHAh4yg74Pk8EuC4iBVfWDnCWDICn7c4wIZ1itERsO4nxvIgtfhEgGuN1s5ILvSdHD
         6Ty/jcCDQxM6+yZh43ipDFLHA67VDP7NnH0+a2imU5fW+Vju9VS5E1gFPPcAQAUgZyok
         DVOp6ziCrIPBUuvsAmLkO5J6ebEaJwxZmwGa/JQriPqSoCDQ03dxNY6inYWhmbZ5yeab
         8H+VsxIxiznPcIMpwUL+wxMKvXNsn1Z+3BlaG4etjlDIZP3UWVs/4r2IVEn5YHcbDKEG
         gIKA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1738422217; x=1739027017;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:sender:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ZcDmH7gsgEJWi12SQ0kBDnjX26Y8Vw0rc0aE3RRxPdg=;
        b=KGOwO8c4KQBfw+128j+PYk0mTBLNXeBCCjkhygaSDkKiS2oFnpIZHUIC1N5iVl+oMB
         27Hj/rC1ypGSr1+cY/bhCTS8Df+nAuOkMtUZA6raR1K7hLNvhBxHHnRbNoBv/bVUz7lb
         BnfbIzbHq/d0kGA3xj92ga4mByB8z6dNClcxjwxI+YkCq2zot706xMkDFmfpWNqjw30o
         udlZ4MS1XEWgvtkJXEsYbBvlxo5FnR7+KMKQLsmckoFL46QiVB+BZUpd1KfcDEihpHO9
         WY8P8TmT60CFjCaUIKDP2c6VHhO3gKl1Zb5itVaybZP0/LrppPe1zZLu6AmDJqUdoooR
         I4xw==
X-Forwarded-Encrypted: i=1; AJvYcCXirsan68TRqqD20jPxahRyPPrS9m7S1UlY34DhcI4QusLMrMqW/tt6NrvdMGJq7rk+u8keEEBe@lists.linux.dev
X-Gm-Message-State: AOJu0YwUIN1hLgifh6YjblR83tyWr8N5HsR3wYOkg/zfEd87nCvC8XOt
	04HGRKwjCF2qn4DWuLMqHUmhfkWRY8vkpBPrUysymNhmAKCH1fck
X-Gm-Gg: ASbGncuVF4hNpPOo6bBnd/4z3p86BzHC8EI7msMlVYYVpDVlMpyEQsQHONBLQEk8+66
	85RqYS3eAjLmr/4+HewnDQmn+tjNliP90gZ9tGUjKxbCrJrly96wZ6/oBaUT174nAzcmJctBMcC
	Tnbj9/i5HV7ZvZm+Y/TfYqpZvuXyNWp2vb9VO5gLEtmaKLzXcNr8pdpz5e7FsfxI+LQ9arfxNy6
	OR8DWM9h5zh23mx7HFq36RgHE9vviHz/lTpIa20+dwgE/NUg33SsWFrxkALOi/+vP5irDddF5lJ
	+C3RZDBmdcZYg/g51iDCMlJhFP2ifPzZ96wX8wPYALjmhQFe76QDag0O+0jYYeHQ
X-Google-Smtp-Source: AGHT+IEpjID2jYrW+M0djm9cTXaixd9ZVxKsfEkWLxxcQOS0l8KbAiAORx/K/1W/vMG5l01POGI0Yw==
X-Received: by 2002:a05:6a21:1586:b0:1ed:a5f2:dba6 with SMTP id adf61e73a8af0-1eda5f2fe6dmr5899280637.14.1738422216727;
        Sat, 01 Feb 2025 07:03:36 -0800 (PST)
Received: from ?IPV6:2600:1700:e321:62f0:da43:aeff:fecc:bfd5? ([2600:1700:e321:62f0:da43:aeff:fecc:bfd5])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-acebea4005csm4160206a12.44.2025.02.01.07.03.34
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 01 Feb 2025 07:03:35 -0800 (PST)
Sender: Guenter Roeck <groeck7@gmail.com>
Message-ID: <cb1e9306-9c05-4a7e-914b-d5127a411ebe@roeck-us.net>
Date: Sat, 1 Feb 2025 07:03:33 -0800
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 5.4 00/94] 5.4.290-rc2 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
 Pavel Machek <pavel@denx.de>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
 linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
 akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, jonathanh@nvidia.com, f.fainelli@gmail.com,
 sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org
References: <20250131112114.030356568@linuxfoundation.org>
 <Z5zIZHIZxuHoymof@duo.ucw.cz> <2025020157-unsecured-map-aa0c@gregkh>
Content-Language: en-US
From: Guenter Roeck <linux@roeck-us.net>
Autocrypt: addr=linux@roeck-us.net; keydata=
 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
 mDW4+i+XlNFUPUYMrIKi9joBhu18ssf5i5Q=
In-Reply-To: <2025020157-unsecured-map-aa0c@gregkh>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 2/1/25 00:01, Greg Kroah-Hartman wrote:
...
> Anyway, are you all really caring about riscv on a 5.4.y kernel?  Last I
> checked, the riscv maintainers said not to even use that kernel for that
> architecture.  Do you all have real boards that care about this kernel
> tree that you are insisting on keeping alive?  Why not move them to a
> newer LTS kernel?
> 

Looking into the 5.4 release candidate, I see:

$ git log --oneline v5.4.289.. arch/riscv/
98d26e0254ff RISC-V: Don't enable all interrupts in trap_init()
574c5efceb70 riscv: prefix IRQ_ macro names with an RV_ namespace
c57ffe372502 riscv: Fix sleeping in invalid context in die()
98c62ee8bc75 riscv: Avoid enabling interrupts in die()
88cb873873ff RISC-V: Avoid dereferening NULL regs in die()
2a83ad25311e riscv: remove unused handle_exception symbol
8652d51931cc riscv: abstract out CSR names for supervisor vs machine mode

Why do you backport riscv patches to 5.4.y if you think they should not be
tested ? Shouldn't your question imply that there won't be any further
backports into 5.4.y for architecture(s) which are no longer supported
in that branch ?

Confused.

Guenter

