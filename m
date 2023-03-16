Received: from mail-il1-f172.google.com (mail-il1-f172.google.com [209.85.166.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 784337F
	for <patches@lists.linux.dev>; Thu, 16 Mar 2023 00:04:48 +0000 (UTC)
Received: by mail-il1-f172.google.com with SMTP id r4so104872ilt.8
        for <patches@lists.linux.dev>; Wed, 15 Mar 2023 17:04:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google; t=1678925087; x=1681517087;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=NcyC6TmL6Ixm3qQl5SnDBlbDITCyRh/BIzkGTxVX6dE=;
        b=JqeYTktBIO3BrZBbEHR652A3Z5I6XNVvEVx3JGn6aYhtp1iaMy+6FOlSJYUqb8DASW
         hrsnGnzkC54Gg6YAh5+XJUKqr9jVC9AZ0g+c8efHoa1zFxhix5FkuUVmGJGhL7uDmcvi
         xMl9aO8UnvfFG+OIgxXIwMOsO2oFpCH7V+Ka8=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678925087; x=1681517087;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=NcyC6TmL6Ixm3qQl5SnDBlbDITCyRh/BIzkGTxVX6dE=;
        b=epAp7TfAgqGSSbeNCuKKOMvl/uDx3i/BH+9aPoaxoorS/E2XwwBdy+uLgaqSKgkzDG
         ARjV+EFsld4Nx925dsZHwwadJACp0pi0etgUjpKwFEhl5ewr9r7W0HXVbDFerr+um+nC
         wRiPPwfejuUFAZ8/O+7yiPLVMyj9ldMqszKQJ4rYhcgyQXVQGTPa1gmHJvWD1pwoxy9b
         fxB7apBRDbYq/un3WaCRM6OKFbQMj3vs/F0jHZh1xsgMf5F3BlreSJKaXQMa7z+4lhCB
         KpAxJKuNV3JV4M8YMcr0bxX8PsaMNCXrDrNQUp3r9TgbmLebzg/jUEPgu2uKw0W3uFKq
         OB7A==
X-Gm-Message-State: AO0yUKWHRhvJ4UG+wyfvOgfueOapiiqbwoyX6nTDUAVP6Qn219F3+VfP
	rB2l8kVrq7x4RM5DeB2jz5jARw==
X-Google-Smtp-Source: AK7set//bjb9cEUAND1W9Tfd25P/NvhxXp9+AP7JRWZJcv8hCtN98oFPKouBJxqH5FL6VYjOUsGV3Q==
X-Received: by 2002:a92:d64f:0:b0:323:10c5:899e with SMTP id x15-20020a92d64f000000b0032310c5899emr2966919ilp.1.1678925087525;
        Wed, 15 Mar 2023 17:04:47 -0700 (PDT)
Received: from [192.168.1.128] ([38.15.45.1])
        by smtp.gmail.com with ESMTPSA id k15-20020a02cccf000000b003fe66427492sm2091514jaq.42.2023.03.15.17.04.46
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 15 Mar 2023 17:04:47 -0700 (PDT)
Message-ID: <dee1c998-cf70-8300-8360-0cc85bd0887f@linuxfoundation.org>
Date: Wed, 15 Mar 2023 18:04:46 -0600
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Subject: Re: [PATCH 4.19 00/39] 4.19.278-rc1 review
Content-Language: en-US
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, Shuah Khan <skhan@linuxfoundation.org>
References: <20230315115721.234756306@linuxfoundation.org>
From: Shuah Khan <skhan@linuxfoundation.org>
In-Reply-To: <20230315115721.234756306@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 3/15/23 06:12, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.19.278 release.
> There are 39 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 17 Mar 2023 11:57:10 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.278-rc1.gz
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

