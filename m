Received: from mail-il1-f174.google.com (mail-il1-f174.google.com [209.85.166.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D67776048
	for <patches@lists.linux.dev>; Thu,  7 Nov 2024 02:56:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730948215; cv=none; b=iKgzDAqtnB7khk6k/L7PhH5tDeyMHY+QUnDFMTBz5SgiYBEVJtrgwANJhBP55Tc0Ahv2u82cYTbccKUZZd6hJcQf2XQxov05p3YUmbemdVAaPlVJ9YoRTj9j6Q1bMSfS8sAtksmUtGdg6nxbtazN8kUdq2ra7fQ0FppVry3vsOs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730948215; c=relaxed/simple;
	bh=iU8Yq5U1yq8Ri6s5bvf1TqjnMP7Fji6Q8Voe/HqPewE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=QQ5w50Q3Rcqjk/xpVncwENtKW62ImbZtF5PNJMiYfn3iZ2kf85CowjxQ3JLTJz8GNbOdvcNo1HG2SgYFH7MDQvRiy3oHa1KuVvNzJKtGUEPVA2SWiGjSKIsTRlLROh94POkf7sKmyYh4HRfaRIwl06IIyoZmNcz3snGbt5DObIM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=I/KZKWR8; arc=none smtp.client-ip=209.85.166.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="I/KZKWR8"
Received: by mail-il1-f174.google.com with SMTP id e9e14a558f8ab-3a6e960fa2dso1198665ab.0
        for <patches@lists.linux.dev>; Wed, 06 Nov 2024 18:56:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google; t=1730948211; x=1731553011; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=gDxrDipU5XMaVDAVRRPsfjldbqgDYPtJ2JLlKFXqBUE=;
        b=I/KZKWR8wv9I3bNm7ONIwTf1PJahBvoYjAEWGJx8ECW85FCzwau1KR2Srqj4braHb6
         HiIthJoK8eMDGxAYUDhOQwWQBxKdv9pVOMn3BOEDqAGQIAyyi44549JHDbYwfCsHbE3s
         ZoM0p5JkuY+NmwBshvTWqJ660ZHua0NTu44P0=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1730948211; x=1731553011;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=gDxrDipU5XMaVDAVRRPsfjldbqgDYPtJ2JLlKFXqBUE=;
        b=ZzMWm09brGcZYMiKXe7AfRREdqA2yTJJ7UoEWLx4ro4/RY1bbiCHSetuddb3D4qCO7
         +nc3kA2L8VtDI4Edu2BeJRLBdgxMK79Y8WJTMmQDYG4VIMpU0c4S2uise06OJfOvfEz1
         5+yWkAwUq6rFo6SlBwH95U41WDnnRLj2J1YZ4iosAcVpj0HC+6BHJ5nGCMXMKfD8VUHx
         8Q+AqJ3/4k2CTI9cz1j3bBtd9tcx9ilgjyNijiAXT0d5AH8FiKmIF8E1O1UbTHAynK9r
         rOyQSTPkc1GUDGPSe+xCC5MyB7fqBnZp+7JPZALxMn61N35+xeytEG4ZUeVA5cR0cQsY
         UvgQ==
X-Gm-Message-State: AOJu0Yw2AbwnMe8dyjY9caibkoBksrcfJgFm908F1yzYG22Nsas2C5P3
	kxOfHO+QQdAJvoK2ipQ2vF3W+engyEqwMms05NvpFRnlZsfDOhzffl6A8MKh0Hl/SLFCAuBGP2k
	G
X-Google-Smtp-Source: AGHT+IEpTwgqbmmSGMj6ZEB+fBjuiRqUjPz3WQrIx5QDRQA4HP3cesZ8QbsAhbbYstiP5zNb8jiCNA==
X-Received: by 2002:a05:6e02:12e6:b0:3a6:ac17:13de with SMTP id e9e14a558f8ab-3a6b032b298mr242523505ab.20.1730948211539;
        Wed, 06 Nov 2024 18:56:51 -0800 (PST)
Received: from [192.168.1.128] ([38.175.170.29])
        by smtp.gmail.com with ESMTPSA id e9e14a558f8ab-3a6eacc066asm817945ab.40.2024.11.06.18.56.50
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 06 Nov 2024 18:56:51 -0800 (PST)
Message-ID: <0e245d12-c912-4262-8e4e-bf3b4f4d6c8a@linuxfoundation.org>
Date: Wed, 6 Nov 2024 19:56:49 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 5.15 00/73] 5.15.171-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org, hagar@microsoft.com, broonie@kernel.org,
 Shuah Khan <skhan@linuxfoundation.org>
References: <20241106120259.955073160@linuxfoundation.org>
Content-Language: en-US
From: Shuah Khan <skhan@linuxfoundation.org>
In-Reply-To: <20241106120259.955073160@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 11/6/24 05:05, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.171 release.
> There are 73 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 08 Nov 2024 12:02:47 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.171-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.15.y
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
