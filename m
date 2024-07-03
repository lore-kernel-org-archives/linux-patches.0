Received: from mail-il1-f173.google.com (mail-il1-f173.google.com [209.85.166.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4CE404964E
	for <patches@lists.linux.dev>; Wed,  3 Jul 2024 23:04:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720047890; cv=none; b=DQMkDPaA+X6NJ95uGn531UmVPkCOe+nrQlppm3VDHMgJnN0+DiT64nIm+JUHFoRNEbOCLwtDmgxePWXVzWj5LSTgem2S2W8yaaHwe48H/m/ov24scoIkkvyAyXEa0qeHR60dUwwgP1YzoqYksocrQ/WD0GCT1F7TVUcjiDRpD+U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720047890; c=relaxed/simple;
	bh=XAbTDSCiuix+leu4nt20ZGL6CGC5tq+OVyQUmfdwLc4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=EJmdKdAI+Fka6+HzOIPqt9WT5/G8/aJO6YmjRFd0l050WPKtTPLdglxGAs7TR+W6l3np+9HOttazLyVXZ36DhR85TLLVu3uUIxETBtJhWXkCi31H2jUOtzTZPa3zme2VwEuqhUHJFhW8kvOKXlj/Y06jN/i/3YyEuHDyuIPxWmY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bEZi7m4+; arc=none smtp.client-ip=209.85.166.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bEZi7m4+"
Received: by mail-il1-f173.google.com with SMTP id e9e14a558f8ab-3745eb24ffaso36475ab.1
        for <patches@lists.linux.dev>; Wed, 03 Jul 2024 16:04:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google; t=1720047887; x=1720652687; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=B1Gw0ZjNIkvjLQEAJl32qrbP+mBtuKKDlcaDQhvoYrY=;
        b=bEZi7m4+Xl31kpXIjU1uiR4xp0BZJJTDbIJn7JNvkPjfNzfqBRy1h5SAKgtufmTldt
         XRpSiO6jPvfv42FBrxjsYjbp9Duqv3Yc5dwnDV2hYzGvtr0A9fxCjeGEagHTaJBXEMlE
         vQQFPbyzkM7MplEE7+bR7WVz+0TEAxJjo6gwI=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1720047887; x=1720652687;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=B1Gw0ZjNIkvjLQEAJl32qrbP+mBtuKKDlcaDQhvoYrY=;
        b=Qkn8qYL7e5fpOVMaKtQe02ECumEG2OtbXE7zZXWETpRiQOvD18BbNtoG42/eoWJRXs
         c1Op00RXNE5axm7TDySS0XgcF4lXeQlNDnpTmKmNkF8VqXFkIYIUerZsJkaJB0CsZ14h
         aqcRN6qeriMRnomepSLeGy3IaFnaTaSy/X0VUpIvmc4EJXF2XFqgskfRZ64otsnpLLSh
         0b7+F59ePBU7/V1LUpOcBGzXd1hvrIOdr2ETOxd7CLYbTBaJZRx86To3U6MgwTltIO34
         sQ8D72BbzmgKSh6CCBHmRfLHkUNqQ8ZfYixdeJoe6OjBgsR6Xp5D9S9QtghkvB7xw7Zb
         UCPQ==
X-Gm-Message-State: AOJu0YyTUmZGS0J1YBAc2qvcZnZwqa1NBTrRiW9ius0Lr5j32Qt+kjWv
	bssWaDp0uCf6siU5KEw3fUhQQ5RkHRPIQ5887RzzhYT3qrFrj3buKmxTHDBrav4=
X-Google-Smtp-Source: AGHT+IFDVsmppcbGL+gnyzISDited4s3wOkjFHvBfz84LQnxxLISKA0y1gljgdxrjb0h8+8a01JC5Q==
X-Received: by 2002:a92:c144:0:b0:383:17f9:6223 with SMTP id e9e14a558f8ab-3839a0339b7mr882935ab.2.1720047887367;
        Wed, 03 Jul 2024 16:04:47 -0700 (PDT)
Received: from [192.168.1.128] ([38.175.170.29])
        by smtp.gmail.com with ESMTPSA id e9e14a558f8ab-3838f132c29sm342175ab.5.2024.07.03.16.04.46
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 03 Jul 2024 16:04:46 -0700 (PDT)
Message-ID: <c8721a72-17c5-4619-9128-9260214ad0d5@linuxfoundation.org>
Date: Wed, 3 Jul 2024 17:04:45 -0600
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 5.4 000/189] 5.4.279-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org, allen.lkml@gmail.com, broonie@kernel.org,
 Shuah Khan <skhan@linuxfoundation.org>
References: <20240703102841.492044697@linuxfoundation.org>
Content-Language: en-US
From: Shuah Khan <skhan@linuxfoundation.org>
In-Reply-To: <20240703102841.492044697@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 7/3/24 04:37, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.279 release.
> There are 189 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 05 Jul 2024 10:28:06 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.279-rc1.gz
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
