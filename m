Received: from mail-oi1-f170.google.com (mail-oi1-f170.google.com [209.85.167.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 374AD2F43
	for <patches@lists.linux.dev>; Wed, 28 Dec 2022 21:15:04 +0000 (UTC)
Received: by mail-oi1-f170.google.com with SMTP id c133so15788372oif.1
        for <patches@lists.linux.dev>; Wed, 28 Dec 2022 13:15:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=u61catlXVW5wFymBQzKgemYTpBvwIjho7UirvKaMj6s=;
        b=GJn/+f/zSq4Sj1Jy5I7R7pzdtBAYQj/fHvpunvZvo6+d4ZIVzK1RydQT4AkNxsAUqH
         62BtU1qKw8UmOR1rCLQkwd1luBZeeG+xEmJH1un6vgWHAsSOnGOIOIeNr7/LcpKCzNsy
         4vH5KtfRC+FkayOrE7CDm9ViKw81nIwEUl1E/MapYHw31K5enZlwC0hczo54VhHIl+80
         KuHi2ZZl9cSwo2FmsewEBVbCBhmrLeLCdSc2H46hQtIJKj7EtonhPQYY7iWFRLB+o25g
         VFdc5oVOGjmS9qPZm0KY0zKtJ567MiNrJ6KzdCaYEUJuhU8Hai4YjynfnttUUFELW5q1
         Y+HQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=u61catlXVW5wFymBQzKgemYTpBvwIjho7UirvKaMj6s=;
        b=tS+0++J+Qjsy/SnfC4b7LwZQAtPY9PTWWYMwn7TVg2GFtUUMtLQ1QnGWV8Y9rk4Jop
         gN0wL3QvsAqwPFKum8DDms6vNJosYqZ9VB8fGLKXS9TAOj17amszeNFFkrB8a2AIisQD
         SWLHw7D5G/0JwoX3PUhZGwCmMaB7t3m0ww3pmbTf7XfAmfDjiNz6CCpHebFPCAeScu/w
         vL5Scfdw4siJz7gDp4sM1YkJuWTPeGw/nP+WtQBWmdnTKcFm8OHdMzQSQmtLYigUrr4i
         NRssZetj90yw0c5i/xr9gQaYv9tnqk+upmkmMHvXmNFrn8BzTnEDhSXGfctaJlnu0kHb
         jyfQ==
X-Gm-Message-State: AFqh2krXqclPVxgtlyk+H+cxGdRaFh68ePCoa3ge6LU/KA0tsq1fKGG3
	/71LM5rGbnHKq4XwbnqrmM/sWA==
X-Google-Smtp-Source: AMrXdXvjsN/jTj/sK+n2xZm0y1XctLSMEEFFh1I46UezAZgLU8ZmXZK9DIWXil/6O6GaUT28xYetxQ==
X-Received: by 2002:aca:4009:0:b0:360:ceb6:1f6f with SMTP id n9-20020aca4009000000b00360ceb61f6fmr9928171oia.54.1672262103112;
        Wed, 28 Dec 2022 13:15:03 -0800 (PST)
Received: from [192.168.17.16] ([189.219.72.83])
        by smtp.gmail.com with ESMTPSA id c17-20020a056808139100b003546fada8f6sm7400869oiw.12.2022.12.28.13.15.01
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 28 Dec 2022 13:15:02 -0800 (PST)
Message-ID: <9560136e-d6e9-995a-141a-61dd05a62b8a@linaro.org>
Date: Wed, 28 Dec 2022 15:15:01 -0600
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.0
Subject: Re: [PATCH 6.1 0000/1146] 6.1.2-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de
References: <20221228144330.180012208@linuxfoundation.org>
Content-Language: en-US
From: =?UTF-8?Q?Daniel_D=c3=adaz?= <daniel.diaz@linaro.org>
In-Reply-To: <20221228144330.180012208@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Hello!


On 28/12/22 08:25, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.1.2 release.
> There are 1146 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 30 Dec 2022 14:41:29 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.1.2-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.1.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

We're seeing the already reported problem with the unused variable 'rpm', but also seeing this on Arm, i386, MIPS, PA-RISC:

| /builds/linux/drivers/pwm/pwm-tegra.c: In function 'tegra_pwm_config':
| /builds/linux/drivers/pwm/pwm-tegra.c:148:53: error: result of '1000000000 << 8' requires 39 bits to represent, but 'long int' only has 32 bits [-Werror=shift-overflow=]
|    required_clk_rate = DIV_ROUND_UP_ULL(NSEC_PER_SEC << PWM_DUTY_WIDTH,
|                                                      ^~
| /builds/linux/include/linux/math.h:40:32: note: in definition of macro 'DIV_ROUND_DOWN_ULL'
|   ({ unsigned long long _tmp = (ll); do_div(_tmp, d); _tmp; })
|                                 ^~
| /builds/linux/drivers/pwm/pwm-tegra.c:148:23: note: in expansion of macro 'DIV_ROUND_UP_ULL'
|    required_clk_rate = DIV_ROUND_UP_ULL(NSEC_PER_SEC << PWM_DUTY_WIDTH,
|                        ^~~~~~~~~~~~~~~~
| cc1: all warnings being treated as errors

Those are with GCC-8 and allmodconfig.

Greetings!

Daniel Díaz
daniel.diaz@linaro.org

