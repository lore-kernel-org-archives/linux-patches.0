Received: from mail-io1-f54.google.com (mail-io1-f54.google.com [209.85.166.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C4DAF847C
	for <patches@lists.linux.dev>; Mon, 14 Nov 2022 20:20:48 +0000 (UTC)
Received: by mail-io1-f54.google.com with SMTP id p184so9082214iof.11
        for <patches@lists.linux.dev>; Mon, 14 Nov 2022 12:20:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=0nQMvLB5INQNmj5E/HGsA2eiB52DexTVVJe3m04ZfpA=;
        b=A22VrwqESF/t5YHz3RtHI5c8nxBisEmNDqZ+aI+eW1Yq1Ic21fd3d+8Q5WPpMWSqQM
         sP726UE30fXy8u7zepEOIhmDVY/JVB0G/mwcOobUw5uwU+uEnrKGbw5K16VnVR/GvK20
         4GRiEHFrRjhHsTxNVZkNqT92MR9W5KgBPu/10=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=0nQMvLB5INQNmj5E/HGsA2eiB52DexTVVJe3m04ZfpA=;
        b=oxWcCZVbKcMTZV5lPdZ4W3lxOr+LV0FWOCZKdoXT2CVq6DhgR5hP+po2zsxNpyUEGM
         7xjj7FJvowG9dChRppTOTW5lSy5+PsWIEXhNR6/9gTZEhOtEkjzRZ9JrO1Qm2sP9WtmC
         ay59KjxXxyiRehhrRPxtBZdFGkB9ZJGr3VESoIOug148zRGPWt9aYc1B32Kh1K15N4mT
         4lemt7o/+i1xF5wNpbmJNKCtrjTeKSZgoY2fk8yUUm9oC2pMXcg4OjCL6ieBSu0VX+Mu
         VmJvEFClEnrIXVE8pQ+nnZcAlIZSK25B2VmqOgzKlwkKqIzfjV428pJdEn2oXvOerqR9
         x6iw==
X-Gm-Message-State: ANoB5pnt5MDgvk9IyGaVoSqB5V8X6wtJudjofCCeAbPmP96wXaAYik6Z
	QvSFSpROLoLTNHWL/HrMX59IFA==
X-Google-Smtp-Source: AA0mqf45a4K8rpJsFCtIvLY6IJ/KooyuKaDOP6YHXNNeADL9vwk+q3ct9iaZw5xCdlHBiG7SnheWiA==
X-Received: by 2002:a02:a002:0:b0:376:e17:5eaf with SMTP id a2-20020a02a002000000b003760e175eafmr3080930jah.56.1668457247869;
        Mon, 14 Nov 2022 12:20:47 -0800 (PST)
Received: from [192.168.1.128] ([38.15.45.1])
        by smtp.gmail.com with ESMTPSA id e22-20020a0566380cd600b00363dfbb145asm3685533jak.30.2022.11.14.12.20.47
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 14 Nov 2022 12:20:47 -0800 (PST)
Message-ID: <0af677b8-a796-8fc8-c892-c588704732f6@linuxfoundation.org>
Date: Mon, 14 Nov 2022 13:20:46 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.2
Subject: Re: [PATCH 5.10 00/95] 5.10.155-rc1 review
Content-Language: en-US
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, Shuah Khan <skhan@linuxfoundation.org>
References: <20221114124442.530286937@linuxfoundation.org>
From: Shuah Khan <skhan@linuxfoundation.org>
In-Reply-To: <20221114124442.530286937@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 11/14/22 05:44, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.155 release.
> There are 95 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 16 Nov 2022 12:44:21 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.155-rc1.gz
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
