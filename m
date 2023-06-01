Received: from mail-il1-f173.google.com (mail-il1-f173.google.com [209.85.166.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 60D1E22626
	for <patches@lists.linux.dev>; Thu,  1 Jun 2023 20:42:40 +0000 (UTC)
Received: by mail-il1-f173.google.com with SMTP id e9e14a558f8ab-33bcc8f0d21so127015ab.1
        for <patches@lists.linux.dev>; Thu, 01 Jun 2023 13:42:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google; t=1685652159; x=1688244159;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=OKl0/TmyqUCpAuOpupn8i7XJtpT5nAF1vYH6XGHvHjc=;
        b=FPZTWOxQswiu52q1RB9Ek5TC8oPmpUovkh1mEQWLvXDPGVw4Ck2gwxzbtupsd32WkB
         r95C07a42vDulZ+tCbu1cKLGs7M9cmBRRkdkUaBRoSpmMMeL791OPLTdkqHc4nMayFBv
         st7SNWQPks4XAt8cYuJHQzKXXba/wzGyMNGz4=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685652159; x=1688244159;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=OKl0/TmyqUCpAuOpupn8i7XJtpT5nAF1vYH6XGHvHjc=;
        b=Hv8qvzkK6IT/HzG7w4Pfj7hbzESqTDriqzKIXhOt2P3dRL9q9/BG9MHwV8pxzd+P4q
         PewqFN2Jcm+47llDR1Zat/yFQC9r36dBU5WVeyl2Rdqdej4DxHkeTzZ3yZRVVIjoy5MG
         cTi/BS8nAfjQ+dziqCMax1DSA0XW6cvll0mLIMp7dGKlSfkFvas9MYZbBrsK/nV5VaHK
         eLKTbijK03pLqA74GVYlHaut0jmUaOVm1eDvxqBKXRRK469P2+ywy9muHsvm5cDDR9CQ
         HjX5dBhbYAcdbsXn1X2gH+Em5IVL9crWS2l0/2ue5Tq4+op83zuZRqZhqLbY+lJhqsFT
         tdMg==
X-Gm-Message-State: AC+VfDyofTYjb6Bw+If/T8XpVRXkfjm+eEO3ZCsLXjchjrwrsQ0liq8F
	PWciKFVOvAyQ4NPy+8LrRyvJYQ==
X-Google-Smtp-Source: ACHHUZ7D8q0nVmNZ636h4Aayli31YpZDJIWXYvF569qKvamTbIiSnRXcSvslg4ZpOIOdDsaRsfVUkg==
X-Received: by 2002:a6b:c9d1:0:b0:774:8d63:449c with SMTP id z200-20020a6bc9d1000000b007748d63449cmr4520667iof.0.1685652159333;
        Thu, 01 Jun 2023 13:42:39 -0700 (PDT)
Received: from [192.168.1.128] ([38.15.45.1])
        by smtp.gmail.com with ESMTPSA id i39-20020a056638382700b0040bbf478147sm2485029jav.163.2023.06.01.13.42.38
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 01 Jun 2023 13:42:39 -0700 (PDT)
Message-ID: <31216e05-6cb5-330f-fbe3-f6d75b356707@linuxfoundation.org>
Date: Thu, 1 Jun 2023 14:42:38 -0600
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.11.0
Subject: Re: [PATCH 5.15 00/37] 5.15.115-rc2 review
Content-Language: en-US
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, Shuah Khan <skhan@linuxfoundation.org>
References: <20230601143331.405588582@linuxfoundation.org>
From: Shuah Khan <skhan@linuxfoundation.org>
In-Reply-To: <20230601143331.405588582@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 6/1/23 08:36, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.115 release.
> There are 37 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 03 Jun 2023 14:33:22 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.115-rc2.gz
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
