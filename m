Received: from mail-qk2-f13.google.com (mail-qk2-f13.google.com [74.125.230.205])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 49043503BF3
	for <patches@lists.linux.dev>; Fri,  2 Oct 2026 17:11:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.230.205
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790961128; cv=none; b=tG/r7rdrC4IM1EEI9tEEYcwq0jBEzF8/rqAv0utV/HCJqQgxn8+EBOWJncEvyQStMK2oIQ2SOhGujthd7rqZGeuEvxFXOUlCU1ViTYAJ4r8P7sxdAouayVZ0/1UOu5rQMe/iwgFMowv/eTRwi5qYzggQf19zxaGorbFipTGQj38=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790961128; c=relaxed/simple;
	bh=9iWiLeHeXnIJI/lcv7EGA9Q9oUsxmKM0h3HsxY6J+1s=;
	h=Message-ID:Date:MIME-Version:From:Subject:To:Cc:References:
	 In-Reply-To:Content-Type; b=DgPYIH+B11wBZfL0hwTRoF8gv8zGSbDp7Yz2z6ODM/7Nw2oz/ouGxbV9NiZ56yEBxOmcCGUcAQqQ55MRer5KmQ4LyUk3CLEuQEy1IjUhtE3L7CS8TETI2dbMb+KXDvsZjieMCz0h5qj7twDL9LveRee1Om65wPmNwV+bU48tSvk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=X6P4mMoE; arc=none smtp.client-ip=74.125.230.205
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="X6P4mMoE"
Received: by mail-qk2-f13.google.com with SMTP id af79cd13be357-939109fafd7so627692585a.2
        for <patches@lists.linux.dev>; Fri, 02 Oct 2026 10:11:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1790961110; x=1791565910; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :references:cc:to:subject:from:user-agent:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=78WQxbjUnQrJhyVO1dcpGQV/qKspNnaK49GmbKiN3lI=;
        b=X6P4mMoExFvwCNfYQAlcJW9DOV77sZnIf/dHHjdcMYC5SSs7neWlnorjzsXf8WWMkQ
         NiasUR/B2rdHuxmcdlruBVB51pabcqwTVOviLkyvedB1ybDi4QuVCVu8Y5qsKrpYyp0/
         iZgqAe2QEKGUWmA03pXWItN9+YbgkXA6/8e1F4jyvkKcIHGwcAPUWjqhRT4b31mSjvBE
         YAaR/drpNsmnP4/hKwBJjoeSHV+Q/au5L6fvmU9OJrDCmy7F4a7Sk/9oOFpMs2hDI7IV
         UQDu5LJviY0T0A2xKBkeN48P9RufoAs1v1/UORQt6Uag/7Sfc6P3CQq4wYjE4Y7Fk86b
         YeeA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790961110; x=1791565910;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :references:cc:to:subject:from:user-agent:mime-version:date
         :message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=78WQxbjUnQrJhyVO1dcpGQV/qKspNnaK49GmbKiN3lI=;
        b=k1+RppQcrXaCSESpCYMcMgmSvU0I/9nS+W29CBLALxv0Jiwvs8UJsoPokq3u/XTyQf
         kztAeFCGz2EZw0LnXLdhpyRgAxwgrFvl61t6SBH3TcVhgtdI4CNUq6ri8DiLjjCAa7Ky
         NQ7DruwniS8c8HmUiqErnFcyVVV8Uz1KOM8DhDNL+6c7sEYM1DTl9uHXTHdqACTmD6ON
         gfBfht9wjbKLF33jPf1kjF7Qy9zhTEI1mZOhcFhN17WgQHmonMno3+n9XXRw1K3Ks9+E
         rZ2DfJYDb4hko6ZtSQi0d01bEn+p+x3Q/QrFKHfL25OKzzYFxG7Js3ZpBbecmglG0QW1
         lVCQ==
X-Gm-Message-State: AFuF++lCPQ22171k794VQ683It2CifoxiopxuCaJ669Vds0cQ/035bq+
	ZNQEFgtc+ll9JsTy89KjnOw1hrKjbQhDOOAx5zQKDH6x7+I3JzDSmvsg
X-Gm-Gg: AYBFou1BJ37pcUgQfX3T6HYH27r0mU9LPgVm0gOaP3+7Nq5S4ocOpzRHRXweXpO+llC
	3VmXzICTUVp+94Oo8b8+TcT3zZGzlB3bYI/JIx4Dcyg1WxtidaFSWE/BO8Mze2bm3s/9O2haG1T
	yrOG8dBHRlQXAKZyPtA56GcMLKgte6mBI+ZU20HtBi0S9p1kZzTcvZ9pEccGtoVGkec7lmyybu6
	UJqMebwnhXhiJTZLeW2SlaTANsyPYWGWfg+vSgSnLtLqFfdPP6x9mHCunesjZhcmK1uOTfuBu4p
	EsMUpQKzsPuDQC+fC1b95nptVqkjPAdF9KOmQG0s3WepR+fvNTNLnrcIP/LcO4rvLSUlPe4fdY6
	vpTLS6QWktKvUUluSsrnU4Xgt7Wm7eWOuyvNx8WgvvO5vltIZdX1D6GUOK+ZVKaVqgXGSP6CgsM
	GuS3Enkh2uZkR29xxq9fZ4d6C5/GgCuerseOa+shppnfgGbf/iXzZQCMCrKStJ6yd70R5ftGxrZ
	CNcW+0lH3ObXMww4sTc3+GiIQ==
X-Received: by 2002:a05:620a:1728:b0:939:8373:b552 with SMTP id af79cd13be357-93ce7a955a2mr596693585a.1.1790961109773;
        Fri, 02 Oct 2026 10:11:49 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-93cca1a63d8sm266316885a.12.2026.10.02.10.11.46
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 02 Oct 2026 10:11:48 -0700 (PDT)
Message-ID: <6f58df26-16f1-45f4-a5a5-c8e97c936944@gmail.com>
Date: Fri, 2 Oct 2026 10:11:45 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
From: Florian Fainelli <f.fainelli@gmail.com>
Subject: Re: [PATCH 7.2 000/457] 7.2.9-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, rwarsow@gmx.de, conor@kernel.org,
 hargar@microsoft.com, broonie@kernel.org, achill@achill.org,
 sr@sladewatkins.com
References: <20260930152346.024115587@linuxfoundation.org>
Content-Language: en-US
In-Reply-To: <20260930152346.024115587@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 9/30/2026 8:21 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 7.2.9 release.
> There are 457 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 02 Oct 2026 15:23:04 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v7.x/stable-review/patch-7.2.9-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-7.2.y
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

