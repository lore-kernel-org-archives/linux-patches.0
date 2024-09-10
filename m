Received: from mail-io1-f47.google.com (mail-io1-f47.google.com [209.85.166.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3286419412D
	for <patches@lists.linux.dev>; Tue, 10 Sep 2024 21:12:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726002742; cv=none; b=X/eytgeHn3k8qNUdKTrGFc80T/kmESyvQtaSjtofd6I2+uNFL55XFToS8f8cH6yZL+Y46yDJD9fM0fcX0xAjPk++ph+TFmRDrFS6DfhR5rRczj3KsCDm6xNut5uh/2WM/Sy6SfEDs5vgGt+NlFwc5ziudGnJTbZlr21fdAL0oek=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726002742; c=relaxed/simple;
	bh=ik3UKsltknlff9FD/NaLT46PtwDaXCHPQhKMj6WoIpU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=QiPOb7eEawlEJWanQ8h+5X7jIgii6q8JOuPRJeDraeHC9is2vDVLrWGgl0hPAgGPMTkGq4mxpe0U26WhOATLErmj2kGo0i/oxkWPrWI1WUwr0i0ajQ/NhTfWTEJafG2m0QbOSFUpowU/eccGud8pyJvTtG8W491jeoeIHuAOxqs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JN08Xn/p; arc=none smtp.client-ip=209.85.166.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JN08Xn/p"
Received: by mail-io1-f47.google.com with SMTP id ca18e2360f4ac-82aa7c3b3dbso206358539f.2
        for <patches@lists.linux.dev>; Tue, 10 Sep 2024 14:12:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google; t=1726002739; x=1726607539; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=7rPGjGCzv+oasSI6pVCkPDSWf7w4QJh8MFoceYLzhS4=;
        b=JN08Xn/pY8lXZmujnjxo2hgFIxkC1Gl+/vgmWFBtGSWt1yji9ih2vUwSun1J3sDJ/B
         hlKZ0/edBu/boL8nhXZ8Hvv3GjD/Xgot5/Ynnd+rZ5lJQdgegwsW9+Rd3XM+sBeogGdD
         1LQ6kdygq7Df9r+u6iDIwrdltNqM/wTVeJens=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1726002739; x=1726607539;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=7rPGjGCzv+oasSI6pVCkPDSWf7w4QJh8MFoceYLzhS4=;
        b=Jj5MCsuo1lCEdOayTrX2lofUbBSgyzVIGe4i/THO/Mr1ulU0Pbb6CJsmqwQ1vf2sOG
         P0Y6V+kUvkMMfSBOgnkPPVDaMmrG4ACtbHaiIR1jJWPBdkywj1E5zCMo4tKD9T4jTqec
         GVO9UAngwxc10vvIpw4Gp5roUANfQry9ZCRv93GoNvUhvbIUV5MnNJpC9BkhwLNb1s9B
         I0JXgVUoWpgpchkrwtglLR5eVJdXDuyACubsLBCBleXh63aMIbExpJM2D/CHtxrZsa7a
         Tu7ZHvJ1HKp98tL7ZgRl7h+25BfdYO36XliHH0j/aduARlc2BiCm+yW8He+dbmOhyC8v
         lHBA==
X-Gm-Message-State: AOJu0Ywr9Kz+XJby3jzo99JdAl/y+oZofUuTjPU7xm6ocXG4rV5l2S4v
	FIQ4vgSSOCSTpyabh+nx2H/VyTDRK2PXwyBv2IAcp3RAoUxWfDiW/bhzwSj+8Co=
X-Google-Smtp-Source: AGHT+IEBXCGJfpx6uQrNCJWbyWaXdkVnusVExeZjTk7LweFyaAVp0ZTqw7/koXWoG3nviMKixvHXGQ==
X-Received: by 2002:a05:6602:1583:b0:82a:ab20:f4bf with SMTP id ca18e2360f4ac-82aab20f590mr1225176939f.1.1726002739074;
        Tue, 10 Sep 2024 14:12:19 -0700 (PDT)
Received: from [192.168.1.128] ([38.175.170.29])
        by smtp.gmail.com with ESMTPSA id ca18e2360f4ac-82aa77b5ed4sm220908339f.53.2024.09.10.14.12.17
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 10 Sep 2024 14:12:18 -0700 (PDT)
Message-ID: <cb8e0e51-a934-4aaa-91dc-c4530ece99c7@linuxfoundation.org>
Date: Tue, 10 Sep 2024 15:12:17 -0600
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 5.15 000/214] 5.15.167-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org, allen.lkml@gmail.com, broonie@kernel.org,
 Shuah Khan <skhan@linuxfoundation.org>
References: <20240910092558.714365667@linuxfoundation.org>
Content-Language: en-US
From: Shuah Khan <skhan@linuxfoundation.org>
In-Reply-To: <20240910092558.714365667@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 9/10/24 03:30, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.167 release.
> There are 214 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 12 Sep 2024 09:25:22 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.167-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.15.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h
> 

I am seeing a modpost error when I install the kernel. Looks
ERROR: modpost: module ad7606_par uses symbol ad7606_reset from namespace IIO_AD7606, but does not import it.
make[1]: *** [scripts/Makefile.modpost:133: modules-only.symvers] Error 1
make[1]: *** Deleting file 'modules-only.symvers'
make: *** [Makefile:1825: modules] Error 2

I am seeing a modpost error when I install the kernel. Looks
like thge following commit is the problem.

> 
> Guillaume Stols <gstols@baylibre.com>
>      iio: adc: ad7606: remove frstdata check for serial mode
> 

thanks,
-- Shuah


