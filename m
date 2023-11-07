Received: from mail-io1-f46.google.com (mail-io1-f46.google.com [209.85.166.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 27E4C31A60
	for <patches@lists.linux.dev>; Tue,  7 Nov 2023 15:51:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="F/BOe24I"
Received: by mail-io1-f46.google.com with SMTP id ca18e2360f4ac-7a9447c828aso3374739f.1
        for <patches@lists.linux.dev>; Tue, 07 Nov 2023 07:51:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google; t=1699372294; x=1699977094; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=LAzxkP10OQDM9YOWOWaJJRML05AHefjemOIWQGzk+qI=;
        b=F/BOe24I71cnSDCXbKNOL99NH29pgTANkTfv1U7PbnzagKldXwCbcWdGeXN2gM6gTs
         Fl2G8MiQewaBrjP0oNdiCpNERFfRZ8N0ImjpUpQIcyN/u6s1ZnyPxM+k07D+orEU1A8G
         MnkTbR5p0/Uf+umU+/UALmeZTj70NTvftYF/s=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1699372294; x=1699977094;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=LAzxkP10OQDM9YOWOWaJJRML05AHefjemOIWQGzk+qI=;
        b=MVpakFfmZUeRRrAcJb2l1cImIXTRnXyAEWSflEzzWSDvZlfhEegJQNCc/AXTtKOk8G
         V5i8yo7ysTmW4z8FOvzx614sWjsoEHaa0KWCY2vDpx8oE9wM0VzAFqA3t3AO9z1qzvrS
         RI+8B8S5dOdUhxbMRY9Goj/bCYtU6UIyNcFXSxhY/ThHpIHMmq58eiLX6B2MngUYA2Gt
         b0lDh5CeljRnivHHlgNiu2kTL33fsAonUQEqn6dhLqoxrilatrkg01wEhwNIeHb8ybBo
         iOgAVa5sEtlg+lzxSQSBHikXeb1ns+dS0LWMlrLjI1f7DklDAyi4a4FJtxPWiC4I2Zq8
         STrQ==
X-Gm-Message-State: AOJu0YyAKCd2WvCXpkRQIDsnJQdz7QEB59+ZIKPnRfx7Wi+0fn0aU2wr
	WZQ9UTrG73jMBWjVEFPo3I/lzA==
X-Google-Smtp-Source: AGHT+IGv36r+ShQUykCndJzyqw+Ib+370gxiK90Ut8FZCZBzlh3wm4c/To1ndWM2b46rlfXQKkxINA==
X-Received: by 2002:a5e:a80c:0:b0:792:8011:22f with SMTP id c12-20020a5ea80c000000b007928011022fmr36342555ioa.0.1699372294206;
        Tue, 07 Nov 2023 07:51:34 -0800 (PST)
Received: from [192.168.1.128] ([38.175.170.29])
        by smtp.gmail.com with ESMTPSA id m8-20020a6b7f48000000b007a278f16881sm2899101ioq.42.2023.11.07.07.51.33
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 07 Nov 2023 07:51:33 -0800 (PST)
Message-ID: <ae5bf8c4-23b8-43cc-b6bb-ce89076fef4c@linuxfoundation.org>
Date: Tue, 7 Nov 2023 08:51:32 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 5.4 00/74] 5.4.260-rc1 review
Content-Language: en-US
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org, Shuah Khan <skhan@linuxfoundation.org>
References: <20231106130301.687882731@linuxfoundation.org>
From: Shuah Khan <skhan@linuxfoundation.org>
In-Reply-To: <20231106130301.687882731@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 11/6/23 06:03, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.260 release.
> There are 74 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 08 Nov 2023 13:02:46 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.260-rc1.gz
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
