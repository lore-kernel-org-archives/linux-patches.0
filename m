Received: from mail-dy1-f182.google.com (mail-dy1-f182.google.com [74.125.82.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 11FD2399895
	for <patches@lists.linux.dev>; Wed, 13 May 2026 17:16:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.82.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778692588; cv=none; b=r3OsEbBsPFIO41r1X2gKh2Bqe5XFBOXpSLMtuvirxS60rlev6aclhwUDPaUFBk93z5g7erQX+av9zLAHxDMYnXV0ixT2RGiGYXU/5VrBkg8T9nbehonr2lhHVv16SEjm1DctaxcBHfceBPbabRoeKlNFw3pU6WQuNvRNnkxq5FA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778692588; c=relaxed/simple;
	bh=K90sbdV+ulm99KUT0SeI9AT5YPATm3JEyQ27ovWRo9o=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=VnwGfgII8bV5lGaQ/hcOOdwaae2ll8Eirro9Keh7Phktp4jrJ3zRwLciwQKjS0eVxu+/d0XzsC6cZQTplK+N5ABGgpYJjDEj0JWSH7+bglKcNU7nm3M5+fc913XyciHoXTf6i7trTUpe9I2vrnUnFQnqOiSptISYAdlntELWwZk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=tFeDPDZx; arc=none smtp.client-ip=74.125.82.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="tFeDPDZx"
Received: by mail-dy1-f182.google.com with SMTP id 5a478bee46e88-2f30a4601bbso7650912eec.1
        for <patches@lists.linux.dev>; Wed, 13 May 2026 10:16:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1778692581; x=1779297381; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=/bMevHUpxvHgmnggs8mtB8OZjWsvTBxv6UxHli9n5VM=;
        b=tFeDPDZxi+sGO2BF5HgtC1QNFGqXO7e2zhGCljsWXleCpASVcwxQmVNBYCgXzj9PYZ
         3AOYcSdX0P6UtK71ir/ovmmdRHKvnk38CvfZ8sSHydOXM7EefgLCOF9kUB18yO2WCdAY
         NRBYxy7MDcfPOqugHA98mT2ySZ2zd0t68u7BblmeoRY2ILZpPYJd+iqQ9ENRHp4L8stE
         u9AiW4LeYwQzhVtF56bULHHzNBGRSzlCo7lRa6neZVnZVtFqXi0EAeRWLhJEjav5ivlH
         76cepo3/8Ld6cLsnHSe7k5vsAZzTKwbx9k5pXCgtOzYTAk3T1TKNvPXyO/HdrX9tPv8h
         0Lsw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778692581; x=1779297381;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=/bMevHUpxvHgmnggs8mtB8OZjWsvTBxv6UxHli9n5VM=;
        b=tLsX3LGKGmK0+yvf6yMuo6OfnNVP6fkkec5D2j8k4RCkOPciSTO3Dea3x9nCtnswaU
         1Hs5QemSBG7fA4KGyy3luczGA6YdKQDdaziCaJuhPBtyYbhxhqOx0JvcgAz8VAHWToCr
         AhnrR+HcNGZjWWPxkQrV8u5slcjsDwsF19Jafs3iGVXfNtO/wOve7g0D9yPmkYqtC57b
         suIGVWeynkIyKovULYlydPipeKcVh38rTW3b3I0rJo/eGef0+JkxCD+WD5HiA6EL+NIn
         uBddlhUvzo//6EL1DDcm1FQLdBhpyrMPdN4Bll1RrC2TJokcR8vg3LXlo5NQPHZog4OX
         Yb6g==
X-Gm-Message-State: AOJu0YzYFElVsZXW6SGLEjL5n1uWcX0MAcJCB98bZLC4cL0SeTY2o+h/
	Zlc5E1nl/rbxfo2H9vi4mdqPtC3lKZOE1JmkkJFlE9SMF8MeNcoSFl1J
X-Gm-Gg: Acq92OFjXpk9+Ob0F3Tgl5GrBZ1A54WLhz/bPRvo1iiylInSsLoOwXKrtgJ/N04sHZJ
	mFjgpQ1jygtaAAcNQKGpX4VmnDx1mGjcRyR8aMkUCq9eHF26Zce14bc9QcY06UAiImtvSrAvcZi
	05zwLUIlpsy/MfNeNfp7lv6fFXWBRkMdU4xrku5uAU1i1DdcjGPPlryKBut6Gbsd/T++RGIPVyJ
	tt9amBzpsQUKzQiXV3f0ZSmX5nYxNM9Fbqh5+KcF5x/jyq6/STuj9hrzXi8U7v3fFDMqXVZxD4W
	n0i82hQmfEi1vzJZG0q323L6gmND6xlCv8KI6cOcJOKE3gr1q8b2PA5hInNH5ZI8TSwzVlKBsvH
	b2KWWx1pOC/aaeS4R0xN87uPyoUXCRMkG6Bt37xzHNb+rd1JkplHymcjHm5zlKYA8Rx7KV5RHHL
	g/wWwuvZU6voa9sXkjkJ5UhusZ76acYe9FtPDyMaav41ppkt0p8ic5DASi9LYaYy25
X-Received: by 2002:a05:7300:a984:b0:2dd:5641:f01 with SMTP id 5a478bee46e88-30155b4d27bmr1922956eec.28.1778692580578;
        Wed, 13 May 2026 10:16:20 -0700 (PDT)
Received: from [192.168.1.3] (ip68-4-215-93.oc.oc.cox.net. [68.4.215.93])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-2f8859eafc2sm28901475eec.4.2026.05.13.10.16.19
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 13 May 2026 10:16:19 -0700 (PDT)
Message-ID: <481cee2b-1deb-4093-8b9c-b3f1e982ff6d@gmail.com>
Date: Wed, 13 May 2026 10:16:17 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.12 000/202] 6.12.88-rc2 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, rwarsow@gmx.de, conor@kernel.org,
 hargar@microsoft.com, broonie@kernel.org, achill@achill.org,
 sr@sladewatkins.com
References: <20260513153743.326058350@linuxfoundation.org>
Content-Language: en-US
From: Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20260513153743.326058350@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 5/13/2026 9:17 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.12.88 release.
> There are 202 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 15 May 2026 15:37:24 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.12.88-rc2.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.12.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

On ARCH_BRCMSTB using 32-bit and 64-bit ARM kernels:

Tested-by: Florian Fainelli <florian.fainelli@broadcom.com>

perf for MIPS fails, largely due because it assumes newer toolchain 
kernel headers than what I am building with, which we hit with the 
following build error:

trace/beauty/fcntl.c: In function 'syscall_arg__scnprintf_fcntl_arg':
trace/beauty/fcntl.c:96:13: error: 'F_GET_RW_HINT' undeclared (first use 
in this function); did you mean 'F_GETOWN'?
       cmd == F_GET_RW_HINT || cmd == F_SET_RW_HINT ||
              ^~~~~~~~~~~~~
              F_GETOWN
trace/beauty/fcntl.c:96:13: note: each undeclared identifier is reported 
only once for each function it appears in
trace/beauty/fcntl.c:96:37: error: 'F_SET_RW_HINT' undeclared (first use 
in this function); did you mean 'F_SETOWN'?
       cmd == F_GET_RW_HINT || cmd == F_SET_RW_HINT ||
                                      ^~~~~~~~~~~~~
                                      F_SETOWN
trace/beauty/fcntl.c:97:13: error: 'F_GET_FILE_RW_HINT' undeclared 
(first use in this function); did you mean 'F_GETOWNER_UIDS'?
       cmd == F_GET_FILE_RW_HINT || cmd == F_SET_FILE_RW_HINT)
              ^~~~~~~~~~~~~~~~~~
              F_GETOWNER_UIDS
trace/beauty/fcntl.c:97:42: error: 'F_SET_FILE_RW_HINT' undeclared 
(first use in this function)
       cmd == F_GET_FILE_RW_HINT || cmd == F_SET_FILE_RW_HINT)
                                           ^~~~~~~~~~~~~~~~~~

I will submit a fix upstream for this.
-- 
Florian

