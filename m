Received: from mail-io1-f51.google.com (mail-io1-f51.google.com [209.85.166.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AEA5F7F
	for <patches@lists.linux.dev>; Tue, 13 Dec 2022 00:06:58 +0000 (UTC)
Received: by mail-io1-f51.google.com with SMTP id b192so907682iof.8
        for <patches@lists.linux.dev>; Mon, 12 Dec 2022 16:06:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=2Db+FmifZCy1uWygbKZTWCX5801TWsuTURiI7y3O7ac=;
        b=SFO+OJqeZ7SjtvEggmWRenFvL8o1MXYJKHBHTiFGu4uIpWQPDDgBbJTWbsMeYyGbQ/
         jZP3HGDcUZI+IAyHsqPXC0QxOzp+GuxRvcrG/L2dV4Brb8i4dZKqoQDx6rf6mXyrfdvf
         +3G5EutTiycaWhR75OfqVSv3d7Etxegvdyzyg=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=2Db+FmifZCy1uWygbKZTWCX5801TWsuTURiI7y3O7ac=;
        b=D5ldHv4HfELcM21ihrfGVij31Do3EwjWcu+pmDn48zhIGtolY8g1HbhMSaBlQZ9+Li
         jDLqJw+XTiasXiOzvB0wFUkb8VnQVnjKc2cnjy/ZkUGHVUrYYVp6DtreCW1tVA0mCSx/
         m+E/k0+JL6OvBRo2DHRuC1tvgRApQjHcDmPAyoOBBMFjCmtumFJXnD+o/Z1KkuWxk2JM
         3bXnX3u/8eo0+rjbYKTAY4wA92RkOrczcOyf5mkWfKpb3wjPHNL/qoGSaKPkLSXaF3WZ
         VKm0Bia0T4N9mdt87M4qQN6Z5ZuxpVYdr9ez+IM0B7n4z5wsdtq5ocIcouu6k7P2YAmg
         33Kg==
X-Gm-Message-State: ANoB5pnrJJuddoF128vsnlSr+XczsL00jtJjjjC7BGuJljtTyxOtfHgz
	DE8ZhtZqQZBLvSHf/IfCaaiG4g==
X-Google-Smtp-Source: AA0mqf6Kf2LiWQza+25hgRAHiDpLYJIOgT3Rvr//CUSIS7h8DDu9qdUvW7InhaNvZeMMyx5NLAhr9g==
X-Received: by 2002:a6b:4916:0:b0:6dd:7096:d9bc with SMTP id u22-20020a6b4916000000b006dd7096d9bcmr1909782iob.2.1670890017737;
        Mon, 12 Dec 2022 16:06:57 -0800 (PST)
Received: from [192.168.1.128] ([38.15.45.1])
        by smtp.gmail.com with ESMTPSA id k2-20020a0566022d8200b006ccc36c963fsm4671321iow.43.2022.12.12.16.06.56
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 12 Dec 2022 16:06:57 -0800 (PST)
Message-ID: <6494f1f7-33ce-05c6-df67-e5ec8e813611@linuxfoundation.org>
Date: Mon, 12 Dec 2022 17:06:56 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.2
Subject: Re: [PATCH 4.9 00/31] 4.9.336-rc1 review
Content-Language: en-US
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, Shuah Khan <skhan@linuxfoundation.org>
References: <20221212130909.943483205@linuxfoundation.org>
From: Shuah Khan <skhan@linuxfoundation.org>
In-Reply-To: <20221212130909.943483205@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 12/12/22 06:19, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.9.336 release.
> There are 31 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 14 Dec 2022 13:08:57 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.9.336-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.9.y
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
