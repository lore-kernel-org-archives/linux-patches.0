Received: from mail-il1-f177.google.com (mail-il1-f177.google.com [209.85.166.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C98B110FF
	for <patches@lists.linux.dev>; Sat,  4 Feb 2023 00:53:58 +0000 (UTC)
Received: by mail-il1-f177.google.com with SMTP id x6so2778789ilv.7
        for <patches@lists.linux.dev>; Fri, 03 Feb 2023 16:53:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=BW4GZm3BU02bbcJ/C7il67qLf+uzYfRkVWlY4FUNarM=;
        b=bCcJlsKbLQm8nY6SlBhi0hNbah3pff5bXeEz0qiGAHpiYmooO8vkLono54CLVhYjnI
         4n0MtCxfM9gdDluGMvDT+7ogMVsVrIhDjBsyp9V/7Z/ex6LF9k3iRwIXguaYJxKc+z6P
         f8PM1BspLfrKhIMwK8z7iadoOG/sHzb8cDrN8=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=BW4GZm3BU02bbcJ/C7il67qLf+uzYfRkVWlY4FUNarM=;
        b=TcNlP5IPrrCyx7pnOFL8IiXxC1LhbaE/rwxG5t9cQWWUi4vUC2fZumhEaQGWQCEEOQ
         ksu45+96TxQAe4UZTsl+DsrmUc1VOAYgwAtYK5F/K70sxWjsm5Jw9bYixqz7TwR44uwv
         KHEqTCKoiuOg0MwsyptBDcY5ErnzqUldad6kCP6BdDKY1Q2tFzhKZzAGuchWQFW0/WXF
         xvQ0bcPQnTKWXEvOM34QeJ7kRK94RYKNZ1tD10bTu1GoCdtbdUQk29fRSGn7s0jyFjq3
         7/4pFaN8YAkVfGgWPr1njQ0Ri04zeBAneSAw0EBBkzYB1ZCwoeqw19n97+puwzOoqZno
         Q/Kg==
X-Gm-Message-State: AO0yUKW5bqcnqAM4RD4xR6Nk34Ii2Z3Grcr2oGacu+SYdsxfTVl27nDD
	I88pDKi8wPfv1U2OPnlRYSDHGg==
X-Google-Smtp-Source: AK7set/LMNVNMG8rFbs3SjKBLpsKgzIqoKGGqneev/Wr0wOz/EZjrkquoVEZyy6kOX934t0H470l9Q==
X-Received: by 2002:a92:c5b2:0:b0:310:9adc:e1bb with SMTP id r18-20020a92c5b2000000b003109adce1bbmr7603510ilt.0.1675472037792;
        Fri, 03 Feb 2023 16:53:57 -0800 (PST)
Received: from [192.168.1.128] ([38.15.45.1])
        by smtp.gmail.com with ESMTPSA id q9-20020a92d409000000b00310bde806e8sm1229395ilm.12.2023.02.03.16.53.56
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 03 Feb 2023 16:53:57 -0800 (PST)
Message-ID: <86f541e0-43eb-0926-c71c-c6a006cecded@linuxfoundation.org>
Date: Fri, 3 Feb 2023 17:53:56 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.2
Subject: Re: [PATCH 5.15 00/20] 5.15.92-rc1 review
Content-Language: en-US
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, Shuah Khan <skhan@linuxfoundation.org>
References: <20230203101007.985835823@linuxfoundation.org>
From: Shuah Khan <skhan@linuxfoundation.org>
In-Reply-To: <20230203101007.985835823@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 2/3/23 03:13, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.92 release.
> There are 20 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 05 Feb 2023 10:09:58 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.92-rc1.gz
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
