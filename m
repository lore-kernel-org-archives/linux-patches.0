Received: from mail-pl1-f176.google.com (mail-pl1-f176.google.com [209.85.214.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C65CE31A8E
	for <patches@lists.linux.dev>; Wed, 20 Sep 2023 17:01:59 +0000 (UTC)
Received: by mail-pl1-f176.google.com with SMTP id d9443c01a7336-1c465d59719so31902835ad.1
        for <patches@lists.linux.dev>; Wed, 20 Sep 2023 10:01:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1695229319; x=1695834119; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=GHujuC4La1zbiPeEIuvGOEBBG8VELcRCDyL8zMCWV50=;
        b=RisQpt2KeL2v2MkLiXkRKpjtHUm1nssfvVswq0l0jsJE1mqBPLspdMn5ZNkds+3/CW
         ShnxEuL9unrXck/ERxPYt3NreGOT2IFkii50uM+TblF9dplu9eNUMHl/hEDgrKs0l4qM
         r1kWxWwgUPTMV2GAFLiSRl3dt3kYszV/bmfv50XE5vb4jbuZtWQ63/EdHTfcO9orRI0S
         EbbkITjfHtwdMp0/jh5Omhhym8JCF5Sf1+hcCE2LOLxhzf7AjgYAwwpN04sI++ZG+hiE
         eaywl8TWsa+2SmCrzHAQbVZdHSkLmub9aDzulvDF/DJJyn2PmXzNsMRbGRAiwqZN0KA1
         3wbQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1695229319; x=1695834119;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=GHujuC4La1zbiPeEIuvGOEBBG8VELcRCDyL8zMCWV50=;
        b=oqkAewm1OT1ajLJb6CcjdT1di2pj/LXeFAg12yQ3Op4d414wLw7HFSwVrTQyYHEVNN
         9MJ/Vukc/Ydnat82m3xMc6VKwzTEqiCVD7Eq8xDTTh8ypjHpZRMzaeTfnKEpjO6GMFW1
         dotHI4y2J7ocehYbGrnGjk7wAkt2RT+4I8IJL5eTEiKinkMf8frbcRVbJXLTJ+pNVAJF
         GQ6nE0RXdccxG8Sc8eDi19aueTOb9phYJCALibrUP1k0zcOWSvV4xsJTvxXdpW5AEY9Z
         lIJ8Yyd+uPZGC0574p9b6IzvZp/IiIYurzb/Pm/UyZgTzT5HwTYc0zyLWS0vL1IkWtRg
         xZew==
X-Gm-Message-State: AOJu0YxHUjm2BbCyQcmAUsZdu+A1APLjElpZnNce7VBvWxHmyGI/y3s3
	LSMBY9XWDFA45ELp+iUGso4=
X-Google-Smtp-Source: AGHT+IFQpH3spCEqxNoVJkXAHO0SCtX1qRc23XIa9dvA9l7bMarEU+YJBc7iSR3PfvjV9sunr1kZoQ==
X-Received: by 2002:a17:903:2601:b0:1c5:76b6:d4f8 with SMTP id jd1-20020a170903260100b001c576b6d4f8mr2632880plb.44.1695229318793;
        Wed, 20 Sep 2023 10:01:58 -0700 (PDT)
Received: from [10.67.49.139] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id u7-20020a170903124700b001bb0eebd90asm12058224plh.245.2023.09.20.10.01.56
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 20 Sep 2023 10:01:58 -0700 (PDT)
Message-ID: <8457ff12-c28b-898b-3f12-97aa12ce6716@gmail.com>
Date: Wed, 20 Sep 2023 10:01:55 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.15.1
Subject: Re: [PATCH 5.10 000/406] 5.10.195-rc1 review
Content-Language: en-US
To: Guenter Roeck <linux@roeck-us.net>,
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
 Kyle Zeng <zengyhkyle@gmail.com>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
 linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
 akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
 conor@kernel.org
References: <20230917191101.035638219@linuxfoundation.org>
 <07a04540-554c-4394-1e79-46ea665f8c03@roeck-us.net>
 <2023092009-angriness-sank-ae4f@gregkh>
 <27f978f3-11ca-6054-5160-ab66d4c918bc@roeck-us.net>
From: Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <27f978f3-11ca-6054-5160-ab66d4c918bc@roeck-us.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 9/20/23 08:18, Guenter Roeck wrote:
> On 9/20/23 01:11, Greg Kroah-Hartman wrote:
>> On Tue, Sep 19, 2023 at 09:57:25PM -0700, Guenter Roeck wrote:
>>> On 9/17/23 12:07, Greg Kroah-Hartman wrote:
>>>> This is the start of the stable review cycle for the 5.10.195 release.
>>>> There are 406 patches in this series, all will be posted as a response
>>>> to this one.  If anyone has any issues with these being applied, please
>>>> let me know.
>>>>
>>>> Responses should be made by Tue, 19 Sep 2023 19:10:04 +0000.
>>>> Anything received after that time might be too late.
>>>>
>>>
>>> chromeos-5.10 locks up in configfs_lookup() after the merge of 
>>> v5.10.195.
>>>
>>> I am a bit puzzled because I see
>>>
>>> c709c7ca020a configfs: fix a race in configfs_lookup()
>>>
>>> in v5.10.195 but not in the list of commits below. I guess I must be
>>> missing something.
>>
>> It was part of the big patchset, it was posted here:
>>     https://lore.kernel.org/r/20230917191101.511939651@linuxfoundation.org
>>
>> Not hidden at all :)
>>
>> and was submitted here:
>>     https://lore.kernel.org/r/ZPOZFHHA0abVmGx+@westworld
>>
>>> Either case, the code now looks as follows.
>>>
>>> configfs_lookup()
>>> {
>>>      ...
>>>      spin_lock(&configfs_dirent_lock);
>>>      ...
>>>          err = configfs_attach_attr(sd, dentry);
>>>      ...
>>>      spin_unlock(&configfs_dirent_lock);
>>>      ...
>>> }
>>>
>>> and
>>>
>>> configfs_attach_attr(...)
>>> {
>>>      ...
>>>      spin_lock(&configfs_dirent_lock);
>>>      ...
>>> }
>>>
>>> which unless it is way too late here and I really need to go to sleep
>>> just won't work.
>>
>> Kyle, you did the backport, any comments?
>>
> 
> After a good night sleep, the code still looks wrong to me. Reverting
> the offending patch in chromeos-5.10 solved the problem there.
> That makes me suspect that no one actually tests configfs.

Humm indeed, looking at our testing we don't have our USB devices being 
tested which would exercise configfs since we switch the USB device 
between different configurations (mass storage, serial, networking 
etc.). Let me see about adding that so we get some coverage.
-- 
Florian

