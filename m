Received: from mail-io1-f54.google.com (mail-io1-f54.google.com [209.85.166.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D5D0C155739
	for <patches@lists.linux.dev>; Wed, 24 Jul 2024 15:13:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721834011; cv=none; b=Bnqp9gxEnFGx3IhpYDvUzJhucionXKG0JSPow5PU9+NbfoVrCmHBBxB4KMy6lPA9vYPKJuKVIG7Z6WoL0gO6VzmngNweUQ8CgbBQfvqPbm2jtOnfAB3cJaeS6JR7kMaWmtyTR5qQRrnzJpskHEEDOP3O0TxPr/qaT3V+mMOXujg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721834011; c=relaxed/simple;
	bh=PiKiMeVMpEMyORv6wqPxrhhwhf+nk3ai60FMDdvmZ1c=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=C9+AIOUlBpUb905Pwj+6xWxWAD4BmUbYA/xMRLHkbjSOSCfFMIf0JHmE03EznD2RUUSN6hEsCF1lrUOllvv6pbi/fYJBu+qVTOQizoRWnMhsEhVvR9YgzZWBvo1YHAPHTA9B9PG6NlO/vHvuSG6K0snAvCw5XC25Y/kQkkqv/h4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MDl4j12r; arc=none smtp.client-ip=209.85.166.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MDl4j12r"
Received: by mail-io1-f54.google.com with SMTP id ca18e2360f4ac-805fc096a34so31604539f.3
        for <patches@lists.linux.dev>; Wed, 24 Jul 2024 08:13:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google; t=1721834008; x=1722438808; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=izbTRiVUnoJj8uduUMVBVNFl+ePHNjaDWB/ZfOAgS4E=;
        b=MDl4j12r8x6fnI6hD5CCh2WfJ7uMsSSJzvnD3go4NLvlZmZ4cN1MCSok5vfKh6ESSJ
         eXiMw6UolaED6KgPYmiCDT9gXTt99JzQeJbGJkhBZcIVEZKh8ShAQ90CTodXoA5B7H7M
         AZNO9KbOc+3B9UmZr6V41X+0vvt4w4cHZnOkw=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1721834008; x=1722438808;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=izbTRiVUnoJj8uduUMVBVNFl+ePHNjaDWB/ZfOAgS4E=;
        b=LmOci/Nbmd/By2EiIK4dkJSIpznD9AfzbZtpCh4WccTQivYrvDjtz0GF1WQ75/lSL1
         Tbz5wOy/VmuzseBnY94pAffpfCFgzCzX+pl649XgqcuTeaxk25O5ZWx4P6znXcnsaIzH
         tPpYIOkYgUdnns6VT7Est9gQ9GjqWroU2J3TX6CHv0QgdpfHTUIY8VYmK5Xi0V1ZcDvp
         Csi6n0EKOLcjwr+XCmM5Xx0tQFJnSVQp2t5MrbT0WpnteXoEveOLC3cD+IZE8XqVgi/F
         9i1tUxByaiPJRgUJmdHrLoHvpgfM88BpnDC+gK2W2IlvjD0ArlCZ/b3Qa311LDlNCqJ6
         /vxw==
X-Gm-Message-State: AOJu0YzTd6j0vx5bSBEIdXikRpWTj0DQRh68DMBmio82s0kypKlbACfv
	bLgmYSY5PfUWCE5ER91yyW0oaDCbePXxpgJfrIK9u3AOOpzrfdj2H2FsH1E+SIs=
X-Google-Smtp-Source: AGHT+IEUr2/8iC/dgeBTNLSWyU1KAMScdHfHVYW03/ZVZBKEuh831Prbb8KLZ6d9w3RyRON2TbDAvQ==
X-Received: by 2002:a5d:9f5a:0:b0:803:f97f:59e1 with SMTP id ca18e2360f4ac-81f7bc78dfemr13570839f.0.1721834007941;
        Wed, 24 Jul 2024 08:13:27 -0700 (PDT)
Received: from [192.168.1.128] ([38.175.170.29])
        by smtp.gmail.com with ESMTPSA id ca18e2360f4ac-81f7158d724sm53731839f.1.2024.07.24.08.13.27
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 24 Jul 2024 08:13:27 -0700 (PDT)
Message-ID: <671007f2-d57e-49b1-91af-a4e693f11ac5@linuxfoundation.org>
Date: Wed, 24 Jul 2024 09:13:26 -0600
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.10 00/11] 6.10.1-rc2 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org, allen.lkml@gmail.com, broonie@kernel.org,
 Shuah Khan <skhan@linuxfoundation.org>
References: <20240723122838.406690588@linuxfoundation.org>
Content-Language: en-US
From: Shuah Khan <skhan@linuxfoundation.org>
In-Reply-To: <20240723122838.406690588@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 7/23/24 06:28, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.10.1 release.
> There are 11 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 25 Jul 2024 12:28:30 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.10.1-rc2.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.10.y
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
