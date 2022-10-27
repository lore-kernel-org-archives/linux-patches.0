Received: from mail-qk1-f175.google.com (mail-qk1-f175.google.com [209.85.222.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 94AB71C13
	for <patches@lists.linux.dev>; Thu, 27 Oct 2022 19:54:28 +0000 (UTC)
Received: by mail-qk1-f175.google.com with SMTP id j21so1897845qkk.9
        for <patches@lists.linux.dev>; Thu, 27 Oct 2022 12:54:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=L3SZEZa2CJV4SjO0lun68s17zx0qUNNwhmx2jM0d8fw=;
        b=a1VqFrUx5ufOx8Ndmi3Yz7UYzK6rz5jSxFqxr/oHJ2tuKPgqrAhVQCwrgLoNpzKVtX
         YFp+toDsrkIuZ/5EgBc2BIbnUWSdvtuFuM36lLr69oxtcAUaGtZADkKwhwE0ztyoH1Nx
         gn3sTwmG4/5Ok8FkKv16ljzU+cpR1jnrKKBJPAil9dZ3WSSyCC8H/BVbbCs30/olP4Xq
         Fhnbj0v9zW6CXkjtK4kVkw2NH63PcPtaW5Lqd8QY9bqTetHMmFp/r0U2PfgMUOJqXARu
         ZMlzWU2yFBagwIge8BUQZJrZvbH5GNCjdEHGsQtgoEjGEFw+tvSov5L+XM4JuIP1roHi
         V+lQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=L3SZEZa2CJV4SjO0lun68s17zx0qUNNwhmx2jM0d8fw=;
        b=Est6UGh9CZkkAJVGmwDHd3+ZJKrRXwpf0LniVdCt95zf8oCPeOGHzbzek6bscy1l3r
         4Gxt1DFaWQLXB+2VGKCoZtQ6spkZMw2tUO+HAs/HGwgSXHhGFaoF6yANPLiaketIc0rU
         3TbFAXPPfSKunMH6m/VM+EHAZxDxXkEI3FJ/ndAHus9ulRLdIlOsYfaXK0uxXO92h3xT
         4D2ZPFA0KyQYfv7ooD7avUsmr48h2ITZ+A3SAAe23taMrgsoB+zH7w7X40sJ+Ycp93qP
         FTEfFiEa28cLBtkZp7kY4eYeOzYoftpXiAwB9XmRPpvNv7aIPW+rSDJ/3vVFqm6xIwJx
         1BPA==
X-Gm-Message-State: ACrzQf0/RTvZRqbX6CL0Tn/wWV805qb2Wzi8hVkyhxZcg0SGMeVfjSn2
	oTfgPL/kD5/lnAZp6E+yCdY=
X-Google-Smtp-Source: AMsMyM5/3x/owzdlPKOOgN+JTLlnKbleEwOi3n4bsdz4hUh6J+BRXMMFedFYhMIGh9R+YX+bhp1C4Q==
X-Received: by 2002:a05:620a:440e:b0:6f6:2a11:c497 with SMTP id v14-20020a05620a440e00b006f62a11c497mr14149909qkp.213.1666900467381;
        Thu, 27 Oct 2022 12:54:27 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id h24-20020ac85498000000b00399b73d06f0sm1357418qtq.38.2022.10.27.12.54.21
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 27 Oct 2022 12:54:26 -0700 (PDT)
Message-ID: <d1a46ccc-cb07-fa51-f722-c48d6c84bf9d@gmail.com>
Date: Thu, 27 Oct 2022 12:54:18 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.2.2
Subject: Re: [PATCH 5.10 00/79] 5.10.151-rc1 review
Content-Language: en-US
To: Guenter Roeck <linux@roeck-us.net>, Pavel Machek <pavel@denx.de>,
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
 linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
 akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, srw@sladewatkins.net
References: <20221027165054.270676357@linuxfoundation.org>
 <8617f970-2a72-799b-530d-3a5bb07822a6@roeck-us.net>
 <Y1rbQqkdeliRrQPF@kroah.com> <20221027192744.GC11819@duo.ucw.cz>
 <ffeb2d7f-cfc6-887a-5751-d58545171526@roeck-us.net>
From: Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <ffeb2d7f-cfc6-887a-5751-d58545171526@roeck-us.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 10/27/22 12:39, Guenter Roeck wrote:
> On 10/27/22 12:27, Pavel Machek wrote:
>> On Thu 2022-10-27 21:25:54, Greg Kroah-Hartman wrote:
>>> On Thu, Oct 27, 2022 at 11:10:18AM -0700, Guenter Roeck wrote:
>>>> On 10/27/22 09:55, Greg Kroah-Hartman wrote:
>>>>> This is the start of the stable review cycle for the 5.10.151 release.
>>>>> There are 79 patches in this series, all will be posted as a response
>>>>> to this one.  If anyone has any issues with these being applied, 
>>>>> please
>>>>> let me know.
>>>>>
>>>>> Responses should be made by Sat, 29 Oct 2022 16:50:35 +0000.
>>>>> Anything received after that time might be too late.
>>>>>
>>>>
>>>> Building arm64:allmodconfig ... failed
>>>> --------------
>>>> Error log:
>>>> /bin/sh: scripts/pahole-flags.sh: Permission denied
>>>>
>>>> Indeed:
>>>>
>>>> $ ls -l scripts/pahole-flags.sh
>>>> -rw-rw-r-- 1 groeck groeck 530 Oct 27 11:08 scripts/pahole-flags.sh
>>>>
>>>> Compared to upstream:
>>>>
>>>> -rwxrwxr-x 1 groeck groeck 585 Oct 20 11:31 scripts/pahole-flags.sh
>>>
>>> Yeah, this is going to be an odd one.  I have to do this by hand as
>>> quilt and git quilt-import doesn't like setting the mode bit.
>>>
>>> I wonder if I should just make a single-commit release with this file in
>>> it, set to the proper permission, to get past this hurdle.  I'll think
>>> about it in the morning...
>>
>> Alternatively you can modify the caller to do /bin/sh /scripts/... so
>> it does not need a +x bit...
>>
> 
> That should be done in mainline, though.

This is the second time this is reported unfortunately, so while we 
could change things in mainline to avoid being dependent upon the file 
permissions stored in git, this really seems to be a workflow issue 
involving quilt.

Any chance you can run a fixup while you apply a patch Greg?
-- 
Florian

