Received: from mail-io1-f51.google.com (mail-io1-f51.google.com [209.85.166.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B66BF4653F
	for <patches@lists.linux.dev>; Mon,  8 Jan 2024 20:55:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cpdCDH/W"
Received: by mail-io1-f51.google.com with SMTP id ca18e2360f4ac-7bec3b9db1bso5961239f.0
        for <patches@lists.linux.dev>; Mon, 08 Jan 2024 12:55:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google; t=1704747355; x=1705352155; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=FozcbD392EoHS/61C3J7n8Lnu2PFzEqIfm1NNRw0ONg=;
        b=cpdCDH/WDHDcqip6vtD2bCY+vVzMTVBYx++w9h5DiRIwd0D4ZVRCnUgDFG+wHEKw6E
         kpc2m+v3Z/wiXcmih6FBtU91U158C4OrQi0h7cxD15N0X6/0sK5UYp562Na2MfktoRnk
         dTDRpCkU7FblYej4Als1cpM8VXadp4eHQrn+Q=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1704747355; x=1705352155;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=FozcbD392EoHS/61C3J7n8Lnu2PFzEqIfm1NNRw0ONg=;
        b=p/iuLlbaF60ygn2QWtM+DNmn/NOKUee3gElo+WqsURjO4n7TeiYNL040iMtnzPklUi
         s3XNqG4uA+w7lbQ6mODDKEOh9TiDBQUyc4/LpvOQFkG+Avc3wXyQ5pLjBJ7OGehBF1AQ
         VNCXEtOscq0u8eBn9TvJPV1J4ICPCIB/gH//Y/9RDs6gW0l3cLQPQ0QxG4hfqOKNx+Pe
         hl85ieJH4tEIcjAjYRZc4yApVvN4PZlzEC60Ekheiu+9+kVO+y4JdFeBdQ6SH+irZPag
         fYQ9uFQMbjfmSxCPUs5NilsxFXxMKjz7+zoQrccNfBnylQCB9Cfxvhm89hWQ0rd+qSvI
         u5bw==
X-Gm-Message-State: AOJu0YwDV7jzAqq9Tjd8bsqK9v08uVyWVGX75QvGgY3urZyVsKcsNFni
	Vtdbd5bclieYinVYq7eXVXbyWPo8VvOTHA==
X-Google-Smtp-Source: AGHT+IEsCxx22dw61jddRHvI4wlX79x52MWlS2DXSCOaDvBDAcalau4rJEE4j1KfiFIF9plGs0NMew==
X-Received: by 2002:a5e:da4b:0:b0:7be:d855:4893 with SMTP id o11-20020a5eda4b000000b007bed8554893mr236092iop.2.1704747354775;
        Mon, 08 Jan 2024 12:55:54 -0800 (PST)
Received: from [192.168.1.128] ([38.175.170.29])
        by smtp.gmail.com with ESMTPSA id y11-20020a5ec80b000000b007bc102fb67asm122482iol.10.2024.01.08.12.55.53
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 08 Jan 2024 12:55:54 -0800 (PST)
Message-ID: <e51703d0-ab7d-4b67-bca1-74afc760e6bc@linuxfoundation.org>
Date: Mon, 8 Jan 2024 13:55:53 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.6 000/124] 6.6.11-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org, allen.lkml@gmail.com,
 Shuah Khan <skhan@linuxfoundation.org>
References: <20240108150602.976232871@linuxfoundation.org>
Content-Language: en-US
From: Shuah Khan <skhan@linuxfoundation.org>
In-Reply-To: <20240108150602.976232871@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 1/8/24 08:07, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.6.11 release.
> There are 124 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 10 Jan 2024 15:05:35 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.6.11-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.6.y
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

