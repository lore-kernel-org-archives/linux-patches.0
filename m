Received: from mail-qv1-f41.google.com (mail-qv1-f41.google.com [209.85.219.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 44BB835B632
	for <patches@lists.linux.dev>; Thu, 16 Jul 2026 17:30:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784223048; cv=none; b=d+IS4EkDHMESDF+00IZ9yW96so1u2hCkGVl6AY8lOb3obX0+PwgXhd73IRlP3t7CFZiHM0BzCNWb9P4C5mEzRF845x0pRgr5CPXKf+EBX9mVF67mjqPDaJAWzRFWJZI5hAcOsQ5UU0ea7dZWNOweb37zogvwVXLAELkM8JteOB0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784223048; c=relaxed/simple;
	bh=voFa2xNUGsehUNPrXUXNg5NODZ1yCBEHbrIFo4sGZeU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=lM6SnJutSOH0i6CfhHhXdhZ//WpnMEO9u2ToWv0CcDqH3yTz5vuTRrarajuB8QoJGCiD0YWluWLXck/JOXO+2M7gNGu265C6UWVrFqIzGfn/Sv1PhMKE7U+b8ju9aIzcZiTVNR54Ofc94L7Gx2UABW3ATOhpe42Bz/oQ+ZA3K8Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Lcy+3vMV; arc=none smtp.client-ip=209.85.219.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Lcy+3vMV"
Received: by mail-qv1-f41.google.com with SMTP id 6a1803df08f44-8f23e851626so71209266d6.3
        for <patches@lists.linux.dev>; Thu, 16 Jul 2026 10:30:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1784223044; x=1784827844; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=UCWV22I+W09c//Y2bdGU6hl+mnkh7Gm9VSdVidV0tfE=;
        b=Lcy+3vMVAkbYZ4Gz2gZKaKXg6JpfQ3ca01rOSDX+7XdDrG9MOrAoFcPa4nan0qNt9O
         qDtSQGDq/jf2rruKqXmhxf0bDt+xmbMJczb5NWRPiPoK0bg811dx4cmHQrOCTN1ogkM+
         sTVCKDIPDdlDew6BhgKXEFN9lxwqjLPgm8Icmat94mxACUcGZeSCbpvGgqoQFpmyWCeY
         6Dy007eG+TeK3vZUjO6PrGQXbrYOYD5zhpIcY+6X62V8dG/jfNMjLUlKV+00eqAEAI9S
         1G4mU8vukBUKKwvjfVO7HdobBlyEr1PHONnvjySpzsbKhjWFdW0mGWDWIfC/o86t7vGN
         wo9g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784223044; x=1784827844;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=UCWV22I+W09c//Y2bdGU6hl+mnkh7Gm9VSdVidV0tfE=;
        b=gIDx1p/xFeTkmd8RWSdLapgZwGOA2x6atZI3BamZXcb7jjf85YItG3xgp38gkVx85p
         R31x/Zc4xioBZUNRyyDSZgh7sNR4qqqMosqXR7JckandsWtCxqEyS+gAiFyd/XK2EB0p
         16cD7mY84hrvVv+IcMne9mZ1FfqWEuSCGDI05LOgW1GMsnkZ1z941ox6i7zHnwaxdVE+
         qZo/DSzuNTUjxH6v8OMxf5lrSMUKPvzoQVzI6Uf5j6d5eCVOe7mvGPobmRQlC90+I3wa
         uZ6hHPa419KLaeyr3iDRcDXJ4IXg8AO2C/nywTBCEliaSq2UHX4nax3XdLM6DOhvpP8a
         1sgQ==
X-Gm-Message-State: AOJu0YzVzgmkzhLUqcxqTOf74gjfy55NoMwK73HDZ9DQwrerFJU1YozW
	Zm8p0iDq4HRJIegGm9i8eY2uQocsFCMHCzg6CtKylwo1wMHHnosM9xb7
X-Gm-Gg: AfdE7cn90i6drS2LmKsH5fjp8huBtUmYjIO+bby6KuYdj+NMXyNfZPzWL6KBqkkF6K0
	4IOV3V+jDzZO8znIUgbeBWMIuVER+lr8cNtPlSaeTTb+2YOPzdn9dgC2MTTUDabcw3UzCeWhJq+
	YW1iKPdIUEsH1s8q3mTIiRyXw9FGWqnBKuT554CjFnX2U8jIsMyhIWqwW82WqsCs/aCDGiiQpT8
	qQBE6tGdGwCuvR2KG+oVAhm4rXEOZqjOaYaRVdJYs8gypLaK9noN1CuGt3DkRWApEDIwx6djHt7
	NzBUq/bLniioZAZUpKJn8KS1AmJqUs5syuc6jKqnlglTO8vlr0YPjSbF2iwGoQm43ZCSHfJNJ/R
	IfMehfNV5oewbWiXVAVSizPf45oyLZsp1q59hB007k0SgpUURFX7ohKjSOeUpQ2nkweIa+pFmIT
	v5ayYICbbfk75+XVcLk0gCDT/l4s/O
X-Received: by 2002:ad4:5d43:0:b0:8ef:db4:d85f with SMTP id 6a1803df08f44-90747cd4f16mr163706796d6.41.1784223044027;
        Thu, 16 Jul 2026 10:30:44 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-90749b913absm85264156d6.10.2026.07.16.10.30.40
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 16 Jul 2026 10:30:43 -0700 (PDT)
Message-ID: <4d165c10-f527-433b-9d67-3acddff6cfb1@gmail.com>
Date: Thu, 16 Jul 2026 10:30:39 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 7.1 000/518] 7.1.4-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, rwarsow@gmx.de, conor@kernel.org,
 hargar@microsoft.com, broonie@kernel.org, achill@achill.org,
 sr@sladewatkins.com
References: <20260716133047.772246337@linuxfoundation.org>
Content-Language: en-US, fr-FR
From: Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20260716133047.772246337@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 7/16/26 06:24, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 7.1.4 release.
> There are 518 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 18 Jul 2026 13:30:01 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v7.x/stable-review/patch-7.1.4-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-7.1.y
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
