Received: from mail-qt1-f182.google.com (mail-qt1-f182.google.com [209.85.160.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3867E7C
	for <patches@lists.linux.dev>; Mon, 23 Jan 2023 19:06:58 +0000 (UTC)
Received: by mail-qt1-f182.google.com with SMTP id q15so10621894qtn.0
        for <patches@lists.linux.dev>; Mon, 23 Jan 2023 11:06:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=noM6rQKbS9rfagFoqhc7Ies1urqmhdKV4jSItScOuqI=;
        b=HBBmQd0BJxU9q/tAIGHkTvaclkPb0Bz6jjQpmWpbYtHl8dj6OI6EYw/444y7zuq3Ow
         lQld+mPf7cazTuH4l9gXZzq+mYhjdr/DDUsXUMqVbmesOYD7Kb5Q96Uxrcqp15HZMyFq
         XkMTO125djQVni8xbyc4cpJHQWnms/wUQCvkXL0LwS4PxMpddg7TL4qwf3d1qqMMk6Rq
         KoijGK8aEEm4KZJ1n6OE5336oKjdLd3rA31vnhfpZK7LCXgH/ndgVqMrkSRQ6JgksGqM
         A7ssVJrz2addZGoz0ypFywFMS71AlnaIRqI2qa9gU0UA7iCmK1Kx6MoJR0ZIMdur9Zqd
         2aQg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=noM6rQKbS9rfagFoqhc7Ies1urqmhdKV4jSItScOuqI=;
        b=uarJ+fOKTF5hFKANaVLY7RMmtB95fxifFGK/37DS+Pdh99GNApLMUCG0fItIHGJdpE
         IKBZeVKzSFSIC53UBNngVl8dF/oam7mzMw7GiMZKCyhiP1zj0A//v9Adbs/5w/bhjOJM
         ueYVmLlNmzfDOJPuunngv4L/1qYjbEntxfRc9CF2E5jWHLprKao94mEWXNfuCzxRan0X
         ziRXqo9I/RgSs5I7QjJxG5RTbuXXAcnMErGzbQYj2woo+PzO8gOcBQ4Rjm4ExGH/nggG
         aZWUl33q8tfWG4flf9/u5Tr7ZVS0S6nAh/HwTwUXEnbzk7Khh6yQz1dYdgo30SfYlJr2
         aldg==
X-Gm-Message-State: AFqh2ko2Spqr91QKSDNxYFeq5wKG7BXdUGPKIJLKmhOu5ovADWigNQJT
	E78JEqIHpWtrePntNGcoUGY=
X-Google-Smtp-Source: AMrXdXulvEger+xu05aPBZkCIImnQTYIqCn1bCrjyOr9BWHW/59NUZkTVw/U1axrlaA3MTHJm1onbQ==
X-Received: by 2002:ac8:4906:0:b0:3b6:2b76:d7a6 with SMTP id e6-20020ac84906000000b003b62b76d7a6mr38078070qtq.57.1674500817008;
        Mon, 23 Jan 2023 11:06:57 -0800 (PST)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id c6-20020ac84e06000000b003a97a71c906sm10216172qtw.78.2023.01.23.11.06.50
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 23 Jan 2023 11:06:56 -0800 (PST)
Message-ID: <bf6c5407-5026-b87e-b771-e2f1d92fb8fe@gmail.com>
Date: Mon, 23 Jan 2023 11:06:46 -0800
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.2
Subject: Re: [PATCH 5.4 00/51] 5.4.230-rc2 review
Content-Language: en-US
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de
References: <20230123094907.292995722@linuxfoundation.org>
From: Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20230123094907.292995722@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 1/23/23 01:52, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.230 release.
> There are 51 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 25 Jan 2023 09:48:53 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.230-rc2.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.4.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

On ARCH_BRCMSTB using 32-bit and 64-bit, build tested on BMIPS_GENERIC:

Tested-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian

