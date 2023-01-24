Received: from mail-il1-f178.google.com (mail-il1-f178.google.com [209.85.166.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7312D7C
	for <patches@lists.linux.dev>; Tue, 24 Jan 2023 01:14:04 +0000 (UTC)
Received: by mail-il1-f178.google.com with SMTP id i1so6843784ilu.8
        for <patches@lists.linux.dev>; Mon, 23 Jan 2023 17:14:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=CCYNt7URGQ7oBqyQbd15UA8FF1tOX4zB7NKqLZYoh5A=;
        b=E2Nhqn0AphtGOlrnMlqIO1XTLWnQ7WRtNvzoix1QfdqN9k5oRhXWRE1Cm3waPhsYyJ
         DqhhHSL7w+GSMIgoha11/5DyfGkXAyHJpcSH4VtXOJu+lnIbNygUyfdHRkqUWw3OxT1O
         8vB/N0GlGP0u8Avm3q4EfdOYEVACxKvCMQC6I=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=CCYNt7URGQ7oBqyQbd15UA8FF1tOX4zB7NKqLZYoh5A=;
        b=pKiDQJRx7C8VaCGHzSHktpTrXF+hxEgs5Nu2cSrgUG0VxoWPUJ0FQM8wBCUx78SiLQ
         kJZTqs2f+hEONwL5QDVzK/PosjfjG6pu7jaUwPhizgtbppELXRuSnOw/yphDVYBDRzg/
         KLo5jD7xtqSEAw7UnfBcT6c8EIMRce8QkyBSst4euzd6H4zIKuvmELx/lSXF6Z7q0Pb1
         ke2oKxGcKvJr1oCVa8yu18uzSDnNnzNAYSC7XWwj+dh9ie4313aUL1+F/da/S70+d/Jh
         25/gc2zDdzsfzYb+BIvVIf4oTop4i8bwF+eLa+xJILdEY4gLCZdtjSm2m5sTkWt8P7Og
         NjCQ==
X-Gm-Message-State: AFqh2kpfpdjK/y4vmrvdmZoyCNnbQoDuF2NS8AfoBF8GeFozVIH5c1ai
	jh1CEhpXvjsBb2yJa/moIyHcvw==
X-Google-Smtp-Source: AMrXdXtg98qKzdHR3i1QLOOQbNk98aeenCp4sK3eBWGTI5KRfYQw404brU68awG65sVmE4XWhrahyg==
X-Received: by 2002:a05:6e02:ed1:b0:30d:c502:a9de with SMTP id i17-20020a056e020ed100b0030dc502a9demr3957277ilk.2.1674522843415;
        Mon, 23 Jan 2023 17:14:03 -0800 (PST)
Received: from [192.168.1.128] ([38.15.45.1])
        by smtp.gmail.com with ESMTPSA id e32-20020a026d60000000b003a174bd44eesm236174jaf.81.2023.01.23.17.14.02
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 23 Jan 2023 17:14:02 -0800 (PST)
Message-ID: <d94fe79e-e7f2-a4e1-131a-715426e5d21e@linuxfoundation.org>
Date: Mon, 23 Jan 2023 18:14:01 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.2
Subject: Re: [PATCH 5.4 00/51] 5.4.230-rc2 review
Content-Language: en-US
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, Shuah Khan <skhan@linuxfoundation.org>
References: <20230123094907.292995722@linuxfoundation.org>
From: Shuah Khan <skhan@linuxfoundation.org>
In-Reply-To: <20230123094907.292995722@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 1/23/23 02:52, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.230 release.
> There are 51 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 25 Jan 2023 09:48:53 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.230-rc2.gz
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
