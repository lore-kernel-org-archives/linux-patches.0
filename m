Received: from mail-qv1-f50.google.com (mail-qv1-f50.google.com [209.85.219.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1DDAC6FA6
	for <patches@lists.linux.dev>; Mon, 20 Mar 2023 20:00:36 +0000 (UTC)
Received: by mail-qv1-f50.google.com with SMTP id cu4so8383822qvb.3
        for <patches@lists.linux.dev>; Mon, 20 Mar 2023 13:00:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1679342436;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Ncz9Qy4DSOSCtDPPMkaguFx8M2v82pbbx+KqBVH+Vb0=;
        b=gAPOvuv09IB4axFEdbyMK3ydCNXCZXJtfNDpwG6dRc0HQr2dSuf305SgVyvjMnYc1R
         YbaB8kQebWgxMOjcDa1aHm5yngb4QshND5iFZTzhsx9I3vxym2vxn3x9P75UQ7gTMlya
         4y6ewvkqMy/pPKtgOhGEEV1S+BeNyEsle27jf76KrZyDV+4tfoX3jEIWtAP0LJHLbezh
         jOnAArgxUw9M76LDMDHPuXtb12b8xK6jxb9lPxP6z9iZfTUyk+hUr9rM4mHwBGn1oQU5
         KGN8BqEcoeFvdZR0rFG2TzTbvou6SPzgu3lkbb4NiXcF7z5s6TpUpP5tRAb82T6xhHae
         t4lw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679342436;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Ncz9Qy4DSOSCtDPPMkaguFx8M2v82pbbx+KqBVH+Vb0=;
        b=ccwyB7Sdodym7XP0KRTb2p1bY0YxdCd8xAvgBZ9XcYaDVxYwnIa7CtrnFpneJtphzm
         915xKRS9fXkKUhVQwGNllJhF8fhAMu1OJa5d7SAKech0inMy8dZd5+UdJ/Oila7hCpuq
         Xpxs65+1mxBfRolJi0dyj8+BF+UmixqIHNMsEsJXzcWlyntgduGpEl89je+dzjMzt0dh
         fevWk/zuheGbipk8nSRbz1AgajA4ZmTR2bgWmzX7bWYJBW19Cif3qCPSOD4qPfrYia3D
         6lPcqVwHyhf0JSAxpVast8BqsT8wV8LCP2AB5QYIVB+QYnGmOLI7C+UK1MgLt6OtNofc
         a6CQ==
X-Gm-Message-State: AO0yUKV4O6hgVJeXf5ht8VYPJpHLSyTd+1GM/571GUKCMTIy0UtOaUsv
	7hFZgKutMiQyhulvg82OiHg=
X-Google-Smtp-Source: AK7set8Q76Ke19mD1eHBAf6ZxetIGPmwhUCjXNxaGno2+4Ts2TcGIxYnSIxXmeU5A5fFxWpUoZSzVA==
X-Received: by 2002:ad4:5bce:0:b0:5ab:c25f:9791 with SMTP id t14-20020ad45bce000000b005abc25f9791mr225772qvt.29.1679342435939;
        Mon, 20 Mar 2023 13:00:35 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id bk12-20020a05620a1a0c00b0074357a6529asm7960294qkb.105.2023.03.20.13.00.29
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 20 Mar 2023 13:00:35 -0700 (PDT)
Message-ID: <f6679e32-3c77-dcfd-cf34-2b41a845d71c@gmail.com>
Date: Mon, 20 Mar 2023 13:00:27 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.1
Subject: Re: [PATCH 5.15 000/115] 5.15.104-rc1 review
Content-Language: en-US
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de
References: <20230320145449.336983711@linuxfoundation.org>
From: Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20230320145449.336983711@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 3/20/23 07:53, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.104 release.
> There are 115 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 22 Mar 2023 14:54:26 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.104-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.15.y
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

