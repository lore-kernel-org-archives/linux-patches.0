Received: from mail-il1-f182.google.com (mail-il1-f182.google.com [209.85.166.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F32E1320F
	for <patches@lists.linux.dev>; Wed, 28 Feb 2024 16:41:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709138494; cv=none; b=KKStSlcUjr07kg5AY6rg8UIWCdHIggaFpI50+G19korcFyHlgnUIETgq2mpwFujgwfgTaOM5gwqOYMFAYJzfrwJIb5qTsN3+MAOzP8YncNeorne+NmQx3sFxgWI8zd7TbYI0laDuYf8nk0KtGAh621DdWOrh/4D0NXY4TQ3G1FE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709138494; c=relaxed/simple;
	bh=TMSEQ1DwvaNLQs2sR+09rtomP5hVhyZrbPg6TZDQrZg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=AORfJKGr+z9jaJxnVC6wY5bbhKfsOPEm8Dw/eyY6z8ObSO4q6OFztxeVg4pLoTOPkI1wPSR0K4duPrTSFQRW/PccO9yDMEo4kfBcUd4rYO5LhXvOhPgp8v9rRSJs/vXIN+TpQFUGJvGG2ZwBqR6dPG24Tj3KWfYAXub1EHXZazs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=P5rPyJXV; arc=none smtp.client-ip=209.85.166.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="P5rPyJXV"
Received: by mail-il1-f182.google.com with SMTP id e9e14a558f8ab-365c0dfc769so415035ab.1
        for <patches@lists.linux.dev>; Wed, 28 Feb 2024 08:41:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google; t=1709138491; x=1709743291; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=fsnH6cWddi0m8DzE0iTefNtxyP9czfqdJz+Tpy09Cf0=;
        b=P5rPyJXVJUHpQJhJXJcknJDB3T6IzRrm6lPfQsTCxHPrHFeAGDFOqUVCInOk1nN9Nx
         oxrEivrAHPa5nxZe6OYz8KynfL5WndnmQPvaiy31LmcO4G3711R9whrSQRWWpDlhttTm
         Ol95wOG6gEczWfciQGlmZ9NcUjlUU0TzMN8nc=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1709138491; x=1709743291;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=fsnH6cWddi0m8DzE0iTefNtxyP9czfqdJz+Tpy09Cf0=;
        b=PP2NwkLAViaoZhW+bo8o9sTL49l1CN5wZd0so1VHTpNCS9CleDP0NaY1x1YwRAdiay
         TG8TrFAsqBCElJdFfYkbHZwkPfwJOBiHv2NuvzE6gbIC2f48dW6I3Jc2dMCbO9th4Yhz
         6Cni8wKB/VOUw++TFFfZ48EzSJ5gF9IZ97JFtJ1vIswQdEInTgkzTJJcq6/ww45PVLVw
         maNsRCGdh/uwV+i075zArwcaAZoVVVAmQeBaXi8A+DD5rzP0VDkHr2CJ/pHVLHl18ES0
         lhLboFAYGTf4r3YZ1hBTtQ/zjAg8p6LA5OYxFPbRCr1nOz0kGaG/S6HgNpS7/xtpEIC0
         rQqQ==
X-Gm-Message-State: AOJu0YyVtXVpadOxzydeUsx5/ChQ16+elntKnpi/YRQTBUGZP5Y2CsP0
	1ONZ2ApGCyh4n5vpJJz18yC5+rzTYaYA+WGrE88btzoOIzKu1xmMIr2wKETF8QM=
X-Google-Smtp-Source: AGHT+IFimdqecE4SJGAfQoDywQAZJJvabdZpvtekbx7ZJni0NQBheGQk47VQD7g+bEax4Ag+pN+ZUA==
X-Received: by 2002:a05:6e02:1d86:b0:363:b545:3a97 with SMTP id h6-20020a056e021d8600b00363b5453a97mr12995175ila.0.1709138491242;
        Wed, 28 Feb 2024 08:41:31 -0800 (PST)
Received: from [192.168.1.128] ([38.175.170.29])
        by smtp.gmail.com with ESMTPSA id bs17-20020a056e02241100b003642400c96bsm2891272ilb.63.2024.02.28.08.41.29
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 28 Feb 2024 08:41:30 -0800 (PST)
Message-ID: <5f248be8-0c93-4656-8ebf-e9d29fb36f09@linuxfoundation.org>
Date: Wed, 28 Feb 2024 09:41:29 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.1 000/195] 6.1.80-rc1 review
Content-Language: en-US
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org, allen.lkml@gmail.com,
 Shuah Khan <skhan@linuxfoundation.org>
References: <20240227131610.391465389@linuxfoundation.org>
From: Shuah Khan <skhan@linuxfoundation.org>
In-Reply-To: <20240227131610.391465389@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 2/27/24 06:24, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.1.80 release.
> There are 195 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 29 Feb 2024 13:15:36 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.1.80-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.1.y
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
