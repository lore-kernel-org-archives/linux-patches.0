Received: from mail-il1-f181.google.com (mail-il1-f181.google.com [209.85.166.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4BC67C949
	for <patches@lists.linux.dev>; Tue, 18 Apr 2023 21:22:08 +0000 (UTC)
Received: by mail-il1-f181.google.com with SMTP id e9e14a558f8ab-32ab7a1c27bso741185ab.0
        for <patches@lists.linux.dev>; Tue, 18 Apr 2023 14:22:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google; t=1681852927; x=1684444927;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=svyznddJgnVR1avwF2cVVe8eGgIgkWAaMGGDNnfRRxg=;
        b=cVBl1ruL/4j6CtSpiI+4j+X/GkOTulJT4p6lxIUvEsQLBQRf1754bALXTDwY8n+gwg
         a/ubfFEtcfbRKloMcn6kQF/7sCJ0eteH3wn8AWhmmAKIL2X4I0Wiq5nsYJjcgAKB58Gk
         ivhp74zaUhCikwjQACunyjhVP0+64Q5rW4UyE=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681852927; x=1684444927;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=svyznddJgnVR1avwF2cVVe8eGgIgkWAaMGGDNnfRRxg=;
        b=cKPZZG5ygY1w56qqqd33u3gJj5vt7SmAbQwpEtARpjsOAAhsPJiWueV6nUJiwdOHc5
         V5g1j2yE7978+ASDqmQsvBTQGvbpBET9W8BmmfaiD7U0QZwx8hkCp0VaqQnBbRFt8Rov
         HlRZrTDyWycx1eiVqIawZRiPTwbW6RAXstdV8FA8L/YLBW6AIlxkwnI28xCkKUCcpvst
         jS+gqPDSTJ7/3oyw5A/2EsU1vATgVs/BGy52pRx4YvwXka4U94iYAqDGoDf5eO9Gx4s6
         DXVxzT3i4NsPXJ+DtOKzY43y8IPFYlkl7bTol4/KMNdYKRPZk7CCNOf2GNErXRsJqcAj
         kw0w==
X-Gm-Message-State: AAQBX9fgZ2V5oXyG0ZeYkBSf88KJtdhbgz9MDau80Y741/3MD4bF9JKe
	u9ddOD9ew/YfW5S7gvYe8ce8Tg==
X-Google-Smtp-Source: AKy350Y/VLfcWWcnBVZOnqZmAq1KczXEZC3CzyMaqmYrVkcW58kDFGdj+5ihTikYL7ZMoJmR9H3dJg==
X-Received: by 2002:a6b:c906:0:b0:760:f7e4:7941 with SMTP id z6-20020a6bc906000000b00760f7e47941mr4583295iof.0.1681852927254;
        Tue, 18 Apr 2023 14:22:07 -0700 (PDT)
Received: from [192.168.1.128] ([38.15.45.1])
        by smtp.gmail.com with ESMTPSA id ay27-20020a056638411b00b0040fa2395ad5sm2258461jab.178.2023.04.18.14.22.06
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 18 Apr 2023 14:22:06 -0700 (PDT)
Message-ID: <461dc6c5-7771-2b74-f563-5592391645d0@linuxfoundation.org>
Date: Tue, 18 Apr 2023 15:22:05 -0600
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Subject: Re: [PATCH 6.2 000/139] 6.2.12-rc1 review
Content-Language: en-US
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, Shuah Khan <skhan@linuxfoundation.org>
References: <20230418120313.725598495@linuxfoundation.org>
From: Shuah Khan <skhan@linuxfoundation.org>
In-Reply-To: <20230418120313.725598495@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 4/18/23 06:21, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.2.12 release.
> There are 139 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 20 Apr 2023 12:02:44 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.2.12-rc1.gz
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
