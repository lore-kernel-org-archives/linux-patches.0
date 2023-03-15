Received: from mail-io1-f43.google.com (mail-io1-f43.google.com [209.85.166.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B0EC193
	for <patches@lists.linux.dev>; Wed, 15 Mar 2023 23:53:22 +0000 (UTC)
Received: by mail-io1-f43.google.com with SMTP id bf15so62763iob.7
        for <patches@lists.linux.dev>; Wed, 15 Mar 2023 16:53:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google; t=1678924401;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Vd84AnaoqgffLltxoJ8OX+oSLpNPg+Q/OHum9kFhYu4=;
        b=gOyCS30SFVW6sTveg5ZHcXeE6gWMPyuqbyjPATNISsBAnROJmjwGRjCYyKcWGRqXkn
         Q69c70ipIwyUxTE/geusAYoXPHFEQR2S6JuHCLRceUSGDQ8XLsp9j0ZviAXzxID0Ii+O
         g/jvY/0C5+MaALCLLPkWVtYtfzaW2SGQrerMI=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678924401;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Vd84AnaoqgffLltxoJ8OX+oSLpNPg+Q/OHum9kFhYu4=;
        b=d/tlrGCk7aJkALC4X07Z0VZOkKG54kLhTb2VYaNeRSxN/SbjLfN1Inw/domE9JhbFp
         1vNXB6VqhiIVP5KxK6dO0+0d4LuVn9CHjFZoCTMBVCF1ejoFhNtxMGAOqBapPFUR9Yz7
         J1IgXTt+6jddR8Cux+Q8Qa/NC3mAtNjX+U3DHNb+AoGmgI6T1OSIEFmuXpgCDfAwPWoZ
         EZ7WtjBBO7Tp/XoFYyxkEsJw70OuqQh+LH0oxOXw86kK8NUtJE8RT/gMw5vFx0DWeVt9
         iBS/B4t+iBLooQjHK60OaemtuAfvbvnP1LuBHSav++5urRxorN4hQDrZ2fuWTApXxnb6
         c8Tw==
X-Gm-Message-State: AO0yUKWVE2WrnhxBZgI8X16nrXvNdn+ABisppAgZhMv9M87SVbynFp6x
	YSp3iAN0vW6SjqNFJJ5NW3aPvg==
X-Google-Smtp-Source: AK7set+9r02RFtx+5x1+uLhD5DXcNqJleEdP7NFpP2nqpfoRY8f0irMrHrwt+9+fddL4+SBIzfZdLQ==
X-Received: by 2002:a6b:dd0c:0:b0:74c:99e8:7f44 with SMTP id f12-20020a6bdd0c000000b0074c99e87f44mr556896ioc.2.1678924401244;
        Wed, 15 Mar 2023 16:53:21 -0700 (PDT)
Received: from [192.168.1.128] ([38.15.45.1])
        by smtp.gmail.com with ESMTPSA id k11-20020a02a70b000000b003c4f7dd7554sm2126614jam.5.2023.03.15.16.53.20
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 15 Mar 2023 16:53:20 -0700 (PDT)
Message-ID: <9985fb4c-4e10-e1c2-110b-8003fea0ff30@linuxfoundation.org>
Date: Wed, 15 Mar 2023 17:53:20 -0600
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Subject: Re: [PATCH 6.2 000/141] 6.2.7-rc1 review
Content-Language: en-US
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, Shuah Khan <skhan@linuxfoundation.org>
References: <20230315115739.932786806@linuxfoundation.org>
From: Shuah Khan <skhan@linuxfoundation.org>
In-Reply-To: <20230315115739.932786806@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 3/15/23 06:11, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.2.7 release.
> There are 141 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 17 Mar 2023 11:57:10 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.2.7-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.2.y
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
