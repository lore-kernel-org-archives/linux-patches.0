Received: from mail-oa1-f66.google.com (mail-oa1-f66.google.com [209.85.160.66])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 790002D46A2
	for <patches@lists.linux.dev>; Tue,  6 Jan 2026 22:56:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.66
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767740185; cv=none; b=PN6qIYfBvkRhCSR0Dqbk03oxPuSe8V+UVJggZiOt3E3DSkWDX180LE6qUqMMXSOkakXkMlGK+uyVwTSdqv0v2YiUSRTrwECXSd0CJxhoEYHNcwhPcApip4qXz4qNuoPclLh6R6SZGw4hxvUMPLth+SaWzT9k9llG0++N0TgN9iw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767740185; c=relaxed/simple;
	bh=A+XSURg7K9EwgUvytmexG4/kwwx+ACrDpqBOoY2K9QE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=HXxJ/T2AqXpwlx4zcKPuqSrHXzPOrRSyO85QW2+YjQF/+5M7BghIV4WCP+TsvKeMyllFf+Ec02oack07/cHkmV9+PjOR2axcrMiHWL7G8CIbatQFU841OII3GZskSP8hRcpIb5G20FO8g74gXL64qnbsewWDmlrzcIdNfjiwY1U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UnqC4gVK; arc=none smtp.client-ip=209.85.160.66
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UnqC4gVK"
Received: by mail-oa1-f66.google.com with SMTP id 586e51a60fabf-3ece54945d9so621354fac.0
        for <patches@lists.linux.dev>; Tue, 06 Jan 2026 14:56:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google; t=1767740182; x=1768344982; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=rlEgTGvQwC//J0kCOTtW9TufRYi3qibIbd/C3rGyaPU=;
        b=UnqC4gVKnRFHy/4xYQ0TXovypONUEhqedDS3zIgVI4J7d/avK9dQsE47VgmvYcYRjI
         9/ubh87fmvE8AhHE7ui6gdgRwTmklgeaf8ORVizQZBCUG0Qbqq1SWW/IUKuA5Ap8fyDM
         qN1A+b21xWpZyA7kWyl84T0KorMuswmJsRUDU=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767740182; x=1768344982;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=rlEgTGvQwC//J0kCOTtW9TufRYi3qibIbd/C3rGyaPU=;
        b=XPwxTudJqR5dfB+VTTKwSmsMhC6/y1tHkRJjlKrE8OdXbrOUIoP2+2XC9fVLRsQGHQ
         gUa7dq3Q/b1m1yAeOdlDbnKlBOLhNVP9K4V3EftxuPjcXjkOk53wq3KDet+h5yCwONEE
         xT2M2axLlimcqaLA6GYBnRfOxbDdQtCdf+0rFhVSm+iyrAHVzoGRMapXO3XHEF7nKlDK
         eTy1QUXKyud+hde2UtDzWVomlIDcxPS8ekBwvqW60Qguea140nBHcoEzAnFR7j/JQ7Rv
         we8UDbsPP71gf/t25Z8ffm9vZ6LYwypqtNxeRehVuttfoXyeS9w4iEuUpf5RTX7l/71q
         Pc3g==
X-Gm-Message-State: AOJu0Yzn07NZY63E9tByCeX097JdhaJ1CV1+AWEujEkiokSWUpw5RHTN
	N211aKrjBDT5q9ypgLnbj58GSVtUGPdXUbNEWod1phvHboSnDjL1wDITQgG7RGY6g54=
X-Gm-Gg: AY/fxX5FXZLu0anx0zrv58utNGuJRtK9Q7ndTI8oipxNxtozOtaRmYmFFTV/LipuXdG
	oGD+6HhQTC10g44VmlUKv25ekNFWVPNjB9TBPYFRakpoqGyddt7gnjK9bNpS2h+bGzry9X8H12/
	umlQNq/221RCT4fo8DwAI6Yy1j6Z2qv8DLgqqZBevwESke+K1DFXOwLsI1Van+TIUTVOXIJwUMs
	3CTWS2dDooQgJ7B1Nd6EVVPAuHxKOwtvKBAN8T7oUGg0nWbe6SRZ3d6ZMk+PhjLl3X/lMCHZbp+
	Pyqx7SADO7RVBTq+ExceON6xsSGjaPFYb1wpIN7sh+Y+khLRX5kBJmxkHu+U45G2v/Q7i/QXttx
	B0uPYCGP6IBzZdRx7rX4kL+40QoeJIHr54w0SJJ4L+wVSuUtsfm42m8QaUPlFC+JkE8YIfbFWZB
	AyDFuSRrYRJXUy5vg81uyPLNk=
X-Google-Smtp-Source: AGHT+IFAuV1BxuoZwVQSFSBXE5zpDFi9jBI42cEVmFxkFCru49vqQ7tHYN9dkhTgJRw8CjbAd0tKDQ==
X-Received: by 2002:a05:6871:739c:b0:3f1:664f:e8db with SMTP id 586e51a60fabf-3ffc09fa492mr292992fac.23.1767740182243;
        Tue, 06 Jan 2026 14:56:22 -0800 (PST)
Received: from [192.168.1.14] ([38.175.187.108])
        by smtp.gmail.com with ESMTPSA id 586e51a60fabf-3ffa50ecb58sm2056089fac.18.2026.01.06.14.56.21
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 06 Jan 2026 14:56:21 -0800 (PST)
Message-ID: <51c18a00-2ac6-46b0-be9b-b7b1587a382b@linuxfoundation.org>
Date: Tue, 6 Jan 2026 15:56:20 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.12 000/567] 6.12.64-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 achill@achill.org, sr@sladewatkins.com,
 Shuah Khan <skhan@linuxfoundation.org>
References: <20260106170451.332875001@linuxfoundation.org>
Content-Language: en-US
From: Shuah Khan <skhan@linuxfoundation.org>
In-Reply-To: <20260106170451.332875001@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 1/6/26 09:56, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.12.64 release.
> There are 567 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 08 Jan 2026 17:03:16 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.12.64-rc1.gz
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
