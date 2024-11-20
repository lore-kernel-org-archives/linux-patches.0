Received: from mail-il1-f178.google.com (mail-il1-f178.google.com [209.85.166.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 410881BBBF8
	for <patches@lists.linux.dev>; Wed, 20 Nov 2024 23:20:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732144816; cv=none; b=dHA15vg1hS261w1fBJmI4/j6CjLN8dd8fz0vKKPJr9wIJFChTBiuIPWwWuxuLrrK2ojmStjOP92BLTClioWhdeGXy9wQX67ilxyD8edcjZDeS+TWt1n4IFROA/5YvDMFenJOgWsfgtsSmxSgMOXCOSzj++aWu1tuDeWYtKrwP8o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732144816; c=relaxed/simple;
	bh=jI4SLcBURQUIVjCq9OmPkKskQ+oV7R1slDut6JAMdUI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=rcynmKM6Kk1mZ6N+YBkSd/LRN756osE0PJOBXDWlPQPIBqcIeQBq6hWHGa2NSQnsobyII1FTM/zjEwRFdwiMORP4HoBk4yun7UhYlbJuvbwJNQqI0O7yjRDpiICWmzBnqYmnp5TKkFnnnr931kgeyD74SZvCVWPxn2KhxNw5Lzw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bxHgrteL; arc=none smtp.client-ip=209.85.166.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bxHgrteL"
Received: by mail-il1-f178.google.com with SMTP id e9e14a558f8ab-3a7750318a2so897785ab.2
        for <patches@lists.linux.dev>; Wed, 20 Nov 2024 15:20:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google; t=1732144814; x=1732749614; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=x8xHzRHGzi5IfxFH+OvUgtLCMdNgx5N5MbYr0Qa4lIc=;
        b=bxHgrteLb6JyKNqxsYEp7Prgv3nnQiiqxKp4zXOQHFyI9k2t0OJHb47mB/fFEpafuU
         RrA3bT4/EL2U8uoQM/nGOA0/2vQvIUeJj0MIBH0ZRXH/e7fi+Hz3dV8oaGWc2p2W7KDl
         DZbyY+X4xbDDkTg/GlGjdAr56xf34pqcYwxdM=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1732144814; x=1732749614;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=x8xHzRHGzi5IfxFH+OvUgtLCMdNgx5N5MbYr0Qa4lIc=;
        b=ru/2Aw381peH+0uMNIwkY1OSFo0qRhbzBnZKpU5snv3wYteWqoFzyemDccT8mA/ref
         Oyu8AZmfYTMZGlMun3Tytnj32d7xsSxeiw18evhHoEsUPP/ktC3VqHv5EWcNAcrZFDtU
         g31pgSU5TaIprV7uKYuGllho+4v9+gRyhWvMBpKAijZQWTKMYQubhpMA2ZDHe3/ghPbt
         at52MNcT9SaZ8z2mp/C1vmqnCztz/47+pJBqV9C/6G265leWAHt61Gm5d5JLPjBmTIo1
         Xpe8cCfcaIiJoEFCX0vDixUIYxVJgJbey4lxTkSYBVKV5yp7nPXCOJ36nbxr5Fc7aDEC
         jM7g==
X-Gm-Message-State: AOJu0YyGnP+wS8CwP2vPbQj9n6qRtuxced037dpmiVFoyzMYKZJrwNAj
	NyW4Szz6TYuT4H9z3toew+R8bqrQtP06ZI/S3nz0FAyRTsfyqr6dLEiMTrJ3f9U=
X-Google-Smtp-Source: AGHT+IGLUc+IIYiZvfXusLHHAf1JPdTjyjFweeMLIA2azNgB7h1pYfNPCmSUCryRIBxpqnB9hzFEzg==
X-Received: by 2002:a92:c24d:0:b0:3a7:776e:93fb with SMTP id e9e14a558f8ab-3a7864a9067mr60036555ab.8.1732144814408;
        Wed, 20 Nov 2024 15:20:14 -0800 (PST)
Received: from [192.168.1.128] ([38.175.170.29])
        by smtp.gmail.com with ESMTPSA id e9e14a558f8ab-3a74807dba4sm33826665ab.29.2024.11.20.15.20.13
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 20 Nov 2024 15:20:13 -0800 (PST)
Message-ID: <bba15d36-e82f-4d78-912f-fe12d2d6f179@linuxfoundation.org>
Date: Wed, 20 Nov 2024 16:20:12 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.11 000/107] 6.11.10-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 Shuah Khan <skhan@linuxfoundation.org>
References: <20241120125629.681745345@linuxfoundation.org>
Content-Language: en-US
From: Shuah Khan <skhan@linuxfoundation.org>
In-Reply-To: <20241120125629.681745345@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 11/20/24 05:55, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.11.10 release.
> There are 107 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 22 Nov 2024 12:56:14 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.11.10-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.11.y
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
