Received: from mail-io1-f54.google.com (mail-io1-f54.google.com [209.85.166.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C060F1F181F
	for <patches@lists.linux.dev>; Fri, 31 Oct 2025 22:36:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761950166; cv=none; b=hRwpGzlXAWojCeXaAkZmnGO5zFso99pvGkwdKEM7R4GU13Jone4LH9cFd8jGDJO09GECDLT7msL3ka1W3aW4QidFeYFLfnyEcGOQeV5MVaiFMVAWrnTGePKphyXnhqVh9P2wRnqK7AIXA+3ADdQrOhscMFcPltj9PFIyzw8/UhI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761950166; c=relaxed/simple;
	bh=0tVzFNaHEgPaz0CZFVVHB80gUFRmJ483D/NF8VfZ8Mg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=BjShOAlr3rYguEPD5UNXYZCGwhHWUceNHZZ1m8zLQcJH1G2jdugvng3fmO4Am7ajiqoWsDHGo/RxeDcP817j0XZyAX51q8mxDFpb4HklKg++h+uFCoL106rNiFyyBy/Y4hOI7IwmPpMMYhWjl6SNZY8VtQbpgVE16WjZUdGakbc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Tu31QxTR; arc=none smtp.client-ip=209.85.166.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Tu31QxTR"
Received: by mail-io1-f54.google.com with SMTP id ca18e2360f4ac-940f8a73275so272641639f.1
        for <patches@lists.linux.dev>; Fri, 31 Oct 2025 15:36:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google; t=1761950163; x=1762554963; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=NJjxAMRCSSyp0uaLlfSkXfbuT3Ybs5HEdO2ce/3JrAo=;
        b=Tu31QxTRGx9XmfP+aCJgaBxPWLBYE08yk1Nv2t9BhMdktnZi4XXSShRchPK2pqfX8D
         LB3wMNZyCs3aHzO1d2COfbIyadfK8lHPKAbYkRPVwkAaCu169+BL84pV3ucNOdZqYzhC
         zkioBF/TsKzvw/b8Il7ZJB+z4nR74dLCYRj9c=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761950163; x=1762554963;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=NJjxAMRCSSyp0uaLlfSkXfbuT3Ybs5HEdO2ce/3JrAo=;
        b=vCZZpmMVSoyUOY58gRkj89E8ECjw6RIgO2kbQPoN1XOI52cvhfnGDFQmDC5b6FrIfs
         bIY++P3GJZ4yntdqy5ERKl3r/30SEAp3FU1rBPrdWzCwgHC/RoyQCZcLIS5gOjzQHhpl
         UDnQkT/KUvvtL85Bi3gJQ1jWKb+1bea8PUZDKeLg7XHdBRpaO0lhdXpDqRjQuFBXDE9P
         oGnMsI9Vi6Ns586KVkPJ+kPQe+07ykSPh8klP9SWFJLOzNjLnWnI10dv4ikI55MAehPj
         MwDB+F7FT85SEJ8ebQk5jbWjkvLn/BmE+qN3lySdiPxHPmR0nrM1DtB4dKhHbc2rcehX
         dFeg==
X-Gm-Message-State: AOJu0YyUPeBdhGcyeW8eQg9yOhyzdLzXLDVtCOaTaFcRyn3byW21lXfC
	A4NDrK2xM9xgxuF02ywCqw1pgv9qTsjDAPWKt6bzSblv3cPLbjnLpO0bWfIkkRg7ltw=
X-Gm-Gg: ASbGncu0RpHBnqE66oIPen+4G+pXYKHKySMgo609OJ/xVi3DhatjsgfKbVwprbTswv8
	RXK+nnXLgMHwjDlR85k5uHcxynETkPmoLjU6n4eoDX5/9mDjCK9NcKB7ESP6qx9D7YymPNEV1fV
	vXM0WAO4szxXA7BcaMnXO2vXBoB5l6GpEPLS2y33QNXZDdIuoOYXHfQwPC3tGqS391BcJv+iE6s
	duhdW9xViF5TuCqh2q9Vwc7ZH/+OdEmVqGlZaBiJKdGGZGmsOl7IOjeO3JwpKf9n3LI1iIlUFi6
	9byDD1femDbu+2kwRKQv+Ig0c9yZoiEIACYIkRXtc3aocFlCABtlDkN+OBiMEq60jKuk21Np4ke
	BmFdFfsKKLAFa8ULjwQ+BhMZfTG8MiVWWajq8YpeqCdQLhj72F/H1/8/VTsrFSNylodxEYZvHE+
	j9OeyHOvvcpzkQ
X-Google-Smtp-Source: AGHT+IHpp2jrTbLgg0/IEW8inYD+D6jhXRJdiw9OAuvNttZoQnFgqxt14vowND5GNwRc9wQwEHi3bA==
X-Received: by 2002:a05:6602:2b83:b0:943:5c52:f802 with SMTP id ca18e2360f4ac-948227e6a14mr838664839f.0.1761950162944;
        Fri, 31 Oct 2025 15:36:02 -0700 (PDT)
Received: from [192.168.1.14] ([38.175.187.108])
        by smtp.gmail.com with ESMTPSA id ca18e2360f4ac-94827baf909sm96079639f.8.2025.10.31.15.36.00
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 31 Oct 2025 15:36:02 -0700 (PDT)
Message-ID: <7e1582d1-4d1c-45cb-86a2-70de0161d735@linuxfoundation.org>
Date: Fri, 31 Oct 2025 16:35:59 -0600
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.12 00/40] 6.12.57-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 achill@achill.org, sr@sladewatkins.com,
 Shuah Khan <skhan@linuxfoundation.org>
References: <20251031140043.939381518@linuxfoundation.org>
Content-Language: en-US
From: Shuah Khan <skhan@linuxfoundation.org>
In-Reply-To: <20251031140043.939381518@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 10/31/25 08:00, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.12.57 release.
> There are 40 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 02 Nov 2025 14:00:34 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.12.57-rc1.gz
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
