Received: from mail-pl1-f174.google.com (mail-pl1-f174.google.com [209.85.214.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3CD9EAFE6
	for <patches@lists.linux.dev>; Tue, 18 Apr 2023 18:47:46 +0000 (UTC)
Received: by mail-pl1-f174.google.com with SMTP id q2so32943861pll.7
        for <patches@lists.linux.dev>; Tue, 18 Apr 2023 11:47:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1681843665; x=1684435665;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :sender:from:to:cc:subject:date:message-id:reply-to;
        bh=qdrElW73CyUlcUQEClO9EDUAz3mThnr1vcZk4xLQL2k=;
        b=MyDX1zU5nDUFfCk7a8bqMnmAoiE+/xQMuOgeWvgr4UbWB9NVcgfTrYc9XIwjtd6eLN
         ekqQEyaGmCmygL7e31av4ogs7r9J+T0icRsx0szp56/AOvQYljJMfKowIcR4qP+5O3va
         ps9my6LUGYeqHl0lm2ML51nFAmQZj/arP5PPQRVSuPvbG/OYpGpDXP2BKSHQS+B6eRWm
         EEVLtnWEHp7TGl/EwnSUVEU/1Rp0KJQmksl2rQ7tse8nxTnYp/jkPuty2sK6ault5/fN
         pOa1f/FV8xRwX1fhI/i3daIgQu8rJ9ZjgGfS7Wze2vmyUhqex8SzxQY+0NpWXUFicvqA
         e+ww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681843665; x=1684435665;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :sender:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=qdrElW73CyUlcUQEClO9EDUAz3mThnr1vcZk4xLQL2k=;
        b=ZXufyUHq6EHhepzRU/IwCBOd+zYVJetzrkheLZIXn37MayoK0aGKl/VGJJ70PQrZ6X
         l4JZwH5Zk+X2LF+iFHbyzgTgIua5hIfbZs9udR9qq+at+lHtlW+i1WiAx21LO1QgM+LF
         QJdXAl1SNtkmtpgf1h82TQT0BAkRoDDm2fXAfRCyWM+lxmJ1pDdVxAigUNOkVHyY2GTL
         GVJp5Zjb4WGTFpqzY4KV6u5teG9yzF8uBoXPYh1n11DRKP4X2Nia5n25ys4tKIhW5SLK
         6TrEJO6C13i0EuNJN3Z8aK0cVIrDnga1wB9YEKKV5oHg7XSTwi34hWN2/dcrVZhIAQ1r
         iN8w==
X-Gm-Message-State: AAQBX9ckcav+iA/K6cU9UH6LafPy4dHtCvBf7EUHxlfgiJqwz+5DuK7K
	bGjDIwLY9vAMQ83TdLbXMmY=
X-Google-Smtp-Source: AKy350YWAZo62MlxCISzCzTXCWB6HNcLN+rogclsKSl19ZhfESlpqOSpTd+nyaD1f8ff6CcIRE3pqA==
X-Received: by 2002:a05:6a20:938b:b0:ef:e017:c60f with SMTP id x11-20020a056a20938b00b000efe017c60fmr593762pzh.51.1681843665590;
        Tue, 18 Apr 2023 11:47:45 -0700 (PDT)
Received: from ?IPV6:2600:1700:e321:62f0:329c:23ff:fee3:9d7c? ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id d3-20020a63d703000000b0050bc4ca9024sm9106874pgg.65.2023.04.18.11.47.43
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 18 Apr 2023 11:47:44 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Message-ID: <81e21f0a-a149-7bd7-e37d-741ddce101eb@roeck-us.net>
Date: Tue, 18 Apr 2023 11:47:42 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.0
Subject: Re: [PATCH 5.10 000/124] 5.10.178-rc1 review
Content-Language: en-US
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
 Naresh Kamboju <naresh.kamboju@linaro.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
 linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
 akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, Waiman Long <longman@redhat.com>, Tejun Heo <tj@kernel.org>,
 =?UTF-8?Q?Michal_Koutn=c3=bd?= <mkoutny@suse.com>
References: <20230418120309.539243408@linuxfoundation.org>
 <CA+G9fYsA+CzsxVYgQEN3c2pOV6F+1EOqY1vQrhj8yt1t-EYs7g@mail.gmail.com>
 <2023041819-canyon-unarmored-38c6@gregkh>
From: Guenter Roeck <linux@roeck-us.net>
In-Reply-To: <2023041819-canyon-unarmored-38c6@gregkh>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 4/18/23 08:34, Greg Kroah-Hartman wrote:
> On Tue, Apr 18, 2023 at 08:38:47PM +0530, Naresh Kamboju wrote:
>> On Tue, 18 Apr 2023 at 18:03, Greg Kroah-Hartman
>> <gregkh@linuxfoundation.org> wrote:
>>>
>>> This is the start of the stable review cycle for the 5.10.178 release.
>>> There are 124 patches in this series, all will be posted as a response
>>> to this one.  If anyone has any issues with these being applied, please
>>> let me know.
>>>
>>> Responses should be made by Thu, 20 Apr 2023 12:02:44 +0000.
>>> Anything received after that time might be too late.
>>>
>>> The whole patch series can be found in one patch at:
>>>          https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.178-rc1.gz
>>> or in the git tree and branch at:
>>>          git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.10.y
>>> and the diffstat can be found below.
>>>
>>> thanks,
>>>
>>> greg k-h
>>
>> Following build errors noticed on 5.15 and 5.10.,
>>
>>
>>> Waiman Long <longman@redhat.com>
>>>      cgroup/cpuset: Change references of cpuset_mutex to cpuset_rwsem
>>
> 
> That's a documentation patch, it can not:
> 
>> kernel/cgroup/cpuset.c: In function 'cpuset_can_fork':
>> kernel/cgroup/cpuset.c:2941:30: error: 'cgroup_mutex' undeclared
>> (first use in this function); did you mean 'cgroup_put'?
>>   2941 |         lockdep_assert_held(&cgroup_mutex);
> 
> Cause this.
> 
> What arch is failing here?  This builds for x86.
> 
No, it doesn't.

Build reference: v5.10.177-125-g19b9d9b9f62e
Compiler version: x86_64-linux-gcc (GCC) 11.3.0
Assembler version: GNU assembler (GNU Binutils) 2.39

Building x86_64:defconfig ... failed
--------------
Error log:
In file included from include/linux/rcupdate.h:29,
                  from include/linux/rculist.h:11,
                  from include/linux/pid.h:5,
                  from include/linux/sched.h:14,
                  from include/linux/ratelimit.h:6,
                  from include/linux/dev_printk.h:16,
                  from include/linux/device.h:15,
                  from include/linux/node.h:18,
                  from include/linux/cpu.h:17,
                  from kernel/cgroup/cpuset.c:25:
kernel/cgroup/cpuset.c: In function 'cpuset_can_fork':
kernel/cgroup/cpuset.c:2941:30: error: 'cgroup_mutex' undeclared (first use in this function); did you mean 'cgroup_put'?
  2941 |         lockdep_assert_held(&cgroup_mutex);
       |                              ^~~~~~~~~~~~
include/linux/lockdep.h:393:61: note: in definition of macro 'lockdep_assert_held'
   393 | #define lockdep_assert_held(l)                  do { (void)(l); } while (0)
       |                                                             ^
kernel/cgroup/cpuset.c:2941:30: note: each undeclared identifier is reported only once for each function it appears in
  2941 |         lockdep_assert_held(&cgroup_mutex);
       |                              ^~~~~~~~~~~~
include/linux/lockdep.h:393:61: note: in definition of macro 'lockdep_assert_held'
   393 | #define lockdep_assert_held(l)                  do { (void)(l); } while (0)
       |                                                             ^
make[3]: *** [scripts/Makefile.build:286: kernel/cgroup/cpuset.o] Error 1
make[3]: *** Waiting for unfinished jobs....
make[2]: *** [scripts/Makefile.build:503: kernel/cgroup] Error 2
make[2]: *** Waiting for unfinished jobs....
make[1]: *** [Makefile:1828: kernel] Error 2
make[1]: *** Waiting for unfinished jobs....
make: *** [Makefile:192: __sub-make] Error 2
