Received: from mail-il1-f177.google.com (mail-il1-f177.google.com [209.85.166.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD971EA1
	for <patches@lists.linux.dev>; Thu,  2 Mar 2023 01:44:09 +0000 (UTC)
Received: by mail-il1-f177.google.com with SMTP id i12so9577835ila.5
        for <patches@lists.linux.dev>; Wed, 01 Mar 2023 17:44:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google; t=1677721449;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=/wn0GhLKfvndtXTBbWz5QIu214kxtRlcBtnzhbmKAbw=;
        b=Wy7KOhXqkaoDoBgSms5p/icdqbwn2o0tqPwG37KM0Jubxew2owaE3mGCi80QpNN1/7
         PXY1r0Xq1D7G4jgVPnXkTip8jqQz2YIZFYlhGb4EQy+dbom5e5V/KT6QihayK6RYMhrd
         2YONx+0xxOAz0fQXlnyLDFfYyh5wskQpU0w4Q=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1677721449;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=/wn0GhLKfvndtXTBbWz5QIu214kxtRlcBtnzhbmKAbw=;
        b=SVMZko3v3vIHx/5GhGRhmXW2SR37OTaly2yqH4bnqpbBHwg2wucz7h9+5WampC6xi4
         7F0uTmed58tMEOsTAg5Zjqhe7YdDWrpY7U9em6oaPMv/6lPD1J1cUwyoGYnvRFWwExzj
         9ci5BZ7AqqiFoK21jIIN9J0SWoOtv5BQXIx172kFAqIetuypdK+S3TCUI6J734l3NsQn
         og5y5Mn5J88Ho/lwPfyN+VsGY4RUlgJW2XOALHKt3VRFIRx+np3WZh25WUG6RQ3urVRo
         ik7mdAdbUMpb+Q9MR64G7vFuVHEO8+L40XjiMH4Ljn/0soXh1SuTFyv1Y6ADfVPCA5gL
         mA5g==
X-Gm-Message-State: AO0yUKUqDJZpfMN7YDgcHUCLnDCNL/jrZCrCFr/r2xPrx4yOuDMCHp7q
	oa3LBsz6TYfppwvkC5NkuiKBLg==
X-Google-Smtp-Source: AK7set/9FFT6a9C3NXius89Sc64bLu+bFZ0TVFTj+E4Su+lTvZDyEUaN+DUAA71wzjxV5X0RQHd5Ng==
X-Received: by 2002:a92:6c0e:0:b0:317:16bc:dc97 with SMTP id h14-20020a926c0e000000b0031716bcdc97mr5585168ilc.3.1677721448794;
        Wed, 01 Mar 2023 17:44:08 -0800 (PST)
Received: from [192.168.1.128] ([38.15.45.1])
        by smtp.gmail.com with ESMTPSA id u23-20020a02aa97000000b003aef8fded9asm4224833jai.127.2023.03.01.17.44.07
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 01 Mar 2023 17:44:07 -0800 (PST)
Message-ID: <d77cfb98-1135-d56a-9199-263ead73eee6@linuxfoundation.org>
Date: Wed, 1 Mar 2023 18:44:06 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.1
Subject: Re: [PATCH 6.1 00/42] 6.1.15-rc1 review
Content-Language: en-US
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, Shuah Khan <skhan@linuxfoundation.org>
References: <20230301180657.003689969@linuxfoundation.org>
From: Shuah Khan <skhan@linuxfoundation.org>
In-Reply-To: <20230301180657.003689969@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 3/1/23 11:08, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.1.15 release.
> There are 42 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 03 Mar 2023 18:06:43 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.1.15-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.1.y
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
