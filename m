Received: from mail-io1-f45.google.com (mail-io1-f45.google.com [209.85.166.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9AF6A179BC
	for <patches@lists.linux.dev>; Thu, 20 Mar 2025 12:55:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742475311; cv=none; b=bKZWdEYT4M+OIcYGgQGtL47ag5AnJk4Cd9zIEVENyI7a01HQJPnO5IlG7meiId+kkPxED/sj9NS4zYcvtdqRjQ7u960hY14u5VB4QlA+iG/Ii6rQ8fY3+LtOw+tGvx5J+8tszZ+q4lBl1iGVCDme8Z6xsMXqdTQ7L16ZMYDy8no=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742475311; c=relaxed/simple;
	bh=zaGLhQEKaTi2oTxalubOkO7crjcho7RWd5O/NDqW5sI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=V6AzJmaEKcaXs4qQbOWHPo95ahLRlpytcydLrYJHFDuRYABNjNtuVs//9n+Qhe65oadClpjYPSVH1xDihwFKW4bR1ggAQmAtuShqGqKeFF2UVXGAr327GIUFSxO8DDDJJb0iKY02bnwu7ssfUTZvqmiTpsHI0nTiQNPBkeXtPMc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=N8qW1eNz; arc=none smtp.client-ip=209.85.166.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="N8qW1eNz"
Received: by mail-io1-f45.google.com with SMTP id ca18e2360f4ac-854a682d2b6so52640339f.0
        for <patches@lists.linux.dev>; Thu, 20 Mar 2025 05:55:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1742475309; x=1743080109; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=GOwMMS9hglRzxW3ezI0QinI0heUZsr03hz7ekDle39Y=;
        b=N8qW1eNztj0NjZM/v/1Un0b8JJ7Xk4PO8fOLHBPiLuuSG8292lMY8aCyzwsfrgR/IE
         Al0XVntixwHMB/rFHkNCWjeJowBPGJoEBn/1sSw9lq5Phob+VuwdAvQRt0amnTGD9K8S
         Z7Hfm79GrNFBoUKVVQPNMor7uwJyy1WJM+NjLI7h5+DMjyLUxstyLscC5e3E84eUR++2
         g/neB34qdEiSN6IVvb5dTPIoq8oYVUHIwjmKMU/BJHEsZAVfp6h0+n1Nn6naNVdS3FPN
         juP3DZ8aVOPmeioR3kWTPX2lznTwR9IaVtoMMWYtMsUAGRFUdbQ0z+KqK41jq27dSnYM
         LxpQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1742475309; x=1743080109;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=GOwMMS9hglRzxW3ezI0QinI0heUZsr03hz7ekDle39Y=;
        b=oKUxBI5NqrPU7ypDrN8Sa1jZJ1L7itlOcEwojssysl5Rc6mHiky0FZh4ie5P0eveHu
         eG5Xay1iRXw5Nky3OGkxhCC2iH5WyQCfQRqC83HP3iOUaA1YAMn8mq8Et3SQSWja3a+Z
         yZyA6Qo2zatH8xfY6QJcv+NyZ0ynV3ZcKRvhsZBi91Hg4mx6r0EPrm110G9ogmmNnBJR
         A39lX2FRqh+8qBH0IS5jpvx9wMmy6yi3cC5c+s2YHFmDSU5ra4iYj+W+jzhmKLuaVS3b
         FYxBlfWzddu7U+6WiQYy3/Bcckbd2csCHNYed/DvSPI1+gcG9CMir2x1LuWVqyr0TKxa
         3XOg==
X-Forwarded-Encrypted: i=1; AJvYcCWzKvlvyGGEpHUGjVegv/R+dmkIVHF/kbnAHi2LLUKORYmsney/kJhLCbWK6lonMqfhNS2qYikI@lists.linux.dev
X-Gm-Message-State: AOJu0YyrAOJAnoOx0Sprs1LCBXWAth9LVUIvRbvjFi5hRwxozO2/gh9e
	L0QR9vXCZp5PmnEpIUxt9Q2kobh25fSKkUdi+HkUwYXEhl1+TgwqI49SfgvRMJk=
X-Gm-Gg: ASbGncvypCES3uoTFOpgvtDy68xFk7Ezt3yOBYXakA8WIabgSpSteQmSlPI41axO0wX
	QbYzutTA8ZX7E31PwzNOFxJm4g9ZBLi5Q5Rs1XzqQhFnW1twH5jNsFURQGXeMTPO+KVnVpcQPxR
	zv+Fd3KPRHrrWRWlud6VAUec/5U0pF9QOI+Jx6aRBCK+LuiFHgB14lyXxbYq51Niu0MJ3+1Xibf
	oAnF436B37GFBj+62eN40t60kadJbbIM27vCz27blt4YyglVHxOIJMV4EOTiVML4jZ4gbYvX8xF
	3hFa1ZEiQzSGQuKU6IwP1EcnepRCsPCR6ad+mCVSQUMblrgWc447
X-Google-Smtp-Source: AGHT+IEON63IV/8wSGuratVRSV3sBgQWopW8fhTGMX30EPgngC5K3ox6n2FPHmHwhdzbBzI5XNq9aQ==
X-Received: by 2002:a05:6602:3791:b0:85e:1879:18df with SMTP id ca18e2360f4ac-85e1f4c058fmr390863839f.2.1742475308710;
        Thu, 20 Mar 2025 05:55:08 -0700 (PDT)
Received: from [192.168.1.150] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-4f2637fabd4sm3725628173.85.2025.03.20.05.55.07
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 20 Mar 2025 05:55:08 -0700 (PDT)
Message-ID: <3dc5b070-0837-4737-be78-ba846016c02e@kernel.dk>
Date: Thu, 20 Mar 2025 06:55:06 -0600
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.6 000/166] 6.6.84-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Naresh Kamboju <naresh.kamboju@linaro.org>, stable@vger.kernel.org,
 patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 Pavel Begunkov <asml.silence@gmail.com>,
 Anders Roxell <anders.roxell@linaro.org>,
 Dan Carpenter <dan.carpenter@linaro.org>, Arnd Bergmann <arnd@arndb.de>,
 io-uring@vger.kernel.org
References: <20250319143019.983527953@linuxfoundation.org>
 <CA+G9fYvM_riojtryOUb3UrYbtw6yUZTTnbP+_X96nJLCcWYwBA@mail.gmail.com>
 <2deb9e86-7ca8-4baf-8576-83dad1ea065f@kernel.dk>
 <2025031910-poking-crusher-b38f@gregkh>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <2025031910-poking-crusher-b38f@gregkh>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 3/19/25 5:51 PM, Greg Kroah-Hartman wrote:
> On Wed, Mar 19, 2025 at 10:37:20AM -0600, Jens Axboe wrote:
>> On 3/19/25 10:33 AM, Naresh Kamboju wrote:
>>> On Wed, 19 Mar 2025 at 20:09, Greg Kroah-Hartman
>>> <gregkh@linuxfoundation.org> wrote:
>>>>
>>>> This is the start of the stable review cycle for the 6.6.84 release.
>>>> There are 166 patches in this series, all will be posted as a response
>>>> to this one.  If anyone has any issues with these being applied, please
>>>> let me know.
>>>>
>>>> Responses should be made by Fri, 21 Mar 2025 14:29:55 +0000.
>>>> Anything received after that time might be too late.
>>>>
>>>> The whole patch series can be found in one patch at:
>>>>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.6.84-rc1.gz
>>>> or in the git tree and branch at:
>>>>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.6.y
>>>> and the diffstat can be found below.
>>>>
>>>> thanks,
>>>>
>>>> greg k-h
>>>
>>> Regressions on mips the rt305x_defconfig builds failed with gcc-12
>>> the stable-rc v6.6.83-167-gd16a828e7b09
>>>
>>> First seen on the v6.6.83-167-gd16a828e7b09
>>>  Good: v6.6.83
>>>  Bad: v6.6.83-167-gd16a828e7b09
>>>
>>> * mips, build
>>>   - gcc-12-rt305x_defconfig
>>>
>>> Regression Analysis:
>>>  - New regression? Yes
>>>  - Reproducibility? Yes
>>>
>>> Build regression: mips implicit declaration of function 'vunmap'
>>> Reported-by: Linux Kernel Functional Testing <lkft@linaro.org>
>>
>> Ah that's my fault, forgot to include the backport of:
>>
>> commit 62346c6cb28b043f2a6e95337d9081ec0b37b5f5
>> Author: Jens Axboe <axboe@kernel.dk>
>> Date:   Sat Mar 16 07:21:43 2024 -0600
>>
>>     mm: add nommu variant of vm_insert_pages()
>>
>> for 6.1-stable and 6.6-stable. Greg, can you just cherry pick that one?
>> It'll pick cleanly into both, should go before the io_uring mmap series
>> obviously.
>>
>> Sorry about that! I did have it in my local trees, but for some reason
>> forgot to include it in the sent in series.
> 
> Wait, this is already in the 6.6.y and 6.1.y queues, so this can't be
> the fix.  Was there a fixup for that commit somewhere else that I'm
> missing?

Huh indeed, guess I didn't mess up in the first place. What is going on
here indeed... Is that mips config NOMMU yet doesn't link in mm/nommu.o?

Checking, and no, it definitely has MMU=y in the config. Guess I
should've read the initial report more closely, it's simply missing the
vunmap definition. Adding linux/vmalloc.h to io_uring/io_uring.c should
fix it.

How do we want to deal with this?

diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index 058c89f72e8c..efa7849b82c1 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -70,6 +70,7 @@
 #include <linux/io_uring.h>
 #include <linux/audit.h>
 #include <linux/security.h>
+#include <linux/vmalloc.h>
 #include <asm/shmparam.h>
 
 #define CREATE_TRACE_POINTS

-- 
Jens Axboe
