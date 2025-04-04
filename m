Received: from mail-il1-f177.google.com (mail-il1-f177.google.com [209.85.166.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 21C961F3FE5
	for <patches@lists.linux.dev>; Fri,  4 Apr 2025 14:48:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743778099; cv=none; b=J81Irxmtf2rv99WhjYhFdJDyn6XX2tOJgaD3OMrBgvrvxADa6NB5G8gJ8xNh7tu5CPb63z2d6tvRtRlx2p3L+7vMEeDf7PJu106r+ofhI0u7gqEKRKZV6zlFI7W/B/VGvcKtP+PCIKXcVT2F4Ptz/4t3eVRQrTQpGlUqn/HPWD4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743778099; c=relaxed/simple;
	bh=xR8q7hzgA9FXRoG+sY9ISOiAyQMLmpe6nTbBK8Ue+CE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=VEKhOm4jKevAH0WkaKSL/5dD5mceUe2cspwezam0kmaMX/7ffXiP/yXgrMO2VQO18CLnclT2K1a9nOckIaZ1rIi2wymQmiljEF53NT0O0f2qYpv0msrO29rh0K1mahUgTVO7+8Ds/shuktrjdF+8jwTDw3xcTPix9+hZbfInEaI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RPs/75R3; arc=none smtp.client-ip=209.85.166.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RPs/75R3"
Received: by mail-il1-f177.google.com with SMTP id e9e14a558f8ab-3d589ed2b47so7173435ab.2
        for <patches@lists.linux.dev>; Fri, 04 Apr 2025 07:48:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google; t=1743778094; x=1744382894; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=W7uwFeew0VDqMArV6F/glKB7hcKD1UfxHTGRSpLzJvE=;
        b=RPs/75R3/2hl7hbnaKZ0gYeVO4YguW2N1wll6tQtovCyziMrJl+q9l8hPWCXLu1G/H
         ogzrCPlm8T5zow+0it0w3gWn2VwubsIlmRpgQCZS40X6+uIobAYJ/wMTlimFHobQ4BxJ
         jhm7f+gmafAkBFghTAWr7EteGNZ/yWIUxYCnU=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1743778094; x=1744382894;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=W7uwFeew0VDqMArV6F/glKB7hcKD1UfxHTGRSpLzJvE=;
        b=fW5Y44MB2qga2Hmx3syTfdcJZRoaiD+lyR9iacVrIUpnn991EgXj+2R1/1gMXqH7ss
         I4gO4VzLackHlS4bpNXYSVEv+lVYtEu0LVyrCFowveXJ3+QxTqk61z7yhmTd2qRnVN3X
         Hi6vFQL0OYpgXOdoE7UNUU5HUCFzaBpkMoooj+jSGXGFwstw+PDqc2lTtdXI785lL6TT
         diGWIW5t0b3apgi01uQzfETMjxQ2ccjp/1nKyhnITm1hXYivi4LFq8cikkVtKk8siGGC
         Pqn7W4RlYzt06jvUfOgbXavmHwOMjHQLwKBOj2fmHa26pq20xmFIMTaP4mhUOpj9oCNY
         Vhag==
X-Gm-Message-State: AOJu0YwaEFf2t9LrILzCP2/Smkk1VDV5UOIp3Rxqt4QaP25irQKsphSw
	+YRDzMWOc/8I9otbHNcUCJBZ7K/MqGcW8TSZsK0asB/olac+TRIBiXl9qA1sgzg=
X-Gm-Gg: ASbGncveHaYqmhk4s0TBted28/w8NMCjxX9LEixKz28dKVsmtyEICexXjNYVeOvdASk
	ZjdT+VKQlfnaRaaAZPQKHzaVOy65txioqKktOq+7OrkN881dTTO+5ZnAjFuguM2KBhLLuLpB5/N
	uwF4xlKY0Lz1NAkHLwItmvozHEfTv47+e7GWr4c9/uMLXGyGVxCAM9Es4VaEC5hUDVJnxviwbDF
	BPym2jfJSOMxS4MoWjp17tRF1PhdBE8KT9lx4pFRAR5szxkK/PG5tY2s11HbUEYfQmx1OUx3Vl6
	4gGkoof5kSm+SCuSQmGhv7C84F4Am+GmkyjU85/fHdy97yii4ZaUU3s=
X-Google-Smtp-Source: AGHT+IHmeVMxstvkkG/8A080OyDr0AsQTJp/ULWOhj+O2+I727qqrla8YXBKLW9XgqtGvSIgC8PYmg==
X-Received: by 2002:a05:6e02:1fe1:b0:3d1:78f1:8a9e with SMTP id e9e14a558f8ab-3d6e3f7f864mr42089095ab.20.1743778094195;
        Fri, 04 Apr 2025 07:48:14 -0700 (PDT)
Received: from [192.168.1.14] ([38.175.170.29])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-4f4b5c4b32bsm816259173.56.2025.04.04.07.48.13
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 04 Apr 2025 07:48:13 -0700 (PDT)
Message-ID: <d36bda59-3198-4eaf-9da7-a28c5dfdc3de@linuxfoundation.org>
Date: Fri, 4 Apr 2025 08:48:12 -0600
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.6 00/26] 6.6.86-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 Shuah Khan <skhan@linuxfoundation.org>
References: <20250403151622.415201055@linuxfoundation.org>
Content-Language: en-US
From: Shuah Khan <skhan@linuxfoundation.org>
In-Reply-To: <20250403151622.415201055@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 4/3/25 09:20, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.6.86 release.
> There are 26 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 05 Apr 2025 15:16:11 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.6.86-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.6.y
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
