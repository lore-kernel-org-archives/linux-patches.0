Received: from mail-io1-f48.google.com (mail-io1-f48.google.com [209.85.166.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA89A29C351
	for <patches@lists.linux.dev>; Thu,  3 Jul 2025 22:13:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751580837; cv=none; b=SLtqgjsRJWHNSFELLfkRawGVq0jTv4xWzrfRzyOV4+gd2P6tDztHP34da+8T/7opn2UDJHhOjsqBhqS5+mKeOl2+Wd8Nz8utw+qrVdN6y5UHPPNA4nDxm90D5E9ISQombvfSMR4jRHYgOjf83G8W82dWsqhmDnIv0lKtQQ++7mg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751580837; c=relaxed/simple;
	bh=XBUgrUQQS2IqwX0+wTG19jVJ5Ci3HRHkOkCqjlNfFLw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=nl5WOX/cNwF2+dVNptiyWJ5O0Zr9pYSJ1Hk9ts0lfhui+aQTo6rKlGuZ507/YOWKgSzIrOBoeE7hkVcDXtd29rMOuaMOEIUFfctQQLrqiuljYV/7oyY0EabSxvJKuqKgp+UWeEExSxxgYTkgVqIb4RFNJbPZ4P7KmqD1gkTdfUM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UrzOKRNk; arc=none smtp.client-ip=209.85.166.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UrzOKRNk"
Received: by mail-io1-f48.google.com with SMTP id ca18e2360f4ac-86cf3a3d4ccso33127639f.3
        for <patches@lists.linux.dev>; Thu, 03 Jul 2025 15:13:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google; t=1751580835; x=1752185635; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=unR9qVJeTgB9WSoA50q1O1NQAOhKvwtm6keiADO3aKE=;
        b=UrzOKRNkxeAjBjkgiIsZFPcdxWUfW8YqWWGK2nlRtiJ3ryHcBeeUlcpP+ErDGl/zEj
         T8HvD1ycXAiL3jkM2GvcZvLWZqkZTvbGHfyXDwD9g5GriQGaQZRP3PoECQcosvVJtVzI
         CjotOL9hK9knQxJCk21ZYvR89bbkepn4SMnbk=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1751580835; x=1752185635;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=unR9qVJeTgB9WSoA50q1O1NQAOhKvwtm6keiADO3aKE=;
        b=g9FIM6VGy6DTja7EaOz86YUTzTDKiPHSE/V+pIWlSNuCrzaN+Bluh2zhOEPs/4MHO0
         EkL5N9f5E655zM/YJbfdWh54EncyiLwXA9m0G6aKc0CZ+geYAAUv086xjfU82opPNmau
         q3nq4iiK6YnB4B3e53DkuM4hAsPRBu6o9k9mQnyCTxNsqWUb8DzgkGZjyORxYhWtfr1i
         x6EyE2EVyKoC3zDqCf+gqlQDhF3I3jPRfHeS7wmax/Ze0/v0AkEuKczHPQ9iTGsVQ3ZS
         D2qFCYbbwAA4is+orHUNMb5TqZDERJrt6lfRYFucvsgDs7vORo7zDnjhIUoeF1Ca/Zny
         lsbQ==
X-Gm-Message-State: AOJu0Ywb3+nOIynXM2fkuiDqN7zYHTqOjDGrqGoyY6ZPAI04aeFAHWCv
	6E2KFDU+ltg1JJZu8vEabfKQjXLiRSAl0diEHAicySVL1np9c6f8HDylQKfLzYIVRtM=
X-Gm-Gg: ASbGncuH3QYCV+8jZ9CLAMUessDL+G9T2ggyaZiJyaPzEwnUgT3HlUWMn9cjqxeBfhx
	s2QxE3OzNinYOxsgitHFUZjG5fFplwxHFE27eL7rlrWBN7tgBNGh5op4BmQNsUkV8Bu1Eq7jRDt
	QvvHlofmsgyIUItjHxCbqCVVgGy3XjT2q4L6gXRMwUHxIDIy2P1N54gBt8BVd+Ls29sNPCF4m4X
	IQKnkpBATwAr5LMs7bJnloKvHcasntuq71kA/Zr0eJYusDypsvtFjb8b/fd0XPyPckZGJqpW8+s
	3fyRNNSY/CIjx7jZueEbw7Ibfp+l4c6Niu7HsgKt642CoqTAHy9jPIRbuuXHb2kN29SXHnAm2od
	aX+OoCtTq
X-Google-Smtp-Source: AGHT+IFTLPGUsvktoYg6kHPD6nYNhc4LkDTbKKI3SWfHrM/XXrmfE9LouQSm0Mhp4hyUgtiuBB0RcQ==
X-Received: by 2002:a05:6e02:12c3:b0:3e0:4f66:3106 with SMTP id e9e14a558f8ab-3e13547ddf5mr2083225ab.2.1751580834710;
        Thu, 03 Jul 2025 15:13:54 -0700 (PDT)
Received: from [192.168.1.14] ([38.175.170.29])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-503b59c7860sm152582173.39.2025.07.03.15.13.53
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 03 Jul 2025 15:13:54 -0700 (PDT)
Message-ID: <55497fa2-f6f3-4c6a-9869-625e5edfd777@linuxfoundation.org>
Date: Thu, 3 Jul 2025 16:13:53 -0600
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.15 000/263] 6.15.5-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 Shuah Khan <skhan@linuxfoundation.org>
References: <20250703144004.276210867@linuxfoundation.org>
Content-Language: en-US
From: Shuah Khan <skhan@linuxfoundation.org>
In-Reply-To: <20250703144004.276210867@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 7/3/25 08:38, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.15.5 release.
> There are 263 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 05 Jul 2025 14:39:10 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.15.5-rc1.gz
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
