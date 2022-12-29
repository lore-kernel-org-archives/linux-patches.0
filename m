Received: from mail-io1-f53.google.com (mail-io1-f53.google.com [209.85.166.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EBA3B8C14
	for <patches@lists.linux.dev>; Thu, 29 Dec 2022 23:24:57 +0000 (UTC)
Received: by mail-io1-f53.google.com with SMTP id g20so10406535iob.2
        for <patches@lists.linux.dev>; Thu, 29 Dec 2022 15:24:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=j5M1qEcQ5hCYalkUD046W/PZUv5GPJc2CtY9IYHcJB4=;
        b=GPNV4dpaVxP9zTf+BkpTVlxnIJ/f72GDPO6A4JPyT+83cUiqXMxxB35FAembUAsyUf
         +VDfmCVPAlHOOgLGnLRuxoY77abUw0MgvYh78toiFQmagMhrHiW2aFSm+Ed2AZFMXgWl
         RoUHeQ96WEfPDQXU8bTwrOX0Pg/sOL6774W7w=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=j5M1qEcQ5hCYalkUD046W/PZUv5GPJc2CtY9IYHcJB4=;
        b=LO0qX/qSCdD0OZtfhKYvHfWvL/WVND3BQzORYjVnHAh3y9mikYMHtX7b4yPps9ECzY
         qdC+03JWOwXiF9pmQlYKts33tdIpBFnhpC4G5mnqgTzyqPCXMyp6PNb8r2UhHRJ1j+zk
         JvXUE+PVr5PPAAmnJZ96Kb1gs0kmoJ7Bfb2Qn/3E0ynet1kfuKG0qNvAyr6tX6a1sQQm
         kDT1cmMU9F1ZQYePjrFUJmJgtVfE3AWM9vwsW/aqsE66baCRyvUWoe1F4dgYHF4QC2Yp
         CupWGlWyF8ioukaPEinXcUUuo0IP88WkTuLOmbCtA8T4l9ohxHJSQSkyz7FBpbJtJ/qa
         LDAg==
X-Gm-Message-State: AFqh2kovhBNiHH2Ac99XHJMWLbSj/UKv8I5AbELlS8diWmR0ul/GxSmZ
	6OloOLT1fV6BGko2juqFzCKltA==
X-Google-Smtp-Source: AMrXdXuPlOK6xinbIDs6LEugKfP+/pOjZA22v2dJAt+MghoMvVAdIGho0uLd2B7G4BnDyTOvic0f0Q==
X-Received: by 2002:a6b:410f:0:b0:6e2:d6ec:21f8 with SMTP id n15-20020a6b410f000000b006e2d6ec21f8mr4265883ioa.2.1672356297026;
        Thu, 29 Dec 2022 15:24:57 -0800 (PST)
Received: from [192.168.1.128] ([38.15.45.1])
        by smtp.gmail.com with ESMTPSA id b2-20020a029582000000b0038308683a09sm6536106jai.143.2022.12.29.15.24.55
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 29 Dec 2022 15:24:56 -0800 (PST)
Message-ID: <528f1b8f-927b-0c9f-8558-6d814aeca8f9@linuxfoundation.org>
Date: Thu, 29 Dec 2022 16:24:55 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.2
Subject: Re: [PATCH 6.0 0000/1073] 6.0.16-rc1 review
Content-Language: en-US
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, Shuah Khan <skhan@linuxfoundation.org>
References: <20221228144328.162723588@linuxfoundation.org>
From: Shuah Khan <skhan@linuxfoundation.org>
In-Reply-To: <20221228144328.162723588@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 12/28/22 07:26, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.0.16 release.
> There are 1073 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 30 Dec 2022 14:41:34 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.0.16-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.0.y
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
