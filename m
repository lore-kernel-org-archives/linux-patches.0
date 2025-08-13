Received: from mail-io1-f42.google.com (mail-io1-f42.google.com [209.85.166.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A6D702EE29F
	for <patches@lists.linux.dev>; Wed, 13 Aug 2025 15:05:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755097536; cv=none; b=Jo7QEaArcKQxh+yO2ty/U4XiRchtwTUi3TmELBOE9xm5TlVyKxbs8S+OgdaggxVK7TsVUrWqNM0pgW6QBdOiaMcbpoZ7SopvCn/NncA9TWYJuh1QHhlYPRrfapmPmv6LETeysCiWKpdcabYU5YMqHfaeWhVdEzPTGuLE9alz/Zg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755097536; c=relaxed/simple;
	bh=3XzWy2tt6bqaDyewBfl3310hnzDoLk8KgRxkC51IzhA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=GtmRmzcuHy/2gzddJrRNotIhThJnSHoRwpP2lJAeCG5oigM/YKQ+xd1+7L0Ku9bmkUlew4XY/ZZdNk7AnVsn6Pge38vVeBfmE1keMRMnZSXFIwdx3UAjclV/aoEJBANQF0ba4eFwuK+NkNTGxqlcCkXIpqqsIzlmzAZkiZvD4I4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Mp/PjOot; arc=none smtp.client-ip=209.85.166.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Mp/PjOot"
Received: by mail-io1-f42.google.com with SMTP id ca18e2360f4ac-88428b19ea9so28623639f.0
        for <patches@lists.linux.dev>; Wed, 13 Aug 2025 08:05:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google; t=1755097533; x=1755702333; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=bLuxF8BcFQ4U8Ber6EP4PVwS4pfKrMlITaK4ixL0kHE=;
        b=Mp/PjOotPgV1w9lw+Vsg1cOSJ7ZbZQPRqIdsyLuVGs1eRLwRkLjDzS5W55CvF4zhut
         JgEJZVGfHLxRVt2OZMvBcUT8mibxWM/SGuheXO61kKo4sdZFcfZTAGyZK8o4nTo6D+rH
         3Rpby9sw5y8QJXMY/F3y/OgmSw7IM0pjWYxMQ=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755097533; x=1755702333;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=bLuxF8BcFQ4U8Ber6EP4PVwS4pfKrMlITaK4ixL0kHE=;
        b=M4k9eTngBsl28j5Rr+VV5lY0jGzN2yESxynmLW6RKqyrZG7jeL2xW6q/egDWbtqvsg
         Uo2Y+a8IA0UaoH+arPwHJ+pljERL2QpoYyVanMSCbOj+ecsuaWpsJWLXUKBSebkFJO4R
         OSD45ekIgNI1HHByrg7DW/b8Y2LpZAM36SZP7KONi1fXW4dSuVZm7FovqmPFrO4Lq82a
         tqWjrVfC8fj8j1HJuFHrpHvXFe7gcjK9IJtl+e8nX/5jrGF/1QObDwprSSil5t/dhT8H
         NAp1FEdT7lo4gOapTTVBApwpVlit+H0f5NtVyDBQu3sjRoNJW/7iI8qgxr4YKmeZwSHk
         WsrQ==
X-Gm-Message-State: AOJu0Yx1JGNYF0/5RzFazdGGBjSVP0SNphSBvcSoTValdNwky27EZWt8
	kFJbfsvoikna7TYc87ojQ60A/DjXOB4qQIYQ3r5mMoRwzWog0PoYK64EOsNYYyDRHpo=
X-Gm-Gg: ASbGncsha3A9hLc6Q4FhIjBxP4qUUHfhz1+LreiZP9Qcmguh5hl8tTfFhn3LwYoiUmX
	k3FHPHS2jTgTLDK0DJPVcfs0YqNNspa9r/i2WC101rN14+r8CXdMA+OqkBxzhFin/pIP0cJNOSx
	Tvo6T75HXangtmIRIBRaqQwRPTwQU1QW3tioEFtgqOM6CZylWhFUEP4om/j2f4VB2W9ZLSrAfGZ
	q7LyZ6WxF6alDSnCbrfhVBQKPVelq0MdF6qHXGigoB+2fuX39QYU2O6SRBMz+mxhF+hzoAH3Em8
	yaZS5+AxsuZN9NKiiolyjLSPyBkpIR+DJGyObjmrpWQtvJC9n1CearMTP5fg7QrLi9z2wIEgUmH
	sZmJ+CVWM2pR3Ckz+4dzFNh1KDTN2VAD/zg==
X-Google-Smtp-Source: AGHT+IGV/ISII8H2LUhsvrlcWKzdOlv0auQmk4l8zj9XLpqt/+BOLYq6RaNdUSrvqV76pSjl/LDVlA==
X-Received: by 2002:a05:6602:1651:b0:881:4b5e:fa9d with SMTP id ca18e2360f4ac-8842a332320mr450166339f.0.1755097532624;
        Wed, 13 Aug 2025 08:05:32 -0700 (PDT)
Received: from [192.168.1.14] ([38.175.170.29])
        by smtp.gmail.com with ESMTPSA id ca18e2360f4ac-883f19d013dsm448497339f.31.2025.08.13.08.05.31
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 13 Aug 2025 08:05:32 -0700 (PDT)
Message-ID: <173eccf4-5613-4899-a3d1-1931379ce09b@linuxfoundation.org>
Date: Wed, 13 Aug 2025 09:05:30 -0600
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.16 000/627] 6.16.1-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 achill@achill.org, Shuah Khan <skhan@linuxfoundation.org>
References: <20250812173419.303046420@linuxfoundation.org>
Content-Language: en-US
From: Shuah Khan <skhan@linuxfoundation.org>
In-Reply-To: <20250812173419.303046420@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 8/12/25 11:24, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.16.1 release.
> There are 627 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 14 Aug 2025 17:32:40 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.16.1-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.16.y
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
