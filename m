Received: from mail-il1-f180.google.com (mail-il1-f180.google.com [209.85.166.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 279802397BE
	for <patches@lists.linux.dev>; Wed,  9 Jul 2025 18:21:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752085320; cv=none; b=M2hpnsWMHZ1Tzz6T7y2Zzi9voDhKfCq+8MzQR7i6xVV/lRr5w8vEpusB1Z3MgGBYuzRVbd5B4kWjXgwacVTxZz2CNi8e0EFfEaEM/ABc7xOntKn3pxx9tEboHL6BNiGHMa5smSUK+9RAI5+wqFIKzgwu79hOe52K0kOB/v1TuNI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752085320; c=relaxed/simple;
	bh=8LvNsabc0my7V+hNxMMtYFnztRuOaqiig2opJPSQKqA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=OxEU+oc29LovSEbihbtbTaBBWyPFYvHHCsNGqIFgEOXBAhZKNfML4OQfYcV6Ti+GtnuLTL/Hib4IOU6MVHkN0MzETlm6J3MERrG4dbznfrvwX6ajlWYvFuGecq+wnkGkWKsll2C1Wu/vlAYl+cOjgRaWolZ+idMuXjXMbdFKMO0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=H6bWFBKL; arc=none smtp.client-ip=209.85.166.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="H6bWFBKL"
Received: by mail-il1-f180.google.com with SMTP id e9e14a558f8ab-3df2e7cdc69so459895ab.2
        for <patches@lists.linux.dev>; Wed, 09 Jul 2025 11:21:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google; t=1752085317; x=1752690117; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=PBRfgTf7RIgKnJwuu7ZvDO6OZoixjZPMxFISgPsX2vc=;
        b=H6bWFBKLrrethoXJ8by6Ld3kCFtUX19AxO6Zgs0aTjGXv/tNFTecjJlmBkjdbA3tHL
         Ymztc1G3HoCqMqNZAsguQlE/VGrmPfUsdfB0VHKC5BckmygiO1dt0tbG35AWfxr3xogD
         JBvxqJn49t8XkZVwmL63l5ilgiacvzGhc3iQs=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1752085317; x=1752690117;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=PBRfgTf7RIgKnJwuu7ZvDO6OZoixjZPMxFISgPsX2vc=;
        b=b/aKYuGn5Puvo6w/1fzxrZxRwgiYfzM4hrNpWDytkjFhpCTmAzu94dekFCCm4br6mO
         OJA/5kw4JPFRK+Dp4kFF0rDEoGHcr8q7kKFHX2fTdee+UI/+7G4DHrToL4kh4M8bSYzN
         k/BI6QeCkQP+QaU6f2sU8kNIzhAJVO6F6kv+G3tmVgh4qQ1jzIDdTtURDs8RWDryqyMG
         OADzKoACM+zEH2P7712g5rDB4SbYW9odVzugBqc270+Qwd+8wItQfu+UVgdB+4QnpnvL
         BuCYnc9c2HkZ/dH2JdnQDwtOSw0cyNnTNRPc9saTUlLUfkLFraQ/WNeoDDf0X/KrKjAz
         Yqrg==
X-Gm-Message-State: AOJu0Yz6nZ8jYlIPE0NQhue2135R79654mtoAXZ+JwtPi/a95p4hLIW8
	KxXhoAJtvCp94YsyzyeBqca6t5frdi3G8q1bf2Lk+jeoYIe/a1jtRKF52/sQut0jj4M=
X-Gm-Gg: ASbGncvcXCeiZRzXcFRYYfyPUghsgkeb6jGeSt7pPNkKeIR/KWgd75h5vvvvI7VIDIr
	WqEYvWS3gmW7vVCOGz+20R8qgSqSBm0f2+VUWHjESEyqSQ3mbp59y8vV2WpWraqKdDuibvFU6Tp
	+hfyLVSVbPiExvN5YrQugeL8vt6W50JXjv7W8NJtZOCgYkgae4LjKpmGC2fplmZQZB8qCzyHIMB
	97rTzcocT5BGHIq3UlHsMQEF6w5+En2Rv+vNav8yGcJnMTZHEpCE6+ekm1GwNMT5H0Bi+rk9dBX
	lTliGMNYotWvUp+wTNJJt2cG/rZ0UI5fpcrMJSDVEoVTdIf82FvjLkjE6tDvdjZspqY3xpGoVwA
	AdRdnZzWV
X-Google-Smtp-Source: AGHT+IHiWna6bSyXG2HZPU9BES5Uu3BzehbrD/ysyplTdibJ/xd0zNUZnSNOWYpFqmRipgJGKDYT9A==
X-Received: by 2002:a05:6e02:3487:b0:3e1:5f8c:10e6 with SMTP id e9e14a558f8ab-3e243ff1490mr8804495ab.13.1752085317104;
        Wed, 09 Jul 2025 11:21:57 -0700 (PDT)
Received: from [192.168.1.14] ([38.175.170.29])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-503b573ab0fsm2823317173.0.2025.07.09.11.21.56
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 09 Jul 2025 11:21:56 -0700 (PDT)
Message-ID: <a7227104-f537-4e76-b567-4b3e3d3306aa@linuxfoundation.org>
Date: Wed, 9 Jul 2025 12:21:55 -0600
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.15 000/178] 6.15.6-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 Shuah Khan <skhan@linuxfoundation.org>
References: <20250708162236.549307806@linuxfoundation.org>
Content-Language: en-US
From: Shuah Khan <skhan@linuxfoundation.org>
In-Reply-To: <20250708162236.549307806@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 7/8/25 10:20, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.15.6 release.
> There are 178 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 10 Jul 2025 16:22:09 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.15.6-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.15.y
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

