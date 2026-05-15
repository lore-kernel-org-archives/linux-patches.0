Received: from mail-lf1-f47.google.com (mail-lf1-f47.google.com [209.85.167.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ABFFB3C1404
	for <patches@lists.linux.dev>; Fri, 15 May 2026 22:46:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778885168; cv=none; b=GW+0tNBv8v7fdBbckTZEs+A+3XD0ApuIqSiTikuLUmmeiyuooigwkiTqhEelL2EjFnHhm+n5HiGLBap8BHnBbBEkOe1fB84L7pm65yex1+pYNOxsw811lZLEyDba3ywzlgNBHR1Hl88K3O/duZZDcaKw2/vKdzOPW49KdHumMFo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778885168; c=relaxed/simple;
	bh=4VWdYZOeSXPXzHYSybAygONbBj/ffb7fn+UnSWUUdsc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=qN5/tQqSOqwXCDhHSMqMlv/PbaVU7nQQePB7L4g0/gCr/+yzetNUGJ0Rk+uk2DLPbJT43Wnz6vtJTFcQvZ+8RQJ85rFtIrI+1C+Ya2QYgkrlVvVlnb+wWvGnZNBPQfX4BsWL3LPptBbrefqqMOeZEnRbvWlyrT4nf34ZOL2aUMw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UWuxpGhE; arc=none smtp.client-ip=209.85.167.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UWuxpGhE"
Received: by mail-lf1-f47.google.com with SMTP id 2adb3069b0e04-5a87782588cso375736e87.3
        for <patches@lists.linux.dev>; Fri, 15 May 2026 15:46:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google; t=1778885165; x=1779489965; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=84CRE+I2YfK1j6GPeY5z65m1K/HjZDHpGYmsC5LRKQk=;
        b=UWuxpGhEvLeMCZRykKCl2tzxsK5RVONCWXFe4vs3oWG8KlNoMD8X1oQGWi/H1ZMsyN
         xF0sH2NwIPnakoQNz61Baq+7yh76Tl9TxKdzpbM9Sw0ErnY5NrI2ETP6yZCxEZEwLhXM
         J/njlQDIun53mp6w5xOGW0ip2r0dod0gQIpAo=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778885165; x=1779489965;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=84CRE+I2YfK1j6GPeY5z65m1K/HjZDHpGYmsC5LRKQk=;
        b=XYOvMUasKpKn/0jjKvBR2xKRkTJ+ZOvJrlPj/+3PSEPsy0GrqQo26qbUS3zw+b74Zl
         oUYJ6AWdIE7prD2R2nn1SVqfL3tf3WRF+IprCbr1PmXNuQR/95reKwJNa27Sb+1sC2Lt
         kYLE47SZYf+ObCVXOruQTOu/GyJj3bpR7olX6K8kEKUogKOf6senHLv350MHgFowJf69
         d3BgDPIVXfCNDpCi8GhAprsURyGJnwc+2JhPu4jIQUwSGjGmdgksYVg3gw0/GLWGe1B2
         gqlrFjHdlV8L3nDV40mdCd7s2NZIbnFO/irMJyFI8WYn6jhnYo5nBoHJ3gGmLR7vBa2m
         8ckg==
X-Gm-Message-State: AOJu0YwO1I2Tuzgw7WeUI6//2c3z3NLQpOWfv+bMDtx16viKF3jIO3AS
	zDyktZof3Vjizf4+JN/xm8RZhXts2sEIpHuTa3S1tqo68B+bPaEc/w+TDSYGNfZKv9A=
X-Gm-Gg: Acq92OH00Y5hM4VTYfYurzhPjBTRNOZQyZ37NLfOq1r5P1K4cgKIotCcdLjlbuSd+sF
	HW8vU8hkwuOG8VdBrBQcf/qoWiv+5Jq4vkdp69mHHETLPOlF6Zti4jR5022cQDfrV6WGSXJUII4
	NkLfsVRWwFOjYlSHX+IUjctxDaZGEW+2omAEcT1y9bpiqdpxsUnJPmOBt2mCks2aUgBv08hy+wv
	ImG/7ulKr3gaW326zA+obr3bD9G/trGUg6xA8XsvR7joh7L937TNoHxL/GI37yyIkK7CE3zrfWn
	Ay3pUW4/XOHFsHXse5iemoyFU8TVT1+iyWtc7G4Ym5NBoObrOWZZ3YH3vizex9YZNjfrgdabttY
	r22YDO8MloBmTtrIKTJeerVNzawW5VfDq1L2vAthRDR4asj8FK9j2vgtWwOiceu3WLAUDXEROuV
	Rumd+8QFRTvBOfZxwuwNwwzFXJNMihWqs=
X-Received: by 2002:a05:6512:1388:b0:5a4:17a6:9780 with SMTP id 2adb3069b0e04-5aa0e61132dmr1871519e87.14.1778885164759;
        Fri, 15 May 2026 15:46:04 -0700 (PDT)
Received: from [192.168.1.14] ([38.15.57.99])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-5a9164cf003sm1570444e87.73.2026.05.15.15.45.58
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 15 May 2026 15:46:03 -0700 (PDT)
Message-ID: <df624493-c29d-4bdd-aff2-8209d2bd6a9e@linuxfoundation.org>
Date: Fri, 15 May 2026 16:45:56 -0600
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.18 000/188] 6.18.32-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 achill@achill.org, sr@sladewatkins.com,
 Shuah Khan <skhan@linuxfoundation.org>
References: <20260515154657.309489048@linuxfoundation.org>
Content-Language: en-US
From: Shuah Khan <skhan@linuxfoundation.org>
In-Reply-To: <20260515154657.309489048@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 5/15/26 09:46, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.18.32 release.
> There are 188 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 17 May 2026 15:46:37 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.18.32-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.18.y
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
