Received: from mail-pj1-f47.google.com (mail-pj1-f47.google.com [209.85.216.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 050C215ECD7
	for <patches@lists.linux.dev>; Sat, 18 Oct 2025 03:31:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760758267; cv=none; b=SrFRm5nTIBwY3N4MMqlHToUvl1nSm0lThw1bS0IRNWaH6sAzPG8bB48brr/tQ3RzO65UpzpM4whkuAQ3YqR7v9DxD0ILiKoVy4FHD28TVcVNCrXgot3HqlZVJHftutWHufi4foiH1btYcUm/4jSwdJrZYOvTn2lv//e9Su8pbXU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760758267; c=relaxed/simple;
	bh=+10+GeTAtzffLGH8zcKVrCr0sCkofSw5csfm87HIomc=;
	h=Message-ID:Date:MIME-Version:From:Subject:To:Cc:References:
	 In-Reply-To:Content-Type; b=giDnj90A0XHF97rj4Q2g0x9q9zhJJuQfV5RrmQBeRqxMKIIg3u7/xA+bj5B47p+Am7sjxaFefyKwEY6FZaW0xKJGba8YfyA7vB+XkCtyBqLV9EcDP3i+fMyo+qhtrpHIxl3/+sAjiIGscfJ3251ksRyUzK4eSD8N2v/xs7xy1Rg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=WDf6cHTi; arc=none smtp.client-ip=209.85.216.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="WDf6cHTi"
Received: by mail-pj1-f47.google.com with SMTP id 98e67ed59e1d1-33bc2178d6aso1545654a91.0
        for <patches@lists.linux.dev>; Fri, 17 Oct 2025 20:31:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1760758264; x=1761363064; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :cc:to:subject:from:user-agent:mime-version:date:message-id:from:to
         :cc:subject:date:message-id:reply-to;
        bh=v6vOeL0Ti9p0IbinEayIS2aVQiUiE4kHXsDaP64c+YY=;
        b=WDf6cHTiySnlURqSWje9saCWnb3sLBGEELwxITr03SBrMz+I40Q2ItK4vPUVYnNQf+
         CpWHzcSyFKe9PLbA2KHw7+zJSGQk4n1DdYUBnf1SMV+q06kiy4y1AvRWdUwqguHhJrAu
         7ItYm98/ZF+jv46ikIAb4wPhL+Lyxk8CHj/fIMHM/CNS6dIbu1f8S298QojSZujmB7eD
         31GzXiWBbxsd7o6sYDFy75jXSTkygDkby/VNdM8BcRBJPI/y+kA8dY9mheep6KOJE1f7
         8B77xLvLx9eRsgyDv2XYcZq5KuDdKi542Q4Lxo0CHK3CX3UODdJ6I2n3EHI2FvD0hLYl
         yorw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760758264; x=1761363064;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :cc:to:subject:from:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=v6vOeL0Ti9p0IbinEayIS2aVQiUiE4kHXsDaP64c+YY=;
        b=sMAOJSZJ5iXp0Iv/PyUz76CRa2yt+43OpOc7PTjcg7VugsC8QSGnDav0hiNxTsQyKW
         zLnmfG9PokvApgYZLEEth3SmpVfdbSLW3tpMK1VVnSFkmdp8cvHgliA1Wh0PK2Pbv2Mg
         Mlh0DvN/rHqS0Qv57lIUyka1p2wlNjIe8GopnETwjvBE3AuzSiukN9TD2kXeIcwsEczE
         6e02xjbZaTjuzpfMSZbpAWSUrMjK4Vp/mFi2vFiyP+2lJ5mdhaVmTJsHohrXKsw+5s5R
         7h36FpcUU7wBJ1COxLJsJdIXNVaDgCo2nCaQRL4lWUm8G5l+qlf1IrjYntIjVESFJtwT
         aF7g==
X-Gm-Message-State: AOJu0YyXeUwuqw/eDe3PTbSQ7CLLbvK4R4sKh9e2ot2ItJ77BUkHN4XB
	VO1Ecyg3IYZARNiiIky9H9VrAN/J5xBsnp6UUghkxN/Wgo59EicP87uy
X-Gm-Gg: ASbGncvVTwQr32Ln84+G41l0/OdRJotZtJEXzV7OD200wzUq8JNqURXTkj8coit7ar4
	uL8Ltfjp9ZaUxiRpO3CQCxxi6+7BIM3DVg/8pQw0g/D18VH5t6/we2kCAIsSE2c9J0nBbsTBgLN
	6PA2Mlimjqgq8uLmmpY8oVF6VMaLbc472CKWTeT51CZC+qYU1H1VZCSD/cRQwDLxz6jWNDigfsB
	U9dPi6a+5mbu/8+ua+iveGwnwUEjr3yQyFoAOHddKYigH1bBU/UePczq8Qv4P5ZT65YkwbHVgMy
	7KVxPq7a4FAIgNrbYagZWuf7dCfhdA0Zthfnqveh6X5/w5bqIcZYaHzzArNFI/PgiWRwdJOoQr4
	wxCWQfMPB1K6atb0yZdpyvWMjLpcw7WpHzM0NRRjWq4lPrJGtZl26cTjOYgRNEh6IkZRBabAy6J
	wO2cVFx3eVfdjbZVGr6NZymINvpWCjGjKFHBmkgYENDS6RisPwEKcp
X-Google-Smtp-Source: AGHT+IF2jhP8EBwcp7ssUhyFGBfyHgpvEdDxNhJAUMzEUUmdrL/VUU+PTz7bDljFsV81pHEH+14dIA==
X-Received: by 2002:a17:90b:498f:b0:33b:cfac:21d1 with SMTP id 98e67ed59e1d1-33bcfac21e6mr6838380a91.32.1760758264085;
        Fri, 17 Oct 2025 20:31:04 -0700 (PDT)
Received: from [192.168.1.3] (ip68-4-215-93.oc.oc.cox.net. [68.4.215.93])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-33bae113eb3sm3899336a91.2.2025.10.17.20.31.02
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 17 Oct 2025 20:31:03 -0700 (PDT)
Message-ID: <201bd632-344c-4a89-8870-6cfd2f3bac13@gmail.com>
Date: Fri, 17 Oct 2025 20:31:03 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
From: Florian Fainelli <f.fainelli@gmail.com>
Subject: Re: [PATCH 6.12 000/277] 6.12.54-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, rwarsow@gmx.de, conor@kernel.org,
 hargar@microsoft.com, broonie@kernel.org, achill@achill.org
References: <20251017145147.138822285@linuxfoundation.org>
Content-Language: en-US
In-Reply-To: <20251017145147.138822285@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 10/17/25 07:50, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.12.54 release.
> There are 277 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 19 Oct 2025 14:50:59 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.12.54-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.12.y
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
