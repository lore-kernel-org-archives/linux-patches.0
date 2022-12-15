Received: from mail-il1-f175.google.com (mail-il1-f175.google.com [209.85.166.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CAFE86ABC
	for <patches@lists.linux.dev>; Thu, 15 Dec 2022 23:47:46 +0000 (UTC)
Received: by mail-il1-f175.google.com with SMTP id o8so503172ilo.1
        for <patches@lists.linux.dev>; Thu, 15 Dec 2022 15:47:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=DFWfpc//dWvOBKoGlK25YY9oGZBsORiw2JQ1wUsg5lc=;
        b=N6s9lkTDogylaJKCi1XDaYJmKaEOM2Fn/TVqq11p0J0Fh3m5hzFOI3YLYusuX3pVTv
         XCsQDXT+aa2hT39KqYmxza8gWpyQYRVRQPCvwBpeKCM0LYXqNZsShu/7ikVz5ZfbdGsY
         mZQsgOx720nBEvPAl25axuHmfJebrTuVsEJTs=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=DFWfpc//dWvOBKoGlK25YY9oGZBsORiw2JQ1wUsg5lc=;
        b=InAhVuhJmO12d452czW5gtXPzfYg5nnbfAX8sXzoo3MhxAT8eO5kwLkgj9DZsPjZL0
         Sf5ok+MdG//xGQL7jI2hETUIvHU92IS7y26IVf5dkMYdMtBYaPkjjLA+3uO3hK+GtO+s
         bmjN2kPlnkulwyT4n80L5H/Lf4MZt4VeHmIaVPzLNwWDOk6rBT/qHpqpjUqZeuWdpqSC
         bTOe2muLl049RLnssnyoDboqVaadjehEOX2llw9rL+M5wSwxe1Ihzyick+Z7Bt0VZxSa
         MJRS3vD9OZOcD+ctQzJzxvsJsILItbPUH/YnbZs31yU1M/ZVoIG+rARk5JW/juOj1ODr
         yOdg==
X-Gm-Message-State: ANoB5pm/giPISzShlKpPV8E32skGzSVkQDiwgfXAelumxEKeHd90TjeP
	Fa8fgfn34L5BuEfDQCmHPhXcrQ==
X-Google-Smtp-Source: AA0mqf7Y4g123//H+2jMnkADCNsb2ly/e/mDdRaYmJnK7xa6NHiwn/8UfLNbHkLtpX89p3XsNkSLdQ==
X-Received: by 2002:a92:dc91:0:b0:304:c683:3c8a with SMTP id c17-20020a92dc91000000b00304c6833c8amr1688440iln.3.1671148065751;
        Thu, 15 Dec 2022 15:47:45 -0800 (PST)
Received: from [192.168.1.128] ([38.15.45.1])
        by smtp.gmail.com with ESMTPSA id i14-20020a056e020ece00b002eb3b43cd63sm217054ilk.18.2022.12.15.15.47.44
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 15 Dec 2022 15:47:45 -0800 (PST)
Message-ID: <cfb586b0-c4f5-42fd-48db-0fa0082abdeb@linuxfoundation.org>
Date: Thu, 15 Dec 2022 16:47:44 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.2
Subject: Re: [PATCH 5.15 00/14] 5.15.84-rc1 review
Content-Language: en-US
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, Shuah Khan <skhan@linuxfoundation.org>
References: <20221215172906.338769943@linuxfoundation.org>
From: Shuah Khan <skhan@linuxfoundation.org>
In-Reply-To: <20221215172906.338769943@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 12/15/22 11:10, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.84 release.
> There are 14 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 17 Dec 2022 17:28:57 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.84-rc1.gz
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
