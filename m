Received: from mail-qt1-f170.google.com (mail-qt1-f170.google.com [209.85.160.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E34CA33B6C0
	for <patches@lists.linux.dev>; Tue, 16 Dec 2025 21:38:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765921121; cv=none; b=qedf72vIJw1apHKtq9hfRP5FtVaXpQSUGaVzAlxTtqtS5c6WrQM56GuwM7vwbjKGCr/NWNNn8W5we02M7q50n6ITLpCtQrmqTecBWgcJaqzyYAbWNo58XrM33f5ZTEWv8tKjulnodO2CYiMZcloYUolYyATNDJRImIdLnRK4keA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765921121; c=relaxed/simple;
	bh=IrzwS6C5aI7fipV7HbMn9GfkbRo3LcMiD0elXuzsMdw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=kuG7CrIQeO5VsG5gXYNxVIqSEcBb970UCjel9znnldir9u7bOx71g+USd8GZxm0mhhUfIuypwXuoRLpVB1zJLsmu4ZwQSk+RsfwllE2/CaQTw9QlifYsIqUaE6lre5AyZNcFLp+4xHIflbmg1qpfKY5IOjiy3xQRfD6xK0kYWTA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=OGGfKFpI; arc=none smtp.client-ip=209.85.160.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="OGGfKFpI"
Received: by mail-qt1-f170.google.com with SMTP id d75a77b69052e-4f1b4bb40aaso30557351cf.3
        for <patches@lists.linux.dev>; Tue, 16 Dec 2025 13:38:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1765921103; x=1766525903; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=9FDuJHVI3P4lF6qM6POX+953ahYksqf7lfbvS1w+/rg=;
        b=OGGfKFpIt7eUXmwzynUrWF58LykQ1JefZ8VsGykZSQjEy0Uj+nQgDlaQ+erosSyZqU
         0XzcfWoPODvdrNcSm+z3MW8RbLqKQrXu65C+Wv19JtjfKfBOTALSz6u+9a0PeL3B7wSA
         uwHU5AwkNsW4qcoNIv2VMt9Eg9KilN3tqTOe8cOoZgWNArobuGAQgyHAcQMayPV2SBgW
         xrKA3isDq0F9czLXrZAoKS2KQ0vTW4QqQfvPbJodGFUE2mk7MqKD+g1Cgd/Z1OFqUIId
         govPXbdE2CqBFlJpUMzMM1a+PRpJyRE5deFS4WpHloGmTP3vcfpYfwCNn8wPwrFNw/wz
         fOYA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765921103; x=1766525903;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=9FDuJHVI3P4lF6qM6POX+953ahYksqf7lfbvS1w+/rg=;
        b=oAN72qN3xVGRrgk1ZYU0AXw6j+YDPhfNOFSycR8yvHwkEaFt39RZnFWul0Be09VkJQ
         FUKwR13K1TEptP+DySOCPaMphKZNagk47spd4cQ5MgvYRcoRMxeM/fnGdizNK+s6mCuK
         RA+ZUlxMeRMy0jaEwvRlLJDb88r8lu0w2Y7snUUsp2ewzyRr+vndVAnEifkfu+PgW1to
         yfNVSyX+SVGLW6Nise1h6fSBqgqp72jU71hfJs0x2mXIhc4MfwKkU+7whpGFaeBfleV7
         2kTYp5Lf9jG1+oX6W8ivk5UiZAqa0sHLPu3J1Rpn5l1OH/2ultBSPi1+QEMsf8nyTlFY
         Zmew==
X-Gm-Message-State: AOJu0YyqmKTGLcwTzSeosATgsawFkGKPhPUcX+em5BQnWH45tnYFMiVt
	otcfMYXMS085PSxusbUGwfgbBFz+rfOh8OcKwQuCbVGqyadsGRqyL2NS
X-Gm-Gg: AY/fxX4E5FXVrsrszyI1MnNEyrkIbEIp3IZXFV2qxeA6cKqrFAnnavbc9A2XIQQqz9b
	XI1FJQd8WkWK1ytsLX+0RDfm/YQtoqNmOAKZEO+FlUdRhWkFCvybiVrqzRyc5DelTXDUTLXdiBz
	Sml5ouOWbzU9X+tyAu5ahefYHqnk9CpBHDLgphb1G8CmC1KojCWkJNP2EKIKeplkJS3aJd3kab7
	JNaNakD66NeUQlie/1wSYH7QX6vmFyTHqrVKFy8BRHs9m5qq1iu7ZBfSKQWqYN3nO1diIf/56lo
	44XAFgzVdG3U/vWFBtDxBd85GrtOY6/9qelb5LcVIl0bMubbTQ5mrm62DT5pEWa+kAPZWyVCBY/
	DvEN8S9pZQFS2lnw8oSn6qfh10v7/CiWDrZnbob7ug4zEHSj579NFH1fKp7jX2/9JEKxdrTpSTb
	N6cciAS9bxP4lGS8QnJCmsWEa+yj3PgRpn2EGv6g==
X-Google-Smtp-Source: AGHT+IEnyi5xvLj4o52rVDCfep2kB9HscHAQcdZPennsWNgyCwdgrfXSc1zozSGCq0Do8l5Ss1AufA==
X-Received: by 2002:ac8:7f03:0:b0:4ed:e337:2e68 with SMTP id d75a77b69052e-4f1d066fd5bmr202028001cf.81.1765921102543;
        Tue, 16 Dec 2025 13:38:22 -0800 (PST)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-88993b6a80fsm81763976d6.18.2025.12.16.13.38.20
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 16 Dec 2025 13:38:21 -0800 (PST)
Message-ID: <b60ffaaf-fe92-41d3-a394-e82f2d27a402@gmail.com>
Date: Tue, 16 Dec 2025 13:38:19 -0800
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.17 000/506] 6.17.13-rc2 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, rwarsow@gmx.de, conor@kernel.org,
 hargar@microsoft.com, broonie@kernel.org, achill@achill.org,
 sr@sladewatkins.com
References: <20251216111947.723989795@linuxfoundation.org>
Content-Language: en-US, fr-FR
From: Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20251216111947.723989795@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 12/16/25 03:20, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.17.13 release.
> There are 506 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 18 Dec 2025 11:18:24 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.17.13-rc2.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.17.y
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
