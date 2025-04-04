Received: from mail-il1-f179.google.com (mail-il1-f179.google.com [209.85.166.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C258A1F0E51
	for <patches@lists.linux.dev>; Fri,  4 Apr 2025 14:47:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743778066; cv=none; b=i1+Me+zn5YePd07rDdbF6ixRQ9FWIYRStcmEjZHLL0ATdiolFRY+MBZH/vvEUYG2YvMovdXrBWFtbUKLNEeQ2p3ZD+jGFTijJPPxQWw/dcuGxx+Ai2kOxs4+LhkUHJY+tD2emE7EtgGVVoqkYcHpZKMiQ2EBfGTIYkLWYx1fVAg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743778066; c=relaxed/simple;
	bh=DT0oeOxSlSB5tyOszx54qwkjlZkH81j+NmiwOPAiv6Q=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=BtwIv41+5FfVdb9eWMYVQE9/Fd7/axhN6kXXFg23g0kCiiykExHhxUEbTAqTPTKLv2NqhI2Ke6DQ8x3VkbvJjgvCY/iUe6B3a3uxPj4YJsK1PhETYRbg5MTacBDb5mLu54Q9Qeb7rrP6P2pyp5awVR0mtDZ7/gS6p3o8JupPv2I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LYTZa/5w; arc=none smtp.client-ip=209.85.166.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LYTZa/5w"
Received: by mail-il1-f179.google.com with SMTP id e9e14a558f8ab-3d4436ba324so19924335ab.2
        for <patches@lists.linux.dev>; Fri, 04 Apr 2025 07:47:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google; t=1743778063; x=1744382863; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=HV5vr/ytVO3vXtKit7H8xx/vEmS66zrCX03htvsUFGg=;
        b=LYTZa/5w6WhSYEjENFlXXi7snY9acjM+Xe/T7hQK2KSUkmfFv2kR3gxQHu2JdCrh1D
         bLoNPaj4SdeZW27whJDYPcxNBtFyhEj53/YxmSMTsmkx4YSytpfaMG9fLYXaVyhUFl6U
         cdMmHF8681aVgxEqgK/JpBDrxZ/vXUY0PJ7wM=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1743778063; x=1744382863;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=HV5vr/ytVO3vXtKit7H8xx/vEmS66zrCX03htvsUFGg=;
        b=vdKYGw8Lc5Up/cazfKx2HWUeJ/O5G5DzcFVi0ABx9stOAfb+Arf/3BkyhKvuKFG6dM
         fgHzSOGNPVUS0CVQexWlFjPtWeQ1zWAL3vp5dvDdRA5l+OSO9xzvhLW8ksPZCz20A4CU
         qCYYIXzgFXdwHehoKELwMfggqtvYE5HMcjgWsVXmy1zSSRx1bEJf3s7xZ5XVAmEnOWOL
         gYxpFc/5lSMlq4ELcKnnyRqPRkJKkuVMlDoMCG3bMM+zyLtBQMrnxJTtOk9hW9knP0Qa
         KINaFzwjswq/oGGDbOt3mbob8DlsJMuqaktk+R3FlaPqLBb23ilVH+76/c3ecLWXYs73
         nrFg==
X-Gm-Message-State: AOJu0YyTyc0E5etr9OP5uFGapR/4RmaPJXOlZ5MaSvwGkGnjp4aW8fK3
	C2VTqJDdQrjqmRvcCMpdthboZMiE4Eu3NTN0YJ0ua0KlA3oI9o5LvuW5OoOBddY=
X-Gm-Gg: ASbGncsSGjJxRGzFFtHvt27DgmHzg7sLEiFwtaDtocJ2AjUsKJ0KR+6WVCt6JGDfIrs
	n5itNUKYvm2gQsBO2HGxzpclCbkVU04rQbSpFUEHDknjOjl0v/jH/lbNkScP/RtRTgXondodmAC
	KczoSQ4uOifDc17twE8gqpoT0hvUhHrQ0b9DKP+XtKyYhnoXJrVE0FpstjE8ugIi8WSBIQlnWA9
	JssdJnRQ6dSHui0bh8MPvZV0o6xJ+9VEfZrfJeR2XiAkbHFmbVWdPrAA7Tr1z0apAS9J19Q0/Sz
	YwDiT18QPs9TENn2VoqZOGb1U2LJF2QAuT+fN0ctipJObxA4qj5TL5s=
X-Google-Smtp-Source: AGHT+IGEdyTRJtsV9w/3g4cbKsZhABESQ56Z9fZbnRALmoq2R+tjiu8kPUCEse1POeCcyUAsLI2HWA==
X-Received: by 2002:a05:6e02:2590:b0:3d3:f4fc:a291 with SMTP id e9e14a558f8ab-3d6e3f88ba3mr43879915ab.19.1743778062809;
        Fri, 04 Apr 2025 07:47:42 -0700 (PDT)
Received: from [192.168.1.14] ([38.175.170.29])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-4f4b5c4a6dfsm831627173.54.2025.04.04.07.47.41
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 04 Apr 2025 07:47:42 -0700 (PDT)
Message-ID: <406a11f2-af5b-4e2a-8bd9-0cd1a8afeced@linuxfoundation.org>
Date: Fri, 4 Apr 2025 08:47:41 -0600
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.12 00/22] 6.12.22-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 Shuah Khan <skhan@linuxfoundation.org>
References: <20250403151622.055059925@linuxfoundation.org>
Content-Language: en-US
From: Shuah Khan <skhan@linuxfoundation.org>
In-Reply-To: <20250403151622.055059925@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 4/3/25 09:20, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.12.22 release.
> There are 22 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 05 Apr 2025 15:16:11 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.12.22-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.12.y
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
