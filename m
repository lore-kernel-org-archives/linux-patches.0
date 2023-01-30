Received: from mail-io1-f52.google.com (mail-io1-f52.google.com [209.85.166.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A94879F5
	for <patches@lists.linux.dev>; Mon, 30 Jan 2023 21:09:09 +0000 (UTC)
Received: by mail-io1-f52.google.com with SMTP id w24so1657676iow.13
        for <patches@lists.linux.dev>; Mon, 30 Jan 2023 13:09:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=I5FFyP1pwgAcJTSYXMdmc2wmxlAHasQAPTGxr28W5CA=;
        b=O8oFQDSRasxJf9c5fc06EAjHPlFi1g/U5C954FGeGPSLDA86s8gS0RLxtkYxkLptrS
         T1/mM7geMzxj0yXPFir6O+AsFxzDcjMXL2ZpnIhpQz4HQC7fLaTt48ah90WVOEJ30Aui
         1DxXS2Xd6VU5xfM8MFokgDNcsYMrdauVEy+wE=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=I5FFyP1pwgAcJTSYXMdmc2wmxlAHasQAPTGxr28W5CA=;
        b=DXOvzbH9QYH73iebGDyAT/qsqzCAm552TD1EMxvb3jDS3+yyTcCIo+mQ2Oq3PJc0mz
         w03vXLncMxsNX+8Yf7RlbxD5awU7W11rehg12DWAdCulGlkTKZuy1XmgLSH+V1FVJC+p
         vBIcytP79sGOC1rKKprZF0fHgwXdBboyBP6WcA2htxJt5+qIld5BHQ/e8jO8xcvP1sla
         GL3POutL2dmxGdAYElbhJIVThSZgev0W/OyxPWkSa3Mo5bm/ejj0AU/eYgLwz+77J0rc
         1tXdyqgdkdm5Y8kptnowORjiCjlVbApPWPxlwegHH9rGUVyRozdHq7LS13x2cunOAOe6
         qCqQ==
X-Gm-Message-State: AO0yUKVfVP07YeJavSNClj0n10HnlLeigeoX32TzaAyQocRNrmVKU8Dt
	Sea2q7LbNvukF2S1U0e5aOA4eQ==
X-Google-Smtp-Source: AK7set+FmzYByEq+Ec1/MOcNI87kKOBFwxgvGlNVWFYtOs1Z2FaVqx/pN7V1kz8PsZUMkqHKeQkBuQ==
X-Received: by 2002:a6b:bb05:0:b0:716:8f6a:f480 with SMTP id l5-20020a6bbb05000000b007168f6af480mr1490463iof.0.1675112948672;
        Mon, 30 Jan 2023 13:09:08 -0800 (PST)
Received: from [192.168.1.128] ([38.15.45.1])
        by smtp.gmail.com with ESMTPSA id t11-20020a02ccab000000b0038a760ab9a4sm4982930jap.161.2023.01.30.13.09.07
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 30 Jan 2023 13:09:07 -0800 (PST)
Message-ID: <84908e0d-54d0-30aa-54e7-acde8c661f24@linuxfoundation.org>
Date: Mon, 30 Jan 2023 14:09:06 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.2
Subject: Re: [PATCH 5.10 000/143] 5.10.166-rc1 review
Content-Language: en-US
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, Shuah Khan <skhan@linuxfoundation.org>
References: <20230130134306.862721518@linuxfoundation.org>
From: Shuah Khan <skhan@linuxfoundation.org>
In-Reply-To: <20230130134306.862721518@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 1/30/23 06:50, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.166 release.
> There are 143 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 01 Feb 2023 13:42:39 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.166-rc1.gz
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
