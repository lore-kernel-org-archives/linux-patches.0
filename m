Received: from mail-pl1-f178.google.com (mail-pl1-f178.google.com [209.85.214.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA80C1E1AC
	for <patches@lists.linux.dev>; Thu, 10 Aug 2023 14:24:35 +0000 (UTC)
Received: by mail-pl1-f178.google.com with SMTP id d9443c01a7336-1bc65360648so8640395ad.1
        for <patches@lists.linux.dev>; Thu, 10 Aug 2023 07:24:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1691677475; x=1692282275;
        h=content-transfer-encoding:in-reply-to:references:cc:to:from
         :content-language:subject:user-agent:mime-version:date:message-id
         :sender:from:to:cc:subject:date:message-id:reply-to;
        bh=g7aVWMgiSCY8pbrReUeQfTDqSM2NOWq1Su86uIhB8xM=;
        b=ShmnbVqmdpWKk1Bgj5jhiPZZm9hzZaSTST7U59fSdo73Q6AsKb3l3uzMBfg1SHwa4H
         efQtrx3M6oCkAl1Kcbd2XhjWxPqDp1FmuDFthIlU6GL8OAVc+/W4a4l2RBtvEFL3XVlb
         xt/nYX4BredPMGzeqm97k1/GuPQ4EbiBqGVxf3rfIAxcc3ipaftpESMGbgFEhmvpcbpl
         Wp2/O00i11o+vWbxXlC+tkRo79lXtPzwwxXYhSWmQhQjzu6lPi155Iyzypzk4Qami/Y0
         FzSxDoqIE/j2eN0zG+aqovTnrOHGKS4QhXoXc2yOrPte0TD3vnYzdpTCqCR6DcwTx9nd
         JHvQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1691677475; x=1692282275;
        h=content-transfer-encoding:in-reply-to:references:cc:to:from
         :content-language:subject:user-agent:mime-version:date:message-id
         :sender:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=g7aVWMgiSCY8pbrReUeQfTDqSM2NOWq1Su86uIhB8xM=;
        b=ApFQ1hoX9Vd2Ou6316SyU4fD5K4NjTqRocNoxJgIVEObnmKcRo+qWrgLwbYLNIxFBc
         yF1gHMoFr5JNzs93FfQ4E2yDGw8IAm/1jQ4T768WH6enUycdm2ILsApnQCz6HtHAbXIc
         HZScLv5OsYSziaHNqER3vYqUj8Vh1Sc3GYUWreXfaHZaCHtpuVz0ssd0mOpEbrWIb6r6
         Mm2ZGajKkkT9/hGnQo0p01j7mZXv6vc1TSqMAUfWpLIH1YDqlTjzjFMHUvdsKs/Bo/up
         cn5v3IOQgjvmYWIyuQefAPdqPvHcqEaaJu9p/Tag9Z8KFXTMjW5qp6AF5d9HWRzl/mKS
         d7Sg==
X-Gm-Message-State: AOJu0YydAQZPJhQqOS/vqSai9ZFMvIf1neFkkvPhe82nfI/RRdxB7Xnu
	E5pXsou7YxB9Wlsg1NYtPCU=
X-Google-Smtp-Source: AGHT+IH3n1zkaG/y/IW0v36I+eu+pJIzWmUs6Wme5ATrsdqnMBHOIrtY+Pb3D3QfBp+9lBTHE8YmvQ==
X-Received: by 2002:a17:903:11c9:b0:1bc:48d7:f29b with SMTP id q9-20020a17090311c900b001bc48d7f29bmr3008767plh.27.1691677474846;
        Thu, 10 Aug 2023 07:24:34 -0700 (PDT)
Received: from ?IPV6:2600:1700:e321:62f0:329c:23ff:fee3:9d7c? ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id t3-20020a170902e84300b001bc59cd718asm1819355plg.278.2023.08.10.07.24.33
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 10 Aug 2023 07:24:34 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Message-ID: <fff0f61e-4260-f91a-2254-65daaffae45d@roeck-us.net>
Date: Thu, 10 Aug 2023 07:24:32 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.13.0
Subject: Re: [PATCH 4.19 000/323] 4.19.291-rc1 review
Content-Language: en-US
From: Guenter Roeck <linux@roeck-us.net>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org, shuah@kernel.org,
 patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
 jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
 srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org
References: <20230809103658.104386911@linuxfoundation.org>
 <252c7673-53ee-4c4b-e5ef-5bb2c0416154@roeck-us.net>
In-Reply-To: <252c7673-53ee-4c4b-e5ef-5bb2c0416154@roeck-us.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 8/10/23 06:55, Guenter Roeck wrote:
> On 8/9/23 03:37, Greg Kroah-Hartman wrote:
>> This is the start of the stable review cycle for the 4.19.291 release.
>> There are 323 patches in this series, all will be posted as a response
>> to this one.  If anyone has any issues with these being applied, please
>> let me know.
>>
>> Responses should be made by Fri, 11 Aug 2023 10:36:10 +0000.
>> Anything received after that time might be too late.
>>
> 
> Building sparc64:allnoconfig ... failed
> --------------
> Error log:
> <stdin>:1335:2: warning: #warning syscall rseq not implemented [-Wcpp]
> /opt/kernel/gcc-11.4.0-2.40-nolibc/sparc64-linux/bin/../lib/gcc/sparc64-linux/11.4.0/../../../../sparc64-linux/bin/ld: warning: arch/sparc/vdso/vdso-note.o: missing .note.GNU-stack section implies executable stack
> /opt/kernel/gcc-11.4.0-2.40-nolibc/sparc64-linux/bin/../lib/gcc/sparc64-linux/11.4.0/../../../../sparc64-linux/bin/ld: NOTE: This behaviour is deprecated and will be removed in a future version of the linker
> /opt/kernel/gcc-11.4.0-2.40-nolibc/sparc64-linux/bin/../lib/gcc/sparc64-linux/11.4.0/../../../../sparc64-linux/bin/ld: warning: arch/sparc/vdso/vdso32/vdso-note.o: missing .note.GNU-stack section implies executable stack
> /opt/kernel/gcc-11.4.0-2.40-nolibc/sparc64-linux/bin/../lib/gcc/sparc64-linux/11.4.0/../../../../sparc64-linux/bin/ld: NOTE: This behaviour is deprecated and will be removed in a future version of the linker
> sparc64-linux-ld: init/main.o: in function `start_kernel':
> main.c:(.init.text+0x77c): undefined reference to `arch_cpu_finalize_init'
> 
> Building sparc64:tinyconfig ... failed
> --------------
> Error log:
> <stdin>:1335:2: warning: #warning syscall rseq not implemented [-Wcpp]
> /opt/kernel/gcc-11.4.0-2.40-nolibc/sparc64-linux/bin/../lib/gcc/sparc64-linux/11.4.0/../../../../sparc64-linux/bin/ld: warning: arch/sparc/vdso/vdso-note.o: missing .note.GNU-stack section implies executable stack
> /opt/kernel/gcc-11.4.0-2.40-nolibc/sparc64-linux/bin/../lib/gcc/sparc64-linux/11.4.0/../../../../sparc64-linux/bin/ld: NOTE: This behaviour is deprecated and will be removed in a future version of the linker
> /opt/kernel/gcc-11.4.0-2.40-nolibc/sparc64-linux/bin/../lib/gcc/sparc64-linux/11.4.0/../../../../sparc64-linux/bin/ld: warning: arch/sparc/vdso/vdso32/vdso-note.o: missing .note.GNU-stack section implies executable stack
> /opt/kernel/gcc-11.4.0-2.40-nolibc/sparc64-linux/bin/../lib/gcc/sparc64-linux/11.4.0/../../../../sparc64-linux/bin/ld: NOTE: This behaviour is deprecated and will be removed in a future version of the linker
> sparc64-linux-ld: init/main.o: in function `start_kernel':
> main.c:(.init.text+0x764): undefined reference to `arch_cpu_finalize_init'

Introduced with v4.19.290.

