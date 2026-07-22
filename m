Received: from mail-oa1-f53.google.com (mail-oa1-f53.google.com [209.85.160.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E62303EA955
	for <patches@lists.linux.dev>; Wed, 22 Jul 2026 16:56:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784739379; cv=none; b=XhZFZwnxEKGVHB7ZEfEfQ6I8WCyJ1ySR5C41dWKgXa4dsGU8DKOJtZLS6iDVnn+GTmzD/k/jRBSKgreHKmdIIwHnehMEPz4ywHu8jqOCrPbtJLNTb7MGmJAm1cuJet0UnnuwAVFBREyAUvAD94wrl7bSJe3YvdsceOO5BceW6as=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784739379; c=relaxed/simple;
	bh=rci9TaTiV+aXvjUilW7ZX6DoI0odRocOImgqMMLWJU4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Gna+iZ/3hPMWHEim/W6d1VRfhO5Ate3WAr2ebUtzJbGuoVEcuIYz7E1LKMBtttDRGoER7eIg+yHcLVmBDMCOL/h/EsmJhPo5PP9JVDzQQm+j+PoS9fiYY+qh/y1/pCG2fZfndwGYaneAh/b++eb9v1WLsevfTXT154r6LDLHC8o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JfH4liwe; arc=none smtp.client-ip=209.85.160.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JfH4liwe"
Received: by mail-oa1-f53.google.com with SMTP id 586e51a60fabf-43b7e186a0cso4653710fac.0
        for <patches@lists.linux.dev>; Wed, 22 Jul 2026 09:56:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google; t=1784739377; x=1785344177; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=dcVqI9nNZSfEoCc3vL/vD/jS991vj6WZxdUxSGF8rUY=;
        b=JfH4liweu8g1dNwbXmn0FF7T/Vi2bsfaKCT0WvOX9D7Ixd1YkEsvAtB1yNvncT7qfZ
         HHgtSa6vFxu86ZYZ2/j8fAqvoBobEYq0L9IBElvdDh4NLJEbJ0zXRoFJAv1Q2yyQFh4a
         AlmhR5gXrJ7duaeb1NKTqlQ+Xg0pFBTgnYp6g=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784739377; x=1785344177;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=dcVqI9nNZSfEoCc3vL/vD/jS991vj6WZxdUxSGF8rUY=;
        b=eGtmcT0OEMvIvFpGMDnpnwSErca8eqJk1WjOk3jusx+W1og9d896R8HQRBtocTzePw
         e/zwjvjNBr/aBZ4dS5dAam6FX45IN9jCKtzYycUudNFP1sdP6Ty0LSyA/VqgLvBqQsrH
         2Oq6PSIcgvbdBC6Etdpgq+ZOeQrNMuA1sKb8QIJ5O7CzQrTbpgz5iG31/44a94SXKZbl
         2EHUvOKLBcnXtIRb1az47tq72Q6OvwtcZm+N5l3i6RvHOyNRe+qPqo6TjHAU3JYMKvuJ
         UUncdzyVyfCwMbkNxPNEuRpEo0BaCsZNVaOUFBG1zGQWk0Ssj7liaQieQ2A9nUbSwsIO
         xhNA==
X-Gm-Message-State: AOJu0Yyeob5kD6jNlrXhOuhmyvXR7fEnJR6if7OC6agYGZmuBM16tvwv
	ORA7tQ0U+sjCz6AM6IJ1b/17qcrwDfBwniUZk8O9a8ON1h4xFei4Chv2T7vVmDTtRqs=
X-Gm-Gg: AR+sD113cixfxM7AuriJyOs8arV6e9yZnZ/Jv0Zh52ge8ffw+44RbVCZsvbgwZ33O33
	yH+9imtpE3HJZ+mbmXqnZidhsMI8fyheu7XkuOcTGeuXRGpnUrojlUFQGo5p7cAsGABO3rrBW52
	ywze9i5DMGasTODTSeSiqU18HbNvJI344A9fLfwFLsQuuVjS/vX/xYDGv4GofAhKYPzzqVfKz4g
	SJLGFBi0vMTyoaM+zkY9GGWorhaEFaAG0Sz+wm5mdTKTAWVGgRAsE5u25Dg9jr5X3a4iW7PCzz2
	kN3b+JgWV8h+N68VK1uT1zcjf3uqInKzKFjXvYGrKdBf7uuIHnhWY7qaDB6/knhM5bj0ksQtz5C
	CSqTQagIbYYiFmedxRXj6kYIWmUiUEBEVLonTD3EgN+Y7clRdKktQ+OkzuwsRpsNIpHg5JiMD/g
	VN8XINTOg1M1k=
X-Received: by 2002:a05:6870:d30d:b0:447:9dcd:ad3 with SMTP id 586e51a60fabf-4569031b3e0mr10790866fac.18.1784739376677;
        Wed, 22 Jul 2026 09:56:16 -0700 (PDT)
Received: from [192.168.1.128] ([38.15.57.99])
        by smtp.gmail.com with ESMTPSA id 586e51a60fabf-45767486cf6sm2444471fac.15.2026.07.22.09.56.11
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 22 Jul 2026 09:56:15 -0700 (PDT)
Message-ID: <e07b290a-7e48-4998-b29b-fcb2f6f55906@linuxfoundation.org>
Date: Wed, 22 Jul 2026 10:56:09 -0600
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 7.1 0000/2077] 7.1.5-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 achill@achill.org, sr@sladewatkins.com,
 Shuah Khan <skhan@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
Content-Language: en-US
From: Shuah Khan <skhan@linuxfoundation.org>
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 7/21/26 08:54, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 7.1.5 release.
> There are 2077 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 23 Jul 2026 15:23:00 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v7.x/stable-review/patch-7.1.5-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-7.1.y
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
