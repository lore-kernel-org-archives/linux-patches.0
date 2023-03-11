Received: from mail-il1-f176.google.com (mail-il1-f176.google.com [209.85.166.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 398F3EA1
	for <patches@lists.linux.dev>; Sat, 11 Mar 2023 02:02:33 +0000 (UTC)
Received: by mail-il1-f176.google.com with SMTP id l2so4046606ilg.7
        for <patches@lists.linux.dev>; Fri, 10 Mar 2023 18:02:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google; t=1678500152;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=OyLUejJJCPWP6PVsnG0VJF+sqdtQu2YfnVNooJBJCBY=;
        b=ZDHsJq7hEJP8hojv5D8iVtFXLVGbwsTKTdM+M38lnfFBygiyb8cnjaNxOi+nBY8JZv
         XZmOLpjQmGEg3OXHfjVyT8eqXsYX2ZB5TFUD/N39Yufmo5JtAB1TXSA+O0DZYDBkTNkO
         OSwMvcBVgyrWjKsp3XguTaihLKEI7iisYiDok=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678500152;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=OyLUejJJCPWP6PVsnG0VJF+sqdtQu2YfnVNooJBJCBY=;
        b=kSQSq9kD2Qf7S6x0KGwToFrW2X7gcoJ6oJl1qeOri8fE3DuhoFQzWVOxsVNv8e3rl5
         vqicHvotdjZa1QVLf85Kf5kPamNumV6Pi40jTvxi4GTgWJzKPdZaEWTyseNMZ34lG9h5
         AKIFnUl/VYj8pacOZw4Vqo0gOwWQJSVT/mPwkSLALvexd4yrGIwR191KuEvgAP37ekiY
         2S+7GMtUs8daHpdSbctop7rsS6X7TJL540fiZ2g4Cgd4ssIKyDvju0W9WeUYk7ZSt5DP
         aDvkruVUNMln5JQucWWj34sOfWO3riC5EIJIiZuGbo6f2QBkXR/MSxszurd4dz8ee45b
         lDtQ==
X-Gm-Message-State: AO0yUKUJ+TWsXB2TkzhxHVMMisDfqKd5PtWkE6ALdznvu47Rej4kYegr
	ceVvqrzvan7Lv7pvDsRHlWO5qw==
X-Google-Smtp-Source: AK7set+yfru95D8eXzjtb0ulLyuM2sfG/Pdgc+LL/M74Syvgmw9HVBF8Qy+53xZffrjIvJ9/A1mPOA==
X-Received: by 2002:a05:6e02:6c2:b0:317:94ad:a724 with SMTP id p2-20020a056e0206c200b0031794ada724mr5040662ils.2.1678500152190;
        Fri, 10 Mar 2023 18:02:32 -0800 (PST)
Received: from [192.168.1.128] ([38.15.45.1])
        by smtp.gmail.com with ESMTPSA id i16-20020a056e020d9000b00315d1153ffcsm450583ilj.65.2023.03.10.18.02.31
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 10 Mar 2023 18:02:31 -0800 (PST)
Message-ID: <9bd59ce5-5cdd-877c-26ae-3e0e4d0ec1ff@linuxfoundation.org>
Date: Fri, 10 Mar 2023 19:02:31 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.1
Subject: Re: [PATCH 5.15 000/136] 5.15.100-rc1 review
Content-Language: en-US
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, Shuah Khan <skhan@linuxfoundation.org>
References: <20230310133706.811226272@linuxfoundation.org>
From: Shuah Khan <skhan@linuxfoundation.org>
In-Reply-To: <20230310133706.811226272@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 3/10/23 06:42, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.100 release.
> There are 136 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 12 Mar 2023 13:36:38 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.100-rc1.gz
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
