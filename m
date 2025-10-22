Received: from mail-io1-f44.google.com (mail-io1-f44.google.com [209.85.166.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E573D299AB5
	for <patches@lists.linux.dev>; Wed, 22 Oct 2025 16:17:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761149849; cv=none; b=Ugkk04ivHfMSjM4SGpOdWBGjeY3JqD127acMFu53qGjSQOurLZhyKOlWTqPvrfgfbr4Zg2ZW20kXZTRiRn80pU/v4CUCbpxjZhFs1t/hVkgvdxVsf01SyfmB9kBy4dny0iCcAdRRaOlwGj7NtrpqBz/h4/5pWgcereicA6+RO8s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761149849; c=relaxed/simple;
	bh=bJnDcFIdIHGxiONbn2/mN1YrXxkCQ69AXDwYI3D7Ojw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=rgKPjGVr1S+GQhvMqpsb7/F1V7fPj9tGnN3cw0f0V963RmlG8O07iG8RiaJDV/1YxD5eqk3IzZFmtb3SAQMHmZxYvXWrhQdlmE3zK3IZR+4joyD/bJy9ixUwP9z5fExzuH9JVZm8rOWVFjegihaBFK9umIU6d3l7d6diajT/vDA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=I3gfUsRw; arc=none smtp.client-ip=209.85.166.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="I3gfUsRw"
Received: by mail-io1-f44.google.com with SMTP id ca18e2360f4ac-940276d224dso443732939f.1
        for <patches@lists.linux.dev>; Wed, 22 Oct 2025 09:17:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google; t=1761149846; x=1761754646; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=ohIPApBH9FOd6VfSJ6LwqJdcHsRV0vgebW42BSjwjLI=;
        b=I3gfUsRwRjlrmn99wSFDLH5+Qznu65DrgZEJCFvxeKiJ+s1aEdMw1i/RQN7IfoacDt
         Z4x579Ube44AyA/1ozZO+pIvEhz3RONkCiu1ZJ/MSzhLDZcW50vXY6vRJYLiTEhU0p2+
         UwBVERg3piaPWYNcR90wlJ7AmB1xvOYNB6Gmw=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761149846; x=1761754646;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ohIPApBH9FOd6VfSJ6LwqJdcHsRV0vgebW42BSjwjLI=;
        b=wptpLS5rexERg2R0XNYk+P+fqUJE4jmA+Kr+UlouECVkJbrBhla4hYJowpmEE0XIkk
         CJvT+l4dJct1xrgtWUztEi553WlJ2tzzk2Yp/o5fcMOQyug2Cp28XbNUYsMzFX80cqxj
         G7ZK+fNBg3XfK/P8Ftrk/ydmf5plkgbCIrdDj5C+TVzhTg3k67JGeHqie25miKYl+wBx
         Jyt/jVO7NOlm7FTmiF1k+3Ru9BDazJeqzJsBFPoXxKm60OC8F1jjM1UU17cz+vTEKsAR
         m4RjrWQT0pqKst80OqjZijFWY39J4SiIzQHLXqdS0xe9l9+tjYcrmwUYFYQNWoEbckUF
         JASg==
X-Gm-Message-State: AOJu0Yw9t5W+jt2gJRgrBAf30Q6Z1pcB4jYbSmtfzah9ALU+3xBd0hpK
	e5Lfx8fLE2Aj2O/SvPMOEwNQT8zQh956jQZkNdLVZbr3cwu6XpjSQM1iu6nqLnETIRE=
X-Gm-Gg: ASbGncs/+xQ2ZQ8ydKcH/hT+e7WQQIrATLr+rBhC/yjTqWB0CJ5WGV5OVpUrM072Rco
	0zg1tXJFPC30xlD3RlVd91+MPIS/l40z8eiUvzRZOqdQaxYtgw9FYMNHMMzmpWw5WmIG+oks8v/
	+AKEn6rOk4txqymhK1/dlJWnyOZylutMsEgvlrNW4mvGQK3CNLYXBsfqcBUJsfkqsKm/Xn468dw
	u1Q5n+KERYtF6SdkX1d8UNKIBffLHZHkC6w7w4LuMGU+xiI11pfaNKhfbErUN2RxH/eCf4PGMz3
	jP24+3idx0RQlBuHTv67bNHtfJZi6BYtUHm0i3ImMX5gq/UaB7mCGcTwJVlNdsPJkscMJ5DznYu
	sE5Lzuk78EGsfaZuSiaFUDjKSkcp1VJJ7FU83bCBsZoIyujKqg1CrpSSLKLCrqXie0iD6eGkIYe
	20/7CxziFuP1+q
X-Google-Smtp-Source: AGHT+IENId+3otkyvFCVvSbIP7aMnHBbcVmNJLxAqp8FAcojgNqEhNO66lf7DIELTcRS0+v4li/Ckw==
X-Received: by 2002:a05:6602:6416:b0:93e:84d8:429 with SMTP id ca18e2360f4ac-93e84d80763mr2540500339f.6.1761149845759;
        Wed, 22 Oct 2025 09:17:25 -0700 (PDT)
Received: from [192.168.1.14] ([38.175.187.108])
        by smtp.gmail.com with ESMTPSA id ca18e2360f4ac-93e8ca2d51esm469991139f.21.2025.10.22.09.17.23
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 22 Oct 2025 09:17:25 -0700 (PDT)
Message-ID: <e4ca190d-313b-4c0a-9100-9c351b1be22b@linuxfoundation.org>
Date: Wed, 22 Oct 2025 10:17:22 -0600
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.6 000/105] 6.6.114-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 achill@achill.org, Shuah Khan <skhan@linuxfoundation.org>
References: <20251021195021.492915002@linuxfoundation.org>
Content-Language: en-US
From: Shuah Khan <skhan@linuxfoundation.org>
In-Reply-To: <20251021195021.492915002@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 10/21/25 13:50, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.6.114 release.
> There are 105 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 23 Oct 2025 19:49:51 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.6.114-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.6.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h
> 


> Mario Limonciello <mario.limonciello@amd.com>
>      drm/amd: Check whether secure display TA loaded successfully

Verified that the error messages are now gone with this patch.

Compiled and booted on my test system. No dmesg regressions.

Tested-by: Shuah Khan <skhan@linuxfoundation.org>

thanks,
-- Shuah

