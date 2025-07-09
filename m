Received: from mail-il1-f170.google.com (mail-il1-f170.google.com [209.85.166.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1CFDB191F92
	for <patches@lists.linux.dev>; Wed,  9 Jul 2025 22:12:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752099133; cv=none; b=SrV4MS7r68NIgnataEvifc/h/Wa0pWzkY40zClxXynoAWplMP4UHe6zYpLZtbpm5iayKZENVvu175jM32LXkHcM1lBHuLNwtRsEU9rLSN0ye1fWVunkI4JgElJ3YC6bVFbusAYf+U82FXVAUKkv2MHtUBftHJIr3uQWCKCti0bg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752099133; c=relaxed/simple;
	bh=BuNQ2mYEgeP55do80Pv8brcXDATJKUwOVb1q83oWXGo=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=BUZbjfbwkn+E8BcpiL51FZ6oavwPaaOA3rQu6f3CDOaV84hfgjWYEg1Z1M304fQYrrqdlylIJ14hZOSUHKDFQFasu/DZtKqXMSXUkVLMMSYhDKnBqfKwoXb1zlbI33OxRX3Agt6PcgbTC4GO3F1GVPnwt8XR0/OToR7cA8GE7HM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YlfGF3KI; arc=none smtp.client-ip=209.85.166.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YlfGF3KI"
Received: by mail-il1-f170.google.com with SMTP id e9e14a558f8ab-3d948ce7d9dso1885005ab.2
        for <patches@lists.linux.dev>; Wed, 09 Jul 2025 15:12:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google; t=1752099131; x=1752703931; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=TIxrKC669NC+k5Q2PskeXiZ3z1OvgkVukHTfy6+bNlo=;
        b=YlfGF3KIoSvlle23uB7HBbLn1OJnGuv+prxZhqqtiWBrPGr70sS1hETihWhaeL8Aqp
         R0yd/rR2Y63FOXdPi5S8ffsaK9kVdJhMXma2XA1nxAbeVMSgXsUl/tJjXsY/5pPgN2EQ
         AxggLDTQoJoZYcaxZ42R7yK9a/y1og2sE/jMY=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1752099131; x=1752703931;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=TIxrKC669NC+k5Q2PskeXiZ3z1OvgkVukHTfy6+bNlo=;
        b=jDvvX4ivlBN0gUPCfOigzaUSWAZJ53SoRXP10kpbj2xCQ8JlEHyR0324fwCt3MWjXt
         r45WoUgVl1hUSFP/ygxgah2Hc0TmOCAoUoeoh+gsGLaWCTLcXAzBBX2XtM33LLTCLS9w
         MzSQPjFiwz800BU+4q04fFISTopZf7iIUex/Ye8fBo9l01ceadxG9YzcTvguNl8dZe93
         XMoEw/zH973UiOnh0WQ3+DO4qiAh1m75waWmGPYvZTM2wcV6kucj0jHrz7RiktGnUejw
         VTxqGoPeLM1MbfOs+ePtYV53aVvqdSig+HZ9bH7IN+7bDmZZI7fxSx6nD7fFLm9itnic
         YoHA==
X-Gm-Message-State: AOJu0Yy5itHfPuUESd74EEAkD7tODOI8ABu6biD1Wh1CqlMdK2jgRM8S
	ZegGuTS/yyny+foYOyiCJCjf95hUVVxm5U7AesArJCL3qh/GFEuXyWZViVq155BAta0=
X-Gm-Gg: ASbGncvXfN+CSdUc71TJVYkYnuhw1SnRxuE3G0aj1FRicWnxDGGBFtZqVj8c9y0BSSQ
	Mw/Ct5wY/kFb79kfiRgSPdnb5u2Dc8aG62nuzLpStQbW/F5dkzUjE8x0JaJJeFwsGFqZ19SPFZy
	2aMrZQFeVQhwcggHYDMtFUao5Hr3Ef+bfa5jJ8WYu7sW1wrTAGGDUFCJWLOAhMgTF9nRV55j9yD
	nWYnRbrlZyp4nozORCKMLogXE8gf4wLZU2FsEL1kl7Yx6obx8wfTirmsy0npA6brathyrwP689c
	R6OQy44izYasPhTHdYB3sZx/hoMXGcYfV3bj58dzABOdTD6qmGOYRfRQ9wQxTo3k0DdgUTyM1zE
	xBdI01DGD
X-Google-Smtp-Source: AGHT+IHaIzZWNqOEEpYPr9Qs9PHjSIXPHby13nHFbqDrTCwo6xB3iLAn/fUooRUkfxxOIKQ+Pk7Eiw==
X-Received: by 2002:a05:6602:14ce:b0:861:d71f:33e3 with SMTP id ca18e2360f4ac-8796938fe79mr35681539f.5.1752099131134;
        Wed, 09 Jul 2025 15:12:11 -0700 (PDT)
Received: from [192.168.1.14] ([38.175.170.29])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-5055659d231sm45091173.52.2025.07.09.15.12.09
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 09 Jul 2025 15:12:10 -0700 (PDT)
Message-ID: <0e3d9928-cd18-4683-a71f-bc7b0d9a83f3@linuxfoundation.org>
Date: Wed, 9 Jul 2025 16:12:09 -0600
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 5.15 000/160] 5.15.187-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 Shuah Khan <skhan@linuxfoundation.org>
References: <20250708162231.503362020@linuxfoundation.org>
Content-Language: en-US
From: Shuah Khan <skhan@linuxfoundation.org>
In-Reply-To: <20250708162231.503362020@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 7/8/25 10:20, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.187 release.
> There are 160 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 10 Jul 2025 16:22:09 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.187-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.15.y
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
