Received: from mail-il1-f175.google.com (mail-il1-f175.google.com [209.85.166.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 951392342B
	for <patches@lists.linux.dev>; Mon, 12 Jun 2023 22:25:29 +0000 (UTC)
Received: by mail-il1-f175.google.com with SMTP id e9e14a558f8ab-33db502bc30so2565465ab.0
        for <patches@lists.linux.dev>; Mon, 12 Jun 2023 15:25:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google; t=1686608728; x=1689200728;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=KMJQMMSjzlha9re6bGJiDvNT3DtRinbFbhGXkPE2bPw=;
        b=KRNKWdxNHOks9UtRA0/RJ4zCLDd5/d9bqHLQHe3rukKgmx778AzKUBYE2URQV6u++P
         +JANCMtdVec5reJF/YUlTjk4Dn6uEOac9ZcjCUoyT9JqvcQfsq8pDuKlhl+3wSkwP2xM
         YZ8iyvt/5+/mgl1uHSADlSe284DO20kLrPvr8=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686608728; x=1689200728;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=KMJQMMSjzlha9re6bGJiDvNT3DtRinbFbhGXkPE2bPw=;
        b=eTcf5LARKr6MA4nu7nGSBCpHsO56lkDtmilmUUPFhRm3E3THdAbdVq4c67y9PnJDW2
         aD8IStwJjBexFMcXC8vvd5dOKusUEIO5c1qgfxz0G4hzDWmFXO0n7RcoAAjUBl5JiwP2
         M86y1KbAgI50S4adeGtKfl+OMvgtwnfBgDakB5ORaaeqUt/f6dc78uJsFX7y8fc8cMCh
         zrAQEgAGTbbfJusPYdRYnsqAI4DDP+3w2CVphfGUzxqF95+SHCE8PSTRGNaIGY6pJVEs
         axnY9CzanOcBI+cKVmwOOvohIRupHvBY8KUXjpA5P9oK9Jobq2NkMAmjYlAWMBqw3tl9
         iYdA==
X-Gm-Message-State: AC+VfDwrEnMY54tM33rOV5joSNi5iZH1yX97iZTE/+hFFNw1OsDFMbNI
	KuuW17tggqa5kZvxd1lnpnvZ8+Slv0y4sY1eFxE=
X-Google-Smtp-Source: ACHHUZ5v8L+4Gd+dXffTSdIXzZdLM0+tZ3lxkMJ2QmzgXUxQYl/fypc7IlPKu4El9nvFTxtcF7R7BQ==
X-Received: by 2002:a6b:5019:0:b0:774:9337:2d4c with SMTP id e25-20020a6b5019000000b0077493372d4cmr7409681iob.1.1686608728537;
        Mon, 12 Jun 2023 15:25:28 -0700 (PDT)
Received: from [192.168.1.128] ([38.15.45.1])
        by smtp.gmail.com with ESMTPSA id dx7-20020a0566381d0700b0041d759c451asm2996607jab.166.2023.06.12.15.25.27
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 12 Jun 2023 15:25:28 -0700 (PDT)
Message-ID: <b76078b0-1bb0-221c-5382-cbb16e2b6ee0@linuxfoundation.org>
Date: Mon, 12 Jun 2023 16:25:27 -0600
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.11.0
Subject: Re: [PATCH 4.19 00/23] 4.19.286-rc1 review
Content-Language: en-US
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, Shuah Khan <skhan@linuxfoundation.org>
References: <20230612101651.138592130@linuxfoundation.org>
From: Shuah Khan <skhan@linuxfoundation.org>
In-Reply-To: <20230612101651.138592130@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 6/12/23 04:26, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.19.286 release.
> There are 23 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 14 Jun 2023 10:16:41 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.286-rc1.gz
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

