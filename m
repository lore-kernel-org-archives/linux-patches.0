Received: from mail-io1-f54.google.com (mail-io1-f54.google.com [209.85.166.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 33E0F29AC
	for <patches@lists.linux.dev>; Mon, 30 Jan 2023 21:05:46 +0000 (UTC)
Received: by mail-io1-f54.google.com with SMTP id o1so1173020ioo.10
        for <patches@lists.linux.dev>; Mon, 30 Jan 2023 13:05:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=4Yg7svhVghi2FwAaCr1trqBzknfSY2QukGFpxxcVl4E=;
        b=f9+SVlIeCAtmftHkMq4LU3vuk8e7WGQi5yVTzJYW7GIeXW5odNP349fdMgOLBeMAzq
         LpyGiKEQxsA62QZixvCi7F0UKsw6cNfbTDejCwhigPK30f80OFwpMJauSISEgoTGq+XL
         ZHVgFIi8NBfcBm0j8mvwwPd2CuQFt0qkxqnfk=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=4Yg7svhVghi2FwAaCr1trqBzknfSY2QukGFpxxcVl4E=;
        b=gHAzavoaOraM3yZngzUDMAi8Pi67OFS1TvW1ZuKOSlnPpg2FK4bkNWbMsEVG2y6mNG
         Sebz1H4hRqTfj/LcYa49QAOrA1czlmAnejuVipjSJikq0fApj3S/kaMrg3zMprwoJVBj
         56G2lzUwn8kBoRoEzj/QaPgkYid6C+WtLc6W++rL3GtZdwnf6NbR6+FSZrm8ECwvfdXA
         32ayVumSt5QxtnHNz04s1kbgcyUHrrUmrT5pJXr48xi/4dakDVS7aL1pQWVYqe+19Nil
         DD7adRajs4fB4MTtofhx6myTMJXniKcYzIMt2VGVcglXzgsdGkUfGgRJkJ6BhMu5jZD7
         ufTg==
X-Gm-Message-State: AFqh2krq7T/TvlIheWnL1QRV4T86wY5qQGRk/8SnFcddPeoir2vsXcmr
	U5K3Bhq2BCVIULtMtv7rV614mg==
X-Google-Smtp-Source: AMrXdXvqFoVe6g5u6x5x85R35qxNQPoaSl/vg+4nY+i2nCJz1vJxa6EtsKvRTMZ++C2vGiMxXCQYSg==
X-Received: by 2002:a05:6602:341a:b0:704:d91f:9932 with SMTP id n26-20020a056602341a00b00704d91f9932mr8577267ioz.0.1675112745041;
        Mon, 30 Jan 2023 13:05:45 -0800 (PST)
Received: from [192.168.1.128] ([38.15.45.1])
        by smtp.gmail.com with ESMTPSA id c33-20020a023b21000000b003a068d00373sm4965945jaa.138.2023.01.30.13.05.43
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 30 Jan 2023 13:05:44 -0800 (PST)
Message-ID: <ea974e95-723f-23e1-364c-4d4a388fdd31@linuxfoundation.org>
Date: Mon, 30 Jan 2023 14:05:43 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.2
Subject: Re: [PATCH 6.1 000/313] 6.1.9-rc1 review
Content-Language: en-US
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, Shuah Khan <skhan@linuxfoundation.org>
References: <20230130134336.532886729@linuxfoundation.org>
From: Shuah Khan <skhan@linuxfoundation.org>
In-Reply-To: <20230130134336.532886729@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 1/30/23 06:47, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.1.9 release.
> There are 313 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 01 Feb 2023 13:42:39 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.1.9-rc1.gz
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
