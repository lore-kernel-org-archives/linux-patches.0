Received: from mail-pj1-f50.google.com (mail-pj1-f50.google.com [209.85.216.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF9F810955
	for <patches@lists.linux.dev>; Mon, 17 Jul 2023 22:50:09 +0000 (UTC)
Received: by mail-pj1-f50.google.com with SMTP id 98e67ed59e1d1-262e89a3ee2so2964484a91.1
        for <patches@lists.linux.dev>; Mon, 17 Jul 2023 15:50:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1689634209; x=1692226209;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :sender:from:to:cc:subject:date:message-id:reply-to;
        bh=R16wYXJMzLsEsj3FtQgk/CvxzmydOiyAt9JWzQt8uoI=;
        b=BiRNYGFnwAYfIznKKt9FOgRGm5RuU/GMsOekFTRwD5/ies/HlrT1t6cqP6E6zr0+qI
         i6WJvatIh0quRDU3EUiLVxMVqYpJq7WiW64j35gqQ5kHaCMwTBzolkY5amKFFf6lQoZt
         hR6AKx/KyEah19OAxfqtT1SILtRugoDkDSxRYNvkI6TyrElqjbL9Fbrc+F8JFC3+nG/0
         TWLnWdg5x5969gkruFmZywVN8SciJB7HTMPlOCA0szFhGFAY9LOgx9srpCj7HZZALOiO
         SEX+yGro0YOHWYbUb9e5UAhfSJaGwgkWFjqgGTI67k//nD2IX2kbU78qtOYQcj9mIenY
         XmTQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1689634209; x=1692226209;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :sender:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=R16wYXJMzLsEsj3FtQgk/CvxzmydOiyAt9JWzQt8uoI=;
        b=hrO5ukZ+USoTFtZlRsfhg1bNCLpAh5oX2PZW0J61sWIxP1Hz5/Mal7Wr4Acp+GCoC8
         /YNSRnZkGhmcLYbeRwEmxaCu69Rtb6SuJ2IH7EL+jxtmzZNYTQ5xY3srbjI80WB4mSBF
         gLI0uXfB5YzDOSzJXIKXW3CPeqH4tjfvknr/dAWoBDtOrnKB2fmNOFaL3pn7gId47aZT
         /kbiejaHAcoX0l444nnYrHi9l0S9W77u1AUEOn1yn8jpxUjo0pBZf+TwJsGNbMPq4+Rr
         CjeOVkVE8mEFqdwQ3UzfhaeMUQ4j1ylUDIxlUCB1I3W33KuFVbBr5GOOcaJFxJdpyl6M
         a1mQ==
X-Gm-Message-State: ABy/qLasXcv1+FX6HFEFg9L+sGOs2L+x6F4R/AW2Ozij/lYxG1xDh2md
	AfpR5B/sVsmK4USM6MbxWho=
X-Google-Smtp-Source: APBJJlEXGgThbxa04zY5Ja8vhwJhXfm/sbZHKWKosW+tHnHT8l0v/jmiwi9K0QzqLXj9Frb/0e/6KA==
X-Received: by 2002:a17:90a:f189:b0:262:ff1c:bc33 with SMTP id bv9-20020a17090af18900b00262ff1cbc33mr387194pjb.13.1689634208919;
        Mon, 17 Jul 2023 15:50:08 -0700 (PDT)
Received: from ?IPV6:2600:1700:e321:62f0:329c:23ff:fee3:9d7c? ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id me13-20020a17090b17cd00b00263dccf96a3sm261125pjb.54.2023.07.17.15.50.07
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 17 Jul 2023 15:50:08 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Message-ID: <9705c130-997d-6356-18bc-ee5ce5d8b325@roeck-us.net>
Date: Mon, 17 Jul 2023 15:50:06 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.13.0
Subject: Re: [PATCH 6.1 000/589] 6.1.39-rc3 review
Content-Language: en-US
To: Paul Barker <paul.barker.ct@bp.renesas.com>,
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org, shuah@kernel.org,
 patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
 jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
 srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org
References: <20230717201547.359923764@linuxfoundation.org>
 <9da5f8cb-5ed0-1854-0a0a-252794e01ce3@bp.renesas.com>
From: Guenter Roeck <linux@roeck-us.net>
In-Reply-To: <9da5f8cb-5ed0-1854-0a0a-252794e01ce3@bp.renesas.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 7/17/23 15:39, Paul Barker wrote:
> Hi Greg,
> 
> On 17/07/2023 21:34, Greg Kroah-Hartman wrote:
>> This is the start of the stable review cycle for the 6.1.39 release.
>> There are 589 patches in this series, all will be posted as a response
>> to this one.  If anyone has any issues with these being applied, please
>> let me know.
>>
>> Responses should be made by Wed, 19 Jul 2023 20:14:46 +0000.
>> Anything received after that time might be too late.
>>
>> The whole patch series can be found in one patch at:
>>     https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.1.39-rc3.gz
>> or in the git tree and branch at:
>>     git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.1.y
>> and the diffstat can be found below.
>>
>> thanks,
>>
>> greg k-h
>>
> 
> Building i386_defconfig in my Yocto Project environment (with gcc 13) fails:
> 
> | /.../kernel/workqueue.c: In function 'get_work_pwq':
> | /.../kernel/workqueue.c:706:24: error: cast to pointer from integer of different size [-Werror=int-to-pointer-cast]
> |   706 |                 return (void *)(data & WORK_STRUCT_WQ_DATA_MASK);
> |       |                        ^
> | /.../kernel/workqueue.c: In function 'get_work_pool':
> | /.../kernel/workqueue.c:734:25: error: cast to pointer from integer of different size [-Werror=int-to-pointer-cast]
> |   734 |                 return ((struct pool_workqueue *)
> |       |                         ^
> | /.../kernel/workqueue.c: In function 'get_work_pool_id':
> | /.../kernel/workqueue.c:756:25: error: cast to pointer from integer of different size [-Werror=int-to-pointer-cast]
> |   756 |                 return ((struct pool_workqueue *)
> |       |                         ^
> 
> Cherry-picking afa4bb778e48d79e4a642ed41e3b4e0de7489a6c from mainline fixes the build for me.
> 

That is not a new problem, though. I see the same problem with v6.1.38
and with v6.1 if I try to build with gcc 13.1.

Guenter

