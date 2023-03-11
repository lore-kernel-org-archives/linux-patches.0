Received: from mail-il1-f172.google.com (mail-il1-f172.google.com [209.85.166.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 49B25EA1
	for <patches@lists.linux.dev>; Sat, 11 Mar 2023 02:05:42 +0000 (UTC)
Received: by mail-il1-f172.google.com with SMTP id t1so4030499iln.8
        for <patches@lists.linux.dev>; Fri, 10 Mar 2023 18:05:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google; t=1678500341;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=hUthFU/x3amSOzypKTrD2gVEBI2imuppYYPDhIEirzA=;
        b=E3dpNBsUziGq4vwTAQRWdoT0OG2Ym6oUke+3ulKaQ2pxUjoQOEZrFYWK0UUxF+t9jz
         l3fuxqfBjkpZFkRQkK81FJR7cpZaf1soAwUY3uv89+TWfqTf11aY/SAUqzWxQfIm8ABM
         XfnlIn+jk6y+K3B2hDdb6pSyi8IxOwmb18ym0=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678500341;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=hUthFU/x3amSOzypKTrD2gVEBI2imuppYYPDhIEirzA=;
        b=iXbAUsVmyxfZPYIo3i3vTVOQEtXEksWe6qbmcOhBmh1lhgpuD5TNvbiiwPjPsom0fY
         Y7kMGy9/3ecrns4IpJlHYaGeprvwjwIqpT5uXiLRotuECoMdV+/nrsx+ZgNvzDU1Lmxy
         Eg3T/BgFrlJopm7iS/gsDbjoAgbCz5ie/sSAp0syRxYJqIZV2HKrb+QhikUUaSX84ghP
         zuk9QdFE17KZSkyWS+iz00geMiCXcTM0XoBT4+8MQtmsiuULoyEuxlMp5s262rqlot6p
         /IUH7erz2P72kn8opXjHCA0Tqc/bhRtEVpYXJpNOXUz2LkFADZx/kEuNcv9hRNoK8012
         PAIg==
X-Gm-Message-State: AO0yUKXBlMmsfKCwBfBmL3KV5JNKXKf8wxq57IxPOLyAmYhDtUXk0LCX
	GreYglUyroS07h+HulvvvbX+Kg==
X-Google-Smtp-Source: AK7set9G3bdapXBs2La7WWwmdEHcBJmTVLiAned0+h7dNql8Zi0bGVzBnDZObTrNNAiHc63hwGkhgw==
X-Received: by 2002:a92:d704:0:b0:317:943c:2280 with SMTP id m4-20020a92d704000000b00317943c2280mr2370619iln.0.1678500341309;
        Fri, 10 Mar 2023 18:05:41 -0800 (PST)
Received: from [192.168.1.128] ([38.15.45.1])
        by smtp.gmail.com with ESMTPSA id y8-20020a02ce88000000b003f8765183cesm474399jaq.87.2023.03.10.18.05.40
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 10 Mar 2023 18:05:40 -0800 (PST)
Message-ID: <1837c3ab-3136-463b-c379-43c1dd8b71c9@linuxfoundation.org>
Date: Fri, 10 Mar 2023 19:05:39 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.1
Subject: Re: [PATCH 5.4 000/357] 5.4.235-rc1 review
Content-Language: en-US
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, Shuah Khan <skhan@linuxfoundation.org>
References: <20230310133733.973883071@linuxfoundation.org>
From: Shuah Khan <skhan@linuxfoundation.org>
In-Reply-To: <20230310133733.973883071@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 3/10/23 06:34, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.235 release.
> There are 357 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 12 Mar 2023 13:36:38 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.235-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.4.y
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
