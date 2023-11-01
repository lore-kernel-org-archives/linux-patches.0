Received: from mail-il1-f177.google.com (mail-il1-f177.google.com [209.85.166.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F7AC7F
	for <patches@lists.linux.dev>; Wed,  1 Nov 2023 00:15:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="P6xahaH0"
Received: by mail-il1-f177.google.com with SMTP id e9e14a558f8ab-35904093540so4697175ab.1
        for <patches@lists.linux.dev>; Tue, 31 Oct 2023 17:15:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google; t=1698797703; x=1699402503; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=H01XgswRPGwawONIAmjiaU9xQBusRZiNk3wBO1wRmYA=;
        b=P6xahaH0LY2HEu3mGsVsNqY5d078LLYXOt/q3a8zt9bSOb3aqqMYJ7GrLbQ+3buxfh
         YQztIsC5oYAYKWbSCsJQiCdkFr6cId5xIv7TbpQEXVvo4LpiRZb1mdT6+8fgQZ5uFuIo
         RF3peg8LzmHJN07rL2/pnNkL6oiLghhlFm+dc=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1698797703; x=1699402503;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=H01XgswRPGwawONIAmjiaU9xQBusRZiNk3wBO1wRmYA=;
        b=QKm03cetX6tASEKNcjX+OG57RincXydSCIzsKd7n/dUgFmuJWTRB+JXMovEkOQOtB8
         agI5z8X930DdbC6xRDX10F0sMx+vwX49kl5pttWOLj0CT0XoD20gRgsZyRw2eqp5AL4W
         qEwZz2mUl4Wvg0HLfQoVLBzFUO820Yg49OcpIvh41HuJExGbtJ225BXpAtXGQEIAlosJ
         DWqd9eh1ADy5nG47qjjfvufw4etP/AQWjYLD8ru1tJPcZZDld3M5JuNzCYcQlu0aaceF
         aZRFv5Dejt3lbiMI7ydn6tkr7A9W5e1OdldIUWvalp9juoffrBaoYXSbeVleFUUINLY3
         tp5Q==
X-Gm-Message-State: AOJu0YwVenSE5V+LPf6PeHU/mBMiEXjRmCtmAq5t6VW716bEImrW43cy
	8U44MnTt2uswd8lhPE8yv7l2Ww==
X-Google-Smtp-Source: AGHT+IGl+WxhoFAyV7WnhN40xADAgliUOCfNAwIL75Rsrgz0hw4g6miD1Ry9thMYblpeYpqd4Qn83g==
X-Received: by 2002:a5e:a80c:0:b0:792:8011:22f with SMTP id c12-20020a5ea80c000000b007928011022fmr16901322ioa.0.1698797703330;
        Tue, 31 Oct 2023 17:15:03 -0700 (PDT)
Received: from [192.168.1.128] ([38.175.170.29])
        by smtp.gmail.com with ESMTPSA id l14-20020a02ccee000000b0045ae21e7291sm614212jaq.32.2023.10.31.17.15.02
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 31 Oct 2023 17:15:02 -0700 (PDT)
Message-ID: <1140cd7b-e1b0-455c-8219-1b31e0227bc3@linuxfoundation.org>
Date: Tue, 31 Oct 2023 18:15:02 -0600
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.1 00/86] 6.1.61-rc1 review
Content-Language: en-US
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org, Shuah Khan <skhan@linuxfoundation.org>
References: <20231031165918.608547597@linuxfoundation.org>
From: Shuah Khan <skhan@linuxfoundation.org>
In-Reply-To: <20231031165918.608547597@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 10/31/23 11:00, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.1.61 release.
> There are 86 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 02 Nov 2023 16:59:03 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.1.61-rc1.gz
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
