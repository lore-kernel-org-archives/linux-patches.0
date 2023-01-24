Received: from mail-il1-f173.google.com (mail-il1-f173.google.com [209.85.166.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 578477C
	for <patches@lists.linux.dev>; Tue, 24 Jan 2023 01:05:51 +0000 (UTC)
Received: by mail-il1-f173.google.com with SMTP id i17so6836030ila.9
        for <patches@lists.linux.dev>; Mon, 23 Jan 2023 17:05:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=s93ZKJi/eyAuvTHK5GSRYNYk2jtuLDZoKO9TCFwwVLQ=;
        b=Fg+kpPe+pheuW1fV4nyazNl4T2zPM0uBxI/8MU8sMc0Tq0v9TuEyQ1l6KUxXZW+pr8
         KLY2Xmir95LDiU57+//hr4EfiuEZeVpIYsRKRwV6VNQ8Dw8YAXhlbHXZ+sCj4qe1GKeJ
         6AdmbRXMVrR3NidbR9kVTigJY1KrhSaRuFKBo=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=s93ZKJi/eyAuvTHK5GSRYNYk2jtuLDZoKO9TCFwwVLQ=;
        b=mRwDXpudEZlETPrtv+KKirPrd0zHBSKJtiohM6jPPS11jyzcj0bXvGnJjJ7b2cKjLv
         KGv43szeQlO7H44/Y9dpV8DWRKjkY5qwERHWZqnm2t17yn/UzCYcEzALhQyx/WEn2q+8
         oaOO6MW/0dt8iPHlezmruGSAhf2GaQEYD7uK7iJjTs6cJHKO2t6tXOUSN4YdW77ZKr2y
         FAOmcmtE4i3COipMPY0ytJ3GA1Jxfs4xsyK+uUjOC6euAL0mQ/6ko3PBot/Sc+u82P6O
         xfxiSVF273qiufzBc9EvqCZvED70EG0G+bvDbw3nhX9KxxHq0MAyto3ksEfzIJhAybvT
         sw3Q==
X-Gm-Message-State: AO0yUKWBbOID7uy/rKMmDg4tvGmDncUCOMnZxs2dJFPAnbQJYIk4Vhq8
	EIXdo0Tir0munUEewhF0PCu8RQ==
X-Google-Smtp-Source: AK7set/40nqpQdiITXp6tF4Med5qx27LNaaTtVfCmd0pU4hd5Ibomho1jstcrmf9F/fBrhsUMyudrA==
X-Received: by 2002:a05:6e02:1184:b0:30f:a889:2145 with SMTP id y4-20020a056e02118400b0030fa8892145mr207150ili.2.1674522350241;
        Mon, 23 Jan 2023 17:05:50 -0800 (PST)
Received: from [192.168.1.128] ([38.15.45.1])
        by smtp.gmail.com with ESMTPSA id ce21-20020a0566381a9500b003a484df1652sm223150jab.55.2023.01.23.17.05.49
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 23 Jan 2023 17:05:49 -0800 (PST)
Message-ID: <6570e849-aedd-245f-163c-208a9bdfaf9d@linuxfoundation.org>
Date: Mon, 23 Jan 2023 18:05:48 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.2
Subject: Re: [PATCH 5.15 000/117] 5.15.90-rc2 review
Content-Language: en-US
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, Shuah Khan <skhan@linuxfoundation.org>
References: <20230123094918.977276664@linuxfoundation.org>
From: Shuah Khan <skhan@linuxfoundation.org>
In-Reply-To: <20230123094918.977276664@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 1/23/23 02:52, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.90 release.
> There are 117 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 25 Jan 2023 09:48:53 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.90-rc2.gz
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
