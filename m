Received: from mail-pf1-f172.google.com (mail-pf1-f172.google.com [209.85.210.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4811615CAE
	for <patches@lists.linux.dev>; Mon,  5 Dec 2022 23:34:38 +0000 (UTC)
Received: by mail-pf1-f172.google.com with SMTP id 130so12923367pfu.8
        for <patches@lists.linux.dev>; Mon, 05 Dec 2022 15:34:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=aHpH0koW71v/gNWUs8go+lrDnb52j7CWUOqHhEfGdM0=;
        b=gsFde3HUYz7Yz53ctyOl999WurTwkF6KGafYkT+A62Z1gxrY1M3n8F0zJACffptg62
         FEtd/PVbdC4SE1pg+noGbT7G03EIzyDfL9pXlRyeZzyvLgrcPScv66fHbwMSnfy8LnJ7
         xPmfAO8bmBTdAknl+sC8ORt21covOyMN1WlK2S+rLWk5JZEftu3R+QDR6EPYRn7738Gl
         V2i/0Eyyry6QRfBiJByQjg1/oeRsFBF+4Z12yI0MD/U2AepAwCei5Ung3HKHgXRGZSuK
         4ll5WYP3TRC4wMI0YG76VbBlejlUpC2ewsnDZnSuau7RWQBkFTBNIfH2VhrmP3260BPU
         KVkQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=aHpH0koW71v/gNWUs8go+lrDnb52j7CWUOqHhEfGdM0=;
        b=pUSACqRX50FjH3cckRd7oRL4Uv6lipNB49H8KQx4LPIjW9GSDPz+BZTkfBbTTAH9pl
         xZJ84qqjXlI+BLW2OGAg+o0p0D8GOKo/44r2jdTkghzVU3dGZEpaZO+GMoS/52/IWTp0
         lJOlaQf4K45LQ6UkasIj2xe9Fxh12ksjjYRwOmVcYMfT2278VhkhadDkRqgEs2HO8ktx
         FwK2PgVxbEyF7ZPpW+yXrA/pqtIoDZNLxiApGVLHbb3b8w9mp7g3c2nQVSbu7Udvytux
         IYp1lpGftwccMTz9lSrCLL28JQ+J7FLU+gOC5uTRtUsXwS1f40+b7sRbgdYtnDJnkbWH
         tFLg==
X-Gm-Message-State: ANoB5pkXcyCjeIbAdInBboMcTgY9xBbS8x2AjvvqttI6xL6KrUFzlnYi
	+NkkK0JG6FcCAdSRmUUYsl0=
X-Google-Smtp-Source: AA0mqf6PnUuIQY0pCVuIeDYd5kASTPnCO1yfcd8JTB7BhrHfxMM/jy0ZZDES+A9qQOwoeWjhtatNcA==
X-Received: by 2002:a05:6a00:1c8d:b0:56c:f87e:c662 with SMTP id y13-20020a056a001c8d00b0056cf87ec662mr68183904pfw.65.1670283277656;
        Mon, 05 Dec 2022 15:34:37 -0800 (PST)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id a23-20020a621a17000000b0057630286100sm7952974pfa.164.2022.12.05.15.34.36
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 05 Dec 2022 15:34:37 -0800 (PST)
Message-ID: <ae9f8db2-38a4-8410-6d94-222e8f48d8e4@gmail.com>
Date: Mon, 5 Dec 2022 15:34:35 -0800
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.2
Subject: Re: [PATCH 5.10 00/92] 5.10.158-rc1 review
Content-Language: en-US
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de
References: <20221205190803.464934752@linuxfoundation.org>
From: Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20221205190803.464934752@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 12/5/22 11:09, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.158 release.
> There are 92 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 07 Dec 2022 19:07:46 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.158-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.10.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

On ARCH_BRCMSTB using 32-bit and 64-bit ARM kernels, build tested on 
BMIPS_GENERIC:

Tested-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian

