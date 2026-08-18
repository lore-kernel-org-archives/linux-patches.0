Received: from mail-oi1-f177.google.com (mail-oi1-f177.google.com [209.85.167.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5FFB945FFAC
	for <patches@lists.linux.dev>; Tue, 18 Aug 2026 17:36:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787074581; cv=none; b=Xq8mXggM2weWThlv0pTBZN0Vhf9K/8i1LA0fC2xXHdCxphOtaEpbOycbFb4E6aa818m6GaBKJ6KZkhTOzeFHfRJ6IPf9khw446IOUAC6GHp4qPes9Tnv+613GaLW7jO7qdVErRW+5qlmCxieCIBtjpBi+RCN8Y0thBvdjYVJMRw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787074581; c=relaxed/simple;
	bh=g4igpkjRW/gzssrsO8VF7rAC1YOodN0DQU+YJi48h8c=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=uDLFbdUJjCGJLjqAWq2m4rt9LUDkmNWtefPa2jM9ZTqstOlkuddoqpcl8dropk4ydxlz/DL5lJAlZYSi9mkSBoa9Vsw4rGbPPL4ge9fqT7Wg/S8DJsJZyTyR8y8OShGNb2vr6DaaWkC2kvlPk8xYSnkSG1jdQyQuU3myIkwOQUY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VsaaD+4/; arc=none smtp.client-ip=209.85.167.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VsaaD+4/"
Received: by mail-oi1-f177.google.com with SMTP id 5614622812f47-4b28df1f600so141368b6e.2
        for <patches@lists.linux.dev>; Tue, 18 Aug 2026 10:36:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google; t=1787074578; x=1787679378; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=pMas4PLE2VjLEhJFKIS7cha7z8zOGMsrrYlzGahYsx4=;
        b=VsaaD+4/hS/eGMQTFpuzMzDLd2VMHi+r5ovnp7JkpsRPTYjP6DuT0J/IdhRC8s9NUH
         XemnyNWz1bMYo70OpDUmoTLKZezquZosrME3b7J4gmVlE2uVb8NnMfGu09uVp+nCe82+
         tsdux/XafU8a494RKo8ASu1pwjX2zBHNmfABM=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787074578; x=1787679378;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=pMas4PLE2VjLEhJFKIS7cha7z8zOGMsrrYlzGahYsx4=;
        b=RW0oALKIxdLwnHE9okwUEb3cGqtzZH9V7kV9Xq0Vve4byjDFvEEuni2KGslg15xeIJ
         724wJYl9khLtsVy4Oq2hDKFPnhYKQSRpVmdLzmDcQ3U+uEQ6Cj6gDjvW6KnpmeUCmhoY
         42S8vdIFUvjGLwsXHEJ/c0N82gbt35AyohfH+gliLfaqbpZy7xLPLTR49bdMKp5tDSho
         ahlv4OxApA49a3swK19N4qZMnqNob1JKSjb3ezFrWWqzTSNmNC/3XBHPDM1Q9/w1UA0M
         jaA0bUptclAb1PiSPGA4rwU5YhOSQUDUEXgSMd6ozBfXIFh18OH1ZaEaqyw0Fbx2xLbP
         W0qQ==
X-Gm-Message-State: AOJu0YyAJWljX65KbzJ7eaZkeREKyyQjGMj+aJxyfhbWH/mLcVnoUTPr
	wjbDlE8xAhFdLsIPPJNOnRwwIzBvaNB9KyBQTLs3UGdgi/NKs4ubsQr8re/C0URA/0s=
X-Gm-Gg: AR+sD11CkdjMe0rMjY1KceqFUbZzaefdGCxhayIBIGslOCqVsr1/IjU0zWLWezoFI9C
	f37RwbthwnhSBiTZfuEMHFweu4dmQOybA1iV+Fi2r1anVWDNdEZNbp4CQTGACdS0WJILUfbXZpI
	xJLiuA7T0WEgwhK1DJRw7C8ZT2wKLTaQgXc9OhlttkoSKBuKxF1nHYEwN23A0NyhakIC9IgX5xl
	5AxHNbcr5EdLL7G0zNu0dWeI0yOKjaR5TUWxz+nBMrDgT08CkfEE9EhHGDONFMyUX+Bw1JowoqG
	s5WEHZX0MHZ7rOyThXCrBPaN22H6FDDtqP2h4xti/0jFfz+kRjOgRjX64v387pHQRmE+TM7wml+
	KVX5s7Vx3ZM8PqONfVKtcd8pF44fg2Lb+PxUCi3Du5y9Dy0kUVgPq26tZ/Z/HPNJYp39j77TtRE
	fP3O2spX6Gr+aV4qfAGv2am3ATH9vSOuKmLGLA9chrfd4NeFKXZt9bz4rRXNIt52JQ6WPIkA==
X-Received: by 2002:a05:6808:1484:b0:4af:5d69:1cb4 with SMTP id 5614622812f47-4b241e09a94mr34744190b6e.15.1787074578056;
        Tue, 18 Aug 2026 10:36:18 -0700 (PDT)
Received: from [192.168.1.128] ([38.15.57.99])
        by smtp.gmail.com with ESMTPSA id 5614622812f47-4b290a46307sm4505829b6e.3.2026.08.18.10.36.12
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 18 Aug 2026 10:36:17 -0700 (PDT)
Message-ID: <6eb71274-31eb-4836-babb-7f84c29968fe@linuxfoundation.org>
Date: Tue, 18 Aug 2026 11:36:10 -0600
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.18 000/250] 6.18.45-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 achill@achill.org, sr@sladewatkins.com,
 Shuah Khan <skhan@linuxfoundation.org>
References: <20260817132536.466235697@linuxfoundation.org>
Content-Language: en-US
From: Shuah Khan <skhan@linuxfoundation.org>
In-Reply-To: <20260817132536.466235697@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 8/17/26 07:29, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.18.45 release.
> There are 250 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 19 Aug 2026 13:23:44 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.18.45-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.18.y
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
