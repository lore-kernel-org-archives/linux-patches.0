Received: from mail-il1-f169.google.com (mail-il1-f169.google.com [209.85.166.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 00EF57475
	for <patches@lists.linux.dev>; Mon, 12 Dec 2022 23:58:51 +0000 (UTC)
Received: by mail-il1-f169.google.com with SMTP id s16so4250568iln.4
        for <patches@lists.linux.dev>; Mon, 12 Dec 2022 15:58:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=OZjN4DfBt1MpKQnJvB+t2SgFukuSJ9KwUKmZ/hzFAhI=;
        b=gzz8jhfC+YxU6CPIUoPEFVa32AeoGayYHzFWctIg35CBZHX08zzy5LNGJYniDlAUsK
         cQw9aRyIjWsHnIjEMJPpsvBN7JSLwGDKbk2V1Eq4eapWt0DGmtfbtO9SbgwJ7Enm4ybm
         R+BIiF1fLLil6hOamE8OgtsDessM+iXrogq1U=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=OZjN4DfBt1MpKQnJvB+t2SgFukuSJ9KwUKmZ/hzFAhI=;
        b=1SNUkmVwdACg7iRr4vJSqDEKz8FySLB7gu6gPLFq4lg4XiXzGu3jcSqpinbAZxtoAZ
         EBtrkoOwQo7noRNxX7q2lcO5xb1j6ZZy84LxnyuVMGwgMFjg+YumgYt/9JnCqDXu19XA
         ZS7GjTU3txrg4OWVUpruEHWRpL4GDdwVCx/gHzyNbCaUhg2r4EWmtE3qaOvDs5FkzbPD
         GF6h6pMjZC980WhXIuXxcfTwUsjpfxLbN1DEFZeswi7AOVtT2CBUcmbRZa97YBEb5JIs
         D4u3mRseww1Z9Ac/jL4TaPjOegprG14MnZO1qFTd4qvsZqybr5hSUUfTnNtNvRuGxGcL
         S1qg==
X-Gm-Message-State: ANoB5pnTK/66CbONhD/QQVgVZ5jI+u195Y2ZoER5IBZJweY0qsmvw+wg
	zBBPMXYuPZ1hpZrouZMxZ8quQQ==
X-Google-Smtp-Source: AA0mqf5PU7eqBo0BF+Q2Sro7x9KVt3tYrLlLLX882/S+IjtN28no4eMFYTFNE6ze8+7d40T21fy2jg==
X-Received: by 2002:a92:cd4e:0:b0:303:1141:1044 with SMTP id v14-20020a92cd4e000000b0030311411044mr1994430ilq.1.1670889531058;
        Mon, 12 Dec 2022 15:58:51 -0800 (PST)
Received: from [192.168.1.128] ([38.15.45.1])
        by smtp.gmail.com with ESMTPSA id c4-20020a92d3c4000000b00302e09e0bb2sm3295862ilh.50.2022.12.12.15.58.49
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 12 Dec 2022 15:58:50 -0800 (PST)
Message-ID: <6c96b2f0-8144-8442-b127-e38aa46e252d@linuxfoundation.org>
Date: Mon, 12 Dec 2022 16:58:49 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.2
Subject: Re: [PATCH 5.15 000/123] 5.15.83-rc1 review
Content-Language: en-US
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, Shuah Khan <skhan@linuxfoundation.org>
References: <20221212130926.811961601@linuxfoundation.org>
From: Shuah Khan <skhan@linuxfoundation.org>
In-Reply-To: <20221212130926.811961601@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 12/12/22 06:16, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.83 release.
> There are 123 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 14 Dec 2022 13:08:57 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.83-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.15.y
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
