Received: from mail-oi1-f175.google.com (mail-oi1-f175.google.com [209.85.167.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E125AD5A
	for <patches@lists.linux.dev>; Fri,  3 Feb 2023 19:28:51 +0000 (UTC)
Received: by mail-oi1-f175.google.com with SMTP id s66so5031258oib.7
        for <patches@lists.linux.dev>; Fri, 03 Feb 2023 11:28:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :sender:from:to:cc:subject:date:message-id:reply-to;
        bh=LNv6LLpCvBmjs2M9EoGEVHNv766Oz0fMNWuBCC4P26Q=;
        b=TDWI6UMjunazhVuRrFR8JDYyuj1aEYf1L+zYM8McBROHcw1rk6wgApHll67UZAdzth
         lvmYTYHsMBCcs/6BFDvRk8ojVaJ62v8HrlhKqqpDyvYOMyV4pKVkrhYox5rFnPVaP6b2
         +IL1fzLZA5iCOktDTMim0qifp5OHtSEKgkb1hO2TwOH40eDeWXmyo1XgZKLFN47xsMoy
         a1k5A6+bja0j2lqDu8g3eo4/DXKX/0eeDnHijjgizoe3NHXM6uLTPZfxsogGQ/3BpLkk
         j9jzA6F3T4MCxKsc3cf9ktjuHSToZWT48NC+mjPkVnp408mnl6dCPNYR4GADUQ4WUhMT
         5lBw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :sender:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=LNv6LLpCvBmjs2M9EoGEVHNv766Oz0fMNWuBCC4P26Q=;
        b=eI3x/a98//4QB6GyD/0ytXNeTcnRTnwSG8JONfmkq5cPYFWqXj5Jjpkitl4VZ4HBEq
         AbbyBTFH6t3HNotprZyno2iKzow2uUyZ30yrsnyUOKb4eWcIZndSbdiHKuPWEDtbEFcm
         tjSYfU4dGB8giBACvQjta4+wTKLrzbdi3HRSqlfvc+rR5KAdtaApbYfTVvtJ60HEV5YU
         IUPeU0q5jUwGQDiauxfpYStoqaiR5lu3f/bLnMjGrjIK1Ona43VS2SQIqWQosKUP29BP
         cQoExtBsJ1L7dH7riScYr85g80XVUsrK1Vaz2BhTlNYlIBFIG4MNwpE/B5k/6i2wS4TM
         q26w==
X-Gm-Message-State: AO0yUKU6xwGLPF9s709KeLzkK7/TTT7nI2nHj12YzxZ+/Uu/j2DqnH+t
	S4wD6kQWeCgMVGdVxcaRelk=
X-Google-Smtp-Source: AK7set87wdANkr75YErqha3aFxTJmv6DDqClUOfw7Rkz37unMSDyEoWqtowQWA3w+cjMD6yWV6oe/A==
X-Received: by 2002:a05:6808:1983:b0:37a:ca27:ae45 with SMTP id bj3-20020a056808198300b0037aca27ae45mr3786035oib.14.1675452530195;
        Fri, 03 Feb 2023 11:28:50 -0800 (PST)
Received: from ?IPV6:2600:1700:e321:62f0:329c:23ff:fee3:9d7c? ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id p205-20020aca42d6000000b0037ad30a2dc3sm1143135oia.23.2023.02.03.11.28.47
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 03 Feb 2023 11:28:49 -0800 (PST)
Sender: Guenter Roeck <groeck7@gmail.com>
Message-ID: <705ab151-da1e-30e1-c232-c9860717267d@roeck-us.net>
Date: Fri, 3 Feb 2023 11:28:46 -0800
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.2
Subject: Re: [PATCH 5.4 000/134] 5.4.231-rc1 review
Content-Language: en-US
To: Eric Biggers <ebiggers@kernel.org>,
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
 linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
 akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de
References: <20230203101023.832083974@linuxfoundation.org>
 <20230203155619.GA3176223@roeck-us.net> <Y906Hz3UWYxoxYdD@kroah.com>
 <20230203171826.GA1500930@roeck-us.net> <Y91YWzopMMGF1Lgh@sol.localdomain>
 <Y91bjnIuQRvVqpO7@sol.localdomain>
From: Guenter Roeck <linux@roeck-us.net>
In-Reply-To: <Y91bjnIuQRvVqpO7@sol.localdomain>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 2/3/23 11:07, Eric Biggers wrote:
> On Fri, Feb 03, 2023 at 10:54:21AM -0800, Eric Biggers wrote:
>> On Fri, Feb 03, 2023 at 09:18:26AM -0800, Guenter Roeck wrote:
>>> On Fri, Feb 03, 2023 at 05:45:19PM +0100, Greg Kroah-Hartman wrote:
>>>> On Fri, Feb 03, 2023 at 07:56:19AM -0800, Guenter Roeck wrote:
>>>>> On Fri, Feb 03, 2023 at 11:11:45AM +0100, Greg Kroah-Hartman wrote:
>>>>>> This is the start of the stable review cycle for the 5.4.231 release.
>>>>>> There are 134 patches in this series, all will be posted as a response
>>>>>> to this one.  If anyone has any issues with these being applied, please
>>>>>> let me know.
>>>>>>
>>>>>> Responses should be made by Sun, 05 Feb 2023 10:09:58 +0000.
>>>>>> Anything received after that time might be too late.
>>>>>>
>>>>>
>>>>> Building ia64:defconfig ... failed
>>>>> --------------
>>>>> Error log:
>>>>> <stdin>:1511:2: warning: #warning syscall clone3 not implemented [-Wcpp]
>>>>> arch/ia64/kernel/mca_drv.c: In function 'mca_handler_bh':
>>>>> arch/ia64/kernel/mca_drv.c:179:9: error: implicit declaration of function 'make_task_dead'
>>>>>
>>>>> Caused by "exit: Add and use make_task_dead.". Did that really have to be backported ?
>>>>
>>>> Yup, it does!
>>>>
>>>> Eric, any help with this?
>>>>
>>>
>>> Adding "#include <linux/sched/task.h>" to the affected file would probably
>>> be the easy fix. I did a quick check, and it works.
>>>
>>> Note that the same problem is seen in v4.14.y and v4.19.y. Later
>>> kernels don't have the problem.
>>>
>>
>> This problem arises because <linux/mm.h> transitively includes
>> <linux/sched/task.h> in 5.10 and later, but not in 5.4 and earlier.
>>
>> Greg, any preference for how to handle this situation?
>>
>> Just add '#include <linux/sched/task.h>' to the affected .c file (and hope there
>> are no more affected .c files in the other arch directories) and call it a day?
>>
>> Or should we backport the transitive inclusion (i.e., the #include added by
>> commit 80fbaf1c3f29)?  Or move the declaration of make_task_dead() into
>> <linux/kernel.h> so that it's next to do_exit()?
> 
> One question: do *all* the arches actually get built as part of the testing for
> each stable release?  If so, we can just add the #include to the .c files that
> need it.  If not, then it would be safer to take one of the other approaches.
> 

Yes, I do build all architectures for each stable release.

FWIW, I only noticed that one build failure due to this problem.

Guenter

