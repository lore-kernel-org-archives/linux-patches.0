Received: from mail-io1-f51.google.com (mail-io1-f51.google.com [209.85.166.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C2685286D69
	for <patches@lists.linux.dev>; Wed,  1 Oct 2025 16:06:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759334764; cv=none; b=Eva4FMLuV7H/NZNJzDlUoT6EzmyweisHBxgqXEmmrwbuFcY2SvTys94PlGgpRNZ8mNKzb/oeVsS4+Wnd8PojC4TvqhAHMOPZN251aq80bgbSPZ/r8NycgiYAdBkuIps4GTAvdJKMfYs8CkJ0VReIbGurn4DDNxgnVEkVwjlAXy0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759334764; c=relaxed/simple;
	bh=VJHEaNZgpUqWWb3y7GCl9yOli6rthjNjxN6lV8kjhCc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=ODZz7WhefNPrOeLNjB3H9757Yj5+e3E6gYwX5wr21P42q+RKsjCqwefQjmJ+5hKhAOse9hpsy/XMwXJxrD1gUY2em4OeIe+mfzwKmdM3yNmRqY0J9Nbb/H2SAsdv/C8etM8ft0Yr5m2sdvGOP+Q8zL5l9ZLjLImhV9dmLfCI2Sk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cpVItScf; arc=none smtp.client-ip=209.85.166.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cpVItScf"
Received: by mail-io1-f51.google.com with SMTP id ca18e2360f4ac-93607aec358so36952939f.0
        for <patches@lists.linux.dev>; Wed, 01 Oct 2025 09:06:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google; t=1759334760; x=1759939560; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=VcoX46bwfl5dQYwcLHAK7OapTp8NlFOAbc6NCmLaSLA=;
        b=cpVItScfnhImrFfszFgUkfxAqBLCmrE3E7TCMGG6vzO8a5rbvBCi0lQItkXwfrHr9G
         26Wcrju3/WuTMMQxxkRQRaon5HctMRGyMudVTvWfUEXXH2cy0NyjiKeugqFNczcvnqyG
         rdcbRhd7GeM3BYVTEKG3inlK+MAjH067Yxta8=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759334760; x=1759939560;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=VcoX46bwfl5dQYwcLHAK7OapTp8NlFOAbc6NCmLaSLA=;
        b=XkjKcHGrGvf10XYHejDYu4uc08bh45iCHtEwDT2Oj76iktdSV3NJer7XWDWwA3Hu+3
         1TJDZWgFwcko3c816BFPlRq8tJ8Up/1soCEOswTqJQNl147nae1DkTzWeX9zAdAe/b/R
         M5Eu1TKtCth3hcOyZBwhE8FPMtExHt9IdBtp3u0PUicqHKwy6HJnZOp0eo7nweORGzZE
         Mh2GfvNgJ7Poss9J+DSEKzZxd1EJUjTg4+jfIorTWx3tK5zl95LqjjCp0AkLh7oK/cBt
         gkRJXJ0+9bjfIUkQmj0IAynXYob3fwAD6m5Qb8TYzBZ6LIpiSJYSzqe7IiJee3Llw4nX
         Cz7A==
X-Gm-Message-State: AOJu0YzmSWWcSnJFnqE/zUV5C51e1g7HSGzwlLxEtkdMzoC9PZOjJgFN
	ZGg4D6tVA/FcPGqWY1FgioOoT55KGoyJDpBFDSgeDd02YXNbFFuQX0ZXdQhkeL5ynbM=
X-Gm-Gg: ASbGncsFBze0KZHcthDHJrLvbni+QpjgCBpYi7huQkI6koLpAy1A1H9uTl9DLCLR97W
	fVR0srMXxeBzDTuHVULUa8Z29yMeIuoi1ilfgZfs85onoBgWFr+PhnNHx/VZ3raQ26IJXALqTYV
	QZC7UQB3e32J1Sxvl+7Mc9IItEptcgNH9zyyOxfhCqVv1bVu0jTVoERUgaiEOa3JelOoRVDZa4J
	Nb8MgUcMOYGK7urGHWVwgw24lYO2XEZPdI4T4WMkQuYJ0poWZi9+vMmlTF6ZwrEqeV0xnz/Ms8U
	TSmRCRg7jeAo7jjB9Ydr+laRmN3Vpg/DxgYUY+ry/EKF6R9+vlFOtqE1W3mn8xjrS6bI3B2Pptq
	4AFdk3d8BQhV5z5v/bSJwXy+o9jJhegOvPBzYCiAnf3ktUy/Gy3dlOLrF2Fg=
X-Google-Smtp-Source: AGHT+IFHk4Xwk9RArCCX+gxR924eyLozP8mlXDS8m3rsfRvOu87qimTOaq2cLVy5Bc0FK8NNNeMH3g==
X-Received: by 2002:a05:6e02:17c7:b0:425:73c6:9041 with SMTP id e9e14a558f8ab-42d81617930mr55114785ab.17.1759334759664;
        Wed, 01 Oct 2025 09:05:59 -0700 (PDT)
Received: from [192.168.1.14] ([38.175.187.108])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-575e72881b9sm2514685173.47.2025.10.01.09.05.58
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 01 Oct 2025 09:05:59 -0700 (PDT)
Message-ID: <9c617b3a-7978-4906-a749-98d6ea1a944d@linuxfoundation.org>
Date: Wed, 1 Oct 2025 10:05:58 -0600
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.12 00/89] 6.12.50-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 achill@achill.org, Shuah Khan <skhan@linuxfoundation.org>
References: <20250930143821.852512002@linuxfoundation.org>
Content-Language: en-US
From: Shuah Khan <skhan@linuxfoundation.org>
In-Reply-To: <20250930143821.852512002@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 9/30/25 08:47, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.12.50 release.
> There are 89 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 02 Oct 2025 14:37:59 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.12.50-rc1.gz
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
