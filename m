Received: from mail-ot1-f44.google.com (mail-ot1-f44.google.com [209.85.210.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E909FBA34
	for <patches@lists.linux.dev>; Fri, 24 Apr 2026 22:32:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777069947; cv=none; b=QKohDmM/OSVCUQP/FMUq0MneBOnWdSTpbF6IOyqMzPKP/6SGeT8pyI9lWb19Gy8CRYnjfvyEQ9DrSZ+ykoJ3ZInI9QlsPT9RgpjmRyjL4RHsMi28Q4lWNAy2DWgMj+Ga6Xk1HkZi8rW5qZDfweixvYuyZx+PsuT8ut6ijKk1jBI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777069947; c=relaxed/simple;
	bh=XiYgjWVSSmvsu9T2rXFWc7XJ7DDFJtdxFEBscoZ6/RM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=NwHjkF5v1T+EB3QaqhpKFKw7ims+TR9Eyam1qkb/6fpAfw2FRs7GlmATwg9gfp+YLEzhKKxGCMH8RRaktjXN8YHiKkzn5uuqTY3cWGWkMPBuxsyF3jLLhXnjLKAwtrc68ep/k0vFi+RqH93B6iFivEcN7Xx4JH8XYlkEBAeaySk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RNeorJX1; arc=none smtp.client-ip=209.85.210.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RNeorJX1"
Received: by mail-ot1-f44.google.com with SMTP id 46e09a7af769-7dcdd23fcdfso2459702a34.3
        for <patches@lists.linux.dev>; Fri, 24 Apr 2026 15:32:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google; t=1777069945; x=1777674745; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=d63IHBcUO19TdA2d3EB3lF2F+u+MqqfFJL5ktUx7u18=;
        b=RNeorJX1v5MXSoXecCkaFdYufv0J1Efu+wBUlu0XcqWHb4fjhfNo9/HvM0rev1tHrX
         HoiR29bYxQGCAry7zzhlCp1rVg/CxKUT+k+ulU1Oe6NTFBMI2YL6aV4YmkefQTmg4orf
         DE0weK3epbqO5NbmY3RrfJxiF77KuSwpqNia4=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777069945; x=1777674745;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=d63IHBcUO19TdA2d3EB3lF2F+u+MqqfFJL5ktUx7u18=;
        b=Oq4rU83rTKo3/1MGY/H8QHmSXUd4IxG4CtHwOtiWqRPO1pv/11Sum/29VF5qRvEuCV
         DUOJoV724YKXMTIhpe9pS6SCDoON+HECMYFd9d5pWwqgAuqoLrPKe/1d+cKPQg5VpTBn
         bPPvDSvm6eUBGZmfiFoguKAi6acI6/BVz8+IDPw/RttI0y4iStYKlcqQYkZSxJaQ8iD8
         Ro1Q6YBNImMACH8AR2WB9O68/63xKUZLSQ1LhZwltG6mJuyIptfY6Yk7xzVQeDBzGMWi
         bAKQXYhRBvMIS/he8H8iTrYlkkglBLwcTEw88VPs5eqilI93tRWMECFzLUiX5i/21H/o
         pOQQ==
X-Gm-Message-State: AOJu0Yw1lRrifrw5UVCTbMbBwLlQa6K+/BpiWc8AmbDJRJ1xLk/FJOwC
	sPPfY7CkVBEfVo1MrlDMPeX8vvuSzl3ixG6CycUhd2WRBJTLms3Z8wyTkUBwp2yCEMg=
X-Gm-Gg: AeBDievD6PKCiLanYFMpxHk6Afvdohldna/sk2PQM/0Yj3vRTI0palA4KfM8F9yMJLZ
	DKSaL3SOQwXU5ErWphkulM9tAcmtsnzxfwr14cN3YnEzTHCv2uXJZpxQoiyFyQzNtZbOkniRFc8
	6cq62IDkjxsN5AI1tJrU1VCgCEc0jPYvr3hvt1O3xWjY30CZ5i5Jc6HiRogp70awvCmK9wllcZx
	MxMVwFUUgkU4SQyXu7DQJ+R/DEo9koRF+Z8l3JVJ/BoWLTLp648nVQwg9FPgKTbnJHVh+qip5mv
	FFjdijS/xBoV4BIGxdFtAZwE2unsqnXFooW+BRb4yrCMJZHDicLtgaYzu6oQ/um+kqt/JRGZSrf
	MR/IHaDYjl+lhcRMrn5ceN2G6hV2ukAxLEnq6lOaLxbcdrt+m/Ei2NUSxPFJYXxeHKpbLUQC2/Y
	pTOiEkCQP8y+9KG0G2ZjxXBNXuzQa0BQ+NaUO0IWL/qYIye/EMY4iG
X-Received: by 2002:a05:6820:4df8:b0:694:984c:1a7a with SMTP id 006d021491bc7-694984c1e67mr11447714eaf.10.1777069944845;
        Fri, 24 Apr 2026 15:32:24 -0700 (PDT)
Received: from [192.168.1.14] ([38.15.57.99])
        by smtp.gmail.com with ESMTPSA id 006d021491bc7-6949eb69302sm7045615eaf.5.2026.04.24.15.32.23
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 24 Apr 2026 15:32:24 -0700 (PDT)
Message-ID: <35bb259b-b74b-4c57-8a04-592b71d5fd28@linuxfoundation.org>
Date: Fri, 24 Apr 2026 16:32:22 -0600
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.6 000/166] 6.6.136-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 achill@achill.org, sr@sladewatkins.com,
 Shuah Khan <skhan@linuxfoundation.org>
References: <20260424132532.812258529@linuxfoundation.org>
Content-Language: en-US
From: Shuah Khan <skhan@linuxfoundation.org>
In-Reply-To: <20260424132532.812258529@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 4/24/26 07:28, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.6.136 release.
> There are 166 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 26 Apr 2026 13:23:21 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.6.136-rc1.gz
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
