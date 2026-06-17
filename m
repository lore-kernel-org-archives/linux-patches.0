Received: from mail-oa1-f51.google.com (mail-oa1-f51.google.com [209.85.160.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9277F35202A
	for <patches@lists.linux.dev>; Wed, 17 Jun 2026 17:29:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781717360; cv=none; b=h6LkqbJFlQ44ZLh5jRFJ0c73xrVVOL6eHufw8Vtu0Nsd+MG73c3Rx9VXaTQ7BaSoppvM3vg6t7PJxoue87Kl38vLNLECz3PIXtoyD/PPaXO8m3MoDK8P7qODExR1Owy9vkY8VJwlJit+Ucm6Um4MeDxbgQrViXgbneLQLn2psxE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781717360; c=relaxed/simple;
	bh=02BJK2ZfcsamB2bEa8rD3M8pW2i0eiOTfmEB9cAJ3iI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=nhg2W9Iw2hhvrVLSqn+8DdCAmLkQY1G3r5j2fIP/u8dkOXtewZcWMLwIpHeDIym1Vrn1dhMjMoIWwtl22zAo81k8IxogficoVxGP2qRKKboolRfcXEJODEusSMfkqKk2UHNDA/HSf7pESzRpUyhDtNVezk/Tfkx3VXL4yxzeyYE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Iq8Vnlu9; arc=none smtp.client-ip=209.85.160.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Iq8Vnlu9"
Received: by mail-oa1-f51.google.com with SMTP id 586e51a60fabf-43f5e285111so3672809fac.1
        for <patches@lists.linux.dev>; Wed, 17 Jun 2026 10:29:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google; t=1781717357; x=1782322157; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=VpJEmEv6Dlzji0c1FgDwTrEHITjYvzcZOoSTVPustG8=;
        b=Iq8Vnlu9tJzX4Cx7Qgg8/0fiFoyAKlbsWZvNcbHM6GsJbxyM0j/lhxKo9zohxjM6vL
         AmMfdva/31LSXBjLd/0q3BfKACz1z9CEKIPej3nzk+JHNKRawnqs2G4WpppaN6qMqhSq
         m4dvev2uxQ5RurMitzO0wo1mLYEfqgsXBMZfY=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781717357; x=1782322157;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=VpJEmEv6Dlzji0c1FgDwTrEHITjYvzcZOoSTVPustG8=;
        b=BGRPJw4KQmqh32MeYteFDugrqWH9yJIWUi23oBTLN6YeKmOGuOLNmA7YAwP1pgXo8a
         iBr63ddLij0ePx3PF1jVoBS1f5QZGrTZV4J8BXx1pZx5wXh6gfGwqc6axCu05ZV2JP1y
         GQa8kGfv8pP58fLqjl4PPZCdOMXGRpLM98TppSCV4oku//Syq8B4zB+feHpxVd8U04Zp
         aXg+W8betTX5jvbaWn7/21g3VNfReche+tam2Z5ipCnqSz/df75k8t8jKCVbwyyVEcJ4
         kzLJMU3VWtEoyAQdexjsbg7utBtgpEreHodth3G90TAUBshEmTzI4yh4KhcOXHS+MABB
         Pzww==
X-Gm-Message-State: AOJu0YzbOAFSp+5Yyr9p/4g9N7/3f4Q35JWJcOQBs0YBTufiHGtPGrMG
	CnRVlnr8jNnRkYqiAC/7OO2b4uQvOU+sCC/PL0OSaihta1Is5HObW8rHFbN2tZQWa5y4YLI5uv8
	o7an+
X-Gm-Gg: Acq92OFzIMTXvQv9ZKGpXdALEcuRpCIxA1hbga4Tkznumwv2UFXBuBGPrVI+2y2/wyW
	EAklPRcaGS/gZjbgq2A+vupLM4ZubUxPrN8A/+xYljzc9sl4u0mNO59Zrih2nje6WUsRqWzbznT
	sbWia775PSgUvrJ0zCxsU8uKUx01O4n8d4x5KsBgZKrYeJbFHa+4fEcmqIh/rOoiSzOGQlm1H+3
	pha+/uNazsV5IlzA3WWeEX6zr/081/V+++mKUKbo95mTBxc4/KVFE5CFqyQMQt0D28/8fJqopEo
	XjWBXhwQogS09+ph8n5E7xKbJHEu/0AUXvGKuXJwv5rKYREua0Kfi0CiEJnh2yP5uv21k9/MWLm
	OBVYpm0mPyT+HoAREUdE30Ns9DFjA1U03X+v+02QCFLmtXeWq9ie005uXp0ObNzloEBt2Oxtka8
	vlUckujiqWsJ8BqANsCoIBOf387qU1UTA=
X-Received: by 2002:a05:6808:1210:b0:484:c3b5:9b11 with SMTP id 5614622812f47-48942bad140mr3688005b6e.36.1781717357498;
        Wed, 17 Jun 2026 10:29:17 -0700 (PDT)
Received: from [192.168.1.14] ([38.15.57.99])
        by smtp.gmail.com with ESMTPSA id 5614622812f47-4875ddda6b6sm6499310b6e.8.2026.06.17.10.29.15
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 17 Jun 2026 10:29:16 -0700 (PDT)
Message-ID: <cdf1b806-9327-4c74-b3b9-090b9f78e236@linuxfoundation.org>
Date: Wed, 17 Jun 2026 11:29:15 -0600
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.6 000/452] 6.6.143-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 achill@achill.org, sr@sladewatkins.com,
 Shuah Khan <skhan@linuxfoundation.org>
References: <20260616145117.796205997@linuxfoundation.org>
Content-Language: en-US
From: Shuah Khan <skhan@linuxfoundation.org>
In-Reply-To: <20260616145117.796205997@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 6/16/26 08:53, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.6.143 release.
> There are 452 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 18 Jun 2026 14:49:57 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.6.143-rc1.gz
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
