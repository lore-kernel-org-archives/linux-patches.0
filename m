Received: from mail-qv1-f46.google.com (mail-qv1-f46.google.com [209.85.219.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC28929CE8
	for <patches@lists.linux.dev>; Fri, 26 Jul 2024 20:02:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722024167; cv=none; b=HenVW9pyMnv5NvR6Kxf1RsJZWPyBxJQybN0lDTk9bNJPJdUAA6xYXVuAvkoRlHgzKm8kFT9gkkzih465XL0sE9jBTRAF1Ku4RUDGCxXDRxMIPgFkKMi9cEvNL5907tNSlzkJj8/EI45Gd3CF7lGsSz3hNxV6fHLTRpQ0QIP2hG0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722024167; c=relaxed/simple;
	bh=GFsF+jKskuhgGnBjr3n4TRAHhLbxgaBJyMzCDsYbsn8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=bIynP6bkO8irCw0fYF7bYwpyoEUUZJDmCUnuYLFWglXrQgPFO9iFVy8NbOrL83BdcIWSuPzVGextXlhkzHcXxVFHLtR4LF2m0vN2ubmQm3syV0zPjeTHTblviIe3fJVKdBHnmTqfvM3sA/JcDc4OdVrW61+FYJEOYYfpri8mzJ4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=bgI+A1v3; arc=none smtp.client-ip=209.85.219.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="bgI+A1v3"
Received: by mail-qv1-f46.google.com with SMTP id 6a1803df08f44-6b7b23793c1so5724236d6.0
        for <patches@lists.linux.dev>; Fri, 26 Jul 2024 13:02:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1722024165; x=1722628965; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=nJxI3RUALg6qvPeKhK5g5YhXu5vNqGOcbCAXjfUdd6M=;
        b=bgI+A1v3+I462nwoCYlxvJMVoggZTAkYAJ2949szcyqGCbdl8DWXN8Nx4GX6Uw8K4y
         /MSCuZeZ37yleF+DqO8eeD6oRQT4Vvg1OR/BvEgKSPbbxyZAtwqDKww+7tAG93DA4ECj
         Jhord6Ck0G/uRlNM6NH1o+BOiximIZUhBoaQRNTtO7pH64fGa4YS1o02+M0LNKtHHl0z
         gmh2B+hkczTevivwk8g/60TKGJWdvAAGFdAToUgHEB0KYKFYphq/8Z5YR96oXCRHUw5b
         qrohI7cCO8iZCoav5pQxBxezuJ7XsZ9te3eqIVJ1ioSVEF8iBDvj5zYgJYlB9LuLjkvc
         fTrA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1722024165; x=1722628965;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=nJxI3RUALg6qvPeKhK5g5YhXu5vNqGOcbCAXjfUdd6M=;
        b=WMLTt5ur50wW10MIAHax6go29jT9EMgHmZupUSFknnK9sHpcSDlzh85ZrgzG7hnQsT
         mNvddzAvvnYBY2wJJbGMq78OOwQn7KRnzCsPQjuwzaZXzQdh/EoqRm7fzQpBQ3jHHmi8
         euavPQTfW1Une/bR9WnSD8Rkk0EGXE3IqA43FiLx3oD/VW0Fv4YHJi/zv5OezK+EjGQj
         V3orOdG3HdB43nhfXx12bnaCwE4R70n8lrNySmfyBM4WkEramNNHnWKn/kAClQjknhYL
         iO4jSb+wn56/KRv7KTGWnw0cWV9mhHe1eL84hLhlA8Z7kwRogeAUP6ThgJBmCO5s0bti
         qfYw==
X-Gm-Message-State: AOJu0YycGYFIAfaOuGg+87dcDjU86GcKn8asyAo3lQVLJfievdXMThb/
	J5L8+ozqQcRrdxD5cAhvd6RaASLJLKImWiuWFsJ7Kdw2ONvgcG8w
X-Google-Smtp-Source: AGHT+IHB6Z+lbg7XWIRMElM0+HtT1YAvNgKpK/ewPBfnsocH6+ThAkHe4XJsJe9r0X4FQZXNDw/HEw==
X-Received: by 2002:a05:6214:2a47:b0:6b7:b2eb:ae82 with SMTP id 6a1803df08f44-6bb55a44de6mr9274016d6.29.1722024164770;
        Fri, 26 Jul 2024 13:02:44 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id 6a1803df08f44-6bb3fa94e63sm19727426d6.76.2024.07.26.13.02.39
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 26 Jul 2024 13:02:43 -0700 (PDT)
Message-ID: <d873b5f1-4208-4e9f-9846-965ba27073e2@gmail.com>
Date: Fri, 26 Jul 2024 13:02:38 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.9 00/29] 6.9.12-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
 conor@kernel.org, allen.lkml@gmail.com, broonie@kernel.org
References: <20240725142731.678993846@linuxfoundation.org>
Content-Language: en-US
From: Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20240725142731.678993846@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 7/25/24 07:37, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.9.12 release.
> There are 29 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 27 Jul 2024 14:27:16 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.9.12-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.9.y
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

