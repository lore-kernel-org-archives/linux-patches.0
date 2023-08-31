Received: from mail-qk1-f177.google.com (mail-qk1-f177.google.com [209.85.222.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2FDD25399
	for <patches@lists.linux.dev>; Thu, 31 Aug 2023 21:27:00 +0000 (UTC)
Received: by mail-qk1-f177.google.com with SMTP id af79cd13be357-76da1331db9so111157685a.0
        for <patches@lists.linux.dev>; Thu, 31 Aug 2023 14:27:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1693517220; x=1694122020; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=OKupqeRqjjG5+ZAE8jQOr7HoDwD4mmWqhqzhxE9SrKI=;
        b=HPS/uDAvtTyl5vJKI7kZ5q0F99LmKHXiHItIUBbAFu162CwZNPgqc3MB/bxVhMpXaV
         /Cs1GYAoyXWU4zMXSsEdio9QTPJ1gS71SQjmhUrt/Kt9d3OGY0nNIncGli5z4nRgQOjD
         yStXtT9Q4veeEtaLJpIL3lRGs9tolN1rIs3CPDwu6CXZ9ZQauXoXLmIgbqZTqd66NQfh
         dRm9pFjMvT73yl+fBcXZroEcWejKehqX8BrdpJxbeIhHFyL6rnnTV3/8/2qkzflFE7lC
         ozsMyUbk4jCXyXNByzyxY1mKfvO/h8hgA8XLBUWpzUR7kRkpSSq3t6UtDXzMH28Mc8bT
         i+TQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1693517220; x=1694122020;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=OKupqeRqjjG5+ZAE8jQOr7HoDwD4mmWqhqzhxE9SrKI=;
        b=LmJSxVG8FcERhns3nhr6GXyxfiJ09orRD850iuGcUqJz3fslLpjpQtyVESsFBI50Mi
         9T1W0utHPZwW8wL8V2rONCAfJ2RtdCWMHcFxBHhkcL9Ebvdrj3qkaibFuv2H+WTahcnO
         adkyyv5a6MSxChUPF8RWMLGwrpo/OYod1/wXi6vXA/aMCSzHKT70OrOcpahHLsH0nVub
         d3cypOD+85MvshTQRvNIqnKfIoudWXGfDIUre/SQ4898S40hUYlFZVrQA6fiLh7wVZTL
         vsVYr1FdSKSPN8FdGMLX5WYww2LrDzowTx4/Ul+dbgTlhYNwOEjhjFX57kwjaKAvF//+
         DBbg==
X-Gm-Message-State: AOJu0Yx501dKJjbKzhZfsV+oEQI4FisvEGukLgshBnrrDBA/kN87koV5
	e9acX5QNSqdNlVPgga1zkxY=
X-Google-Smtp-Source: AGHT+IH8hKJ4Mmc2oI9vlaszFEwDZpJ7dW2OgV1Y3HBF44zcBYMVO9UjJQvmLZcPpZCnvNsz+Ja66w==
X-Received: by 2002:a0c:f4c7:0:b0:647:3346:1289 with SMTP id o7-20020a0cf4c7000000b0064733461289mr1296596qvm.11.1693517219718;
        Thu, 31 Aug 2023 14:26:59 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id i29-20020a0cab5d000000b0064713c8fab7sm923855qvb.59.2023.08.31.14.26.44
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 31 Aug 2023 14:26:58 -0700 (PDT)
Message-ID: <fc349a26-a56b-f3ed-65a3-4c18f88b650f@gmail.com>
Date: Thu, 31 Aug 2023 14:26:38 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.13.0
Subject: Re: [PATCH 6.4 0/9] 6.4.14-rc1 review
Content-Language: en-US
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
 conor@kernel.org
References: <20230831111127.667900990@linuxfoundation.org>
From: Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20230831111127.667900990@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 8/31/23 04:11, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.4.14 release.
> There are 9 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 02 Sep 2023 11:11:18 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.4.14-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.4.y
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

