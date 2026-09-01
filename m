Received: from mail-oo1-f54.google.com (mail-oo1-f54.google.com [209.85.161.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 59965481253
	for <patches@lists.linux.dev>; Tue,  1 Sep 2026 16:46:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788281197; cv=none; b=icCIXcUCrGUj1BV0LrOxKK8wNFc7iHK5DHR4I+pXefyHlDx2rMI1ED7ZzVqKm4KsFKqtQ7NuuQfZDtMkOup2W8aN262kn4Rss9VrAxiSjTr0IsYJ6Ih9Tufp0wV+s4PxsZBxk8uIY2CS/x3pVUoHE9g1OV/nFfPQ03WgJM9+2Ac=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788281197; c=relaxed/simple;
	bh=vx6IVAIfvGi2YN6wuW2bjqrtH7e+yn11t53xGem1iAo=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=d/bLiCBQeKjE+mY9wuPJC21AITpTWUkwR1V2S6z9IceKfzrNN1LeaqOLYKbzuC0loB0pWTeoLYDiqkro7KppTA4amoOhYnSN1Ok0Rdzgo9D7TbCDWss6A2je/aTWMox1sOIlbMCShCoNw9VpJzKzYg6Xe6z96NyDepiHQUZShx8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UZhF94O4; arc=none smtp.client-ip=209.85.161.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UZhF94O4"
Received: by mail-oo1-f54.google.com with SMTP id 006d021491bc7-6b1b233ca98so17044eaf.1
        for <patches@lists.linux.dev>; Tue, 01 Sep 2026 09:46:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google; t=1788281195; x=1788885995; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=gQ+8Eg5A7HAboa6Akxc2ZyEa3pqY0HjMm6hBUa0qhPQ=;
        b=UZhF94O4Q7cDfQUGszeH36QlmwTyDg4YsrZYvW+hG/edXbQpL2altDfpu4IQYOeSjL
         dzozJ3jeAd+jU3JYJ0SQVMWWnREnDlOka+vkIeqK8Hl/BHr2WdsWdSmPuJqnxTVFOKPl
         otEoYr/JgmNFDkabXoLyc0MsXZhJk6YdlGrQA=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788281195; x=1788885995;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=gQ+8Eg5A7HAboa6Akxc2ZyEa3pqY0HjMm6hBUa0qhPQ=;
        b=Hin/ucpt5xNDZUgw8VdCFcs5pjiekIILqB2Hn74COW7xi5Unwg8IBHom7cLCZEiRgh
         Ao7RSBfYZbTAqPf12Zv12EGZbUXXDuDNcEUh4SCdlk7bbgYfZT9BmvPOYzxPO+Xb0dat
         EFYoOvVDProf9QOktg/F9/DFMJHq5A84Ghq5GzlnXECrIRzax35wqPQMsaPKK240NZZz
         LCDtGvkCq0xScibVu9F7h7HUBjr7kPN04Ns+OL2bD3NCYLwzeGu63atEb+YqHGnYMYqa
         ffE+dErRvYmfG4qCfI9YMObOMFrryMxs/oLzfelz71jOZpzm0zAjOHgmov0dCXpJ4CDK
         B51Q==
X-Gm-Message-State: AFuF++mcz2xyNo3Dx0nXK3DmhkcTJ/+7KjT1Pgay8MX4fY86tOdM3VPt
	1CzDNjJQZhwG3BRxy6wf1b7BsqokpH7igxkL3MZ9w+8QNN2Hw40s+SUuma7+LGZI4qAgY9gfGGS
	0VPFeHak=
X-Gm-Gg: AR+sD10K/W7KNrBm+cMDJG1qo9lHBxSKvoJLh8K4vGZr6X7D8x2OHWRWfdE9e9OLDTI
	HxwUe/WBBSVaweP36dylugZtQJQWy+EW811+JXMmaEu/aSA+tOPR+6x6p/1krpK4hG4+1CZarys
	caWh91+vozW+uSrOqbbNkYtoDdSGe7WldwsuU5yg9cXbe141Zzb+UEjAkRA+xBQTpCeomkOsTIR
	RbZpd3EUAo4+a055iGyNNTfXLSIsJfAx9pwnAdwc06NOIHZJEpjZtPEajBBmyVkOK8XPsNpPLBt
	Kw99PAZWsU9uqEzaFNx+mv5EEZskk40GREiJhXxDgICSVu6mBfjRRigTfwoqK7PYynK0EI2Tkb1
	2ybfTz7c1MBoTp1fNZe+NIq5k4hoA6VOd79Kh1Mem+2S9R/Hec+Tas0dNzQkqNHgcIviJv0+GxC
	mVpONkycFubyNmdIa6/acP+WuZjCpZOwRbqwaM/xC2//C1+TM47hMM0DxRA6DTPQFd2AWzjlxji
	7e8X5LH
X-Received: by 2002:a05:6820:995:b0:6b1:3cb7:f535 with SMTP id 006d021491bc7-6b1c638112fmr34990759eaf.0.1788281194736;
        Tue, 01 Sep 2026 09:46:34 -0700 (PDT)
Received: from [192.168.1.128] ([38.15.57.99])
        by smtp.gmail.com with ESMTPSA id 586e51a60fabf-46f3046b139sm221497fac.3.2026.09.01.09.46.30
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 01 Sep 2026 09:46:34 -0700 (PDT)
Message-ID: <bc7fd0f4-d2ea-4d49-9b5b-ff2e04236878@linuxfoundation.org>
Date: Tue, 1 Sep 2026 10:46:28 -0600
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.6 00/91] 6.6.156-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 achill@achill.org, sr@sladewatkins.com,
 Shuah Khan <skhan@linuxfoundation.org>
References: <20260831133359.468089036@linuxfoundation.org>
Content-Language: en-US
From: Shuah Khan <skhan@linuxfoundation.org>
In-Reply-To: <20260831133359.468089036@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 8/31/26 07:33, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.6.156 release.
> There are 91 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 02 Sep 2026 13:32:19 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.6.156-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.6.y
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
