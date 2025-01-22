Received: from mail-oi1-f181.google.com (mail-oi1-f181.google.com [209.85.167.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 16A12215791
	for <patches@lists.linux.dev>; Wed, 22 Jan 2025 18:24:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737570294; cv=none; b=aSH/rKyXAcENWoTYrhuOkSfNoO8kZ3CB51UFDK0JmBKVAk+luqnXU31Vp0MEWzeIx0psWDNYD4dADBBEhVWaukABRgrHEOprlzxQMs7mcZLPbW42c7TzGVwBkyiaxJKUxAUYDgQQ/bykmyl5xPc0LZzY1tCpi5QrV4euClcdwVo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737570294; c=relaxed/simple;
	bh=xh7zLoMQOjcaM/STUaHGtXRn+vPaUHEN15K4WYtdl6o=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=fVhcSJVRpkIrhBtc9MrKEAgVkts+TsFAz0YWMNHpY/R8X4FFDco+kpqDObGusZLxUHXW1QVnQTJVj+pBuNLnzKI/xzluiekAWeOkTTQF/WkNuHA2hf+tLigSwlGJiztSrqSU/QDbcpQ32VqaKZwuGSgB5HIQRfAxk/+ZE+DP2pE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=OIePhzbR; arc=none smtp.client-ip=209.85.167.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="OIePhzbR"
Received: by mail-oi1-f181.google.com with SMTP id 5614622812f47-3eba559611aso42465b6e.0
        for <patches@lists.linux.dev>; Wed, 22 Jan 2025 10:24:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1737570292; x=1738175092; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=cswVlj2rHirmLrWsg4FzAzYo8xKtur9XHV+F/JamivY=;
        b=OIePhzbRIpYtRgDbW7VSLxEjHWGRORpIosOdimlzEt82ziLK5UtU+LAnsqYsuumrZB
         v0cqqp66GilP5vdmP6viHbrARttEhfJQR6xeQ1JoQ/Yzjf/fQZEFEOCoE4RWUJLg3z97
         7sP9kxUjXje9Zsd3k6GmLOn5H34kYt2fIJGXbClLF4BpKYtYxx0EXTnBNW6XhqkNhcGl
         csOqJPV6vf6T+wa1fihdOJMfVBeLKMA40Ww1fB7WBdaGOth1hqylbEAAhYw7MKEO1gSC
         hNsexQEJgCkT6xDKryAJYMniImKJ+RQsHUhBZHjqnnvmPbeyFd2M8j3ylqt1AXVHt0Ty
         PSuw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1737570292; x=1738175092;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=cswVlj2rHirmLrWsg4FzAzYo8xKtur9XHV+F/JamivY=;
        b=Xq/xtSqnvGxOEDnzItjq2bMBf0rlsRkQx07fYrdXJ+kHfR2MARC6VQg1J67+mjD096
         Ce2KWAHkJaJF5Y9Wb1hrKY5H3VCQrcph7DOLXDR6k7LP8RczwzXut2ka2LNiqLuYTfZo
         PEwFt3U6yBvMxP4CjHyefPNfB+D/JYSkQ4BtnZp69FFVI04fs81xml6pVbORnt3mB8yX
         bZKIXV4BcemFbBDP5x3hvMPrPaxeW22olXyz9LF3BwvyyVD/XCKSvcMIgfZBx9LCZQLP
         0dnPMyM04L5dHxn89MkgO7OBHEjBMlEMLc5uxA+vwpA2Be5TFLYQsmK4h9gnGFrEGxtd
         ruhg==
X-Gm-Message-State: AOJu0YwgUQNqgqbA5CuO4/pBtRCyTcnkAXTyzEmos4Tirqijbhb0rbGQ
	NTih4uGKfzUv3KkrDKqC6QNhAHIWgUG+xocasIEj0CSjeLC5ph6v
X-Gm-Gg: ASbGncuysxgrqF/s9zOIy1G24ZJukJTOT4KXgttSOInh0XpUNYQh9BZ99Q2FPF31slD
	w1Z8m2TILirChPGMumZ0sVErj6DDmdwx3jvgwVOeue/G+lT3EPgqORIaD+KcsSL/IhYGNtbf+BM
	jLm8BtnLE8l97DCqvbb7Z1kCi6H97l9tUM6kiQ2+ffpufuPLi4NqcDlmFOiHAGjE++4D/zCepeG
	9pkT/b+5/aqgA8BU2b0hkTF/ICcuOYKRQJeGnsCirwwlcRKxzUmj7OLwDQhiWEv4E8M2+oqW5uu
	WSRc4aSA6LbsvuyPDN536pFz3WJNQs6O
X-Google-Smtp-Source: AGHT+IGM1J6k5OkVgtSoFl4ZTZ2W7kVZ1aY/iA3q1cI69tm2o+kqsEmEAUf6PO8Mzcl5FnfNB6L10A==
X-Received: by 2002:a05:6808:398c:b0:3e6:5761:af3 with SMTP id 5614622812f47-3f19fc7d842mr15416836b6e.9.1737570291933;
        Wed, 22 Jan 2025 10:24:51 -0800 (PST)
Received: from [192.168.1.3] (ip68-4-215-93.oc.oc.cox.net. [68.4.215.93])
        by smtp.gmail.com with ESMTPSA id 5614622812f47-3f19db9eb8bsm3645425b6e.49.2025.01.22.10.24.49
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 22 Jan 2025 10:24:50 -0800 (PST)
Message-ID: <c0b51920-9575-42d9-93ea-6047e1061939@gmail.com>
Date: Wed, 22 Jan 2025 10:24:49 -0800
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.12 000/121] 6.12.11-rc2 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org
References: <20250122093007.141759421@linuxfoundation.org>
Content-Language: en-US
From: Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20250122093007.141759421@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 1/22/2025 1:30 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.12.11 release.
> There are 121 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 24 Jan 2025 09:29:33 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.12.11-rc2.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.12.y
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

