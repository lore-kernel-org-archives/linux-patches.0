Received: from mail-pf1-f178.google.com (mail-pf1-f178.google.com [209.85.210.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F3712172BC2
	for <patches@lists.linux.dev>; Tue, 25 Jun 2024 16:29:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719332969; cv=none; b=pQDT5NZZZTicn7zFtV3hE51nfLQtX0pbETdT/3bGU+cLobJYUvAn36NyO3z+yzyzDzD+rrGVSBthO2OkXWZ1Qf1gNkjn3k9rVEVtsct5uBuKWFazGUNg0Y5JBRZGQtVLnv8vgHMEPb8BV1empV+9ZmtAaEj6NHsiNLnwJTbcCPw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719332969; c=relaxed/simple;
	bh=JyClAYv+1Nz8tEASNP9SLaPkFXRzT3IWaGoyL7VMJ2E=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=o7e8y43Z6U47o5tvxDzSZnZY4IVdTxxzPSmDjye7vZWi86TF16XUMSgYwhvd3MeVqrsG1ZoL0VKuAzn8v0zgaj0dOZjnzkgDhyYltJxfMIHUUD4COOJJO2P84jCH3RHGSDY/nfZMBY7HlGHnSCYIynlS7dVZ14rj2mMsT6DKiAg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=roeck-us.net; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ghsTJ/xo; arc=none smtp.client-ip=209.85.210.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=roeck-us.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ghsTJ/xo"
Received: by mail-pf1-f178.google.com with SMTP id d2e1a72fcca58-7065e2fe7d9so2963931b3a.3
        for <patches@lists.linux.dev>; Tue, 25 Jun 2024 09:29:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1719332967; x=1719937767; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:sender:from:to:cc:subject:date:message-id:reply-to;
        bh=pMJOuE2BPwJWsvMQnxI8pzQYLzC2K1TGd0U2QAkDfTY=;
        b=ghsTJ/xoeRZc2tuqvijh9J6jkbB5GgCdpcq+pxM9KtSFx/3emoU/EBxDQgouVnjr4H
         998lQIDTyRU6NVv8yEnFbqqVhspAzyjlJGAJWhYGFMmbtdFLFEhOmHc+UseOyVLGJhtt
         1/hCveRikoigZggep/5ZM3IYRNokC/JGxA7uqwU1uOgC2Dp7LBUxzTyHzh7fkTeHu5PZ
         nN9sC2m3qTOB8OKfHBJkb0yE4jtuAKehwllO79jgbXOaRfzbgED7hik2i0V3yp9oDC6A
         KtXezmqxKLYyXk1o53xIvwPMnjHT5OiazLhvHXmCte2lPb3p4HoAqb8cfTFacEXo0Rdm
         mjGA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1719332967; x=1719937767;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:sender:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=pMJOuE2BPwJWsvMQnxI8pzQYLzC2K1TGd0U2QAkDfTY=;
        b=fdse0LgV7TtXBLCNO1Z+frjGsWz+oRY38erO6RVlGNpdL3rKcbMNFS925x+pqkUtIj
         9NNszljP2REPXJ0y6p3UJ2/YU/CxI/8NUUMokZ20nd80pT8O0LWoXse0jr/TN3anCmjS
         wGu4fxxYr2S0IcvR1QFwXNt1DOleF+qyHfhmNxXmjKsZhbRfCoRtLR/3a39BkAjlS39U
         EGUOiHXxVhICltX1XYi7quxH2p3iiZnrPOpM0x4qRmbmsuNRxbJjfQyipnrCvGQpzC4s
         jhSrlEuIv4u0MSymduHqmBm4CT0SkQ6qYv1EJng8thegw8OodooJanNhVH2vO6t5qFCn
         sSYQ==
X-Forwarded-Encrypted: i=1; AJvYcCU/IsaBLo4wIo7mOFhqw3bghMrA9ffvV7ZNSlHhoyp6ZXGWtskifKwlOS7vHo2HCs4z57h4lvoGPlcedHo+RFq87pUtZ1w7/w==
X-Gm-Message-State: AOJu0Yz9rVuDyWVVMhqU5SatBmcLsAmRBDrCl13S6IcvvCTzRlkAlWvu
	REquRek+srjGwOUstmnzasqc+1TyxTUXYGJ8Zw5K3TE4wYNTXnzq
X-Google-Smtp-Source: AGHT+IG9QgkXar9qQFSqPgBT3U9cJfiOLJf6MIG2uY3uo0XABIIwqQMTz4zhq4wWR8Df/tbdSBTM3g==
X-Received: by 2002:a05:6a20:8c11:b0:1b7:f59d:fd12 with SMTP id adf61e73a8af0-1bcf7fe9ecbmr8587099637.55.1719332966976;
        Tue, 25 Jun 2024 09:29:26 -0700 (PDT)
Received: from ?IPV6:2600:1700:e321:62f0:329c:23ff:fee3:9d7c? ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-71a5a2349eesm5435891a12.42.2024.06.25.09.29.24
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 25 Jun 2024 09:29:26 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Message-ID: <cf232ba1-a3f3-4931-8775-254d42e261e5@roeck-us.net>
Date: Tue, 25 Jun 2024 09:29:24 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 5.10 000/770] 5.10.220-rc1 review
To: Chuck Lever III <chuck.lever@oracle.com>,
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-stable <stable@vger.kernel.org>,
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
Content-Language: en-US
From: Guenter Roeck <linux@roeck-us.net>
Autocrypt: addr=linux@roeck-us.net; keydata=
 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
 mDW4+i+XlNFUPUYMrIKi9joBhu18ssf5i5Q=
In-Reply-To: <EEE94730-C043-47D8-A50A-47332201B3BF@oracle.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 6/25/24 08:13, Chuck Lever III wrote:
> Hi -
> 
>> On Jun 25, 2024, at 11:04 AM, Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:
>>
>> On Tue, Jun 25, 2024 at 07:48:00AM -0700, Guenter Roeck wrote:
>>> On 6/18/24 05:27, Greg Kroah-Hartman wrote:
>>>> This is the start of the stable review cycle for the 5.10.220 release.
>>>> There are 770 patches in this series, all will be posted as a response
>>>> to this one.  If anyone has any issues with these being applied, please
>>>> let me know.
>>>>
>>>> Responses should be made by Thu, 20 Jun 2024 12:32:00 +0000.
>>>> Anything received after that time might be too late.
>>>>
>>>
>>> [ ... ]
>>>> Chuck Lever <chuck.lever@oracle.com>
>>>>      SUNRPC: Prepare for xdr_stream-style decoding on the server-side
>>>>
>>> The ChromeOS patches robot reports a number of fixes for the patches
>>> applied in 5.5.220. This is one example, later fixed with commit
>>> 90bfc37b5ab9 ("SUNRPC: Fix svcxdr_init_decode's end-of-buffer
>>> calculation"), but there are more. Are those fixes going to be
>>> applied in a subsequent release of v5.10.y, was there a reason to
>>> not include them, or did they get lost ?
>>
>> I saw this as well, but when I tried to apply a few, they didn't, so I
>> was guessing that Chuck had merged them together into the series.
>>
>> I'll defer to Chuck on this, this release was all his :)
> 
> I did this port months ago, I've been waiting for the dust to
> settle on the 6.1 and 5.15 NFSD backports, so I've all but
> forgotten the status of individual patches.
> 
> If you (Greg or Guenter) send me a list of what you believe is
> missing, I can have a look at the individual cases and then
> run the finished result through our NFSD CI gauntlet.
> 

This is what the robot reported so far:

1242a87da0d8 SUNRPC: Fix svcxdr_init_encode's buflen calculation
   Fixes: bddfdbcddbe2 ("NFSD: Extract the svcxdr_init_encode() helper")
90bfc37b5ab9 SUNRPC: Fix svcxdr_init_decode's end-of-buffer calculation
   Fixes: 5191955d6fc6 ("SUNRPC: Prepare for xdr_stream-style decoding on the server-side")
10396f4df8b7 nfsd: hold a lighter-weight client reference over CB_RECALL_ANY
   Fixes: 44df6f439a17 ("NFSD: add delegation reaper to react to low memory condition")

Guenter
