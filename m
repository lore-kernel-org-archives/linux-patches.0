Received: from mail-il1-f177.google.com (mail-il1-f177.google.com [209.85.166.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC5107F
	for <patches@lists.linux.dev>; Tue, 13 Dec 2022 00:04:35 +0000 (UTC)
Received: by mail-il1-f177.google.com with SMTP id z18so4254618ils.3
        for <patches@lists.linux.dev>; Mon, 12 Dec 2022 16:04:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=4RP/Ecj2nDWpVcmR1nLBO6gBmUtk2NUcP+9/dUfOyQM=;
        b=HtyBpSqe+EZt7+aZWbhBFJo9Q4WUMRSya8P7RQISXYsIPa+70t51V/+GXrLzcBRVow
         9bVTJwbsGKEjt5ahoWkDQyIM3pzxTiruGw6349snvgcMJcjWIwUUflFmJqpXWpIt6E12
         s/oQaMi+WMslI0YP0dE6EGQysIOdlaGhFKXqU=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=4RP/Ecj2nDWpVcmR1nLBO6gBmUtk2NUcP+9/dUfOyQM=;
        b=iwWlsNCnmLpQ9KXN0ltR39+DUuHh/Mhp4WdXQA8oSPaLcTkcVpJSA0aP0qZG1x12PY
         6MZBfdYhT88hwFkt7bz/TC1qmqfAMtnvhAE2z3eQOuK9G0jBgFRrXvNfnYXGbA/bddtP
         Fqxl8XaFt+16MRhqMlV7bzUNDLy/iaXrWIArqozrUWaRW86D20cgM5UrZEHh6NW6NTpr
         hLl34sB6uT2lCBh9Zx6BDjlUecJj0j4NIHTOf/pmsUZVT9xPal/w8pL11vHZ6zPH2ihz
         qPn0A1XuwwuIp47lN4arpUbRMv24xHcwKj6PnLoUppLlI/nE6IU7rGU2OSGWljYV2ptz
         Y/pA==
X-Gm-Message-State: ANoB5plqrcsF48iehLU/QoFMkyw229/AydBItmy3VOx3foUJrTTLD4iP
	wQeMMCzFvYgcAE51Yz6ypTWE4g==
X-Google-Smtp-Source: AA0mqf6tC52YycsOvnOOmbC/iRb5JZAhdSms4tMO+wgiZ0ucy/7HuwcUo8JWFybuPUgc5FdoTevJPA==
X-Received: by 2002:a92:dc91:0:b0:304:c683:3c8a with SMTP id c17-20020a92dc91000000b00304c6833c8amr235836iln.3.1670889874868;
        Mon, 12 Dec 2022 16:04:34 -0800 (PST)
Received: from [192.168.1.128] ([38.15.45.1])
        by smtp.gmail.com with ESMTPSA id y17-20020a92c751000000b00304a715461esm2538021ilp.16.2022.12.12.16.04.33
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 12 Dec 2022 16:04:34 -0800 (PST)
Message-ID: <08a7e3e2-6a34-bc85-9d1f-58cc07b22429@linuxfoundation.org>
Date: Mon, 12 Dec 2022 17:04:33 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.2
Subject: Re: [PATCH 4.19 00/49] 4.19.269-rc1 review
Content-Language: en-US
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, Shuah Khan <skhan@linuxfoundation.org>
References: <20221212130913.666185567@linuxfoundation.org>
From: Shuah Khan <skhan@linuxfoundation.org>
In-Reply-To: <20221212130913.666185567@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 12/12/22 06:18, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.19.269 release.
> There are 49 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 14 Dec 2022 13:08:57 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.269-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.19.y
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
