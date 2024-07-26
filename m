Received: from mail-io1-f42.google.com (mail-io1-f42.google.com [209.85.166.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E4FCD17D34E
	for <patches@lists.linux.dev>; Fri, 26 Jul 2024 16:38:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722011908; cv=none; b=aVMOSZMwmGpM8SPzMDKqqL1vzmm4hcSkV/vFhtehKV088CXWmXrcjlkfiNX2dWcV5aSLH0D2/IBQAehEMhiydgRs0l+FLDv32b05RI+bFYn70oEr0xzlxG0RCt+aE0TEwOT74NyJjy3RHSYb73QQD230aJEYXrW+vCzneQtO1Lw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722011908; c=relaxed/simple;
	bh=liR4FpGObaLr3N9VLnvUf9D0SqRb/BnbBXVDeZQV/Xo=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=CtyKcmJ0MLi7xKxwQkmQa+jS52kTGXJmtBrSISmbJoMcS+am2sHNxcl9+Fea7wcHBLOTxV9iXYIsiAy+WVVAYVQ37L+TjZrLp2+/ClI2IMsEwar4HevfYHwrDWnBo31LSnE9XVpKNcCB3wmUvg1rKCOtdQzs156CXy4Xanl39lI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CejLljpP; arc=none smtp.client-ip=209.85.166.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CejLljpP"
Received: by mail-io1-f42.google.com with SMTP id ca18e2360f4ac-81f861f36a8so8298239f.0
        for <patches@lists.linux.dev>; Fri, 26 Jul 2024 09:38:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google; t=1722011905; x=1722616705; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=SoDlS+0StE2fDyQgsc9/rzf13+hWCe0NS+x2HBh4HKY=;
        b=CejLljpPJifJ6lC+4xbgOHl5wxqDF75LHwN2vpncmqST1YIxqJQh8JtqZ7N55ozCq6
         3dmDFXqZwj3fpgfX6wmJk0JPAxfARvh7Om/dkpBzEn/rGrCOmo4TGUlFI8iJJqDbOS6w
         uyH3Hz5eiifg1LhTC99Sy8xQ8ZaONyuS7ombM=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1722011905; x=1722616705;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=SoDlS+0StE2fDyQgsc9/rzf13+hWCe0NS+x2HBh4HKY=;
        b=uHAdr3tlkbXQYz4z8VYQ0sTEfUlXGN1w72wixaIF4ItLe0w7n5S+4cpCL82kS6Q7KM
         Y5UjSXPK7HzYDZiU1hyQxQMs/QQDEuGhUEWFuwMzs0oWrpQK26IpDYQYn8Y3Szr56rKe
         zF+tHrMSzCFSpg2p0xmTVnWf3gR5/6XGpcOQJOMQLoaGPew0XQdJdcnRA8nprZihUoKV
         3QH1X4hLDRivQX7am5Bm1tbqnxZXjpLJSKB32zkymQRclCHiPTg5jSesGgfIducV9Q2b
         y8benVEzSArojKJgIiwWlsZZEv5MBpt+c559onAaokv9YdMMB7k2vwGwH8wy869d5Ak/
         2qng==
X-Gm-Message-State: AOJu0YyOogo29VtZV9loZyf5yl0GbO9YmaBuxzFpmsjF9xV6xAQACj0v
	TrsN4YSzEf9rLDJt5xSmR+9jFieOAujOWbVce+uhKffmH/yuSijam5oT/DmwiuQ=
X-Google-Smtp-Source: AGHT+IHx3H4hFmIxSitK5dI1fIxrAS0E0Olz8bBvOdpIdj2NyJKD2GwHGGm4gzA5iZEK6sPs9CXNaA==
X-Received: by 2002:a5d:8ac2:0:b0:80a:4582:ceca with SMTP id ca18e2360f4ac-81f7d02e3f2mr420233439f.3.1722011905010;
        Fri, 26 Jul 2024 09:38:25 -0700 (PDT)
Received: from [192.168.1.128] ([38.175.170.29])
        by smtp.gmail.com with ESMTPSA id ca18e2360f4ac-81f7d788b40sm115538939f.29.2024.07.26.09.38.24
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 26 Jul 2024 09:38:24 -0700 (PDT)
Message-ID: <e4d1e0db-9d0b-4563-95ef-b66517d5fe7a@linuxfoundation.org>
Date: Fri, 26 Jul 2024 10:38:23 -0600
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 5.15 00/87] 5.15.164-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org, allen.lkml@gmail.com, broonie@kernel.org,
 Shuah Khan <skhan@linuxfoundation.org>
References: <20240725142738.422724252@linuxfoundation.org>
Content-Language: en-US
From: Shuah Khan <skhan@linuxfoundation.org>
In-Reply-To: <20240725142738.422724252@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 7/25/24 08:36, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.164 release.
> There are 87 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 27 Jul 2024 14:27:16 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.164-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.15.y
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
