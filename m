Received: from mail-pj2-f12.google.com (mail-pj2-f12.google.com [74.125.227.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B3EE36A363
	for <patches@lists.linux.dev>; Wed,  9 Sep 2026 17:28:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.227.140
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788974892; cv=none; b=ANqB6WSVGCQcPA0o+ercKLj3RWtUodT42JFqFTW4q+2ne9PTSnLThram4IsmZo4hBzW1v+hRHGODGEEkLh4BG1l6psy6lmWFJgospxGANtXAK/A3pwObHQf/J4K0ylLaODWmIebZNenonjhpSgMmQkoX08uZx+9E7K/nNtC5GEA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788974892; c=relaxed/simple;
	bh=8NppacfHdLDtG5JzX2FZPUFkGO0XjyIiwYMs140ZnjM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=ZCPcRQrLfhCzV4pQl2VA1eydixnYiMn75vCklfi18voY+1CwiczDBnx1W47JAjYUsf/nvfAzNkQg0fuRxTfTBydqNuTdyxjhvtUBtIzc+CAXl5n2IRSfgYoqrfpsxRpnMTonETZ5F6mfxr8BU2KGicxEc9GyqNGSURoXNisJ9E8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=oQmLfkED; arc=none smtp.client-ip=74.125.227.140
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="oQmLfkED"
Received: by mail-pj2-f12.google.com with SMTP id d9443c01a7336-2d747ed9865so4376815ad.1
        for <patches@lists.linux.dev>; Wed, 09 Sep 2026 10:28:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1788974890; x=1789579690; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=7iMcbjfyMphX5/lME4IhFQ/AbOnN1ivDHYpPPxczf78=;
        b=oQmLfkED5Qk2ZANSjn8lFO45PQ8XojkPM/PoTzAFuJOIq/DG4IHx0AXMaZYRJAgCP0
         +O69c7FMInl2BKxKc/n0xhWlwfW+rA8a9f2J6r7xdGu8JiUpNBDJBJ/OOGqmP11GKxBL
         vGnw42Q+2n8Hp3wnW/3gLoE0JSYZgpW4XbZ+WQ3pOU3gazIfpqhL856FjUfeUyRE0ReZ
         XN5plMcw4TLaw4odryyVPvp7LFVP0j0kYJvolcewB3VuWJFT3AfZjz9wqQxjIJLTsO/Q
         9hmD64E27Poxv6G7dykfta+RPTk7dTQoeGPutU8opQAmUU8iWtK1yiyilv4xi/2Ym2WY
         Aslg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788974890; x=1789579690;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=7iMcbjfyMphX5/lME4IhFQ/AbOnN1ivDHYpPPxczf78=;
        b=r5ryNMt1XS/0Kz87bDWEY0hwR7NVfOMTW9X0f6EVQnTuOb/dM5Ks6K/stQRc36Yn9T
         NZ3Xtjb6tORex5CK2OwIC7lp0e31RryZmIxrpdgAC7KkQLBLLDzMf3n5iA4ymy6+LBfc
         E/gb5rVr4LiwSLA00h4dzoXMNDwmAmixkaTM7vYfAtG9lCUmylVYUtpIUNMY0oqVCix0
         DBdqD+qnLURgk+MlTGu08gl+/cainyapG61hwv45Zb7sII7jBIowmjGsE+5eOGrdo204
         SKcGhuSu1GI6bAOOM3/9F5W9NbBNRIsX9p0L7bVOjak1T+8mYEJ1ro+r31W8OHRdBuqA
         Qr2g==
X-Gm-Message-State: AFuF++ndvFOfozfjBzLRcx/LrbhkIHrIk87wgAaTLBjilX4oDcAVBSmG
	eIL2PGhw7eulNeKfXtf4B637mwiLRsVp8BWx8Yszpo1Ix2sx/jJnsrve
X-Gm-Gg: AYBFou1wZO0SQ6KHXCoXsNQwrcUoQIud+HTxeye3Fb+YvM6LTTF3vMirHYsl+lwr1QS
	XN3jK3FBw6G+CSvAoCg7l7lmq1lLe3uYBW7Fq2W3b1aeDVJdmjHEO1ybXcHT+SZbg9No+ESkecT
	dwBHpWkFOAaoYAS+o4tIHk8nLAursFfJlEd16EfxyCazekRyAJIXgJhig0sv5dwVSL7o4et0Fdx
	PNMHzaBkn2AgZ0zLZkpksCxunPF/ytdGAFqvAhPK5MF+jtKlM8GjFjb6Ns4S+0Vy/Sw1UTi9wxO
	9a0qJRMt9oN25DoOOuQKnM77AHSGylJ4SfiFTX6ntoRcnqRKoC82UzavoQ7nFZCoQagUzKpSV0H
	T2AbR2c1tCHDCWWnL64RyFbOa2dPi7yFwwlKFVWNYPGPgGqlNZsjvSPPRfzPVCZdWp1nMc9KfjE
	FnkBp5wmSQQenA9ME9fzUzJLMKyOnFJ/Zah5LOfXHRUQhDxEHYVq+OFT6I91nIQfRjdRrxpatNP
	OYajeTY5YyaHkk+1r7FqOZRTA==
X-Received: by 2002:a17:903:46cd:b0:2db:39da:90f2 with SMTP id d9443c01a7336-2dd07809f49mr31004255ad.8.1788974889883;
        Wed, 09 Sep 2026 10:28:09 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2db1497e9e5sm76340935ad.38.2026.09.09.10.28.05
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 09 Sep 2026 10:28:06 -0700 (PDT)
Message-ID: <04d98c16-9f87-483d-a4e3-b79cc586d537@gmail.com>
Date: Wed, 9 Sep 2026 10:28:04 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.18 000/583] 6.18.51-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, rwarsow@gmx.de, conor@kernel.org,
 hargar@microsoft.com, broonie@kernel.org, achill@achill.org,
 sr@sladewatkins.com
References: <20260909134237.773280130@linuxfoundation.org>
Content-Language: en-US, fr-FR
From: Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20260909134237.773280130@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 9/9/26 06:34, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.18.51 release.
> There are 583 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 11 Sep 2026 13:40:31 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.18.51-rc1.gz
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
