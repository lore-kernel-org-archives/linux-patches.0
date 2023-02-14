Received: from mail-oi1-f178.google.com (mail-oi1-f178.google.com [209.85.167.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1486BC5C2
	for <patches@lists.linux.dev>; Tue, 14 Feb 2023 17:59:51 +0000 (UTC)
Received: by mail-oi1-f178.google.com with SMTP id c15so13657442oic.8
        for <patches@lists.linux.dev>; Tue, 14 Feb 2023 09:59:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:references:cc:to:from
         :content-language:subject:user-agent:mime-version:date:message-id
         :sender:from:to:cc:subject:date:message-id:reply-to;
        bh=s8UzaNfEND0jC/yceoLp3a3whXWdJFqcFdLGizTIhz8=;
        b=qshxiKxdLxeJ4PeuqXQwrO4EnYS1plQsrkAk8SmkJWBw7LoV3iEQ5oOGGppWMzhD4+
         hUw4KAMZuo+I8oBH46g31MescWFDI5Q3PEhN8FZoLEEptiQLlXCEe4AD3uyVBt1aMmTo
         W6iOboHuKRxGbL6OV1nwRA1eNbiFmyj1rLPiLzBWLJSYDpxmzrCaDts0NC45VhIbTmlC
         etGgvIFTc2Wjg2J2Pym04AGJTTNJFDHi1ZFK2zeb1l9kP4XZ/clUV1ppiw3NnnFDnuGR
         ee+Ef2o9NaHsZRDy6CAwzQaewZKvBmTIc8yQtXsntl/sOX77KkQ5+byBb7btA4v88LAB
         GNRw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:references:cc:to:from
         :content-language:subject:user-agent:mime-version:date:message-id
         :sender:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=s8UzaNfEND0jC/yceoLp3a3whXWdJFqcFdLGizTIhz8=;
        b=dlTjqtKET6TBzPUW5PbE8ca8+mvbUqpuLBpONXyBqlt7y0TaEZaeRP5oFhSJNR677c
         02qNQ6k3Oz32KHMsuYi7mPjZUAFbQTxBKyaYixfJA6RExm72wMEKYSTmkxXajpBjuYli
         vpPV07a1pYmWsvACtHM/zAaHmK2/DRjLP0iL2oOWINzTFVmR4pXw5SQcPoK3kWzwtDak
         TfP8Xhp351601fYlhpEBXf0cSB7q6l8R8A0XmpAKZAu9pZoEMfFldB6VcruK/afuYh3S
         1PnT5aZbv+/oEBEZmYvTP5xDvDAuJ4y+kXPsyWfJDPv6QvX3g4H9Crb5rX3Dh9MCtFeK
         yI5g==
X-Gm-Message-State: AO0yUKUsfJQr3j65zxh72CJ06vwEcrvF6ms2GLrRfiYlxf8FCcXk6P1P
	GAOeb4q2GIw5DISAxrD1Hp8=
X-Google-Smtp-Source: AK7set+LDbBvPDey+JSMgLvJmB8fr2skkFW5Kqo8WzDl5uM3H7YthXP1/bXbT2bsHmtgU+Mba/Egrg==
X-Received: by 2002:a05:6808:5c8:b0:360:d307:c23c with SMTP id d8-20020a05680805c800b00360d307c23cmr199708oij.25.1676397591064;
        Tue, 14 Feb 2023 09:59:51 -0800 (PST)
Received: from ?IPV6:2600:1700:e321:62f0:329c:23ff:fee3:9d7c? ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id g1-20020a0568080dc100b0037d8bffbe76sm3032484oic.57.2023.02.14.09.59.49
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 14 Feb 2023 09:59:50 -0800 (PST)
Sender: Guenter Roeck <groeck7@gmail.com>
Message-ID: <710c0c7b-0920-8ea5-98e9-d3f07ab82f56@roeck-us.net>
Date: Tue, 14 Feb 2023 09:59:48 -0800
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.2
Subject: Re: [PATCH 5.10 000/139] 5.10.168-rc1 review
Content-Language: en-US
From: Guenter Roeck <linux@roeck-us.net>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org, shuah@kernel.org,
 patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
 jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
 srw@sladewatkins.net, rwarsow@gmx.de
References: <20230213144745.696901179@linuxfoundation.org>
 <7106f107-061d-231d-fb09-bf4832e2a5a0@roeck-us.net>
In-Reply-To: <7106f107-061d-231d-fb09-bf4832e2a5a0@roeck-us.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 2/14/23 09:04, Guenter Roeck wrote:
> On 2/13/23 06:49, Greg Kroah-Hartman wrote:
>> This is the start of the stable review cycle for the 5.10.168 release.
>> There are 139 patches in this series, all will be posted as a response
>> to this one.  If anyone has any issues with these being applied, please
>> let me know.
>>
>> Responses should be made by Wed, 15 Feb 2023 14:46:51 +0000.
>> Anything received after that time might be too late.
>>
> 
> We don't know the reason/cause yet, but Chromebooks with arm64 CPU
> no longer boot with this merge applied to chromeos-5.10. We'll revert
> the nvmem patches and try again. If that doesn't help we'll need
> to bisect which will take some time.
> 

This is also caused by the nvmem problem.

Guenter

