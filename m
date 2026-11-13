Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.210.54
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794608823;
	b=VWh+Jw+HMq1SipQMC5MLXuPSEORNv+rYcTftXY6RlYnupGVOmByJ/dC8A+omHWKtay5m
	 bB6LuQ3jJC39/sygeX4tN640oeWou5bhWy+8/HO+RssfbQ4zGsyVyMvlgCO69Yp/rsHnu
	 gN3N9dq27MTNOd4C47KaeBsqFc9+HR5riz9/cgs1Qs4qlsVY+c3OGq3A24UgbgyVjyLlQ
	 B0nMvaIUD1hxiYpWys2X+7+cwSvyPIJ6p2WUwIfPU5rGAXvywl7OljPshdUldY8jxe6uW
	 /jqfdZdD5392pjP3CA0tAKnraTxQXRWDJZV2mZJgP3CWbWlu5gkJwcDNBgKHqLvOEhw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794608823;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:Message-ID:Date:
	 MIME-Version:User-Agent:Subject:To:Cc:References:Content-Language:
	 From:In-Reply-To:Content-Type:Content-Transfer-Encoding;
	bh=8JTpanzVHjsYyfTqgNv/v2AlQs8qfVxkL+bAMQRdOVg=;
	b=eYI/69IVFUsgtpTUEa2vE42Lmc4+q1MSHTkc+F2R1feDMFHukLH/hieNxrH7LwcRrDdl
	 ipKQVydax9hrnLDk7XQoppskT5ndOcRT3NI6ySObla0Mey3owhFz5NTaT+m3VqAFHEhOW
	 k4bCasXchXp85NXqlONdpANv8teLvGyMEryF78MvqasJysHFxidTDa3hV5x6AReO2sLW6
	 2U+bay/f0B/lcBn2rdoUuiXW4LCt3iRLSgF40QzaKZZueJtAsXAs1+uHmtH2aJC9fUxww
	 NKWYbrS0NjIBbxenVBpsHh6kmS9KthyI5bZJI/0AQVekg2ZPstabr4E4rI9MnQrQndg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linuxfoundation.org;
	spf=pass smtp.mailfrom=linuxfoundation.org;
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=google header.b=hssaI2hR;
	arc=none smtp.remote-ip=209.85.210.54
Received: from mail-ot1-f54.google.com (mail-ot1-f54.google.com [209.85.210.54])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9AF28606A889
	for <patches@lists.linux.dev>; Fri, 13 Nov 2026 22:27:02 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 9AF28606A889
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=google header.b=hssaI2hR
Received: by mail-ot1-f54.google.com with SMTP id 46e09a7af769-82380b0f55dso506066a34.1
        for <patches@lists.linux.dev>; Fri, 13 Nov 2026 14:27:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google; t=1794608821; x=1795213621; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=8JTpanzVHjsYyfTqgNv/v2AlQs8qfVxkL+bAMQRdOVg=;
        b=hssaI2hRz4VX/3zJu9s8Az/Jch1IkAgs0MV16K0LocFPxQeF/U6Vpnj1zaRQVjJcib
         3koKa04bOXm8sNEyoCUoGSKfRyK2ra66yKby5BeZ/3AP6aKtTK12F5uM2RN7iqEkM/gP
         ULnPIeQCcsvXiPG82DIXdgI+QZAwPRHdK3gcM=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794608821; x=1795213621;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=8JTpanzVHjsYyfTqgNv/v2AlQs8qfVxkL+bAMQRdOVg=;
        b=AeJZod8/qehywTqqffA39dMXaiAOC7myaIa1CRjcyC79fakfOC9qLY4zyXy45ePvNk
         J0txdDTR/bWgzkdaljch5oYbxmQu8Nb1hEgUlPjVs74cnnsKeDJCeeMMFsILdun599po
         gLXJwFHKlLvH73EbJRhD8Nmz6CFC1iqp0/t5sYQGVCMHs8sgPU7LV4QHSU2aqzdTvgcw
         3jzqXC0UuL2I5mMtqETeUT1fNQniTPmPOXrV7s48ryfn27m+QGVvNHmrVumaDjOBpL6p
         lWh0hiL5QGWgVEaooQaCzinHHpbufHlAgpynxGPzekRx/AXTHE0o60DT0kVjlMTHRDTJ
         oJSg==
X-Gm-Message-State: APuU4Z+4CfVmNmUWa25TWn7OT9K1ZC9Bebiq+esuLGDzVIGzp6wE2hCu
	dawzmRjECNZnYHX1fmqypZ9nQo90SVAYup6Zwb2qDZxpAMlEhwW+NWXFTHiSiwcKEpU=
X-Gm-Gg: AYBFou2che7moZAZDXIlciTZBLPfjbRwRuhGdCZi8S0oovO8fCbc0TdOwUObuqotogq
	2wRFsljBR01zPEeeB9Lmp6nT7NGA1tMvaNPza92zIMT87BnyG33B4nLnsvGvQH7SZfoEntazmZx
	ZChwHIx7sPHIUIpaGFbeJXT3L64QI2+6o8js6xFaMPrMzmbdwPaMG+B43CtQf6m1JZhM1uRL0w1
	fWMqu19oMWhu009SSTxuUiZTDusH0ICoSjBw8wgCvyPUUrpWmBVP7p2lTEvqcZCzPQo7R0t4Rer
	GVcxVPcOw8BDtSxu84BYrWgvQilrLCl23/SxrKU4DyLYY6y6pe+zU6+Huu4JObhsD3uxHx4sKuU
	wl9w1LFK1NwCDIS/sUKHZ9MibRBR+U2/0EjVtOb8JoXEW7wtvhQvovwjR2ujAC4DZV3IrqJII7r
	orgPQYKvW31OULK7wgQwxKF7NjdP7ovVWnsIKlcF9l12qyrrwW6ZGEl5OGDdjtYymf3cDL8tM0L
	RErh4xo7Jf3cnrR28iuUSRkN1nK94IHcA9YMMIIS4ZZvN9zDiXFCbAcJn+MTJP5q6oOMtWjoy7o
	7k/u9jWRNskYAbeFIPaqWJ82e05dgJ9iogwrm7E=
X-Received: by 2002:a05:6830:924:b0:7dc:c7aa:22c7 with SMTP id 46e09a7af769-862895381c3mr4868916a34.0.1794608821646;
        Fri, 13 Nov 2026 14:27:01 -0800 (PST)
Received: from [192.168.1.128] ([38.15.57.99])
        by smtp.gmail.com with ESMTPSA id 46e09a7af769-8628813346esm3412398a34.17.2026.11.13.14.26.59
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 13 Nov 2026 14:27:01 -0800 (PST)
Message-ID: <0b626ecf-3c4b-42d4-887a-9b11dc473edf@linuxfoundation.org>
Date: Fri, 13 Nov 2026 15:26:58 -0700
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.18 000/686] 6.18.64-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 achill@achill.org, sr@sladewatkins.com,
 Shuah Khan <skhan@linuxfoundation.org>
References: <20261113153820.902362109@linuxfoundation.org>
Content-Language: en-US
From: Shuah Khan <skhan@linuxfoundation.org>
In-Reply-To: <20261113153820.902362109@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 11/13/26 08:42, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.18.64 release.
> There are 686 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 15 Nov 2026 15:36:17 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.18.64-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.18.y
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

