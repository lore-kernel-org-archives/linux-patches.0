Received: from mail-qv1-f45.google.com (mail-qv1-f45.google.com [209.85.219.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BBC29A4C
	for <patches@lists.linux.dev>; Wed,  1 Mar 2023 22:09:55 +0000 (UTC)
Received: by mail-qv1-f45.google.com with SMTP id bo10so10378038qvb.12
        for <patches@lists.linux.dev>; Wed, 01 Mar 2023 14:09:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=sladewatkins.net; s=googled;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=m81d3ZLYTA7um9M2BirrsjSwNVFJb6lqEr36j6zjLAk=;
        b=K+4LerK63Mc/rUyaTPH9P95zh5pcpecJ9ALi8IDWd8us+oUEDkQP3KE1ABeI/0Jt5F
         qojwGe10Be/ITsn+4BTwbn6CU+ozh6YYb0CJTL07KVSohZuPNQYaHgQWh4XFYkHMEV7e
         XNPtcQBpNv8cTkABk8B7fiZp9IhJfOA0fhw4Q4jma4Dx73lCcEIhyNNN96Jfy7rqETEl
         IfzTHeZdiRq0FCwvMLx5EkDMgf38j3dUSsHVi+GQSi1aGyr2HA80PNniG1RFTJHL4iW1
         JB9Ln8tVJwl3V9Z99WprMZBFm6WGb0ZBW4NO12q4R83OIL4U68yFb2ukxLZokIFmr6Dg
         a2FQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=m81d3ZLYTA7um9M2BirrsjSwNVFJb6lqEr36j6zjLAk=;
        b=ZlyfVj6gu/r6j3cdaK07H5hbZXwE5nKLicW3HdWqjIwf9vJr5YwE1xuQ8bHCba9pog
         zb0dawE4Ic7um/w5acTJTERSkiyZtSYmx3YOrX7RulzdeIgD710zlMOphUTNX/lYyxCR
         NshGBKk6OacxGrBUUhhdlZsLCjgRmyB5X24NOVAGkkpjKQwHRE8PbDNegZ7hps3YNTXm
         L1Bfy24ABye/++kGQAUFMwA58i/bQje0edDbhqGAdNfZPfQYgI6RZ/I5lVmdlN0p+lv+
         r3kVDu8ywihEOFiZpWG+F+bKFKgYMhsotfWJ4o2VnitZgrmhqgp8kGfsWVRL9XA4Px8G
         JS3g==
X-Gm-Message-State: AO0yUKXKQZ8aKsm8f1E4kDtBoYQaCoetNScxQFk6pCZQUlnIU3IWwknH
	2Ls6VtshSUsQ3zIpLhlgkArGXg==
X-Google-Smtp-Source: AK7set9ymAUBN1sEWxPb8MKa0QRmjnq5/cjk/PQEdLjWWbDzIwRsDvRZf0yOU9nUChJkxsjQCV3R/w==
X-Received: by 2002:ad4:5945:0:b0:53a:bf63:b053 with SMTP id eo5-20020ad45945000000b0053abf63b053mr12607707qvb.45.1677708594508;
        Wed, 01 Mar 2023 14:09:54 -0800 (PST)
Received: from ghost.leviathan.sladewatkins.net (pool-108-44-32-49.albyny.fios.verizon.net. [108.44.32.49])
        by smtp.gmail.com with ESMTPSA id o134-20020a37418c000000b007429ee9482dsm7618614qka.134.2023.03.01.14.09.53
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 01 Mar 2023 14:09:53 -0800 (PST)
Message-ID: <31339d95-a318-ba2e-fdb0-ea7b102fd6fd@sladewatkins.net>
Date: Wed, 1 Mar 2023 17:09:52 -0500
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Subject: Re: [PATCH 5.10 00/19] 5.10.171-rc1 review
Content-Language: en-US
To: Pavel Machek <pavel@denx.de>,
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: kuniyu@amazon.com, stable@vger.kernel.org, patches@lists.linux.dev,
 linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
 akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
 patches@kernelci.org, lkft-triage@lists.linaro.org, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de
References: <20230301180652.316428563@linuxfoundation.org>
 <Y//Lw/zL168J3spQ@duo.ucw.cz>
From: Slade Watkins <srw@sladewatkins.net>
In-Reply-To: <Y//Lw/zL168J3spQ@duo.ucw.cz>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 3/1/23 17:03, Pavel Machek wrote:
> Hi!
> 
>> This is the start of the stable review cycle for the 5.10.171 release.
>> There are 19 patches in this series, all will be posted as a response
>> to this one.  If anyone has any issues with these being applied, please
>> let me know.
> 
> AFAICT we should not need this patch -- we don't have b5fc29233d28 in
> 5.10, so the assertion seems to be at the correct place here.

This (b5fc29233d28be7a3322848ebe73ac327559cdb9) appears to be in linux-5.10.y,
though?
https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git/commit/?h=linux-5.10.y&id=b5fc29233d28be7a3322848ebe73ac327559cdb9

Confused,
-- Slade

> 
>> Kuniyuki Iwashima <kuniyu@amazon.com>
>>     net: Remove WARN_ON_ONCE(sk->sk_forward_alloc) from
>>     sk_stream_kill_queues().
> 
> CIP testing did not find any problems here:                                                             
>                                                                                                         
> https://gitlab.com/cip-project/cip-testing/linux-stable-rc-ci/-/tree/linux-5.10.y                                                                                                                         

