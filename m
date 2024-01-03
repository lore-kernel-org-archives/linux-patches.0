Received: from mail-pg1-f178.google.com (mail-pg1-f178.google.com [209.85.215.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5BEDC1CF90
	for <patches@lists.linux.dev>; Wed,  3 Jan 2024 19:15:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Rm0azOVT"
Received: by mail-pg1-f178.google.com with SMTP id 41be03b00d2f7-5ca1b4809b5so3246981a12.3
        for <patches@lists.linux.dev>; Wed, 03 Jan 2024 11:15:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1704309338; x=1704914138; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=QUKrvnDKVUQB/NUh9WHSZ3lM3rwikTTA7m5z5TfQ1LE=;
        b=Rm0azOVTneKYV894VllleKz+4VCdidAT18oVI0O4taJGLJpvdxGP58o+yRsKOl1pcQ
         YhYrdL6BNbcnXxt/fD3CXreu90hUWyrhxJap04VUEHQ9Vs+nWEspB2XMh7RmtRoj6zej
         N2L2+bmDCSnPMZMzRl4QY8K5F7Yq8TfgzgCtGu3qNUowDnwFcXq05ivNsN3RM2xBcGHK
         Si2jhPAlvaKmnzJuihE0YIFKcNnSHdi7FxBmy+mRF1LBfwRs9nfHttMBq3EfnUtXDlnW
         vMzsQdMad8lHaziNQx4DxPpq6PJum+KaxVdZbmkZ+j6ktP+yoDiEmvOOGA5cDPXggOtC
         y6PQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1704309338; x=1704914138;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=QUKrvnDKVUQB/NUh9WHSZ3lM3rwikTTA7m5z5TfQ1LE=;
        b=BN2xmAXBiZQOnudMIw4sZSbLovrlG0zzeloJXaGEB4j9g1MauonD6PqkabG21r8BSt
         c4FOn3Q8HvES/IQyGjSOGYk740CtNHNJCYgl95K5peMXrS8lUmC5ZdylmehnxdKiibA2
         /d1P/x1DCh0hFxL1kyd7XTPK3rDhHHD3IbuQsUegYJ2aiBlgCgF4mxSieJ/90MrNueOL
         wpi83zoN7JeuzaPGc2z+dqOtaVDFVBc6p+v3/sERKdSBFZTodTVp1Bw4uBl5X0JWg+kz
         fDbcFdq8Aok0sIGioE8ZT7Gt494fuyqKy0aaT/22g1fVYEuuy3eEXGqBNGp8S5YShCGJ
         L7Qg==
X-Gm-Message-State: AOJu0Ywp/Tbgv4rXvlsY9eGEfIknsU65Xr6FDk8hgSMFRu0N1u+CptRT
	2AQCKVdxqJFwLuKqS1rsWZA=
X-Google-Smtp-Source: AGHT+IHfnT/bgD24BwhFVCndtsgTgB5xyFndtPtFp1nVWMlDecJNekMCkFq98cxglhWyQrPm6JMZIQ==
X-Received: by 2002:a05:6a20:9717:b0:196:e00:29f8 with SMTP id hr23-20020a056a20971700b001960e0029f8mr5935741pzc.32.1704309338505;
        Wed, 03 Jan 2024 11:15:38 -0800 (PST)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id du8-20020a056a002b4800b006daa809584csm3473076pfb.182.2024.01.03.11.15.37
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 03 Jan 2024 11:15:38 -0800 (PST)
Message-ID: <22d414cc-d2fa-4323-8cd2-61476e28e0eb@gmail.com>
Date: Wed, 3 Jan 2024 11:15:36 -0800
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 5.10 00/75] 5.10.206-rc1 review
Content-Language: en-US
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
 conor@kernel.org, allen.lkml@gmail.com
References: <20240103164842.953224409@linuxfoundation.org>
From: Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20240103164842.953224409@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 1/3/24 08:54, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.206 release.
> There are 75 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 05 Jan 2024 16:47:49 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.206-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.10.y
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

