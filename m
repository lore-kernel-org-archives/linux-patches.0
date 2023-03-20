Received: from mail-pf1-f177.google.com (mail-pf1-f177.google.com [209.85.210.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B8EE6D1B
	for <patches@lists.linux.dev>; Mon, 20 Mar 2023 19:22:20 +0000 (UTC)
Received: by mail-pf1-f177.google.com with SMTP id i15so3600389pfo.8
        for <patches@lists.linux.dev>; Mon, 20 Mar 2023 12:22:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1679340139;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=F8cZ/SgykcdtJDq1l5H8ozbgaiP6IPGwDuK89HEBuAk=;
        b=HAcPE40eOcxoCHrG43mfdwoOS2+q86L2j2Vr+h9AjRsyG50heeF4biSrz69k1wt07W
         QOFBXsskIOaqgReA4piu1x+FPZWh2I3waH+jyNFlLWJAQzNBYtAW2CJWiOJoeDqvHO8G
         BMxeLhOBHd6YjCDpKNmaZMH3v379debzozB5rUx8vvdPsZrvJCvTnfQgygowa1loCnpx
         fzEiiDHwb9xJOYkPZzzfsQ9CAZ8rMe5AB8ccgD5suy3HqtEs0kPBCJINMqhUG3UgdoW2
         ezowJByU4NU1Xn/NYFcn5n9LO6uOsiAMPn82CXxtIAn8Hf89W1td9e2ljrdefBQBZhh1
         lSlA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679340139;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=F8cZ/SgykcdtJDq1l5H8ozbgaiP6IPGwDuK89HEBuAk=;
        b=dZwGK5xUsQheF2cQpktQwfvMYUWMJ3HTindcPXOyFHJSBSY6w7MsAsBBJjYYBbmU7d
         vtagMlrlgChJ4N99fycAJX1r3r6OHJ4jquVKpkYSEWsGeIzv8iYcnSu9aTM+0eSWTlxW
         KiTQCHwgl+/L47d+h5y2AJ9jB329a+MffI7xcvNtvxTpOm91CAVCP5n6m2WSttQ/0zwJ
         YG9ShZLhlNDIXkKv8s+Ni+Tylm8ABQb8kUvvZcbvOwp+nn4hG0n4SAIAkY0mNqJbZEPO
         hc4Vz0wZMUbwEwliBncxOXH0OE1uQPcLsLVvtquyvomTgCzq3PTwZIqg0U7Riv+CmxSN
         Nngw==
X-Gm-Message-State: AO0yUKVC6LNqq4kTDF0E+AHXfa9/5qoneBb2ba7BA2lXepbye7qhiGAz
	/Vg0hMX7ncDyaPm84drZ9Gik/Qk4bVk=
X-Google-Smtp-Source: AK7set/XVroZFVsiNRScnNn2KeEgRBnORCoFN2FALRhzbT0x+SdhdWP3ZrQNierHE7ZBHgGpMqugDA==
X-Received: by 2002:aa7:97ba:0:b0:623:cc95:e517 with SMTP id d26-20020aa797ba000000b00623cc95e517mr16252546pfq.17.1679340139327;
        Mon, 20 Mar 2023 12:22:19 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id h4-20020a62b404000000b005a8bfe3b241sm6646418pfn.167.2023.03.20.12.22.11
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 20 Mar 2023 12:22:18 -0700 (PDT)
Message-ID: <961d41bf-94d5-c689-e9dd-105d212bad8a@gmail.com>
Date: Mon, 20 Mar 2023 12:22:09 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.1
Subject: Re: [PATCH 5.10 00/99] 5.10.176-rc1 review
Content-Language: en-US
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de
References: <20230320145443.333824603@linuxfoundation.org>
From: Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20230320145443.333824603@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 3/20/23 07:53, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.176 release.
> There are 99 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 22 Mar 2023 14:54:22 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.176-rc1.gz
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

