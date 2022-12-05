Received: from mail-qt1-f174.google.com (mail-qt1-f174.google.com [209.85.160.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C10BB15CB6
	for <patches@lists.linux.dev>; Mon,  5 Dec 2022 23:56:34 +0000 (UTC)
Received: by mail-qt1-f174.google.com with SMTP id y15so12650262qtv.5
        for <patches@lists.linux.dev>; Mon, 05 Dec 2022 15:56:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=iIy0CU7yt4+X9mKqU8x+YEdNsjIIrmk6leKhWgrrnKg=;
        b=EuKe8P+/DODwiEjsue4QUosOKRNzQGiO4ljWrDWvTSjOYalJ1nodD5y2e1L/Krn+5o
         CjN3z3kwEyqqVk8EsBkuNjPmColYfJEKxUnTdD8bgBSl1c4SqHmo8lx57z1VI5RnZtHA
         RyeX7f9N3CiOOKikm4xC8i05FdjS0ucjR1t/GHocu2XYfPjZ6bGm1exzChbr0W2ccUem
         Y/Ys4qYob5fzRx9QuS1UAzchXpIfJZ3iSooau1xg3/0MLzK5TM4Um/FFNug0mq3v64vq
         B6Kc4SjieW6bKvC0e9ztGnu9szlc4vbpgBRDUxN8zAYD1Q0DYtWkzWhmdebp71Mny40/
         3H1w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=iIy0CU7yt4+X9mKqU8x+YEdNsjIIrmk6leKhWgrrnKg=;
        b=euOqxGxc4vSdY1Yd5w/n35EVIzmMd1yZ1ostSaW9wuHbfQ/nvt/rpNbZ9WI0rhGHSV
         VZi5i93cY43EkjwuZ5j3ZTwV+SRHdpLcnGUS2ErsutgLBtkqBMW5hZAiGbpruzVZWlEm
         GdNloP1q04xijmjYH/Jjwvv/e//rsDdhf1feoWcLE4ql3u9sO7aloFwKqdyck4XQZNwH
         HUasQJy1nHHTa+I7VTOJZtN7M2pbd64J2/3kZfhEcXMXjF1fd4G/lUxpW9eKtV521PuS
         za7cjsQ/vEWO6OmrULT5gEOwT0pyoIXAwYM0qcOjZKEmCCGTmBMP9dpipdLAsiJZr6jq
         8JHA==
X-Gm-Message-State: ANoB5pnw2SHWnofgqflR6KnU9Koi9u8U5V3nwzZK+s9g4BQKXzh92ElV
	cxtJbX/mDxv+dcChWvGzcFk=
X-Google-Smtp-Source: AA0mqf7lMDNT73WkSKJf76e53D015ySK+agv0dvW9aOPQG/JfKsPXCUNiRAgDRYVRj7vCMUZXYNYjg==
X-Received: by 2002:ac8:75c2:0:b0:39c:e98b:ea12 with SMTP id z2-20020ac875c2000000b0039ce98bea12mr78450279qtq.151.1670284593552;
        Mon, 05 Dec 2022 15:56:33 -0800 (PST)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id s22-20020a05620a0bd600b006fc3fa1f589sm13684026qki.114.2022.12.05.15.56.31
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 05 Dec 2022 15:56:33 -0800 (PST)
Message-ID: <b4b89dcc-4e15-303c-1071-a0d103ca4d68@gmail.com>
Date: Mon, 5 Dec 2022 15:56:30 -0800
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.2
Subject: Re: [PATCH 5.15 000/120] 5.15.82-rc1 review
Content-Language: en-US
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de
References: <20221205190806.528972574@linuxfoundation.org>
From: Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20221205190806.528972574@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 12/5/22 11:09, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.82 release.
> There are 120 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 07 Dec 2022 19:07:46 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.82-rc1.gz
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

