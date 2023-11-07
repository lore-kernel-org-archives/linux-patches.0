Received: from mail-il1-f169.google.com (mail-il1-f169.google.com [209.85.166.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E7D12C872
	for <patches@lists.linux.dev>; Tue,  7 Nov 2023 15:40:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="F2+1SLyZ"
Received: by mail-il1-f169.google.com with SMTP id e9e14a558f8ab-35950819c97so3879995ab.0
        for <patches@lists.linux.dev>; Tue, 07 Nov 2023 07:40:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google; t=1699371655; x=1699976455; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Tz/3EAWv61f6wEBvRr3aAF3KcbwKrMc//gR1rrcsb8w=;
        b=F2+1SLyZiScxU1MFojnQqROhPbT1cGJD7MBqatR4sOQDcfgwOSkryN/PjVH4Oic3wW
         Rbzrr2N2x52z7NmCf/XINYljKydz7YGWvloo8xSnlyVtvXazfUftiBRb6QQUml1PqltG
         uEI/yeLYjJ6boB+6eng3nkPr+xy83LmxRDzlo=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1699371655; x=1699976455;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Tz/3EAWv61f6wEBvRr3aAF3KcbwKrMc//gR1rrcsb8w=;
        b=KrgY4H4ViHQy2z+ryMbKapN1Zi6VIvLTZAqo8ENM1Ar5g090TA9rkfiEMTpxF/FP37
         TppVzCAcZNdhURhaSg1d12TXg4/fFQcSv3oQicz2JY5gw2yzc/YH3aWCRuPDo2fJWF4g
         arpVJvAzdPaIbvkSaaDmqVCnXGn5glaHHqf3mnCKU6vfTPV8YBi5d1dZFVSKkotu6GbN
         IRSoLWhS694Sw/6lf16DToqMUzN8foOPTGhynCmehaV1lN1YKFDGwYv6IgBQLMUZZzi/
         p35A9EAyT6EPOMypr/vC2BM1vR4VO02KRKtrTMr9lrx58sWHR++ZS2LUIIauW3puqPbO
         BrMA==
X-Gm-Message-State: AOJu0YzYnFJ3nVMwczuhPeJ2l3GZrDSi5Kb04lPIWx5E9kceHAyNnkUI
	Uy+mu6xAsT/DAKa3g1L7VTYQ2w==
X-Google-Smtp-Source: AGHT+IGQAWYgGlHvzGOchOtYfwGf4w5IoTPD/+kKzlZTcA7bY03Zr+sGBRvCeJPucCtA1SCy16Gjew==
X-Received: by 2002:a05:6e02:168c:b0:359:4db7:102a with SMTP id f12-20020a056e02168c00b003594db7102amr25003454ila.0.1699371655252;
        Tue, 07 Nov 2023 07:40:55 -0800 (PST)
Received: from [192.168.1.128] ([38.175.170.29])
        by smtp.gmail.com with ESMTPSA id f8-20020a056e0204c800b00357fc1e2ffesm766889ils.23.2023.11.07.07.40.54
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 07 Nov 2023 07:40:54 -0800 (PST)
Message-ID: <48432650-09c9-4cf6-8ec7-9c4577c18e38@linuxfoundation.org>
Date: Tue, 7 Nov 2023 08:40:54 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 5.10 00/95] 5.10.200-rc1 review
Content-Language: en-US
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org, Shuah Khan <skhan@linuxfoundation.org>
References: <20231106130304.678610325@linuxfoundation.org>
From: Shuah Khan <skhan@linuxfoundation.org>
In-Reply-To: <20231106130304.678610325@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 11/6/23 06:03, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.200 release.
> There are 95 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 08 Nov 2023 13:02:46 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.200-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.10.y
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
