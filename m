Received: from mail-ot1-f50.google.com (mail-ot1-f50.google.com [209.85.210.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0741042123B
	for <patches@lists.linux.dev>; Wed, 22 Jul 2026 17:16:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784740587; cv=none; b=m4bfNvtntvblAlo1JPdaqjoH8DYAECxY0rTkbqAJlg88a2T00VxQGMWO5zYRAYzr3kq3VmGuGMxTdn5j9d3TE6T01miorBw+Qd4kcOREEqXl9baggUs8i897wT4Y0aKZ8laFoIv4c3eD4RJI03mC5Q9nMF3kmHS55bJCab7tYUo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784740587; c=relaxed/simple;
	bh=kI484T49IdlFyKZ6ymqSXB7r/2MnN9NzxJVXNfyNpr4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=IwouDVTALg5NxNBTmC2hojFVhY1y6K8kiTlMOXYAu0Oix0J/tVocVotWglU8nS0pHWhY8ZPy59FcFASm1KppScj+9QSTPOlmx1mD6S6+qybRhe2bPXxJmlkjf2RTI4wHHBnYqrE3gG3I/mHOZecJfK5NFLbmRSfCiveTtIHMFas=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Wsc2O3ai; arc=none smtp.client-ip=209.85.210.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Wsc2O3ai"
Received: by mail-ot1-f50.google.com with SMTP id 46e09a7af769-7e6b554044fso9957220a34.0
        for <patches@lists.linux.dev>; Wed, 22 Jul 2026 10:16:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google; t=1784740584; x=1785345384; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=F8i2hMLvis/bSEBIldeXCE1A3TzJ4qPXzcIblPSmycQ=;
        b=Wsc2O3aiLoQVjurFXsdmghi7sT+ObVw1hs2OGU+A2JXkjqC0hpa9pG8BzlSfF81APo
         c5XoINPgYicoc1jOjeKbbL2Yma9T6CAgQcU4z9JKh1L+YOqtg2Z4MDWdArrlgBi70kVG
         UN2BN+4TLEqPatxFtpQnvvtJD3muoebLJlJcU=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784740584; x=1785345384;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=F8i2hMLvis/bSEBIldeXCE1A3TzJ4qPXzcIblPSmycQ=;
        b=PeXt1LQyGAuLKw+GlnttmDkmJYgkkxbGDV5j27JNrlcnDXSB8FMDRIl+Olt7oRysho
         ik0w90Jl8K7p/PRuwjTnV59uXEFbak3FXLFN5tMvDItrjN9ld/IsUHDyvenKVJI8QiY6
         sjzbVjhdsc9nx3wQ0B+LMoulYemA7hqqFGLu+t1xe4fgrmz082gHZD6IltnGxnYMW5R4
         T8VklOuPOll9T7msIY7U9SAP79vMrOyF0LbxKmVVi6rh/jm/SwB4HsvOHFryY6gLsr4a
         xpAPZMBeaMsjbMpsrHYyJvjQ7a7JvZFiNSZ839u1c+f7pYt2pPwVGB5awnW41PNW7M+c
         SUWA==
X-Gm-Message-State: AOJu0YxDPc6Ave/dLsEcQl9ndDzbD59cK+oMIJoKartSRGBhSAxiE+PT
	Zzu7b8H0cI2CW7VlLXuQE3C03tVxsuPK35pfYermP4l++8mRR0ifKTJpVR8EsugRdmQ=
X-Gm-Gg: AR+sD12Bkcbz1vRuAxYDFEq3dkJs97uwURR8AnTMsnTGohQV1u0FNNQcHgotJuuNjWu
	mO/NoYkfwBC6wUTfiTB5uBAu+fMijPV3OaKhBei5J3rSuOf9wduRVtaqlPiT47b8BDNJWlGVZSC
	YqD24p/idFirLgV8Ras3Ws9iTld7ozO6G6k0190q7yOG8TJJrdXQMA/7QwkKqC27Yj8C5k7IxtQ
	BIuAh/1ijSewFhAPYw0QHTVrSqVc3N8vOBQ2kiaSDgf+5X4emUICGdT2+MONJ9JR5ReHnRGc1fx
	7quLsMhJEeIrz9l5KstNh1Xm1RiO4RkCAo2yH5tsVtZmZQHow3QMZDLOUjTCb83tevpLZN2VgsD
	HktZOYqkvyTjvfByMfVFfRpTjsc3z2N9BH2m7QRqwmDAyDgyqLBaJT3yvv6PINsO354COwCsEj2
	SKAAfCVaIKdJg=
X-Received: by 2002:a05:6830:4195:b0:7e9:d3aa:e391 with SMTP id 46e09a7af769-7ed9aa5776fmr12417851a34.6.1784740583864;
        Wed, 22 Jul 2026 10:16:23 -0700 (PDT)
Received: from [192.168.1.128] ([38.15.57.99])
        by smtp.gmail.com with ESMTPSA id 46e09a7af769-7ee29e0ec50sm1872169a34.8.2026.07.22.10.16.20
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 22 Jul 2026 10:16:23 -0700 (PDT)
Message-ID: <01cf96f9-763e-4c20-8494-1b0388622678@linuxfoundation.org>
Date: Wed, 22 Jul 2026 11:16:18 -0600
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.1 0000/1067] 6.1.178-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 achill@achill.org, sr@sladewatkins.com,
 Shuah Khan <skhan@linuxfoundation.org>
References: <20260721152424.521567757@linuxfoundation.org>
Content-Language: en-US
From: Shuah Khan <skhan@linuxfoundation.org>
In-Reply-To: <20260721152424.521567757@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 7/21/26 09:10, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.1.178 release.
> There are 1067 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 23 Jul 2026 15:23:00 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.1.178-rc1.gz
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
