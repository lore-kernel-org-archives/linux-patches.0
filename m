Received: from mail-pf1-f174.google.com (mail-pf1-f174.google.com [209.85.210.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1ECE22453D
	for <patches@lists.linux.dev>; Wed,  9 Aug 2023 20:38:22 +0000 (UTC)
Received: by mail-pf1-f174.google.com with SMTP id d2e1a72fcca58-686be28e1a8so164301b3a.0
        for <patches@lists.linux.dev>; Wed, 09 Aug 2023 13:38:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1691613502; x=1692218302;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :sender:from:to:cc:subject:date:message-id:reply-to;
        bh=8/Z0/25k8a2DdGjSrsbfbrWoP5/6dQQ99jfQZHEVRjo=;
        b=dRz0yFgQzbfuX9vkGGccYHxbFHhxQ6KAXJ4UcMl5NW9UV/Y/pEtXFondu7uzAB1K3s
         rhYhFXeK0vT+WE8wnt37SQmasXng5hOYl/VYifq+GtoR2lZxh0Q6bQL35VyZ5G+OG+Nc
         yg0Lz09nyNyTTphM0tohD11++U9AzKujcXDrQyKoddRx2LMfnpbFEBLTwoPQYrTdsvkE
         p/v5LeGRv8zL07CNbeUG8JmB1ytUkpQkRS9zlr2AHwBRa7J8Tu8XCNXsKWeoNI1IF64c
         nLo2dAXrV3TnYheIIAalUIiMbBgH1YWpfpJjAfvGyW8p4j1UXwsB3YxXmzUQdEo2Yly2
         T6Yg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1691613502; x=1692218302;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :sender:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=8/Z0/25k8a2DdGjSrsbfbrWoP5/6dQQ99jfQZHEVRjo=;
        b=RtJ+WcCAdnTlCbmZCCGVzb0/H1YMotY2j4aCEL0llH/8qkW+ddJE7j4UfXTnTP4vWm
         5G668XLbvfrlhQb8wLc/a2b67Xj9M1Ma89LOXPyG0XlmSxHQploKWtUJRgd0jnj/p35U
         Qdbe5m5hPWZ/yqH/a2xJ+Yg0CgpAOW4YQcckHzsIpyX/aeUd7bCjHF0t0EsGrbW7zPrG
         gaUwP1P0pp2iP6tRux/D9Yyykb+3/tK5efl7AyOmTML+kxYl8d2JLnSTIzd54qSg+Z67
         RyDT225GdfDNGqafHPtptb0Jn50RBRfhJEaleT8HC2MkAZSUFwzdczFu3Fk+0KGp1gWF
         tWoA==
X-Gm-Message-State: AOJu0YycPprvU/mhflJY6dTKaMqs5CsDQ5Wsc4CkeMPVQSGs/QSWYwp+
	t4423+CX3QiL/t1yY3v0kqM=
X-Google-Smtp-Source: AGHT+IHkFNDOn/FAlzafEaJxRJP9XQUbV3GceIFwoTCQdlCbZk4ltJqhObVljQSbzJ10ojQ8l6gzRg==
X-Received: by 2002:a05:6a20:5507:b0:140:324c:124c with SMTP id ko7-20020a056a20550700b00140324c124cmr248997pzb.62.1691613502129;
        Wed, 09 Aug 2023 13:38:22 -0700 (PDT)
Received: from ?IPV6:2600:1700:e321:62f0:329c:23ff:fee3:9d7c? ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id y11-20020a63ad4b000000b00564250660f3sm12857pgo.78.2023.08.09.13.38.19
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 09 Aug 2023 13:38:21 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Message-ID: <6b05a082-41a7-f0cf-c0a4-1cced8d5a230@roeck-us.net>
Date: Wed, 9 Aug 2023 13:38:19 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.13.0
Subject: Re: [PATCH 5.15 00/92] 5.15.126-rc1 review
Content-Language: en-US
To: Joel Fernandes <joel@joelfernandes.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
 patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org, shuah@kernel.org,
 patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
 jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
 srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org, paulmck@kernel.org
References: <20230809103633.485906560@linuxfoundation.org>
 <20230809135326.GE3031656@google.com>
 <f47340c6-3c41-1f91-d0f9-fe0b59a23aac@roeck-us.net>
 <CAEXW_YQ4GqPwvUF8=8CWmdj=cD56v_eEVK-EirsObQXyBDFVpg@mail.gmail.com>
 <35e4b770-2ead-4a19-ad01-fa75996adef4@roeck-us.net>
 <20230809201413.GA3374446@google.com>
From: Guenter Roeck <linux@roeck-us.net>
In-Reply-To: <20230809201413.GA3374446@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 8/9/23 13:14, Joel Fernandes wrote:
> On Wed, Aug 09, 2023 at 12:25:48PM -0700, Guenter Roeck wrote:
>> On Wed, Aug 09, 2023 at 02:35:59PM -0400, Joel Fernandes wrote:
>>> On Wed, Aug 9, 2023 at 12:18 PM Guenter Roeck <linux@roeck-us.net> wrote:
>>>>
>>>> On 8/9/23 06:53, Joel Fernandes wrote:
>>>>> On Wed, Aug 09, 2023 at 12:40:36PM +0200, Greg Kroah-Hartman wrote:
>>>>>> This is the start of the stable review cycle for the 5.15.126 release.
>>>>>> There are 92 patches in this series, all will be posted as a response
>>>>>> to this one.  If anyone has any issues with these being applied, please
>>>>>> let me know.
>>>>>>
>>>>>> Responses should be made by Fri, 11 Aug 2023 10:36:10 +0000.
>>>>>> Anything received after that time might be too late.
>>>>>>
>>>>>> The whole patch series can be found in one patch at:
>>>>>>       https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.126-rc1.gz
>>>>>> or in the git tree and branch at:
>>>>>>       git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.15.y
>>>>>> and the diffstat can be found below.
>>>>>
>>>>> Not necesscarily new with 5.15 stable but 3 of the 19 rcutorture scenarios
>>>>> hang with this -rc: TREE04, TREE07, TASKS03.
>>>>>
>>>>> 5.15 has a known stop machine issue where it hangs after 1.5 hours with cpu
>>>>> hotplug rcutorture testing. Me and tglx are continuing to debug this. The
>>>>> issue does not show up on anything but 5.15 stable kernels and neither on
>>>>> mainline.
>>>>>
>>>>
>>>> Do you by any have a crash pattern that we could possibly use to find the crash
>>>> in ChromeOS crash logs ? No idea if that would help, but it could provide some
>>>> additional data points.
>>>
>>> The pattern shows as a hard hang, the system is unresponsive and all CPUs
>>> are stuck in stop_machine. Sometimes it recovers on its own from the
>>> hang and then RCU immediately gives stall warnings. It takes 1.5 hour
>>> to reproduce and sometimes never happens for several hours.
>>>
>>> It appears related to CPU hotplug since gdb showed me most of the CPUs
>>> are spinning in multi_cpu_stop() / stop machine after the hang.
>>>
>>
>> Hmm, we do see lots of soft lockups with multi_cpu_stop() in the backtrace,
>> but not with v5.15.y but with v5.4.y. The actual hang is in stop_machine_yield().
> 
> Interesting. It looks similar as far as the stack dump in gdb goes, here are
> the stacks I dumped with the hang I referred to:
> https://paste.debian.net/1288308/
> 

That link gives me "Entry not found".

Guenter

