Received: from mail-io1-f54.google.com (mail-io1-f54.google.com [209.85.166.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 386BE8C14
	for <patches@lists.linux.dev>; Thu, 29 Dec 2022 23:24:20 +0000 (UTC)
Received: by mail-io1-f54.google.com with SMTP id d123so10400750iof.6
        for <patches@lists.linux.dev>; Thu, 29 Dec 2022 15:24:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=EKWr2Oqn4+KbfBpOg8OfYaJAhn+fXb/cSvl2sD2pWvw=;
        b=G1OO+7KSmmiwUcrRssIY4eqX3xS5Y4JnvkJMYoE7vkNc9EHanx+JhRTYAJtjvbg3Z7
         vdRGHr4aTZJvVzCwWauWUHn4HVRp877G09OkfQ+ChYHZqOMJreKkoytpjJpzdXXUerV/
         LXHdIAo5+svAlhbFA1AgVoTrl6V0ef4mbfLhA=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=EKWr2Oqn4+KbfBpOg8OfYaJAhn+fXb/cSvl2sD2pWvw=;
        b=A5sIoPiGZxeWN6+Gxi7/1TKg/x/NhAsDbErjgYYkScXpJKExpdO4XANl9wqqajNnIk
         LvZSBRQm086YTM4qRdqkFqPBpCpHqXSYoJ17dzml7MoulM7yduvGlNnJleIM8cso0QT3
         Lxfdh9sFuhaLLzqTuEKs49S91ugn/kZBKvsCmkdeS/a+pccszaJBKdUDFqIYvkIkuWGQ
         tUCagiV3Q9TnaLFqWGKyyCEBZWZnQDCmA7PLotc9B8kURshYqhd4QXD2KLkIWG66tYlc
         6qcDNVsri2Zz/3MU88ic/Qc7oJ6funAPTU+wI4LV2ko/i8PkChfwmC9spq6VCu42Ir2H
         qnZg==
X-Gm-Message-State: AFqh2kpoXmz3kx9lQ7iRtWeAbkqhXa8dYxXUvu/Mlq0KhatSElzvkf3k
	3/4OYijX7ilytRabkNggYPwjmA==
X-Google-Smtp-Source: AMrXdXtlKlZSAuUaSVEw7pdrAhUjFDCakVbS0qZBml8qKztAB2FaGTxtccOMXkLmUJaUZ7HThFJ04A==
X-Received: by 2002:a6b:e812:0:b0:6f3:fed4:aa36 with SMTP id f18-20020a6be812000000b006f3fed4aa36mr2749575ioh.1.1672356259094;
        Thu, 29 Dec 2022 15:24:19 -0800 (PST)
Received: from [192.168.1.128] ([38.15.45.1])
        by smtp.gmail.com with ESMTPSA id u5-20020a5d9f45000000b006884b050a0asm6983365iot.18.2022.12.29.15.24.17
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 29 Dec 2022 15:24:18 -0800 (PST)
Message-ID: <9cfe1554-a060-8966-844f-52a7c9cf4bd2@linuxfoundation.org>
Date: Thu, 29 Dec 2022 16:24:17 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.2
Subject: Re: [PATCH 6.1 0000/1146] 6.1.2-rc1 review
Content-Language: en-US
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, Shuah Khan <skhan@linuxfoundation.org>
References: <20221228144330.180012208@linuxfoundation.org>
From: Shuah Khan <skhan@linuxfoundation.org>
In-Reply-To: <20221228144330.180012208@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 12/28/22 07:25, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.1.2 release.
> There are 1146 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 30 Dec 2022 14:41:29 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.1.2-rc1.gz
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


