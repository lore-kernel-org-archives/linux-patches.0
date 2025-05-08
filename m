Received: from mail-pf1-f174.google.com (mail-pf1-f174.google.com [209.85.210.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 15A4E1C3306
	for <patches@lists.linux.dev>; Thu,  8 May 2025 20:12:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746735122; cv=none; b=Ev7rGCl9TsMLqIVcg3EDr85Q4nVb2eQltvW16LXH9VleK3peiAA6jvBglAMKukoXQyjB0iabNDyqDuoO2pQIYQT/el5VUFFYnQJ00IraTyFcPKNWVJNrUUuK38vpvkfv3to9gfDMduDXceOFiNYG274pYZHMHkX4cEfhx7fE7dk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746735122; c=relaxed/simple;
	bh=k0wwXn9+Kglc/htmR5mqLgpkq0ooGdmYiPqFrSisiog=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=hDG7L0gV9tkibvgQP9CfzG9PITjtNK8jGpQDIru2e2aqByOqMFYnI29EvFBmT0VRas81Wa9LmdcdFVSI3A4fjp5/JrcKX+E4R7amiiBScYkXJJb8Ofw1Pc7e2YSUbksQrdc7tPKcOBPrsroi0aDvAOHG4w2xPHT9VOx1FP3eCYA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=goJ533kj; arc=none smtp.client-ip=209.85.210.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="goJ533kj"
Received: by mail-pf1-f174.google.com with SMTP id d2e1a72fcca58-7398d65476eso1276975b3a.1
        for <patches@lists.linux.dev>; Thu, 08 May 2025 13:12:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1746735120; x=1747339920; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=aw4B1u4HPbJNfnMuBelVDNrfn4TFJHyKA2ta4iSdBBM=;
        b=goJ533kje4//hEnxsRNjZP3Xx3BXEjbQC5IcthhtyZ82k6QYGXBKiFMgvhkULYMO4H
         PBsXVe5q74fJEBzgG87Mz+NwZhsScrcvB2rES15Fp3vKIt8KsBa8XKDPk+bQj85oPUvy
         o51TEOA4L/w8QlkIRxLV4HkPDSsCB5LDoV/GeywozrZYtBBxz7ixNdlwxa4ivx1SXgRP
         fqmwfrvxcExuA7Q+PTxdCstEYO6Kak9pcifRjA8rCFtSpqOCtXlvLQw7RyzwYtr84Iw6
         DrW+zzi8X89vUNrX9odtp/62OZekxxS4Sp9VC8oJ3AFUW8qIxvuyPGOLb1519RtYoKdM
         bBoA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746735120; x=1747339920;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=aw4B1u4HPbJNfnMuBelVDNrfn4TFJHyKA2ta4iSdBBM=;
        b=hiLEu8PmkgiV4pUC+aQhbnBJZpFauPOWaPSNvQbVdJPSEhq5eOd3BILTEsh6SZaB7H
         KlgK0RY7aZFCdeWEAfrY4uEB+H8RekCZgAt1SCt3xzHsJ7DhkMeskRwaRjMGGdEX4liW
         qaYWXd0YizP8PD+KPtNfe1IzS6n5oOZZzNxwFHG3JbXbug/TEKJuZnCXdirP2nh63uK6
         rqBEvKP0G0GGhC5BpMOx9cUDYv1uOZHOaJjsrgDknuadstxz2zfQfJrdtPIhZGGpdRV9
         O6jyhHEQY6EskrrfKVxTyGBP9CLXDq3TTBeDYebIzSXDKx0tRbN9fypG23RxuMt3CXoy
         eaoA==
X-Gm-Message-State: AOJu0YzNYBzn8taLs+cZO3jGxRuLvXwt1qFya8iPJIum7XjgsI4swQ1Y
	SAOKoKQUI03uuQqPU6t4jWFJXRlpREgyFTRug40wJk/4CtB0yKbo
X-Gm-Gg: ASbGncsOqIM5Ykj6PULHJTZ+2ICTdvPa63w1GVOPwao4r252eKjXC2QbUh16mDg5Chv
	e1cNqFp+xo5sD0kYqybQGHBHBaP1CjvgSOiztvzyCerTPRmhxS237tE4mBXJAzYja7yTWaICyBZ
	c8vLajbZ7x7arvEPlFQOj9+0ngwafoovWMF7yv8EHDgkimN21RM1V4T+XMdFQLNl5YiMuv80Qw0
	y4la0ltAe4wMN2e30vGKpLSfIn71MjXyA+oI1OuoESFhxUrP0Q703TWKj15FaombFZGfjxDgevL
	XYRcAjYds4Kp4Zj4jCjH3aqk5bUbxJljK0uPDtoHOvS9BS4SDiJkX5dxaufbqMaFp6JhlHGX9y2
	r8iHX
X-Google-Smtp-Source: AGHT+IHpt5aPkaQLSd1QA23UtVwpqaETMta8Cc2kQrD0v6amxVQTqNzfxXJKS2U5zxDPJcxd2wofeA==
X-Received: by 2002:a05:6a00:3e20:b0:732:5875:eb95 with SMTP id d2e1a72fcca58-740a9316019mr8520617b3a.4.1746735120241;
        Thu, 08 May 2025 13:12:00 -0700 (PDT)
Received: from [192.168.1.177] (46.37.67.37.rev.sfr.net. [37.67.37.46])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-b235198cccdsm241367a12.64.2025.05.08.13.11.56
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 08 May 2025 13:11:59 -0700 (PDT)
Message-ID: <a98e39af-ff02-4f1d-8902-97a5a183c2f0@gmail.com>
Date: Thu, 8 May 2025 22:11:55 +0200
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.6 000/129] 6.6.90-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org
References: <20250507183813.500572371@linuxfoundation.org>
Content-Language: en-US
From: Florian Fainelli <f.fainelli@gmail.com>
Autocrypt: addr=f.fainelli@gmail.com; keydata=
 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
 WlfRzlpjIPmdjgoicA==
In-Reply-To: <20250507183813.500572371@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 5/7/2025 8:38 PM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.6.90 release.
> There are 129 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 09 May 2025 18:37:41 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.6.90-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.6.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

On ARCH_BRCMSTB using 32-bit and 64-bit ARM kernels build tested on 
BMIPS_GENERIC:

Tested-by: Florian Fainelli <florian.fainelli@broadcom.com>
-- 
Florian

