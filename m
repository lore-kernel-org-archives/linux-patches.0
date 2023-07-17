Received: from mail-io1-f66.google.com (mail-io1-f66.google.com [209.85.166.66])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5CD0C253AC
	for <patches@lists.linux.dev>; Mon, 17 Jul 2023 20:46:17 +0000 (UTC)
Received: by mail-io1-f66.google.com with SMTP id ca18e2360f4ac-785ccd731a7so51666639f.0
        for <patches@lists.linux.dev>; Mon, 17 Jul 2023 13:46:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google; t=1689626776; x=1690231576;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=sxgp2mwlv26YsfH69lRjIjxF5UskIkFR70oX6AS3GJs=;
        b=Y61QceVKdQIJKsar7XFQV/CaFS90R4bca2nGRuvsmf1lRexRt9E9pWQ68rXcbKHE0Z
         y274BCu/HTQganiSFr9veh79rMHykmo7ZYKGZSttNRxjGHYsiW8dCce1pihg2kbN4R7I
         czKxf4r87JW3TUYg9u0vKJ/YCLP6fl2qwO7J8=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1689626776; x=1690231576;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=sxgp2mwlv26YsfH69lRjIjxF5UskIkFR70oX6AS3GJs=;
        b=c3cuyGXzhqzhy7JFdcIo6xGjBjvUCiacPFLRzKTUEi+UmSbb4LQhB57bBluLZDx56g
         OGxRNTSzEN39LJFwl+egbwiyheFJxlYm7Otd+bsp0cxhUfl7i+DN0XXn4edAiclA/7hq
         AjujvhJxBRrAybLsx8rOmWDWIi8yNJ6HewliQvvaxx1xplIqGg9mVGy1qL407V2Lvls2
         aJ/TRFFF/9ZSWAqe4pP0uxm1BBfyaONfEi8FGHf6xAuV9X8N//NIr42Bktk+Uzpj59mQ
         mKKZcfoJoXMVTFyV+4ElAwd3qOY1hKeVJVgiFp10ds5THmpX3QtlQeQwLAlj+WCwWQWM
         XR9A==
X-Gm-Message-State: ABy/qLZFK2eVaZqwnk4I4S7e35MDUjCKg/yE8x0gfXODVmtDH2FSPgNy
	0LJvFEst72YiX9btrt0zKMgSnA==
X-Google-Smtp-Source: APBJJlG6MFdMmtlsKtO6W9vfx8X+L1SO5x7xZilm+7U95hMbQfsDp+fQmSAqCf0o9C5oDSYSdCjL7A==
X-Received: by 2002:a92:2609:0:b0:346:10c5:2949 with SMTP id n9-20020a922609000000b0034610c52949mr647458ile.1.1689626776218;
        Mon, 17 Jul 2023 13:46:16 -0700 (PDT)
Received: from [192.168.1.128] ([38.15.45.1])
        by smtp.gmail.com with ESMTPSA id m7-20020a924b07000000b00345d2845c42sm181319ilg.57.2023.07.17.13.46.15
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 17 Jul 2023 13:46:15 -0700 (PDT)
Message-ID: <519168de-b559-186b-41d4-3659e0551c10@linuxfoundation.org>
Date: Mon, 17 Jul 2023 14:46:15 -0600
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.13.0
Subject: Re: [PATCH 6.1 000/591] 6.1.39-rc1 review
Content-Language: en-US
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org, Shuah Khan <skhan@linuxfoundation.org>
References: <20230716194923.861634455@linuxfoundation.org>
From: Shuah Khan <skhan@linuxfoundation.org>
In-Reply-To: <20230716194923.861634455@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 7/16/23 13:42, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.1.39 release.
> There are 591 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Tue, 18 Jul 2023 19:48:07 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.1.39-rc1.gz
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

