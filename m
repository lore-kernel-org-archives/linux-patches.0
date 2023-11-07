Received: from mail-io1-f45.google.com (mail-io1-f45.google.com [209.85.166.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 44D4E2C872
	for <patches@lists.linux.dev>; Tue,  7 Nov 2023 15:37:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YUN9dHiN"
Received: by mail-io1-f45.google.com with SMTP id ca18e2360f4ac-7a66bf80fa3so36306339f.0
        for <patches@lists.linux.dev>; Tue, 07 Nov 2023 07:37:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google; t=1699371445; x=1699976245; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=LDzkQitSyi/YwAVHmkQ+3L6zd+cMnfnuVuRUDTMMudk=;
        b=YUN9dHiNidsBJFY3xZ9Wf2yECOVot7ogSLBmoh8Z4VndlILT6f2Y+v0Eq+XWT2Daeu
         mit0y92Jcwst1WywTld47xaF6bRqyPlEUy89nsSJZ6BU1Eql6UxfjXA2n7r7CL/ehbHj
         Md0ukmvqSCwF+GtQH3olpzrsz1a4pA13YtL0Y=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1699371445; x=1699976245;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=LDzkQitSyi/YwAVHmkQ+3L6zd+cMnfnuVuRUDTMMudk=;
        b=gY17ZZ8lUi+T4VlKED6n4SPCI9TQMrL6wCeBNvJpZiV2kHkS4G0bjgLgGHiaaTxrGS
         ouuw6lenU2da2YEBIVYXHCjYeuvgaP5M+B2Q8Gusd9VjrEIYfaBam3CogBiR98ysDtz4
         nr+jbNlgMEVSwIdbSDsWUhp4r6xPLQLDPTMs0mf9hblA8hzFD/5/3lAW6fJUP06oFPqA
         R9W+ALRDOQ4i1wvF5tL0QEnPmAFOFktM1+qMA4hSCPPmyvQ8QNqwVij9kiGvT4QRipDJ
         pYih+B2jhuJ7MJItFYA//xrkZ5l1YsOILowcLwpL1HVcLM8lkd6H0VfvNSCFx91k9I34
         8KPQ==
X-Gm-Message-State: AOJu0YyfCfQ1uhA73haZVU15mjwATRStwFh3bH0Y+O+n6nDOjphkH/Tc
	7CmvJZBPxRb3YU5JUBX2JPFKvg==
X-Google-Smtp-Source: AGHT+IFxxAYfY/knWpIJB5/9ALe6JFyy7qTD4vgvbpq383FXiugruIENQJikmem4+TsLENoNUajfgA==
X-Received: by 2002:a6b:5c10:0:b0:790:958e:a667 with SMTP id z16-20020a6b5c10000000b00790958ea667mr32194643ioh.2.1699371445388;
        Tue, 07 Nov 2023 07:37:25 -0800 (PST)
Received: from [192.168.1.128] ([38.175.170.29])
        by smtp.gmail.com with ESMTPSA id f19-20020a02a813000000b0043321a50c29sm2703757jaj.93.2023.11.07.07.37.24
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 07 Nov 2023 07:37:25 -0800 (PST)
Message-ID: <0bbc4351-a4a7-4e28-b1e7-082b29a932db@linuxfoundation.org>
Date: Tue, 7 Nov 2023 08:37:24 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 5.15 000/128] 5.15.138-rc1 review
Content-Language: en-US
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org, Shuah Khan <skhan@linuxfoundation.org>
References: <20231106130309.112650042@linuxfoundation.org>
From: Shuah Khan <skhan@linuxfoundation.org>
In-Reply-To: <20231106130309.112650042@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 11/6/23 06:02, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.138 release.
> There are 128 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 08 Nov 2023 13:02:46 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.138-rc1.gz
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
