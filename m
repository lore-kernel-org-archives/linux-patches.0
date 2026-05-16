Received: from mail-wm1-f43.google.com (mail-wm1-f43.google.com [209.85.128.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1551D38B12D
	for <patches@lists.linux.dev>; Sat, 16 May 2026 22:22:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778970155; cv=none; b=H73RWb1PhzuwX0dA2CCii+f/tuxaZBsZfdccgVz+9iGQR+KGwPUf1gJY9+NSbQFdTRwdyg2a7UCoOq56HrCNeg+2RIXEDDen8p52ymzPl67tOBPLpWGYC7r+2lR9sUP7x5XLca3K7Wz0NfV5gJPPox0avsKW3ynbCi719xA/K4M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778970155; c=relaxed/simple;
	bh=4jugQan87WW62OkdA+/W9xo3plv+dnJsx5zP15FbgtA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Y/1TTI22RjydGAhe5Xva+tOlZUPxLsW5uduLipWjCxETso88Z6S3AYnIxCQ/StW60mzkB/dG6dEzQeiCk8TX9dedS397KzuFBdTbXjoF32nxpN/fjr+NV88P0f9SuHE5Pi53vuq+NDcPT9qXJwa+H1voaDzqI3EAbKSIxhFGw7c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com; spf=pass smtp.mailfrom=googlemail.com; dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b=O47vjcB1; arc=none smtp.client-ip=209.85.128.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=googlemail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b="O47vjcB1"
Received: by mail-wm1-f43.google.com with SMTP id 5b1f17b1804b1-48a3e9862f0so5167295e9.1
        for <patches@lists.linux.dev>; Sat, 16 May 2026 15:22:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20251104; t=1778970152; x=1779574952; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=/KJ2iP9YLpv0fim6ZmaqIgPF+/tIhMj4Q1ToMIsKE5U=;
        b=O47vjcB120QhskAwgA+Mhi2Bdp+dJ5mlzLEhkD8/D0mubUK3NLEChEbtDXL5ZyIgX1
         ePmi0cglJIMV6LpeevFWNZXABb93W2bOElg/nYBAfw6dyJKTm4IjcpD32PeUgNJ0cXwf
         8ck1pd1GS2WZutoaL783RIAhujkUYdbdt5k0xmhqf/fR0hICTSCarwdSouc/IRwYcfga
         Ds/Cai743kOtF3gJY5RXJQNPsCkdbH1J1wBYccxESI/amTbcFjogMQBM5/RM/rOI6i6V
         EzzElmOfwN8xugoL77+0xx7SEpiPXic4mdi/khrK3nC801/7lNceVCixKYtJ757iJIYr
         Vndg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778970152; x=1779574952;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=/KJ2iP9YLpv0fim6ZmaqIgPF+/tIhMj4Q1ToMIsKE5U=;
        b=Fu3iWLPIS6gBHfGdn0cJcyWX+7q04WOVdlAZY9Y6uktFJu0gTeVzPn8kOnvN/Yul0K
         K2B6v4pUOp2Jvruj42RsaOVb/d8fS8PhrHCR1LVpIFOH1yHznAxJbjWIBgBqcg70ePQy
         Yjklf1IGl1UdxOoK/DPTldd6mGVeQM0IJI7SdEPqUXUqU4DaZlYxKVnIMlBKJsDqP8EB
         bKSzDvfITinPh6k0KL8KPAi7eUogwarRyqG4rCZwBC5yvLj7bfB3xKIPQByvsmsOBG5M
         KKv3rSGmFhatbSwNC6YMWinGRwJxsa+sKIKmjD2rRrO/ay/0iQ0HOxDYSBzcHO+kHh6R
         r3vQ==
X-Gm-Message-State: AOJu0Yz34V0zFUiszLgwPaobqaYp5bLUz24KQ5EToRhsqEpwgmv2qjES
	ar6uok3aVslU37/Vr/fuU+6TNqpFLcVcEfc/11UqXyYOWKUjgN9FfY0=
X-Gm-Gg: Acq92OFbLSRnBsu4d3hXeKnkKx8YiPcur1+0/OgSGISOthq/TXtEPczqHnb4uHq/VQQ
	fBbmiK5GuH00vkVQd6s0xoTFTwNIzYSwSxaVj6oga851+ASRf4GWRw2RG1vXM2obr4RinNYiM0L
	jmuZvyvbA3pDBO65Y3y/XA1GflsLxrSYe87/aDceUP19cZBwANcxALSVll+SMcoUIGa75gma/lU
	KWpntPQmRSuqTDWxdFuVaf3K38ltOnhbyyFYZJEHw2njgK7euDZr4JdBXd/7i3CtOPqkcOEzv69
	pRj+RAFfxRMy3f4sxbtH89MLdC6g8ko0ivJIlIcAQhmBtKcJOr1OIr8t05FcEtiL2huRl6fhKUr
	JB+PqtUeIT/d6sVSP9wJbYCBCswgKVayI9Q7NBJgKuI9NZEhFZzaXuHtaeUL2CHkxXjYQe5nIUM
	MKtcSx+pZGCgNRiSVHQDXaPDU56R89qQ9wfnuhUQVIjlUoJ4M1MbpFGgKyDuwavHfnxvkx6J2Uy
	DoKYdm+TmhNKA==
X-Received: by 2002:a05:600c:1688:b0:488:c21a:4754 with SMTP id 5b1f17b1804b1-48fd646b8a0mr131869295e9.18.1778970152386;
        Sat, 16 May 2026 15:22:32 -0700 (PDT)
Received: from [192.168.1.3] (p5b2b4b92.dip0.t-ipconnect.de. [91.43.75.146])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-45da0fe13b4sm25463416f8f.28.2026.05.16.15.22.31
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 16 May 2026 15:22:32 -0700 (PDT)
Message-ID: <31029eaa-1d73-4ef1-8849-85b0cbd9a52e@googlemail.com>
Date: Sun, 17 May 2026 00:22:31 +0200
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Betterbird (Windows)
Subject: Re: [PATCH 6.18 000/187] 6.18.32-rc2 review
Content-Language: de-DE
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 achill@achill.org, sr@sladewatkins.com
References: <20260516102236.209957148@linuxfoundation.org>
From: Peter Schneider <pschneider1968@googlemail.com>
In-Reply-To: <20260516102236.209957148@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Am 16.05.2026 um 12:30 schrieb Greg Kroah-Hartman:
> This is the start of the stable review cycle for the 6.18.32 release.
> There are 187 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

Builds, boots and works on my 2-socket Ivy Bridge Xeon E5-2697 v2 server. No dmesg oddities or regressions found.

Tested-by: Peter Schneider <pschneider1968@googlemail.com>


Beste Grüße,
Peter Schneider

-- 
Climb the mountain not to plant your flag, but to embrace the challenge,
enjoy the air and behold the view. Climb it so you can see the world,
not so the world can see you.                    -- David McCullough Jr.

OpenPGP:  0xA3828BD796CCE11A8CADE8866E3A92C92C3FF244
Download: https://www.peters-netzplatz.de/download/pschneider1968_pub.asc
https://keys.mailvelope.com/pks/lookup?op=get&search=pschneider1968@googlemail.com
https://keys.mailvelope.com/pks/lookup?op=get&search=pschneider1968@gmail.com
