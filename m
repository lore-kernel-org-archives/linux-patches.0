Received: from mail-qt1-f175.google.com (mail-qt1-f175.google.com [209.85.160.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC7A633E5
	for <patches@lists.linux.dev>; Tue, 25 Apr 2023 20:30:19 +0000 (UTC)
Received: by mail-qt1-f175.google.com with SMTP id d75a77b69052e-3ef6e84945dso15363331cf.2
        for <patches@lists.linux.dev>; Tue, 25 Apr 2023 13:30:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1682454618; x=1685046618;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :cc:to:subject:from:user-agent:mime-version:date:message-id:from:to
         :cc:subject:date:message-id:reply-to;
        bh=RXQsS7DdiSemVpvOd/+IAfNyN39Y2Q7DpC+A5PL+xNA=;
        b=LvmYZzqI9WmhHAK/C0BbetjeKBmdMLaYDLV99Seog7ajhUKTDkWqE6PvrZdOvBvCXN
         oC7VTli22EVS1ikyQt0522xLSWD12OSwHiooP9tL3rg71Aj3Xxon4nzhsTbLqsx5PO9r
         VMgXUQ/GJPYsCCzsO05W/ZKXce93EqsMdOIhlt9B4XkVKAq10tRVyK3T6sP5cqkEPmtt
         lja6E0MQDX094Fla9w69pA169SDGqRHsdf0Quxam31sFtdWwt6eXE9cowOcBHoN/l4Vz
         HpslOs9fc+DSO8BONaDjoqbaAWwq65jBknxlbQbQZeQJ/Xvy2OqnPz+XDhgc9KGpaOnv
         3qsg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682454618; x=1685046618;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :cc:to:subject:from:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=RXQsS7DdiSemVpvOd/+IAfNyN39Y2Q7DpC+A5PL+xNA=;
        b=F261R/yVIv5SULGTIHZqPXv9hLxgXA/X4RP5YpLld89F3t/kYIhI74XzlX4j32XZGg
         z7fN0yeBMxojrHqfuD4/yuKZpd7ZmcNXdD/LQvpyAK1LbfltZepsl6EVc8El6mUIhgAZ
         SDTwruPJZwgNKcsA9NcQguhDiF/KunBDEv4AiWbl+R7pcs19aFup/IzPZQECgSMfALEA
         KYIWb57gixMvOJy2ul5pC8M9U7kxoB5yDdzrBYEKmT2lC6kEj5uKQ3vkwvk3ssXOqCSn
         avWdyUqit5nXt7R9gk+Gns0abzlk9ixJ4K+VDuhb6FImHwSRzLN/jLy0w+u7rg4VD9C0
         cDtA==
X-Gm-Message-State: AAQBX9cVk+xN78v9rjzyci/eDf4+A0tVE7ZR1HE84m4ciklM9Dp4OtH0
	XZdWs+/9x4E77whCSuyZ8hM=
X-Google-Smtp-Source: AKy350ZE6zOs2gNMe9NE/LoM0KeCVhu1NrakcyKqVddHUGUANhpxJa8T2n3LZWhvQHdJ/Oj5Xgmi6w==
X-Received: by 2002:a05:622a:101:b0:3e4:e8be:c3a4 with SMTP id u1-20020a05622a010100b003e4e8bec3a4mr30445538qtw.56.1682454618432;
        Tue, 25 Apr 2023 13:30:18 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id b2-20020ac812c2000000b003e8160cf93asm4716700qtj.80.2023.04.25.13.30.12
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 25 Apr 2023 13:30:17 -0700 (PDT)
Message-ID: <37c7ce6e-4e01-9c5c-1c2f-ac55d06f0ec2@gmail.com>
Date: Tue, 25 Apr 2023 13:30:10 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
From: Florian Fainelli <f.fainelli@gmail.com>
Subject: Re: [PATCH 5.15 00/73] 5.15.109-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de
References: <20230424131129.040707961@linuxfoundation.org>
Content-Language: en-US
In-Reply-To: <20230424131129.040707961@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 4/24/2023 6:16 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.109 release.
> There are 73 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 26 Apr 2023 13:11:11 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.109-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.15.y
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

