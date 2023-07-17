Received: from mail-ot1-f45.google.com (mail-ot1-f45.google.com [209.85.210.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 81C2F253CD
	for <patches@lists.linux.dev>; Mon, 17 Jul 2023 19:18:09 +0000 (UTC)
Received: by mail-ot1-f45.google.com with SMTP id 46e09a7af769-6b711c3ad1fso3203049a34.0
        for <patches@lists.linux.dev>; Mon, 17 Jul 2023 12:18:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1689621488; x=1692213488;
        h=content-transfer-encoding:in-reply-to:subject:from:references:cc:to
         :content-language:user-agent:mime-version:date:message-id:sender
         :from:to:cc:subject:date:message-id:reply-to;
        bh=pD/oZCaJCOJRr2WuaMkYLcpCFfZmO7kAcw4QWPJFCs0=;
        b=NzeVcJLBnHLhBKfctguPt3mS8ngFJGqsjZWCfpuLI7fAgXT/QLVfgylUk86w5Qf3X5
         yP49vPtG1W6+tZqV4XUt/U5zVVI4+HQy+ZvKZx3UgL+PWQPvAd9bnkd8vrZlhsUsdVX/
         Y1lCkUFK/0n4WHFw6urPZkXbRFbl6xOJ/WMVGU2pu0vOUg/rTphyTiiVfIVLbynPtsH/
         Iuo3tgAzYEs0b3jg/thvAnfYbvB0rcKyLftRSR9lMogF85RRhNTU4Jne9Fe0Y1NNxG7N
         DzYsdcdBAP602sYgVIsmhPWV912b8ruFJcxMkSsdCYTtg9U6/9mnAPY78xnSvbXU+u5u
         1Oxg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1689621488; x=1692213488;
        h=content-transfer-encoding:in-reply-to:subject:from:references:cc:to
         :content-language:user-agent:mime-version:date:message-id:sender
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=pD/oZCaJCOJRr2WuaMkYLcpCFfZmO7kAcw4QWPJFCs0=;
        b=YF78Qe1WW2DHMIuEvJ/7ewJJHj33o6ORWNOun/bunCBEuuC9T/RPWDGi+wFu7w9VHI
         uPPMc3jBvSGHFPSjuET+IqgaUaP+Qno1MdvN6o35QwHfWg+KbgtAfmr5zicT1fnc+hG0
         Q2ZEvSNEHNuSyVLS7hudy/ZXtbcATw4rst2e6HLomZQJP3E4xyqOOLKzVQAYSUs6UwMT
         Lew0V+FA9Bjn0ecxRVkOoM0PcVcHtbhFYPYxd5PCuPDVEoodwMEj78W7kJoC4ZmgFu7D
         Gd98qs0cd7pOwUluAqF3e47mIKIQPCml43OTT9mK4mPp0ZCm7rdw1zfDmxiRI+vLUKJ1
         /NVg==
X-Gm-Message-State: ABy/qLZlEm98tNul+R2JgHT7kHO69IgUpNi66wJvvc61gbLh/bw7H9kf
	XpvkFga+M9Mfb5eSBy2gS30=
X-Google-Smtp-Source: APBJJlGzBShM3WI3crHaFM1S6Hbpe/XCjVy49B1K121fBw7BDbSbSOkfDvrkh2vf+JNJJyYYYDZDmQ==
X-Received: by 2002:a05:6808:10d6:b0:3a3:9337:4099 with SMTP id s22-20020a05680810d600b003a393374099mr13876098ois.56.1689621488275;
        Mon, 17 Jul 2023 12:18:08 -0700 (PDT)
Received: from ?IPV6:2600:1700:e321:62f0:329c:23ff:fee3:9d7c? ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id i195-20020a636dcc000000b00514256c05c2sm171727pgc.7.2023.07.17.12.18.06
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 17 Jul 2023 12:18:07 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Message-ID: <5f514ecc-a0ae-ece1-a212-e392c128fb35@roeck-us.net>
Date: Mon, 17 Jul 2023 12:18:05 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.13.0
Content-Language: en-US
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org, shuah@kernel.org,
 patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
 jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
 srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org
References: <20230717185609.886113843@linuxfoundation.org>
From: Guenter Roeck <linux@roeck-us.net>
Subject: Re: [PATCH 6.1 000/585] 6.1.39-rc2 review
In-Reply-To: <20230717185609.886113843@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 7/17/23 11:57, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.1.39 release.
> There are 585 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 19 Jul 2023 18:55:09 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.1.39-rc2.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.1.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h
> 
> -------------
> Pseudo-Shortlog of commits:
> 
[ ... ]

> Sergey Shtylyov <s.shtylyov@omp.ru>
>      sh: Avoid using IRQ0 on SH3 and SH4
> 

This patch is applied without its fixes. That means almost all sh boards,
including the one testable with qemu, are broken. Fixes are (at least):

7c28a35e19fa sh: hd64461: Handle virq offset for offchip IRQ base and HD64461 IRQ
3d20f7a6eb76 sh: mach-dreamcast: Handle virq offset in cascaded IRQ demux
a2601b8d8f07 sh: mach-highlander: Handle virq offset in cascaded IRL demux
ab8aa4f0956d sh: mach-r2d: Handle virq offset in cascaded IRL demux

That list may be incomplete.

The same problem affects v6.4.y.

Guenter

