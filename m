Received: from mail-il1-f173.google.com (mail-il1-f173.google.com [209.85.166.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 253AB79C5
	for <patches@lists.linux.dev>; Mon, 21 Nov 2022 18:47:15 +0000 (UTC)
Received: by mail-il1-f173.google.com with SMTP id m15so6066001ilq.2
        for <patches@lists.linux.dev>; Mon, 21 Nov 2022 10:47:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=oqx3G0aXGGKxzB5h+omW+ABR290qnZ0zZzZxS6dxX28=;
        b=dnhn4t7g8QDQA/5jV3NNdfaym1An5H7lkbEBJVJPAN17tZq9RGwfVzKy5xMoA0zhAj
         NVutb96WUX3cI8JMt2bg5Th/npQ8F3NDSjTERF/zfrZma/YlBBhyawS4+T5TJ1ioxfEu
         y8qkcsxRh+DS/2Q+KxxCloF0kaSvUUo4W1SwY=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=oqx3G0aXGGKxzB5h+omW+ABR290qnZ0zZzZxS6dxX28=;
        b=XS3bfav0NdhZiSuwgwIQ/gJvDXYgJiZ9TXFaLzIB33J7nFgXi668Ejf+BE6t0AanyM
         Mqoyp4q5MPG3HvWNSH+zqGGvJQ5bHqCWSrh+F6eVIIxVsZ1QJlkRx8uBhVtTa1GIBVcM
         7phSraCXNSoDVwag3rUKyrsHfUyoYY02wYcskdN2ZPbZWK9qUjne71++n+koO3gNb64R
         AVnkRKQl4vlwZ3xjFy5Iu1j9UV/7Pap2BkzZRDVcVeaaeu6RUWVucihXaxbW9Y9bfzRJ
         V1IYkWfMCBrKSTNxE81r4pGdCqjPEHtN4gddKbjIfwg+pBOjOCQOaqfNNu5KwPLUrhul
         hKiw==
X-Gm-Message-State: ANoB5pnDJSxFS7FrZON3EdBJzu9RILPkjqK+qYWGlmd497UuMShkIURh
	fcPyZAGBXwHUzOfdghIRmgKiBw==
X-Google-Smtp-Source: AA0mqf4lsJtw36e5uQQ/wGXc0mvSHnGEjEglq+xdJJ8LMb4Nh33xrOSdGZR/AAXD4HASpmOvsYno+g==
X-Received: by 2002:a92:d5c2:0:b0:302:5de7:fcd4 with SMTP id d2-20020a92d5c2000000b003025de7fcd4mr862544ilq.191.1669056434115;
        Mon, 21 Nov 2022 10:47:14 -0800 (PST)
Received: from [192.168.1.128] ([38.15.45.1])
        by smtp.gmail.com with ESMTPSA id u12-20020a02c94c000000b0036374fc6523sm4457337jao.24.2022.11.21.10.47.12
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 21 Nov 2022 10:47:13 -0800 (PST)
Message-ID: <6f74f18b-0487-5eba-720d-5f4a4e47a8f0@linuxfoundation.org>
Date: Mon, 21 Nov 2022 11:47:12 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.2
Subject: Re: [PATCH 4.19 00/34] 4.19.266-rc1 review
Content-Language: en-US
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, Shuah Khan <skhan@linuxfoundation.org>
References: <20221121124150.886779344@linuxfoundation.org>
From: Shuah Khan <skhan@linuxfoundation.org>
In-Reply-To: <20221121124150.886779344@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 11/21/22 05:43, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.19.266 release.
> There are 34 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 23 Nov 2022 12:41:40 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.266-rc1.gz
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
