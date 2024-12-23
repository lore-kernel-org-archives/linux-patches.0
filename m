Received: from mail-il1-f174.google.com (mail-il1-f174.google.com [209.85.166.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ADE92482ED
	for <patches@lists.linux.dev>; Mon, 23 Dec 2024 22:41:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734993705; cv=none; b=aqYIzj/pGWH3asd4Yyq8RFfRukD4gxAQrCNl+8NdCLBPOiYaAvuGz0es54qPZYwxS7FyvyJaeZxn3jt+iRawpHOC08e0ILkrDTCxCDCWM/nJjGEurW6jPYIniRzhbswubQlHgWRqeKp327avt8qv5cxW2QhTKIE1piErKUNkMu8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734993705; c=relaxed/simple;
	bh=PWgG1LVspxAzFLHY/42aqwmCKRJpGNPJ7aFKCzRPR+Y=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Q91GUCZWfZtoGPxRI79PG67Ev1FS7gy/NHNiu3vGljDk/vd5HgzFmT9SAYebrxYaWMXL+lZfMGHXFu/zVQ2pRXMAuS5adHJVfDoDyqZAhKCtNUa5CfONtHjp4RHq11AgKLjFaZg5G7PKI8GON5Zu8Vl94XRPhWUkE/zWofgmKg0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Jcpj0LEN; arc=none smtp.client-ip=209.85.166.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Jcpj0LEN"
Received: by mail-il1-f174.google.com with SMTP id e9e14a558f8ab-3a9c9f2a569so35254825ab.0
        for <patches@lists.linux.dev>; Mon, 23 Dec 2024 14:41:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google; t=1734993703; x=1735598503; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=xxQ/0rVJwsXrpBpC8qULH3JqbRbkKBPMeZOo81XXfVg=;
        b=Jcpj0LENDDnGcHwqKxOxxUUs2l+isHX97nOXVCn+TU4DF2JFTCNT09FCdZN1kga8dp
         OZxl6qlpS2E1Y3v0lY3CjKGjxsB+o+hNzKR+RVV1/4B8zCg0AwxyJ3Zriow4JJFNzaig
         mJL58iW8d552ESVj7ILtbQU4BPkECqFR3A+MA=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1734993703; x=1735598503;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=xxQ/0rVJwsXrpBpC8qULH3JqbRbkKBPMeZOo81XXfVg=;
        b=psfBDU3o/b78wsk9g1v2uaw1ne+spIXmBLbO/vilQrevFLVKH0xWo6Vt9/VrKe/CMx
         qzcoFBiDybXAL+ndzVDYf2gt5XMB6onfE5wvpgC3OUW/4U5U8CTSJ0ZwctflJ2e9RQ+B
         v0y8arLbf2iJccmI3GAR9UjV7qb0aAKFO66m5Jmdkd+H0rArrUYMuoSxUeqFVKOudcod
         te/VlfYiKWG9Nh/3PXoI8ALdOrgBMqQqzZfZTb/Ce9SXWRNGVrRS+Ik4ir/uDbSfokbY
         9xyOVTW9+XN8pFhd/I8JHUi1Wb6zl8jI+OhGqfGCEpc7I2mtu+taJvgJgMppJ+1LtdcG
         NCOA==
X-Gm-Message-State: AOJu0Yx50EUs7gpINVEg1NhKdMGzlvxg7nHPwWmArdSEk6cifDrJPjr8
	Z/pQzC2/BXrbrs7iX64M3TBo+HSgiYqs5Y8iy6AQg+WOKS6u4C7x8GHBHP1IWhM=
X-Gm-Gg: ASbGncuQ7thj74P60lhfDahrQv9QxXQZtDuKhaJKF3/cfMje6Qu9rvjA4xXGNZlyKfo
	LUFHmP9Hr2sfUd/lR3Zcy1qgoKFDsXIgBiRLGbfWmxZ/hqw0WVclpJLkVggg+3kvWvSX3g5QPKf
	4pLwzlcZdLNXbCWsXslfHEVOXK2sdgHOLq3rJpLc594C51YBz1SleSgHB2yyhMIBiFS30j/QM0E
	TEMTjE8t4RaMgsJLLgfFvTeYqBG7xcu4WAlSp3DKw76cZk6IYILYaEQnU1X0RsTpfhB
X-Google-Smtp-Source: AGHT+IHDu36v3Qn3aWq/3rSXibFxSwNgar+s0Ye8l0hxH+V0OdCHe1e0mhddmap1WiO6DQF+OzQpxw==
X-Received: by 2002:a05:6e02:1aaa:b0:3a7:e01b:6410 with SMTP id e9e14a558f8ab-3c2d5151684mr141631985ab.18.1734993702796;
        Mon, 23 Dec 2024 14:41:42 -0800 (PST)
Received: from [192.168.1.128] ([38.175.170.29])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-4e68bf66f5esm2416544173.46.2024.12.23.14.41.41
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 23 Dec 2024 14:41:42 -0800 (PST)
Message-ID: <d8a84e10-e440-4f13-b5b8-90b5c3fc847c@linuxfoundation.org>
Date: Mon, 23 Dec 2024 15:41:41 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.6 000/116] 6.6.68-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 Shuah Khan <skhan@linuxfoundation.org>
References: <20241223155359.534468176@linuxfoundation.org>
Content-Language: en-US
From: Shuah Khan <skhan@linuxfoundation.org>
In-Reply-To: <20241223155359.534468176@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 12/23/24 08:57, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.6.68 release.
> There are 116 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 27 Dec 2024 15:53:30 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.6.68-rc1.gz
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

