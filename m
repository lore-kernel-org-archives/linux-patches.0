Received: from mail-io1-f48.google.com (mail-io1-f48.google.com [209.85.166.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 761B2BA31
	for <patches@lists.linux.dev>; Mon, 13 Feb 2023 23:31:31 +0000 (UTC)
Received: by mail-io1-f48.google.com with SMTP id a10so5150075iod.0
        for <patches@lists.linux.dev>; Mon, 13 Feb 2023 15:31:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=jGmzuGPn9I/FZ09CbZiNPtzTdFC7E/SYikD0S6LcbdQ=;
        b=gdA8Fg229Zr8Gi+sF6aRnk6TS9c9zyZ2tFpA5dJJE9mNcXQSIIY2WM6BD3q+hP0RTD
         nqHJBgPhJnT5m0iujz1Xuv0TQGvJQRx4qFw0ynhNOHBaEg2bWOJdJwQBZVk4cPvqa6yU
         KXa/Th/HaLkMwrtTxERCLzRwQO9dFzWKbwiRk=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=jGmzuGPn9I/FZ09CbZiNPtzTdFC7E/SYikD0S6LcbdQ=;
        b=npTPMCemh/9uX5PaouWggzfO3tReWDG8fgLC0IpLKQvsszk1SCJcarLD3SPv9Dd8bH
         /+VajqRcQPVRebXhkt8pcAAOh36p95eoaJk0J43TVV+VMe+iK5g+uK8NGtygQLlaThfa
         UZmG8jqWJt1vo0mcz/mDeyF0tW5TncbswBTHDJ6qftzIXPlHn6E4GFyL4DbU4O6H21+9
         pIRHABvp4k9tg7isub94pWRTXLBILzT9hBhXUsxzSg0WH7xypICoLkgBCI2AqL/zOzmZ
         91fdZNwYabE05y0McDWYainJUD49WMMEIRzTWVOInEJynBYx4YmDff4+74/UUPQhDgZt
         EJ5A==
X-Gm-Message-State: AO0yUKUIM/Gd8n5On+nA4/w12sNniHhRQ2cGL2gYC6aKgkgz/03eyNjw
	BWCsohukkDPAmbja+CEbxpdFtA==
X-Google-Smtp-Source: AK7set/7TKUE2Tnu+YddFY7KD5UJ0yXLaaGtJxJEJm2w3ZTnV133eeBo/RnZmbbyfXBVLvpsfZB+RQ==
X-Received: by 2002:a6b:7f03:0:b0:716:8f6a:f480 with SMTP id l3-20020a6b7f03000000b007168f6af480mr222872ioq.0.1676331090473;
        Mon, 13 Feb 2023 15:31:30 -0800 (PST)
Received: from [192.168.1.128] ([38.15.45.1])
        by smtp.gmail.com with ESMTPSA id z4-20020a6b5c04000000b0073f2c68483esm1306208ioh.32.2023.02.13.15.31.29
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 13 Feb 2023 15:31:29 -0800 (PST)
Message-ID: <c08a57c1-49cc-e5e9-3b98-30c7f697818e@linuxfoundation.org>
Date: Mon, 13 Feb 2023 16:31:28 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.1
Subject: Re: [PATCH 5.15 00/67] 5.15.94-rc1 review
Content-Language: en-US
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, Shuah Khan <skhan@linuxfoundation.org>
References: <20230213144732.336342050@linuxfoundation.org>
From: Shuah Khan <skhan@linuxfoundation.org>
In-Reply-To: <20230213144732.336342050@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 2/13/23 07:48, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.94 release.
> There are 67 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 15 Feb 2023 14:46:51 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.94-rc1.gz
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
