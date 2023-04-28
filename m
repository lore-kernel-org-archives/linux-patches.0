Received: from mail-io1-f51.google.com (mail-io1-f51.google.com [209.85.166.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D9871AD43
	for <patches@lists.linux.dev>; Fri, 28 Apr 2023 22:29:45 +0000 (UTC)
Received: by mail-io1-f51.google.com with SMTP id ca18e2360f4ac-760f040ecccso2592239f.1
        for <patches@lists.linux.dev>; Fri, 28 Apr 2023 15:29:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google; t=1682720985; x=1685312985;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Boy6p0n8qLopxE4kdZMs85c3u3Z3pk27Cau95jGvS38=;
        b=AxqFfMerAPZPVYpMRAY46fKJ0DhoFUgnHw51zsrb3Lr04/brzvNQD2lwyf7EHhkRhO
         71pWYuMmQSV7fWbZkDJ84eNteBAP0FIfL+Cy8RBOAw8BCEMjZ+Xqz0pZhI/ZjRDNbgDk
         7ePe7hp1PfsngPr+igvxsenvTLmoLadU0+Kqs=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682720985; x=1685312985;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Boy6p0n8qLopxE4kdZMs85c3u3Z3pk27Cau95jGvS38=;
        b=hCgM/iFOhmxmnGMhVUzbGWWCcQidBDLyYc56QXSEsSE1YPXrNqmZ5+4vuvsTyJv5U4
         4AscGqrdlguxzB4CGt/JyuGIq6BgHy1g0mVaE/s8qQ9rvg+mpF50EmvNz82iO0aAf7LT
         zcSbpoI7+oP5eGBXQpoy4XdMVDrjxGYw9vm3O4WMqojl6CfG89CrLrGB3s7FslK/erU3
         0Z9rAmyEfeUa/TiXXuUApf6wDVKHPq6R6UU7LHL1IpExqKGU1HGDp54DMEa3r4wUeVA1
         GmYfqURlwKVCULcaXosCnRMBtgf0b7H61APPjYu8rRqI9YKVssvEId8LrxXzKFM7hBvZ
         NMug==
X-Gm-Message-State: AC+VfDyfgLXJoH8K1zhIy64swB8iuLeQ3JvfjEsSS8kGLNtUN/66d0jx
	ICKwV2WcG5yWgxDOd40enGZQ7g==
X-Google-Smtp-Source: ACHHUZ56M48aorTP2dAefEJ2HRjRwrNDGc4PTjENkU+4VXTA3Ni1PQiOEC1ZyKlgDJYCLfncGvoekQ==
X-Received: by 2002:a05:6e02:1ba7:b0:328:4634:7ed5 with SMTP id n7-20020a056e021ba700b0032846347ed5mr3871162ili.0.1682720984852;
        Fri, 28 Apr 2023 15:29:44 -0700 (PDT)
Received: from [192.168.1.128] ([38.15.45.1])
        by smtp.gmail.com with ESMTPSA id p5-20020a92c105000000b0032934416cc8sm344111ile.27.2023.04.28.15.29.44
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 28 Apr 2023 15:29:44 -0700 (PDT)
Message-ID: <e018355e-46ea-8d4e-4e24-201c717ff887@linuxfoundation.org>
Date: Fri, 28 Apr 2023 16:29:43 -0600
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Subject: Re: [PATCH 6.1 00/16] 6.1.27-rc1 review
Content-Language: en-US
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, Shuah Khan <skhan@linuxfoundation.org>
References: <20230428112040.063291126@linuxfoundation.org>
From: Shuah Khan <skhan@linuxfoundation.org>
In-Reply-To: <20230428112040.063291126@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 4/28/23 05:27, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.1.27 release.
> There are 16 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 30 Apr 2023 11:20:30 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.1.27-rc1.gz
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
