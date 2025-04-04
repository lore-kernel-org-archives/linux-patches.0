Received: from mail-io1-f50.google.com (mail-io1-f50.google.com [209.85.166.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B94277111
	for <patches@lists.linux.dev>; Fri,  4 Apr 2025 14:48:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743778131; cv=none; b=AkXFQXKLPdoDRqzS9ddv20BaZIQ18TCU81BCMjSURpk+0qIIXRuQspx8KnRVTkrViyPX/MCcIl+pjn6nBgbEDTEWOEpYZZhHpLrO2Dz2rLIxD2tdRe4KWX4Tkza7kqFPejI6HpHfdkppxJzYv5lBN2QUVvR2hcQpMBkoRiqIQJA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743778131; c=relaxed/simple;
	bh=N8xr3gZnvBzoAFFMIbubqfbIqdfrBwHBym9C7LusSuM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=ECtD+TPce2RudVJp7IVsephlSWsswIvwo5+iHzkA6HOc8TN7305qgpVqdhyZMLOkC5In2YdSyeYynjfdMMiVbkWwUN041hDguhxDOZZ5j+yzgInoDXqk82Qd1eagcfsg475tV2gAoR2HXM3jmEYsTEDdPzcvHI9QfNhvWi75v9I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=K5uv2Hbt; arc=none smtp.client-ip=209.85.166.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="K5uv2Hbt"
Received: by mail-io1-f50.google.com with SMTP id ca18e2360f4ac-85b5e49615aso187645039f.1
        for <patches@lists.linux.dev>; Fri, 04 Apr 2025 07:48:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google; t=1743778129; x=1744382929; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=WtHOMalSobmJxdbzjcuw4y+jApPaBkGJD3B8y9lwgGU=;
        b=K5uv2HbtSbCsVOhnql60F86o339ntKOYuhpJIf3ZxUwIZnMCjuQA44nbEQeVGZPMtK
         1m3sKdsYhB8SpNf5vKtwzuP/scOtu3qtjqfTc3WJD6NlRB/pjPOHBdNXFe107nOrEK3j
         Gvj1LgVikTDHtu1SraqOQLETQoXQW9qncN0Xw=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1743778129; x=1744382929;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=WtHOMalSobmJxdbzjcuw4y+jApPaBkGJD3B8y9lwgGU=;
        b=i/BmDsDBs4OlkSibs/0YklfjJ7DoAWuHDT3gFX4NVGOPF2AdpwyKt/1oi0Nlq3VxNg
         pANoQxw41t5yMifdx8DPpJGG8Bo5YqIBKsBz4+OR9sGSiJFMgi05LdrVHNiycJUZnsaX
         S1tfocr51twTNFCPz6LiDMPL+gWLAw1+Iubplh1BYUC/cx1WJUYnhZzDqAEuj5/84Awg
         1xw7b/QNNU6c1pDHdl/C7sLZGRxf+HcKnE+jihYH1CdJXfRu7YkcwuQttLJ2R3I6+RsG
         jgej0c4RzPGGxXhzfxG6C9s73NIUw7m3RhU8GMutAbRJ2Y8/oim7kIFmWbHFezKUGI2H
         IVog==
X-Gm-Message-State: AOJu0Yw3pd3epdOoNjNR75utrdc4IVJIla7hYQwpIXaJpuRwKBFIkkU8
	sPIeWLb3I+C4CeLp/Ga7Y0y0HFxxvqOHhtwxo+8bsZwm+Tush/CK6G8j9DtnBMp2Jr42NGPO16V
	o
X-Gm-Gg: ASbGnctYwB9ZDPsOSc7CSilwaxXltWiW/yqSFsew2c14vpzYRPkeAEejQHkBWRJY/J0
	ytrsVY6nZIuQ9NxdSRyaMMUubK+sTgGphbxDSm6DvgMCh1i6L6hwcEDRkEU6Hn66KxOqpVQlyNR
	7AyG4oN5vGA3OVc0Kj4IfeLmab8PeVBw+p3/Bo1ue+E4ZWJ+vh5EbltxEA8zolRyLkAY8jvG9y/
	FF4uCfjmwxitxIU6bfNKHs2QqDsuSXYm9P7Qg9ZaH2X88O2nW+ONfKT/lu2HQuN9Hqg3PLuFVfY
	hLQfjGV4arLJStc4C+Dmsw0USlMf9FznaHWZcyPwvVSKCpmrRK/1Ypg=
X-Google-Smtp-Source: AGHT+IGJgS5dZigzPp1PfoohVD7rTW7eiqP49p94pLE+ryqtZy9qsHkuogejD5wKg72S1cjf28aMZA==
X-Received: by 2002:a05:6e02:1b0d:b0:3d5:eb10:1c3b with SMTP id e9e14a558f8ab-3d6e3eea7dcmr38875265ab.5.1743778129170;
        Fri, 04 Apr 2025 07:48:49 -0700 (PDT)
Received: from [192.168.1.14] ([38.175.170.29])
        by smtp.gmail.com with ESMTPSA id e9e14a558f8ab-3d6de972c54sm8479945ab.65.2025.04.04.07.48.48
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 04 Apr 2025 07:48:48 -0700 (PDT)
Message-ID: <148cdbaa-09f6-4c66-8a2a-1f55b596a00e@linuxfoundation.org>
Date: Fri, 4 Apr 2025 08:48:48 -0600
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.1 00/22] 6.1.133-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 Shuah Khan <skhan@linuxfoundation.org>
References: <20250403151620.960551909@linuxfoundation.org>
Content-Language: en-US
From: Shuah Khan <skhan@linuxfoundation.org>
In-Reply-To: <20250403151620.960551909@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 4/3/25 09:19, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.1.133 release.
> There are 22 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 05 Apr 2025 15:16:11 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.1.133-rc1.gz
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
