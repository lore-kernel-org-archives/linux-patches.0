Received: from mail-oi1-f176.google.com (mail-oi1-f176.google.com [209.85.167.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A09302D7383
	for <patches@lists.linux.dev>; Tue, 12 Aug 2025 21:29:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755034161; cv=none; b=KimPSwexC/p5iTyFfbmA/1pPTZdYsPa8Jvb+nd/b4JDVLWfP7kxI6mLHw0AK61NBODzp2z++JgHrshG+vwqidqNRL3jH9DRdFV3h1joVTqmg5yZKj1w8x92AgZahZ6mjOEc6NP+DHETqtCNgaYoPEfa9Mkrd3IcWkSoa3ahwv7s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755034161; c=relaxed/simple;
	bh=eGqZCroda2wJopOF3l+REjl4tR5Yq9+2gAley7tEEew=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Ipv3OdC166EhujEBta0etoSs8vaEADPLc9J0oaMA2YE4NOYNUycAjuDQCP2cxA0biyyaaPBOwhYeybXsbeP7zzaBxvijLNLA3fjaWkHXQE9aykGLYkGL8IWG4bEodtIr+CbDtbriTit3CcNZbj60mPsxZBir69aZLIb2XBWDsBY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=PiA3FWlx; arc=none smtp.client-ip=209.85.167.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="PiA3FWlx"
Received: by mail-oi1-f176.google.com with SMTP id 5614622812f47-435d0a95c56so424312b6e.3
        for <patches@lists.linux.dev>; Tue, 12 Aug 2025 14:29:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1755034159; x=1755638959; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=ZLeohoAGJ+hVylKDxkihOkXHb1E9F0dH5sp5SD+x3pc=;
        b=PiA3FWlxkthCcQ9gq713EYKdF8KZYh6MjjB1l3sLQc1Sw4pL0eGQsIKrCYPGIXaH38
         Xer/0CavHAoUkEmAjQy4kvxZW3GA1Ftv+cOViAsDLGQ9UNiDoNKJ0imEsGwp8vn3uVVE
         HPKyw2YR2N1uIW4H/RqqM9pQsSbaGMjMJ87KrJQPETb0rEacYCcF3yW45qM/KWb81iqO
         M9ruwLVeUpPtR/Z+Yt8XAR6b9fCL/aHfmYwv03REuLMp0UptQdpRf+kO18y/M4v7xJrW
         Cgi+POCNtjbR5sHvmyosuzfvB8ta9q6MIRQB3lqd9nMSuMUuYAV53C3J93r983qKRNQW
         nO6Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755034159; x=1755638959;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ZLeohoAGJ+hVylKDxkihOkXHb1E9F0dH5sp5SD+x3pc=;
        b=eS0PgoRY7TkcsOymKt3NHhVEHNQZ4ForXg43H5Eu+Xkg7haqNl2M92OyZp7z4L/RbM
         L4QBd2HUt/hFzaZ7pAtikyVR+q0YeybSvfxlt4bsuJ7zk7AA3vPcEC/VMyPPuWXgcJgd
         RSn4yFy//F57L/o4XxlEtElw0c78R8ZIu37rbaXEJwZGcy+105ipOAVzROUaY7T+ScG0
         ufyF6ccjGnVleT6GHiVE22+GiPzN94uoK1+lKbBgdwQZwbsPGaRXZvIUPK1WvWLysM4y
         8i8GcNtygw+kyrpNniLFVgwLwfXVN24dzNPPDfU5bdEVchiOWf9drWGZ+3MYGrTGFCD9
         pOlA==
X-Gm-Message-State: AOJu0YxpJcpQtETmlzC+hnKRa7d5Kewc9bVYYWGcRWAJxU1xbI4a9CNe
	Ickg7F3ARcoxtK7nPElAh3uJKvMz5C1pr9Qf+auo6tFxGu/8fD12POic
X-Gm-Gg: ASbGncvzPKZ7bVMM5gu6k2bSM/cChCiXDx3DaIwLEBs2BY5Q4B1gQZ//PBON34uuV5f
	Oypwyjsc413NN4sLN9TGguRFTbxMSqJ+ULCfvnAkfWJ+seevHVGFg1XooBvsJ3JgItvtuoUf3Ju
	Ajazv+icAHKfIVn6qjYJ6Jn4s+p+e9iXINU8Mhb6JTNc6ufO1VgcNuI7aS+y9JagAyoGsBZ2DM6
	yli8SLw/E5GedXqIvaUFBtpQquV4vsBS6/To2jWdlpGvHP8utnDb7laxNO61VPIjHq59w2+4JY9
	zcqbPxQtIwuVRAlWpu/NP2YRiobtwjccphySZuotig0BZWtzZQ/dpwbwPFG9cl8Ws2AtjBRA9ZY
	1yNA3gRKkXvc/Qqfou+9d6qlafbdbTTHRoGxF1YTzlT13pfqYaDoVnP0=
X-Google-Smtp-Source: AGHT+IGWVbUN21tmOA5DQIBW20HuNxcOZHa+8f5mkd53ppc4gWWw8N7yD+V3DBAFt9EaMmDWFFrpww==
X-Received: by 2002:a05:6808:1781:b0:420:81f1:32fb with SMTP id 5614622812f47-435d4275049mr530209b6e.38.1755034158685;
        Tue, 12 Aug 2025 14:29:18 -0700 (PDT)
Received: from [10.236.102.133] ([108.147.189.97])
        by smtp.gmail.com with ESMTPSA id 5614622812f47-435ce85683dsm365938b6e.20.2025.08.12.14.29.14
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 12 Aug 2025 14:29:17 -0700 (PDT)
Message-ID: <f86afb24-a328-4b20-ad4c-e8f5b56eeb24@gmail.com>
Date: Tue, 12 Aug 2025 14:29:13 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.6 000/262] 6.6.102-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org, achill@achill.org
References: <20250812172952.959106058@linuxfoundation.org>
Content-Language: en-US
From: Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20250812172952.959106058@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 8/12/2025 10:26 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.6.102 release.
> There are 262 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 14 Aug 2025 17:27:08 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.6.102-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.6.y
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

