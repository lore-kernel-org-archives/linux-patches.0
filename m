Received: from mail-io1-f45.google.com (mail-io1-f45.google.com [209.85.166.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D0657DDA7
	for <patches@lists.linux.dev>; Mon,  8 May 2023 21:28:47 +0000 (UTC)
Received: by mail-io1-f45.google.com with SMTP id ca18e2360f4ac-760dff4b701so32020039f.0
        for <patches@lists.linux.dev>; Mon, 08 May 2023 14:28:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google; t=1683581327; x=1686173327;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=LdHfEQtLtNDQXgK0ROcb2pQ+ZbGp8ywADrDmw5EHPD8=;
        b=BH7x4gf6827DTq+nNDr+4p/4dTFyOqjDVC5nSVY+1km3AnPfWvFFAQHpvdZq1twQOk
         AgP9gLG8IAzJE1pft9Fng790hAEGz/jZ47TYL73eKGRi5J0WwgA7TJf61JYCRQpKnVyJ
         M2t1TdUpm+wjed9SFDCA1uKS9XiQ5VrzB7lJI=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683581327; x=1686173327;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=LdHfEQtLtNDQXgK0ROcb2pQ+ZbGp8ywADrDmw5EHPD8=;
        b=hiLTC4USPoRHDvD//0pF7WXyCU1spAVrXaHDCFAgxY/gwkdphTFykb1SW1UfG+7xZF
         1cmXl472PzpUIjzUMkUsqYYDzyhjz5tfQEzcVXPtWitN+T3uMQL+f6COubz+8XVjSxT1
         e2HE+tV1fKWtybSdfNx3fCQbhY72o3GBNZ1uSgrkedrLjlpMG5rp+Qq7hHwQt205e2Rf
         3eLF/hhAjysHVvzr62i9twApjjR7qViLiWfOc5qkw3aGeAiY/dK0uQQcP8dZ1azzV3Z9
         6lq4YJZnpKlPVvLU7i96c5kWBr2PzHqZkx9BS1APwBUfcPxrmIbAQfbZInBamdfOAHC/
         iorQ==
X-Gm-Message-State: AC+VfDzlGrHI4YfAGjrmnYgUwVjsfTO7UKjLKYZqZnk5U6mnZZu/f60C
	ngrbClesq0QN+0xbfOXUahQq6w==
X-Google-Smtp-Source: ACHHUZ7h17gNHcSuwR609gd5cM+lScBgEdnF7oLgTBriBGKNYl4xiJXFoscS58xF/YfjzMkuutzf0g==
X-Received: by 2002:a05:6602:2c81:b0:763:86b1:6111 with SMTP id i1-20020a0566022c8100b0076386b16111mr8286721iow.2.1683581326840;
        Mon, 08 May 2023 14:28:46 -0700 (PDT)
Received: from [192.168.1.128] ([38.15.45.1])
        by smtp.gmail.com with ESMTPSA id y5-20020a6bd805000000b00704608527d1sm2444124iob.37.2023.05.08.14.28.46
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 08 May 2023 14:28:46 -0700 (PDT)
Message-ID: <23f8bbc9-19db-dc6c-8d59-f0eed757dcc6@linuxfoundation.org>
Date: Mon, 8 May 2023 15:28:45 -0600
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Subject: Re: [PATCH 6.2 000/663] 6.2.15-rc1 review
Content-Language: en-US
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, Shuah Khan <skhan@linuxfoundation.org>
References: <20230508094428.384831245@linuxfoundation.org>
From: Shuah Khan <skhan@linuxfoundation.org>
In-Reply-To: <20230508094428.384831245@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 5/8/23 03:37, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.2.15 release.
> There are 663 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 10 May 2023 09:42:40 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.2.15-rc1.gz
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
