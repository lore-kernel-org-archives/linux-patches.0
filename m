Received: from mail-il1-f178.google.com (mail-il1-f178.google.com [209.85.166.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A2E1B24510
	for <patches@lists.linux.dev>; Wed,  9 Aug 2023 21:45:48 +0000 (UTC)
Received: by mail-il1-f178.google.com with SMTP id e9e14a558f8ab-3492c49c649so994965ab.3
        for <patches@lists.linux.dev>; Wed, 09 Aug 2023 14:45:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1691617547; x=1692222347;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :sender:from:to:cc:subject:date:message-id:reply-to;
        bh=hfnCZjZmqBGVlOLZIrSAWs+Ngt6gotXhjV95+8R8uJU=;
        b=Pu99zN9JXgQjGw6QvoXR38L2RZRrdYFNgjW0Y2IQTk2t+htTFCaqhTRSXVV80s9VpT
         qh66vnPK7tPOvRdtcGrI8SW9vRfhIt4CuGEf7y26B/EGnOJTmAehBedgHjECOS/tcJXY
         yXOk3s+ltfhdO2O8JO4RibKvXZNM/YwxU8hrGr+mILYFFM2kvA6LdvDENtzGu7BuiEge
         LR8skysU1fg/rveJQB8EDXJH8TOJr+r3J7jontqOZ7YxlMKtWFgk6Zzj0Ra9DVIRwzq2
         pkc6OPlXZWhpDEY1MG8enk7+zjLd8y9jd3ugEbaO3HBESFoKVXEi0WBQdLuEdMCDs26F
         LMTg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1691617547; x=1692222347;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :sender:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=hfnCZjZmqBGVlOLZIrSAWs+Ngt6gotXhjV95+8R8uJU=;
        b=P3BQhtkd7a92TAXGbr4moB34h4aFxUIhwdB7I+0VVZB2fD2jJ5d5W60QiNa3mjfpxh
         t8gvuhvoOhEuE0FfPaM+WSvKbespbjtcrcD8JxqlJYJHM/qp+No7/pXWXswFjd70Vg8L
         /OG2kDmwrg4NTPFLFaTOgzm8EWS5kuPogyvtRTOlJU/G7bRPoL5YPP7hbZGh+aBeK6kC
         8aDYbFkI55MHTA9RUufJwTm2fNQLIthgwM+dJ4J8LzCJHNlfDz6Ab/cNCdVSxV/68fDU
         T1PgtOfY2y2Fmo3ryhALrxg9yw60bNZWfpGnKf24L9zwEWuEUjV4EPgvFJkZtN/0blnu
         CfLA==
X-Gm-Message-State: AOJu0YzhqVIv1rOpPjh4+dqLfWI+tEeUJdmlgIBYeB84cOm5WMbTOY9a
	yJ3zMgJCwyDkgk4uaiydMXA=
X-Google-Smtp-Source: AGHT+IFtiC8E8uJIKVaqyAfIFRAZj8bZtnvywPvS+QrugzgIp20vh/FKVGfYR1DZszLxGDfqa6GYog==
X-Received: by 2002:a05:6e02:b43:b0:345:d3bc:8882 with SMTP id f3-20020a056e020b4300b00345d3bc8882mr468043ilu.24.1691617547384;
        Wed, 09 Aug 2023 14:45:47 -0700 (PDT)
Received: from ?IPV6:2600:1700:e321:62f0:329c:23ff:fee3:9d7c? ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id o17-20020a92dad1000000b00345840d442csm4391063ilq.66.2023.08.09.14.45.44
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 09 Aug 2023 14:45:46 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Message-ID: <4dbe72a3-50ea-051c-96ba-d709b33d3a98@roeck-us.net>
Date: Wed, 9 Aug 2023 14:45:44 -0700
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
 <6b05a082-41a7-f0cf-c0a4-1cced8d5a230@roeck-us.net>
 <CAEXW_YT-7epvu4uUS19aDAcM0X63j9_L2aa-XGGFGSLceLu8bA@mail.gmail.com>
From: Guenter Roeck <linux@roeck-us.net>
In-Reply-To: <CAEXW_YT-7epvu4uUS19aDAcM0X63j9_L2aa-XGGFGSLceLu8bA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 8/9/23 13:39, Joel Fernandes wrote:
> On Wed, Aug 9, 2023 at 4:38 PM Guenter Roeck <linux@roeck-us.net> wrote:
>>
>> On 8/9/23 13:14, Joel Fernandes wrote:
>>> On Wed, Aug 09, 2023 at 12:25:48PM -0700, Guenter Roeck wrote:
>>>> On Wed, Aug 09, 2023 at 02:35:59PM -0400, Joel Fernandes wrote:
>>>>> On Wed, Aug 9, 2023 at 12:18 PM Guenter Roeck <linux@roeck-us.net> wrote:
>>>>>>
>>>>>> On 8/9/23 06:53, Joel Fernandes wrote:
>>>>>>> On Wed, Aug 09, 2023 at 12:40:36PM +0200, Greg Kroah-Hartman wrote:
>>>>>>>> This is the start of the stable review cycle for the 5.15.126 release.
>>>>>>>> There are 92 patches in this series, all will be posted as a response
>>>>>>>> to this one.  If anyone has any issues with these being applied, please
>>>>>>>> let me know.
>>>>>>>>
>>>>>>>> Responses should be made by Fri, 11 Aug 2023 10:36:10 +0000.
>>>>>>>> Anything received after that time might be too late.
>>>>>>>>
>>>>>>>> The whole patch series can be found in one patch at:
>>>>>>>>        https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.126-rc1.gz
>>>>>>>> or in the git tree and branch at:
>>>>>>>>        git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.15.y
>>>>>>>> and the diffstat can be found below.
>>>>>>>
>>>>>>> Not necesscarily new with 5.15 stable but 3 of the 19 rcutorture scenarios
>>>>>>> hang with this -rc: TREE04, TREE07, TASKS03.
>>>>>>>
>>>>>>> 5.15 has a known stop machine issue where it hangs after 1.5 hours with cpu
>>>>>>> hotplug rcutorture testing. Me and tglx are continuing to debug this. The
>>>>>>> issue does not show up on anything but 5.15 stable kernels and neither on
>>>>>>> mainline.
>>>>>>>
>>>>>>
>>>>>> Do you by any have a crash pattern that we could possibly use to find the crash
>>>>>> in ChromeOS crash logs ? No idea if that would help, but it could provide some
>>>>>> additional data points.
>>>>>
>>>>> The pattern shows as a hard hang, the system is unresponsive and all CPUs
>>>>> are stuck in stop_machine. Sometimes it recovers on its own from the
>>>>> hang and then RCU immediately gives stall warnings. It takes 1.5 hour
>>>>> to reproduce and sometimes never happens for several hours.
>>>>>
>>>>> It appears related to CPU hotplug since gdb showed me most of the CPUs
>>>>> are spinning in multi_cpu_stop() / stop machine after the hang.
>>>>>
>>>>
>>>> Hmm, we do see lots of soft lockups with multi_cpu_stop() in the backtrace,
>>>> but not with v5.15.y but with v5.4.y. The actual hang is in stop_machine_yield().
>>>
>>> Interesting. It looks similar as far as the stack dump in gdb goes, here are
>>> the stacks I dumped with the hang I referred to:
>>> https://paste.debian.net/1288308/
>>>
>>
>> That link gives me "Entry not found".
> 
> Yeah that was weird. Here it is again: https://pastebin.com/raw/L3nv1kH2

I found a couple of crash reports from chromeos-5.10, one of them complaining
about RCU issues. I sent you links via IM. Nothing from 5.15 or later, though.

Guenter

