Received: from mail-io1-f51.google.com (mail-io1-f51.google.com [209.85.166.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 355B1ED1
	for <patches@lists.linux.dev>; Wed, 26 Apr 2023 00:28:44 +0000 (UTC)
Received: by mail-io1-f51.google.com with SMTP id ca18e2360f4ac-760a1c94c28so35564939f.1
        for <patches@lists.linux.dev>; Tue, 25 Apr 2023 17:28:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google; t=1682468923; x=1685060923;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=uhyMv9OZ9mvx4IhTSE5UvrwBRU370RxidTCgJvUyue8=;
        b=Heu0niEzxoY5rTYHyEsV4e11x0/pdN65vFedPvVmiwHLXFJkV0f45yqcZAzBYIXF2a
         j+njBZUW4bRtO2noJsWO1x9v+bpd6/9EcJoNj9VMXd6p44FeXR/0rYmRmNdOjztnwbHf
         o/hCSF5meDdVKFySpTD5Um8Vnh26Estd3mKgw=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682468923; x=1685060923;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=uhyMv9OZ9mvx4IhTSE5UvrwBRU370RxidTCgJvUyue8=;
        b=Oo5GEZimZe936OGzMYiyCA0iRV/JToQ3RWDyo4WxAEaWl/nALzJfHPUNfGXvKJdzet
         OyItlJLHcPuy93btYDUwf5cVCnG+OlUP4+HGUgWedjR0FKbYKA6pTSEqST3dmGJAT1KV
         49teucV4CB1e8QI5xYHsXog9P7pnutlVd87arahPDDuvTc3sBd9HYb6hkyO3bp0khP8G
         74MMTUr7oDkYhrYEn3/jJzDlKquy/vbven1smI4SbUZtIADU5wvmzDSihaklpVot+ydP
         0caFIJL3TQTHgDtjP7sPfcFGEmeWTUGjGneJxkdJwJcxKL1F0l9tQF/xOisI0nXPix8U
         b5TQ==
X-Gm-Message-State: AAQBX9dlfOYtmFYyXyWWbO7NkYtOVt02ZnAEkjlVevPBCrSjixisQiNd
	7pipdLoq00Kfsh2JGSg+Sd3JfA==
X-Google-Smtp-Source: AKy350ZYv/G9pJTFwWGEygpwAJ1mJ1eme+0ltmLg6fdMNkFzdqS0GA44pp9j5JLnQiesV0wCpicDgg==
X-Received: by 2002:a05:6602:2d81:b0:760:ea9d:4af6 with SMTP id k1-20020a0566022d8100b00760ea9d4af6mr2702166iow.1.1682468923149;
        Tue, 25 Apr 2023 17:28:43 -0700 (PDT)
Received: from [192.168.1.128] ([38.15.45.1])
        by smtp.gmail.com with ESMTPSA id y68-20020a02954a000000b0040fa2395ad5sm4583603jah.178.2023.04.25.17.28.42
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 25 Apr 2023 17:28:42 -0700 (PDT)
Message-ID: <c65f5688-5005-cee4-903f-526cc0d0ca35@linuxfoundation.org>
Date: Tue, 25 Apr 2023 18:28:42 -0600
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Subject: Re: [PATCH 5.10 00/68] 5.10.179-rc1 review
Content-Language: en-US
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, Shuah Khan <skhan@linuxfoundation.org>
References: <20230424131127.653885914@linuxfoundation.org>
From: Shuah Khan <skhan@linuxfoundation.org>
In-Reply-To: <20230424131127.653885914@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 4/24/23 07:17, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.179 release.
> There are 68 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 26 Apr 2023 13:11:11 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.179-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.10.y
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
