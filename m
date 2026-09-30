Received: from mail-dl1-f46.google.com (mail-dl1-f46.google.com [74.125.82.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A807C3DDAE9
	for <patches@lists.linux.dev>; Wed, 30 Sep 2026 19:08:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.82.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790795312; cv=none; b=ORcY1WqA7ioPgVwqFNc5D5GP38Yw9B/VmeHk+Z7os7uA7gnsWFx1AQVhe+8dBItQ/zccws8+7Jii2sX3++n2NsTJKp6e8Ej0aCYWO9Csubz7gGlwpgMz3NANUgFdBQP50ROAlKwZY3utMkylQ5xxeCd4a5lrrMt8cHtliWGUQ0s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790795312; c=relaxed/simple;
	bh=vqOV2uF0Ci7vXHGhVG0nXnSb9mu5dZuiChUCnPPFeKo=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=O4AHJXPpP79I6TdbIZvyLfHNrHhjkG+7fEUm5i28FgxXpTjildDabKQdBm2vqOPnEMti6+Tk9pliN607AgeRAmfkPnZy/qXPyzdqk4PWF2vsdkuswcKSttaMoFcHh25+293G0Ok8RApkcPMUEIFBur2c9EaE0v1xQa5AlSeTYgM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=HCSGD630; arc=none smtp.client-ip=74.125.82.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="HCSGD630"
Received: by mail-dl1-f46.google.com with SMTP id a92af1059eb24-14327018b37so22817c88.1
        for <patches@lists.linux.dev>; Wed, 30 Sep 2026 12:08:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1790795309; x=1791400109; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=d+JAldsdHwPu3ZufnjHdhfOy8fAoKYsgi/utsa5zT7w=;
        b=HCSGD630bnxSxnpF/OUt01obsac1Tdj0XgWAWWjxFClbg25kXR0oIYshFqBURGEh2p
         1I6gUOIqbqMUeRRUKNTReoryAl5E3ZdqJG+/VjhHOfz1IqhiEUsfU9wVXCPF8wzb8TkP
         Trfsg1vmmtLAatK7JPJJ+P7EDcuoI6oEfOz5VmEVCucGFGKA5paqowzbFXorx7EyrmYJ
         Zedp5snSo+c5jSBKexFJzza61lnj46ySLIV7cy6r4/kUz2J6LIp590OSg2J1glmMrT/r
         cXkjBZyAXCXn+Qi6pTcGgZZfHwZm2fpvZApHlQFDca5iKpzH+grFVHfryy4dLzEwJRJf
         eaGw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790795309; x=1791400109;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=d+JAldsdHwPu3ZufnjHdhfOy8fAoKYsgi/utsa5zT7w=;
        b=DoSNswF/bLMKpDgPZidiqO33iyqQyK8N1e6fzaaHH5FUhAdcYaRAtjJFS8ZVdh/Amc
         TkDRkvbJ2ftJAAgj//wQLOud8RnyHgmPEO7sXfPU4OZ7DlV8YzRToMp1dJw/wRqVi6bd
         h2kDKTD14c+/R641S+kEihiBGAhFid/HdMIkY7jfOWYYcZRSAYY6A5mBG/wHFB1/Yh4D
         6XC+/0WsHJvLx/6fx0ST9LiWgpvpHd9bS2SU/8rVTlyJpK3OvuJH9JvOqxNavLu5umyv
         Q/qMiK3qoiDbcAMrtC4tIjE1iCrsPXWeHORrdE89biAoX42qvxe7ytLBlmJgR496WL9s
         vqsw==
X-Gm-Message-State: AFuF++knx8+jT5retwVjA8BgdaEJOW+AOSTAoETxmQCPBDyM0u0m1cnh
	4w4BaNwg996sgPScPdaoJ9G4ptKCY21MhcWYUSZ0teNUump4VJ2SLgFs
X-Gm-Gg: AYBFou1s4mrgbGVuFqCGckTo+f5nLUUGXDBvjJ/hSlaP03ObEH9k5bK37WNWD5xD0zO
	SoHw4UPPhvJJDa2F3LdX0/PgaMsXN2umUc7GvTqFBgOC3hnKSk6G4BpNj5PjRylrhZXIEpIZhZM
	LKdQoinAoRGbvWtZhp+wM2SMFcjCG3xORjy9QsxFwkgb/vY7FKyrFfy1P8O73P1AnTUlFFm1e0B
	MQCC3dIl/cINANHZ4NKBF/NfQfNNyCyrTIECsXyk3qzoE6ntDj0Iqbk0QWizsqt0jF1XMb90EPm
	lsKa56X33F92xAiTlEuRwifGlG4nz/xbRjWb5FStOhjZ1BV6AbJBA4HZcsDIUrUaWGtLJEG2hPi
	spr8A10qd5Vlxj8QUvQclV4RVoUhU/kagvquAT+H1vuJTsXQcK5BRGplgINDqe8ICKR+2Ec52Cw
	H5Mt4mlVM84+EFZ1ajab6WgzzDqEo8xehl1yRtAJT0eazpiVtmsy8R5DITr6KkrOgDJmcp4ds/k
	3ZbkvFoH1kxFyWdGOhcrl8/d2a5vKGkPBd9lTo=
X-Received: by 2002:a05:7022:1588:b0:143:1bb1:32ff with SMTP id a92af1059eb24-14dd129c6bfmr508585c88.16.1790795309223;
        Wed, 30 Sep 2026 12:08:29 -0700 (PDT)
Received: from [192.168.1.3] (ip68-4-215-93.oc.oc.cox.net. [68.4.215.93])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-14df359f15asm285867c88.4.2026.09.30.12.08.27
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 30 Sep 2026 12:08:28 -0700 (PDT)
Message-ID: <a9cb7dee-2c63-46e1-ac1f-ad996b4eff6c@gmail.com>
Date: Wed, 30 Sep 2026 12:08:26 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.12 000/877] 6.12.112-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, rwarsow@gmx.de, conor@kernel.org,
 hargar@microsoft.com, broonie@kernel.org, achill@achill.org,
 sr@sladewatkins.com
References: <20260930152414.738996857@linuxfoundation.org>
Content-Language: en-US
From: Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20260930152414.738996857@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 9/30/2026 8:15 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.12.112 release.
> There are 877 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 02 Oct 2026 15:23:04 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.12.112-rc1.gz
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

