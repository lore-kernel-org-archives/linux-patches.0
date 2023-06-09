Received: from mail-pl1-f169.google.com (mail-pl1-f169.google.com [209.85.214.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 31353408E7
	for <patches@lists.linux.dev>; Fri,  9 Jun 2023 19:31:08 +0000 (UTC)
Received: by mail-pl1-f169.google.com with SMTP id d9443c01a7336-1b0201d9a9eso9376935ad.0
        for <patches@lists.linux.dev>; Fri, 09 Jun 2023 12:31:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1686339068; x=1688931068;
        h=content-transfer-encoding:in-reply-to:subject:from:references:cc:to
         :content-language:user-agent:mime-version:date:message-id:sender
         :from:to:cc:subject:date:message-id:reply-to;
        bh=F34e28g4Hf9Xu+fszBUHQ7hLKPkEewO0EPUPYwTOjus=;
        b=LE/fMAN1eq+8apJ5cArgFf2LnG32AfY2XmpV26YtEqBi4dZ42YoMHnEcgB7Oh3NbgB
         nckQVLFbaSRF9RRETPQkN0E1/u0TRgjpngQ987s/qhDZIdgbwMso0dcUidTLs7m5OC/r
         2yBQAZyczYX9eIwKylGrjK36/954Zt7wzHn8D1JgVEEH6bQP1EblABjVKUlm/ErO1RTs
         lLfQay2hApQRAscs3PZ3PWRCi00OmWAYUZkZq+ux2Ch2hE/mPhhjb4vfR8Ld95of43Xh
         ZTzexqW5zub3WJfGgnqPKKfWV+7FAdvMTvbbQojEtwKFZxuQdGAtAoCiAmc9k0z2Mhz4
         Qqtw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686339068; x=1688931068;
        h=content-transfer-encoding:in-reply-to:subject:from:references:cc:to
         :content-language:user-agent:mime-version:date:message-id:sender
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=F34e28g4Hf9Xu+fszBUHQ7hLKPkEewO0EPUPYwTOjus=;
        b=NoaY2HV2veuhJXElqV29AlbsNHjYdyK7qjbPKQd723N0tcWPfLnrxJAgPV+ZrujeMH
         pvEagH3TMrLMh+MN93AuqVyrGgRzj3HjNno9VNS8ICmbttWz95NxWDCJszvEhaHSB0v/
         7BN2JiwUcF8cSTUkqakgd2ZWU4/ihRjPO4v2z1+soV6HmJVaEhkxFVJa/tkSsz+iC3cs
         /ylHgA/Po7N3OTas1VNACbNlk+FZBJxO5XOcECdjTmGP2A8f5pf7OEUlqr6zjQ8Ezgfe
         jqsK0aYFUTc5cxOdewLPVoaZ36wBCFzwFt390nW/3VpfuK2DeJ6yUpOFNXmW1jhYl80r
         8ShA==
X-Gm-Message-State: AC+VfDwt2tQhfX8vS0wWM+VosdMJqjp75dARAkA8BP0bV/gOsZymg7ND
	EcAd4M5gQzNc4eFK+g/xmPI=
X-Google-Smtp-Source: ACHHUZ4EDmsFV4rkhZkvBQJPbuLNdV9oFboN/HmzG5iCfpmxSjR0JkyudcjqFqlMwaIKqRz2uHqlpw==
X-Received: by 2002:a17:902:f947:b0:1af:bae0:6be7 with SMTP id kx7-20020a170902f94700b001afbae06be7mr5559562plb.10.1686339068275;
        Fri, 09 Jun 2023 12:31:08 -0700 (PDT)
Received: from ?IPV6:2600:1700:e321:62f0:329c:23ff:fee3:9d7c? ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id a7-20020a170902ecc700b001a69c1c78e7sm3654934plh.71.2023.06.09.12.31.06
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 09 Jun 2023 12:31:07 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Message-ID: <8a166eec-fc09-9ae8-b590-2c2e84796da0@roeck-us.net>
Date: Fri, 9 Jun 2023 12:31:04 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.11.0
Content-Language: en-US
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
 patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, Thomas Gleixner <tglx@linutronix.de>,
 Ido Schimmel <idosch@nvidia.com>
References: <20230607200903.652580797@linuxfoundation.org>
 <b979807a-a437-4d3f-98f9-989da52abb30@roeck-us.net>
 <d35b1ff1-e198-481c-b1be-9e22445efe06@roeck-us.net>
 <CAHk-=whA=HsyDFtgQnWMZP-08ddhMh1a88OZHCXf8N-iP6hFQw@mail.gmail.com>
From: Guenter Roeck <linux@roeck-us.net>
Subject: Re: [PATCH 5.15 000/159] 5.15.116-rc1 review
In-Reply-To: <CAHk-=whA=HsyDFtgQnWMZP-08ddhMh1a88OZHCXf8N-iP6hFQw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 6/9/23 12:06, Linus Torvalds wrote:
> On Fri, Jun 9, 2023 at 11:42 AM Guenter Roeck <linux@roeck-us.net> wrote:
>>
>> I managed to revise my bisect script sufficiently enough to get reliable
>> results. It looks like the culprit is commit 503e554782c9 (" debugobject:
>> Ensure pool refill (again)"); see bisect log below. Bisect on four
>> different systems all have the same result. After reverting this patch,
>> I do not see the problem anymore (again, confirmed on four different
>> systems).
> 
> Does this happen on mainline too? It's commit 0af462f19e63 in the upstream tree.
> 
> It was in 6.4-rc1, and I see a clean result from you at least for
> -rc2, so for some reason it sounds like upstream is ok. But I don't
> really see why that would be the case...
> 

I see the problem only in v5.15.y, to the point where it is almost
impossible to get a clean test of all arm-v7 systems. Affected are
npcm (Nuvoton) boards (kudo-bmc, quanta-gsj, npcm750-evb) as well as
orangepi-pc. I don't see it in any other branch or with any other
platform/architecture.

Mainline is fine; I have not seen any problems since -rc2.

I have no idea what is going on either, only that I can reliably
reproduce the problem (and of course it disappears if CONFIG_DEBUG_OBJECTS
is disabled).

Guenter

