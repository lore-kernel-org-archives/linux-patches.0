Received: from mail-oa1-f47.google.com (mail-oa1-f47.google.com [209.85.160.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E2A7A3822A7
	for <patches@lists.linux.dev>; Mon, 23 Mar 2026 22:14:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774304068; cv=none; b=HQW2KtGOoWpvjtmgSv9BvuuLdP3CNqRB7V4/ufHEIapSdCUeid//4LHlC4JTroaEmrlfWZkPgj+sIiHvG5o/tWLVVBEoc7ZWMa1b/GIIf6HDF3J+LuLFSXIa6ctDyBKNMZETR6nAm/ZjZmOXIZoneXyHWM/2bTC3TXm2+fBC9ls=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774304068; c=relaxed/simple;
	bh=u45GD6ljkZzzO+s25gIyu9x9FXNK40ZR6rWB92rZkB4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=UzTMfsf3ExoN2oLP11RyLbNcrmyL7EHOltvT0x6mRTdehsewrBf/cHjTaBXUphiEJCQe+g1v+ZkNqSEPG73ue+/4dkFT1qlof7TYxCjGYUkJo/CddeBZXz27W18IdGervlKHZF4HazXphxm66z5RjKi8FCnHj1DIfnl4jN1Cm+Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YOnLrmvl; arc=none smtp.client-ip=209.85.160.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YOnLrmvl"
Received: by mail-oa1-f47.google.com with SMTP id 586e51a60fabf-40f387a688dso3621994fac.0
        for <patches@lists.linux.dev>; Mon, 23 Mar 2026 15:14:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google; t=1774304065; x=1774908865; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=ChdMT4MylejAuCZm+2amkaY9v69TqoANZkATUoAewQc=;
        b=YOnLrmvl/Fw7OXlBOHsv7cfqfwxmXPbjVONoMlsK8oDuaWZyDWTa9Kk2CoHdsaRBwu
         xuf1Tnc9lSrsPJ8RBeTHnQBAjJ0kS2ciws4hTwynP/AFhriXbP+QIfh1uwPP73JPbUxQ
         c2qWVmdyhOiErhhBTrJVVv4Pcv0hPkcGcc27E=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774304065; x=1774908865;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ChdMT4MylejAuCZm+2amkaY9v69TqoANZkATUoAewQc=;
        b=pPW/l30eCIoLaARxZZB7z4OeV0nnXNrLdWiWVBojqlGmLjcEd3UP56TpKHEsDYqL6q
         Vpr2RpnDmnj1/2iVN5Ne4CyrQPbIq63azZe1NtWlPJZjoA8/7twlEayZVXAV9Yu5VoDP
         /coWEk8kocgdxu04m+b1WX0SRzj8FXqLfyaf6kjhVGG6UPxk1HGRd0baB++6Q1xG9X6f
         DVFU+ldRKLDR29HUC/jF2GyGD79DlOdMt+GufJQ2Vk6GzUE7SIZytQMNEHTHwjV5lcXO
         fdfNtKW+t7ou3TOW30Yxzez4o8/6dRWv+Sb+hkMi0jStAcfB5MgHoT3tLvL61dO86fvX
         OYdw==
X-Gm-Message-State: AOJu0YzeQRVyBjhwFcrsJeFQKNM3XrE+eqq1avu067A3fOiKO6HBo9Ov
	R8NymGgKDLFG7MacQ8OQW4KTJ7+/IbFkAfBknED/sh+4bBQml4KHbuK+qyKKef43Ph8=
X-Gm-Gg: ATEYQzxhJlmjUDIPuSJGlyQmM6hThBmjaB8RqCg3RDf+8LB89zbwpQW+25uPI7yPb2T
	paoTEeWwBNt9JsAsTWAhh9ntCMGkogLF074SpWWwKdnLaKQjaug/1p1C9sYF4WoGgGktsw+isCP
	23oSWkvbpjjUDeky7RMcgU1BlarvrNIfy2nNShX8+MpSqbsqbyWJXwTMaoibrFaMSfilA7TW/hd
	c/Y43Vb60A6RxUNItmMbPFg2eJpyHmk6GaQc782PBJuRvrlQPxIxIlEeigdzOipZzJVffAEu7Eu
	MaA3I0nYZNctxAhsjdUqPn5H1Dt/CzoCNu8xgtE5dUyZVcjLI7/rTq+/dhw+XQ6NpjPdAZsEVIk
	C8W0hXcW4IyayHqfhrMvJnM/S0ja4gRxTHYlUMF9E3vzpEywpf5mUJCGd9x4BUy+z1I/aa7QtfL
	BmXAoZguA1t8TVQZk6s3E+OvXgm4nfW/xd42zbp9nT5H+9Lg==
X-Received: by 2002:a05:6870:b52b:b0:3d9:2fe2:f5c8 with SMTP id 586e51a60fabf-41c11227833mr8798048fac.32.1774304064791;
        Mon, 23 Mar 2026 15:14:24 -0700 (PDT)
Received: from [192.168.1.14] ([38.175.187.108])
        by smtp.gmail.com with ESMTPSA id 586e51a60fabf-41c14ddbcb3sm11505467fac.14.2026.03.23.15.14.23
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 23 Mar 2026 15:14:24 -0700 (PDT)
Message-ID: <959e0530-4991-4d4a-8b65-3ce0b7f6ff86@linuxfoundation.org>
Date: Mon, 23 Mar 2026 16:14:22 -0600
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.1 000/481] 6.1.167-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 achill@achill.org, sr@sladewatkins.com,
 Shuah Khan <skhan@linuxfoundation.org>
References: <20260323134525.256603107@linuxfoundation.org>
Content-Language: en-US
From: Shuah Khan <skhan@linuxfoundation.org>
In-Reply-To: <20260323134525.256603107@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 3/23/26 07:39, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.1.167 release.
> There are 481 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 25 Mar 2026 13:44:33 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.1.167-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.1.y
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
