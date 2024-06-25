Received: from mail-pl1-f178.google.com (mail-pl1-f178.google.com [209.85.214.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E3A717C7CA
	for <patches@lists.linux.dev>; Tue, 25 Jun 2024 19:35:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719344105; cv=none; b=NDD+y8J13m3q0EVGcfAQvnI6aHyVWQN9C4q0r5yqXzr7NqSQEBUiTQvtKzwVFbAyjluiX22Vv7nTiUQTgdLWIC/r88qi2fIPdyNKYJB4RNg/bcqx6eczGNTGamcExaWK8u8wZpYjr8/x3p87zMLw5y3DRYcb7D2HDPw4kWWsELs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719344105; c=relaxed/simple;
	bh=9RLvHYNRTu4KbVC6LCgL92ZtkH8kPc4iBf8DTz667os=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=UjH6/AtS+0t5OUfpB5BsRrEPX6e6uhSVGKzGhY51Q6hw6IZ+5cM24Z52aNCVZJlAPRPycsgykVw3tgQAMeuFzriVOuPkrQd+wdLBbZWh2Oe65mm2M2bcZIPmX6aHydg9bgEgs9fAZ+dKsNFa8iCzRNXm5HimLtsdiZYDTldPSXc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=roeck-us.net; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=eJVk361+; arc=none smtp.client-ip=209.85.214.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=roeck-us.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="eJVk361+"
Received: by mail-pl1-f178.google.com with SMTP id d9443c01a7336-1f65a3abd01so48048525ad.3
        for <patches@lists.linux.dev>; Tue, 25 Jun 2024 12:35:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1719344103; x=1719948903; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:sender:from:to:cc:subject:date:message-id:reply-to;
        bh=+rD0h5O+Z6CIEyFEGlASZTLTFM51ag41AlHwF91ZiSo=;
        b=eJVk361+M/v5VoUyJvmwkpnzKnErDvwxmXdTHmfwgUKe8C6NzhaWxdLnLuKqRWh62X
         DTgrLG1JIjjqBlesRcShW8DFtwgSSqBVMeH42tPlnJ1cf1yVpQZvB+PED1iDTkvS+SX3
         mhSRhxUdksiJHGKPEIA8FMGVCEHxmTvmL7/me7yF0P5QNvJRwSb45ni7tHVk8vFqxGy0
         2BNmpTsR9I1Eyk/Z/hsZCBBCNxSQJRYX8BamDTiS590kLe4MPOUDHt8jUo1hLK2Mr7Ia
         Z8eKdM8d1pODj9Q5H9xNlNDHGuuIgaaS2+AB2to6kmSH4UnxwOkg4xzKSISEaLWoMaQB
         APlg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1719344103; x=1719948903;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:sender:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=+rD0h5O+Z6CIEyFEGlASZTLTFM51ag41AlHwF91ZiSo=;
        b=IOvTVhnlELuR8tmyJJgXx991h48Yo/S1HRZkH5BhvXrR+p00JjHosqHcvVsMXO1gUj
         09iIhNPzAs2FBmYiV+QS3tJtQKNHtGKuuqX4bT45if/ZyuQQRY9jrroJ+8XrRKGAjVar
         U+kdRTN8x6j/dnuSH6OgWSTnzrYjFKpGR6tm2FoG/s9kTU+ft22ce1Jmzdldxu7pUa7I
         zaHO1eKqSwU3xT3i9ZfgRUen5UKxvkbeh3m7dpZicOfqnQ23/VIJ4OAmMEXlx31ki7Pp
         tTIJPmLUW38GQH1LbDX76Wk7kcyEGrLvxFpW/pBMBtUNX/fKN66RDT7KUJi7sCY1qQkl
         svGA==
X-Forwarded-Encrypted: i=1; AJvYcCWO2n+PSmmZI64D6qAE9UeFyeyK6LmXoDWrg6RKHqFh9ZLIm3ESekeh1LpJnOYgvqItnbdjsaKbEMdzVU4z1gjeuvsQpEFwqA==
X-Gm-Message-State: AOJu0YxOjWSv1vPe1zBnaRNSk/zCYfAy3wLmb5mnsH0dBKBSvyoM/y0i
	4eDrRDtTvGSpQvQ2JxBS8v7u8j0NOrA7rDJBKsBrtETgOhqDhjIx
X-Google-Smtp-Source: AGHT+IHsHUf8Qb/uMeMB2GbSsMWFif92oQ1RWW/2FOPiNdLrJic328XU/XJLsG0HE7rBcAq82j1o4g==
X-Received: by 2002:a17:902:e80c:b0:1fa:199d:6d66 with SMTP id d9443c01a7336-1fa23f1f71dmr121527645ad.59.1719344103228;
        Tue, 25 Jun 2024 12:35:03 -0700 (PDT)
Received: from ?IPV6:2600:1700:e321:62f0:329c:23ff:fee3:9d7c? ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-1f9ebbc8efbsm84873985ad.306.2024.06.25.12.35.01
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 25 Jun 2024 12:35:02 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Message-ID: <88a0fdf5-ffc5-4398-88cd-220a3a996164@roeck-us.net>
Date: Tue, 25 Jun 2024 12:35:00 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 5.10 000/770] 5.10.220-rc1 review
To: Chuck Lever III <chuck.lever@oracle.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
 linux-stable <stable@vger.kernel.org>,
 "patches@lists.linux.dev" <patches@lists.linux.dev>,
 Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
 Linus Torvalds <torvalds@linux-foundation.org>,
 Andrew Morton <akpm@linux-foundation.org>,
 "shuah@kernel.org" <shuah@kernel.org>,
 "patches@kernelci.org" <patches@kernelci.org>,
 "lkft-triage@lists.linaro.org" <lkft-triage@lists.linaro.org>,
 "pavel@denx.de" <pavel@denx.de>, "jonathanh@nvidia.com"
 <jonathanh@nvidia.com>, "f.fainelli@gmail.com" <f.fainelli@gmail.com>,
 "sudipm.mukherjee@gmail.com" <sudipm.mukherjee@gmail.com>,
 "srw@sladewatkins.net" <srw@sladewatkins.net>,
 "rwarsow@gmx.de" <rwarsow@gmx.de>, "conor@kernel.org" <conor@kernel.org>,
 "allen.lkml@gmail.com" <allen.lkml@gmail.com>,
 "broonie@kernel.org" <broonie@kernel.org>
References: <20240618123407.280171066@linuxfoundation.org>
 <e8c38e1c-1f9a-47e2-bdf5-55a5c6a4d4ec@roeck-us.net>
 <2024062543-magnifier-licking-ab9e@gregkh>
 <EEE94730-C043-47D8-A50A-47332201B3BF@oracle.com>
 <cf232ba1-a3f3-4931-8775-254d42e261e5@roeck-us.net>
 <B5D1D979-253A-4339-AF15-5DB3B8503698@oracle.com>
Content-Language: en-US
From: Guenter Roeck <linux@roeck-us.net>
Autocrypt: addr=linux@roeck-us.net; keydata=
 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
 mDW4+i+XlNFUPUYMrIKi9joBhu18ssf5i5Q=
In-Reply-To: <B5D1D979-253A-4339-AF15-5DB3B8503698@oracle.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 6/25/24 12:08, Chuck Lever III wrote:
> 
> 
>> On Jun 25, 2024, at 12:29 PM, Guenter Roeck <linux@roeck-us.net> wrote:
>>
>> On 6/25/24 08:13, Chuck Lever III wrote:
>>> Hi -
>>>> On Jun 25, 2024, at 11:04 AM, Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:
>>>>
>>>> On Tue, Jun 25, 2024 at 07:48:00AM -0700, Guenter Roeck wrote:
>>>>> On 6/18/24 05:27, Greg Kroah-Hartman wrote:
>>>>>> This is the start of the stable review cycle for the 5.10.220 release.
>>>>>> There are 770 patches in this series, all will be posted as a response
>>>>>> to this one.  If anyone has any issues with these being applied, please
>>>>>> let me know.
>>>>>>
>>>>>> Responses should be made by Thu, 20 Jun 2024 12:32:00 +0000.
>>>>>> Anything received after that time might be too late.
>>>>>>
>>>>>
>>>>> [ ... ]
>>>>>> Chuck Lever <chuck.lever@oracle.com>
>>>>>>      SUNRPC: Prepare for xdr_stream-style decoding on the server-side
>>>>>>
>>>>> The ChromeOS patches robot reports a number of fixes for the patches
>>>>> applied in 5.5.220. This is one example, later fixed with commit
>>>>> 90bfc37b5ab9 ("SUNRPC: Fix svcxdr_init_decode's end-of-buffer
>>>>> calculation"), but there are more. Are those fixes going to be
>>>>> applied in a subsequent release of v5.10.y, was there a reason to
>>>>> not include them, or did they get lost ?
>>>>
>>>> I saw this as well, but when I tried to apply a few, they didn't, so I
>>>> was guessing that Chuck had merged them together into the series.
>>>>
>>>> I'll defer to Chuck on this, this release was all his :)
>>> I did this port months ago, I've been waiting for the dust to
>>> settle on the 6.1 and 5.15 NFSD backports, so I've all but
>>> forgotten the status of individual patches.
>>> If you (Greg or Guenter) send me a list of what you believe is
>>> missing, I can have a look at the individual cases and then
>>> run the finished result through our NFSD CI gauntlet.
>>
>> This is what the robot reported so far:
>>
>> 1242a87da0d8 SUNRPC: Fix svcxdr_init_encode's buflen calculation
>>   Fixes: bddfdbcddbe2 ("NFSD: Extract the svcxdr_init_encode() helper")
>> 90bfc37b5ab9 SUNRPC: Fix svcxdr_init_decode's end-of-buffer calculation
>>   Fixes: 5191955d6fc6 ("SUNRPC: Prepare for xdr_stream-style decoding on the server-side")
>> 10396f4df8b7 nfsd: hold a lighter-weight client reference over CB_RECALL_ANY
>>   Fixes: 44df6f439a17 ("NFSD: add delegation reaper to react to low memory condition")
> 
> My naive search found:
> 
> Checking commit 44df6f439a17 ...
>    upstream fix 10396f4df8b75ff6ab0aa2cd74296565466f2c8d not found
> 10396f4df8b75ff6ab0aa2cd74296565466f2c8d nfsd: hold a lighter-weight client reference over CB_RECALL_ANY
>    upstream fix f385f7d244134246f984975ed34cd75f77de479f is already applied
> Checking commit a2071573d634 ...
>    upstream fix f1aa2eb5ea05ccd1fd92d235346e60e90a1ed949 not found
> f1aa2eb5ea05ccd1fd92d235346e60e90a1ed949 sysctl: fix proc_dobool() usability
> Checking commit bddfdbcddbe2 ...
>    upstream fix 1242a87da0d8cd2a428e96ca68e7ea899b0f4624 not found
> 1242a87da0d8cd2a428e96ca68e7ea899b0f4624 SUNRPC: Fix svcxdr_init_encode's buflen calculation
> Checking commit 9fe61450972d ...     upstream fix 2111c3c0124f7432fe908c036a50abe8733dbf38 not found
> 2111c3c0124f7432fe908c036a50abe8733dbf38 namei: fix kernel-doc for struct renamedata and more
> Checking commit 013c1667cf78 ...     upstream fix 2c0f0f3639562d6e38ee9705303c6457c4936eac not found
> 2c0f0f3639562d6e38ee9705303c6457c4936eac module: correctly exit module_kallsyms_on_each_symbol when fn() != 0
>    upstream fix 1e80d9cb579ed7edd121753eeccce82ff82521b4 not found
> 1e80d9cb579ed7edd121753eeccce82ff82521b4 module: potential uninitialized return in module_kallsyms_on_each_symbol()
> Checking commit 89ff87494c6e ...
>    upstream fix 5c11720767f70d34357d00a15ba5a0ad052c40fe not found
> 5c11720767f70d34357d00a15ba5a0ad052c40fe SUNRPC: Fix a NULL pointer deref in trace_svc_stats_latency()
> Checking commit 5191955d6fc6 ...
>    upstream fix 90bfc37b5ab91c1a6165e3e5cfc49bf04571b762 not found
> 90bfc37b5ab91c1a6165e3e5cfc49bf04571b762 SUNRPC: Fix svcxdr_init_decode's end-of-buffer calculation
>    upstream fix b9f83ffaa0c096b4c832a43964fe6bff3acffe10 not found
> b9f83ffaa0c096b4c832a43964fe6bff3acffe10 SUNRPC: Fix null pointer dereference in svc_rqst_free()
> 
> I'll look into backporting the missing NFSD and SUNRPC patches.
> 

My list didn't include patches with conflicts. There are a lot of them. Our robot
collects those, but doesn't focus on it. It also doesn't analyze just nfds/SUNRPC
patches, but all of them. I started an analysis to list all the fixes with
conflicts; so far I found about 100 of them. Three are tagged SUNRPC.

Upstream commit 8e088a20dbe3 ("SUNRPC: add a missing rpc_stat for TCP TLS")
   upstream: v6.9-rc7
     Fixes: 1548036ef120 ("nfs: make the rpc_stat per net namespace")
       in linux-5.4.y: 19f51adc778f
       in linux-5.10.y: afdbc21a92a0
       in linux-5.15.y: 7ceb89f4016e
       in linux-6.1.y: 2b7f2d663a96
       in linux-6.6.y: 260333221cf0
       upstream: v6.9-rc1
     Affected branches:
       linux-5.4.y (conflicts - backport needed)
       linux-5.10.y (conflicts - backport needed)
       linux-5.15.y (conflicts - backport needed)
       linux-6.1.y (conflicts - backport needed)
       linux-6.6.y (already applied)

Upstream commit aed28b7a2d62 ("SUNRPC: Don't dereference xprt->snd_task if it's a cookie")
   upstream: v5.17-rc2
     Fixes: e26d9972720e ("SUNRPC: Clean up scheduling of autoclose")
       in linux-5.4.y: 2d6f096476e6
       in linux-5.10.y: 2ab569edd883
       upstream: v5.15-rc1
     Affected branches:
       linux-5.4.y (conflicts - backport needed)
       linux-5.10.y (conflicts - backport needed)
       linux-5.15.y (already applied)

Upstream commit aad41a7d7cf6 ("SUNRPC: Don't leak sockets in xs_local_connect()")
   upstream: v5.18-rc6
     Fixes: f00432063db1 ("SUNRPC: Ensure we flush any closed sockets before xs_xprt_free()")
       in linux-5.4.y: 2f8f6c393b11
       in linux-5.10.y: e68b60ae29de
       in linux-5.15.y: 54f6834b283d
       upstream: v5.18-rc2
     Affected branches:
       linux-5.4.y (conflicts - backport needed)
       linux-5.10.y (conflicts - backport needed)
       linux-5.15.y (conflicts - backport needed)

I'll send a complete list after the analysis is done.

Guenter

