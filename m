Received: from mail-il1-f169.google.com (mail-il1-f169.google.com [209.85.166.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD9C9156C3
	for <patches@lists.linux.dev>; Mon, 11 Sep 2023 20:09:45 +0000 (UTC)
Received: by mail-il1-f169.google.com with SMTP id e9e14a558f8ab-34f5357cca7so4499875ab.1
        for <patches@lists.linux.dev>; Mon, 11 Sep 2023 13:09:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google; t=1694462985; x=1695067785; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=n6Z8kcoZfdqrD4VAC+its9hMTOja8wL+SBN6X63Af10=;
        b=ghaazdKLiaSW1Jpur7Q5DwpNxlJomUE4IafxlJHJa+7OHPWtYfQkl5ftrZzyh2dh5r
         iy5YdAPn8/3ZYGh0/9F21Y6r8b5EfbTtT5GgBz8lh0dxZJ0z6ck/MBlIGB3qqOkv4CV+
         g0pWsZQayUqjTl86TY/hrrHoE6m9IA0wWPh+U=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1694462985; x=1695067785;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=n6Z8kcoZfdqrD4VAC+its9hMTOja8wL+SBN6X63Af10=;
        b=s5bFburnGz3+8QvkHJ4Wap6WNQRFOx8rR83mbzbUEV2cBFHebO04WD4htpc11fsriU
         ob40lKw9svG6KxooNEPfQn8d8k5VJ3TSwbe4dA8xp2Hv6gDR2flr/hmLW8EGZoC0O62M
         srmcYwq0YaK9g9+fcGFdyAjyw0lHbQyRLZxlpmFy7S2hsHpTO7+YAdKZ8AXOH9325qkl
         UoQEzlUDKK3zPvj8Ft0T5Nf+VXRPH4an304WWZsNhNzeBgnTQKl6t3Du14xdGYfkDqyn
         X7kaDHQLC1r1ot2TlnU8jaOa5J25O3OzIe8j1YYDfjnlQ0YMIo3ULqmOtzs7Elog2em2
         RLew==
X-Gm-Message-State: AOJu0Yz9boK7PBbDhelWAVoEFwiXpcQusEOaV+9btlAQAyzPcDdv7A3O
	bRKqvghSF/D3AgLS26cqsnFldA==
X-Google-Smtp-Source: AGHT+IHl7dEk3Usw2lbA4i6Du78JPOPDv+eJN2JrRzjfuzVVE4YHa04mCVuFcDZEenbGJoV25HF5dA==
X-Received: by 2002:a92:dc05:0:b0:349:983c:4940 with SMTP id t5-20020a92dc05000000b00349983c4940mr10587304iln.1.1694462984855;
        Mon, 11 Sep 2023 13:09:44 -0700 (PDT)
Received: from [192.168.1.128] ([38.15.45.1])
        by smtp.gmail.com with ESMTPSA id q10-20020a056e02078a00b0034901a2f693sm2575834ils.27.2023.09.11.13.09.44
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 11 Sep 2023 13:09:44 -0700 (PDT)
Message-ID: <a0dfa3d3-da47-56f2-b486-c9d607f9749e@linuxfoundation.org>
Date: Mon, 11 Sep 2023 14:09:43 -0600
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.15.0
Subject: Re: [PATCH 6.4 000/737] 6.4.16-rc1 review
Content-Language: en-US
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org, Shuah Khan <skhan@linuxfoundation.org>
References: <20230911134650.286315610@linuxfoundation.org>
From: Shuah Khan <skhan@linuxfoundation.org>
In-Reply-To: <20230911134650.286315610@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 9/11/23 07:37, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.4.16 release.
> There are 737 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 13 Sep 2023 13:44:56 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.4.16-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.4.y
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
