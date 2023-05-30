Received: from mail-qv1-f54.google.com (mail-qv1-f54.google.com [209.85.219.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7726E19924
	for <patches@lists.linux.dev>; Tue, 30 May 2023 18:53:02 +0000 (UTC)
Received: by mail-qv1-f54.google.com with SMTP id 6a1803df08f44-61cd6191a62so25487616d6.3
        for <patches@lists.linux.dev>; Tue, 30 May 2023 11:53:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1685472781; x=1688064781;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=RL9pdM2o2z5T2G6D8vKneXdh0c/zBkvXlO/Xd4J2Dvo=;
        b=DGgqnQd/dBiyyqsSxI+b2XTa+20cfxjVDJaDl2Epu6HDMH7RF4AeYJTD9iPfaUwL3w
         iAY5W7YZ9rivRl5OuGSRHcY6/yINZLmUEFlzhu9K02PMfLF67tj/gAOWMqMHqqgZXkDy
         /J81plLJ7DELb92OJxLfTMrCHnZ8Wg62yKwIMU4YOfITqdjChrgxsgHHMHjVDgPWbIfE
         x2inywZXeRdPh06LntO61d5faRcUgT3uTRCfgMW8avu7wrOiiYgNBQPGgJeA1qECtlKi
         b3D20uG/j0drXlLl1wAE9kGB7Z8ndbXCNpzpfvQLBpmwxN9EpHdxj9ldWFvjHaunRK9u
         8ybQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685472781; x=1688064781;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=RL9pdM2o2z5T2G6D8vKneXdh0c/zBkvXlO/Xd4J2Dvo=;
        b=CeGd1hkBxkT82VFmBd7cRFBSYRWawUf47aqhXA1/SkosKxGJVdoDoWeyjo1LzOXh3o
         YLz5U0MJb7LJDhCsigpvHrwloyZt+FAXkRy/+rqtQukQTz96Oyby6zGEDQnXOFOs703A
         Fwg22vn8ErIvccYCJgodHvSUpJX/XL9Mt6mNO6MQPfxfkI+1Ov7FLd+5uwTdbyZyYpMY
         wXLmX2ikMerqKGRNMibv8Sj+xol7yGdZ8eaaFU8V/EVFhIZysGEeXKcsJN3VKZGn0PRe
         nSiMcHFfD0s/asjORudSiLDV/9TiYmPeLec7KjJFCByibbMYX/xmCWp+MPSSooMRqbgl
         19cQ==
X-Gm-Message-State: AC+VfDylhrZDHx+i30FTjcHzT6yOHk6IU1E8UJ1TuZ5gvt7wW5wvygY3
	0bXr+m8tqKhTiaXeF2nJ/9QrEIHKLnRSVg==
X-Google-Smtp-Source: ACHHUZ6s76j5kRhXWMwfpodXJ9vyN0EYG6XWzpPvY+UVc5uwXrLtoAlo4bG9Ra7fznbwLOtrZ3SLvw==
X-Received: by 2002:a05:6214:c4c:b0:5e3:d150:3163 with SMTP id r12-20020a0562140c4c00b005e3d1503163mr3754919qvj.20.1685472781325;
        Tue, 30 May 2023 11:53:01 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id f16-20020a05621400d000b006262d158ab9sm1343897qvs.124.2023.05.30.11.52.54
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 30 May 2023 11:53:00 -0700 (PDT)
Message-ID: <904bcc86-71a0-021f-55cd-bbef94b13801@gmail.com>
Date: Tue, 30 May 2023 11:52:48 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.11.0
Subject: Re: [PATCH 5.15 00/69] 5.15.114-rc1 review
Content-Language: en-US
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de
References: <20230528190828.358612414@linuxfoundation.org>
From: Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20230528190828.358612414@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 5/28/23 12:11, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.114 release.
> There are 69 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Tue, 30 May 2023 19:08:13 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.114-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.15.y
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

