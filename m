Received: from mail-io1-f50.google.com (mail-io1-f50.google.com [209.85.166.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F1D85A28
	for <patches@lists.linux.dev>; Tue, 20 Dec 2022 00:19:06 +0000 (UTC)
Received: by mail-io1-f50.google.com with SMTP id p6so5592833iod.13
        for <patches@lists.linux.dev>; Mon, 19 Dec 2022 16:19:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=gc3hWzYWnwxE0KxM3PiNn4ggv+l8ysEvnTXP4M8gEZQ=;
        b=YcWERSawby9HLFUaDofFiqJzjtWuQQAV8Bl+fepedaQ1d9EZ70C9z8QkDjUBQB+PNU
         VZC4qDjIwalMd7bTkNNCQz7SrhRiptA87TzW1AfI2UsfgeqDuZ1nlUkuIOsvqYngyXyt
         5idFkzqWLBbDopUyg5fYV4Ych4BjZgtXS+VNs=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=gc3hWzYWnwxE0KxM3PiNn4ggv+l8ysEvnTXP4M8gEZQ=;
        b=aOiUHrF/r1gMCg9X8DjCjydxOqPvD91U7zR8KXo+Qn+cpTVD4+/kBo1kRlYSTa8JO2
         UVQI3wv6rp7SE8aMKQLPoO3EsA3FhLROcyDjH1b7Rza48wlTMJUY2L+PFmtTqwAH2/mu
         bOmR8+dDdeCJv2+Ri77FtR0PVRaWAuxx+1GZyZb1fXdlSp0aTP5vGlunhDj2rE32pTte
         jrI7YKU/zucxo3yCS4Gh+dC7Km0lDzDxZMfMI9ZjFAqA0LOpamQoxJj6C/jQgYX1JLWw
         YitXuGj/dcKenLu2tLKHFuz61vvwBaktCNEhQrnSr1TnldfBOEipTjO8+x6twzFhFfBV
         C9ug==
X-Gm-Message-State: ANoB5plLNDuKI8n4Km2lItHY/SxjWKvYUWxcvNkNsdFBeHq+fYWpr6YW
	skR5E59IwuBeuZ7pitQzNdU9kg==
X-Google-Smtp-Source: AA0mqf6R8XlJpG3NHFCje5qyDPzOlJZOb1SXv7X2p+7WpO9xBGKQIDDqaHDJbW/l5NpYWHcWNYbyXw==
X-Received: by 2002:a6b:500e:0:b0:6e2:d3f7:3b60 with SMTP id e14-20020a6b500e000000b006e2d3f73b60mr4534593iob.2.1671495546007;
        Mon, 19 Dec 2022 16:19:06 -0800 (PST)
Received: from [192.168.1.128] ([38.15.45.1])
        by smtp.gmail.com with ESMTPSA id r2-20020a028802000000b0038a5b8d79basm3984074jai.106.2022.12.19.16.19.04
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 19 Dec 2022 16:19:05 -0800 (PST)
Message-ID: <74cad41d-e088-f8c3-3bda-d9e2843ae9f2@linuxfoundation.org>
Date: Mon, 19 Dec 2022 17:19:04 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.2
Subject: Re: [PATCH 5.15 00/17] 5.15.85-rc1 review
Content-Language: en-US
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, Shuah Khan <skhan@linuxfoundation.org>
References: <20221219182940.739981110@linuxfoundation.org>
From: Shuah Khan <skhan@linuxfoundation.org>
In-Reply-To: <20221219182940.739981110@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 12/19/22 12:24, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.85 release.
> There are 17 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 21 Dec 2022 18:29:31 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.85-rc1.gz
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
