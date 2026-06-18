Received: from mail-wr1-f47.google.com (mail-wr1-f47.google.com [209.85.221.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A85F43B7B66
	for <patches@lists.linux.dev>; Thu, 18 Jun 2026 11:46:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781783213; cv=none; b=UBsPuO01HFMUIXci3Lf/MnBtl86VYgRHffkQkr3RZ3lg1UDx2iLy6tnQ7K+agG0xl8yTn3LwJEV4WGS3uJFA/JSCRXhXUBaQ1/YErsbdu7uhSeXytPqeMjFa88IcntQA0+jTH4FzKCbdWtIZHDfxj0SuvPswQ+6GOj1deYcwH5o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781783213; c=relaxed/simple;
	bh=vQ+HAki6E8x9KEeaRuveOCb6/8L9j/jcZH16cNZ9uss=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=QFHAE4rmKGJCt6VTxt2Z0LVRf3l/fIfrnbv8D/LHNeiJbITj7jA6M2KmZTx3tDIGG41XNKUwAX5kopVfFwVt97VDE+bIQPDxzj3sV40r9BLQMXIuirmOrswc+H2Hq9Dh4WnfNmioBKkVwgfqebOEmt2iFdEN/3cjPTUZN9zitAM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ezcncj1y; arc=none smtp.client-ip=209.85.221.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ezcncj1y"
Received: by mail-wr1-f47.google.com with SMTP id ffacd0b85a97d-4633193af19so652497f8f.2
        for <patches@lists.linux.dev>; Thu, 18 Jun 2026 04:46:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1781783211; x=1782388011; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=2RcPJ5vmiw5p2JNiLjYZxK1/VIU//IbyCjbXLw/2zm0=;
        b=ezcncj1yv8HvI65WP5NjUF9ztTNfuWMWLGWtVds2tN//9gQvSzKxClBON6rWNgMbGd
         Y54g/cq3K1+emWGJT9e3aEAnRJuFz183csV+bh3mYafds+A0Rw30Ja8SwLfU4LNSO1oh
         voWE/gc+nKiYrWqihg7xvTELJkIOfauMQaaRdPMViP6KHwn/pdvGtkWMaJdGKbWn1XZF
         E9CvgTkRc78JY1TCKf/yJJwozL8zVIaenGGJK7T7gxAoq3UMzBhilHVKHBeKiJl4X38W
         bTiEH+w0LbkczZMFh+Z2/aa+O1ru3txR7ejoGGcUmzCeu3S9zG40v5VjERCMbx1mcefK
         wiKw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781783211; x=1782388011;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=2RcPJ5vmiw5p2JNiLjYZxK1/VIU//IbyCjbXLw/2zm0=;
        b=oGoy+vQbLAUkhsx8Mi2FsvI0ZmvsAfMC0IouCjXjAn1m3W5c1JaAioy0eHzUUE7DgL
         Fn1zFmliwTg+VveymHkESZZEDwfREXTk9fs6CRLmlhf1kSGN/IS/xDxiov8N3EDmhltz
         l99Z8SgAm7yX6Tw69MaZg4wkxDRtSjdgtjyn5wZNJL2XK9sPgAqtJ1BRycVU97R+Rm/b
         cS+GIUzJUgMzllX63IzA7x0tG4H+I0hyE+AF7W/aDqDd6L4vOAdNByLWBRfMjoJpTn0W
         5ZBLai6s62QhapgDLotbDPmyy7utip3C4kPaa100lXBpHQJ4E2YZWP+E6xQcwoJHxBlm
         QGBQ==
X-Gm-Message-State: AOJu0YwDNlVxkzfJ6UrcXMZRHJBX3zwvVOTP1Rh1txr6g1vIdsr2Frgt
	zDgOPyzGqllFLacT66tz0GAv82EVBhXYGHaZAWN0r5vMNUAeRsI6VCPj
X-Gm-Gg: AfdE7cngmOHdwbyX5Hza4J5O0jZgoiJDGhRd/tFLKHTXQ3SWH3ncPWxMoHI/bGRkIMw
	zgJXCCa1CFFnc/X10vtaiBJebQaKiewL8IgxQpgBsCF9c9mQWgwoupz61TpPHG3FR76yDslJJnr
	qygpdTNIq9mSZVc8EdKMTaBxuy5Uja38+teugtae0LDtl6XH0/YFKK7Lid/+p6wEAxMV4Wqa/I2
	K4eK9MFwPllLrnjyap6Jh2nas2Khx68HDQwX58iRZWqBk5cXKfuqIx6ih5J+kDpRo8qahhJSStz
	I+8mYN+Qc/lCOI4pb2BSSdfzeyeFv6+OJRLdVBAl/zZRbFU+uW1OCcpdQcmolD2dKlW8yyduqj+
	6xJkIrsyOfjDZaxQfYT4xDtOXX7lt16OaAjiybuaOATDENxBw0Nwg5QjCfSSonHV7jtVdQcpZcR
	noJE4GxrD31ccuGlPOY3zhBvm7Ps3HKA==
X-Received: by 2002:a05:600c:4715:b0:490:b446:fb8 with SMTP id 5b1f17b1804b1-4923a97f870mr23146315e9.11.1781783210900;
        Thu, 18 Jun 2026 04:46:50 -0700 (PDT)
Received: from [192.168.1.21] ([41.140.50.249])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4606f26392esm62440164f8f.3.2026.06.18.04.46.46
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 18 Jun 2026 04:46:49 -0700 (PDT)
Message-ID: <f9445527-daf3-42b3-81a1-8e0b01e275bf@gmail.com>
Date: Thu, 18 Jun 2026 12:46:45 +0100
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.12 000/261] 6.12.94-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, rwarsow@gmx.de, conor@kernel.org,
 hargar@microsoft.com, broonie@kernel.org, achill@achill.org,
 sr@sladewatkins.com
References: <20260616145044.869532709@linuxfoundation.org>
Content-Language: en-US
From: Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20260616145044.869532709@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 6/16/2026 7:57 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.12.94 release.
> There are 261 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 18 Jun 2026 14:49:57 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.12.94-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.12.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

On ARCH_BRCMSTB using 32-bit and 64-bit ARM kernels, build tested on 
BMIPS_GENEIRC:

Tested-by: Florian Fainelli <florian.fainelli@broadcom.com>
--
Florian

