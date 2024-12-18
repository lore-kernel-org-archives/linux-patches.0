Received: from mail-il1-f182.google.com (mail-il1-f182.google.com [209.85.166.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5575A21364
	for <patches@lists.linux.dev>; Wed, 18 Dec 2024 01:13:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734484418; cv=none; b=RUeYccGtxEpQ8eecOqrQqDcssr9e/mcNu+36ZntT9DPjRv+YwmuBiJfI+32zVi3UW8P6/6ZMuATJlZnEBe0Xj90rvPwKzfHK0K7TD2do0s5WJeneBBiNfYj6Iou5Xgs7Rfwkbk5IN99GJ8LqivFIRoL3adiPaUQvtDh+62EhYok=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734484418; c=relaxed/simple;
	bh=Jnq3a9Mp6GeYFmHNoKlGjPOJsiDdZuUS0Ph9aMtKgaA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=TSd18l8+dkQGzYYCHz2c5J9jHqWGdG65obG/22pzcjwWETv1zeQiJJJ6a2+GCLU9XFIPBip/4Y1GpmYpy/7kfnhI/NR/dLc5N2rKbgB5quBBTzvaKf4gyZj+pWEOSuFY5CO+vNpYLYTa2eu/cuAO0Ja0tUNlzJUcqbwNVs2Jcfc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Wo/a/0Na; arc=none smtp.client-ip=209.85.166.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Wo/a/0Na"
Received: by mail-il1-f182.google.com with SMTP id e9e14a558f8ab-3a9d9c86920so19808205ab.2
        for <patches@lists.linux.dev>; Tue, 17 Dec 2024 17:13:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google; t=1734484415; x=1735089215; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=+MIaWhOayCAGEBZ6/Srj8huJLJWFEvDsu1OwxMVgWrs=;
        b=Wo/a/0NaA4bWGgZ/jXpEem4glM0WEnZZfF8T/GmCl2tf/z91DieMlrYfWmun9cXZZq
         skhnXCVHXrOzYhgclJ8xYifI7fIjwS/JCTn0lCR+Q9GY6IQTo2wFZ7o+bm+Zw/JcGNVV
         aqtjrgz0WzMPfOBoxnfr+p+2Wi1cBzDBr0pHY=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1734484415; x=1735089215;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=+MIaWhOayCAGEBZ6/Srj8huJLJWFEvDsu1OwxMVgWrs=;
        b=I6y84bPjdr2Yxs1fPBKJ6kBaY7hUlSWYySiHfgIHZCfFue2Ycf/+KBmt3KMXPKz1dL
         UxCft/mRIgTkeJ+ONZDxHSZi7k2j/a8S6h6QaZ5dsMoL/LGjXABT+aaFVi9HJ/l4j7wD
         cIfiwBaWeXOa77mkzQtavUIX9/jj3rO3V2YR/izKXXswVX5GXBXRc54IUMMxG+tJawV6
         NDRS5U1XH7xeMkVQb8Qpnb/ChLYXBKPNcaMaxDatZV55WX+98HBpcMOAFWbCso+T+2Vz
         Y/05ObrgHu8CG6Nlo4KjpJCSTR/jE3aRR3GOAZiTf7tHjASq00+IkOqS/3gSoMiqxLKo
         nRqw==
X-Gm-Message-State: AOJu0YwPZQufu8IfJe7ra3oGpOG1mJTsp5FNAK56//y4zxv6y8qowmCf
	N4KxqpkcVntq+gvvwrCg/JcoAYDw0XB8REojpI1BLHQQAD457oqyP36nWOcZuT8=
X-Gm-Gg: ASbGnctR435hs6py08t+h0AivYhTZ4VcsERj6Ztju1m3R0IZFGl9lJFIX1OuSaEIlQT
	lX4D6egnrsmLCP8YNjwBoQbylMlsz+UCU0I+vSvCPPJKYpr2uYYuLL9HCoU3HV8snTy8vbz4J8q
	jXZIbyeKZ/J+24v71w5e+IWGUAtM0Lev6kgdDNTmHxOtTWUE4osPeun9kTZzZwsyrsNGWzl0rTU
	5m/LfDXQGCYGn+E6HfMYVxNSzIGU0uyquBpOHHMAeNRAhOKZlzQjgR+zy2/0nAGzSts
X-Google-Smtp-Source: AGHT+IH59hqk6TvgSTl61Yb2QfXa1njYv/W2AHnV+LeRa7Q4yZChXmIc5ifk/e6AYSjY1UulYcIPFA==
X-Received: by 2002:a05:6e02:1a46:b0:3a7:6c5c:9aa4 with SMTP id e9e14a558f8ab-3bdc174f0f1mr10768175ab.12.1734484415382;
        Tue, 17 Dec 2024 17:13:35 -0800 (PST)
Received: from [192.168.1.128] ([38.175.170.29])
        by smtp.gmail.com with ESMTPSA id e9e14a558f8ab-3b2475aef77sm24165525ab.2.2024.12.17.17.13.34
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 17 Dec 2024 17:13:34 -0800 (PST)
Message-ID: <90302dde-38f0-4be7-991c-a464160d75c4@linuxfoundation.org>
Date: Tue, 17 Dec 2024 18:13:33 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 5.4 00/24] 5.4.288-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 Shuah Khan <skhan@linuxfoundation.org>
References: <20241217170519.006786596@linuxfoundation.org>
Content-Language: en-US
From: Shuah Khan <skhan@linuxfoundation.org>
In-Reply-To: <20241217170519.006786596@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 12/17/24 10:06, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.288 release.
> There are 24 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 19 Dec 2024 17:05:03 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.288-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.4.y
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
