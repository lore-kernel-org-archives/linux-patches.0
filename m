Received: from mail-il1-f178.google.com (mail-il1-f178.google.com [209.85.166.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A7D6517C8
	for <patches@lists.linux.dev>; Tue, 13 Dec 2022 00:02:30 +0000 (UTC)
Received: by mail-il1-f178.google.com with SMTP id z9so4238052ilu.10
        for <patches@lists.linux.dev>; Mon, 12 Dec 2022 16:02:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=G1HKnkT2H1E5a9tRBc8kxtai75M4h/8ugB4lCGNkHko=;
        b=A7BikBRZ71ECNAJ/PTktlFLR8u+Jzt1pNlpgn05vR6UHQRq63Brxjq5ncggdt7z30K
         YheQV0pNHlLTcqhdvRAmpX9mDodYLBNB8MDHJ3ZNvjwKsjm/NVmna1iQ8svKzyiCU0FC
         maj4g3dqA8U92+H8hU7kSGTutFULGeMyXrbWY=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=G1HKnkT2H1E5a9tRBc8kxtai75M4h/8ugB4lCGNkHko=;
        b=wlpl1FTUkEcGpHwMs3VT7SyBoUoa0ytRAHT+PV5/Qz9OTxru4x9VVA2uH7NJQ10w0L
         Qu9TUOyCzKztJU6sSZ5hfXQmyLbyb/qreXhJluMZxWB7SzT6Piq9NS1yUKPbKRWN+VLn
         Hqqecut+9kwCNOeNtfHrWSCgAc1lsddsOBGSpL940eLbz1WDmpBNGnlGndQwn7vyOhso
         sjqGMiSiiNbUpGKnk9s03L6Ypv+nE/UMp4IT+rUV5uXL/bNJuIThD66jiVWdnrMlXwfE
         R+wxuYThgI8S6EDh5FYUgQ7VaHKfEI0LO9/QEuHBKPuTLKgBABCSgmA/HOXyCfOue2wO
         aVgw==
X-Gm-Message-State: ANoB5pmCdBkcRy6KL617GogVJLLVc0elTUKlf2v1lOgR2yQjoNmuH8zh
	g0GK+heMnDV64LVl8Wyi2arASg==
X-Google-Smtp-Source: AA0mqf4Q0wuXsyq6H5PwttLVTJytpXdak9Dl5Wa69CZAdQ6IaPvaV4JBYQBSnQ0v4CoTfrpYvGh5Uw==
X-Received: by 2002:a92:cbd0:0:b0:300:4c9:f52f with SMTP id s16-20020a92cbd0000000b0030004c9f52fmr1955672ilq.0.1670889749621;
        Mon, 12 Dec 2022 16:02:29 -0800 (PST)
Received: from [192.168.1.128] ([38.15.45.1])
        by smtp.gmail.com with ESMTPSA id e18-20020a022112000000b0038a06a14b37sm362765jaa.103.2022.12.12.16.02.28
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 12 Dec 2022 16:02:28 -0800 (PST)
Message-ID: <cf988a45-cbd9-be77-3160-803bb4cb6c0a@linuxfoundation.org>
Date: Mon, 12 Dec 2022 17:02:27 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.2
Subject: Re: [PATCH 5.4 00/67] 5.4.227-rc1 review
Content-Language: en-US
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, Shuah Khan <skhan@linuxfoundation.org>
References: <20221212130917.599345531@linuxfoundation.org>
From: Shuah Khan <skhan@linuxfoundation.org>
In-Reply-To: <20221212130917.599345531@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 12/12/22 06:16, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.227 release.
> There are 67 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 14 Dec 2022 13:08:57 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.227-rc1.gz
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
