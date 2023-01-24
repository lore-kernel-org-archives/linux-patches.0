Received: from mail-io1-f43.google.com (mail-io1-f43.google.com [209.85.166.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 981A17C
	for <patches@lists.linux.dev>; Tue, 24 Jan 2023 01:16:22 +0000 (UTC)
Received: by mail-io1-f43.google.com with SMTP id e204so6452841iof.1
        for <patches@lists.linux.dev>; Mon, 23 Jan 2023 17:16:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=FlP1Icr443ARU66WHZYKa6EnbCHhRztF1yDkYHAN5ho=;
        b=aHx4hxvMpYlfOapQzoBDSKute05xDQx7HptuDJP/r1WwgWNfwvMiziSqNesxbnbFpX
         KutzBUKs5jFgoBYUEZnImcrFABnSxiu0yRiTNZlUIPEbCS3inQl5CM2gOBJXKq23fedy
         QCPRHYhABuF+qmYC9UX2TgYafaNL5mg9Vtp/k=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=FlP1Icr443ARU66WHZYKa6EnbCHhRztF1yDkYHAN5ho=;
        b=qKmfq1Wv8s9W0/kI1IJIHI2opmPlun+96jlO7o2dpcezRcjbHFF9Zfk6GWs989+sNI
         EHOqNnFSyI3jO090/G+m6GFIHFSDNC+3kocyfLMh6huHYhJm6AJ3ZsIxk9UaiCxrDFyl
         pslDGqTB9fOrGaN/wUpRjIMjjrHBcdWDcvB2IR2pOk8gmeM+ezEzLJ2ZSs0AbZNNqG2V
         LQf6hcP8g9ip0NGKS+bFa2F4fxVIw7+ooWXBgwdY+oTZHj/gZHplzldG2oYWu8i4YrDs
         00//N1dH+WQKHIZScGhakBMN61JnNuO7z57/WolERqQH/nkQs17znjj2irDWIIADOl4S
         gb3g==
X-Gm-Message-State: AFqh2kqg3gCYUDDRtPaYKQp/1LBri7rzVJGfP2XLXi71U6U6MdZBqbiR
	OFDcfgESZ7Fm8bTTeGq7SCg/UQ==
X-Google-Smtp-Source: AMrXdXvT9jkBefDTD0v8eXxzRc77DwIqHSKbNR6Au0zExGJ2TS6TH7tBS2kTICcEQjehHDO/DUGQvA==
X-Received: by 2002:a5d:9482:0:b0:6cc:8b29:9a73 with SMTP id v2-20020a5d9482000000b006cc8b299a73mr3423444ioj.1.1674522981496;
        Mon, 23 Jan 2023 17:16:21 -0800 (PST)
Received: from [192.168.1.128] ([38.15.45.1])
        by smtp.gmail.com with ESMTPSA id h24-20020a02c4d8000000b003a432de0547sm217517jaj.163.2023.01.23.17.16.20
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 23 Jan 2023 17:16:20 -0800 (PST)
Message-ID: <17e7c853-c851-8f90-6ba0-e913c447c5de@linuxfoundation.org>
Date: Mon, 23 Jan 2023 18:16:19 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.2
Subject: Re: [PATCH 4.19 00/37] 4.19.271-rc1 review
Content-Language: en-US
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, Shuah Khan <skhan@linuxfoundation.org>
References: <20230122150219.557984692@linuxfoundation.org>
From: Shuah Khan <skhan@linuxfoundation.org>
In-Reply-To: <20230122150219.557984692@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 1/22/23 08:03, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.19.271 release.
> There are 37 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Tue, 24 Jan 2023 15:02:08 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.271-rc1.gz
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
