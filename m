Received: from mail-pf1-f177.google.com (mail-pf1-f177.google.com [209.85.210.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B2E4D2F8
	for <patches@lists.linux.dev>; Mon, 19 Jun 2023 15:32:14 +0000 (UTC)
Received: by mail-pf1-f177.google.com with SMTP id d2e1a72fcca58-66872d4a141so614152b3a.1
        for <patches@lists.linux.dev>; Mon, 19 Jun 2023 08:32:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1687188734; x=1689780734;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :cc:to:subject:from:user-agent:mime-version:date:message-id:from:to
         :cc:subject:date:message-id:reply-to;
        bh=wmvl0aCfmdGaJ6IP/J7U3w1ihrhz91UltYjZDif8Ll8=;
        b=SZnTb2zTrDD43NblYvrQTo1FVdEtry0Y95tUye6RBw8eq9WHET8gXoMmuhNZcaSdx+
         o1RVuXo8q4VGuc97TLcDVJOFLXlnDAZp+HfNVGDJuW/p6wBourXrKqEmro8uCs06BVzS
         59nD+IMXFK1rs9USMgiI/wVvGJShDu6cWP6Gyhi5r5JQTpIV3+j9oIlAVLf5FQG6NKCy
         PeQEpdlEo14pwiP+ZcA1Jz1d7NCGpKozrp0qPMG0NWk5s/A/In3vjYW4jPzel7rZeLPe
         spbflAbyBFABmf2YTGXGyWOXerUdETEv6j9WOtqBl0ax60naPh1TjSznyZSINWivy+bq
         eJ2g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1687188734; x=1689780734;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :cc:to:subject:from:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=wmvl0aCfmdGaJ6IP/J7U3w1ihrhz91UltYjZDif8Ll8=;
        b=Hzk7i0OPQ2aVeatDB1RiohoIc5qcbbwbLhZItdkTdXGm2BJvf6zqRkBhwCjJDPdyja
         OrCrEq6y6QZSwQashrLD7kMMCBRVJFRZtjT01sACfHU6GhgmKFi320xIyfvLCf/IGciY
         ubsxV/qYewYMROtBAScfaLQ8Vakd8RbgR+9IbEFIFQMSzZ9Fhnp+gTgaesnxV43h24ZT
         fqQNVxUBjvyTfYi/T7AvuJKqm+Iu35HkJbXiqj4LkG3hjmRfAv3wa7Xg5qPVBLuVmKui
         kNSwqMYLIZzKhU3Jl0U270tb19kg6iRXo8EHux/UORnb7Cgo4zcCHUoJeGbdP/KAtY1Y
         IdYA==
X-Gm-Message-State: AC+VfDxmwrptKt/lH+cH5WFsRIUc5DH97nNEqlM6ffCSHAFWWT4OjpZ1
	tUpreQIIa8fBQPt34Dw4j2g=
X-Google-Smtp-Source: ACHHUZ5/TNzfZSPePnXGZ5nGgfPZJWvn922sBf6v6hnhuOxmVmR8EFjYqib7KIl+OGe0U/y/XXWNTA==
X-Received: by 2002:a05:6a20:3ca1:b0:110:9b0b:71a5 with SMTP id b33-20020a056a203ca100b001109b0b71a5mr6754278pzj.23.1687188733724;
        Mon, 19 Jun 2023 08:32:13 -0700 (PDT)
Received: from [10.178.67.29] ([192.19.248.250])
        by smtp.gmail.com with ESMTPSA id h126-20020a636c84000000b0050be8e0b94csm18532175pgc.90.2023.06.19.08.32.10
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 19 Jun 2023 08:32:13 -0700 (PDT)
Message-ID: <2567d144-b3b3-a85c-00ac-7e560ebb3347@gmail.com>
Date: Mon, 19 Jun 2023 16:32:08 +0100
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.12.0
From: Florian Fainelli <f.fainelli@gmail.com>
Subject: Re: [PATCH 6.1 000/166] 6.1.35-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de
References: <20230619102154.568541872@linuxfoundation.org>
Content-Language: en-US
In-Reply-To: <20230619102154.568541872@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 6/19/2023 11:27 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.1.35 release.
> There are 166 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 21 Jun 2023 10:21:12 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.1.35-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.1.y
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

