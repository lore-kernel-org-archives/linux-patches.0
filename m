Received: from mail-io1-f53.google.com (mail-io1-f53.google.com [209.85.166.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 984031173D
	for <patches@lists.linux.dev>; Mon,  9 Oct 2023 22:54:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RHrngWuq"
Received: by mail-io1-f53.google.com with SMTP id ca18e2360f4ac-7748ca56133so46362239f.0
        for <patches@lists.linux.dev>; Mon, 09 Oct 2023 15:54:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google; t=1696892048; x=1697496848; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=0EQh9doZilTbZ+ByxkYuuzuJU5ao0hek1Op6tjYZFzE=;
        b=RHrngWuqf5Qp4izyRKUFzI27usM3w3Za52GpyGfliYiZ25wTL+8DRIoh+QgzT2aVxS
         p3P8MCD8tLHVz7uPntipJH9b0cqC/VZXsQWfk5EOMeuozb4393x33V4j/mZtaHGcKU4r
         CzxRAHaX4H+CagWbWMhCZn2906TYrGaDxIDCY=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1696892048; x=1697496848;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=0EQh9doZilTbZ+ByxkYuuzuJU5ao0hek1Op6tjYZFzE=;
        b=ZVJek4sCNjwUMA6KIOTgP7bOB7OBnYQzCOUHHzAdyjcLUi7bFMHcfJptEbzu13gI45
         T8lcHJu/WYyJ8UgZdV2ka2cBRetyoENNrU8gs+MJj3NgQ/sAi9mMG5wC7aEt59DdTnDA
         B584gLygfACzPuEjN3V+T+nikRwr8+W2VwvmWIlcabu4V5XO+U4mmI4JXSmszfUFEdRH
         S++hvD73z2oJMCEBiE3MzoE+7/3i6ctKXi/KvwPojkuWE6T6F/PbW4fbmLcWlg44BdYL
         3/zBkkl80O2CQjwOhsqCXEFbhvthgVsIuDEgTbj3W0LLE5cXKiH5Xva3YJxX2C7uyz3y
         t7dQ==
X-Gm-Message-State: AOJu0YyaU2vxtyJF1KDN1EkU+gEzDCqShw+Rs7hcTykNWLwDzgSn6t3E
	P1IgsZrrn+2FxXhBEReAiS3wxQ==
X-Google-Smtp-Source: AGHT+IFEhU2CfRiEAaBi1vp7RtQW0sdMdgV7ovI04oK4dlaTCLXISJC16mF+K4QHlHlJvaCebz6rKQ==
X-Received: by 2002:a05:6602:3a05:b0:792:6be4:3dcb with SMTP id by5-20020a0566023a0500b007926be43dcbmr16989954iob.2.1696892048599;
        Mon, 09 Oct 2023 15:54:08 -0700 (PDT)
Received: from [192.168.1.128] ([38.15.45.1])
        by smtp.gmail.com with ESMTPSA id g4-20020a0566380c4400b0043cbc7f9958sm2317085jal.110.2023.10.09.15.54.07
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 09 Oct 2023 15:54:08 -0700 (PDT)
Message-ID: <e591167b-c01c-4905-976c-c7e4f06c3379@linuxfoundation.org>
Date: Mon, 9 Oct 2023 16:54:07 -0600
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 5.15 00/75] 5.15.135-rc1 review
Content-Language: en-US
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org, Shuah Khan <skhan@linuxfoundation.org>
References: <20231009130111.200710898@linuxfoundation.org>
From: Shuah Khan <skhan@linuxfoundation.org>
In-Reply-To: <20231009130111.200710898@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 10/9/23 07:01, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.135 release.
> There are 75 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 11 Oct 2023 13:00:55 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.135-rc1.gz
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

