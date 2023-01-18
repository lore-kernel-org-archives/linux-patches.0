Received: from mail-pj1-f51.google.com (mail-pj1-f51.google.com [209.85.216.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C4EC8C06
	for <patches@lists.linux.dev>; Wed, 18 Jan 2023 22:04:14 +0000 (UTC)
Received: by mail-pj1-f51.google.com with SMTP id bj3so521748pjb.0
        for <patches@lists.linux.dev>; Wed, 18 Jan 2023 14:04:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :cc:to:subject:from:user-agent:mime-version:date:message-id:from:to
         :cc:subject:date:message-id:reply-to;
        bh=u7Vhz02/OiTcxeOxGsxJsAIoe9iATxGL5yF7599ooUk=;
        b=hoPJ94JXYXk76hU9MfRNs+7boN9aFW0tBh8fdqc+Nob3S5GOrjhWYLQp/zotUG9ELE
         yKUiJqEW755ZN3Szrk2sdNEChjX+8DfcGyXM5knao7i+ZYRKGkf57peosXa4OGRmt4Ug
         0+KKyiUB2Jlfoqlgp2s9mG2UI0gawSPeMo0QKzaUUyllnpIUwVkDZxut0VbRNB0pRMzr
         tm71uMghTOsc/S0hr5PWNRJfr41HsoryZkq/FGRY5bpC+LvNw6bzzBgwErnMeWH7evie
         6X8xIKLFo4rwbz8BJQtdVV6lsBCeiq9XDXezSAeq9r4YL4aRVll3EJcTBXJ5XDuysuja
         8T2Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :cc:to:subject:from:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=u7Vhz02/OiTcxeOxGsxJsAIoe9iATxGL5yF7599ooUk=;
        b=KvuAeWX/6eqHX+t4O0rDTrhX1tmPSa5jwD9fG2xvc3KFVvhblOCPNwORKJc0sw+YFi
         cwKyzMUFFMXjMBa/xWnugNR8ktClLGsSejHO6Nuwww1VG1jFTyZyvQjDAoEng0pKfHy+
         tBjPv1alXUfdGj1ygbstDZkpHJAHDFaDJPJ01S+3oSH5LG9mb+C9BmEEwqU5U8Z1GGfa
         LiWX6vFLGSIf6hGHNPVtKap03q66RgQZUH8XGRZnoVN3BAsMYjCD4BY9ruhcpSIikxT4
         GEU6askX7Srde3X5eel0g3jnarS5+sQlbI2zIqrjIa1jTXRccdx/fOs/RhDaTXXXO9bg
         ydyg==
X-Gm-Message-State: AFqh2kqJQNQ/9CCW2iYiGlI3soOkHnLujLTHMN4Xd5qkK7bpeWWJ+HHF
	GmaaWrRd4/0h7P0KMrahvpM=
X-Google-Smtp-Source: AMrXdXuRu+al6gKD7Fwz8pu7Gtw+rxuIQEa/EUi6RFO98P1EdnAh+8aOlY66AsrugF1PBF7dm+S3zw==
X-Received: by 2002:a17:902:6ac3:b0:194:c25a:d824 with SMTP id i3-20020a1709026ac300b00194c25ad824mr1864045plt.26.1674079453629;
        Wed, 18 Jan 2023 14:04:13 -0800 (PST)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id z6-20020a1709027e8600b0019445b8ef29sm15990755pla.61.2023.01.18.14.04.03
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 18 Jan 2023 14:04:12 -0800 (PST)
Message-ID: <3def289a-74a6-0b90-c9e0-bcc6a0dd16d3@gmail.com>
Date: Wed, 18 Jan 2023 14:04:01 -0800
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.2
From: Florian Fainelli <f.fainelli@gmail.com>
Subject: Re: [PATCH 6.1 000/176] 6.1.7-rc2 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de
References: <20230117124546.116438951@linuxfoundation.org>
Content-Language: en-US
In-Reply-To: <20230117124546.116438951@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 1/17/2023 4:48 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.1.7 release.
> There are 176 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 19 Jan 2023 12:45:11 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.1.7-rc2.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.1.y
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

