Received: from mail-io1-f49.google.com (mail-io1-f49.google.com [209.85.166.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 710F7156C3
	for <patches@lists.linux.dev>; Mon, 11 Sep 2023 20:13:27 +0000 (UTC)
Received: by mail-io1-f49.google.com with SMTP id ca18e2360f4ac-77dcff76e35so56802539f.1
        for <patches@lists.linux.dev>; Mon, 11 Sep 2023 13:13:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google; t=1694463206; x=1695068006; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=oHAg2VsYE9Wj9A+w2eQqzWwdmNR2LINhzqAcs3jRGCQ=;
        b=VGprUC+VTJDJ3yNp/qVozHlrzK+ANeCFUlcCfhnN/YIQ8X2cm2kua34lXjKi8oylip
         WhsxHV0rTaObIAho6wj+7+nnNGyxP/IDvRv83jsfavALk+8+f4RIT4ClKxMpzgjFTzFe
         u0rlv1ZxkQa6SQSjoLchkn46nXf6sEeZM78Lg=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1694463206; x=1695068006;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=oHAg2VsYE9Wj9A+w2eQqzWwdmNR2LINhzqAcs3jRGCQ=;
        b=KemjeKq7OeZLqex9XFlPGC01CPb46g8dF+YU/ARGkdL8rPfK37amdUTILbyAC8BuEr
         A8q/VUNq2Yax36qYoY5bIbMuukHN5D2pVG9iNIth3Xf1hRFW5dSE7g3KtoXABNSxj9Mr
         8GmwsCiTBAM5ST2Fi1aIJXZF80noxWcsAnBOVJdo4IedjE00RGwLREksjbzxJtVCHs/J
         XaT5cwOjS3I5zhslnjQktN9hpyx/dvYzYh5gJkq0AzZD+5P1a/TMxJOhcfOwnGEryoVN
         +PRx9RvoaIwOYxJHtzf/N2xEBoHy2cifVlUGy50n6NwVspkq/3DSupm45ucBTwvWLuLS
         0hEg==
X-Gm-Message-State: AOJu0YznU1xyiW4Ib2ZN8O3u4vH7J1ztbRu3UYobIC1LvbJcJQ7Tn1hG
	u/+tObKm97oz3gUEKfnu9Imq6Q==
X-Google-Smtp-Source: AGHT+IHju+pZJElzjkRQNbwS7wWV4kEKFa3k5wqg8347rfU+vNEOKlF8pgbnZJFdZXH90URKq3MS4w==
X-Received: by 2002:a92:b74b:0:b0:34f:6e08:d6a3 with SMTP id c11-20020a92b74b000000b0034f6e08d6a3mr5779868ilm.0.1694463206639;
        Mon, 11 Sep 2023 13:13:26 -0700 (PDT)
Received: from [192.168.1.128] ([38.15.45.1])
        by smtp.gmail.com with ESMTPSA id p14-20020a056e02104e00b0034f6f2eca21sm1298149ilj.69.2023.09.11.13.13.25
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 11 Sep 2023 13:13:26 -0700 (PDT)
Message-ID: <20762b62-c15d-467d-2125-f8ac20d20d95@linuxfoundation.org>
Date: Mon, 11 Sep 2023 14:13:25 -0600
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.15.0
Subject: Re: [PATCH 6.1 000/600] 6.1.53-rc1 review
Content-Language: en-US
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org, Shuah Khan <skhan@linuxfoundation.org>
References: <20230911134633.619970489@linuxfoundation.org>
From: Shuah Khan <skhan@linuxfoundation.org>
In-Reply-To: <20230911134633.619970489@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 9/11/23 07:40, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.1.53 release.
> There are 600 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 13 Sep 2023 13:44:56 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.1.53-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.1.y
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
