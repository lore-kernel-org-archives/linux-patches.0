Received: from mail-il1-f195.google.com (mail-il1-f195.google.com [209.85.166.195])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6261D1F186
	for <patches@lists.linux.dev>; Tue, 25 Jul 2023 20:20:09 +0000 (UTC)
Received: by mail-il1-f195.google.com with SMTP id e9e14a558f8ab-346434c7793so6282545ab.0
        for <patches@lists.linux.dev>; Tue, 25 Jul 2023 13:20:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google; t=1690316408; x=1690921208;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=40MUKgtjMMfWxSa/m74WsVfeVnmCY+9HBtHb/gRtD3k=;
        b=aPdJy/KYrpB1XhTlr6DMJqZCCkTnu8b3a/C9qI4YWs6X/whBQV1X+NT99p4A6I9IQQ
         5lbDQ8yCorF2rfB5z5MBvxKDh7JU8BlZhaRjH7E3Zh/vl+6DU6HkfXrmnOdMSKgun7Ki
         efNcYISrsnc7HHMPRFWKDm+9KU/wQtEqK5CJw=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1690316408; x=1690921208;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=40MUKgtjMMfWxSa/m74WsVfeVnmCY+9HBtHb/gRtD3k=;
        b=gcnu3LeA5s8VfBIOOJzSMtyoFgofHxV227Y7wbOi4Onj3kXaaSE7cW9Ew61toy9+Qj
         KYavmOxf8DZGKBa37iuGTOL4rEySIHZBRQLARld/CrEA657XKYUx6H9sZXDcHtZhm+uf
         e+Kca+JQfgJS+N9ri9AkoX8oQKaPs4WPs2AKQIZZmesXKNSw1Ze7d4Jb5eHRkJAJ+GHX
         dOI7uDHHf3BAe1284x2daJHq9XN3b+mTXiupY77v1r7HJvE82vSvDPIpoqJMY62Y9aPr
         iq9DLJhlnfgEc1BwoJ3AApbt8sxGsIIjbk6j3ZYUnM37EGpvvw/4NmvpXdz1NZvqOzhL
         wHbg==
X-Gm-Message-State: ABy/qLYaXY6d5f4uVdQEp1KRJYhHRr8OvIOKaCnY2drhe912n0xIuljz
	jrkQKIHWt/67epd+ntaAsTTQ2Q==
X-Google-Smtp-Source: APBJJlG9LQOgy8uDv7rRlMRdHE7p3FLYilMaLnvNpNxianS2g1xSQOyieZOcAxmswBTLqLKpFsDRyA==
X-Received: by 2002:a05:6602:8c9:b0:787:16ec:2699 with SMTP id h9-20020a05660208c900b0078716ec2699mr10077627ioz.2.1690316408223;
        Tue, 25 Jul 2023 13:20:08 -0700 (PDT)
Received: from [192.168.1.128] ([38.15.45.1])
        by smtp.gmail.com with ESMTPSA id r5-20020a5d9b85000000b00784315b7f86sm4423441iom.24.2023.07.25.13.20.07
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 25 Jul 2023 13:20:08 -0700 (PDT)
Message-ID: <fccc1892-36b3-fcf7-e82f-294cda335b04@linuxfoundation.org>
Date: Tue, 25 Jul 2023 14:20:07 -0600
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.13.0
Subject: Re: [PATCH 5.15 00/78] 5.15.123-rc1 review
Content-Language: en-US
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org, Shuah Khan <skhan@linuxfoundation.org>
References: <20230725104451.275227789@linuxfoundation.org>
From: Shuah Khan <skhan@linuxfoundation.org>
In-Reply-To: <20230725104451.275227789@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 7/25/23 04:45, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.123 release.
> There are 78 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 27 Jul 2023 10:44:26 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.123-rc1.gz
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

