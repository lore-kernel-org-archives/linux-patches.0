Received: from mail-io1-f47.google.com (mail-io1-f47.google.com [209.85.166.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 235627475
	for <patches@lists.linux.dev>; Mon, 12 Dec 2022 23:58:27 +0000 (UTC)
Received: by mail-io1-f47.google.com with SMTP id g20so912711iob.2
        for <patches@lists.linux.dev>; Mon, 12 Dec 2022 15:58:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=dTfI3BBJjBlFIJ4V+DQdc6idCrnKkd0U9K4WNFsdPJA=;
        b=V+thIy0TcfG5SzUQh2o7bx4JrsI9qlf+N9DiECGYh5WckQo3HLyoV4WmI7JweYaqfh
         T48YQB/r2sQ4f+vQvYvv4mzn58/JVes9lIhvyNRWOnKpj8dWKGrBimCrlfx1daEjCOqa
         ukZIz/xL2ldNyDcwbyGK16PpDDu1KzHQ3dxeI=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=dTfI3BBJjBlFIJ4V+DQdc6idCrnKkd0U9K4WNFsdPJA=;
        b=Ninkz5dEQK5FvVNZ4TLGHIOqt63jn853key4GvxRmi2qyxjzxXmuAtSdci8KJOpeNE
         Jh34UcLyKB7mRX9rufxOX1dkUff5WFLtP1dxgVpWNuFL5wu+kKxoQ4UBWbU35TdI8YN3
         AGTiw+YlTC0A/jtUJsfq23jOtaci7pc2E75O5O9TyJB2kobwPP7gSawjZLWBewLz9KRs
         qn7vDXtE5F1JSG6NJ0+2u8Vuh0Qo2zcYrcKb55NuH1b+35zAJ/qehPdvnOMdVh1YVtyh
         HBvTAJhTlaczeLh9tMk56v/bUB1qV0J7qOd52cozfhVVPRSL8cW3B9mDgvurh4cza1Mw
         qi0A==
X-Gm-Message-State: ANoB5pmvXqZWgXyG2yQcObuUxb0KcMlCveWqJV1K+KuuxeUDIYRsvtTL
	zX8lWyIYvZGf1jafztjHBANmuA==
X-Google-Smtp-Source: AA0mqf5yocX+4ApdK7akW1QcbVUUfuW5UBAkzXR+Z0PJ47ZOALkszIx0VsRXGgpXEmMo/Lt7kgMZqA==
X-Received: by 2002:a5d:8459:0:b0:6d9:7981:2a76 with SMTP id w25-20020a5d8459000000b006d979812a76mr2002971ior.0.1670889507013;
        Mon, 12 Dec 2022 15:58:27 -0800 (PST)
Received: from [192.168.1.128] ([38.15.45.1])
        by smtp.gmail.com with ESMTPSA id x8-20020a0566380ca800b00389d6a02740sm339748jad.157.2022.12.12.15.58.25
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 12 Dec 2022 15:58:26 -0800 (PST)
Message-ID: <14a5ebc0-1a80-cc9f-d216-0c11b7defdb3@linuxfoundation.org>
Date: Mon, 12 Dec 2022 16:58:25 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.2
Subject: Re: [PATCH 6.0 000/157] 6.0.13-rc1 review
Content-Language: en-US
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, Shuah Khan <skhan@linuxfoundation.org>
References: <20221212130934.337225088@linuxfoundation.org>
From: Shuah Khan <skhan@linuxfoundation.org>
In-Reply-To: <20221212130934.337225088@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 12/12/22 06:15, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.0.13 release.
> There are 157 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 14 Dec 2022 13:08:57 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.0.13-rc1.gz
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

