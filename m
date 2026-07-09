Received: from mail-wm1-f46.google.com (mail-wm1-f46.google.com [209.85.128.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B2753ED5C9
	for <patches@lists.linux.dev>; Thu,  9 Jul 2026 09:45:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783590324; cv=none; b=NtC4q4A4tZqu9F2mCU51jmby8/0HTfZ9pj9D3SJ8Z2QR1UVVRQjMAzjeBQdj9Uf/ul5Ciy8pM/oL+/Oae01Nh7yBF8EUfgIpMSxfZT1qBYNq4rP0OQwHpAATNqTSeC3cT5mGh5gWpdQr3mXLDLVJrT1s8kDKqM2LmWzh1p+JaFA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783590324; c=relaxed/simple;
	bh=DSolsTJGzHgc/OGPLnKXWHYDHDOGwzlUJFKfR8ob8ns=;
	h=Message-ID:Date:MIME-Version:From:Subject:To:Cc:References:
	 In-Reply-To:Content-Type; b=hLoPC9Zd+H1DvXO4sCtz2gWLXAUIU9DE4rzmY+HPgjRam16GIg5UeyJLeV5R3Y9O9EId9xQ1cWT5rC3emLqlX5qecLRGccKFLhU7A0Ua5O2Ji+Qwqj6kODhYXYRKB/3+sjnPjFrh8B+WUiIkQRfFthCfaqhuY9+d2KDQLpGAqH0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=krTaqGcS; arc=none smtp.client-ip=209.85.128.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="krTaqGcS"
Received: by mail-wm1-f46.google.com with SMTP id 5b1f17b1804b1-493b7612475so14273255e9.3
        for <patches@lists.linux.dev>; Thu, 09 Jul 2026 02:45:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1783590321; x=1784195121; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :references:cc:to:subject:from:user-agent:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=tFZF/5PoasW+xKTZ1VUPfW3HZ74KzO/QxbfEs8dmJ+k=;
        b=krTaqGcShxVcjU1xWCHizVbbg3ncEzIGQD/WiOPG41ofL2vP1y8nT+nqHgFgBuWTfA
         ZOGTnhsvXdnOmQTl92BiFyYUI8MYQP31fyHqqF/5ECyn8oeWFPe2JxumWQBp6BHL6Vcd
         NBiSaEYGM8hbzntuJxGQjho34idGQn/sHFoGxR0I0qawrdBpgNddCiHnTUGekgoYmcUA
         /6yafqTwgfDPmnRB/JK4Ya3S4ICQtA6YgnX2l62ozk/zBTiOvD4xYnVVUS9B5Tat2OI+
         3LF5bv8ZNOdeYrqN0+S+qrMWNghR4umUZA+d/PM1ZA+8pCwjcNv5qIpjTnpyqV/UL38y
         5w4w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783590321; x=1784195121;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :references:cc:to:subject:from:user-agent:mime-version:date
         :message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=tFZF/5PoasW+xKTZ1VUPfW3HZ74KzO/QxbfEs8dmJ+k=;
        b=d7aaH9b6zEYEfxujyYlGQl8ovy2i547vGGT7XjKFvORcq3oyVIa1ltKH1NR3s/c16E
         6GmIR2YL/gH/ECYeqNIAExkOySHzCigY9UFiMMcNkPdnff7pQ/VZCciS3GouSpM33ld1
         14/3NX5MsVjD+/o2l7GmasOcGNYW5Tn3sbyY+Wfz+BVKwt8Y3WataXVcBM9fyO363bU3
         g55qSFMQvNhubG094/nBZ1eLQ5e8mjLJhGrn5Yac5Zg++VLWUwAtoUoRJFxAW2wAbVjX
         Y7Spw+WF5lzCZxJtfdS3mZpqh0qsmQjLSA1Yb1KzQMlL3mkgMECA1EPELHknw4gW1Zqz
         M/dg==
X-Gm-Message-State: AOJu0YyM9RFr3Li/Foopv29My3wxFUhKbkKIRUOF0UAWbhc4FLIcLeXJ
	n8P5JSepR6hVo2B5xvaTUIIqEWfE5gjpUfEV6QrUsII1AaSDEUs3/1wh
X-Gm-Gg: AfdE7cn5Rtmj6k4Wnmn6y9p2/ZCnkYRuurMI/tB+hIDhJL78RM5831xGOD3oyspg90R
	ql93/o8dQKOQIa0TkULKhyh0vxg+qYHTLTqA/uBm2wFuFa0c21j5KixR97nQVYJ3zisuat80u9v
	xY/6Ggnz0kiNyYZL6O08P4ibIFZJgV7D27mYKP8a54ZIYhn+o1HxNUCMw71c5stzFbLdvoO0ibM
	oCRKgzskUUYoqe3hOUWPwretvhNsJUEKG8ABD95PhK8/YQsa1UvZOS/SbmOiWm2qIbv7szck8kh
	p54OTvcnR6GZoqBvWJ+hWqsbBwVpKHSdAYY3/AHmir27V6zR56MTPRWW2LWuM/oq674oEJDn0lj
	v496vPZlgynVea951nQYEtJx6bBxOGnKRYvv6ETrCm1ZnxR7H2ZizlSbflzuBisgm+uN69q1YBm
	4h8bAi4IKJMpZD9PU6VV4fvsMp6adwGCGVE5gS6OFWJ8tObGiHvTxJMaKdiuSBTaaIADXzX0Bw
X-Received: by 2002:a05:600d:6454:20b0:493:cc01:807b with SMTP id 5b1f17b1804b1-493e68815cbmr47157235e9.38.1783590321156;
        Thu, 09 Jul 2026 02:45:21 -0700 (PDT)
Received: from [192.168.0.105] (88-187-52-200.subs.proxad.net. [88.187.52.200])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-493e89eac4csm50367185e9.0.2026.07.09.02.45.19
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 09 Jul 2026 02:45:19 -0700 (PDT)
Message-ID: <34b7e26f-df63-4523-b4d2-5de13c192a8c@gmail.com>
Date: Thu, 9 Jul 2026 11:45:14 +0200
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
From: Florian Fainelli <f.fainelli@gmail.com>
Subject: Re: [PATCH 6.6 000/175] 6.6.144-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, rwarsow@gmx.de, conor@kernel.org,
 hargar@microsoft.com, broonie@kernel.org, achill@achill.org,
 sr@sladewatkins.com
References: <20260702155115.766838875@linuxfoundation.org>
Content-Language: en-US
In-Reply-To: <20260702155115.766838875@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 7/2/2026 6:18 PM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.6.144 release.
> There are 175 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 04 Jul 2026 15:50:58 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.6.144-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.6.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

On ARCH_BRCMSTB using 32-bit and 64-bit ARM kernels, same build failure 
as 6.1 for MIPS:

arch/mips/kernel/smp.c: In function 'stop_this_cpu':
arch/mips/kernel/smp.c:396:2: error: implicit declaration of function 
'rcutree_report_cpu_dead'; did you mean 'rcutree_prepare_cpu'? 
[-Werror=implicit-function-declaration]
   rcutree_report_cpu_dead();
   ^~~~~~~~~~~~~~~~~~~~~~~
   rcutree_prepare_cpu


Tested-by: Florian Fainelli <florian.fainelli@broadcom.com>
-- 
Florian

