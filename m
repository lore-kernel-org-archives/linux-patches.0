Received: from mail-pf1-f174.google.com (mail-pf1-f174.google.com [209.85.210.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BAC0117D342
	for <patches@lists.linux.dev>; Tue, 25 Jun 2024 20:43:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719348188; cv=none; b=Do+cSX/PiEIac0mLVMyoZBnuV9xLVge98RtHJI3R+DHgr4hsD+qXdiV2UF8p12RFDvg3K1kE2Ou70aHLpeLClfX/WQnguTySAxnCrzcq2AK4Izw87MBi4fJ9PqqHSZ/uHD99rN5lumnp/shmhhipa/GOnEWdEBaAIEdxs96VpkQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719348188; c=relaxed/simple;
	bh=SgIQlISm+JEe6AUlgigrNQZ3UdBGCoJDsqf2k8CU3oQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=oIxMx+BEuGhWxJ7bXSbvqsbj5WSaA1PlSKlseHuC6BvAvj4GlwzTrBTMCC5YBA8eQtDDQcc8RCkJXj/ti4p+eTmqRd2QrNMulbNn53MfcVBDK6jZicWqcXfiKKG3kFqLuPEg0HmgBhWEQtJcWSt/J+hh0uDONiJ+mAUbi0OuV3g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=roeck-us.net; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=TEbVfd66; arc=none smtp.client-ip=209.85.210.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=roeck-us.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="TEbVfd66"
Received: by mail-pf1-f174.google.com with SMTP id d2e1a72fcca58-7066a3229f4so2635474b3a.2
        for <patches@lists.linux.dev>; Tue, 25 Jun 2024 13:43:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1719348186; x=1719952986; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:sender:from:to:cc:subject:date:message-id:reply-to;
        bh=NLL8SJgPfMSPaG996+AhVZnvKnUS9gPFR9s/m8IMdSg=;
        b=TEbVfd66snp/cY+bkJ6X0fNbW4p94Rk8mj+waa5dHntjUxQGOVVM2btvvoh8Symu8b
         R84zGsxp5scVReWR3q7TWuKa9nYMHK4XYMp/B9zzLoJQwtJtvwVp84cJSuWPnkdRA9lH
         uHukSlKySLK9Zimcm6JyZU2+gqcNhmpfis4Sm0TE5xEVdnCTaMqgAtI5EAPkCGZCnSPz
         M2GNAb07fwmTzNIqZnddCxswLnK4JZRapklgluNjzpbBXBUgxTQxkubRl8NrJEx7mAID
         Iu09KDeKMQ0I1bZtHT3ajbhVc7Q5XRFEmxpQJl/DPFKVsLN+XAV4R3qm9I7iU+WNcuOj
         Qk6g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1719348186; x=1719952986;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:sender:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=NLL8SJgPfMSPaG996+AhVZnvKnUS9gPFR9s/m8IMdSg=;
        b=ZDtqa6ZHmshkB/aXPT3kQF9Dy4Tq+vHk9Z2KjolDwdzCI0lTY9IaFHrBShRcdsLVXt
         EyP0o0uijpq7/wUJsE6ELWAoyuwNWbsi7uPqfhR4Q3pnz9Tlq7YfLgfldeXbtA/ZGPzq
         sQLRT6vT089giAbgP3ag44Djda3T6uO2eqFQbBDkgWrVqe4X0ZHXlJo4bqQdRV1XkjBK
         lolglCOkujZjpbAYL1vjqB/GjH7fE8Vezc5TPMDLjX7p8JKVE1OpKPMvvNWuNoZrV2iU
         Hmc8H7POY0hwVn5ud9nMUpIuDC8FGeVJ34XEAYrHfipg77hSDE8CUheHsarJ50//+qE1
         Nh3Q==
X-Forwarded-Encrypted: i=1; AJvYcCUBS3DTWv0doWxpsGMbnKxspkdcFmjtvwwLvjQAwHS2ICtaXnxelrH58Ag6VofV2F8fRa4DDH/+7+ZkWnC+9pnh2wj6hYFILQ==
X-Gm-Message-State: AOJu0Yyk97zYDGvs792UfXsJjscRO5cBj15k2TxLd2rcAg2EbdX2YqE8
	exfmqTNyykfSsX0cNjYkLDjtmmUfQ0LsxxhyRXU3Wxq1s881scpt
X-Google-Smtp-Source: AGHT+IHm878UI51B3Q/pdFetH5k9qCqWokx5uxXEiJr77XRqbYHp4Vq4OgbLI6n5DVlb0T1qGnEDhw==
X-Received: by 2002:a05:6a20:a895:b0:1b8:831f:c684 with SMTP id adf61e73a8af0-1bcf8001361mr7386254637.53.1719348185828;
        Tue, 25 Jun 2024 13:43:05 -0700 (PDT)
Received: from ?IPV6:2600:1700:e321:62f0:329c:23ff:fee3:9d7c? ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-1f9eb2f10fasm85825645ad.15.2024.06.25.13.43.03
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 25 Jun 2024 13:43:04 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Message-ID: <61177a72-3fb5-43f6-9456-3980f60159dc@roeck-us.net>
Date: Tue, 25 Jun 2024 13:43:03 -0700
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
 <88a0fdf5-ffc5-4398-88cd-220a3a996164@roeck-us.net>
 <7442B6FD-6EC6-4C4E-A5F7-CDA1174E6DE2@oracle.com>
 <04BEF7A2-EB38-475D-BFD9-2E6B1C2C0972@oracle.com>
Content-Language: en-US
From: Guenter Roeck <linux@roeck-us.net>
Autocrypt: addr=linux@roeck-us.net; keydata=
 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
 mDW4+i+XlNFUPUYMrIKi9joBhu18ssf5i5Q=
In-Reply-To: <04BEF7A2-EB38-475D-BFD9-2E6B1C2C0972@oracle.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 6/25/24 12:49, Chuck Lever III wrote:
> 
> 
>> On Jun 25, 2024, at 3:40 PM, Chuck Lever III <chuck.lever@oracle.com> wrote:
>>
>>
>>
>>> On Jun 25, 2024, at 3:35 PM, Guenter Roeck <linux@roeck-us.net> wrote:
>>>
>>> On 6/25/24 12:08, Chuck Lever III wrote:
>>>>> On Jun 25, 2024, at 12:29 PM, Guenter Roeck <linux@roeck-us.net> wrote:
>>>>>
>>>>> On 6/25/24 08:13, Chuck Lever III wrote:
>>>>>> Hi -
>>>>>>> On Jun 25, 2024, at 11:04 AM, Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:
>>>>>>>
>>>>>>> On Tue, Jun 25, 2024 at 07:48:00AM -0700, Guenter Roeck wrote:
>>>>>>>> On 6/18/24 05:27, Greg Kroah-Hartman wrote:
>>>>>>>>> This is the start of the stable review cycle for the 5.10.220 release.
>>>>>>>>> There are 770 patches in this series, all will be posted as a response
>>>>>>>>> to this one.  If anyone has any issues with these being applied, please
>>>>>>>>> let me know.
>>>>>>>>>
>>>>>>>>> Responses should be made by Thu, 20 Jun 2024 12:32:00 +0000.
>>>>>>>>> Anything received after that time might be too late.
>>>>>>>>>
>>>>>>>>
>>>>>>>> [ ... ]
>>>>>>>>> Chuck Lever <chuck.lever@oracle.com>
>>>>>>>>>     SUNRPC: Prepare for xdr_stream-style decoding on the server-side
>>>>>>>>>
>>>>>>>> The ChromeOS patches robot reports a number of fixes for the patches
>>>>>>>> applied in 5.5.220. This is one example, later fixed with commit
>>>>>>>> 90bfc37b5ab9 ("SUNRPC: Fix svcxdr_init_decode's end-of-buffer
>>>>>>>> calculation"), but there are more. Are those fixes going to be
>>>>>>>> applied in a subsequent release of v5.10.y, was there a reason to
>>>>>>>> not include them, or did they get lost ?
>>>>>>>
>>>>>>> I saw this as well, but when I tried to apply a few, they didn't, so I
>>>>>>> was guessing that Chuck had merged them together into the series.
>>>>>>>
>>>>>>> I'll defer to Chuck on this, this release was all his :)
>>>>>> I did this port months ago, I've been waiting for the dust to
>>>>>> settle on the 6.1 and 5.15 NFSD backports, so I've all but
>>>>>> forgotten the status of individual patches.
>>>>>> If you (Greg or Guenter) send me a list of what you believe is
>>>>>> missing, I can have a look at the individual cases and then
>>>>>> run the finished result through our NFSD CI gauntlet.
>>>>>
>>>>> This is what the robot reported so far:
>>>>>
>>>>> 1242a87da0d8 SUNRPC: Fix svcxdr_init_encode's buflen calculation
>>>>> Fixes: bddfdbcddbe2 ("NFSD: Extract the svcxdr_init_encode() helper")
>>>>> 90bfc37b5ab9 SUNRPC: Fix svcxdr_init_decode's end-of-buffer calculation
>>>>> Fixes: 5191955d6fc6 ("SUNRPC: Prepare for xdr_stream-style decoding on the server-side")
>>>>> 10396f4df8b7 nfsd: hold a lighter-weight client reference over CB_RECALL_ANY
>>>>> Fixes: 44df6f439a17 ("NFSD: add delegation reaper to react to low memory condition")
>>>> My naive search found:
>>>> Checking commit 44df6f439a17 ...
>>>>   upstream fix 10396f4df8b75ff6ab0aa2cd74296565466f2c8d not found
>>>> 10396f4df8b75ff6ab0aa2cd74296565466f2c8d nfsd: hold a lighter-weight client reference over CB_RECALL_ANY
>>>>   upstream fix f385f7d244134246f984975ed34cd75f77de479f is already applied
>>>> Checking commit a2071573d634 ...
>>>>   upstream fix f1aa2eb5ea05ccd1fd92d235346e60e90a1ed949 not found
>>>> f1aa2eb5ea05ccd1fd92d235346e60e90a1ed949 sysctl: fix proc_dobool() usability
>>>> Checking commit bddfdbcddbe2 ...
>>>>   upstream fix 1242a87da0d8cd2a428e96ca68e7ea899b0f4624 not found
>>>> 1242a87da0d8cd2a428e96ca68e7ea899b0f4624 SUNRPC: Fix svcxdr_init_encode's buflen calculation
>>>> Checking commit 9fe61450972d ...     upstream fix 2111c3c0124f7432fe908c036a50abe8733dbf38 not found
>>>> 2111c3c0124f7432fe908c036a50abe8733dbf38 namei: fix kernel-doc for struct renamedata and more
>>>> Checking commit 013c1667cf78 ...     upstream fix 2c0f0f3639562d6e38ee9705303c6457c4936eac not found
>>>> 2c0f0f3639562d6e38ee9705303c6457c4936eac module: correctly exit module_kallsyms_on_each_symbol when fn() != 0
>>>>   upstream fix 1e80d9cb579ed7edd121753eeccce82ff82521b4 not found
>>>> 1e80d9cb579ed7edd121753eeccce82ff82521b4 module: potential uninitialized return in module_kallsyms_on_each_symbol()
>>>> Checking commit 89ff87494c6e ...
>>>>   upstream fix 5c11720767f70d34357d00a15ba5a0ad052c40fe not found
>>>> 5c11720767f70d34357d00a15ba5a0ad052c40fe SUNRPC: Fix a NULL pointer deref in trace_svc_stats_latency()
>>>> Checking commit 5191955d6fc6 ...
>>>>   upstream fix 90bfc37b5ab91c1a6165e3e5cfc49bf04571b762 not found
>>>> 90bfc37b5ab91c1a6165e3e5cfc49bf04571b762 SUNRPC: Fix svcxdr_init_decode's end-of-buffer calculation
>>>>   upstream fix b9f83ffaa0c096b4c832a43964fe6bff3acffe10 not found
>>>> b9f83ffaa0c096b4c832a43964fe6bff3acffe10 SUNRPC: Fix null pointer dereference in svc_rqst_free()
>>>> I'll look into backporting the missing NFSD and SUNRPC patches.
>>>
>>> My list didn't include patches with conflicts. There are a lot of them. Our robot
>>> collects those, but doesn't focus on it. It also doesn't analyze just nfds/SUNRPC
>>> patches, but all of them. I started an analysis to list all the fixes with
>>> conflicts; so far I found about 100 of them. Three are tagged SUNRPC.
>>>
>>> Upstream commit 8e088a20dbe3 ("SUNRPC: add a missing rpc_stat for TCP TLS")
>>> upstream: v6.9-rc7
>>>    Fixes: 1548036ef120 ("nfs: make the rpc_stat per net namespace")
>>>      in linux-5.4.y: 19f51adc778f
>>>      in linux-5.10.y: afdbc21a92a0
>>>      in linux-5.15.y: 7ceb89f4016e
>>>      in linux-6.1.y: 2b7f2d663a96
>>>      in linux-6.6.y: 260333221cf0
>>>      upstream: v6.9-rc1
>>>    Affected branches:
>>>      linux-5.4.y (conflicts - backport needed)
>>>      linux-5.10.y (conflicts - backport needed)
>>>      linux-5.15.y (conflicts - backport needed)
>>>      linux-6.1.y (conflicts - backport needed)
>>>      linux-6.6.y (already applied)
>>>
>>> Upstream commit aed28b7a2d62 ("SUNRPC: Don't dereference xprt->snd_task if it's a cookie")
>>> upstream: v5.17-rc2
>>>    Fixes: e26d9972720e ("SUNRPC: Clean up scheduling of autoclose")
>>>      in linux-5.4.y: 2d6f096476e6
>>>      in linux-5.10.y: 2ab569edd883
>>>      upstream: v5.15-rc1
>>>    Affected branches:
>>>      linux-5.4.y (conflicts - backport needed)
>>>      linux-5.10.y (conflicts - backport needed)
>>>      linux-5.15.y (already applied)
>>>
>>> Upstream commit aad41a7d7cf6 ("SUNRPC: Don't leak sockets in xs_local_connect()")
>>> upstream: v5.18-rc6
>>>    Fixes: f00432063db1 ("SUNRPC: Ensure we flush any closed sockets before xs_xprt_free()")
>>>      in linux-5.4.y: 2f8f6c393b11
>>>      in linux-5.10.y: e68b60ae29de
>>>      in linux-5.15.y: 54f6834b283d
>>>      upstream: v5.18-rc2
>>>    Affected branches:
>>>      linux-5.4.y (conflicts - backport needed)
>>>      linux-5.10.y (conflicts - backport needed)
>>>      linux-5.15.y (conflicts - backport needed)
>>>
>>> I'll send a complete list after the analysis is done.
>>
>> The "NFSD file cache fixes" backports focused on NFSD, not on
>> SUNRPC, and only the NFS server side of affairs. The missing
>> fixes you found are outside of one or both of those areas, so
>> they can go through the usual stable backport process if the
>> NFS client folks care to do that.
> 
> Or, to cut this another way: I looked at only the patches that
> I submitted for v5.10.220; I will take responsibility for
> ensuring those all have the latest upstream fixes applied,
> where that is feasible.
> 
> Anything else (other subsystems, other LTS kernels) gets the
> normal stable backport treatment: those subsystem maintainers
> or their designees have to step up to handle the code work
> and testing if they view the fix as a priority.
> 

Sounds good to me.

Thanks,
Guenter


