Received: from mail-pj1-f44.google.com (mail-pj1-f44.google.com [209.85.216.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2753B12FF70
	for <patches@lists.linux.dev>; Tue, 14 May 2024 22:32:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715725961; cv=none; b=b7cSFqI1HcbkS0c6ENBxEkgSaEgi85qPIjnIP3i/40mn6sKm/gpmIaTQglQxpzZv96bYOwoO5N5euxTLM17HvpT+Ipe7AFzHyFhiOW1wHl+/9WkGmPl+uYc71fOg9bYgshuD5l6T9H5ERVyqZKk5b1Rga9k+gDcZ+Ll6pk/4a3M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715725961; c=relaxed/simple;
	bh=RennY2C6Z+oSU0oRQjAqTe75OFRCviPgBEI+D3LQn6A=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=OoiyTlrrmwqKZZ2gyWWZvZMircaI17dzOWaewT1EU+tdyYwUZuEAJZSp3z7UYnqf4IBPGO1J76o1Qd16FaphvXMnwIVmrIwUzeA4ctvSkkpQAUW2tyYmL5xHmO7+O7BMaS53OxRD6maojSOGyY4Db9Inq+d7Ta9RTmZyPBFgeJE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=GuB8K621; arc=none smtp.client-ip=209.85.216.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="GuB8K621"
Received: by mail-pj1-f44.google.com with SMTP id 98e67ed59e1d1-2b2bc7b37bcso5317803a91.2
        for <patches@lists.linux.dev>; Tue, 14 May 2024 15:32:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1715725959; x=1716330759; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=s74EzR4awKr3eLr45eszTkAhWZLBmsDf/EkYyc0o3kg=;
        b=GuB8K6218O44EDV5PHzWwV6imRDxL/mz+4M8vB0UAQgEAtCkmqtJUI4StC2gD+IEvH
         a03jKWse4xV+RddlH15ffMSTodQhpESi6boQrG460DzkbmbIBT/bAXXPH4x6KzAigaKF
         DaZodKGa340N7e5DZr5+TThznF7ZeIoV0c/3ow5SYd68BZbrggpH05PAlxWbDH2UUmAb
         Gk1gzVoh0p3/j6zfN5JerugypAXBXwDReC8BHGxpqblVO5LJYnUTTinn6X4oxLEe44Fz
         WIp9JTbaTA+OrqbnlNiobCY/Tih001CtHybrWTk34XRbarr+eXX5fJli1DNtSIhrCyeF
         7SqA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1715725959; x=1716330759;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=s74EzR4awKr3eLr45eszTkAhWZLBmsDf/EkYyc0o3kg=;
        b=lLhKFMSMKFcqhiNGy87OnHmvtawTyngNm20eSUk+7G7gF0x117fAk+oOdFAytYK225
         jCD9DwkeNfXD+OYMJ6gBC3O6wIpmdJ9HTYBfIjhc2NNU043lNzpA5n/zWkq/xbiLxpmy
         JH22dKeT7er2zq3Uubu/X/AVtSvl/cDTr6hGvpvklD6rOF9SABRYA06XUxfF4UNh7AHI
         q2fJHOzFiFNZRpnWNhtvjIzFnmqNqW+bdLdIinngZVfsAg52wqjoAQhjPvcZn3/Acjym
         klAn1nqQgrfO6tHS08R9ny4SMWdUVYFtfnBnqyBIoMBSNUsAcPxLg98809MJlmWBdkpK
         C7dw==
X-Gm-Message-State: AOJu0Yz/hHFUKqxnBkxUne54m30izNjtNpuUzZ27ZQQ7s8jrqvWGGRmP
	hne8tFBGvVnBruAO07gHHY5Xs1zWsXGzxc10C6hM7WJzey3ywum+
X-Google-Smtp-Source: AGHT+IG9Iy319cNgBaxrp94szNVyTaeCn09v6tx7NwkuFYWrhwte1QksURJFD6r6MHMHsOk5icmZCA==
X-Received: by 2002:a17:90a:e507:b0:2b3:bcf7:3a9b with SMTP id 98e67ed59e1d1-2b6ccd8e078mr11850683a91.43.1715725959324;
        Tue, 14 May 2024 15:32:39 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id 98e67ed59e1d1-2b5e02bcf6asm10965137a91.1.2024.05.14.15.32.37
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 14 May 2024 15:32:38 -0700 (PDT)
Message-ID: <7a3889c6-2e6a-444c-9827-56ca94aa89f9@gmail.com>
Date: Tue, 14 May 2024 15:32:36 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 5.4 00/84] 5.4.276-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
 conor@kernel.org, allen.lkml@gmail.com, broonie@kernel.org
References: <20240514100951.686412426@linuxfoundation.org>
Content-Language: en-US
From: Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20240514100951.686412426@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 5/14/24 03:19, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.276 release.
> There are 84 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 16 May 2024 10:09:32 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.276-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.4.y
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

