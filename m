Received: from mail-io1-f41.google.com (mail-io1-f41.google.com [209.85.166.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE47F1A256E
	for <patches@lists.linux.dev>; Tue,  3 Jun 2025 17:13:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748970805; cv=none; b=KwSfLo3lYGzVVkKPkU8fdjxdIssYI42IktsQSCzrmY78bBfv2y/cmi6LUJvZ9AFo7myWPKFeU9wMCUIWHjdSshj3ZfvAHUArOWhyDgGCsz4f1EW5aZDfKBuJ1/XgQi9NzkqHKX8RI3deNPG415YvjoFbV61Q7BfZfciYaw2N82E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748970805; c=relaxed/simple;
	bh=sBXM3gHgjvKEO8hWEaFtjRYI585AMHNix0vtsLpfcVc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=S9hwBq+JaleS2S4ukvChpSi+QJMPnBwdGEWYK+V+RVUAJOw3njkTTwpsAXjE85BTOvWY2u7S2QNvZUrj3AQFYFq3rP2eQtMwtqY64/6JX00EBHq+AImgUa7sn2A0tb4BtJSH91XWv6klGMFAhk7ut84w49z2dxcBnAa34DzCyUw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Pf8FtaA3; arc=none smtp.client-ip=209.85.166.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Pf8FtaA3"
Received: by mail-io1-f41.google.com with SMTP id ca18e2360f4ac-86cfc1b6dcaso148683839f.0
        for <patches@lists.linux.dev>; Tue, 03 Jun 2025 10:13:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google; t=1748970803; x=1749575603; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=4A/eTuTh2X5YBHZFcRJOaPXK1QUqrMPM1Unydtq2yn0=;
        b=Pf8FtaA3hwsJPrbuiMX1PqB5hWJgCNGRVYx+oFGuHSrmpKVr/dG2w9L/ZOvApAWBBx
         Kv1U+5sjRBjf1PcoLmfHZLzzbhwt8XLFQU6rcCOF2J8oDlK7X03U1JIdOdH34mmVQJWb
         oSKdj9GmxoRJFYsb2TGms9GY3943E05fEbu3I=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1748970803; x=1749575603;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=4A/eTuTh2X5YBHZFcRJOaPXK1QUqrMPM1Unydtq2yn0=;
        b=B1cX/cAd+nVDJtL/VKylSmOoxlbJ86dUPnrhiOGMgJUeUhQrK+mOQwtf+lgfsklEJe
         kqvxFS7Wd4UMweGzqZMkroTfPPtDcBKQVpOOS5WFWqWlfmUWUGwpOJBSnddcsBmoYS6F
         Pl1Vt+48iK5VOubul+RywyoB6cjFPVgxn50hWFPlD8QFAx2c2mPmcbT+eJHVFMIYuPWp
         VtzJhjbN86g2DAQlNs2VK2WiuISpoNp6oKeXRAU6Z5SUZsoeM6ZQT7K7if+G/1IneQIq
         +jYWh+TKwjTy/xLrUOO1paVDTneT4XC3uyr/tS1xhGbmBf5v+jDO8BiUmccPB6Q07UyI
         vu5Q==
X-Gm-Message-State: AOJu0YyTlJT02+yR7hdiiSZQlcFh2Ivgl0uWYJIvZ0D7m/WIryLEO/KX
	9AWSO63AHsLL60n9rGaoV3iDVldrXZfec2wNGio+OzPRUS6rNSA1Lz/chuPOC1Y8Htw=
X-Gm-Gg: ASbGncsKbtY1pQlVlqwXszpk+ARVw1G6cU2uOF+lmF70cVR/mv/rnDIYpkIvGFRHdrq
	W0e15jGopZFV8PKRbHnrwmT8eTghrkyH2gUJ7xgaZO2KxAQwJXs59ZACqMhuz8VSF8s9UKPmuO3
	DK9FTbKQik38gaCrb7BwwfPXHz7QmkBed+SPueoNyBT4X56AYEboJCwRj2A+NgrLmi21xY383qk
	rqMW5kIujZ7SMQdu+DHGlXAuTKqi+SdUVN0wx63D7YXWM1vuezqte5Q3JVyoeRSp56uv7JDbB5x
	unRfFlqPHY6wdYKVNYwZlEsT4FmE3VDWFoi/33Cc/Tz5YUMLg4ctP9rmM7N87Q==
X-Google-Smtp-Source: AGHT+IHIw1R3UTJPgqPx+MyExssPYvY5omY+CdwwyLuqJPu3o2bPRg5Ahq3s7i1xBS5XVSTi+FsSGw==
X-Received: by 2002:a05:6e02:440d:20b0:3dd:b556:18c5 with SMTP id e9e14a558f8ab-3ddb5561a42mr50229445ab.21.1748970802790;
        Tue, 03 Jun 2025 10:13:22 -0700 (PDT)
Received: from [192.168.1.14] ([38.175.170.29])
        by smtp.gmail.com with ESMTPSA id e9e14a558f8ab-3ddbe2cec9dsm252565ab.10.2025.06.03.10.13.21
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 03 Jun 2025 10:13:22 -0700 (PDT)
Message-ID: <491ec349-54f8-49c4-a740-b89a7b79da72@linuxfoundation.org>
Date: Tue, 3 Jun 2025 11:13:21 -0600
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 5.4 000/204] 5.4.294-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 Shuah Khan <skhan@linuxfoundation.org>
References: <20250602134255.449974357@linuxfoundation.org>
Content-Language: en-US
From: Shuah Khan <skhan@linuxfoundation.org>
In-Reply-To: <20250602134255.449974357@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 6/2/25 07:45, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.294 release.
> There are 204 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 04 Jun 2025 13:42:20 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.294-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.4.y
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
