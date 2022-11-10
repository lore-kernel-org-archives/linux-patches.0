Received: from mail-io1-f54.google.com (mail-io1-f54.google.com [209.85.166.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 59FE4364
	for <patches@lists.linux.dev>; Thu, 10 Nov 2022 01:46:13 +0000 (UTC)
Received: by mail-io1-f54.google.com with SMTP id b2so236662iof.12
        for <patches@lists.linux.dev>; Wed, 09 Nov 2022 17:46:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=p/y3kK/aK9HQTqxA2IkTFj8U2SX9wFU9K+VgUpk9sTA=;
        b=M9QshDp07CPCDTvqjA4I5RTcYiCfsLudF9/OXn1wdyy7NeI9GDcjVDci1j4WxjU6aJ
         n/8Aelt15FUoHCy9QVKRpMIjPbXcqCoKrn70e2sABfc1LGEDEZsEm4y21B1qpR7w66Tv
         ETTMcwCZSJ5VPwMdkyn/jY6DedX/YJIghoDdU=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=p/y3kK/aK9HQTqxA2IkTFj8U2SX9wFU9K+VgUpk9sTA=;
        b=1z+tzdQ+tER7QFql94Z4AqcyNqBRjV2YUrwGV1i05wPgZRbU/Xy+juZSNW+Qqjqjhu
         utSZCiijnzQttxcAPQZxpGX+06RrWjmMARTMxtFqAHUPfEhLyZ5otRkW5z0+DiiLZDdO
         MEN/26eefEjbq++6xnEJVxzNrMHF3PX5gmuN06yoZKEsZVpKmlC3jPMB+aThtAmFojg6
         TpyEzHVpmsmQvCopMZwEKM9Dtkvdi6ajl4mtfkrC9UellZ3Fat5JyRiF0rHdD0PYL8qP
         YiuIqfSLWT1sklVwIJyzCnvEvYeuhCziORtmKEIvhceOCrBcLVMX3eUozTs71TMOH0Zg
         VCpQ==
X-Gm-Message-State: ANoB5pnqDJa/03Ie6oMyg+x4XRK0N0P6sDMkcXWU3VG7lRuWGDK/rlpN
	R+e/nXAYXrHcyw2+SPLpaSNhzw==
X-Google-Smtp-Source: AA0mqf4B2hDgM9ZRoS5qBONm0z+KkOFTYsY83ueuH4QwL0C8LrYW7Ls7BQ2ZBmgUrjh7qL6h8fZ/fQ==
X-Received: by 2002:a6b:3ec2:0:b0:6da:fb85:a84d with SMTP id l185-20020a6b3ec2000000b006dafb85a84dmr9394328ioa.11.1668044772282;
        Wed, 09 Nov 2022 17:46:12 -0800 (PST)
Received: from [192.168.1.128] ([38.15.45.1])
        by smtp.gmail.com with ESMTPSA id a24-20020a5d9558000000b006bbf0466587sm5843573ios.49.2022.11.09.17.46.10
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 09 Nov 2022 17:46:11 -0800 (PST)
Message-ID: <988d8fdf-6513-7544-bd4c-b55c28e5dd89@linuxfoundation.org>
Date: Wed, 9 Nov 2022 18:46:10 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.2.2
Subject: Re: [PATCH 6.0 000/197] 6.0.8-rc1 review
Content-Language: en-US
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 Shuah Khan <skhan@linuxfoundation.org>
References: <20221108133354.787209461@linuxfoundation.org>
From: Shuah Khan <skhan@linuxfoundation.org>
In-Reply-To: <20221108133354.787209461@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 11/8/22 06:37, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.0.8 release.
> There are 197 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 10 Nov 2022 13:33:17 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.0.8-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.0.y
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
