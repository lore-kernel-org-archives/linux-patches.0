Received: from mail-il1-f176.google.com (mail-il1-f176.google.com [209.85.166.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1DF5B7F
	for <patches@lists.linux.dev>; Thu, 16 Mar 2023 00:02:35 +0000 (UTC)
Received: by mail-il1-f176.google.com with SMTP id 4so106642ilz.6
        for <patches@lists.linux.dev>; Wed, 15 Mar 2023 17:02:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google; t=1678924954;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=ewEZHYKYyayjtDE60f5wirtIHx7w+sAb+7nO8rKjDaA=;
        b=U0oBYfwYL1MFLsWjQab0gE03Oaosk3GhZV0eup0X+tGzP4FsX5iD7cSFwVV1JpyiIM
         Xbwwn9/rd9Q8skESRwHR/FG7nqA+PTSpkokIkUjjTLHOrCv+nGlHiDHVWIl7pSpk9Ivd
         XhUBp7PIFmmuHMNnGmHLk2yFgYQAUGuKfxUx0=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678924954;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ewEZHYKYyayjtDE60f5wirtIHx7w+sAb+7nO8rKjDaA=;
        b=AEf3P762NVH2MwHEBARLVBJ2Q0stLjPQv6aph/0ozpCOGNSGBcgQkboocXt4oRXHCp
         94tf3Y0u2WWlvALYN44DcH6GGWM7TcF/PXQ1kMiDfPhxCd/tCeZdTMaCKw1WEKmcO7XM
         SEWJQfRNdKj+j7SY5dQmfenGWCKpA047iYCOZHTH4+8Jp+QPXPEGz9yOMywssSa0/kvW
         EAt2azDei45t3MUxbB7p6iacWKTrXjuWXcs5Es/MHozdrJEVUEmvt057wLG9tzz0GHPW
         88byKK564C1dQjo/w+hpiGV0YIfWkkVkbeSSYLcdNpRunI0BzjeUY9533RiN62+Asw6f
         1Xfg==
X-Gm-Message-State: AO0yUKWD2ldivDbZ+gkw+w8+CP0tKAFVl4FkZeKAxbGvhJzrLvWw1cDd
	D+Wg5rUa5f2MA3Gmz6YAKV3UKA==
X-Google-Smtp-Source: AK7set9m7SzRy4yIcD0dGRkOHxuO7alCUrysveLliyqqS7pMcmMfe4np2GopkDSCaDlGlwRIWaukAQ==
X-Received: by 2002:a05:6e02:1ba9:b0:317:943c:2280 with SMTP id n9-20020a056e021ba900b00317943c2280mr699417ili.0.1678924954094;
        Wed, 15 Mar 2023 17:02:34 -0700 (PDT)
Received: from [192.168.1.128] ([38.15.45.1])
        by smtp.gmail.com with ESMTPSA id v5-20020a92c6c5000000b00313b281ecd2sm1959030ilm.70.2023.03.15.17.02.33
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 15 Mar 2023 17:02:33 -0700 (PDT)
Message-ID: <b1945aaa-978c-398d-ba9b-103bedab9095@linuxfoundation.org>
Date: Wed, 15 Mar 2023 18:02:33 -0600
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Subject: Re: [PATCH 5.15 000/145] 5.15.103-rc1 review
Content-Language: en-US
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, Shuah Khan <skhan@linuxfoundation.org>
References: <20230315115738.951067403@linuxfoundation.org>
From: Shuah Khan <skhan@linuxfoundation.org>
In-Reply-To: <20230315115738.951067403@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 3/15/23 06:11, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.103 release.
> There are 145 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 17 Mar 2023 11:57:10 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.103-rc1.gz
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
