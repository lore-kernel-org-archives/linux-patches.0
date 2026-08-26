Received: from mail-oi1-f176.google.com (mail-oi1-f176.google.com [209.85.167.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5457B18BC3B
	for <patches@lists.linux.dev>; Wed, 26 Aug 2026 00:22:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787703746; cv=none; b=kle3MI5biP7iV0oIH/xs6jwypBwAVi2oc6EUdVidXJXsaqyn77Shxk/dxvyyFDzx4RXnbNWaWAxCOYuAeToOw/Jz2M1MGgUQRVkYvCXxmuiP4n5wW35hG5/vRoGSozHrMVF8W0nreAWzftuNdiuaKPS7N0YLrXPRllBDURVWrwo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787703746; c=relaxed/simple;
	bh=XB1RY8T13jA0T4cjU9BDqQGF3UJei2ApS2wdW+xsHXE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=ULpPANy8h9GWq444TlGbM2+BxTa3SaDyuUPHUi9Aq3xUajbD/DwJIJylzB/D/c9B75PDYrNlFT6DVbBtgKZQkCCT2gCQHWemp2FtpTfM4um4fYzmTgmJDr8cVTzhBskPzne54EgFzPAPIMDW6K2STHt1eg/aBK3IShcTFbmDnC8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=g+ZmoP8M; arc=none smtp.client-ip=209.85.167.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="g+ZmoP8M"
Received: by mail-oi1-f176.google.com with SMTP id 5614622812f47-4a4836dc117so260371b6e.1
        for <patches@lists.linux.dev>; Tue, 25 Aug 2026 17:22:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google; t=1787703742; x=1788308542; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=iFB16aiDvphHQjOhP/WCc8GaCWukTfgWxSTCoB27V7k=;
        b=g+ZmoP8MAkWaMQbqmdz44H0K5W2Y8ZXPjuy9E+PywJZOv94xk22GH+NnVyP8zkf9z5
         QWPllVkTi3eTqmFBc0SCaG4bUDAyk2ka6o8CljKRictqC+lOKIuNmnk2q8OElo7+tgqG
         eLqiCdXt3bDogfjvxGG/TBCAe0iGrE8h7Jeo8=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787703742; x=1788308542;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=iFB16aiDvphHQjOhP/WCc8GaCWukTfgWxSTCoB27V7k=;
        b=BOsueemcGXKa6o4dO18Rh9ZMV8ffSmJ0SKwJzJ3u5kL+vWk2EKQBpAelKamaiHCCzh
         dufUhx8u+zL7MXoMEk+xwzPOA3LQ56CflAe38TmNUSffQxteAgsZf6ittaklReWoXU27
         lsuFdPk8C5XVyAXfHxMomatTNnBbzGqClZ7jl1X/DFM0lEsjPHWjbcxnDRtWfItvGx6O
         xchNBpRuTZ5U0mnIObwadjzKBO1344dhpI6cowg4etkDjk2PmWNgyrav7GF9JWoniobT
         9bvyF9rEdKyZiBIWj99b5PXmkNz2ekIegQV9RfYMcuX7twNx3E173+106zea6kKwRIo5
         3LvQ==
X-Gm-Message-State: AFuF++l584A1ghchoQwRmVHq98JV5MrYwyPXVNIEQoqZi3YZua+nTiRL
	SCowClJElQorD5xyuwbsn2IFHENe6HAzk8Obf8/wR+c3fqkRCwFqbBruUJR2uxM2K+U=
X-Gm-Gg: AR+sD13E/V/8Ml+1EsTbIYrVYWHHH+KLnhZd+BUm1PNUgHyPVx0qPy8BtMkDwBHbXja
	6sByikpGLOBo8Tdbj6Tfxb7bhn8XytKQMkFOkE8eWj3NobG5YL1cnm4lUipm56EALy3kj5lZqqX
	ncQJ63PoSoJ3bh09kLsX3WSMYkAoej9SaxFpk6ywxaHuIcBVRZtYqRk0/lyt4Cz14OxB+mCcQlF
	jodby8FIQd1tPe8RmTPHUkOPbPxjCM0ibNEMtauIumyQvDt0xKCckC7O3VfUyUDShGcn1t+Oz1e
	+RmeXNaq95uQNr39CKIHnkODdw0oufqZ/sbDCGyjL7lVYx2vou5DW8hzdUqWZ9MOyx4RV8p1L/s
	ebXu14EklNjcER+7nbYRA+B7uPoufiwhf3fALA6+/ohnSr4NzN+yjUSKsXQ1zbBAQSsSQ5NNF2J
	kOzpvgMfBzytLU94btVSt4MykWiMoMz9vwo9R/G0Zsp3t3aqTX/wGrRkE1xitejlSz75S78w==
X-Received: by 2002:a05:6808:2e4a:b0:4a3:ff0a:e407 with SMTP id 5614622812f47-4b366b1fbb1mr3801973b6e.15.1787703742192;
        Tue, 25 Aug 2026 17:22:22 -0700 (PDT)
Received: from [192.168.1.128] ([38.15.57.99])
        by smtp.gmail.com with ESMTPSA id 5614622812f47-4b36ab734ddsm310256b6e.14.2026.08.25.17.22.16
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 25 Aug 2026 17:22:21 -0700 (PDT)
Message-ID: <905b62a6-d038-4509-a80f-94c73a00dc84@linuxfoundation.org>
Date: Tue, 25 Aug 2026 18:22:15 -0600
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.1 00/79] 6.1.185-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 achill@achill.org, sr@sladewatkins.com,
 Shuah Khan <skhan@linuxfoundation.org>
References: <20260825132541.677185791@linuxfoundation.org>
Content-Language: en-US
From: Shuah Khan <skhan@linuxfoundation.org>
In-Reply-To: <20260825132541.677185791@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 8/25/26 07:25, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.1.185 release.
> There are 79 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 27 Aug 2026 13:25:02 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.1.185-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.1.y
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
