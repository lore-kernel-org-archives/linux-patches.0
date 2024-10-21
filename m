Received: from mail-io1-f54.google.com (mail-io1-f54.google.com [209.85.166.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F76F1E0DE9
	for <patches@lists.linux.dev>; Mon, 21 Oct 2024 22:41:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729550490; cv=none; b=UqF9lyzVurRV2imMfjzON75CnyJCpJcwEBakXKDXX+xCsAdIP09UWM0NXD5kEzA4RPa65zKP/aALHbf8PSs6cTTYy7LEJ5M58HSgcGPxHtC3Ywuu24zsSukUkr6+Myv7Y2Y2PGixwh5OuIghhYDsgtTPEHV8O8TK+eCwLP8JMEs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729550490; c=relaxed/simple;
	bh=PsPPiiDCrhoSB3wsRMZs3K+SlDE82UI3Dva8qJIqSHA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=aTAV5BKtJFA0DwPOnrhq417p3MdFdnTt4LoO0fcEmi4p8qOSrMRZOla9t5aEqRVLvHth3m72x+eLryf+wJEIR+13tUuJ3QJKeTU6qmMhJOxQ2fgdbnXnoC0ZpqM8o1U6MbtOJwoSPXPVCyEbExpzqzVcxWx6i1wxNuu9g90i7qU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GD4AyzDZ; arc=none smtp.client-ip=209.85.166.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GD4AyzDZ"
Received: by mail-io1-f54.google.com with SMTP id ca18e2360f4ac-83ab5b4b048so175969039f.2
        for <patches@lists.linux.dev>; Mon, 21 Oct 2024 15:41:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google; t=1729550488; x=1730155288; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=l8AuINN/VlI7pACZM3YzjmWIoSWBhMxFLVtFg1hkHIQ=;
        b=GD4AyzDZzfavIJ4CL92yOe42Z4Z/lhPIam+G2zj5eUQoZaOI4Y/gcW+tgal/XoN/om
         nbQjVnR3+ZGuQOAZnVY4+g+xQrI53s3O7QPRs8Yi0SZjZMDAdTOI/8vv4dL57++ErVso
         1Mqs6lMf2H+mIXs8xXGgM0si3HoAcMeqvisj8=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1729550488; x=1730155288;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=l8AuINN/VlI7pACZM3YzjmWIoSWBhMxFLVtFg1hkHIQ=;
        b=T3/83N5hCD74mnt56a8JU0ZJ9yZrZ5UFgugB2jTT5x5nIqdc3IGQP1THBZyAKQMNj+
         loCpdHNQmoq4dzLmbvqm9B93TwkTUFurP6A9j6WSlYgYIyW6GC0fWgSUywH9gFzurJWa
         GF+YpuHsixJfkBzDtV6jvnSFFy76EMqzuqDwPuxSOCrIvKbkV+MjFoSCDL0Ll8/hKqGf
         F/QoyBiP0DDghrSNF9lS0D0KUVHyO9P627hJhXhfKveKMAy3Ms2hiVcaBkTQekO4Ircl
         GyteiHVbVa9wlXjxmg0s8jlRl/ejDgjrfINcb+aizXW5ozPleX6VPZhOvRyyOOc2vS2Y
         Mgwg==
X-Gm-Message-State: AOJu0YyWoF7Krt891goDeXwMseGPY2MCh+qX5bIxFLtMXGjIbXGKhxF5
	7vAGdYYFO/H1f7Bt2Fo+qOGLd3ZJhRpQP/Si8cJHc+OUiZvoE095WdtFxn8hS/xdTA1xjbvil/1
	k
X-Google-Smtp-Source: AGHT+IEaAuGxE8Q/sUhf8BHr/cqOHvML05PH0iljxkC4PH34quq5p+P+YnDVd+6lHd10q3fIaxMq+Q==
X-Received: by 2002:a05:6e02:1a81:b0:3a0:abec:da95 with SMTP id e9e14a558f8ab-3a3f40ad623mr111865565ab.22.1729550488238;
        Mon, 21 Oct 2024 15:41:28 -0700 (PDT)
Received: from [192.168.1.128] ([38.175.170.29])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-4dc2a6090b5sm1260296173.89.2024.10.21.15.41.27
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 21 Oct 2024 15:41:27 -0700 (PDT)
Message-ID: <f1218a73-76db-4f8a-b3c9-19bdd3c026fc@linuxfoundation.org>
Date: Mon, 21 Oct 2024 16:41:26 -0600
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 5.15 00/82] 5.15.169-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org, allen.lkml@gmail.com, broonie@kernel.org,
 Shuah Khan <skhan@linuxfoundation.org>
References: <20241021102247.209765070@linuxfoundation.org>
Content-Language: en-US
From: Shuah Khan <skhan@linuxfoundation.org>
In-Reply-To: <20241021102247.209765070@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 10/21/24 04:24, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.169 release.
> There are 82 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 23 Oct 2024 10:22:25 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.169-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.15.y
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
