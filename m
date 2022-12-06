Received: from mail-il1-f173.google.com (mail-il1-f173.google.com [209.85.166.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD5BA190
	for <patches@lists.linux.dev>; Tue,  6 Dec 2022 02:30:07 +0000 (UTC)
Received: by mail-il1-f173.google.com with SMTP id s16so5961261iln.4
        for <patches@lists.linux.dev>; Mon, 05 Dec 2022 18:30:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=0pqEUgjR5nN+ZU9yzxhsnwV+CWIFbE/FOll9U7ZizPI=;
        b=Rd+pUgs0NIGj35SoS9mIYrWeKLjiDeN11e0N0S2DYICtT6o3TTzYUtFaZJcAzXSf25
         AkShzkb50ySjGmyraIPwM3VnVn7ycqGPBQ82f4Gev4wFKRJX+mUQeAXzBskPFT5J9Ehj
         G32CyrbBI0cUThvHPX4F22PMzdHnvaIQSEygk=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=0pqEUgjR5nN+ZU9yzxhsnwV+CWIFbE/FOll9U7ZizPI=;
        b=A1Dq0GuKgSVhEDEbz9AEsSr0OrzVMFbHNWiRyUSUTYA1+4Lyf/WwynfWIvQxDLOJHb
         DGbxRSYgyvYdAqfDkhPyeN3iroBoX8uPiWSstMpaOeOxT+wQWeGp5tS7AxW5alRgpdhm
         t6h+f96F/cHCr9Vjv1lijaytuqbieeRdoNDeFkPhPCnuLVqINglcW0qUwgIzvGRqKEcZ
         LoVphE1j2q4cwuiyP5TF6/CK7AQz11XcGtPDdp6riazyofizbeHZUyUgN9LcR3xTrbrp
         f7o7vnJps2B5vTqB8pbVTDr2l6s7Pfgh2A1rdDaPAEzQrLW9ptvWPnrIO0IeP9uNjb6A
         BRig==
X-Gm-Message-State: ANoB5pkJ6mjBEOS1qc0haKlNC/P2S64S1zVjpGCWCmzrf1SyGrFINOVY
	6T6lcjAsjyvCpf+KqtgiIWVs8A==
X-Google-Smtp-Source: AA0mqf6M/hERRtaLya+u8H4PosDaxH+NSVg7ezwlG7TsjQ0Hg40pg7wbeWFtQkMjhU639DqaQL2QmQ==
X-Received: by 2002:a92:d312:0:b0:302:ab3b:82a2 with SMTP id x18-20020a92d312000000b00302ab3b82a2mr31318017ila.59.1670293806786;
        Mon, 05 Dec 2022 18:30:06 -0800 (PST)
Received: from [192.168.1.128] ([38.15.45.1])
        by smtp.gmail.com with ESMTPSA id c12-20020a02330c000000b0037508cc0bc2sm6200940jae.12.2022.12.05.18.30.05
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 05 Dec 2022 18:30:05 -0800 (PST)
Message-ID: <9d1013cc-d95f-4451-3d05-ffa50e3a2f7e@linuxfoundation.org>
Date: Mon, 5 Dec 2022 19:30:04 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.2
Subject: Re: [PATCH 6.0 000/124] 6.0.12-rc1 review
Content-Language: en-US
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, Shuah Khan <skhan@linuxfoundation.org>
References: <20221205190808.422385173@linuxfoundation.org>
From: Shuah Khan <skhan@linuxfoundation.org>
In-Reply-To: <20221205190808.422385173@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 12/5/22 12:08, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.0.12 release.
> There are 124 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 07 Dec 2022 19:07:46 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.0.12-rc1.gz
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

