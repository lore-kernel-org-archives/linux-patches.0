Received: from mail-il1-f174.google.com (mail-il1-f174.google.com [209.85.166.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9FFE61FB0
	for <patches@lists.linux.dev>; Tue, 16 May 2023 01:32:08 +0000 (UTC)
Received: by mail-il1-f174.google.com with SMTP id e9e14a558f8ab-3357ea1681fso3215725ab.1
        for <patches@lists.linux.dev>; Mon, 15 May 2023 18:32:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google; t=1684200727; x=1686792727;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=WxAuCAPbFp9ImZfMRV40TuMDQw2xswagc+lrSeMYOZw=;
        b=WtaQSJ8OTZ9/ZK6MoOV91CJMwdT7yRyP8PP1fjRZNWwklcJNHgxsOzhXYuCqLQUSzc
         qCU8ynMIPeSmK9Cqjwvg8aIiizqAwu3jexJCykVSL0WenYDu3eYsz0hDQUKehToa59cL
         vgUgJFqt83Imgc0jiDz//aS5TgVwZrd5qbqQ0=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684200727; x=1686792727;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=WxAuCAPbFp9ImZfMRV40TuMDQw2xswagc+lrSeMYOZw=;
        b=Rv+fWcqwJ/LkRZuGK6sWVKLm03Ng7hJ3/CQOdSGfUMuaJIHXNbax0L0YscLFEQ3RV1
         yQy9YJCv1YIfY8f7EvtOKV5KsFuMjZXRNr7hwOBClgm1HfmgvyL7YXVvNIg4MsP4ILkt
         p84/m4i/u84aqsniPDf25+yj+Fos49o2IivFuk3fBAmEiANsMWMOOLClfClm4zIrEKLY
         1QeXbmV1ecXgW2q5oswAWqdNL6fZE6EoUf7tfAw4QzLhdIy1H1HTpLhDweYLLmqGCBMK
         rsEHoLo1QNHU6S5F38r2j+bljbovuul2jJHop5pn01IoSgJ5MiMZlHYUFMmPvWkk96Jg
         nl3g==
X-Gm-Message-State: AC+VfDwetkYWbzOoFUb/zFgnhi+KoHwzC6vSFAToiXTRpme3lZ7R54YF
	JwCTxcu9KLEvo1DG3/3b38mp1g==
X-Google-Smtp-Source: ACHHUZ4e+UJb59KuKDpjrZ4jheJdHLUsGADTus4l4moTjBngVNMYCjuMO7KHnT0PwYt978kaMbyS1Q==
X-Received: by 2002:a05:6602:3806:b0:76c:67bb:11d1 with SMTP id bb6-20020a056602380600b0076c67bb11d1mr986402iob.1.1684200727739;
        Mon, 15 May 2023 18:32:07 -0700 (PDT)
Received: from [192.168.1.128] ([38.15.45.1])
        by smtp.gmail.com with ESMTPSA id b23-20020a5d8057000000b00763da065395sm7303195ior.3.2023.05.15.18.32.06
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 15 May 2023 18:32:07 -0700 (PDT)
Message-ID: <9d8f2c28-653d-16e7-bdc1-3044ea7cab0a@linuxfoundation.org>
Date: Mon, 15 May 2023 19:32:06 -0600
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Subject: Re: [PATCH 5.4 000/282] 5.4.243-rc1 review
Content-Language: en-US
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, Shuah Khan <skhan@linuxfoundation.org>
References: <20230515161722.146344674@linuxfoundation.org>
From: Shuah Khan <skhan@linuxfoundation.org>
In-Reply-To: <20230515161722.146344674@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 5/15/23 10:26, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.243 release.
> There are 282 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 17 May 2023 16:16:37 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.243-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.4.y
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


