Received: from mail-pl1-f169.google.com (mail-pl1-f169.google.com [209.85.214.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F22F746A
	for <patches@lists.linux.dev>; Mon, 30 Jan 2023 19:09:40 +0000 (UTC)
Received: by mail-pl1-f169.google.com with SMTP id m13so788443plx.13
        for <patches@lists.linux.dev>; Mon, 30 Jan 2023 11:09:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=ort/gBdj1vdteBB8Y2X65MVVB8dvR1Pgw/FQaZkcyXI=;
        b=aVZNKi70t5hY8u5qYrUNfmWf31V9R0KhD3SEynrGNjMtgovQGSXaS40tqH+SBH1d7H
         q4OELhukPtKeRDvYEmYNFSWRpUuh5ModCuENHIeKb2lDkrQpaI6OHo6x/a/PqjRl21wt
         GPRlp7QuUZyEukuHOGAHxf+e17YiEDMv9+HWkDAy07zHf5caE0tTjEqtlxhkuqRkvAnY
         wgYX2yTGEPpF92q30TDfcX29cfjxPLtlVJ8HR5fuhUYpjvjMZe/UdMRMPZQcgs53F+lx
         XyY0Cyc1gB3BR2+US0vknICJgGesKg/o/jt7VQABGfLfS4itY/cEV5H4DYXnbjceAMp6
         nsTw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ort/gBdj1vdteBB8Y2X65MVVB8dvR1Pgw/FQaZkcyXI=;
        b=Wu1hEGtp/JyhXRkyyoGbgilKmoJTP4s9gfGHtUqACJM53HdPXaOyOM9WBamdAZr+16
         LIQzPZ6H1Zst8yLTYPMVoJDwKUTb4lBPr9ZILxu4GSZb3PEDXtLxlmxlmmgPSL2QuS9k
         a+OA0FW/xrjZ+POp1fhYort17iF2OW+oPw1U6beFaxTHQRmpHBdc/EEGUJ+Y+IyUTb0J
         NHx9krYbwQfuN/kLiL/TNgpViim9V4453cp6OG+XE8ae4jiehHhU+VxJVQp7X9/5UyZ+
         g/pO6O62sjm5oAHBsqqL20SYAp5eFgd0NUs8wExMymoAe67aRyHZvJcKbc0xHSn2m6AB
         qrfQ==
X-Gm-Message-State: AO0yUKUD5jUkdXjpS56KOyfjLEv2QDRsyEq04+ETQ4+P3uO0E8fosZH3
	/McCKf5Ci5aCWij499NSj0s=
X-Google-Smtp-Source: AK7set+hyHexHpct2JSs9hZ/I1lSdj5nzs2zz7B3Fh9+LxbLsXziB8PpYJA1JYoeBgK1Zpo8hkxikA==
X-Received: by 2002:a17:90b:1e4e:b0:22b:f834:3fac with SMTP id pi14-20020a17090b1e4e00b0022bf8343facmr24623937pjb.11.1675105779842;
        Mon, 30 Jan 2023 11:09:39 -0800 (PST)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id o7-20020a17090ad24700b00229b17bb1e8sm7446192pjw.34.2023.01.30.11.09.37
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 30 Jan 2023 11:09:39 -0800 (PST)
Message-ID: <2e2b117c-bdcd-2714-2116-8565e10795c9@gmail.com>
Date: Mon, 30 Jan 2023 11:09:37 -0800
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.2
Subject: Re: [PATCH 5.15 000/204] 5.15.91-rc1 review
Content-Language: en-US
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de
References: <20230130134316.327556078@linuxfoundation.org>
From: Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20230130134316.327556078@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 1/30/23 05:49, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.91 release.
> There are 204 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 01 Feb 2023 13:42:39 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.91-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.15.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

On ARCH_BRCMSTB using 32-bit and 64-bit, build tested on BMIPS_GENERIC:

Tested-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian

