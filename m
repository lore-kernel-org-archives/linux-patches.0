Received: from mail-io1-f45.google.com (mail-io1-f45.google.com [209.85.166.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C9F851AB510
	for <patches@lists.linux.dev>; Tue, 10 Sep 2024 21:26:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726003588; cv=none; b=DWdISkC0J1Y7vv6+T7+EgBYwtyj97RI3uKoW8jcoQbKnX3kI91U9368Dsrr5/2pOn+lL9OKSZBd5ry7uYnmfbIjUEcEUattP6lxQgNoBhKISTTbZjWAmozN8e51d4hRGUcjCIvv0LqjJaWM5Q6jtGSCCgKEwW3YQijrGdIcCfMI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726003588; c=relaxed/simple;
	bh=+l5e/LnCdd8IAh9budhJNcJYEEVRB02TloD3Js8eMos=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=HFVxAK3m1eyRKHo+Z7Bvf4VO3nic59ZIx+Z21rM8htxDnk4l6GJPREAoFl9lFjUtw7YTROuuAmh5lXCmBYIIea2Vu7mcContjLu3fINFKWEfDhVWIyLkKiyeOPMIfTES4uyW/vSEUkdSf2lH5TXTQS31eWsnGJSZGjsBeARsMzY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=aJ4hhzLl; arc=none smtp.client-ip=209.85.166.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="aJ4hhzLl"
Received: by mail-io1-f45.google.com with SMTP id ca18e2360f4ac-82aef2c1e5fso175329939f.1
        for <patches@lists.linux.dev>; Tue, 10 Sep 2024 14:26:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google; t=1726003585; x=1726608385; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=IrdxYdiIzLneY1PQkxD+9Iq8WHqwfU8Dic2mnpV1UZs=;
        b=aJ4hhzLlGP0wGL22SbIXZKWzvvErIaZWg37d6QT66M586FS4xcxhJXIICfARJCxpOU
         LpPeM44bctyk/70de2HKRLZ3cXacmjh3pdmyFIiPdSUC24dCY2hz9fcCG6yx4n1jFO1W
         p5AF0iH504GqsHafrBwrRWZvGz//c8m/doYgk=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1726003585; x=1726608385;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=IrdxYdiIzLneY1PQkxD+9Iq8WHqwfU8Dic2mnpV1UZs=;
        b=XcVQA18dpXiR0wANYUFmLoCfHsgqjQHG/aZHfp/f0wvu7zYvaJ7W4pmzHqymfi9TmO
         F/kToGJwuCL3g3sqom3ayKNOsv3RPlPbeNDSLX7mzdcuzpcPYBQtcypzio48iTzIjG6f
         TBiIB0khN65WNzBga1k9liImwTN6WkeJTxzzdhYiXmY8t6zyI6ZwA2PSD0LUQwfTvEjk
         AXgQNPvpHezLbbPFQ4VmHSHySZqEZtQrdTrAQ94wd2OQW0EHSS8X5N7/2AXi49cb8Tj6
         EKq4wwb0GjyXuyHJ685L4n1fPmdl58dn350i2sFhNPxKjDHviUwkhYr8YKvXjq6L/O6o
         LrhA==
X-Gm-Message-State: AOJu0YxttwYmA9aluPJ9J6OxWNSOVHPYv0tQip1vM5rB+5JHfP3CLlCa
	GLRNty9OkIiL3V8MY80fpLeWHoPPZQCaqKSPUjujeTqxQUQIrxFwrLqlHLNOxTs=
X-Google-Smtp-Source: AGHT+IFGQhVronEsKZ13uyaupXrkLsl0LHSmfNr4fnx1sTDUtu261DIXqt77yBBw8Aew2oRg2s871g==
X-Received: by 2002:a05:6602:13d2:b0:803:cc64:e0bf with SMTP id ca18e2360f4ac-82a96172f24mr2867103439f.2.1726003584725;
        Tue, 10 Sep 2024 14:26:24 -0700 (PDT)
Received: from [192.168.1.128] ([38.175.170.29])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-4d09462f370sm1824691173.119.2024.09.10.14.26.23
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 10 Sep 2024 14:26:24 -0700 (PDT)
Message-ID: <39d69408-b8aa-4829-b85d-ecae4fa8f97e@linuxfoundation.org>
Date: Tue, 10 Sep 2024 15:26:23 -0600
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 5.10 000/186] 5.10.226-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org, allen.lkml@gmail.com, broonie@kernel.org,
 Shuah Khan <skhan@linuxfoundation.org>
References: <20240910092554.645718780@linuxfoundation.org>
Content-Language: en-US
From: Shuah Khan <skhan@linuxfoundation.org>
In-Reply-To: <20240910092554.645718780@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 9/10/24 03:31, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.226 release.
> There are 186 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 12 Sep 2024 09:25:22 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.226-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.10.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h
> 

> 
> Guillaume Stols <gstols@baylibre.com>
>      iio: adc: ad7606: remove frstdata check for serial mode
> 


Kernel: arch/x86/boot/bzImage is ready  (#210)
ERROR: modpost: module ad7606_par uses symbol ad7606_reset from namespace IIO_AD7606, but does not import it.
make[1]: *** [scripts/Makefile.modpost:123: modules-only.symvers] Error 1
make[1]: *** Deleting file 'modules-only.symvers'
make: *** [Makefile:1759: modules] Error 2

Same problem. I am building with this commit now and I will
update you what happens.

thanks,
-- Shuah
