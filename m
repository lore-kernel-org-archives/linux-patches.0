Received: from mail-il1-f175.google.com (mail-il1-f175.google.com [209.85.166.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A4082139B0
	for <patches@lists.linux.dev>; Tue, 27 May 2025 22:14:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748384082; cv=none; b=WHzCJwd5v7t8GQ/PNN3b74CRsBVdoxP3VctPk/q2d+6UuAQKMTsxKZj3/qySLts0Fl+URF7oLgwhZn0fmSsel3aXPsfUlvOzA+mXha9HJ+LXt5BQ/4hys/EoFeGPlx2BDInYIRu+91ixFl7kh1ohJr2D3+RY2nLejx68XLILY1s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748384082; c=relaxed/simple;
	bh=9udHDpAYAvxKPviZiivuKs3/emxHMcNVOQEErxHRjS0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=sSoPd4SF/vWEAd79p7a7MXogKryLR5KmyaqrUP2qRE50vW8T7ZiHjf2Y4lVegMTNNTXHksYII2ELJwtU0gZ8Yq9DhHOj+ICg43S+LhmM4amRtMmdjJHm7DCN4jYnuFafkVqgnpRqItoFs5hW4GmDhMyRjZ+pb2h/cqlsKNuABrI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DXlAIuIe; arc=none smtp.client-ip=209.85.166.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DXlAIuIe"
Received: by mail-il1-f175.google.com with SMTP id e9e14a558f8ab-3dc9e7d10bdso9463475ab.2
        for <patches@lists.linux.dev>; Tue, 27 May 2025 15:14:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google; t=1748384078; x=1748988878; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=lFjcs9eaUw90jHcgEZEicT+OU2FTsE9C+Uzz54aKOIs=;
        b=DXlAIuIe5u7kVHBm6/PWyH009VNN+R7TpslLjLpTDGUd8FMrH6ILyGGTE4ZWfOcQmj
         hXEL8iw0CCw1FFdlCihQw6luAotwU9vEOZta7e0ShiiGvkh7EozpH6Ehjt97PgCnIjub
         xSqFQXKHTb9hX0/fKfg/cAVX2EoliiuEyJJyo=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1748384078; x=1748988878;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=lFjcs9eaUw90jHcgEZEicT+OU2FTsE9C+Uzz54aKOIs=;
        b=N9hwNkP+XyOyodtb0K9CB75HmNdhiAqQQG/7aKTZIcm9gecMqvdGm0yquQIQiDfJzO
         huUvZ4NIW/trZpJ3usF3n7QbPgI/DWWbTuRXzStwQYFfgz7p+VOk1kdeFp5BblzLd6Tb
         7Me/tKY3jBQrKhA43+JSvyh57Q2wJtKqzau69PrIuFNvqSZvBq+/pYU2NNkppTI+6VYK
         JbKysDwIpQGjY4RSCMO9mWVoh4SbmVfwGTO24T9RZWa6fET/VpEPfrrt66pC8VCStE/9
         P/RjmWeAh0QH49oCWmysSlpYonPLNMOlaBvir0IWaLAAY2CNH9dJz8+sG+Scq5+7tolQ
         7mIQ==
X-Gm-Message-State: AOJu0Yx0jgAff3cJtodZLEX96NsfuJkdvQvxboH5MAR69EO9UC1cX50x
	PB4veHRDM70ApzHp66hcUcWz0NIzTcclSvelrtyYH0vF0Gn7sBkkWbr2Yzp7hnPt8kk=
X-Gm-Gg: ASbGncu1JTy5zjZI7boaodmmFolQC4vbKQxZkRpddS6cuTsGlBeHlhsUuF+J8Koi5MS
	dMkAYipoQZgpwiIYmxk3HM82s0XG4It9jue2jRYX3pYrT/v+K4P16JVVaPgjH//HATt7nW+TWPk
	1YIk1n7wJIf11dSyKpSPd9wiAcy5FHxi3faQUjBN00WOJWpcLK9Afh1uLyTmPPoucET7bYnHk8Y
	MnihIP7Kvd1saND9lPj7XNtVLOoaVTWQg8O4zx+HBuf4bqW6zr/uNyjRy1A+TJsui/Yd2edBcfR
	N7pVe3l3l72k00aru9pdqI0MZJ1s1+KfWoY+DZuJKDio7oMYcuYdoKOv40+bAnnUslais4Jv
X-Google-Smtp-Source: AGHT+IE7r/xzWEX6isdmF1z1Xc3VKhaKMmnxHU3LTROHn0/Zm9/kosE8qJWqlOrrf4zs/FMpG2JziA==
X-Received: by 2002:a05:6e02:1488:b0:3dc:8746:962b with SMTP id e9e14a558f8ab-3dc9b6e58d3mr143356275ab.15.1748384078310;
        Tue, 27 May 2025 15:14:38 -0700 (PDT)
Received: from [192.168.1.14] ([38.175.170.29])
        by smtp.gmail.com with ESMTPSA id e9e14a558f8ab-3dd89b833a5sm635645ab.23.2025.05.27.15.14.37
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 27 May 2025 15:14:37 -0700 (PDT)
Message-ID: <94de490a-3cf3-44f1-aab3-32309725725f@linuxfoundation.org>
Date: Tue, 27 May 2025 16:14:36 -0600
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.14 000/783] 6.14.9-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 Shuah Khan <skhan@linuxfoundation.org>
References: <20250527162513.035720581@linuxfoundation.org>
Content-Language: en-US
From: Shuah Khan <skhan@linuxfoundation.org>
In-Reply-To: <20250527162513.035720581@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 5/27/25 10:16, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.14.9 release.
> There are 783 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 29 May 2025 16:22:51 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.14.9-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.14.y
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
