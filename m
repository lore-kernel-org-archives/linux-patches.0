Received: from mail-pj2-f12.google.com (mail-pj2-f12.google.com [74.125.227.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 29F61412C0D
	for <patches@lists.linux.dev>; Wed, 23 Sep 2026 19:00:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.227.140
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790190013; cv=none; b=uW73wQH4mW0/GWgMlczbCv1jLxSjGq1amkMeeZEVVqujwbJKdi9q7nGT1PZksLoi5I72uHN5nyH8w4pYN00l0OhGJKbrwzVHiSw/MPaBfv5SS9Nj4ZL3+gyDh5uk8f5AAKAh0Mj3Nlt1dpALb+P8wtU5htc2ap5OSuORu+YdMPE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790190013; c=relaxed/simple;
	bh=dIYxx7dcorRCck/K56ttjlPJHl0ldcGdQEDj9lKWAHM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=epzRj1PTiTpXzbnnfoZNP3dUNXhCONl1vOkAyhMRvTliPEpHQneOzv917WZHNxEarI09mC3pcggvRmJYB/tWjCibTUDMlIgKfH1j87H3L6i9ykUkS4dMGU4u6RJ6JgRByx8zfU/sv3k6SaOMFWKRDoJyTfkzKIdypmnwSJEC4FQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=dVQ26/J2; arc=none smtp.client-ip=74.125.227.140
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="dVQ26/J2"
Received: by mail-pj2-f12.google.com with SMTP id d9443c01a7336-2d91a931f66so6993795ad.0
        for <patches@lists.linux.dev>; Wed, 23 Sep 2026 12:00:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1790190011; x=1790794811; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=ih7vExqheyZRzWcSD/M9fF0f5NUhzIJn0g8tstyB/pc=;
        b=dVQ26/J2Hfcs5+5o5neyBpKS8iwzY0obLy0wjIkY5j8pFNT4tY/ymrD9+qz09dpHUI
         /vwM95JILzuvCycJu2JpV0fsr9xCZtYHhMCRhKRQQ0QV9iEApznrff2Dmujlx2ao0IaT
         +NZZ04xJ014MjJvwgzNPyepw4iHZ9giFRnU6uUTlD4zlZ00TnkZTGG12Sf8OUQzyQ9o5
         SVka2oBiAbzOEb2RTBs/0f7M45rLstH6r/0KmlVMO+o9desFj36cqYk5DB4O1bBU4CU3
         j1C0jDBqAtiFUxauWdG7cXcJVu02u8iwSbFyqWxRE2lytRskxZNZZAgy/fAXZjoD8FoR
         XX9g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790190011; x=1790794811;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=ih7vExqheyZRzWcSD/M9fF0f5NUhzIJn0g8tstyB/pc=;
        b=hqrC4Ifkezcbah5te5LKVJKfytG4jYe0059/gD950ak5exxzMA8ZGWx65xSnfX4hLt
         CiYASQORcC6mG98FI9+yRiv/u/T+JQt16vV5lZFkkhRl2qq7Z0O3tVvv7wYx5//nXDlG
         pjh/FWeV7XLCzi832+wis7nCSr4zG+PI5aEGq7xBnYtY3flCgAydGj0Seepe+fQ8V2Z6
         wkCAFhsAHL5fhzRyaF+nJWmTi9i1qv6/l+tzDoQ6Rgtp+0VuWw8nnUs2GfBcF8jN3O7l
         NvXkR9QAS9GuoGtAV+N4kA6o8q40EW94Uj+LvJFCfSPjJX6YpJct2eqpFysxoP0uW7Hm
         Gs7g==
X-Gm-Message-State: AFuF++lRQnPWWTXqF8F5aFSKcqvL+f0bBanIo8VuLLvWY7NZ3QHx7i3Y
	7L8Oo+CLNVTX+GxR7kgekD7LEPfliH8aTnN8cIhl4ETmk43WQr4Nkotp
X-Gm-Gg: AYBFou0N0HXo3OEEbDBwMqZ8aRuEK2jhUZNfreNNTdlpx+mSvHWzLQzNMBvmaF7A4Kf
	5WZNQF2LWvHt1BrL7+JlASQA0rV3TJ0nVbbxR22lS79MGdNGb+a+D7fdSgOPojj8RxWqZYV0hhp
	bDjU9UXTMpo4h1eRkUlX70kUWVMw0dmwkaP9vwlkWLXY9zlRj6uxEM746c/Bs4EEkk8segbXk3t
	yG9wbrtacqIAeVttxi2uUA6G2R0bb4n44iNmh2MyEZ8JepyYZOcf6VOYC2h4fjQ21TgrT6zf7JS
	BmYm9C6s1TrIMk9xFXw2LG2bBT3PKcfodstxmXIshaNHgxZ48fEPe8zkUq/wApzUFY4xVvaOKMH
	gwhlNERT4cD1tcHXYLUZmf30mxN6rwF5VMmy6N0hX85pQGcPmjsXJpaeRuLPdWGBKp0nagm33qd
	UCzRLnz44lIrtyA+5gnh2sMPKhduloucbDeyF7uZiP5qnw9vhs0U7ObTKyGiW00ZCi71LhhN+Te
	pH/Mfl1up0NYRaF8PelIXg=
X-Received: by 2002:a17:903:907:b0:2dd:c053:d740 with SMTP id d9443c01a7336-2df7dc387e7mr822995ad.39.1790190011161;
        Wed, 23 Sep 2026 12:00:11 -0700 (PDT)
Received: from [10.14.5.0] ([192.19.161.248])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2df6a5d7a48sm15827145ad.48.2026.09.23.12.00.08
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 23 Sep 2026 12:00:09 -0700 (PDT)
Message-ID: <e0e7baf9-185a-4608-8dab-ddaa693d26bc@gmail.com>
Date: Wed, 23 Sep 2026 12:00:10 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.18 000/398] 6.18.54-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, rwarsow@gmx.de, conor@kernel.org,
 hargar@microsoft.com, broonie@kernel.org, achill@achill.org,
 sr@sladewatkins.com
References: <20260923140643.441954610@linuxfoundation.org>
Content-Language: en-US
From: Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20260923140643.441954610@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 9/23/2026 7:01 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.18.54 release.
> There are 398 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 25 Sep 2026 14:05:48 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.18.54-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.18.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

On ARCH_BRCMSTB using 32-bit and 64-bit ARM kernels, build tested on 
BMIPS_GENERIC:

Tested-by: Florian Fainelli <florian.fainelli@broadcom.com>
-- 
Florian

