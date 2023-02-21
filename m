Received: from mail-io1-f43.google.com (mail-io1-f43.google.com [209.85.166.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 20070A937
	for <patches@lists.linux.dev>; Tue, 21 Feb 2023 23:50:04 +0000 (UTC)
Received: by mail-io1-f43.google.com with SMTP id t16so2917882iom.12
        for <patches@lists.linux.dev>; Tue, 21 Feb 2023 15:50:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google; t=1677023404;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=1SE3WgBQxvjkYymj/NUhgZ+JAGp+aqj6czJmw/PWko8=;
        b=FP7UZEXoeBE38eoP64poH/FonAGE3ltAyTyFfn1BCoBDuUfkCOWop440HPxadz7Olq
         c46Bkj2hO6cM6aIOKiV/pDIZUGt8qfJrJDHyf5nBgEU5DhzeCc02Qd8ICcTAkMIYiHtu
         Gf4GPidJZPt6eJBSL8JAdSuiLV8312nQlshuI=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1677023404;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=1SE3WgBQxvjkYymj/NUhgZ+JAGp+aqj6czJmw/PWko8=;
        b=0at+IK96rj2/R6GJ3MdmF/BOPxRbpvMMLYz7f5wp5+2gdu3hf6d56ThChWRi+5TkxU
         VqPGcLNx5xRcRqXLVYXqSOWGD7dp6Ds7agsdlzuItzDmukZUPnmMOy7MDrAbemq9ZBA2
         VKabfnLpUVItEMbfsePL5EeI9E/IJa2aD/CwrJ80OtcJYHhVTL7y4nwNRtAdsfNZCejJ
         psO8muzCoqb9VANrUv90k3W9/jD/sYG89Xb/HVLGVYs38J08RR81tr2jSsaLwsaRq4ok
         GPZGhMCqsIyxFpi8Z2K3iQ0jddd8u25URmyY1V3IwcLE8QdqLQVHiFahjUUiK3Vpui7X
         BeVg==
X-Gm-Message-State: AO0yUKWSsPRfnnxr3L25o95cO2tZYtcmWXzZ1f+ME+fHfwfZJnX/GPfJ
	Lz/uBxvwVUWxbUyzSYVzI8zKvg==
X-Google-Smtp-Source: AK7set9S1jt4zayqTgvWH1NpNpz27f+tc7rbAcPsF0lPV1c4riwA5ed662R9oRRFUaqWS0Yqb4L6aw==
X-Received: by 2002:a5d:9d81:0:b0:719:6a2:99d8 with SMTP id ay1-20020a5d9d81000000b0071906a299d8mr5560871iob.0.1677023404114;
        Tue, 21 Feb 2023 15:50:04 -0800 (PST)
Received: from [192.168.1.128] ([38.15.45.1])
        by smtp.gmail.com with ESMTPSA id e13-20020a5d8acd000000b0074564031d75sm518581iot.2.2023.02.21.15.50.03
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 21 Feb 2023 15:50:03 -0800 (PST)
Message-ID: <95e2761d-9bd9-836f-36b4-f519d218618d@linuxfoundation.org>
Date: Tue, 21 Feb 2023 16:50:01 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.1
Subject: Re: [PATCH 5.10 00/57] 5.10.169-rc1 review
Content-Language: en-US
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, Shuah Khan <skhan@linuxfoundation.org>
References: <20230220133549.360169435@linuxfoundation.org>
From: Shuah Khan <skhan@linuxfoundation.org>
In-Reply-To: <20230220133549.360169435@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 2/20/23 06:36, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.169 release.
> There are 57 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 22 Feb 2023 13:35:35 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.169-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.10.y
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
