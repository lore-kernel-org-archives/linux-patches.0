Received: from mail-pl1-f170.google.com (mail-pl1-f170.google.com [209.85.214.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE1EE2E407
	for <patches@lists.linux.dev>; Thu, 18 Jan 2024 19:10:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705605040; cv=none; b=iPJXK2zoiMukhXpBtJTyMCHhdcSQvQFvEa+w76Xn+VNyATnySu4I0beqdb3kJQcd+kqBZSZYYsdVxDxUWaS8egCZllNp6e8x7t7+ujH4gD+8FVScJSPQJ0dmQ3sFnVE9qo4UNBV2LDB/tuAdNArqQwZLqQ6tftkhpCo+82PV1Yk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705605040; c=relaxed/simple;
	bh=QGy/gV3NdSFRk3x+356l/x+E2n1PrWJbsuTSzohNMVg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Wh1a3k2p3kDcQ4Pk8V1SkNNaOqyuhkx+INj0F6k4ZqwOtLPwCpucdwP8gko5n1iPlk/iG60wrKD3/EidcStlF1MKtLLSdWjk/YmkfR6YzFLm4hlY1HqZ7T70o96erPSI1J028Of2WjfZ5OlLkmMcLpT6FOjW1gQuzL1qdLroIHs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=KDLSOo7s; arc=none smtp.client-ip=209.85.214.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="KDLSOo7s"
Received: by mail-pl1-f170.google.com with SMTP id d9443c01a7336-1d714e224e0so4403135ad.2
        for <patches@lists.linux.dev>; Thu, 18 Jan 2024 11:10:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1705605038; x=1706209838; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=1v/TZYvh2MJ80QgyM922C9D8jEpr9cFLhd1cuq1fI6E=;
        b=KDLSOo7snakK+5Sb29ugWXziQ31U7+8dnKL8wVImNmRTADpHrhCKu6r4YQDwfG01Ap
         pklXHX6ueC+f7m96jPzW1jqzTBwmREwbOVRWcVcoW9nzEVRdx05OEJJHDbfuaofFRQ5S
         r9/XAK3EmR9zW0PPwo0w3KQlEt2skUj7nA4+3wCEGZfhDX97t/PelRZc2P3VduDFcJQo
         EUKgvCUXHZn3QB+EKHrnrNS0CR3Y9K8GUDAz/ecVKZ1ZbDHANz41jq2pOgvHAHdjFsHx
         q58zc4pBukVbMLbnwO7+jfFe5QXh1JTxG/guhM6uHpXsxuWhajU+5q//8Y27mo4nz/Qb
         YFPg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1705605038; x=1706209838;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=1v/TZYvh2MJ80QgyM922C9D8jEpr9cFLhd1cuq1fI6E=;
        b=QclVhaXiEnNjr/Eeh+bDExJoQqE1zu3GdSCoozgMmYS+mfu+MkUbOjrd5e3dS8H0V1
         qqBLAA/bLJxmtwnT2i0/TF73Z9gL+8IWeIVflL8GlFxOWDQpsO9arZiSNaB81Cn6MpOR
         XMRCJAqwHE2vsJfGq+7Mjj1gja2NGiZyrAF8vxwAAbQn9tsiSkRs19/QWTkXGcxowvGT
         VVUZO0UqCF2Z7SCq74jkWmx9hXpSJeLA06nbmHrWsLMWN4Ga16Z8bqF75Sd+lwzaBq9Z
         Emg3pBK8cAG4mveomTYK5kKoKG3ZRep9MFaC22TvRB8MVqcMuII/HAti2Gg1zPtwRiAK
         RbuA==
X-Gm-Message-State: AOJu0YylLkRpNCNPxRX199r4AfZOdcc2t9awZBiGlj2WyN7mcBxL9Pnh
	KTAs9jY32dstlZo51ElipCeUvdltqwKKXzU3/0pcwspr0ZuGHXfr
X-Google-Smtp-Source: AGHT+IH4Ocz9kjSah+mw055Dw5Myw+oA+YfyxXg4b3gE3cy9rSFukaLV5FVQ5ejGALvuuCDYVFztVg==
X-Received: by 2002:a17:902:ebc5:b0:1d6:fc43:6005 with SMTP id p5-20020a170902ebc500b001d6fc436005mr1824509plg.133.1705605038093;
        Thu, 18 Jan 2024 11:10:38 -0800 (PST)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id bi3-20020a170902bf0300b001d6fe15b563sm1704682plb.157.2024.01.18.11.10.34
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 18 Jan 2024 11:10:37 -0800 (PST)
Message-ID: <96dc2b0b-ad51-42f9-a305-744d9d97272e@gmail.com>
Date: Thu, 18 Jan 2024 11:10:31 -0800
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.1 000/100] 6.1.74-rc1 review
Content-Language: en-US
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
 Stefan Wiehler <stefan.wiehler@nokia.com>
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
 conor@kernel.org, allen.lkml@gmail.com
References: <20240118104310.892180084@linuxfoundation.org>
From: Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20240118104310.892180084@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

+Stefan,

On 1/18/24 02:48, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.1.74 release.
> There are 100 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 20 Jan 2024 10:42:49 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.1.74-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.1.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

ARM and ARM64 builds worked fine and passed tests, however BMIPS_GENERIC 
fails to build with:

arch/mips/kernel/smp.c: In function 'start_secondary':
arch/mips/kernel/smp.c:340:2: error: implicit declaration of function 
'rcutree_report_cpu_starting'; did you mean 'rcu_cpu_starting'? 
[-Werror=implicit-function-declaration]
   rcutree_report_cpu_starting(cpu);
   ^~~~~~~~~~~~~~~~~~~~~~~~~~~
   rcu_cpu_starting
cc1: all warnings being treated as errors
host-make[5]: *** [scripts/Makefile.build:250: arch/mips/kernel/smp.o] 
Error 1
host-make[4]: *** [scripts/Makefile.build:500: arch/mips/kernel] Error 2
host-make[3]: *** [scripts/Makefile.build:500: arch/mips] Error 2
host-make[3]: *** Waiting for unfinished jobs....

which is caused by 7c20a4cc189eff36d5aeb586008a540d8024fbff ("mips/smp: 
Call rcutree_report_cpu_starting() earlier").

It looks like rcutree_report_cpu_starting() has been introduced 
448e9f34d91d1a4799fdb06a93c2c24b34b6fd9d ("rcu: Standardize explicit 
CPU-hotplug calls") which is in v6.7.

For MIPS, it would like an adequate fix would be to 
's/rcutree_report_cpu_starting/rcu_cpu_starting/' for the 6.1 and 6.6 
branches.

Stefan, do you agree?
-- 
Florian

