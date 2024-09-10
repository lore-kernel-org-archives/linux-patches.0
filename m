Received: from mail-il1-f182.google.com (mail-il1-f182.google.com [209.85.166.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 96D431A4F1E
	for <patches@lists.linux.dev>; Tue, 10 Sep 2024 23:13:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726009996; cv=none; b=Lr0fJ8rndMjTbWDTqsHYv3UOVwAsd6oQCcv92qD4VIUfsxTuGoTFcplStlXBs6n/qHyHu3OO5dFJrHMpXnUm78owgNVsvizDqfX5pFuuL2kpPlsYZhPC5nBJKpjxsiaoekfWj0cJyec9kB5GGQSonaX48WqAxWu5jYR5RFBW1ZM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726009996; c=relaxed/simple;
	bh=skkOgOVrk2rz6JTfzyf0B9szj/KCPd4ttv8afMLEVBc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=S+OcApeKpZ8JsBnHWowkGQUIq7TEqs/degmPvACBbAp5IS8oVNdVBVTO9RPrprXyT12VhHwFA4LTV+uz0Jokz3Te6mw3QCXZhrK2+7snq0Kz1YjRU2cPbQMNHs3u7G12REnsCCbMQeoamFOdJK0zj5iW6I8ENKgfJyv6nICuvys=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BA+tAN1F; arc=none smtp.client-ip=209.85.166.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BA+tAN1F"
Received: by mail-il1-f182.google.com with SMTP id e9e14a558f8ab-39f539a83e0so22125445ab.2
        for <patches@lists.linux.dev>; Tue, 10 Sep 2024 16:13:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google; t=1726009994; x=1726614794; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=NB2gEKUnRkYZypGTHLojoU4Xifb8ehPDDVLdPZ1Wimc=;
        b=BA+tAN1F3KCuRaoLU9BADg8rtrJUc2/08iLwZtMB3jqyrMYxwqoHDbvwoFmdSzDKIw
         BhpvYSV/v3lOKbT9Jx7RG4kIklIGxtG9VgjHjDbWaLz2XAwsAJunHFZy8LkA1NOVNL0t
         woM/2otgNePq+Z8Q19Fdmf1Sm6m3b1w0LEq0w=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1726009994; x=1726614794;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=NB2gEKUnRkYZypGTHLojoU4Xifb8ehPDDVLdPZ1Wimc=;
        b=s/mN+IFyy24aPzfob2RlT0TjujG1n3zLStVoj/qA1kUjpx3q933ZZfS7OhHz5N/wAP
         QxmMn2x0v3JLAwfS272DhmhdXqR13kbSGygaa4UjClIzUxzVum/BBDnENDhbzNnDDti5
         6bpCdo+UaUIF9zQ2l+nVn0QHWrW7yb1WpsIfD5FtxFzIk0gpyo+/XH/ax6XP9aGByFAN
         N1CSJchTenSU4NlzjqtBVRqcJZVf9erZAhe9jLbPeo2Q9gtNvmDbH75a4sy/OnBJKJIn
         fKhx+23fIaQbH1UzNoWfSzjoTDyAb9WR8m5PAgXbjA9lrmQtWVh8W5huXvALGzTy6dHa
         FM9Q==
X-Gm-Message-State: AOJu0YyJBRJRBMVkzlG9QdeTzo61Mkcp4L8j31JUFSgQfWnGd+MjIj2b
	NgRZFIZY/zO273Oxmlh+0pajxBjuQJpoCCinxaMCz1mG7v3LTgZAcfTTwmTjzGE=
X-Google-Smtp-Source: AGHT+IEeEWIUJMqZZjwDZ2RP39n9JJ9BSDpALYkvcGOf6VmhkOy+w1lJvYj/0k3BEF9J+t5LDNTr7g==
X-Received: by 2002:a05:6e02:1fcb:b0:3a0:4c4e:2e53 with SMTP id e9e14a558f8ab-3a04f072f13mr158108345ab.5.1726009993733;
        Tue, 10 Sep 2024 16:13:13 -0700 (PDT)
Received: from [192.168.1.128] ([38.175.170.29])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-4d09451da2csm1860392173.27.2024.09.10.16.13.12
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 10 Sep 2024 16:13:13 -0700 (PDT)
Message-ID: <2c086ba4-c7bd-47e3-bf12-d3c99a5edcfa@linuxfoundation.org>
Date: Tue, 10 Sep 2024 17:13:12 -0600
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.10 000/375] 6.10.10-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org, allen.lkml@gmail.com, broonie@kernel.org,
 Shuah Khan <skhan@linuxfoundation.org>
References: <20240910092622.245959861@linuxfoundation.org>
Content-Language: en-US
From: Shuah Khan <skhan@linuxfoundation.org>
In-Reply-To: <20240910092622.245959861@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 9/10/24 03:26, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.10.10 release.
> There are 375 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 12 Sep 2024 09:25:22 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.10.10-rc1.gz
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
