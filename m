Received: from mail-il1-f179.google.com (mail-il1-f179.google.com [209.85.166.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2CD5127FD76
	for <patches@lists.linux.dev>; Wed,  1 Oct 2025 16:21:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759335664; cv=none; b=ERIx/JsMApulqi4DEgaxgm/iM2SfyBqEZiRCr00YVsMMB90VuaPP683WcY9/DT9bSOrdme1HzhdtvEYaJ4G906DYbP8xcNIbbFgWaGxE5D0YrxVHfiKxmyebGr4QTGQ5nrdv67rYwM4z3zj55Fc/IJL+Q+rAYX6AlSkOaDcGRU8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759335664; c=relaxed/simple;
	bh=dQwY8oJbnBTTFC31L8Jg28jquYZBGcZkQ4P0+XW1Rns=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=S+AVtzvl1Kt7s+A9FACJjabfHjUAH2sjgDmn3i1gx9T46ZggrROGIa6eRS7Mv+fv6mZ/hJbWSKufwFmdKANJGB95AiXlap1g/TzEI0/h8NJh6j4mnGwiJqODiLv6lK3W6jAgC7rRg3TpTXLC1lsyHduVEsjii22bIiKjwjeqCVE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LCDLp3L+; arc=none smtp.client-ip=209.85.166.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LCDLp3L+"
Received: by mail-il1-f179.google.com with SMTP id e9e14a558f8ab-42b99565146so4979625ab.1
        for <patches@lists.linux.dev>; Wed, 01 Oct 2025 09:21:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google; t=1759335662; x=1759940462; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=I0Bk/1XsHqvwUKw08M8vbOlRk6GNltlYfeCC1qY6aTs=;
        b=LCDLp3L+qRuC8nCQUEKdW51dSC+bI3DqvsIRMI3241ORyNjOOjYNDmgNFH4mtYezvB
         q/2QG2BiY/aUp/2YR2Bi58++bkVIihSvf82E/1rAM2kcl5IsRdGF4vEUNHW8Oe9hLSPb
         4uupe8+K9RDIygt8El4+4EPzOrlegPcYg3v9I=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759335662; x=1759940462;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=I0Bk/1XsHqvwUKw08M8vbOlRk6GNltlYfeCC1qY6aTs=;
        b=QWhbLMRnJD3oYUkfASC98zZMxZ+V9mYRiuIYzyntzf24BlL8n6fFHsHGKHgLSPROVQ
         A5PQMmtKO9ba8MkwE8M1UnUTIzZSf4WTDmGDscwhMVv93cGi10akkc5MWZbp/H6a8q+P
         xEICOYPZM3AUBKb0ugyd9zf29eRSVRoXA1mveaRLBqpsjLyk9NxTw57YtkVZ5Fpv4dh9
         oZJCJIGljs0LCfDb88M+7qlRsxfOFZ2FZltdiPU0v6jzYefv/VEB6PJ8Q4p0VMXOAW/l
         siPo9ArXlSFPB6XsOUr94Zh1zKsmsLP2skxgsd30fvO/V1aO6BSmsjQJG5niaaP+x45T
         v6YA==
X-Gm-Message-State: AOJu0YwaPC+jFDuB7yx2unGrR41b5Ctwc2fiVj/e50fh+lPXVAgO9D3c
	5LFxKfnu1yC/AWZBwHUo1VqTie06pUnf3OEPm9yS+Fh7C5Ezm4b1kdDRXLybBCs1z14=
X-Gm-Gg: ASbGncvHbEjKWr5K2sovbbcUtTY3F0NtLm1aJxG0tVDYQhOQWCdYGw+8Ei634IZ5jJa
	b89FGRMKnEyPVCB8gV/PzaxiU0INNFHlIJxOQg5Z6Q7T5IStYy/GdYErWiYldMIlitBpenvHXY8
	6XxbdHg1gG8Kyv42QyDUn1ON/5/9wtwT0r5pJV9bNfHqQvUhDHq8Md7MpuQfLcpHd8ye28HN94Q
	VV2EDD2U4WeeBO1nq7brU/qfznKIVPWsAf9OJES957e4GM1Hemyhp4hre0Uq7kVplD8Tgu4G21c
	PeeA9S99GZq67nfl65afmL56GzWnEAYd8aeyV+4J3rflrl7zr7USG+sNoNat+0nCSlOtv7qgCtQ
	4tIJJJZkyGd99OKXTBaSUvAkbCnOuCtgV+0I7xPnWpUGa9rKciXKAhOZ3m18=
X-Google-Smtp-Source: AGHT+IE5vkMaEzImU6yFMmEFTvIP5csOxBViu8ui15pbJItIu0M0O39f8AHeTTk0IGXWIMdNvHoLTA==
X-Received: by 2002:a05:6e02:214d:b0:423:2666:4687 with SMTP id e9e14a558f8ab-42d8b1e1a49mr2165795ab.15.1759335662156;
        Wed, 01 Oct 2025 09:21:02 -0700 (PDT)
Received: from [192.168.1.14] ([38.175.187.108])
        by smtp.gmail.com with ESMTPSA id e9e14a558f8ab-42d8b281664sm299785ab.25.2025.10.01.09.21.01
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 01 Oct 2025 09:21:01 -0700 (PDT)
Message-ID: <1b7e8b60-faee-418c-ad23-c2e659ffd03c@linuxfoundation.org>
Date: Wed, 1 Oct 2025 10:21:00 -0600
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 5.4 00/81] 5.4.300-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 achill@achill.org, Shuah Khan <skhan@linuxfoundation.org>
References: <20250930143819.654157320@linuxfoundation.org>
Content-Language: en-US
From: Shuah Khan <skhan@linuxfoundation.org>
In-Reply-To: <20250930143819.654157320@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 9/30/25 08:46, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.300 release.
> There are 81 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 02 Oct 2025 14:37:59 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.300-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.4.y
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
