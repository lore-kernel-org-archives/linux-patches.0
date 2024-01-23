Received: from mail-pj1-f51.google.com (mail-pj1-f51.google.com [209.85.216.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C84782114
	for <patches@lists.linux.dev>; Tue, 23 Jan 2024 21:47:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706046465; cv=none; b=SxF5WtWU2SidkcFuYQfqvjBXFF7V9zJ2A8dmeXuC9VRdJ0coD3Mz/f7ACx9ioR/vZvBwHk7QkIn+93SHeMSMUQA0OXT570+u4OHNafpSlUG3kGsrkoodnQiQTdBOqKdIONg2FxlelBOYfNRAk2DSs5weDnW34+ut5Cgu/ZjTLMQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706046465; c=relaxed/simple;
	bh=7E3YVZzzXAbjUcjPgylzTyklVGOBXlBAL15X5b1iNJc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=ngkRm2kDa3g1oHqznT7Bv43lb92PCnMINJoBkgT+WzRr6CDyDBdKhYytzxLRquAQCE4p+LkR/xejjgVuLLxEGkoDwCUBbpHH1/+qCxrPFM5E+gzmkDZKQ3NvUy3r5YNg7vvOOlnUMorcKTKY8kgj4bQLu+rPGiJrBptYe7kys2I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=F/0DPxFA; arc=none smtp.client-ip=209.85.216.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="F/0DPxFA"
Received: by mail-pj1-f51.google.com with SMTP id 98e67ed59e1d1-2906bd9f2ebso2339667a91.0
        for <patches@lists.linux.dev>; Tue, 23 Jan 2024 13:47:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1706046463; x=1706651263; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=aopPrOg9IfHu/8HlGzikxm2eVGOvpCFKpLoXHZfm0CQ=;
        b=F/0DPxFAEr01IDFPud7XpcR8sKxpx/mXzA7uBbNwP6gv7xuZz/llgVvEQWfuk9D7fr
         /9LppXiZBU7+B701OPP7nKav7Tw0+e3KdCbyNh+UD0KYHo7az9oi5oalE5pTkuxj8fQt
         NWEWDjfqtgYmNKi34+3ue4jmx22Ea2JOFOKDJp4jQiPi7iONUpclyIBVOXRjDj+sF3On
         MMBbBKiVKotpGsAEQOsEGGAdAr/C0cyR+gEdfwV6W2kaEi0JKeMQY2uEfxBl7WlAa39O
         Fkku/S78OzICNu7+CSYO/F8G6cd+HyagkuMEie6JSBekIGr7FCG4TWYx/QhxIeQHNkD1
         L6Ww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1706046463; x=1706651263;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=aopPrOg9IfHu/8HlGzikxm2eVGOvpCFKpLoXHZfm0CQ=;
        b=m7K6HBu5j9OvGJQC+EzpINYi9LHNFQP+t2i0s1z/PQT1eIwZBoWqjDlZ6gSPzQND/d
         JsT1nX/ASyQ2JKos+bU7ynn1rsVp6o0xDCUOxS3QZ5+ycfhiEhP76yzVU5DuoepA6QAR
         2G0EODs5Kdlc01Y/MH89YRWOoeepTelx3+oDz+ShRlPXP8p5pudsP6EMn/ZK3l1Z0isS
         9UpVc5wpLBopyK6xSQ/kArcyK2fJSHpx+9yu4yMirDEPZaVvGkJVdVze+a37tYj2sdI2
         LBOV+6kZSuiHvAVXqu2aZh9XGWeuouEe8s5Vqnn5ddupDaL2GAnUOxlpfVHLP8SH/qAA
         tPWA==
X-Gm-Message-State: AOJu0YxZXMOON0OKI1Wat46KbIbLtxQz3Mpdk8Rj3XcgQoYCi3BOeW+D
	YOf7AL3JylvA+3RMDGqXERSXL2k8pufpc//E7P6f8kO0SIHXLz3i
X-Google-Smtp-Source: AGHT+IGcgc35znDY6cVDFy3PwGVXEd7jCbUBfwp/3XnamNiSfMv+XJTh7GTu/MJKZ8xpoVspgITTZQ==
X-Received: by 2002:a17:90b:1e44:b0:28b:5031:55f6 with SMTP id pi4-20020a17090b1e4400b0028b503155f6mr289155pjb.47.1706046463068;
        Tue, 23 Jan 2024 13:47:43 -0800 (PST)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id js4-20020a17090b148400b0028e7577015asm820519pjb.0.2024.01.23.13.47.41
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 23 Jan 2024 13:47:42 -0800 (PST)
Message-ID: <ff991af0-9e13-4cbf-9223-b49470dc1776@gmail.com>
Date: Tue, 23 Jan 2024 13:47:40 -0800
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 5.15 000/371] 5.15.148-rc2 review
Content-Language: en-US
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
 conor@kernel.org, allen.lkml@gmail.com
References: <20240123174500.819179356@linuxfoundation.org>
From: Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20240123174500.819179356@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 1/23/24 09:46, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.148 release.
> There are 371 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 25 Jan 2024 17:44:14 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.148-rc2.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.15.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

On ARCH_BRCMSTB using 32-bit and 64-bit ARM kernels, build tested on 
BMIPS_GENERIC:

Tested-by: Florian Fainelli <florian.fainelli@broadcom.com>
-- 
Florian

