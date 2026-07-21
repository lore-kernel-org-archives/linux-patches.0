Received: from mail-yx1-f41.google.com (mail-yx1-f41.google.com [74.125.224.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9FB4034F279
	for <patches@lists.linux.dev>; Tue, 21 Jul 2026 17:03:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.224.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784653409; cv=none; b=fFUtIEoyfoYiQE0Uyj9ihfsVEJGxpO0+RPoZ3G+RsZCXmvE+2lX13K2cBJHTHrNkxT4WG30Bjyx1yDlmaRGD+oriGyHwFSV3DedqAU4mndpejc3s+TzMw95QI9DjkpjFS77hixhZuMEd+aBkiKv1xQupI+mRjTHcysre1WBNQVI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784653409; c=relaxed/simple;
	bh=lurmzPoLJrWOsUKkVpyMjP3Qj2JTzkzYcplq6TTBFug=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=s2CSlQ3Hj69TcXVilpMNcxLEnQqm39MLkaDqKagilu50OC3Z/fVy8OQTDfjYoifpwiJIVi1RJ5w3RCizB7Vx5fDDRXLyBKLlbJhvw3uvKV5fGI3RVudFJpJUIzgEWm6bm7u2TeYAp/0EDkoBM0YZIjKZOUehk46UH5RsDY0/Zvc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=XXurtqvI; arc=none smtp.client-ip=74.125.224.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="XXurtqvI"
Received: by mail-yx1-f41.google.com with SMTP id 956f58d0204a3-66771ded50aso15004624d50.1
        for <patches@lists.linux.dev>; Tue, 21 Jul 2026 10:03:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1784653406; x=1785258206; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=IgQDEa5QCTugxYPUBMFU3uD0FXt+JeXLzmMnYYBodTM=;
        b=XXurtqvIcaDX+Xf+OTB0ZvMsHtTWKu8vh6C/MMMCetvxKMwxHAwnH5O9XgfuTUJHlW
         J2I8BWwTxIRTWrO/24KEpifg7ZvhZbCnBZEibNXarbeSp9fSJ4NFNw1u0+8Yb5Ha/8pG
         45IYhw35J81PPQmCdh5duTuGWI1b8Nr6xOPlmjT0IvoKj17b+Q3F1+IRY3OaPZT2+hmM
         +OP1QcYANAtKfqaPozbygtsOOcNV35B2HBdjC5JL3RsZ4z0kYs7z689yUJwjtfQferDu
         RTL+n26i+adqZo/GQF+Dcx7IYh53E8Q7pqWDj4TtD7yL216JWytzXezJptR5Hfq/6dhz
         tmog==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784653406; x=1785258206;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=IgQDEa5QCTugxYPUBMFU3uD0FXt+JeXLzmMnYYBodTM=;
        b=fBV1JqdB83YWKXTgGGFLUR6DN7lS6velz6JxKkX/GIBVNcIIqpXmc8w0kQE5Ucu6DF
         o5ZZNxGUyLV67aucY2ABsI0nDfDaEjYS0W/N0/ZZSwWrIvgyap5NflJ3qTB1fvmSjXCD
         1Ww6OusZ2ufurWejAfW7UmUdmT3PqIM464VKJajos62s1mr9r6PRP5n2usf4SkiI0AXU
         XaVXoSxuicoDvMqSl4iUpRckbLTUMOwItZWuhK/UeJLSgGMxjz1TTaF+pcyq3f/SHHjG
         dCIh7r+HGNEHefecKpJMrD0Wt4YrV7S1QV/qyPzbh82UaCIBB+6gUWhibjSU0u7huioM
         65yA==
X-Gm-Message-State: AOJu0YyPU21DG8hHJG7bqONJl39qvAHdSm2O7erQCsDOxmfzkSwlDBCS
	giPq7Xzqjq5HoO92cXpXfvxk0nD3HxAnMlsVmwKAWqeNd6D5+uZ0rUt6
X-Gm-Gg: AR+sD11ZlYH5UMow1zkZJsTU2P4FSH3LUElor3b3Fq0c8betfpJyO9WBGMbsqho/jPv
	l6RDwIzGmH4gXvD5Penbo2eUP0BXpBoGGaHtM8HccYU2opKP98wxW1OWcRPxTtXMd8lgA9aWTRK
	j9PJwbzlGMiHXOW0tzv6Q1RCDdjcojaRKCalhwWgn5VMgGI8C876etPzZYVxZ0+hpRovynXGX5P
	syofqqeWj3CAWJwMsUitmobWoYhzc1zIYPIgBCqhRcjrk9K0ZboGxKLjLqz4uo08HnQqoyjpyhs
	O1LUkKwRurr2Y9UCBhmrhsmFnWNcGu+BSfGhBJl59JJ4lI5v2Sp4KnDF+iEzJImneZW9FDAdBkR
	bGdXQOypkCgExCrULZenzOm3Cj/eW1+DR2YrESaYmYmJLGfDDLaypFQ3QlZ4tDDBA06VahbnI65
	nm5ulsgcudJC4665iWiWTEjJivpe+e
X-Received: by 2002:a53:edcc:0:b0:667:b503:4d2e with SMTP id 956f58d0204a3-6683bb0bb22mr4168069d50.37.1784653406212;
        Tue, 21 Jul 2026 10:03:26 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id 956f58d0204a3-6683b880cc3sm7342186d50.17.2026.07.21.10.03.23
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 21 Jul 2026 10:03:25 -0700 (PDT)
Message-ID: <0a509c62-850a-4d42-b484-0ef13401b663@gmail.com>
Date: Tue, 21 Jul 2026 10:03:22 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.1 0000/1067] 6.1.178-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, rwarsow@gmx.de, conor@kernel.org,
 hargar@microsoft.com, broonie@kernel.org, achill@achill.org,
 sr@sladewatkins.com
References: <20260721152424.521567757@linuxfoundation.org>
Content-Language: en-US, fr-FR
From: Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20260721152424.521567757@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 7/21/26 08:10, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.1.178 release.
> There are 1067 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 23 Jul 2026 15:23:00 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.1.178-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.1.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

perf also fails to build with:

In file included from builtin-sched.c:28:
builtin-sched.c: In function 'latency_switch_event':
builtin-sched.c:1182:34: error: 'struct perf_sample' has no member named 
'file_offset'
  1182 |                            sample->file_offset, cpu);
       |                                  ^~
util/debug.h:24:44: note: in definition of macro 'pr_warning'
    24 |         eprintf(0, verbose, pr_fmt(fmt), ##__VA_ARGS__)
       |                                            ^~~~~~~~~~~
builtin-sched.c: In function 'latency_runtime_event':
builtin-sched.c:1260:34: error: 'struct perf_sample' has no member named 
'file_offset'
  1260 |                            sample->file_offset, cpu);
       |                                  ^~
util/debug.h:24:44: note: in definition of macro 'pr_warning'
    24 |         eprintf(0, verbose, pr_fmt(fmt), ##__VA_ARGS__)
       |                                            ^~~~~~~~~~~
builtin-sched.c: In function 'map_switch_event':
builtin-sched.c:1622:34: error: 'struct perf_sample' has no member named 
'file_offset'
  1622 |                            sample->file_offset, this_cpu.cpu);
       |                                  ^~
util/debug.h:24:44: note: in definition of macro 'pr_warning'
    24 |         eprintf(0, verbose, pr_fmt(fmt), ##__VA_ARGS__)
       |                                            ^~~~~~~~~~~
make[5]: *** 
[/local/users/fainelli/buildroot/output/arm/build/linux-custom/tools/build/Makefile.build:96: 
/local/users/fainelli/buildroot/output/arm/build/linux-custom/tools/perf/builtin-sched.o] 
Error 1

It looks like we need to backport 7a490187f22b ("perf sample: Add 
file_offset field to struct perf_sample") and pay attention to struct 
perf_sample being defined in tools/perf/util/event.h in this older 
kernel version, whereas the upstream commit modifies 
tools/perf/util/sample.h (which was introduced later).
-- 
Florian
