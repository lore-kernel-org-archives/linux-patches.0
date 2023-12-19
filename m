Received: from mail-ot1-f50.google.com (mail-ot1-f50.google.com [209.85.210.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 172576FC4
	for <patches@lists.linux.dev>; Tue, 19 Dec 2023 05:27:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="TDqJs6gl"
Received: by mail-ot1-f50.google.com with SMTP id 46e09a7af769-6d9d2f2b25aso3057831a34.1
        for <patches@lists.linux.dev>; Mon, 18 Dec 2023 21:27:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1702963667; x=1703568467; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=4bXkmEJvJFAPbKDmMM55QMZx7WRuvaWAYdXvhxYcops=;
        b=TDqJs6glpHz55i8ndxj23+yhEm8zYhaPnce4QjCVghk6D6AtgVO2hog2jpP2ttMC3G
         b7OnywU+yzboiROCd6mYVxLaig5+2ZjL0YH6/rBXjoOcI15R39uFuwI01QQp+NtZbuX1
         q372+d14X7Izkeo6g6nWz3Rb4ulfpUpxZRNxBoAy1SqrIgxLMKkko8TBPfxmocmUyIuw
         DdvxPO9EIizCu8MjBUR8oCSHIHGDh78aCtz70lyhV0ZyQw/8MtC/RB0DfrlhQ+cuugMS
         VZg9Povr0YRmZ+1Jq/rF0MQCFFBR2h1JCqOH9uAqN5IrhveGQEseJHJGXM+3HIAvgzd+
         FtFQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1702963667; x=1703568467;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=4bXkmEJvJFAPbKDmMM55QMZx7WRuvaWAYdXvhxYcops=;
        b=YGHSySQ9o8w3EDvWsGt+oGMHxwj92SZWCU3S5JlnsMSRUg5goCNxCugqXgwptriunZ
         S3vBBi0csmsmr9vCdXSOf4FoTNhhtD3yJp6IPGsOqT/R6up066qAqs3t2/Ox3cQ2r6uw
         hWxZe9JYV8S/X7GX5vQ/4dWS1Xtc5XYjIl06pyH0byY2VB54inrYhU3wLhJX6NUW5k6t
         rHF2a921r5d0f2cqXpd1kcR6UcVlAxJaL9b1aWkHsWqKC+AnLqhOfcavPhC2FbXNgBSI
         cLMXtNd4/4gLOE3dMdHheD0Fz4Z5pCu+9jbKoVDQjCIRlLRziAP1/VIywYL8ChW9rHX7
         jxTw==
X-Gm-Message-State: AOJu0YxbjeTKqRvimLh+9i6o7R9WV5gV54Lom+uBL2mf3Hhd/Tr0kNfQ
	ZLwhGXrtB+RMetOXg9/CWBXEIQ==
X-Google-Smtp-Source: AGHT+IFYR8E5krFrPMoCmfYZtBKLn6BrnnEnAwB0Y2XpS1epJMbyVd7dRUSY4DriGr6moq6f8vlM6A==
X-Received: by 2002:a9d:750e:0:b0:6d9:e832:3f20 with SMTP id r14-20020a9d750e000000b006d9e8323f20mr16571528otk.53.1702963667147;
        Mon, 18 Dec 2023 21:27:47 -0800 (PST)
Received: from [192.168.17.16] ([138.84.62.99])
        by smtp.gmail.com with ESMTPSA id s17-20020a9d7591000000b006d84b3aa650sm4889104otk.73.2023.12.18.21.27.45
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 18 Dec 2023 21:27:46 -0800 (PST)
Message-ID: <cf94f746-55d7-4f22-bb53-b5c1be843354@linaro.org>
Date: Mon, 18 Dec 2023 23:27:44 -0600
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 4.19 00/36] 4.19.303-rc1 review
Content-Language: en-US
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org, allen.lkml@gmail.com
References: <20231218135041.876499958@linuxfoundation.org>
From: =?UTF-8?Q?Daniel_D=C3=ADaz?= <daniel.diaz@linaro.org>
In-Reply-To: <20231218135041.876499958@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Hello!

On 18/12/23 7:51 a. m., Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.19.303 release.
> There are 36 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 20 Dec 2023 13:50:31 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.303-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.19.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

We see new warnings introduced in 32-bits system, with GCC 8, GCC 9, GCC 11, GCC 12, and Clang 17, on:
* arm
* i386
* arc
* mips
* powerpc
* s390
* sh
* sparc

It goes like this:

-----8<-----
   In file included from /builds/linux/include/linux/list.h:9,
                    from /builds/linux/include/linux/module.h:9,
                    from /builds/linux/net/core/skbuff.c:41:
   /builds/linux/net/core/skbuff.c: In function 'skb_segment':
   /builds/linux/include/linux/kernel.h:847:43: warning: comparison of distinct pointer types lacks a cast
     847 |                 (!!(sizeof((typeof(x) *)1 == (typeof(y) *)1)))
         |                                           ^~
   /builds/linux/include/linux/kernel.h:861:18: note: in expansion of macro '__typecheck'
     861 |                 (__typecheck(x, y) && __no_side_effects(x, y))
         |                  ^~~~~~~~~~~
   /builds/linux/include/linux/kernel.h:871:31: note: in expansion of macro '__safe_cmp'
     871 |         __builtin_choose_expr(__safe_cmp(x, y), \
         |                               ^~~~~~~~~~
   /builds/linux/include/linux/kernel.h:880:25: note: in expansion of macro '__careful_cmp'
     880 | #define min(x, y)       __careful_cmp(x, y, <)
         |                         ^~~~~~~~~~~~~
   /builds/linux/net/core/skbuff.c:3630:32: note: in expansion of macro 'min'
    3630 |                 partial_segs = min(len, GSO_BY_FRAGS - 1) / mss;
         |                                ^~~
----->8-----

Greetings!

Daniel Díaz
daniel.diaz@linaro.org

