Received: from mail-oi1-f182.google.com (mail-oi1-f182.google.com [209.85.167.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 13C8E1427E
	for <patches@lists.linux.dev>; Mon, 19 Jun 2023 19:43:05 +0000 (UTC)
Received: by mail-oi1-f182.google.com with SMTP id 5614622812f47-39ee19cfb77so752126b6e.0
        for <patches@lists.linux.dev>; Mon, 19 Jun 2023 12:43:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1687203785; x=1689795785;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :cc:to:subject:from:user-agent:mime-version:date:message-id:from:to
         :cc:subject:date:message-id:reply-to;
        bh=GMRLY2j+IAS7ISAiw0R05ZGvFawTOjh4yP2LDnudezY=;
        b=c4940YOE6lC4WLcpyNG1SzkRuwK56KRqkCHnfj73sNBcqvvOCBP4HtZvyzR5iI+dT6
         JUNcqUKno3vGxTXWyCKlk7qoQoMIVXv1eQRqFkCuxBeyvJsdagBBnqZdvcI2w0KWg21G
         15R/crgx+370LKofABEqLtjp7ln7QqkDFqxx3Rql4WmATHLaRnajEMtKHVpDI2Ls9Fch
         pYS3nmKeSDINZPfxXlkMRMBnMmA/8+aZQZ237yfiMucPJiVeXcRlBPoCCODa2rH0Ux9z
         eA7WHOxhRiH5G2XfR945tQGBd4uNhPHrgUt3ge/hkeuz9T9rwsfjKp8xLSzgQsd6B91z
         Ny0w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1687203785; x=1689795785;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :cc:to:subject:from:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=GMRLY2j+IAS7ISAiw0R05ZGvFawTOjh4yP2LDnudezY=;
        b=TUsHlC4RXNLFAQdx/sGN5a2jwPtfHGFURq2flxenaHgQNfy6UOH7FotQ5ekHWzxT5b
         1LFpzfZw3UCMBmjhRt67Ak+nPCGbirW9XW2LeBVY4tmAAKG/yCi4bgIfocj6fdZ0mQKE
         gWHUpb8k0AmD9saRJN7hsnDFZYsMSdX+428z2q+zryva1MeHUNn7gp0in32WL3T42n+W
         t+yX3Av7rGgBxKQG7toJJO1KSNXKJnJhKFwUpQF8oS7l9Pxe0+Y3kytizjySAfOyNEoR
         A07XuCbT2r73UvE1GUSxUhC2n9pTc8oALY2+RM2GioZKI2EcR8uJPet3jUs8EvpOIio0
         lT2A==
X-Gm-Message-State: AC+VfDwWiAoAGQ6g6EWy5AhbQZ62FXV6406MQ6MS0IYxW9Q0XZaF8kJr
	Gq8qCGOtHjAvC8BWDO8w4HE=
X-Google-Smtp-Source: ACHHUZ5LEzTKiHDX05E7U2SS9tQva5v1sd1qAMHrZlJEr1RiYXXQiSMcIYUYIhl4ZdGn5Mz/lJt/RQ==
X-Received: by 2002:a05:6808:6243:b0:394:45ad:3ea7 with SMTP id dt3-20020a056808624300b0039445ad3ea7mr11202863oib.5.1687203784829;
        Mon, 19 Jun 2023 12:43:04 -0700 (PDT)
Received: from [10.230.29.214] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id j4-20020a17090a694400b0025c1fbc9984sm5937690pjm.19.2023.06.19.12.43.00
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 19 Jun 2023 12:43:04 -0700 (PDT)
Message-ID: <deace106-94b8-8cc0-efae-2c77aa97dd0e@gmail.com>
Date: Mon, 19 Jun 2023 20:42:58 +0100
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.12.0
From: Florian Fainelli <f.fainelli@gmail.com>
Subject: Re: [PATCH 6.3 000/187] 6.3.9-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de
References: <20230619102157.579823843@linuxfoundation.org>
Content-Language: en-US
In-Reply-To: <20230619102157.579823843@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 6/19/2023 11:26 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.3.9 release.
> There are 187 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 21 Jun 2023 10:21:12 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.3.9-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.3.y
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

