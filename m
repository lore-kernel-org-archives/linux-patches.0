Received: from mail-pj1-f53.google.com (mail-pj1-f53.google.com [209.85.216.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 537241E1AC
	for <patches@lists.linux.dev>; Thu, 10 Aug 2023 14:23:03 +0000 (UTC)
Received: by mail-pj1-f53.google.com with SMTP id 98e67ed59e1d1-26854159c05so548840a91.2
        for <patches@lists.linux.dev>; Thu, 10 Aug 2023 07:23:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1691677382; x=1692282182;
        h=content-transfer-encoding:in-reply-to:references:cc:to:from
         :content-language:subject:user-agent:mime-version:date:message-id
         :sender:from:to:cc:subject:date:message-id:reply-to;
        bh=msHL0g14jrk8G1/JTK9Lm9LlFMtaEtngahDCmTUPo1s=;
        b=brTOiRrvLSbfbJ0fh1nNuJMaik02Rn46Cs0m/eMM2rzWScm/6mh0k195Kg3vibIAJN
         VwfiswJ4J7tma5sx2PjVjEUfYnOreI3i4K34lKIFPOn49skcQhhp0WZK5hqHq06MjJUM
         YAD5sifkyU8wbrVTvneb5XUAEx4ydEW6KgiLHLhNst5iIOw0EZ7xwxFSBE/gB/DVh0CS
         5QFjbr8Tu+EPzbagftn54R1rZb0EcEwbgKwrnZwn7H37l9FZfe6IM/Aust8iTLdnZbfX
         1Xjnt+zZzwqmCLuM13to/XFOCwrYhKLK+TA7pvKx5i1zYb+hlX0HkkojW++FkhKjHiCs
         oJeA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1691677382; x=1692282182;
        h=content-transfer-encoding:in-reply-to:references:cc:to:from
         :content-language:subject:user-agent:mime-version:date:message-id
         :sender:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=msHL0g14jrk8G1/JTK9Lm9LlFMtaEtngahDCmTUPo1s=;
        b=GImsi6XFx35Y0CZeu9/H5m8+4u3yTzhrsoG5+vBfBBhVqsx7Lgr+2qh5OCabMgi1K2
         r9oMu9gRITU0KunB3qgzMWol69PhutI6TOhcvARZW5FxFT+n/RNwYDERnx+5VCvN2qPl
         mPzfZ93LWM0+PYQ4tOoP8aJeWHULAtmPNVf+Z1YZneGj5rlWs1Caa4cTghX7pYJrq24b
         BvDxZIpTo6wMfUkKi7h9sCGClfI7W79UEI6rhch5k5+CaZgbKHC9Gw4maIA8KlZqP6jg
         gPNTGahF8rNaiH8dlHNjIBfsuNtYBB6psx//9ZDoPLHnLezGDQ8sDZoJhFP2ijC1WY9g
         dBeQ==
X-Gm-Message-State: AOJu0YzPTD8a4lc9ieky8FCWHW4hXLu3rtxfbPrzqx8XwRWOSqIaJ3/h
	hpszHlXwh5fv3wRopRe85Z8=
X-Google-Smtp-Source: AGHT+IFsDHXk8JYqWSwXQ97oRH5J69hzQj3HGGw7bbihDixPnjvjYKUKPnaVP9ZttWo3x1w3GSja3g==
X-Received: by 2002:a17:90a:bd17:b0:268:fc26:73a9 with SMTP id y23-20020a17090abd1700b00268fc2673a9mr1899019pjr.40.1691677382551;
        Thu, 10 Aug 2023 07:23:02 -0700 (PDT)
Received: from ?IPV6:2600:1700:e321:62f0:329c:23ff:fee3:9d7c? ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id a9-20020a170902ee8900b001b1c4d875f5sm1821299pld.44.2023.08.10.07.23.00
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 10 Aug 2023 07:23:01 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Message-ID: <d52167b3-46c3-1c5f-b4ee-5c9da4400284@roeck-us.net>
Date: Thu, 10 Aug 2023 07:23:00 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.13.0
Subject: Re: [PATCH 4.14 000/204] 4.14.322-rc1 review
Content-Language: en-US
From: Guenter Roeck <linux@roeck-us.net>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org, shuah@kernel.org,
 patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
 jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
 srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org
References: <20230809103642.552405807@linuxfoundation.org>
 <9d35afea-e1b4-72d0-9559-1eccdfd069a8@roeck-us.net>
In-Reply-To: <9d35afea-e1b4-72d0-9559-1eccdfd069a8@roeck-us.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 8/10/23 06:56, Guenter Roeck wrote:
> On 8/9/23 03:38, Greg Kroah-Hartman wrote:
>> This is the start of the stable review cycle for the 4.14.322 release.
>> There are 204 patches in this series, all will be posted as a response
>> to this one.  If anyone has any issues with these being applied, please
>> let me know.
>>
> 
> Building sparc64:allnoconfig ... failed
> --------------
> Error log:
> sparc64-linux-ld: init/main.o: in function `start_kernel':
> main.c:(.init.text+0x77c): undefined reference to `arch_cpu_finalize_init'
> make[1]: *** [Makefile:1049: vmlinux] Error 1
> make: *** [Makefile:153: sub-make] Error 2
> --------------
> Building sparc64:tinyconfig ... failed
> --------------
> Error log:
> sparc64-linux-ld: init/main.o: in function `start_kernel':
> main.c:(.init.text+0x764): undefined reference to `arch_cpu_finalize_init'
> make[1]: *** [Makefile:1049: vmlinux] Error 1
> make: *** [Makefile:153: sub-make] Error 2

Those build failures were introduced with v4.14.321.

Guenter

