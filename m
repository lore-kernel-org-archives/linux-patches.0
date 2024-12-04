Received: from mail-il1-f171.google.com (mail-il1-f171.google.com [209.85.166.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A6FF620C02C
	for <patches@lists.linux.dev>; Wed,  4 Dec 2024 16:56:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733331421; cv=none; b=loQpObAKjFFcJKM+HlMZpFmPAt66uOoF9yioLOuvSZnkuQxpVWqlkOIijfFHwkwMUBHK73Hf5WEETk24XYZ4wwtpjBZge84i0oQiHPc+s38w2mFSK9y/6Z9XzvTX8Hd2B3QB8QgwoxRVKAYqbgdOkUvdrsNJ2yEQBO2KaAdIZbU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733331421; c=relaxed/simple;
	bh=XaoMXII8e6mfuATSLsXtjEWnRh3UwxsQH2bojJPG7NA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=cLJsfb5LWKS799hNVvTs5lJcV0K03Q8mNH7K4C7o05wzXSBCpCHzw4uCIfStfumnbPZLmv7YxQ6nxru+umItlNv/XPqHg6pBJAqqGlllVYfpYt/xX6hy+VdIvGBBOMZonAMd6zWZ4uolBnBKE+IvZ4pz1pzwtJfgHI9vGQhuOjE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FNw4JHk2; arc=none smtp.client-ip=209.85.166.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FNw4JHk2"
Received: by mail-il1-f171.google.com with SMTP id e9e14a558f8ab-3a7e108b491so23704675ab.3
        for <patches@lists.linux.dev>; Wed, 04 Dec 2024 08:56:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google; t=1733331419; x=1733936219; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=7iTXrzkVbRdOn7ya7jAgMy2aC6OZ+AghQ3qdoT+WQZ8=;
        b=FNw4JHk2f91K3/qARqQ/qgygEqk7ak1iUOmRtP9+AludREFM33lkKE16gR9hJzAFim
         oXCtOaIBD+IvfbZodaELJS8nM/JyRMxx+RHUBwctHfSSdnAE6+fF4N9tGWFHl2JHCk6T
         Lc/uhITgHC8E8G0IHKpvMcg9go+nvjbGg46SQ=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1733331419; x=1733936219;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=7iTXrzkVbRdOn7ya7jAgMy2aC6OZ+AghQ3qdoT+WQZ8=;
        b=O9SgPqzbNTuETcHyGwUIwDj1HTAB8lLrku9DLXa5ZxPPztoAtaLJktgXH4OOke7H5F
         JoussHcmTmnLnURiUxLiWVvYBzAETDcRFR9euXTDrr/ypnxIFr7mjKYyhkTgMineSfYA
         H7PGPyu8Y61I4lDdLZ1cHsZjTs9FSjehYdh9En3SzMGx/uEgziskjYa2r0rOL9wTlRK7
         PY4Yc1042lf9ZHYIX/eOxaU+zdDN0vX9PmtfG/eSx0SVEgfNALqrqBV4aYIoINs5/nO1
         +JUWaruw61ZIzbqgt7pa43Rxf2wJlCOzbcix+aV9Sz6Hzro50WUiK5Yz3p+1XBmHvRxC
         jfXg==
X-Gm-Message-State: AOJu0YzSgJ5MqaWv05aOadHrwfPilr0zk6ohP6UcAFyKocPaV5glzdyp
	su3EvwBGwduBldnJU06xWP3EvcgSi9RfmRaXQiwc1lHT8sHD4H1t7n2XdwBhOW1MOsH+9/H/vts
	C
X-Gm-Gg: ASbGnctSIiLphALHNJLIV3aRfRFHA2rmUOhdL75Z/15vME5TYUpxH8yejJCRyZkygOs
	3vt5CfNZ5j68JSdN6cSxaldpJmHClWWhnX4nChqFUKN9uIzGCyHy8+ibBWqhPlEFHLuf3ZB+yaY
	GiQ5HG/22EmV72jWI8G9p9R6YvxKweo5MLr3bhnn5dWF5nb1UCFboah3o81rFmjZ8ReBdjOS2GZ
	SDLaXToaF9v5M6XbwDaWK6S1+Mzxrpxh+qD+I7eYhujjSeUslOuo+g3fnohiw==
X-Google-Smtp-Source: AGHT+IHYHfBvUu0DZFh16zcxTkFpKxetrmBGHduH1Px3jq7+qvQd558v6EZlAarkWJRanQMBCA2qaQ==
X-Received: by 2002:a05:6e02:174c:b0:3a7:e0c0:5f25 with SMTP id e9e14a558f8ab-3a7f9a2952dmr79789725ab.4.1733331418893;
        Wed, 04 Dec 2024 08:56:58 -0800 (PST)
Received: from [192.168.1.128] ([38.175.170.29])
        by smtp.gmail.com with ESMTPSA id e9e14a558f8ab-3a7dcc6146fsm26878105ab.74.2024.12.04.08.56.57
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 04 Dec 2024 08:56:58 -0800 (PST)
Message-ID: <8e7b4812-bb10-4f5f-92f9-86aa33203c3a@linuxfoundation.org>
Date: Wed, 4 Dec 2024 09:56:57 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 4.19 000/138] 4.19.325-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 Shuah Khan <skhan@linuxfoundation.org>
References: <20241203141923.524658091@linuxfoundation.org>
Content-Language: en-US
From: Shuah Khan <skhan@linuxfoundation.org>
In-Reply-To: <20241203141923.524658091@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 12/3/24 07:30, Greg Kroah-Hartman wrote:
> ------------------
> Note, this is the LAST 4.19.y kernel to be released.  After this one, it
> is end-of-life.  It's been 6 years, everyone should have moved off of it
> by now.
> ------------------
> 
> This is the start of the stable review cycle for the 4.19.325 release.
> There are 138 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 05 Dec 2024 14:18:57 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.325-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.19.y
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
