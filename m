Received: from mail-qv1-f46.google.com (mail-qv1-f46.google.com [209.85.219.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C89A33B52EE
	for <patches@lists.linux.dev>; Thu, 30 Jul 2026 17:37:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785433060; cv=none; b=nayykLlghJajOpe3kJITRus9tSRH9plMxHkcZ0wiMXfd8Jtv5Wdt08EKw+l0GAVPBw/Afr+lKzhzWgeWGUx+3Bso4l2BnpUYLDrwuwyFDeTiPk0IOLCGQX24oXLogZy3D1NkIOStyVZY3NRs9f/NxI46vVgjQOIp8FQ+tVUlxCs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785433060; c=relaxed/simple;
	bh=KEHws8kTwmKOCb/5Dw26fUo58ySVRtn2uks4rXh1LU4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=MrF9MthFf8KkRn4PcSusJX5kO21ltQXjwwHopboLqBB3cR6OvF9KsFyB2LDLPEGW0uDuxUjuee7HaZ68Xdui4oP57ya3hTIBYvjx0L8IM2vj2p8X5VENSIxQzoxoiKI7aBD+eia9wu2WW52nD2LbCBrF4Jtx1Lhow3G/MEhQeU8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=hjQ2F3jg; arc=none smtp.client-ip=209.85.219.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="hjQ2F3jg"
Received: by mail-qv1-f46.google.com with SMTP id 6a1803df08f44-9034b6b7674so1157986d6.0
        for <patches@lists.linux.dev>; Thu, 30 Jul 2026 10:37:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1785433057; x=1786037857; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=gsJy5cWyjmORQNt6G3D0DpIqpcWadnp4i2dysW8ERHs=;
        b=hjQ2F3jg2rAbtcuXT4PbihtQWaLIE5tOtNuuSz0Hp5ozsnlY/5n9agem1Kcq67CIaS
         xYRNhHQvkjOF3Rf+isDVt/jNiUIr9uN+oJ6bnuKdav46NNXwxQBzwJG+aq8a5EiahwcP
         bQqYPlSxNuBSeopdXsLU2idgjxpxBMzA2RzCOOpAV2Ze2nW5jQuhHzzAgqPe4SBCGmDB
         oJG4O4k5kv4y4RvF9vmszB2geilZYn6lDYV22SzalX7W0w3Oe6PxuZQ4s5LKeHF9mTq8
         hC5mns4yV2p1DbwvYkmic0gtK6k0hwBM6Bo94iXvWqS2fs7A9EnB6QyvWomwDfViST+K
         FjTA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785433057; x=1786037857;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=gsJy5cWyjmORQNt6G3D0DpIqpcWadnp4i2dysW8ERHs=;
        b=K/MyOxGl1Qjf6AelYbhUKnSBet+xakza+EgKqIRjYynOK+g4paV87cXD06E3mFj4Vt
         CsgLMOTD3Zw9IabdwvGd8Vr6gCJD94pg9IlN/N65j2BRkRb9WSBSt2Ah1gEh6h7e4YCP
         BrGayoIvD4Ig2xkjzss0NCkKHXYxfI0CKxCGdbhB/kBj0n1JUHC+K4euDbxG4icSeMaF
         OhLn8aK+u3+UrNwsrsQeccLNMgm3d9dwOlgeaDU2Frrvvggxagig5QeMz5iNBpJOCVGX
         txouFSkvH2JqUT3VIdMsGy1tnh+dczDgPzTJwRmpYDTKOiK9+2zmo9fS5P5feFd4LNEV
         kX5Q==
X-Gm-Message-State: AOJu0YymC9Cuhv8pgI9LUFFTRmUg0aDYonr3KAhGcDb3APNSpbLDOt++
	p83zCmB6iOfixHFGH1tYNgfgUEmjq+7+oJ2PrdsitrzJalOSd6EKiFAY
X-Gm-Gg: AR+sD13zcKQel8S0z9t/uz9kgv7OQmKvvWv7vLIPVeQdinFyy2Jznb8LzOeZVv8ViMW
	Ac1WaZzjsfNVjtdWtAnkl4q7nqnfUiFtmBmDNxeRy6e9gWNEPonJmM2w0cCCMWryrksaNjhSiee
	Cn5Y2Z6USfAcKGXKxWImlnOYDRsnk6+/B9FkgCG+1LCqU5wu99QOaqq8+pvKyENujp14tFCDY79
	jONWFOZWE2QwoTtdA7Rfvr060J4z5Z4PfMInIXC1s5w5kXRa9HLHvZSew6Ub6evRcm2eivRG08d
	gJIvMxI+jww0DAsTb0C5ulpnTEe1zoTo0Rx4i1SWxveYk94CMAUp6/3QmJgn7mywfw91Ax8N/hj
	yk5VOTAyNpw8O5ARz0sZKqIg43891aVtYFFHGz8vOA4GjCwryN0WLkBfGt4Yhe10T3096gpDpcD
	Tkce4k8oxfXJHb8/eaf9QwBMO2oqdcCmvYjuxCfq8iqbLf4sR52TQR1vqohwcAfX8ne2F81lQNd
	968f6HbpZnTBkNvGitukBMYtg==
X-Received: by 2002:a05:6214:c48:b0:8f2:67bb:a37d with SMTP id 6a1803df08f44-9083bdf2959mr10195586d6.57.1785433056435;
        Thu, 30 Jul 2026 10:37:36 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-908322faa60sm22392056d6.3.2026.07.30.10.37.34
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 30 Jul 2026 10:37:35 -0700 (PDT)
Message-ID: <c40caf39-367b-4949-9eca-037a588a4509@gmail.com>
Date: Thu, 30 Jul 2026 10:37:32 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.12 000/602] 6.12.101-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, rwarsow@gmx.de, conor@kernel.org,
 hargar@microsoft.com, broonie@kernel.org, achill@achill.org,
 sr@sladewatkins.com
References: <20260730141435.976815864@linuxfoundation.org>
Content-Language: en-US, fr-FR
From: Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20260730141435.976815864@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 7/30/26 07:06, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.12.101 release.
> There are 602 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 01 Aug 2026 14:13:43 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.12.101-rc1.gz
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
