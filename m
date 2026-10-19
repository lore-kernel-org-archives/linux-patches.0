Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.167.177
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792453514;
	b=0gcD+S7Izm6sATfvWpduwJxHToSLCdfdkSOuqzoV1iwTeByzpjiKOAlOfANaSQJTVxzj
	 hUIhvNm6z+qEPQtc3vYXlYo11k/m1l6Ddn0E2dpFTces1zYrwhOxBe8+jRa7Aw26Ggf8x
	 CVghcbQpz97xeZxwyWQZe2Zo61WctVEsuduQVBFy2nnBqc/cGAl99M/hZQbZ/rcUuRw+Q
	 rMLvz0kW/g6Wv5hLCveyN+ZcoqpF6AL0NDPbkdHkmeMt059htWkSG1GExcnqXtwCvZbIL
	 7anejxgy9TYIFJsoUAdbwSPakKyulvsbnNVUeZ63aRX6OljHp9BR3I3uhwqrGjOohXw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792453514;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:Message-ID:Date:
	 MIME-Version:User-Agent:Subject:To:Cc:References:Content-Language:
	 From:In-Reply-To:Content-Type:Content-Transfer-Encoding;
	bh=L+dMPBvak1er1V+6J06MJbguYRMeFQgiyOwZtRIbZB4=;
	b=oEI++jlKlSAFL/Rs9g4OcZ2H5voEKxixuY4ONwrr0uRn+hS6SBlVKBuEIy97Ipo6mt1D
	 qJSmiJ5RLUNTvjr3gtkvRmtB5+kxOHKdgq03tEbVoDgd0FdJplLCeLecbXqKTHyk0vXhK
	 aGqbW1z98AQbpurtmEYYnt+riozAg6uRT1Ws6k+pvTiHmApIi9EFD47o7wAL1MAfRedtQ
	 tW2Uk+MuzqTg5RvI+jQzDZKpWBuqtCyF+nWguE+eq7mX7JPIyzWZ2b97Zik2BDiuSsQEi
	 kFmq9NwQkt0+2wB8WOaS7TJATHTKvoliZmdL9zDSrfKEE8QqUyW5IepQ8iRHORnyoOg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linuxfoundation.org;
	spf=pass smtp.mailfrom=linuxfoundation.org;
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=google header.b=E59NaTfm;
	arc=none smtp.remote-ip=209.85.167.177
Received: from mail-oi1-f177.google.com (mail-oi1-f177.google.com [209.85.167.177])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A8333606A31C
	for <patches@lists.linux.dev>; Mon, 19 Oct 2026 23:45:13 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org A8333606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=google header.b=E59NaTfm
Received: by mail-oi1-f177.google.com with SMTP id 5614622812f47-4f48d91ba7dso1651671b6e.2
        for <patches@lists.linux.dev>; Mon, 19 Oct 2026 16:45:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google; t=1792453512; x=1793058312; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=L+dMPBvak1er1V+6J06MJbguYRMeFQgiyOwZtRIbZB4=;
        b=E59NaTfmO3rvsNxJ4ePac3E1880DEWe8Tf25QJNjnuIf8ixIIUcfZVkVc7/YmOILQN
         rAOGLgeUfnnbFY3S6gi9pCnsmDG/PhFJJRH77ZhXQwlfmGyh36tGE3sZwuxr8+4/fd91
         7ESWVMYqO62kA/wE58fZzZQfxRs/Th9ROlOio=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792453512; x=1793058312;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=L+dMPBvak1er1V+6J06MJbguYRMeFQgiyOwZtRIbZB4=;
        b=VHxYWFDmTik3cuGF/uUYrUWIzOsUOLAPxEMhSpD/zabff1yfx53IiuHoBhT+lffXJW
         iCkpXrz6lRTQCr08MOes2T1H6Crmy1H5FysNWFTQQmWPh14uhDcv/d4bmmhk7ppjkyfc
         jfh9cp05MMTFpBst5nMp1bzFv+Mk+3vstRhlH3TY8mXyAqxot0SGf4WZcHRaPHfnyZPc
         BwZTfdb76FSWkBl3J5yLdNM9d7hFFcywcQ9t5xTnpzQLJzCUuI5rwvEMMO/yo0eCTMa1
         6lfJXZyodiET9XPhAE2rhrmT2C1stgZ3MAvqYDWqAuIQVIRzEb477ihOGxsrVFvevCk4
         suTA==
X-Gm-Message-State: AFq9FYIVQwUY2VJzuHhpP7q2Vb+mH78xD3tduoPTD/OEXPlEyEim+g6A
	M9Iob7wtJCIEdJl6ft/yOhrADMbUek27LBx2D1M/9HRcTvh8HNCy2gOzLMDLebDaEiw=
X-Gm-Gg: AYBFou0+ApK2G9Moua8/a+lWteMBzvi6jUxG+wMSxgeVUuI7YJox7NLaSKIz1buwfvx
	vFNndfnTWBGNthXLS+nKFTjMThSs5xdHup1K216kH8juDZgRjknXrFPPG2yTuBr0sf35sijMolf
	v7G/6hFBC+mFgsFsKmWV+WLAXh8D1jmyxDUhEcNMz3n6Gms7Tynk+0L7THncmZvZYlzf5RGOzly
	vova+baJ37+ZXkLISq4R5mZLuVAENvdkf4QfiV2vdnb1GPzSXFCjGfTu+szyfGU4AcZcuA1Pbxl
	bf07up+bGUN4I1QKTl5Ytvexoo7Yt2IBXEvsqvJXdVTj8i7ZifItLZ7Q5Kt284Ld8QiOBTwz6rj
	5Ik/rhk6bDpBQheQUY677knlrmGheZgBnIlMUx+G3sS2bBNiAYiLfFg8EFDuMbgB99nOwboIMsM
	3LtdlmCPJsX3RVI8R75uGlY30h3HPcdy1RsbWgwIb+XuZKi8Zsns7RDHAN5wqb7n2wffKc0fByG
	Rf5ML8=
X-Received: by 2002:a05:6808:220d:b0:4a3:fefb:899b with SMTP id 5614622812f47-53cc5b5bc4cmr8945280b6e.7.1792453512583;
        Mon, 19 Oct 2026 16:45:12 -0700 (PDT)
Received: from [192.168.1.128] ([38.15.57.99])
        by smtp.gmail.com with ESMTPSA id 5614622812f47-54481784097sm3856223b6e.3.2026.10.19.16.45.09
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 19 Oct 2026 16:45:11 -0700 (PDT)
Message-ID: <aba623e5-01d2-4822-bba1-48133bbbea65@linuxfoundation.org>
Date: Mon, 19 Oct 2026 17:45:07 -0600
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 7.2 00/10] 7.2.12-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 achill@achill.org, sr@sladewatkins.com,
 Shuah Khan <skhan@linuxfoundation.org>
References: <20261017155059.698368299@linuxfoundation.org>
Content-Language: en-US
From: Shuah Khan <skhan@linuxfoundation.org>
In-Reply-To: <20261017155059.698368299@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 10/17/26 09:54, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 7.2.12 release.
> There are 10 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Mon, 19 Oct 2026 15:50:51 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v7.x/stable-review/patch-7.2.12-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-7.2.y
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
