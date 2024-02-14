Received: from mail-io1-f44.google.com (mail-io1-f44.google.com [209.85.166.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 46ABC7F
	for <patches@lists.linux.dev>; Wed, 14 Feb 2024 00:15:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707869737; cv=none; b=KIN/GDx+JptfrJvSCHnWsdEYrIGRkXgOD8695ALFP4hhf+tBuLL5IuZHDTsoCmalKh5c1QDLsf1nwWQZhstvWbb/1qZZSKdnNedYqayPimyyIgHRIyLkHS9EViYBlATWU5nmztBZ7NVPhW8TYjmupi9P6+McdMuJF5KSy+BGFIY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707869737; c=relaxed/simple;
	bh=e/JPk36YcaAkB2eASchwf/O4/pt4gfV1CfqC3KKqLck=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=RLYiKXk2yVpULnA99noElaMT95rugpcqZ7YH34qmCYICrGZpzpm/cbgGnehEM84ikUIFgjIbAVI/s+7Eldwm/7LvWbxfT3SDtcMRRBdGDzNI1pYwPWtNA8yM49YdjcPHbuYsI6JLZV/IPJ/Su/PRz0+JMX3Z4f4uGGnNqobO15U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AoVY2GiC; arc=none smtp.client-ip=209.85.166.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AoVY2GiC"
Received: by mail-io1-f44.google.com with SMTP id ca18e2360f4ac-7bff8f21b74so50916739f.0
        for <patches@lists.linux.dev>; Tue, 13 Feb 2024 16:15:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google; t=1707869734; x=1708474534; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=P2dMR0dbccb+q6sxSnuzRauid6CUXOmO7gipmGVqwVI=;
        b=AoVY2GiCvfgNLuv99r+EOvArgNIxKwXPShyhl6YfZuFeTRPeNmxUjN0hvXS87TcJf6
         UUvfdNMfWpzRZZfcvezL8d0/lV5DLVj6ipucJSRq2e3mV3pb6W4y5Epy+d04DD1vJZfy
         iwG+gKc39zWat/SafMvM+94VDUK1KfAsSfXkc=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1707869734; x=1708474534;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=P2dMR0dbccb+q6sxSnuzRauid6CUXOmO7gipmGVqwVI=;
        b=Mewdi9NNV7bS8bixINFjwXZJebjIZ15oZ/uc4wOXyJNA/acym0IJe0F4RSpOh7UME8
         Ir8V4UxEIi3JuqW5f/lXBSmL6l5bPdBdn8qCDZ2OO+oi6KCgXtOWY4SODatlgxrgbfl3
         VLUOKAI8YrNcnTh5mYxt28o8Fuu+jbFD+FonKHJMw5iS5IFqFO2EP+KGSWoCmdrkGmXB
         +Qfgv0HeO6T0571DUpUm9e+1e+3YS6xY+JZpPkahI+7WAPc1Bewgv+TrCRWk53my0oIO
         fTKwsSKUbFTiO9Mm+w1Vn0LHc0LAjRrFdKDCBCfIAp2Xa1ifLJJC/dejOhjFd6oiBMUt
         wGfw==
X-Gm-Message-State: AOJu0Yz54zICzK+BCLQkRBFnScvuFYHJ2rnv+9Makr0qTFYdhwNUjOlq
	/7chtb+BGw4Rxr0RsHCLXKAPkZyCYKrT0kbD6PrFmElwuMTju5YT6FmAaXiizGI=
X-Google-Smtp-Source: AGHT+IGZPxBDGfs1GmmWPdgYBbbuzmh0oqNysYe208XUtrQBS8ruPHHgQ0FygG9avlS6AY88n1HIyQ==
X-Received: by 2002:a6b:ec1a:0:b0:7c4:8398:ac64 with SMTP id c26-20020a6bec1a000000b007c48398ac64mr413794ioh.1.1707869734360;
        Tue, 13 Feb 2024 16:15:34 -0800 (PST)
X-Forwarded-Encrypted: i=1; AJvYcCVoTjLI+7jQTSlcz2sbv7KXq9AUXRKEHCUIBP16b9E4j7pskLlJlDZ9IEdtWsLsmQVZWrww6JzE1txJTPJVH3MJTVv5ydQcdsJGIpbKgjBaZJcA8FEl3v7O7fhDZ0NSJsZh8hrRcL1GD/+MvtwFSYdplaRbm2u3zc2RhGJHuHH0EZIvjxCbQvIt3HzXhyz3rIDvetV7UwsskUB13liQdl+iGJerRZYxqtcylOFcL2bTww4+EESP5/USLOPr+6eZ1YhYBdH+7BbpgAn3EcitWCpQZn3GUbzyhHiIaSe4tKOsfyJrzN3Gr59gVejYLM/a4EjL3UcdK83FTk96hEJbk1FDXiwhU1k5wdLDyqctQUX7Hw903pbgV7+tsIgTlGBPY4JEX295XkHm0L8r4wezPiYeM03SQ25GIwUiegekayXJIkpiDlZTjULPZOuckAGwy286xe+2G4WaWD3ihzXA0nrxyVgxXlFGMY2NVp7SEKDcsQQkL6gx469uc40SrFpikyITMtb8CwlYM8n7ydK5dHzKtJIWzD3REkdUQwm3wA0ALLku9Iaxc1wWPuRYViDBV1+iW+bBNNBSxQ==
Received: from [192.168.1.128] ([38.175.170.29])
        by smtp.gmail.com with ESMTPSA id b1-20020a056638150100b00473a063fe07sm2003035jat.118.2024.02.13.16.15.33
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 13 Feb 2024 16:15:34 -0800 (PST)
Message-ID: <d66a3b58-2cad-466b-8f6a-cd6a10013b65@linuxfoundation.org>
Date: Tue, 13 Feb 2024 17:15:33 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.6 000/121] 6.6.17-rc1 review
Content-Language: en-US
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org, allen.lkml@gmail.com,
 Shuah Khan <skhan@linuxfoundation.org>
References: <20240213171852.948844634@linuxfoundation.org>
From: Shuah Khan <skhan@linuxfoundation.org>
In-Reply-To: <20240213171852.948844634@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 2/13/24 10:20, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.6.17 release.
> There are 121 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 15 Feb 2024 17:18:29 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.6.17-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.6.y
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
