Received: from mail-pl1-f177.google.com (mail-pl1-f177.google.com [209.85.214.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A472B110A
	for <patches@lists.linux.dev>; Sat, 10 Jun 2023 21:14:09 +0000 (UTC)
Received: by mail-pl1-f177.google.com with SMTP id d9443c01a7336-1b24cd75989so14797555ad.1
        for <patches@lists.linux.dev>; Sat, 10 Jun 2023 14:14:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1686431649; x=1689023649;
        h=content-transfer-encoding:in-reply-to:subject:from:references:cc:to
         :content-language:user-agent:mime-version:date:message-id:sender
         :from:to:cc:subject:date:message-id:reply-to;
        bh=fwSnkwhmwp112bJQnIFMHYgVOaOrFSdte6uBVZoZTyw=;
        b=YHiV1L1XrQ05Vmg1SThZ3JwAuNoT9YM+/3VKDVsHR5LLuvBg/UL4GpbFVUih/CYBLy
         9acra23fFx1pVt18NUez5UMP3dJobntDaY9IIGd3Mbshiut/qGXHdcciEOsbUuA9emRC
         OTCkuu+qcSm9sm8rItGX4R0JLmK+67j7lD9HEuSospLH9z9zMWlSYz7vLh6g90BmMiR9
         7v9mJmVhfsPspLzw9l/0zefSkxRDNJvBiBh8FE2/gUIs6BhGtFZGpKIiItl1tL0/38hm
         b7T1+zh0DEvsvbqaca8e5ALQB5cF5neZTmATekH4GiJLT0nkGwUi3qQF43oAL7x1ynSE
         ro9Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686431649; x=1689023649;
        h=content-transfer-encoding:in-reply-to:subject:from:references:cc:to
         :content-language:user-agent:mime-version:date:message-id:sender
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=fwSnkwhmwp112bJQnIFMHYgVOaOrFSdte6uBVZoZTyw=;
        b=MWcNHHGRVkx7kBwAmyjTcd7rjqsXYNHxBvcJVZGMhJ4QR/l1zzwKSYw82oZ/S8kGWk
         gEro5dT7RFFBfbw8+fa5fPlVlSdq/mt0X6HQwhTfwVJK+ZDltwqE3f+SV/+cLH43iEZi
         OAshNC26iakEF4WgmG8EcRevW5MZCdhHdZ7MjEuLXC1pnWkFr4BYH6hrJm20khI5gi25
         SM3kjZGSEMx8GyzVatAZMDSTOzLurY5UuCMNtLMzAMXxE2SJyEFNnzS482cbHxeQ7LXg
         +ZovVMTlQ/SY0tgNRTGVJ9BToJ2H+Q7o5+ZELXdLJPGxgMnsxukfeUme60HI4SoMP+p0
         W/Iw==
X-Gm-Message-State: AC+VfDzyc8EPK6eBK9yA1WRStNLAu6eQgmjpMDj2sHSbwmn4Tf29pWDO
	BAZPDX5LdTGZU+NgSHzI0LA=
X-Google-Smtp-Source: ACHHUZ4bIToj/UioCH9Fxd3nKofkQ4Bv57VphE1mNt36PvZjW0S7G2634DFjzInhqgWukrl7vQTFNA==
X-Received: by 2002:a17:902:d492:b0:1b0:113e:1047 with SMTP id c18-20020a170902d49200b001b0113e1047mr3161439plg.62.1686431648868;
        Sat, 10 Jun 2023 14:14:08 -0700 (PDT)
Received: from ?IPV6:2600:1700:e321:62f0:329c:23ff:fee3:9d7c? ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id o3-20020a170902d4c300b001a24cded097sm5402462plg.236.2023.06.10.14.14.07
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 10 Jun 2023 14:14:08 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Message-ID: <39b34446-88a7-eeb5-cf95-e4f1843100b3@roeck-us.net>
Date: Sat, 10 Jun 2023 14:14:06 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.11.0
Content-Language: en-US
To: Pavel Machek <pavel@denx.de>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
 patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org, shuah@kernel.org,
 patches@kernelci.org, lkft-triage@lists.linaro.org, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, Thomas Gleixner <tglx@linutronix.de>,
 Ido Schimmel <idosch@nvidia.com>
References: <20230607200903.652580797@linuxfoundation.org>
 <b979807a-a437-4d3f-98f9-989da52abb30@roeck-us.net>
 <d35b1ff1-e198-481c-b1be-9e22445efe06@roeck-us.net>
 <ZITNw9cv/WoZcSaO@duo.ucw.cz>
From: Guenter Roeck <linux@roeck-us.net>
Subject: Re: [PATCH 5.15 000/159] 5.15.116-rc1 review
In-Reply-To: <ZITNw9cv/WoZcSaO@duo.ucw.cz>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Hi,

On 6/10/23 12:23, Pavel Machek wrote:
> Hi!
> 
>>> Build results:
>>> 	total: 155 pass: 155 fail: 0
>>> Qemu test results:
>>> 	total: 499 pass: 498 fail: 1
>>> Failed tests:
>>> 	arm:kudo-bmc:multi_v7_defconfig:npcm:usb0.1:nuvoton-npcm730-kudo:rootfs
>>>
>>> The test failure is spurious and not new. I observe it randomly on
>>> multi_v7_defconfig builds, primarily on npcm platforms. There is no error
>>> message, just a stalled boot. I have been trying to bisect for a while,
>>> but I have not been successful so far. No immediate concern; I just wanted
>>> to mention it in case someone else hits the same or a similar problem.
>>>
>>
>> I managed to revise my bisect script sufficiently enough to get reliable
>> results. It looks like the culprit is commit 503e554782c9 (" debugobject:
>> Ensure pool refill (again)"); see bisect log below. Bisect on four
>> different systems all have the same result. After reverting this patch,
>> I do not see the problem anymore (again, confirmed on four different
>> systems). If anyone has an idea how to debug this, please let me know.
>> I'll be happy to give it a try.
> 
> You may want to comment out debug_objects_fill_pool() in
> debug_object_activate or debug_object_assert_init to see which one is
> causing the failure...
> 
> CONFIG_PREEMPT_RT is disabled for you, right? (Should 5.15 even have
> that option?)
> 

CONFIG_PREEMPT_RT is disabled (it depends on ARCH_SUPPORTS_RT which is not
enabled by any architecture in v5.15.y).

The added call in debug_object_activate() triggers the problem.
Any idea what to do about it or how to debug it further ?

Thanks,
Guenter

