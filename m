Received: from mail-io1-f43.google.com (mail-io1-f43.google.com [209.85.166.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 25F3DC944
	for <patches@lists.linux.dev>; Tue, 18 Apr 2023 21:28:41 +0000 (UTC)
Received: by mail-io1-f43.google.com with SMTP id ca18e2360f4ac-760f040ecccso9219939f.1
        for <patches@lists.linux.dev>; Tue, 18 Apr 2023 14:28:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google; t=1681853320; x=1684445320;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=AF+TKDSwlJxEFvef+zLB3pMaYgBVJqNgkRygFdxNlT4=;
        b=CPg4nV1fbFsHAryFxUq33eiQukeLnfEN2+T6suHcy8BLOSsHvyB88Ad0wrH3eIlsms
         d3i4pw6V8UogxgGWZ8SjdWyqpwBaah5C9D/S0Txmr/FFB+lA2PxhcQFA7Do2P0hwraUV
         +XuqF7dyqNsRBFGoeJjX5/tJEDiNUlwZQMpJE=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681853320; x=1684445320;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=AF+TKDSwlJxEFvef+zLB3pMaYgBVJqNgkRygFdxNlT4=;
        b=REYU3R74kr/R9UXu1TgU0QwfuiAOB3V+Oet0kj8XYfrrcZ4v6NxU+TTGKQP/Swoa7j
         HkI6w+z/Ba0v5ByK5eeRkaeftSdHCppaKJJaCvC8YpozOvUQ0CqlfIwM9FWWN/9sBf/C
         75IJZLG73t/X74Wb1wkPv0Mfjbkn97uwjVL42rhlLZUqyPYfHrgC9m5k/EMj8xlB+Xpc
         nUN0whxHHQoQb1BkFomp/r07OEuEe3TvnSdgzuvhqPf6NPiIVQOBOQ3nGTdiXQjUxSLP
         7zt3rbTB0eDlkuZ1wwT8fa/8m2eRberM++R5n35OJCtAovc5FPBC0woOnjcNd5x/f+jx
         27MQ==
X-Gm-Message-State: AAQBX9cgz/Mpwh9DUSzMeGKtouWRPaNx4owd9hlpNhPwQMLntf2zXQ2J
	GIkEe9yTy4H4Z0mqXavH2abNfQ==
X-Google-Smtp-Source: AKy350YiS5R2Iq9yAjKo6pDkiNMNYsvpJyUtu0o416AIUIjVw5bg2sAXzqIda+xaA9Ecpg8BKrTcyQ==
X-Received: by 2002:a05:6602:340e:b0:760:ede8:5371 with SMTP id n14-20020a056602340e00b00760ede85371mr6811092ioz.0.1681853320248;
        Tue, 18 Apr 2023 14:28:40 -0700 (PDT)
Received: from [192.168.1.128] ([38.15.45.1])
        by smtp.gmail.com with ESMTPSA id r16-20020a056638131000b0040bc5460051sm3531116jad.98.2023.04.18.14.28.39
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 18 Apr 2023 14:28:39 -0700 (PDT)
Message-ID: <a94f6d9b-d2d3-1c56-e6dd-964e15763eb3@linuxfoundation.org>
Date: Tue, 18 Apr 2023 15:28:39 -0600
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Subject: Re: [PATCH 5.4 00/92] 5.4.241-rc1 review
Content-Language: en-US
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, Shuah Khan <skhan@linuxfoundation.org>
References: <20230418120304.658273364@linuxfoundation.org>
From: Shuah Khan <skhan@linuxfoundation.org>
In-Reply-To: <20230418120304.658273364@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 4/18/23 06:20, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.241 release.
> There are 92 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 20 Apr 2023 12:02:44 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.241-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.4.y
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
