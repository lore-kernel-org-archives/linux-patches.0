Received: from mail-io1-f47.google.com (mail-io1-f47.google.com [209.85.166.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ECD8743ABC
	for <patches@lists.linux.dev>; Thu, 20 Jun 2024 21:34:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718919260; cv=none; b=XhJ0QL0J/+pRL2KwImABNfZ85n8x5BZF4syeg0QyVoX/a7tIPufn5xtWbb97jDMGNr+pTEaqqXcBEJ592Zes/ls94pK26Qwqxz3gQvkcEkOIHl/+Q2SyBWPBw/1UzpAZnLatUq5lBEzpy+S6SRe7CgT92SqgQ8BC0dYfTlPIZwg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718919260; c=relaxed/simple;
	bh=KTjjL+JKAvw+Qt0PJuGuYKm2WnQ8r33t1A+d+cB5QHA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=ZXsNPji7GsY6Y+CvzNvaBbJbPe79uKV5ySkbJm8qbb0RsL4fI4OtvGidZZ/dDMNOo0T4VpCVUj67yF+n8VyonKpKAU43gFRndI347wJ3eBjLO+2r6whCtFyCIvHsbGek9QwkMfSdAiYKjTgD6eRIhrbweBCnZyxfBmHMZxXrhfQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=exwh9iB5; arc=none smtp.client-ip=209.85.166.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="exwh9iB5"
Received: by mail-io1-f47.google.com with SMTP id ca18e2360f4ac-7eb65738383so2525939f.0
        for <patches@lists.linux.dev>; Thu, 20 Jun 2024 14:34:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google; t=1718919258; x=1719524058; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=/sS9AcK82VG8l8ZobUjuQu874doLpAEywwJuD6PipkU=;
        b=exwh9iB5ARrfLFEa2mAjVusTvtS2JAM395N/nCBE0YHZ35ugM2yCEMMkGqM6ZamgC6
         sPAjwt81qsyUhe8aB2l8VJDkocAacfHPbXcShM4obr6HHq8MMa+/88QLkf4Uy+hqDu/6
         dYKsdXEJFXCGDbmn52/diicc/MwNbqlvLzYko=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1718919258; x=1719524058;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=/sS9AcK82VG8l8ZobUjuQu874doLpAEywwJuD6PipkU=;
        b=PFzJKqdmFQHe1xyvQrBbH5/ewOq4J/DSBqoS4bkj7lh2aN5z82uTuD9tuE74PZBfol
         Tc4jO0eT6yeb0LJMX+oDfAq1Igi+Q8vHW9mjBgiD0ZC4PThmT+u/OnhHbBxPXKxanM7y
         exvBhUcHH4JevGYdCEgodshNU968HrifzTQ+koNHAkhLE0MaKtiAaCd+WkWgKeWIvYUx
         qa4DLCMq2iebDJeQdcloQcnt+TTM4OpqQmJUEm3Lx0sCNeZv1ODtb6DjIJF1oJ9ZWhpe
         Cbog9eMCP9kGd8WuYuK73RzyhHQpUG7vsjjM9B8D/HOk+P7e988OIjW7lbNyKZpzw9z9
         PD3A==
X-Gm-Message-State: AOJu0YxyTpTdWDU7HldNEX7Ub6p5VHTE42nXjgJThd+tsfesnfwGTBNr
	nTDauRU11vbKdKEvvbNzl/OnHH0pSr9hccyDUJaUrGGfK1ZiHDEiKfrcGAbswHA=
X-Google-Smtp-Source: AGHT+IE7vszslD1EzgHNWCRCztpQZU+nao4bi9wPfz6rtQsIhoYpZixmMSW6UPcaae19IMvqbm/1xg==
X-Received: by 2002:a6b:6814:0:b0:7eb:2c45:4688 with SMTP id ca18e2360f4ac-7f13ee9007fmr713914139f.2.1718919258059;
        Thu, 20 Jun 2024 14:34:18 -0700 (PDT)
Received: from [192.168.1.128] ([38.175.170.29])
        by smtp.gmail.com with ESMTPSA id ca18e2360f4ac-7f391fd9d5asm2838339f.14.2024.06.20.14.34.17
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 20 Jun 2024 14:34:17 -0700 (PDT)
Message-ID: <d3d4cdb1-329b-4344-819f-356632548ed4@linuxfoundation.org>
Date: Thu, 20 Jun 2024 15:34:16 -0600
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.9 000/281] 6.9.6-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org, allen.lkml@gmail.com, broonie@kernel.org,
 Shuah Khan <skhan@linuxfoundation.org>
References: <20240619125609.836313103@linuxfoundation.org>
Content-Language: en-US
From: Shuah Khan <skhan@linuxfoundation.org>
In-Reply-To: <20240619125609.836313103@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 6/19/24 06:52, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.9.6 release.
> There are 281 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 21 Jun 2024 12:55:11 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.9.6-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.9.y
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
