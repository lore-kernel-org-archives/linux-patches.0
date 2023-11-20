Received: from mail-pl1-f174.google.com (mail-pl1-f174.google.com [209.85.214.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C6BC1DA4C
	for <patches@lists.linux.dev>; Mon, 20 Nov 2023 18:18:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=roeck-us.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="FBse64x8"
Received: by mail-pl1-f174.google.com with SMTP id d9443c01a7336-1cc2575dfc7so32421095ad.1
        for <patches@lists.linux.dev>; Mon, 20 Nov 2023 10:18:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1700504281; x=1701109081; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:autocrypt:from:references:cc
         :to:content-language:subject:user-agent:mime-version:date:message-id
         :sender:from:to:cc:subject:date:message-id:reply-to;
        bh=kFLRg223LO/GT0x0NzSatE4yEerytkclLakS9gEYU7I=;
        b=FBse64x8J+QFjzRPKp6WHlJHrUo/4wSDAz3OMoJRxnMc4j/2n0M93vXeTt3IdomDPA
         KR1aXmTkwZPOQBLnFVMJ7Zs/bXRSK+uBEaRa0ALAY0osY1Wg5w8WJG0BNbCsnpfSS7PE
         iIR/CSc9x34EpyJZBzaJqJAV621GXcdEmhw7bxFJCoIANqHkbs81JMEg3Phd7IgD0LPo
         N/6Hje44u6ZI5CLLqKFI8onGTFsTFtbu2VJSav+gOUijqwCsWUIXCiFZh90wDCHZNdg+
         wk8VX1MhPvyvydqb58aKoIAObKgbmja8W67NM623119C36ba/I+zlBRZ5UtPA82OsRrH
         +yFw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1700504281; x=1701109081;
        h=content-transfer-encoding:in-reply-to:autocrypt:from:references:cc
         :to:content-language:subject:user-agent:mime-version:date:message-id
         :sender:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=kFLRg223LO/GT0x0NzSatE4yEerytkclLakS9gEYU7I=;
        b=vYcEiGSd68n5vXCIroaYwq1F+qGq0BIhe9gwNLvW+ZKZd+se9kr1u0MmcMTdU/eW8S
         wfMHbkDOSR2x0EbBPpPTIoRcQdhwujgqVCcPyPGI6DqADZyGtcsQFDlSKPkevPdrvFb4
         fwH4JPqaa8EExedl0NGBR5IqtQ0NFhatfJWnqKZHlq25gj+Gz2bjXoD52CFxCNNNzy2u
         Uz9fjLidxFlvSN6Ir7sUHd2Ibc4QWCVl31XYRG5My8DE+xESw1TVGw89GyTMGHi3QxlY
         ozQpWWkio5O6s9Aog9ID7UGsaDwpiiL8FFrDp8unhSl9pCSu/v03QASbN7CXsG5DSyif
         FQVA==
X-Gm-Message-State: AOJu0YzPgxuEu2JbzzmNEyIGlZBDlTmPhfyWUEwrVuHL9fKGOYaj8Ys6
	VE7di8f24+gg1m+bVj+jGiY=
X-Google-Smtp-Source: AGHT+IFqVMvj66yRYiu/p6efYy2ZK63kymXsGblKCTW2WZwap5kNLtzNpDeiTfnXNP2AmSsKU+6sBg==
X-Received: by 2002:a17:90a:6c21:b0:280:aa7b:fbe8 with SMTP id x30-20020a17090a6c2100b00280aa7bfbe8mr6673313pjj.32.1700504281402;
        Mon, 20 Nov 2023 10:18:01 -0800 (PST)
Received: from ?IPV6:2600:1700:e321:62f0:329c:23ff:fee3:9d7c? ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id d13-20020a17090ad3cd00b00280202c092fsm5901776pjw.33.2023.11.20.10.18.00
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 20 Nov 2023 10:18:00 -0800 (PST)
Sender: Guenter Roeck <groeck7@gmail.com>
Message-ID: <ffd98a9d-6db8-4d1e-b3ab-0c7159f91b6b@roeck-us.net>
Date: Mon, 20 Nov 2023 10:17:59 -0800
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 5.10 000/191] 5.10.201-rc1 review
Content-Language: en-US
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
 linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
 akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org
References: <20231115204644.490636297@linuxfoundation.org>
 <b5367845-8d70-4fcf-861a-ff9b8849c9c9@roeck-us.net>
 <2023112039-reverse-careless-e646@gregkh>
From: Guenter Roeck <linux@roeck-us.net>
Autocrypt: addr=linux@roeck-us.net; keydata=
 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
 mDW4+i+XlNFUPUYMrIKi9joBhu18ssf5i5Q=
In-Reply-To: <2023112039-reverse-careless-e646@gregkh>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 11/20/23 02:05, Greg Kroah-Hartman wrote:
> On Thu, Nov 16, 2023 at 05:13:39PM -0800, Guenter Roeck wrote:
>> On 11/15/23 12:44, Greg Kroah-Hartman wrote:
>>> This is the start of the stable review cycle for the 5.10.201 release.
>>> There are 191 patches in this series, all will be posted as a response
>>> to this one.  If anyone has any issues with these being applied, please
>>> let me know.
>>>
>>> Responses should be made by Fri, 17 Nov 2023 20:46:03 +0000.
>>> Anything received after that time might be too late.
>>>
>>
>> Build results:
>> 	total: 159 pass: 155 fail: 4
>> Failed builds:
>> 	arm:allmodconfig
>> 	arm64:allmodconfig
>> 	i386:tools/perf
>> 	x86_64:tools/perf
>> Qemu test results:
>> 	total: 495 pass: 495 fail: 0
>>
>> with:
>>
>> Building arm64:allmodconfig ... failed
>> --------------
>> Error log:
>> drivers/interconnect/qcom/osm-l3.c:6:10: fatal error: linux/args.h: No such file or directory
>>
>> There is no linux/args.h in v5.10.y.
>>
>> Caused by "interconnect: qcom: osm-l3: Replace custom implementation of COUNT_ARGS()".
> 
> Now dropped, thanks.
> 

v5.10.201 fails to build arm:allmodconfig and arm64:allmodconfig with

drivers/interconnect/qcom/sc7180.c:158:10: error: 'struct qcom_icc_bcm' has no member named 'enable_mask'

Guenter

