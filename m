Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.216.52
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795070986;
	b=oQLMsC8I1AYndnaNVeKCJGhaRi4WVXla0TSbWYHUIx8eo3wY5dgdYBK+FUO9StUB61hT
	 KKMIRDFR+rKcw+oRAtFijE3UsSZbkb5KebPeTB6sngrCPvcRO7U8xOqXGH+84C0DZaqXt
	 6YX0ORevH2ei9iAE+d9KUP9lGN13OmB9JujRx7NfBAfxf8wuYn1INBZ9ibphqeloVr7DX
	 pa3yrynjcvRGAl+Vn3BdQwfoltOvY7vc6wYZtfxwFVObyG77iURoe6qK535voclcdydMK
	 RyZVEqQr/PNqOD6mLdUMAkhbsAaJGxdZxtkMsIasVR3+Q3LnHF5aaeFQcQ3FRJFWh7w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795070986;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:Message-ID:Date:
	 MIME-Version:User-Agent:Subject:To:Cc:References:Content-Language:
	 From:In-Reply-To:Content-Type:Content-Transfer-Encoding;
	bh=myuh5cci3C/VnU4rAsT0YjOgSwGITK6f3ixSFCZ5/S8=;
	b=v3vrz3G4/HhLDq6dE8OLDbyZFiYVI8qQvrJlsd+V/Dr2wDznQ49nPhdrTy/PJYBbBffZ
	 gzBaFihZ9RwkHhAsEDxnalqCqWIB2PPDXWdmOmHFPaZ+bHVbjYtrM1zk5wgFQEjgz6JG5
	 HO6vu0HYHoWUfOAfqxh+UpNkodjvNOFlz6ibR7LAWT0ey5J5aopfGCDNW3qdf7vdklyAH
	 iZY2PtYRH8ithjPFRXdmljLDeFm/NKFzrPRc7r5cJJgCVP2jU59vNLqC9Efr3sb1VPrqF
	 JZTpXmtsyyhngg9cTkQxDSKBi551vYm0S+ZGv45Dy6+z4P9KnDiKizSPNpF4ZEJk2Kw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=wuOa5UDf;
	arc=none smtp.remote-ip=209.85.216.52
Received: from mail-pj1-f52.google.com (mail-pj1-f52.google.com [209.85.216.52])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B8962606A336
	for <patches@lists.linux.dev>; Thu, 19 Nov 2026 06:49:45 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org B8962606A336
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=wuOa5UDf
Received: by mail-pj1-f52.google.com with SMTP id 98e67ed59e1d1-3b08a162d4bso1100515a91.3
        for <patches@lists.linux.dev>; Wed, 18 Nov 2026 22:49:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795070985; x=1795675785; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=myuh5cci3C/VnU4rAsT0YjOgSwGITK6f3ixSFCZ5/S8=;
        b=wuOa5UDf93Pu0ljxq/CutSO+0yDzBJa/mqQy+RckR/+IAloB9/DhOZsaPC8Vdw2/8e
         iJ/beRJ82FPdgxMeGqkOZyGnyni6M7WnmphraNwCUA3ltG2CC/alyK3L1QYvYYIsfCFT
         1JLmG9UJLgRw+FbXmEFcYHK+QbPMJ6gRaqxr8nmT1wOlWf687ADo2n9KrQwa1dP8hFoI
         YJaUrTj2YL6buauE9pbZlzlCsEoGHOUYeccDInIKX6BYEN35E9z9Rh01+f5viPJIZSXF
         0MNrSciWCIhfHvg0XAslkCcRo9DnHGDp+g/vj6vDfAwcvBtEETGobihbMRo+ScR7e3ph
         PDJA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795070985; x=1795675785;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=myuh5cci3C/VnU4rAsT0YjOgSwGITK6f3ixSFCZ5/S8=;
        b=uylDaQjwwB/tSE09n4bQPQs0VEZ1pAvrhBt8tJ1PzvNZ9IPWl2jGnWZMHUszirxBTj
         LzS9+NE/h3BFJdbAwYeFa5/GUgNc8jLOmUBpN/FkL5MszUbsO9M5Cs0AdwOv0B5t7QjT
         k9JWQxq+jOmBE1WJZr89hd+7dfJGZMiAtfKiv45QLnjgcCttbTouC5QFGCppyinQ0BZC
         9kTZE3ye/Pcv0avw0scIi5QgM6qlK/5D/lLrJFcFoSkFUgUz7+DiSN1oKId911tHdzWa
         YuVhi0yATQW3VgCKAN7Zmx+a4tHgW1aTqL32kwYKmG/vYxlBKbbMIjmEwDWyr48OuChx
         v8vg==
X-Gm-Message-State: APuU4Z+w+XNGsPyDCqfBLq3y4hH3OeZTjP+hvv3HSWjG4TbF5uPuuBrf
	NfKLOXwg02Ci0DUwjvUJPb3/axgG/E/7hRWtmfBDjKnpcRQOog8FOZ4I
X-Gm-Gg: AZFdTZf8y9lZBHwzhd19BHi2LBFfOjAJyMJX7YkcAHS5XLLRmF9q6L07zyMLCWgtH4c
	Ljbefy4shwJ7xTWGDx4nO1DhYSrLw8fle3AEBAQK8o8y9cpCVuxHythLptC2x5Ppui7O9qCv+ng
	4r+2GwLCvaS45ZzvvAvpQD8JljVCdC5ntnCW58Y+uHT6EWQrN9qwUSyKhUrHKqHoH/pDwR8qaZ1
	bxRfh7foPpvUvtK6QDrVXydUAJcRd9gnkan/a4CuBJeO82vejZPTKBdQinb+T0QM2wrzMVQQRFB
	iuuCV+zRaxYOrrE82lqKef9hPludfS7jWag5UvijRLRL8CPb5ixbU7Z/cDwOWPSKpwwo1NdCxQx
	EXF+Sca9mvd2/PXUPlQTYcjq0OxwyuAUIDh+m+2/ctgdBsrXuCV87O+Ycl9bU9R1gJUIk83NkDx
	GxJe31sS75WTah9K4RHBcBKLqnS3SFn9Ql4YkOkAdVSIIoOZhA3iZNkL3DDumljcUA/0ZFvbMSk
	stgBNFA5Q+h1O4Dhrh+3GHMtyRe9mdhVAMrFzKNZPlDAsidpum4m42mS5MdqlPy31urqlAR3w2P
	/8iOOLtKSyr+4J07bzxlOFa+UYS+zNI=
X-Received: by 2002:a17:90b:4fc6:b0:3ac:b867:81df with SMTP id 98e67ed59e1d1-3b3d07a38f8mr5227675a91.39.1795070985048;
        Wed, 18 Nov 2026 22:49:45 -0800 (PST)
Received: from [10.222.0.188] ([59.20.222.201])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3b40543eda7sm1159723a91.0.2026.11.18.22.49.40
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 18 Nov 2026 22:49:44 -0800 (PST)
Message-ID: <088f8590-0ee5-41e8-9a2c-48566d6ced82@gmail.com>
Date: Thu, 19 Nov 2026 15:49:39 +0900
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.18 0000/2151] 6.18.65-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 achill@achill.org, sr@sladewatkins.com
References: <20261118150121.603863898@linuxfoundation.org>
Content-Language: en-US
From: Joungmin Lee <leejm516@gmail.com>
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 11/18/26 11:28 PM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.18.65 release.
> There are 2151 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 20 Nov 2026 14:55:45 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.18.65-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.18.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h
> 

Hi, Greg:


6.18.65-rc1 successfully built and booted in my system but a dmesg
regression was found that was not observed in 6.18.64-rc1.

[    0.000000] Linux version 6.18.65-rc1-900-myllvm+
(user1@gentoo-zenbook) (clang version 23.1.6, LLD 23.1.6) #1 SMP
PREEMPT_DYNAMIC Thu Nov 19 15:35:28 KST 2026
[    3.060808] genirq: Setting trigger mode 3 for irq 87 failed
(amd_gpio_irq_set_type+0x0/0x180)

Distribution: Gentoo Linux
Architecture: x86_64 (ASUS Zenbook UM3504DA)
CPU: AMD Ryzen 7 7735U
iGPU: AMD Radeon 680M

Tested-by: Joungmin Lee <leejm516@gmail.com>

Best,
Joungmin
