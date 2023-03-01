Received: from mail-qv1-f53.google.com (mail-qv1-f53.google.com [209.85.219.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C6EDA4C
	for <patches@lists.linux.dev>; Wed,  1 Mar 2023 21:27:53 +0000 (UTC)
Received: by mail-qv1-f53.google.com with SMTP id y3so10323167qvn.4
        for <patches@lists.linux.dev>; Wed, 01 Mar 2023 13:27:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=sladewatkins.net; s=googled;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Grfy1mEbjJ/uuvE5E7M7YWn6NRwWppMtzAtk4q3DIN8=;
        b=MwHwYgvlnAOCbpFwFoizuUkm+SZyL85dOgqX03fK93Q8/NSJW26dZDZnc/RdPiKwHN
         1sLnMecptskLiGczkKZOEsOSWzaooQuvV5eBpedKYD9erru4mMuXHwTtxGqpTSwvYSR9
         KfUNqaBAAegg5o2H9eFufT7EonEMMNNdtakaOhMh/PpHI1ymQOYl56PxI+lpqHsOAgYZ
         pDecnHX5+++ZbK3/Up9N2CVPFCCOsfG5RoZ4lRlW8b1turukg6jvU+/61JH2oNWel9px
         nD0HTdgHLi6UxA6BTOvfgpGbQLG90nL0mWKalxAwpOGYY2shUQ/9Ojp4gX0yh89oKyJj
         izjg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Grfy1mEbjJ/uuvE5E7M7YWn6NRwWppMtzAtk4q3DIN8=;
        b=N9BzWXc5EpmAMdwfBR9C2pH2yQeOVmFISWVyloibtYauuAgxjG0+3Vn3Em6FYi3l/h
         46iTtw/pYJ7n0dUS3EshD6JC/5TRB4QSme/bNUadhdUi9UAf9iOB29bMwWxXeeyrMBLj
         HeIgqZXHBOP1N7FD9tDVy8g4m93U6PTiQWdiEWlWNeAnpCiw76hEo4RmPjqac6TYg4Yh
         w3/XrIXtEdgVbxB2J2/Ufx/DEktymP1QDFhX6iOZHIU5SnEnxNzpKK5cwn5q0XDGQ/bD
         eRtOORNZuaYfFs5AlrULGJLDoOqjDd1jce9HqnP5L1qBMpZ+2abroXhXfoQ4f+pgCEpy
         TrQA==
X-Gm-Message-State: AO0yUKWs0AebaHUCWtixXFxnBUaOOvUBw785hZbDrWByl7B4pFhFqhlK
	DV8lGhWYISUrRxum/DZ8B7FLBg==
X-Google-Smtp-Source: AK7set8nIRTUlPvssew8JIDWDdJwai0Wu7Tb/ZwGBhaPupcc6JplngqeMx2ueRHh9X9mgXvGXT9jTg==
X-Received: by 2002:a05:6214:300e:b0:56b:ec30:67eb with SMTP id ke14-20020a056214300e00b0056bec3067ebmr15210834qvb.39.1677706072890;
        Wed, 01 Mar 2023 13:27:52 -0800 (PST)
Received: from ghost.leviathan.sladewatkins.net (pool-108-44-32-49.albyny.fios.verizon.net. [108.44.32.49])
        by smtp.gmail.com with ESMTPSA id y141-20020a376493000000b00706c1f7a608sm9632730qkb.89.2023.03.01.13.27.51
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 01 Mar 2023 13:27:52 -0800 (PST)
Message-ID: <ded94867-2728-45ac-487f-89d995059022@sladewatkins.net>
Date: Wed, 1 Mar 2023 16:27:51 -0500
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Subject: Re: [PATCH 5.10 00/19] 5.10.171-rc1 review
Content-Language: en-US
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de
References: <20230301180652.316428563@linuxfoundation.org>
From: Slade Watkins <srw@sladewatkins.net>
In-Reply-To: <20230301180652.316428563@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 3/1/23 13:08, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.171 release.
> There are 19 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 03 Mar 2023 18:06:43 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.171-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.10.y
> and the diffstat can be found below.

5.10.171-rc1 compiled and booted on my x86_64 test system. No errors or
regressions.

Tested-by: Slade Watkins <srw@sladewatkins.net>

-- Slade

