Received: from mail-dl1-f51.google.com (mail-dl1-f51.google.com [74.125.82.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F2F03EBF34
	for <patches@lists.linux.dev>; Fri, 13 Feb 2026 19:30:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.82.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771011050; cv=none; b=iNWfoe5fhfhRcnO6BJAFOWKrwF6QscYmTqHMtAvIfDdnKvSoyUXTXsH6wG2Uwe9zfAF094U3FUohH6QaLSGuTGYutjXCi1Yg+4RPYjOjbpcMRM7/uHXUOjboNvgvirHv9w8TIJmFIOHqwMFbWSXxXF/3FunIQI3cWFUE66QHKP0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771011050; c=relaxed/simple;
	bh=dAO8lB0ND8WhwH2pV1nOyXFciMHsu+ivTvc7OEUo92E=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=hMS+ynJ/PZZlTUR4Vilo6fURGhV5iKhHrbdgJy7IRtP64UxZ1PtC/sZFvhFisiksw30GjJUZNoh487CdGIPsqFEbkGMEGx/d5srfN5E1M4USRJUiuhqLwK6tbThDBVfRWnCFqrxL+qpEP/cEhRbL/Tz2Y5puS1Q7U7Mn3tK00mM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=UomqWWr7; arc=none smtp.client-ip=74.125.82.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="UomqWWr7"
Received: by mail-dl1-f51.google.com with SMTP id a92af1059eb24-1271195d2a7so1094096c88.0
        for <patches@lists.linux.dev>; Fri, 13 Feb 2026 11:30:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1771011048; x=1771615848; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Q6XCBbxcLfgzoRVkZvaJQyYjeS/eWp9B2ykayYaVUGo=;
        b=UomqWWr7xbwfHKFohI3P7WQbRh/5sOdKF1R5kZ1h8s7AxUM40dRH9r60KjDdUdCLA8
         js/Onc7Xm6nV566DCmRt61t3lKtR/Z1RcL6JVZxAeqeDdtXP1PLgY/Nt2WQTodA7qCDv
         jAD3tXSIFPXwcfIgp6WkY6rjzwSSTzpnm3ffFP9Su19q0GtvJtR4WKc9O4RWiLiORoc7
         vKD34t+85axzMIyRXEPEnuKtSevLW5j9mlL7iphdWHvdakFfYb1Mae+Rw5aiRWoWp1hu
         kaxUfK7iqMDLxMR6y7gjaijUY0GwXFs9VCw/XBBI8afVdhvJjqIKxd7qfK3+WS1PqG5Z
         V+Mw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771011048; x=1771615848;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Q6XCBbxcLfgzoRVkZvaJQyYjeS/eWp9B2ykayYaVUGo=;
        b=EWlbNNZ1c8SLmWSgP+XJfGjdHoYzEAhEK9bGRzWYSf2+oApVX3XMS8wRwxPlxkEq3S
         ZfDkQXfPD3+jSUi7jCCwKYNaZY5jOlV05WKKVGZWS7oUmqheqJtmTkuUkwsDMzxp+b4R
         nj2+Hs73sBg6CqBBKzDmYfoW80+4o+xIX2CTsgN1vEmwpjsVOtjsu+LjR0uQFTWC90tr
         5AueAQt01WjE2vCn93W1FeZlLF5BVDtBm1yLdTMw9w1dU1WREzAgnwYneVULY3rmp2H7
         //2T8xGMuK4b14vQcOZceMOXUptu9rFicG5CpwqnrRj7tl9f2Xf9AwWlTmOeDhwvzf9J
         GyKw==
X-Gm-Message-State: AOJu0YwgXY4q1qx0RYr2z0adV54SHgEQB8Njl1fIJ0tyo8SoPaJUVP91
	rzTab6b4JxSkvtMcKnMyIr5HcCuxtJpfZwU/5ytEPa/4H7nGdbDC6kdo
X-Gm-Gg: AZuq6aK4FOX6BXap6qdllwQqNSMguD73IgyUsEM+i5YrrSHlI5g0Z4jc7YH2aHlKcgI
	/IurPJQa4qiRaPjp5uUrvoSOGhpmoI5uo7PboHLfRhziCH/yR/9bz3ACrJGJyIxGuZ4UEsM2wT0
	SGWKPW0eie47Xwy0oTArAFA2VMZuatqE1V96AIvbMy9X2gjL/KdvEF8EIGhpRJMqUEjOSMYSCYx
	Rj1WT/BU0qZlClyI3QXHvv14Yzp91u2Y14VZgZ+9t2+GtZ3TT1ECneesqiJiCBL7PXWGI3Bb9a8
	J6FbpJ5yPW4AIwkrPJYW0+7XymL+DiMQu+IQCVVFv44K9668Z/2FPb1alkMkSyEjFgwWjjbjNd6
	V9FFKYI40RM8ETYzQUetw1ypOsUxCBaztNqjO5Pfy+wjYme9RuExTktG5sIESnQv9yOr3qCWEll
	XI4J7kZaNNvFMJRTbB53Zk1gwiqC0z3WnlSf6Y9ZgdhxyCLcNQUyV5XrDLc3bi
X-Received: by 2002:a05:7022:662c:b0:11b:c1fb:896 with SMTP id a92af1059eb24-12741b63659mr291180c88.4.1771011047993;
        Fri, 13 Feb 2026 11:30:47 -0800 (PST)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-1273eb11a30sm1350851c88.1.2026.02.13.11.30.46
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 13 Feb 2026 11:30:47 -0800 (PST)
Message-ID: <56cfb554-ec87-4058-8ce1-7629adccf73f@gmail.com>
Date: Fri, 13 Feb 2026 11:30:45 -0800
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.18 00/49] 6.18.11-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, rwarsow@gmx.de, conor@kernel.org,
 hargar@microsoft.com, broonie@kernel.org, achill@achill.org,
 sr@sladewatkins.com
References: <20260213134708.885500854@linuxfoundation.org>
Content-Language: en-US, fr-FR
From: Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20260213134708.885500854@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 2/13/26 05:47, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.18.11 release.
> There are 49 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 15 Feb 2026 13:46:52 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.18.11-rc1.gz
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
