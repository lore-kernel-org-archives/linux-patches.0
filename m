Received: from mail-qv1-f49.google.com (mail-qv1-f49.google.com [209.85.219.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 64736C977
	for <patches@lists.linux.dev>; Wed, 19 Apr 2023 19:33:25 +0000 (UTC)
Received: by mail-qv1-f49.google.com with SMTP id l17so710004qvq.10
        for <patches@lists.linux.dev>; Wed, 19 Apr 2023 12:33:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1681932804; x=1684524804;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=gee+tI2L/+UGQKLH0aENupxaIaXEgJAfZLNOf4TxY3s=;
        b=BBg3z84fA7i3BHu2GgK51FirlDdxNmYXgKbjMPalfpzsMEQKHcY2kXoc+JlI+SN9Ii
         auvz4ADJ4hUTRg0djO07XLWhKI709+Dy97y0OgsL5I0u4EyZhzvKIWo/E9WZsk2My7nk
         MalcdCnOP2KwJ5RV+xEj2DXGAI8KEvW3t1H+a/0mVDozGWP1mHKgAwwP2EsvAVglQTLv
         1YwkmbFGgr3DNN/YpjtZdAWpVLngfJNVVEFH4mybdT5JVQMcxQ4nUFtI4rjvMUa/a86I
         JvEEzYXKrB+UYFY4NOhla5WfLoxp5ARDMY3k6X6NzQ8CreQ5MOKEgFIoRqa6zZapwqdB
         hatQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681932804; x=1684524804;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=gee+tI2L/+UGQKLH0aENupxaIaXEgJAfZLNOf4TxY3s=;
        b=PvszsC/YbVK64V1SiUep0C5Vg3p1BYBrzLMMlnrKeH5raXX/hIyRWi9BlInGgS4wJj
         FmS4FEfuCQbEiPJZ69IIqOF3qGpzQpl5+0PCYRtCRDUHL1Dm32DOdaXXpOvsC9N08RKn
         CxD2oOcVcIX+EXVtMm9KqVu0+qm7AZgK4KiYyDtxlm5BV5gPAQ/KPMAzO16a3wmzJtk/
         AvkdzbQKBvmIhJc7MDfORBC8x1u8Wzz9mmArkfymuIX+jq5ppQOZQZdgcw/0d0fDZwsv
         s4cVTiYZERujQzYkedSgoIF+PevIZuXGBCPmSbpgjQfSN8RMRdN/y01SkmpAhTNIlCbE
         0xvw==
X-Gm-Message-State: AAQBX9cZ2Nm1+C+/ot0v82Q0MD45qU1+wpxRtvMm3BlgquZp9uhqRWf+
	0i9S7jLYUvFz+doAayuwkqs=
X-Google-Smtp-Source: AKy350YTdOdaFpH37zQer4ulNHJtbld6rSKE1wU4qB0R1BhXBgqGSavZeBdWtGttPMNihIVt/bIN5w==
X-Received: by 2002:ad4:5cc3:0:b0:5ef:6cae:c43e with SMTP id iu3-20020ad45cc3000000b005ef6caec43emr25211650qvb.42.1681932804140;
        Wed, 19 Apr 2023 12:33:24 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id bp35-20020a05620a45a300b0074e1ee30478sm174064qkb.37.2023.04.19.12.33.19
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 19 Apr 2023 12:33:23 -0700 (PDT)
Message-ID: <4223275c-deb1-2902-0b59-e11bf7637410@gmail.com>
Date: Wed, 19 Apr 2023 12:33:17 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Subject: Re: [PATCH 6.2 000/135] 6.2.12-rc3 review
Content-Language: en-US
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de
References: <20230419132054.228391649@linuxfoundation.org>
From: Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20230419132054.228391649@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 4/19/23 06:22, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.2.12 release.
> There are 135 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 21 Apr 2023 13:20:25 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.2.12-rc3.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.2.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

On ARCH_BRCMSTB using 32-bit and 64-bit ARM kernels, build tested on 
BMIPS_GENERIC:

Tested-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian

