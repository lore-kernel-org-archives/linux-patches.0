Received: from mail-qk1-f174.google.com (mail-qk1-f174.google.com [209.85.222.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A862812290
	for <patches@lists.linux.dev>; Wed, 16 Nov 2022 20:56:31 +0000 (UTC)
Received: by mail-qk1-f174.google.com with SMTP id g10so12553610qkl.6
        for <patches@lists.linux.dev>; Wed, 16 Nov 2022 12:56:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :cc:to:subject:from:user-agent:mime-version:date:message-id:from:to
         :cc:subject:date:message-id:reply-to;
        bh=zy7OuB/i0g5N8OKRO3fubXKgptPvlvXmoLmFRS8NTW8=;
        b=j6HBmryqK8UClOg/NS2PiSDE3d0BOoNDUsw5wVvkdE0wr9OTpHZALel85g70S45O2f
         fCSJeao726reXsNBDQL50RLxInJb23XC4joKUCS5oCuSxdDVH70QY61xrpF8iwIxlM1b
         IbjifGFRl9t+kbRs76zJ0i6usxyt+x5tpNxG/BtFcqzhMYu1c5ps/uouSq/k2sBzotyr
         6fDi80j/8vI8rrHYMAVFo0cLQwCo8XRKXT9tZAgpGZ+jO8io5GuVvnZHY6+tkdZNPiqp
         ZL624rkRCsm+8G4CJLCB+6okz9qpVMZsNwgCDrq+oWdpIfUaZulVeJ7ybBaZ6QdZfYTi
         1unQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :cc:to:subject:from:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=zy7OuB/i0g5N8OKRO3fubXKgptPvlvXmoLmFRS8NTW8=;
        b=sfSgg0MQ+UhA/eOtRsstRuxucamcSuUTJBGThxrsKStd2xxBxUOJCFL5+JaMKyvimD
         rRRnTOd1A/5XW9u2Vj5PtU7z3UD/Do2hrMGAluTsQYHeOjAhuBu8ZpZyl2Y8UUDZt8L6
         o/vR1P/sndqNPXRoN8tS/x87uMo/lrGnLWWz258DWJNIp9eFcHtMNkeI1eNiDJOx/rS6
         SUp9B96bzFFZRdDjvvoDUb4UP/Q9ahZeNpU+TISSdJsF62z4PX0XWYFu+5LWK6WjajRi
         9WcwDFJ1n4ON8OlTb1rW96a/xiAh8bpu3qxjDrDgLM8P+mweMDVkLVyMtbxapMM1DsQR
         HZsg==
X-Gm-Message-State: ANoB5pm4oCNymuTN2A+1PMhTp6Eu8KoXEAkhBnt5uCdUWeS6jjOo8TTy
	zDSpK4PHQP//4SRFxxO6IJI=
X-Google-Smtp-Source: AA0mqf7FqMZWHCQ9PQ4tImKAUuWMnFGM1yghpJiRtIoziRTs/wLppTh+C+I9D1YmCueKME7UEYWpTQ==
X-Received: by 2002:a37:aa53:0:b0:6fa:4b0b:d08f with SMTP id t80-20020a37aa53000000b006fa4b0bd08fmr21387495qke.488.1668632190553;
        Wed, 16 Nov 2022 12:56:30 -0800 (PST)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id u12-20020a05620a084c00b006bc192d277csm10482915qku.10.2022.11.16.12.56.25
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 16 Nov 2022 12:56:29 -0800 (PST)
Message-ID: <f12edc46-0fed-654b-62da-9e6866f6b607@gmail.com>
Date: Wed, 16 Nov 2022 12:56:24 -0800
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.2
From: Florian Fainelli <f.fainelli@gmail.com>
Subject: Re: [PATCH 5.15 000/130] 5.15.79-rc2 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de
References: <20221115140300.534663914@linuxfoundation.org>
Content-Language: en-US
In-Reply-To: <20221115140300.534663914@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 11/15/2022 6:04 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.79 release.
> There are 130 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 17 Nov 2022 14:02:33 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.79-rc2.gz
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

