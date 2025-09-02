Received: from mail-qv1-f46.google.com (mail-qv1-f46.google.com [209.85.219.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D57013451CA
	for <patches@lists.linux.dev>; Tue,  2 Sep 2025 19:02:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756839770; cv=none; b=rmO2QXoiZNvYTscUA4ObAyEUk7pn193Re4HuFdRUxqnHFfPtFnAJoix7VCKZd2D72eovuVLLWG5uwmcs1Vf007Cw9iS7iFBSevI0ryhqwqCz+Z5ibBvjCBxofrNcSQH/LBFiVkdceGVCbhsEniIZDk45CAYf/B4hLlLdhe8bKT8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756839770; c=relaxed/simple;
	bh=HkcNc2m17+XClu97tQ7M8DyDCI6zfFSV8KjNgglm614=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=EBj6NsMr3S39OffA58ANOjUzds9hpI6Hh8d5dTvgVaB1GjLzmAqUl+mkKNNGd4vE/iXyX+pNcTW/rzO0+4cW8Gcr9xB7QjySGpUGyHcBiAQl4lmiqsM6V2LDlJ164R4n9XCFgjcdPQTQHGsKKhb869Q6dHQTYoSPhQ+du8duft8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Xl46EvhP; arc=none smtp.client-ip=209.85.219.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Xl46EvhP"
Received: by mail-qv1-f46.google.com with SMTP id 6a1803df08f44-720f0dd2809so5891946d6.3
        for <patches@lists.linux.dev>; Tue, 02 Sep 2025 12:02:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1756839767; x=1757444567; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=Ij3T/Iq7U8QtnuXchf+BWF5w1PmRhpoHZpQyoWdQ6+c=;
        b=Xl46EvhPR0yc52rNYd4UcBPb+CfL5AC0StoUIwmggEtvjPQybYsf6pyE/sOYTNTBtN
         0PX2X+X2L/dHicS3/utmdQysC2oaE/lrn7GNRcdmKJe7POiAJgiD3MQtoAdzmaKNE4zc
         sRB4eHIj8EYcaSYFs7S8HLV1dwvJM0CfNkLDNlvO+cofJHJjtLLOAQNS/ogRL6KknuSJ
         0FfUc/5SIctj8+OpbGpLiyfT4qXODyU/RysSYMcVnVq3MqC2aSimRVg2G0gPi20SdFVd
         MhFh+3CDTn+oqh/Cr1jRX7hdjExKZ1UuG6dU0OqyhfHzXLib7sZGNe8dbPYswMQLB1Vb
         IdWg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756839767; x=1757444567;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Ij3T/Iq7U8QtnuXchf+BWF5w1PmRhpoHZpQyoWdQ6+c=;
        b=TvXppcae+PbRizpkpv8F0vLwBBGv6rrJmAtIdT4fW5UyCy2PT4pCaFQiSoTgxcEuR3
         VuyMqm6YrD1NnrEqGFsD0x8Nn6OE0Q3rz3twgDk0k3MkN4Xim5vY8mWuYtcjnUHerJas
         ZyU5x0/EmBeZsZLrm58gh308FcVvtpA6IFD69gPiJRR8On4pL242JjCjARm22flUUrt6
         YVuSNDVyZS6+YFzRZx8ViKM2YpTHVLuoma8utXOwo/1YDJ/XZxKrLfb11NBnzkwJvjp8
         MJYuUcdbNpVDAbdCMSXIHUUIPhNscARlW10sPPZyuPsFNB6bTDlsUITTFo/ltRXNkQwi
         o0vg==
X-Gm-Message-State: AOJu0YyVH5t5oY6AANrzoLqqqoMStXD15h6E9XQBit5hx6uCGJMZojfa
	otfvxkPp6Draa+q6qYfbTrTpCjHqH68MqbVO+JF+0t5k9NB+a4nBDFZE
X-Gm-Gg: ASbGncv1DH0P9ADZLkhMHISV6vgzFH7mhTGATbc1+B1ZDAUveRC1XhPckB0KRDLGAcE
	5eEErjfAQu4/la/9y+lFClGfR284x2YZ4bsDxzLQC1N6GNuCdJfEvjN4GmA9aS0guXUsDAWx9Et
	X333nnVIlZxenR2y3QhMZnkeJuZmJnfUCrBBYJOn9PHsfYsCicn5mM9ykBOXv54pXZDfMZiT71t
	n4iLs+hmBinIRIAm2JNDXQdnWKWCvS8uGJ1bfe2Mjxc37fZ2YdRDAL1/D99r4iBKuKr+0LmOL19
	HfU1ivTvzxqrQfPZm6Ll5Wd6ZllJtMBIav3mDa4SaVhmX/7RSQn54IeRO579IJXrhVix30vGFUk
	H9w749Zq0lZb2KCVcKEiGhlqrAHRbvFbP8Aspx43+J/OYHoS5AQ==
X-Google-Smtp-Source: AGHT+IGn9mO7rvgjXLCjs6fJgBCEFLOZhY6IcSWV6Neruv/fYtq1iOvVP72VqjRYWpl7BrigGf6SwQ==
X-Received: by 2002:a05:6214:2262:b0:70f:a04f:233b with SMTP id 6a1803df08f44-70fac88dbaamr141766736d6.32.1756839767406;
        Tue, 02 Sep 2025 12:02:47 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-720ac16deffsm16216746d6.12.2025.09.02.12.02.42
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 02 Sep 2025 12:02:46 -0700 (PDT)
Message-ID: <8eda7a50-8d4b-4974-9ee8-6e69065e9c90@gmail.com>
Date: Tue, 2 Sep 2025 12:02:41 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.1 00/50] 6.1.150-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org, achill@achill.org
References: <20250902131930.509077918@linuxfoundation.org>
Content-Language: en-US
From: Florian Fainelli <f.fainelli@gmail.com>
Autocrypt: addr=f.fainelli@gmail.com; keydata=
 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
 WlfRzlpjIPmdjgoicA==
In-Reply-To: <20250902131930.509077918@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 9/2/25 06:20, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.1.150 release.
> There are 50 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 04 Sep 2025 13:19:14 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.1.150-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.1.y
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
