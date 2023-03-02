Received: from mail-io1-f50.google.com (mail-io1-f50.google.com [209.85.166.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4029EEA1
	for <patches@lists.linux.dev>; Thu,  2 Mar 2023 01:46:42 +0000 (UTC)
Received: by mail-io1-f50.google.com with SMTP id t129so6168696iof.12
        for <patches@lists.linux.dev>; Wed, 01 Mar 2023 17:46:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google; t=1677721601;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=TeupPCDbd6R78m/pmA6v+CX/TX+yWDdkPxQs8KMcp44=;
        b=RbktTVUJDJ9SkcsicRD/l1otQyLVQk8lH7DLLk8gy7J/Vm3EVSBtzeui2mMNd+APX8
         X8yCDhTOcTjIQMnU6OyvWmL9eAudMHTSZenQfsEEC3kCsZmBzipQguS4S72mx+ZsFBZT
         hu5WaAdqQwfqu7nNB5nyrsBb5QUMWH5IZvRCU=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1677721601;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=TeupPCDbd6R78m/pmA6v+CX/TX+yWDdkPxQs8KMcp44=;
        b=SiaFNn18Fp+HIS98HEiqMi2IdJkwj7eQHsRgXi4SO8sO5X3wNxrR4tHUOITjE0b/kq
         9qaEvou5CBvigt/Ftcw/YneBJid4UZZVQUiytyUDKpiE2pcjgURnCoycBULDVSxB5YsT
         10f4V+5eFl9DF+U/aqf4gdtiYjdR3iDUtSCJSfDyYFXS2hnGI5IpwkXU0XQekgpkrhYj
         A+nOqX05DcR8trfKfalE8z0Ms2VCaWk9mih1l/K19DRtv74XMh3pCrsTmitPetahIMKD
         qjmPhSt7vcJdxNFwQ04WV/AQ+KYf2s0mthIvAPGID0wMYAnKoNdKSf/f/BGbT916fQKq
         Kc8g==
X-Gm-Message-State: AO0yUKWhgdRJxKYZ0z4J55NiMBVvKyiOgwmUGsQsZXZEDmsBGil//jcj
	Oxo4jeM67RLP8XsJFkGV3DCfbA==
X-Google-Smtp-Source: AK7set/sJBwjh4I50VLZ8hqpBfE3S+l76mr1EcvexSXth+Uuexl/i3djxhktrptbBKzJil/EwQGAag==
X-Received: by 2002:a5e:a704:0:b0:74c:de17:fa3 with SMTP id b4-20020a5ea704000000b0074cde170fa3mr5038493iod.0.1677721601256;
        Wed, 01 Mar 2023 17:46:41 -0800 (PST)
Received: from [192.168.1.128] ([38.15.45.1])
        by smtp.gmail.com with ESMTPSA id u3-20020a6be403000000b0073d7d30fb3dsm4288376iog.54.2023.03.01.17.46.40
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 01 Mar 2023 17:46:40 -0800 (PST)
Message-ID: <71029269-20f9-2e67-ae54-3d5ef283a194@linuxfoundation.org>
Date: Wed, 1 Mar 2023 18:46:39 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.1
Subject: Re: [PATCH 5.15 00/22] 5.15.97-rc1 review
Content-Language: en-US
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, Shuah Khan <skhan@linuxfoundation.org>
References: <20230301180652.658125575@linuxfoundation.org>
From: Shuah Khan <skhan@linuxfoundation.org>
In-Reply-To: <20230301180652.658125575@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 3/1/23 11:08, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.97 release.
> There are 22 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 03 Mar 2023 18:06:43 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.97-rc1.gz
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
