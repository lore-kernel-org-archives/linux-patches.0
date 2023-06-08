Received: from mail-il1-f178.google.com (mail-il1-f178.google.com [209.85.166.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC113A54
	for <patches@lists.linux.dev>; Thu,  8 Jun 2023 01:26:12 +0000 (UTC)
Received: by mail-il1-f178.google.com with SMTP id e9e14a558f8ab-33dbad61311so2536165ab.0
        for <patches@lists.linux.dev>; Wed, 07 Jun 2023 18:26:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google; t=1686187572; x=1688779572;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=WkN4YhNfQp+ZbfhdGrNxfUu8thCYEN7OW0ct1T3I3As=;
        b=Ss223zaYWFhxjprbff5yEbLaDzyoVlqg4jO4Tll6AipSK5++GbcuYP3SpXwXIJoXLc
         +Qok/gXdmfqYSN7o6y8UEWGOG99NjP0MMPt9Zvehot3K72UdUAZ1o2Bz54x3s4kpItkE
         e/HJep/MTdGaMMNxffPHghBD9JaJbaEQXMN+c=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686187572; x=1688779572;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=WkN4YhNfQp+ZbfhdGrNxfUu8thCYEN7OW0ct1T3I3As=;
        b=FbJ1IZA6SPXrsBoHaReTn5I5yZDVQtUUCZyxSwo+Bf3Zy0qFlkqjLD0tesKT9vQRKe
         gQQk7aqjPBjw+jT/UQ6ZaeYeH3/2wOfGWoDUiDtZ6GNvjN433XJkLnVSZkfuRxxF+2rn
         R/0Rx9L8SchIkNYzzKthjYo9YVu4qFqALQCigWx9jIwFPj/f8w6lyHOUEmcltfBGlI/C
         BeutHI/g6+vQCFFDiT7nl08EwBy60Yfhfj9cJDPq3s6f2zPD/7qsmmwvBimQGvhKOLgw
         sHdsAfmSq1IAzhE+4AYh8Ui9rAxM1RTuTJZgzQ+0vO5NNVhJxj99zKP7yA9jVLY8d4i0
         MXuA==
X-Gm-Message-State: AC+VfDyE95riEC2a2cwCiuEl5shnISMRw7toFcCa0wh4QzUY3a+IkqzQ
	/0DBBtAO0La8bUOlGfV6hnYhHTxmaNQGmpkJh8o=
X-Google-Smtp-Source: ACHHUZ7BaWYaod1rGhEcVO6fZvTKYJM9YW9/GSHfDK9d4uIUofjC4m94DZuF+JDXvU63EjT/SWVHqA==
X-Received: by 2002:a05:6e02:1be8:b0:32b:51df:26a0 with SMTP id y8-20020a056e021be800b0032b51df26a0mr2192524ilv.2.1686187571838;
        Wed, 07 Jun 2023 18:26:11 -0700 (PDT)
Received: from [192.168.1.128] ([38.15.45.1])
        by smtp.gmail.com with ESMTPSA id dp37-20020a0566381ca500b0041ab9b6f5b0sm2944879jab.128.2023.06.07.18.26.11
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 07 Jun 2023 18:26:11 -0700 (PDT)
Message-ID: <2f85f1df-369c-cdd2-d92a-e7c2c2b481a3@linuxfoundation.org>
Date: Wed, 7 Jun 2023 19:26:10 -0600
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.11.0
Subject: Re: [PATCH 5.15 000/159] 5.15.116-rc1 review
Content-Language: en-US
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, Shuah Khan <skhan@linuxfoundation.org>
References: <20230607200903.652580797@linuxfoundation.org>
From: Shuah Khan <skhan@linuxfoundation.org>
In-Reply-To: <20230607200903.652580797@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 6/7/23 14:15, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.116 release.
> There are 159 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 09 Jun 2023 20:07:31 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.116-rc1.gz
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

