Received: from mail-io1-f54.google.com (mail-io1-f54.google.com [209.85.166.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A6B1610D
	for <patches@lists.linux.dev>; Thu,  3 Oct 2024 00:19:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727914783; cv=none; b=khBEO3xXfwaDPq07QVzB2c51Ht1MaaaRsL44k2Z1OUqZsBetObD2CX8F0tgLIrVFD2GZOA+g4Rpon184CS8wRDur7Noc0eLHcH7goAj4KvO14t35LRwgM5nBvzkx2qqRUhDdSsxOY3zxzmL0zztqgvZPj0I3I9o7vv/yvz+k0UI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727914783; c=relaxed/simple;
	bh=Wszt+FMi++6hAkyrUPopyYAKo6vWeeUQyn8iYz+ArJo=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Ys7+qB9+BPmuYz8ZN5SB9YnLaHh65jt5MBvO8t//N3DNTKD6SCnE8FOULTAPgPygyG0PjpSE8Vd/GzocArjfCHWiro9Y3CrtHvtcUwt0bUr9niOYMlr9tLbZ67oliyldrTRMcVtq1k+I/XjkbQzF0EjgWAeKTYKUcXDMLf6Q94A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CM1zQK0e; arc=none smtp.client-ip=209.85.166.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CM1zQK0e"
Received: by mail-io1-f54.google.com with SMTP id ca18e2360f4ac-82cf3286261so19360939f.0
        for <patches@lists.linux.dev>; Wed, 02 Oct 2024 17:19:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google; t=1727914781; x=1728519581; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=IZK8FupAz8NR+xEbyhnAVE8FI4jxUNfH0gQ1SYLGKug=;
        b=CM1zQK0ejP1Yn3eWtQY59Y/1kC9G9i4UtitYNeMGFi6pXz66m9o6wCugq8Xsl3I2Uj
         T5p6KkSlMS/sUaTaJlU7kdil5q40BaFEuaI3CN1gFga4rZkJmmWAaLtkE9SterR7nP2J
         d4vqzZYFFB9kC40FPGq4GWGnaE4rcWzq0DLr8=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1727914781; x=1728519581;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=IZK8FupAz8NR+xEbyhnAVE8FI4jxUNfH0gQ1SYLGKug=;
        b=VEuk1o7T+mJ271r9JoPSdtRjZfZta15VDho+y0ZggUJL2pFacdxTpuXHGrOJejGzBd
         +SjcKhICKI4t6UwQoQzZOqrf7fUHWvPyPk8ZXLsKpKZE7JdPvvPDNoJ0uJkw0/+3/uZW
         UBtgBGP7hyFgBPRdqM34bldCcBSfW0PN3u5rjbAAUvBsNCr5QuWsoaao1pctuolvOGfW
         p9GHUz9YDMRFlRou7j7p3UFI+YBs7Wdia4LMUrRr65A23K8rUMNZkh47+OJsEtrmWG7n
         SirnIK60zAzH84loZtos9ajWjifxKNZ88TYl4kisfLl4Roi3EmQFjEOqK42BIkTREKsS
         5tIQ==
X-Gm-Message-State: AOJu0YxGl7BEsvloV4aTClSmybKyFp41eg+vnpLIF0BQxO6qJJ3KPbA9
	qlp0gdwj+tYj9s9a0i1XyASa/7nU0Ce1isw6jUIiPk4kddwINvXDuEEwoOahUbA=
X-Google-Smtp-Source: AGHT+IFL3nQ2fqVzpy55jIhf/78rEtwqx8BMIhySGt4vVuWgB+Ao0LYLQfLrxbqIDU5Zgeai3OU+Iw==
X-Received: by 2002:a05:6e02:1525:b0:3a0:be93:e8d5 with SMTP id e9e14a558f8ab-3a36592a7abmr52563365ab.11.1727914780742;
        Wed, 02 Oct 2024 17:19:40 -0700 (PDT)
Received: from [192.168.1.128] ([38.175.170.29])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-4db5586134asm49602173.33.2024.10.02.17.19.39
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 02 Oct 2024 17:19:40 -0700 (PDT)
Message-ID: <199ba85c-afbc-41bb-af30-90e0b197aa84@linuxfoundation.org>
Date: Wed, 2 Oct 2024 18:19:39 -0600
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.10 000/634] 6.10.13-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org, allen.lkml@gmail.com, broonie@kernel.org,
 Shuah Khan <skhan@linuxfoundation.org>
References: <20241002125811.070689334@linuxfoundation.org>
Content-Language: en-US
From: Shuah Khan <skhan@linuxfoundation.org>
In-Reply-To: <20241002125811.070689334@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 10/2/24 06:51, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.10.13 release.
> There are 634 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 04 Oct 2024 12:56:13 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.10.13-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.10.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h
> 

Compiled and booted on my test system. No dmesg regressions.

Tested-by: Shuah Khan <skhan@linuxfoundation.org>

thanks,
-- Shuah
