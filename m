Received: from mail-pl1-f171.google.com (mail-pl1-f171.google.com [209.85.214.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 09EB61DDFE
	for <patches@lists.linux.dev>; Thu, 10 Aug 2023 10:25:34 +0000 (UTC)
Received: by mail-pl1-f171.google.com with SMTP id d9443c01a7336-1bbc87ded50so5432525ad.1
        for <patches@lists.linux.dev>; Thu, 10 Aug 2023 03:25:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1691663134; x=1692267934;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :sender:from:to:cc:subject:date:message-id:reply-to;
        bh=Spf52dVKy0lT8vvfU1TgufHFM9V4XApAOmPWeXdI0zY=;
        b=fFFB0rdFgZ39f2Zx0GXGpN+1NXfR/iHWpgEnbOTISkpkJFGoto8EQmkSqcyg9Klj22
         c3adwbWeS2WaGQY3nvhNEVlT1QFsP0R+xgfXgdGOSwHAMsCDsM59NMfSxL88luXZipGN
         AbcN01FxVSpTLNErg97zNxHSeT5IeJOFJZZjGbnUqoCozUNtwZfrowBAAOU/VRaY1qNp
         syyYaIWzdfdYtx8ogWgqOS6SuBEPHiCe4oSzYF4B5QUnNyvawbI1FaYBVN1EdNwPE3lG
         7/w6pWZpzAxc/I42ORbZLUSIsxdju2AEvMbbSpiqTcWnq/hxzVLVOavMRv8GHE4Gy7Hd
         a8MA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1691663134; x=1692267934;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :sender:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Spf52dVKy0lT8vvfU1TgufHFM9V4XApAOmPWeXdI0zY=;
        b=YzSOOAc3J7mpNo1PVwrYsBul4E9QQcHbbHQUPv2bv1qyRHcOf0bAfouBWCLQfjunk4
         nfeO569MBYfcHKUD9auiYBxJrCmMf2kuD5x1uJsujgceyIFCql2ocu/ywwzr3OtEYtnn
         Ph16LL/5aPZXySFuwSqeNKOOO0WT8BQIpNBr5ZIHVpT6BTAW15w9tbLFv7DD5ara8Bqc
         ZSLv25lSxG/kVJ5ZmEHbBOv0IDGR3TWOaFzsf8ts09ctmInmm8pRt3yAUoR5q3cUu2wY
         5pMCnxA3ynK426a8c3sfotcOilaPJqYntGSJjfbghaLG4ty/WoYzR2ZV/fUHiVHgwfXp
         PmCQ==
X-Gm-Message-State: AOJu0YyAqitL0B1+dgKErMnRh4/yww1+gNM0vlN361z7PaQa9j3WEDDt
	5LdJZJlNxADpNmLdfXFNeuk=
X-Google-Smtp-Source: AGHT+IFQIdLON0+nJgNacBCPfCvvVgaMkTLhUoah8NUjx9nn51eQA3rDYuy1W35F0i/Yh7k496Y7yQ==
X-Received: by 2002:a17:902:868e:b0:1bb:3a7:6af7 with SMTP id g14-20020a170902868e00b001bb03a76af7mr1648591plo.23.1691663134269;
        Thu, 10 Aug 2023 03:25:34 -0700 (PDT)
Received: from ?IPV6:2600:1700:e321:62f0:329c:23ff:fee3:9d7c? ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id q9-20020a170902788900b001bc6536051bsm1336081pll.184.2023.08.10.03.25.32
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 10 Aug 2023 03:25:33 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Message-ID: <3773188c-cb57-6b8c-1c7f-ce3250e203d1@roeck-us.net>
Date: Thu, 10 Aug 2023 03:25:32 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.13.0
Subject: Re: [PATCH 5.15 00/92] 5.15.126-rc1 review
Content-Language: en-US
To: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>,
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org, shuah@kernel.org,
 patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
 jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
 srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org,
 Vegard Nossum <vegard.nossum@oracle.com>
References: <20230809103633.485906560@linuxfoundation.org>
 <3474ec1e-eb15-b2a0-003c-327d6fd17708@oracle.com>
From: Guenter Roeck <linux@roeck-us.net>
In-Reply-To: <3474ec1e-eb15-b2a0-003c-327d6fd17708@oracle.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 8/10/23 03:16, Harshit Mogalapalli wrote:
> Hi Greg,
> 
> On 09/08/23 4:10 pm, Greg Kroah-Hartman wrote:
>> This is the start of the stable review cycle for the 5.15.126 release.
>> There are 92 patches in this series, all will be posted as a response
>> to this one.  If anyone has any issues with these being applied, please
>> let me know.
>>
>> Responses should be made by Fri, 11 Aug 2023 10:36:10 +0000.
>> Anything received after that time might be too late.
>>
> No problems seen on x86_64 and aarch64.
> 

fwiw, aarch64:allmodconfig doesn't compile.

Guenter

> Tested-by: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
> 
> Thanks,
> Harshit
> 
>> The whole patch series can be found in one patch at:
>>     https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.126-rc1.gz
>> or in the git tree and branch at:
>>     git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.15.y
>> and the diffstat can be found below.
>>
>> thanks,
>>
>> greg k-h
>>

