Received: from mail-pj1-f52.google.com (mail-pj1-f52.google.com [209.85.216.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D8993AEF3B
	for <patches@lists.linux.dev>; Mon, 30 Mar 2026 08:54:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774860879; cv=none; b=hRJG0vZm8KlnxSWLQGJPvDocxugO8OrsJO76xWtZ5xkeo9r8OUwO8Hg2PXR8kuX2O7aNmj+BBtYZ3i4aETDeWdE4Jt76hAE2byvta05tbfRaeFRC8bY/HA0LXDDknBKAWonLf0bfFnRwa0w8tn7Hg6n59nQsW3KO5GOmWyV7r10=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774860879; c=relaxed/simple;
	bh=Ugxhy261d5LPgC7T7MePsjFfQZHYLP0vYZcrMZsEDbs=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=eouhZ3qFVKVCVhz2cTBLARMa8/oHaUjaBTgalG57MQtvk5/7r/vsQ8mL1BHQKO4PAdW3NnODyQYTD5kbyRRifQSahE4zIhuoz2fml5fRGkfCPyZqblGBYqeQ31+GS5QWIO34yqsHB53B8jaThHadjPhE0T8n6OtxIhOf3RHJcJw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=roeck-us.net; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=UBc8bGg4; arc=none smtp.client-ip=209.85.216.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=roeck-us.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="UBc8bGg4"
Received: by mail-pj1-f52.google.com with SMTP id 98e67ed59e1d1-35da9c0c007so586385a91.2
        for <patches@lists.linux.dev>; Mon, 30 Mar 2026 01:54:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1774860878; x=1775465678; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:sender:from:to:cc:subject:date:message-id:reply-to;
        bh=CmARyMKOG13A38nFYqx4oFCWcRDBB88m6E/5cb+gjjc=;
        b=UBc8bGg4oiqQ4mxyqo/wPC2nS3m1QCVaCdc7Jm24V33+AZFBpS+NF06USHHeN/dZ3q
         3DNzylX9pm9vE9Ki5jyAEI3stWCaZr9EH4WFPw5uxMXuXbMuAAKdQ30c4zupz5d89GO8
         hQ9Z90NomJu683SJ65ehTr/yJ05Ern9xUs+2RDTNCCbZS+7uh2mdtzpTmp3sq4qOfUTR
         XZDO//X3KgXGI9q2+zCBjmmDY4++yEtw0FIZS4GUHYuqbSQm+5TT0tSRMl1R8BPGF9MP
         YTLY8Z51nKOx1VcuuPHQR6rlyFUZEMFF+hiq/Y+iDbYK0Zj/RfCzBn5ipkHno1KOgrVh
         gmvg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774860878; x=1775465678;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:sender:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=CmARyMKOG13A38nFYqx4oFCWcRDBB88m6E/5cb+gjjc=;
        b=eVWDx2eSecyyAKfAS7uSPntOCorOBkYJfVsJOswO/mSCULnJTlYXK6rHwwZ06Loj1v
         xNkZKcPcYnL0hHa7p3BgNkKPOMFc7Ov0EXaRHRXVwSGrN0ObaqfGLNoDPes3pAq59TTT
         1pm4H56nJWxGn9V5J0bm3v5epqbxPa3I5BcnXRp+2rHtOVjVzMP4X47cC2sbUcuUvMKA
         p2e9Q3tkHHBq1iXChZLkQ2fjuWZ9sCe8qy1ateIBh4k0UAMFm8BmyAbjESUi0r5CrULl
         X7oB6+KqSgMDnloDNiEWVSed+bnIdHvUa62ePvtNAfhFGgz/Fah3QNduNbBYFpyqNBCR
         5wIg==
X-Gm-Message-State: AOJu0YzgnBTYpepw36IDjJ6Trk5CKirfe4Vk4vjXppokYygqgzhvn+S7
	nfxlW4J3n2Iy94zy6vqcjl1pnDcEVoXND4Zji1aB4nWqJj5e4LoX16yi
X-Gm-Gg: ATEYQzxV4jZKSz0W6wTLx5O9jU9Klg6IW45xx0hlN0tWRIYRI0GMXeWPbsOidKeGWKg
	g0pc4rGz7FRSUmyaSHsLn7yafyOm7y2PGTrhJ2/OeI5cFyr6B315xKl0Gpug686xa0wGoRkFsaL
	7shYxSa5KH7xbPvegVnyveKnMV0rKsU+j4w1j9rlBXOTCf8tQ9sbp6RfyccM0z5Bx7DyUjnhbIt
	uTDYuzsV4IykE5bTbnCLSdRvvEigfBfSDtHaJ5PHVw8rsqsmgo7TB5WMeH4c9gmW2PjYxKzLEFg
	CVUfXV9wWDolJk8PnOzBH7DKzE6bfbULqPifrECgOFba0aVblGXr97ckaxEIJPGi2LTEj8QBhIF
	w6pVMannrMqtzAIGVSfg3S90br0AWh0rL4a/rsatD5ZybA5UnCEp4ZyxNuw0Z8GfOMxvbqQRVWj
	CWHCcMn5+QJEhD/l38uJbe2q9W77i18aleJCf9p3jGHxDRwDde/GaDaX1foL95O4g97y2GzL+c
X-Received: by 2002:a17:902:cf0b:b0:2b0:708f:4dd7 with SMTP id d9443c01a7336-2b0cdcdd018mr118209755ad.38.1774860877949;
        Mon, 30 Mar 2026 01:54:37 -0700 (PDT)
Received: from ?IPV6:2600:1700:e321:62f0:da43:aeff:fecc:bfd5? ([2600:1700:e321:62f0:da43:aeff:fecc:bfd5])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2b242766396sm71853505ad.45.2026.03.30.01.54.36
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 30 Mar 2026 01:54:37 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Message-ID: <a2d19941-48cd-4993-ab17-7b578d7c99d5@roeck-us.net>
Date: Mon, 30 Mar 2026 01:54:35 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.18 000/212] 6.18.20-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org, shuah@kernel.org,
 patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@nabladev.com,
 jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
 rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 achill@achill.org, sr@sladewatkins.com
References: <20260323134503.770111826@linuxfoundation.org>
Content-Language: en-US
From: Guenter Roeck <linux@roeck-us.net>
Autocrypt: addr=linux@roeck-us.net; keydata=
 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
 np3900V20aS7eD9K8GTU0TGC1pyz6IVJwIE=
In-Reply-To: <20260323134503.770111826@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Hi,

On 3/23/26 06:43, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.18.20 release.
> There are 212 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 25 Mar 2026 13:44:33 +0000.
> Anything received after that time might be too late.
> 

um:defconfig has failed to build since v6.18.17.

Is there any interest in supporting it in this branch ? If so,
upstream commit aa7387e79a5c ("unwind_user/x86: Fix arch=um build")
might help, but I did not test it.

Thanks,
Guenter

---
Build reference: v6.18.20
Compiler version: x86_64-linux-gcc (GCC) 14.3.0
Assembler version: GNU assembler (GNU Binutils) 2.44

Building um:defconfig ... failed
--------------
Error log:
In file included from include/linux/unwind_user.h:6,
                  from include/linux/unwind_deferred.h:6,
                  from kernel/fork.c:108:
arch/x86/include/asm/unwind_user.h: In function 'unwind_user_word_size':
arch/x86/include/asm/unwind_user.h:23:17: error: 'struct pt_regs' has no member named 'flags'
    23 |         if (regs->flags & X86_VM_MASK)
       |                 ^~
arch/x86/include/asm/unwind_user.h:23:27: error: 'X86_VM_MASK' undeclared (first use in this function)
    23 |         if (regs->flags & X86_VM_MASK)
       |                           ^~~~~~~~~~~
arch/x86/include/asm/unwind_user.h:23:27: note: each undeclared identifier is reported only once for each function it appears in
arch/x86/include/asm/unwind_user.h:26:14: error: implicit declaration of function 'user_64bit_mode' [-Wimplicit-function-declaration]
    26 |         if (!user_64bit_mode(regs))
       |              ^~~~~~~~~~~~~~~
make[4]: *** [scripts/Makefile.build:287: kernel/fork.o] Error 1
make[4]: *** Waiting for unfinished jobs....
make[3]: *** [scripts/Makefile.build:544: kernel] Error 2
make[3]: *** Waiting for unfinished jobs....
make[2]: *** [Makefile:2021: .] Error 2
make[1]: *** [Makefile:248: __sub-make] Error 2
make: *** [Makefile:248: __sub-make] Error 2
--------------
