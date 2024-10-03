Received: from mail-io1-f46.google.com (mail-io1-f46.google.com [209.85.166.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 788B338C
	for <patches@lists.linux.dev>; Thu,  3 Oct 2024 00:07:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727914045; cv=none; b=K8VqydrdXcO9hfHGWqSkPlG0nuUKmVueBp1s6rhRlloi1LuMuCK9ahVGX3ZOP/juaY43u4Xg9aQdQ75J3XGpsCxf5TaJ2g5lvgpGBg2SGVI9C7A7jswiNs4mX9p6zKiBP/hnV3IKpGNUw+NKjGNLHYrcoGKGP3W7mZt5XQbB9C4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727914045; c=relaxed/simple;
	bh=KbnyX+ke6vCrBQO7YCH7P70zqCNUK2YM+P2HzLj5PpA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=C21MtfUeXKgQukyqIi8arGLpGhlb+IoCxMevUo7is0yCG28Iyl0wUeh8LiRNZ6rFy31eW7B3BFxQDW/ESCBsgYH9fnROx50PwvVcBF/LsaJEPXeH33ZknLZr64XtZ25oRuy1TN4tjHcVY7Qpuuo/OXWcLaqhiwWJ9s99DFB9GDg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LTQMquat; arc=none smtp.client-ip=209.85.166.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LTQMquat"
Received: by mail-io1-f46.google.com with SMTP id ca18e2360f4ac-8349389f9b8so21387339f.0
        for <patches@lists.linux.dev>; Wed, 02 Oct 2024 17:07:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google; t=1727914042; x=1728518842; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=2ys1N4TFcbAfveAyNDv0d6+oCrQY2Yusy+lDeHbpoqc=;
        b=LTQMquatM0DRGY6tYB6CtnWqVY9rEv23QpL9Pt/DE8AHyzGHs7wAtwDPI8VweRUAw+
         OpIy0/yYvcea6stckGlcpkfmFYOUAo127xIcc6Hz7BYb1JNn0maKmD0oLFaFNgvBrXbn
         bJdtRENupmlDtEoWb1/Icbp6EhBY5/FNBy9ts=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1727914042; x=1728518842;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=2ys1N4TFcbAfveAyNDv0d6+oCrQY2Yusy+lDeHbpoqc=;
        b=TnE1KBidSNBbTO/aHAuPUwBhYrBXdxxJqjxz3CmgJ4BcmbgQojn+3T07WPGc1tTT/h
         Yw0lD64vm2cesGO6PoahfzWhO23M+WvlWTuLvOLfcI2datemlHIoJnG2S5sGYxXrjHAZ
         zKU7TJiOA/uhjRqDdh70KcWOxq1X1Gu4BRSsuSD4qTNzfaUCgVN1rSTj8E4yyHf3cilP
         s+d5fYIWI7rQyEm5kwZdIb9xt1rulC+ln7rOopnJ6iytG0vJLT/pBnP6qiJVSmrGJ82P
         StdE9ciFpkzEbLFCzx/CmFS87pRllvku395yQaHoU/YJ+52Qt96JSGpSK7MMnT4wurA/
         y7Qw==
X-Gm-Message-State: AOJu0YxZlJNapZATvfyqRzC/wzuO0ii7vsfVUyE5giuIXs3PatEqEBCn
	f0Np0GtPx9qV/wgJx7IH7h4fEJbAVPCFJ3z0hs/765jCsqLKiXiEHSHkKZlPqu0=
X-Google-Smtp-Source: AGHT+IETx/9SIddamSPDhDCVVZ1ODHhRsUEsQ4/pDsFSxBCTAfy/o2mUqa6femcwhdISZPK1VNCLAQ==
X-Received: by 2002:a05:6602:60cc:b0:82a:9cab:9be1 with SMTP id ca18e2360f4ac-834d84c847fmr408199239f.12.1727914042518;
        Wed, 02 Oct 2024 17:07:22 -0700 (PDT)
Received: from [192.168.1.128] ([38.175.170.29])
        by smtp.gmail.com with ESMTPSA id ca18e2360f4ac-834efe37c65sm1755839f.48.2024.10.02.17.07.21
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 02 Oct 2024 17:07:22 -0700 (PDT)
Message-ID: <a9f2e3c6-7e4e-4fbd-8a79-b3fc011412e2@linuxfoundation.org>
Date: Wed, 2 Oct 2024 18:07:20 -0600
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.6 000/538] 6.6.54-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org, allen.lkml@gmail.com, broonie@kernel.org,
 Shuah Khan <skhan@linuxfoundation.org>
References: <20241002125751.964700919@linuxfoundation.org>
 <e500ad8b-07d6-413e-8fc6-2a9afd5593de@linuxfoundation.org>
Content-Language: en-US
From: Shuah Khan <skhan@linuxfoundation.org>
In-Reply-To: <e500ad8b-07d6-413e-8fc6-2a9afd5593de@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 10/2/24 17:57, Shuah Khan wrote:
> On 10/2/24 06:53, Greg Kroah-Hartman wrote:
>> This is the start of the stable review cycle for the 6.6.54 release.
>> There are 538 patches in this series, all will be posted as a response
>> to this one.  If anyone has any issues with these being applied, please
>> let me know.
>>
>> Responses should be made by Fri, 04 Oct 2024 12:56:13 +0000.
>> Anything received after that time might be too late.
>>
>> The whole patch series can be found in one patch at:
>>     https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.6.54-rc1.gz
>> or in the git tree and branch at:
>>     git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.6.y
>> and the diffstat can be found below.
>>
>> thanks,
>>
>> greg k-h
>>
> 
> Compile failed on my system.
> 
> libbpf.c: In function ‘bpf_object__create_map’:
> libbpf.c:5215:50: error: ‘BPF_F_VTYPE_BTF_OBJ_FD’ undeclared (first use in this function)
>   5215 |                         create_attr.map_flags |= BPF_F_VTYPE_BTF_OBJ_FD;
>        |                                                  ^~~~~~~~~~~~~~~~~~~~~~
> libbpf.c:5215:50: note: each undeclared identifier is reported only once for each function it appears in
> 
> I think this is the commit. I am going to drop this and see
> if it compiles.
> 
>> Martin KaFai Lau <martin.lau@kernel.org>
>>      libbpf: Ensure undefined bpf_attr field stays 0
>>
> 

Sorry - not the above. Here is the one:

> Kui-Feng Lee <thinker.li@gmail.com>
>      libbpf: Find correct module BTFs for struct_ops maps and progs.

Upstream commit:
9e926acda0c2e ("libbpf: Find correct module BTFs for struct_ops maps and
  progs.)"
thanks,
-- Shuah

