Received: from mail-pf1-f176.google.com (mail-pf1-f176.google.com [209.85.210.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1EEED30DD01
	for <patches@lists.linux.dev>; Thu, 18 Sep 2025 17:26:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758216414; cv=none; b=Et/0FGgDWFa3zEgtSlUzZElHdktCqvw/MQKz/6NqcN4OspTywk7dE1Tx94UbnyhXingYwbfjr6Sx9ya5F2MPYYyjA3LHnvIoXiU5vu2qij4PCIG+1PtjaV+bWILeGmQ7qiV2jgckWddSKF55CJO7jcsGg5yAkedwrjgQHbH1b5I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758216414; c=relaxed/simple;
	bh=rB8tPEOPRzhba5eLwtxrWUp/9qJMpIYZ22j7kwy6N+Q=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=a7AqFcD9Vhu80ALdgB1ZyxjE0gQRt9MqGM66OgZ+ScepCjYxCESMiUnhTleSYclMzHUhuBtpQs2ZhulCCHyoQeemKC16/SFjw1G4bgzffkJ0C4ukfPeakTRfWxPsbsvfjdmXomefq6Dx8OO4fB2GObcMPEajx5YBcsLWz56x6Gs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=jZi16XP9; arc=none smtp.client-ip=209.85.210.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="jZi16XP9"
Received: by mail-pf1-f176.google.com with SMTP id d2e1a72fcca58-77615d6af4fso1787711b3a.3
        for <patches@lists.linux.dev>; Thu, 18 Sep 2025 10:26:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1758216411; x=1758821211; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=lSL7OFemqt/NSr5lMBXtrsDUmlnbLhLq1OBPdZomIMA=;
        b=jZi16XP9i8emateGfwcodYZQ5gp69bOsGZNySN3bZvnEdG1a+uDx+8s9+wv2jDDer+
         PWLHJkEDdq6q9k2/KP/aM3jx/zaw39CbEmpr90Ri1+SKRnqUzRDZuQf6e/3HEWNrUTxv
         ZNJVXu/th8166BFDS1DyusZ7rsWaqM0EHNYJzEOTlArdjudqkHVfhamcu9oBQ7cv4j70
         yjfbkZja+6j9HbZawYe3lBJarFw2kTGN5oO98kM3lrduwemyjB/wWUqx+/ET4s76Ab91
         t9WC/OKNMXeBxNYVWZyE7RDFN7O3fkhrmEjV/VPekkCSQ/IW+UEf36YXf96UHso9Uv8r
         Pp9A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758216411; x=1758821211;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=lSL7OFemqt/NSr5lMBXtrsDUmlnbLhLq1OBPdZomIMA=;
        b=YV6nLI4gulMZ1XjAQBGP0XYdCfzPtDh85yFi0Ygku5dyoBRUlW7IwGHTmZhkNEKb49
         FY5/HlC+xNTPyWPrTjL02m2cKfT/okb51q5I5Ym7aMX3wA2Ybv2zU1UBvvtawI3BhpN2
         H8Q8tJRkh41p82ck0m0uTW8qjCfyhOyLDgJYB3HTWUyGZQFdP9VS9G4lZv/a0h469kzo
         hCf9vzSy9IevdDnSorPDJb50BvgPa1NN4neA8+uZci8sWRLKodZDfkaTIXSqwun/7O85
         k5B9UJOnqojCTEa75xLy+PGiAykn+ScbanvJ+Ytz2AWZUeHob2Zsi5TPV4ulRL9v4XhP
         3hnA==
X-Gm-Message-State: AOJu0YxCyLODXZfgNVWP1ZWUASVGgPLeOv/TaHlXjdVFunHuIROQNvsn
	GRzcgCsbFSm9aBUy2eMfWb2LVgOXQY9wvUSRvJpIxdf0MSED1qIZG5JB
X-Gm-Gg: ASbGnct3tZekxVKMos1WaUMjpgUHKjJP2VrSuMSlQDGtIXKYQDAZrciJDh1H4j9Tp8m
	1/IbPHJtnpFiBHPfIU6HLiJaO3i3MWoqiYUNvqNg/h7J9PuuEEAX3CMZIJJDQ+mEMvY2xYDUqMP
	7GU0+OWE6+JmhbL8PUaoDzvhzWbO+ooRChIy7Z7d87OYKgX2VXIEesOjlqYEPxCVSAXsNtc52tU
	SycpLammXSWGAx9fm9SE4gEqsYuPxZ5XiCyx/u6LnDSw6/ANPnQYHPgnCnz3cQb4Wmi5bKjMfls
	OLFXsjEeOfvXsFpu/oszUS7hC8zRoSZvPKK9au+2yAC4S3Pk8o+xUUjk/AlZz8EwkgWA0Feiyyu
	1U7X20INmao8hv//RxCCqK//RhuKFbAlu/MMqu8TU3qv17ZR+6azxp4rxXH5thpUDJVIVh7uwL6
	xlLAQu0A4=
X-Google-Smtp-Source: AGHT+IF3/L7P0F5rFfW+9cQVyy8quCWoy76tgJTxC2HHDreQRLnIJl3IZDhU8wQipfAMzXT01RaFYA==
X-Received: by 2002:a05:6a20:e291:b0:240:328c:1225 with SMTP id adf61e73a8af0-29257ff98camr555934637.12.1758216411343;
        Thu, 18 Sep 2025 10:26:51 -0700 (PDT)
Received: from [192.168.1.3] (ip68-4-215-93.oc.oc.cox.net. [68.4.215.93])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-77d6d1883fesm2267894b3a.59.2025.09.18.10.26.48
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 18 Sep 2025 10:26:50 -0700 (PDT)
Message-ID: <2270a44c-0480-4261-ace0-c2d6845d6556@gmail.com>
Date: Thu, 18 Sep 2025 10:26:48 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.1 00/78] 6.1.153-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org, achill@achill.org
References: <20250917123329.576087662@linuxfoundation.org>
Content-Language: en-US
From: Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20250917123329.576087662@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 9/17/2025 5:34 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.1.153 release.
> There are 78 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 19 Sep 2025 12:32:53 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.1.153-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.1.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

On ARCH_BRCMST using 32-bit and 64-bit ARM kernels, build tested on 
BMIPS_GENERIC:

Tested-by: Florian Fainelli <florian.fainelli@broadcom.com>
-- 
Florian

