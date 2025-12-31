Received: from mail-pl1-f181.google.com (mail-pl1-f181.google.com [209.85.214.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 59F5C283686
	for <patches@lists.linux.dev>; Wed, 31 Dec 2025 16:42:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767199361; cv=none; b=nQCiTNUrnhI2mDuCHMdRCeQlGcwYf6IOGRV8MvhlR5KKhW78nSYYioj/KIlVVfeJ3YnbSoqDGZzHyR1HYX7IvHlLBioCLX888VE87YINLYAdeII8GJQWPi84XxirQpttI0L3q3oaRfDtQLo5WwgILSwbPGqmpOT2GZ+kYveAKPo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767199361; c=relaxed/simple;
	bh=YpCg3qw+Z1wkIcOm4rB2dEF4s6zC158uPvyqzAu8hgc=;
	h=Message-ID:Date:MIME-Version:From:Subject:To:Cc:References:
	 In-Reply-To:Content-Type; b=W4GB2nBI3sHFFdYsapZhg2FQzoA2eZiFsckm4Hu/TyoPT+f3MKVaZstPPnMfFlVeZRDq/REvYlzB6800R+34fbOAthkeUzJovn8HXvC4iR97fCGoSeQy1FXyFVxGef6Tg2N2j88ZaoAdOmiHKAZpqhOTv2OK2+luhT9b/8ctst8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=HGXGpb1b; arc=none smtp.client-ip=209.85.214.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="HGXGpb1b"
Received: by mail-pl1-f181.google.com with SMTP id d9443c01a7336-2a0b4320665so167398805ad.1
        for <patches@lists.linux.dev>; Wed, 31 Dec 2025 08:42:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1767199359; x=1767804159; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :cc:to:subject:from:user-agent:mime-version:date:message-id:from:to
         :cc:subject:date:message-id:reply-to;
        bh=4oKHQ/a06IGiaHLwaEqb+SclSJxG6Kp0hGdhM04nP50=;
        b=HGXGpb1b6aryYkwGlNlR+CM+JBGw+ZASvjTneM/RGvtFQpk+PC6W/v1y61QIty9S2A
         pbpsSi7VjT+neOOXOVbkeaFwPYIUmOS0RFACLWamO3sX05NnoAp2QWYB2Rpeqo8fQrFo
         qbWfkihGrG06gdnb32Rfseao3ysAFdfNEBQu0FWkrV8VVXoOBx1T3oQJsOsdtAK1+CcU
         KeF4Y9sEMANzgSZNXgKKxOluA0RCjVqLpOZt8t6lp1D9M6YiUcbkWU/xIINoDMiBm7X7
         Sec/VpO2Jt7Vkgr2tMvScv2pQuZV97xfJ2mOsc9zBEzQw4DYQakPBxNd5Z52MW/ZrlxU
         M/Ww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767199359; x=1767804159;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :cc:to:subject:from:user-agent:mime-version:date:message-id:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=4oKHQ/a06IGiaHLwaEqb+SclSJxG6Kp0hGdhM04nP50=;
        b=Abz/9eyFA3IS0Gg05Eyhvp3N1HybyEqtaWzuSoNnHsoNFAMwizfuHVpiaVGwWG0s89
         1iYBZVxmXaXv3W+HkUA8J4EH69as1VR6wP6jPC+rbHz/xNOStY/Mw1PM01/itUCQh6Yv
         OdukTlZvbSa8u/8WroonLA9h1AZ8XZ96tlQU8eF1CWXIGwmpohixj1q6XmubBdy5P3Ay
         zE6c8KVEPPEDAqQmQOYBcDtRLTgmHX/+xpBUAexjZg+Lsx/plli6TiMP4en522NvkQ2O
         fj06lwcPFhOuV3ZYNwTkSACGk4R7jzLluMhdYM10ywwW1VK3cXZHiU+CVXsrw/GflhJZ
         281g==
X-Gm-Message-State: AOJu0YyYdiw5vpdn2KchKo3Hrp1R6DR0dwMK+KkUgRgkOxhh32rvwdNk
	8mvAbiKXDadT/dMMUrGUkLSP9e2/ndKXGO91rrx3d4QT1q744zVMprSN
X-Gm-Gg: AY/fxX4tWUUlVxsxU750XwuVZTnGuyKdosIEYqjpTi13U6UVzUipyTSr7mNVJZiosxj
	UW8OJO3rKYWSQCP4aT6a6f15t9exm6gF/hZZs3ZUQKYyweDaccuyBw4QFm2KVvsWUcyvyR/xXYT
	wqMn/p7CEGRUykyM924G3U8FkOE/0iw5nEZd6MeIq6x7msGM5RuFxX0HUqJFlsxsvCBj3Z55OGN
	pzycI9YjFXQpj5w6rGUCyq8Gr3ZAYhxKPYX2V1o2by0t7RNsJY8/aPmkwSWlcJMhXtAntiSRcvg
	kUgqZwaUJupeyTzQPCpXdQ67K0t5+9fJ/+tPtNiKFbmqK7bC3XsZvkrRomnLtF9dusiVO+W+ApL
	2Mi0qYYbbU/wBUs/yobEY6DnevTt0jUNv6IFozbAjj9UPIfP3FbsYRyTDgCYA6Uy2GghCSeLY8C
	XxMtJC/uJ8XlvIPcPMLyN+pH/P1hvZtGvTjetKfGOJjOGaqpuqDkRl
X-Google-Smtp-Source: AGHT+IFBoAaXyfy0SkCC/oCwJazyENqfm00APYCRV06LNH0kLYlcc+IDqG/xDcpHfu2EMDNPQrIbcA==
X-Received: by 2002:a05:7022:6886:b0:119:e56c:18a5 with SMTP id a92af1059eb24-121722b46c8mr32858031c88.13.1767199359365;
        Wed, 31 Dec 2025 08:42:39 -0800 (PST)
Received: from [192.168.1.3] (ip68-4-215-93.oc.oc.cox.net. [68.4.215.93])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-1217254ce49sm136098635c88.15.2025.12.31.08.42.37
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 31 Dec 2025 08:42:38 -0800 (PST)
Message-ID: <2af82725-2ffd-459b-aee6-12cc8e5635a5@gmail.com>
Date: Wed, 31 Dec 2025 08:42:38 -0800
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
From: Florian Fainelli <f.fainelli@gmail.com>
Subject: Re: [PATCH 6.18 000/430] 6.18.3-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, rwarsow@gmx.de, conor@kernel.org,
 hargar@microsoft.com, broonie@kernel.org, achill@achill.org,
 sr@sladewatkins.com
References: <20251229160724.139406961@linuxfoundation.org>
Content-Language: en-US
In-Reply-To: <20251229160724.139406961@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 12/29/2025 8:06 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.18.3 release.
> There are 430 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 31 Dec 2025 16:06:10 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.18.3-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.18.y
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

