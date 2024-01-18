Received: from mail-pf1-f169.google.com (mail-pf1-f169.google.com [209.85.210.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E5412E3F8
	for <patches@lists.linux.dev>; Thu, 18 Jan 2024 19:22:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705605730; cv=none; b=akCW7J4QefFjI+078a5C9nUkseDREiv/BNm9ujCBHFSFXz0kRRpfYctYEzR6H/E7mNW0Kde04qsb3QnNcfOAv6etu8lRA9ftj8fLgdjpAGa/FtWUTpluPk/02QaBB9wNS0jKj6mKQw3RvXDbMLjR9jL3u6gozMxqdz7C65/G8/w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705605730; c=relaxed/simple;
	bh=SrRbwpTDfXLX2j/Mn2Wvk81ST3LhR6HY3Tnc+uJKbl8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=m4juosE3gtxEKC6nE+HaXpxSSN1qbAwgN0erluDTkaJ0tWmCMtkM5+yoUjaKcV83kpQc5NgxMBNQw5/ORu9Qge6CxB3IZ+2l7qmqNRu+bS0Hk/LuA4uKO3BuD9UXUqNeQKVYn12/CSIRLy8Wx2wAs9ichrzdnPYEoQ8wOVItHbc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=C99bTetD; arc=none smtp.client-ip=209.85.210.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="C99bTetD"
Received: by mail-pf1-f169.google.com with SMTP id d2e1a72fcca58-6d99980b2e0so38052b3a.2
        for <patches@lists.linux.dev>; Thu, 18 Jan 2024 11:22:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1705605729; x=1706210529; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=eIZHdTR71za9DIyPMIvJQ62OJfFj0JIbKk8OksEAc1U=;
        b=C99bTetD24rPJo59mVQkC9x9MjZLoyA50JUgQNlOxhAM3kyuBfD1MnAkcaHaVIIhuS
         fichSZKfpV0gHnCXtMdXYNAdfWDCCPInuDrpJlivwcG70voCkZxZbrB+aGL7o9us8o5z
         y0cqiFGTANpJ2VeccOoW7ja/dN9yhGe8K1ZlNtIVzTZhsI+U60q/gho2gyNHXRUSsWpw
         1N/RJlf3pOEDYegskbIHI+CqNZ/TYFHijLygBYsipA7SLkbLHrsbiWEEtHoFHuUTIZPA
         iTBL7BuNrypWkSgDuI1EE40iV9NCMmaCinPkaqv3NTeYmrLV5QgKLTWrXnmBNIoPuXbh
         uoAA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1705605729; x=1706210529;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=eIZHdTR71za9DIyPMIvJQ62OJfFj0JIbKk8OksEAc1U=;
        b=Zftg1lVA8u51pZmoXcQHvLZA894tyTZmhgIgUOUSGkfLZjKgkXSWHf2pY/O2IXCqrV
         jt5dxrxQ6yQyUEpJW0+nj4edaoxSvjBTc/4hohmWgy7KtJ2UvVIsPBEsytxT6D898ez5
         hj7+UpY0QdYynTGlvTee/iNEJUpLAbkYBbwF8TgavV0mSeaJI6QPyyT0/9EFlqlJzqxO
         /16zSoAjwZd7Xxuiph9gFJqub5cQJzdoTR65tNqKi70c2Z5kHz0c0SPZlkIxqa5nxniz
         dwWuxnbpmgyN0C0Y8mTz/CmBQuIsWDzJtmIfqpSoaqyggEo56wiyDWNHMTUopDhByDHj
         k09w==
X-Gm-Message-State: AOJu0Yy2AXNyY/VG+QZumabFO9eiCiKzQdL0g3GC2JVCHJupPTk5UofX
	oBAkt4LrLmra6vvBBhZVks91yj0UVlRIKQqhmw3EyC0nv2/FhuCo
X-Google-Smtp-Source: AGHT+IEIR0jISgGDTiNiveync7yB2yYqyPiTmLy8ZnhSieBLfY6BPqzjwTrK+ZaiFHELMp5FPh8s/w==
X-Received: by 2002:a05:6a00:2d25:b0:6d9:bf35:768f with SMTP id fa37-20020a056a002d2500b006d9bf35768fmr1492354pfb.46.1705605728757;
        Thu, 18 Jan 2024 11:22:08 -0800 (PST)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id n24-20020aa78a58000000b006d95b565418sm3643211pfa.153.2024.01.18.11.22.04
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 18 Jan 2024 11:22:08 -0800 (PST)
Message-ID: <ab9bef24-a07b-4930-b09a-b3c0f4e04789@gmail.com>
Date: Thu, 18 Jan 2024 11:22:03 -0800
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.6 000/150] 6.6.13-rc1 review
Content-Language: en-US
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
 conor@kernel.org, allen.lkml@gmail.com
References: <20240118104320.029537060@linuxfoundation.org>
From: Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20240118104320.029537060@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 1/18/24 02:47, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.6.13 release.
> There are 150 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 20 Jan 2024 10:42:49 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.6.13-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.6.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

Same as with 6.1:

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

which is caused by 1fa03a4622bb26a31279a453aa251154f11e6c70 ("mips/smp: 
Call rcutree_report_cpu_starting() earlier").

It looks like rcutree_report_cpu_starting() has been introduced 
448e9f34d91d1a4799fdb06a93c2c24b34b6fd9d ("rcu: Standardize explicit 
CPU-hotplug calls") which is in v6.7.

For MIPS, it would like an adequate fix would be to 
's/rcutree_report_cpu_starting/rcu_cpu_starting/' for the 6.1 and 6.6 
branches.
-- 
Florian

