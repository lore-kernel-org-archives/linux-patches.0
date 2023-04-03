Received: from mail-io1-f51.google.com (mail-io1-f51.google.com [209.85.166.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B7F06A954
	for <patches@lists.linux.dev>; Mon,  3 Apr 2023 22:59:23 +0000 (UTC)
Received: by mail-io1-f51.google.com with SMTP id ca18e2360f4ac-7585535bd79so16368039f.0
        for <patches@lists.linux.dev>; Mon, 03 Apr 2023 15:59:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google; t=1680562762;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=fkd2TX1vf4QdQsQX67c28kv3YBAJ32wfaLNOMhERik8=;
        b=byH49yTiJZ/bNBw+blnWrUs2iYagANWxDUZ0B/m9rs2BP1EcbBpqxuy2co+ghBSbIV
         z39BcU6zrKsPZBOXGRUxpOs5WkPhX8gEHy1fqwKhndy03glJrYNYDVMH2zOnXCiBIMnR
         z/s3x07FxOMqDcERXWkAV4FxyiDjwsMxcQqjo=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680562762;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=fkd2TX1vf4QdQsQX67c28kv3YBAJ32wfaLNOMhERik8=;
        b=bUi1eWqo/XIl2Xim61CUR6tvAO/tHk79lfnCYUv8yj0iSRJq5ZjeMkf5ujMqOYoNQi
         5Fd6R+OY6QtoFA1hipKTb4Q/y8eSqFqJxfs4X/1t01nxbdeX6Z08VOoXYnH6VKZvmglg
         1Bug7eY/3UZYxQV5x7xGpt3KfTVqBdoiQ0eqBoPvszQkTVmM7MA0fggNR9UBOXOH2HNr
         d+7Jp9yA9RXm6xCkqPTbJJRrnV6XuVXwut0BQt42QyaF43uKDIA6b2OzDMV0AuyAlXOR
         Be+cNAW0juaEQDv1UotG/fkImwfzlifbpzdeleyjCT1b75dcTYayw5ZsLRDqOxvwQfh4
         vo7w==
X-Gm-Message-State: AAQBX9fYTBsa0LKOcWIbU1Vlf6EaiTf+iRBo7bwGyjQSZkMQBX/uWW6l
	sRzZgcN9Dv2mzTuiwyBB1HqOlw==
X-Google-Smtp-Source: AKy350ZRbNyEi4Jdca0Ftmjo2kjCwv02cN2cPgzbKUN8wVvCZu02OWnhv+g9RimOYMYrUzDERgBrNQ==
X-Received: by 2002:a05:6602:1304:b0:759:485:41d with SMTP id h4-20020a056602130400b007590485041dmr617082iov.0.1680562762719;
        Mon, 03 Apr 2023 15:59:22 -0700 (PDT)
Received: from [192.168.1.128] ([38.15.45.1])
        by smtp.gmail.com with ESMTPSA id q29-20020a02b05d000000b00406356481c0sm2887964jah.57.2023.04.03.15.59.21
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 03 Apr 2023 15:59:22 -0700 (PDT)
Message-ID: <d681cdd7-b455-080f-9b19-3510f6bc7a8f@linuxfoundation.org>
Date: Mon, 3 Apr 2023 16:59:21 -0600
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.0
Subject: Re: [PATCH 5.15 00/99] 5.15.106-rc1 review
Content-Language: en-US
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, Shuah Khan <skhan@linuxfoundation.org>
References: <20230403140356.079638751@linuxfoundation.org>
From: Shuah Khan <skhan@linuxfoundation.org>
In-Reply-To: <20230403140356.079638751@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 4/3/23 08:08, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.106 release.
> There are 99 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 05 Apr 2023 14:03:18 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.106-rc1.gz
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
