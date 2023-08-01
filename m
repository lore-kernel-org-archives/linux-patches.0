Received: from mail-il1-f174.google.com (mail-il1-f174.google.com [209.85.166.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 87C7720F83
	for <patches@lists.linux.dev>; Tue,  1 Aug 2023 17:32:50 +0000 (UTC)
Received: by mail-il1-f174.google.com with SMTP id e9e14a558f8ab-34913c049c4so13947605ab.2
        for <patches@lists.linux.dev>; Tue, 01 Aug 2023 10:32:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1690911169; x=1691515969;
        h=content-transfer-encoding:in-reply-to:subject:from:references:cc:to
         :content-language:user-agent:mime-version:date:message-id:sender
         :from:to:cc:subject:date:message-id:reply-to;
        bh=rxfffmnKLjMpRaF+oj2k9XWjuJzG7Mpl/8fOeP1Tlj8=;
        b=VcIp2nJOsFoMuplIw3t8qwptOiLdWXL8dwUmccUOs6t93Cc9xR9xVrWBEDBf7tzu0H
         uMXkDf38gFnQafLeR6fnO1wPdRHl5iaFTwuMX+LzJ646zOl1X7m4UuG+2amE2UqSqH7l
         Pz3zqm2tMdLhixWFTWqYqJBYiM0Rp5twyLOQGZfL1yEB7ZQ56l+PLOEzKsZeqrjbZ9uI
         yYkhyzfjZKUVKFRcfoMiQjHuWcnWn9JQi07F7ywdV02+cBq/mCzX6jAU/EEd11gV/o9h
         6RVkuiWqTuQJdrCYyAkC9qb8HWR3oXCEiGAuvcdT/gilw3zvbh1e+rZOiXiDzM0Pn0Ts
         jhIQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1690911169; x=1691515969;
        h=content-transfer-encoding:in-reply-to:subject:from:references:cc:to
         :content-language:user-agent:mime-version:date:message-id:sender
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=rxfffmnKLjMpRaF+oj2k9XWjuJzG7Mpl/8fOeP1Tlj8=;
        b=JkWTYyRVVHXAU8ReVKCX3SbWWYL8Xr7JQRcjp0vc843dH7dDLqiSkKur1+tKlVKCzt
         tX2OpN3obPvvIovyUAwAdWACnPRQVpgP0vpcr5LvKEcYCQMjnLHFfbBCNEUkEQo9sxCn
         BpSM1pbjcKf0BUbID0VBjSy1gQnnhwHk4VRspp+FMteMVsknTM15UDr15hYOi2XLUW2K
         +66PtyGlUibanVsdWoXrRNhCzH3KMvLYDV3VhNXoG5bjCW0EndPa5C0NAu2yFpzJspJm
         BulDMqm/On19pd2KltsrwY4XSR55O/nzLNeVjPWKjyv/KivRq3lfDHY/W5GjylRqcuXm
         cR8Q==
X-Gm-Message-State: ABy/qLb2ASRhm9Qa+1+o+lYXL7njWRaNnhkvX6QS3f7pARi2j2/2iRo9
	gzZEdYlfNI/S9LQJo4KrL9o=
X-Google-Smtp-Source: APBJJlEfYNHAmcDXBD2bJbxgOiEovrQqUA0zD0/q6PfUdnUPPnfhj2y4B95WeuHZ1i438RcxyPsVUQ==
X-Received: by 2002:a05:6e02:1a0d:b0:342:512a:ccec with SMTP id s13-20020a056e021a0d00b00342512accecmr13376561ild.31.1690911169208;
        Tue, 01 Aug 2023 10:32:49 -0700 (PDT)
Received: from ?IPV6:2600:1700:e321:62f0:329c:23ff:fee3:9d7c? ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id n11-20020a92d9cb000000b00345d2845c42sm3991233ilq.57.2023.08.01.10.32.46
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 01 Aug 2023 10:32:48 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Message-ID: <a05743a3-4dec-6af7-302f-d1d2a0db7d3e@roeck-us.net>
Date: Tue, 1 Aug 2023 10:32:45 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.13.0
Content-Language: en-US
To: Peter Zijlstra <peterz@infradead.org>
Cc: Roy Hopkins <rhopkins@suse.de>, Joel Fernandes <joel@joelfernandes.org>,
 paulmck@kernel.org, Pavel Machek <pavel@denx.de>,
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
 patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org, shuah@kernel.org,
 patches@kernelci.org, lkft-triage@lists.linaro.org, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org, rcu@vger.kernel.org,
 Ingo Molnar <mingo@kernel.org>
References: <2cfc68cc-3a2f-4350-a711-ef0c0d8385fd@paulmck-laptop>
 <D56D0318-A2EA-4448-8F4D-BE84706E26A5@joelfernandes.org>
 <3da81a5c-700b-8e21-1bde-27dd3a0b8945@roeck-us.net>
 <20230731141934.GK29590@hirez.programming.kicks-ass.net>
 <20230731143954.GB37820@hirez.programming.kicks-ass.net>
 <f5a18aa3-9db7-6ad2-33d5-3335a18e4e2f@roeck-us.net>
 <20230731145232.GM29590@hirez.programming.kicks-ass.net>
 <7ff2a2393d78275b14ff867f3af902b5d4b93ea2.camel@suse.de>
 <20230731161452.GA40850@hirez.programming.kicks-ass.net>
 <baa58a8e-54f0-2309-b34e-d62999a452a1@roeck-us.net>
 <20230731211517.GA51835@hirez.programming.kicks-ass.net>
From: Guenter Roeck <linux@roeck-us.net>
Subject: Re: scheduler problems in -next (was: Re: [PATCH 6.4 000/227]
 6.4.7-rc1 review)
In-Reply-To: <20230731211517.GA51835@hirez.programming.kicks-ass.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 7/31/23 14:15, Peter Zijlstra wrote:
> On Mon, Jul 31, 2023 at 09:34:29AM -0700, Guenter Roeck wrote:
>>> Ha!, I was poking around the same thing. My hack below seems to (so far,
>>> <20 boots) help things.
>>>
>>
>> So, dumb question:
>> How comes this bisects to "sched/fair: Remove sched_feat(START_DEBIT)" ?
> 
> That commit changes the timings of things; dumb luck otherwise.

Kind of scary. So I only experienced the problem because the START_DEBIT patch
happened to be queued roughly at the same time, and it might otherwise have
found its way unnoticed into the upstream kernel. That makes me wonder if this
or other similar patches may uncover similar problems elsewhere in the kernel
(i.e., either hide new or existing race conditions or expose existing ones).

This in turn makes me wonder if it would be possible to define a test which
would uncover such problems without the START_DEBIT patch. Any idea ?

Guenter

