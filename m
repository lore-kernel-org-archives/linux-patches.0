Received: from mail-qv1-f52.google.com (mail-qv1-f52.google.com [209.85.219.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BDD0A2F85E
	for <patches@lists.linux.dev>; Tue,  7 Nov 2023 22:01:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="JEsr9vTx"
Received: by mail-qv1-f52.google.com with SMTP id 6a1803df08f44-6754b4091b6so38647446d6.3
        for <patches@lists.linux.dev>; Tue, 07 Nov 2023 14:01:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1699394484; x=1699999284; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=2CJun7UB52S4zZmzZk7Tc5+t2/EYY1acmDjuc/JVwgQ=;
        b=JEsr9vTxumhyMhr9jHgHSzYARwwLHpxPdwIwiIsDS4VVaWJOYtlUVeV0MwagktVhjE
         E8KpSo+gZry0+AkraooF1V+Xvn9ysy7hm1gjhqIY2eq3Z+rdfYIaG9K2sqOGTtYDh2v9
         VhTkLYeusWIDoTmQ70NSOLXUAQuvgRDKA95yekFRQHY4MQHt13akalKr0Kq1FKatlWFw
         S7mLn7G7cPoYEteStc34oESlsspz9d24eQ8/JT7BlbAd52QVmZ2AocjvK9cGlbL4FFdC
         4Y15bynRh48hiMN1qodgRoQH3oABG3qeOKnnDnz7r+OkUvmd3ahlTbIlQIlOw7UkBUQR
         kzYA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1699394484; x=1699999284;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=2CJun7UB52S4zZmzZk7Tc5+t2/EYY1acmDjuc/JVwgQ=;
        b=oAowfNwZTXgylqs/DxQSlSzYbx7AlsCc1TexFGFgrdqGWmp1H6S8ivOCT5UYk2XT/S
         HiZEBwMWWlZyJ+fwP9GeYSvc/RQGTVQoR6JAOFC/zf4Z8+XbC9BNcH6tN4zpcspJQ9F/
         EZwcWWPBhizre42EJPm44Tf4orxiKi2Ib8Zskid3dIH8bKtkFOdM4YKQGmyD8NFclnW8
         mreNuHkQ7DeFuIyVw0sYxugYN+TrslHXp1U1+Wzc2qBtJiwKlaTtTNcHZj3Acl4HpXrU
         VH7/loixQpeSgkDxJKA/0GpP9IIgaiBhjBYqN65HlFLz8uEf2DojlZk1DERMdOWIJ+m6
         dTwA==
X-Gm-Message-State: AOJu0YzIZqMWp9w0FeLq9uXIeO2dEJJWPahhUctfC4yWhVM6BfRkkdXj
	lAbiHFvq30iSWaBsR+mtjis=
X-Google-Smtp-Source: AGHT+IFTHyw9DU2WGhjY6FcF6KtbfcVzCzuY8S2stcJyiOKpBL+mrrHEXciP/HQOemZYy2hIv7k0IA==
X-Received: by 2002:a05:6214:e64:b0:672:118e:e368 with SMTP id jz4-20020a0562140e6400b00672118ee368mr49430qvb.24.1699394484288;
        Tue, 07 Nov 2023 14:01:24 -0800 (PST)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id nd10-20020a056214420a00b0066d0ab215b5sm340940qvb.13.2023.11.07.14.01.22
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 07 Nov 2023 14:01:23 -0800 (PST)
Message-ID: <847671d3-efef-465b-af9c-f9789f9cc1ef@gmail.com>
Date: Tue, 7 Nov 2023 14:01:21 -0800
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 5.10 00/91] 5.10.200-rc2 review
Content-Language: en-US
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
 conor@kernel.org
References: <20231107202447.670990820@linuxfoundation.org>
From: Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20231107202447.670990820@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 11/7/23 12:24, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.200 release.
> There are 91 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 09 Nov 2023 20:24:28 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.200-rc2.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.10.y
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

