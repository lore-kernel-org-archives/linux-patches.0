Received: from mail-il1-f172.google.com (mail-il1-f172.google.com [209.85.166.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 328981FDC
	for <patches@lists.linux.dev>; Tue, 17 Jan 2023 00:02:01 +0000 (UTC)
Received: by mail-il1-f172.google.com with SMTP id h26so14671265ila.11
        for <patches@lists.linux.dev>; Mon, 16 Jan 2023 16:02:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Uy3JXCyJNRbRAP9AGSSvge444xueLj6DcpPi55/gq98=;
        b=DMUuXe/HBraCZA7qiMZcmw5kjMkx9qnb3nl1/gtcaul/8ZWWWov2amWEgU7Jxl2da4
         mbVVh31y5jKNFYTIv0aihPu4+zD75rRVZenH8V7otyqXdLVfgo+J02FWtocq0J8GhLa+
         NMfW/A73oCpEqyS6Rl69sf5X7SP2EaLuq8pc8=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Uy3JXCyJNRbRAP9AGSSvge444xueLj6DcpPi55/gq98=;
        b=pQW8pCRp7vSDqAZkzYPrrQB/J3tJG1KHTjmQIqhmNdS92xuLKvdIsRezgFq2nGr4/M
         9XzZnQfSlUuqM6MXz++V6BR7fixIuclIrSLIzFoj5pv7HRPdA1AVnQhJTEwZ+O/qK/yk
         69xh+iSPPw5y/16pYRK5x3drZX/7OEZBn7Qr+GsKvCAwopz+ayoMgt1OaAwYwuiSf9XR
         ZSj+zeuN9IgA3rl5ChHWogV7D7y6Wqwcs59G8SDEXtRv0KaA4ADSVkAzvXfSy/YAsy2M
         t65Zbw1TI8YBQUyebbBuix4REjY8F/Q2qi0RO4rawEqlfmwRG7Dcvk0AX1vZz4vXlEVU
         uq/A==
X-Gm-Message-State: AFqh2krEZlQQWkPy4PKzN8ZgPQbLYqKbx2X9FuU9yY1HMpgTc+CcyqPC
	ZntL6lhIqX+sFw5Br/dWp/XfSw==
X-Google-Smtp-Source: AMrXdXt/6Nzv8x8gsJ22K/ptSP3NfW209hyQ2Qre2Hf7EkTI7joB/0pNhzCgGsdHDJ7x1gBXX/8kbg==
X-Received: by 2002:a92:6e11:0:b0:304:c683:3c8a with SMTP id j17-20020a926e11000000b00304c6833c8amr169573ilc.3.1673913720229;
        Mon, 16 Jan 2023 16:02:00 -0800 (PST)
Received: from [192.168.1.128] ([38.15.45.1])
        by smtp.gmail.com with ESMTPSA id j10-20020a926e0a000000b0030d8089011esm8618515ilc.54.2023.01.16.16.01.59
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 16 Jan 2023 16:01:59 -0800 (PST)
Message-ID: <e447ea5f-8309-48e4-b1fd-5bd8d431a9c1@linuxfoundation.org>
Date: Mon, 16 Jan 2023 17:01:58 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.2
Subject: Re: [PATCH 4.19 000/521] 4.19.270-rc1 review
Content-Language: en-US
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, Shuah Khan <skhan@linuxfoundation.org>
References: <20230116154847.246743274@linuxfoundation.org>
From: Shuah Khan <skhan@linuxfoundation.org>
In-Reply-To: <20230116154847.246743274@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 1/16/23 08:44, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.19.270 release.
> There are 521 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 18 Jan 2023 15:47:28 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.270-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.19.y
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
