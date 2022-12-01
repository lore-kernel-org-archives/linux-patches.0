Received: from mail-io1-f50.google.com (mail-io1-f50.google.com [209.85.166.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4CF8DA28
	for <patches@lists.linux.dev>; Thu,  1 Dec 2022 01:00:02 +0000 (UTC)
Received: by mail-io1-f50.google.com with SMTP id y6so119215iof.9
        for <patches@lists.linux.dev>; Wed, 30 Nov 2022 17:00:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=dKpFb6/jlaeH7F8uv4T9zwnKFkBq6SD8TT8AzfJXYiw=;
        b=XpCF7ey4k8U6+L2Vy6Th3///Gdku7SiVUm+VDShkmzrHdgxlUSuyaPG0P6Oft7FeuL
         UphY9ztPeYjA0ZNrk463cTwV2gG72jUDpm6ro/BXLPT6n+ixeC7QGDTm6mrwK5dNWBoN
         Fw32i0GV/YzVhUJGdvpOdxe8VujMcicEUryLU=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=dKpFb6/jlaeH7F8uv4T9zwnKFkBq6SD8TT8AzfJXYiw=;
        b=xTv2UljblDqhyvkyIwsDEvD7d5sHIUsmbD70NH4sdmb6B/LDYentOTnDpx0Uep1K4k
         wamUcv9g3UvKdtEUg+SGER6U+sti7N/aiYzixl6XLzqerwTRvl97TKRlzoroTwXpo9iT
         n2Qs/nf1L9/GW2IJOlYotq/+vyHLzkyNo51G/fHW/dv5+a3GCYTRIeVVLHR5eTqH+Hvn
         HvXXxGe7joBg7ogjzfIUK8k5bYs4keCJUptxkow5CiOZbkz6ZgGn3G4gQhOs1OufjKjG
         T7WiHupkPycdvpVDCCsLVUN+beiCU8SJ6RG3fB600/wV8PAdngJYDoSnNr5/5j7cp3Th
         JBcw==
X-Gm-Message-State: ANoB5ploGz6+Ep5QdEn7UH32M7XdYexOaGkzRwFUo4hviy5KmIv7fP9j
	feCXt5/um5MOKEzCVF1Aj8/Xcg==
X-Google-Smtp-Source: AA0mqf41TEBl48geLh1CMchiDPpIgKNU9buz5NwCnp6hEefNdxo8QFhdXuKNdPLlQSHN0XL72OsBWA==
X-Received: by 2002:a05:6638:4410:b0:363:aec1:9a04 with SMTP id bp16-20020a056638441000b00363aec19a04mr30680397jab.78.1669856401180;
        Wed, 30 Nov 2022 17:00:01 -0800 (PST)
Received: from [192.168.1.128] ([38.15.45.1])
        by smtp.gmail.com with ESMTPSA id g20-20020a0566380bd400b003734c4d01d2sm1127219jad.61.2022.11.30.17.00.00
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 30 Nov 2022 17:00:00 -0800 (PST)
Message-ID: <45ea7769-42fc-a77b-c323-ca1c2f065f5d@linuxfoundation.org>
Date: Wed, 30 Nov 2022 17:59:59 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.2
Subject: Re: [PATCH 6.0 000/289] 6.0.11-rc1 review
Content-Language: en-US
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, Shuah Khan <skhan@linuxfoundation.org>
References: <20221130180544.105550592@linuxfoundation.org>
From: Shuah Khan <skhan@linuxfoundation.org>
In-Reply-To: <20221130180544.105550592@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 11/30/22 11:19, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.0.11 release.
> There are 289 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 02 Dec 2022 18:05:05 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.0.11-rc1.gz
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
