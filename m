Received: from mail-il1-f177.google.com (mail-il1-f177.google.com [209.85.166.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 30156213EE2
	for <patches@lists.linux.dev>; Tue,  8 Oct 2024 21:58:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728424726; cv=none; b=NTtsfTpFJWoGNxLyS1I3RPuOmDddMg1QDnnceWn+dkCLVh10gE13Ea5bztKyYO/YMG+0fD4Tp2W7GI4BVtM7lKwRlfkGUQedwU204vpdciJqWhWWjnBB54EyECZDpCD33xtxg6w1nGVJz8dTAqFcfyPFBaCPZpQIU2yywszGktM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728424726; c=relaxed/simple;
	bh=BDDiSW9BBX6xnOUh7/79lZgysI7A7Y8so7jKZf0yTV4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=M9z2nRTasdf00Qicw7sow4CyGYaXfLmRRHrB93Fy2aG1khnE9RFLYP1LHjBf7PFzkTKIqgpEQ5lr1/sLuHOXnCdaQpRVu8jIJAVKHEkncCjFYDhGMCs+eSZ40m4+vtd5WulxyMu/aORYcUwaUpeajPfUQ1M6MOOvOoNt4R2pNjA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DjuxEnIn; arc=none smtp.client-ip=209.85.166.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DjuxEnIn"
Received: by mail-il1-f177.google.com with SMTP id e9e14a558f8ab-3a1a7c0f612so33385435ab.3
        for <patches@lists.linux.dev>; Tue, 08 Oct 2024 14:58:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google; t=1728424724; x=1729029524; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=4S2vT+XJ6lAU0O0Dbvl1xT1xfiGrVvJLydXOgnwn2gQ=;
        b=DjuxEnIn4bglI480Sad1iwP7CIb4kSOanUbEhQxCSuqgYUBE5B2F8BOnsZl0wSxa25
         dkeS0UchtXtDNSm/obdX88F0hjaUixGvdVasW/EUe17Ezr6lytoMEo3G6P0pqmGh4PHs
         jSu5Q0wO9ZzBb87R4E1z+Tc7hkrMdkvTberBw=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1728424724; x=1729029524;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=4S2vT+XJ6lAU0O0Dbvl1xT1xfiGrVvJLydXOgnwn2gQ=;
        b=RisZ5M6pw8BRbYi5tY5ZDxnr+wqAKy+uFC64wi/z37VWfEiY1Hoxo7YuaQ+urL4t1g
         YQdrgf9bl/B+/YeZfTgp4Q/pbCX5O2KbVcwwBkKAlktGAyreW/sSJoF5Np4tjWV1OQ2w
         zHj0jJw17AU2W/SEBGNT1p54Z6WwjDdGqAnl3vZabgspmEda5eGPnXuUTnYMtPevV9Zd
         i1PCzBoxLVWOxpdNENEOZ9Ow6y7bW02SSl3/Ai2JFB64sVyYF/TbK/DfK/8u6aRQ1CwD
         4TZtLXaf9w/Gq14R4CZJ4cl8UdzN4o8THxEloq2rCvpSuTItZio+gdMpwOnvcIMsLq6K
         mgzA==
X-Gm-Message-State: AOJu0Yw6Qovr9G/uDgdaPfhct+JgPEpz9pkgUW9XKHuVHGzeNzFUUn0/
	IGHRgkdxIkEOYGEjBCVf7/NNunkbSIv8Z5/nPFe3womGDN931FzTOYlBi45pJPU=
X-Google-Smtp-Source: AGHT+IH1ggCXTbeo7PXnHHIwj+SZzzLhpIklALX/d/oiBJ5FvrShbiCfcU7w9a5bCxSKcJUiSz0/Ug==
X-Received: by 2002:a05:6e02:1ca1:b0:3a0:909c:812d with SMTP id e9e14a558f8ab-3a397d0a552mr3176975ab.11.1728424724272;
        Tue, 08 Oct 2024 14:58:44 -0700 (PDT)
Received: from [192.168.1.128] ([38.175.170.29])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-4db6ebf0998sm1811480173.87.2024.10.08.14.58.43
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 08 Oct 2024 14:58:43 -0700 (PDT)
Message-ID: <4882ef4f-37f9-4e89-b8ab-85895eca4cf5@linuxfoundation.org>
Date: Tue, 8 Oct 2024 15:58:42 -0600
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.11 000/558] 6.11.3-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org, allen.lkml@gmail.com, broonie@kernel.org,
 Shuah Khan <skhan@linuxfoundation.org>
References: <20241008115702.214071228@linuxfoundation.org>
Content-Language: en-US
From: Shuah Khan <skhan@linuxfoundation.org>
In-Reply-To: <20241008115702.214071228@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 10/8/24 06:00, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.11.3 release.
> There are 558 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 10 Oct 2024 11:55:15 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.11.3-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.11.y
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
