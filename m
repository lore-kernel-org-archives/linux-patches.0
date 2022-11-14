Received: from mail-io1-f49.google.com (mail-io1-f49.google.com [209.85.166.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 74C4A847C
	for <patches@lists.linux.dev>; Mon, 14 Nov 2022 20:19:27 +0000 (UTC)
Received: by mail-io1-f49.google.com with SMTP id b2so9073230iof.12
        for <patches@lists.linux.dev>; Mon, 14 Nov 2022 12:19:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Z2YfmStb+j2w+cuOjvg/lXsqwEFt/TTueE5RQ9JeBgg=;
        b=H+QgFHumJj5/td7mI/nGTC87xP/OdZnQnzNi72pJqAHqI6qXwXMnYL2jmvnT4ZcXPZ
         KJV8FWe1O7KCaQzVIA6JnlaI5AOca18wbYnpkUeure3/85h0UBKwJPeRqz4t6JJI3Wyk
         g7jqxdI0L1jncqO3gh2FZZVvZ5RUuW5jJoSa0=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Z2YfmStb+j2w+cuOjvg/lXsqwEFt/TTueE5RQ9JeBgg=;
        b=X8pTCMezTyu13LW3Jsmgq+l1kyWU9SCtvTfIh2uNkVF/4EU+fAYUpkvUFSciGb9Anm
         c8YGGhxCqY+tTC4yCYjZ3jF/g62Lm8NAZ/kIaZdqCoxOpFPGoi26M/GFgy/TCY7wi0EU
         5I+ObNjGvP2lL2kJX0UBjLxoVJ2P6Tju1yCpIaqJgbJjTGr/4it5/4nG5PAqjjh3v417
         PrP+QuWgSRMy6/vZ7c1Ye8APzcCYHW0qRiawHs1eqg5ynVpJB4cXCv8yS0bWT6+XmzBz
         UQZKzoijkp5nKHCYQasHDU3rJFzNxsuIqYZo1+ubvGEo/3Zo7eT38VKMu5oPwArk4fHu
         JOwg==
X-Gm-Message-State: ANoB5pk3XCwAZKvL94uATtKjKDUEYY0ruwPuDdOA58HlB10kBAGoR2ku
	HACI49Ew/kVFBq8P3I1kjjOJMA==
X-Google-Smtp-Source: AA0mqf7IWmybbQ3hDDXF/EtrgdKbnAtlBS6wfTFanMjopif9NV6MnHfXLrQ6d4993Q6+uUW6VPdTdA==
X-Received: by 2002:a6b:d21a:0:b0:6bc:b2ee:a61e with SMTP id q26-20020a6bd21a000000b006bcb2eea61emr6515299iob.195.1668457166502;
        Mon, 14 Nov 2022 12:19:26 -0800 (PST)
Received: from [192.168.1.128] ([38.15.45.1])
        by smtp.gmail.com with ESMTPSA id q25-20020a05663810d900b00375fbb8cbf6sm3224904jad.179.2022.11.14.12.19.25
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 14 Nov 2022 12:19:26 -0800 (PST)
Message-ID: <09133d01-b064-d811-16a6-49537286f7ba@linuxfoundation.org>
Date: Mon, 14 Nov 2022 13:19:25 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.2
Subject: Re: [PATCH 5.15 000/131] 5.15.79-rc1 review
Content-Language: en-US
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, Shuah Khan <skhan@linuxfoundation.org>
References: <20221114124448.729235104@linuxfoundation.org>
From: Shuah Khan <skhan@linuxfoundation.org>
In-Reply-To: <20221114124448.729235104@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 11/14/22 05:44, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.79 release.
> There are 131 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 16 Nov 2022 12:44:21 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.79-rc1.gz
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
