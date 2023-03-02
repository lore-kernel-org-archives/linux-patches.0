Received: from mail-il1-f176.google.com (mail-il1-f176.google.com [209.85.166.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 734D1EA1
	for <patches@lists.linux.dev>; Thu,  2 Mar 2023 01:50:20 +0000 (UTC)
Received: by mail-il1-f176.google.com with SMTP id b16so9621803iln.3
        for <patches@lists.linux.dev>; Wed, 01 Mar 2023 17:50:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google; t=1677721819;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=mF+UwKlmCIUoktbLWxpu0pnFzasKfLV4sm8o38QfDX0=;
        b=WCGqRtES4FcHT9mXRPgt9cYM//xPtt2BjatZYD74NQCcti2ydDnknqmXluXZCOE5uY
         BFZEj+UvfgbC2WBrHAXJ40MqRNzVzQc6jSVuRozi4v6rkXqaoCA1/nZDQplM0RbiCORG
         ryzT0wTvUuakaGTCk6edop+/nfz3c3WgW0XIQ=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1677721819;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=mF+UwKlmCIUoktbLWxpu0pnFzasKfLV4sm8o38QfDX0=;
        b=WIIyCMO3rJx365pMFUEPDgZNojweV31T6N8XExrLTIcXQkCddiCRPm+/rcKl5ojc6J
         9LIdh+YYT24PQfgT4qCcoNUirPE3bj5I+DkmXGxC+qxBXtU9q7u8dIWT2f8sitDdhPkn
         KpxGLCxDvoQ191oxXlot2bMD4rDuWmHuBRhpPCVlDjfZQszLNplxDmgOQQvNj/SSqerx
         OweLjS+MqgzCA+J9Hik8uU8eVMaTSwd+I3t9hYdECx71BzIuGLJQp22KNFglZPt5TjRw
         zRVPTP0lVIt0WYk0x0Hcl8Q2dqLO2Lp8iUagTb7XLd4ryATBfGaw/4M0SQflj1ZgRWLt
         j6gA==
X-Gm-Message-State: AO0yUKWUuXdGDujf5J+K0gyU1rqjEFSL9pCz5/o+AJkInwnlna+df5GQ
	B5/RTGQrtHgZ7L08TChfaRc/7g==
X-Google-Smtp-Source: AK7set/mZA34+COiGh8CSis1f5GXLDYkgGpBiGLxdA8/3DdMo4BMIz5aUORczQaONBZ9sNNSSWhD+A==
X-Received: by 2002:a92:8749:0:b0:317:2ccd:3896 with SMTP id d9-20020a928749000000b003172ccd3896mr5075355ilm.3.1677721819453;
        Wed, 01 Mar 2023 17:50:19 -0800 (PST)
Received: from [192.168.1.128] ([38.15.45.1])
        by smtp.gmail.com with ESMTPSA id m3-20020a02c883000000b003bada974a13sm4331061jao.165.2023.03.01.17.50.18
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 01 Mar 2023 17:50:18 -0800 (PST)
Message-ID: <61575aec-ecc7-0a20-3e5e-6f38df6cded8@linuxfoundation.org>
Date: Wed, 1 Mar 2023 18:50:17 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.1
Subject: Re: [PATCH 5.4 00/13] 5.4.234-rc1 review
Content-Language: en-US
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, Shuah Khan <skhan@linuxfoundation.org>
References: <20230301180651.177668495@linuxfoundation.org>
From: Shuah Khan <skhan@linuxfoundation.org>
In-Reply-To: <20230301180651.177668495@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 3/1/23 11:07, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.234 release.
> There are 13 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 03 Mar 2023 18:06:43 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.234-rc1.gz
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
