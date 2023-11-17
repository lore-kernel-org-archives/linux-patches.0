Received: from mail-pl1-f175.google.com (mail-pl1-f175.google.com [209.85.214.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B3E7E79C5
	for <patches@lists.linux.dev>; Fri, 17 Nov 2023 15:15:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=roeck-us.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="dhA7cXtN"
Received: by mail-pl1-f175.google.com with SMTP id d9443c01a7336-1cc68c1fac2so18963315ad.0
        for <patches@lists.linux.dev>; Fri, 17 Nov 2023 07:15:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1700234113; x=1700838913; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:autocrypt:from:references:cc
         :to:content-language:subject:user-agent:mime-version:date:message-id
         :sender:from:to:cc:subject:date:message-id:reply-to;
        bh=IQCcBRlGrNv8PpHXqM0OdJs3VT+KoaRRoFmGD2ZH7g0=;
        b=dhA7cXtN2TBEGH4pFlkx7Q+Jeype0LoeY1d3mJNe+kElLNoOSIJ9LAZe7fI+M6mNST
         hY3mAgHQIu0jNkBLkZapq16HI4oZ0Xvlpxn9NSxA/ddZVz/HMZHsFS2rz8oKQOmV/Mv1
         6lnqvxoOED8WAZW1BtXyC3UyMNs0/PT9EqeXH1xXWePUjh522siCHNj8G2FT1g1Fm1dR
         jMUrCh3CA3d3oghj3089gcYUJJMgEwVkIJqnX/JvxZdAi1kOGYKaKmzRoZlJOBTuVHgv
         EPdQbnUo/R5/Nr8plf/I/XZsjvUGkJ/TL+2occ4Tvzc8ZoWKbFXzvIjP5s4lwassdGXG
         L6rQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1700234113; x=1700838913;
        h=content-transfer-encoding:in-reply-to:autocrypt:from:references:cc
         :to:content-language:subject:user-agent:mime-version:date:message-id
         :sender:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=IQCcBRlGrNv8PpHXqM0OdJs3VT+KoaRRoFmGD2ZH7g0=;
        b=UGS+bSVjzNoE3EDX3CFgn+bO4GzHprg0gIcx/D4XLKpYz2aCoWCAKwx8g4k3E2I+z4
         AdmmQKnWps8rrFtUFsl0WnbRsLrg4zfBU7Int7E1eX8dwxNSars3Q6JfYDWoQyQ974Wa
         Zh/5yARN7skMnS7XttzpB8cvf0R/WJm0wFLRzoBVOBx50ffPcB0NzpGdVbN9ruFAm8ps
         42+how2sPgEEBD8AqC8XxpcdhdNUret3RaBa01KcjYn8GyUpfcRAGfH9zeiAoK3y/CvQ
         w3rm7XwNKKYdmbrNN8YGXlxRvesbYARL0zSrN0K49Ygmgdd+UmKCa09qUy1qzC6/416T
         w68w==
X-Gm-Message-State: AOJu0YzLMmHGd30naa6DwJs+OpCkisJest2dhdGPrbdwuEE6dpotW/72
	OOO93h+a0kUZVPpzg/Vrmcw=
X-Google-Smtp-Source: AGHT+IELT8ha/v+aHBi1cfw7SHMUmAKdxivsF+wc9Qvt9TQtgEAJJJov8uFVj/jG7au6Q9F707OgXg==
X-Received: by 2002:a17:902:f707:b0:1cc:6e8f:c14e with SMTP id h7-20020a170902f70700b001cc6e8fc14emr15665557plo.15.1700234112780;
        Fri, 17 Nov 2023 07:15:12 -0800 (PST)
Received: from ?IPV6:2600:1700:e321:62f0:329c:23ff:fee3:9d7c? ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id y17-20020a63e251000000b005ab7b055573sm1513389pgj.79.2023.11.17.07.15.11
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 17 Nov 2023 07:15:12 -0800 (PST)
Sender: Guenter Roeck <groeck7@gmail.com>
Message-ID: <826b241f-3d93-4585-bd22-90cff75f7bb0@roeck-us.net>
Date: Fri, 17 Nov 2023 07:15:10 -0800
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 5.10 000/191] 5.10.201-rc1 review
Content-Language: en-US
To: Dominique Martinet <asmadeus@codewreck.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
 patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org, shuah@kernel.org,
 patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
 jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
 srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org
References: <20231115204644.490636297@linuxfoundation.org>
 <b5367845-8d70-4fcf-861a-ff9b8849c9c9@roeck-us.net>
 <ZVbIoqXjfn7V1NtT@codewreck.org>
From: Guenter Roeck <linux@roeck-us.net>
Autocrypt: addr=linux@roeck-us.net; keydata=
 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
 mDW4+i+XlNFUPUYMrIKi9joBhu18ssf5i5Q=
In-Reply-To: <ZVbIoqXjfn7V1NtT@codewreck.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Hi,

On 11/16/23 17:57, Dominique Martinet wrote:
> Guenter Roeck wrote on Thu, Nov 16, 2023 at 05:13:39PM -0800:
>> Failed builds:
>> 	arm:allmodconfig
>> 	arm64:allmodconfig
>> 	i386:tools/perf
>> 	x86_64:tools/perf
> 
>> This is with v5.10.200-192-g550b7e1fee20. I am a bit puzzled why others
>> don't seem to see those problems.
> 
> The perf problem was reported by Florian Fainelli, but my current test
> build does not include userspace tools as we're not shipping them (and
> would rely on $distro packages when I need perf as a user rather than
> building it).
> 
> Likewise, it looks like neither Linaro nor me build the qcom driver...
> I'm building kernels that have been trimmed down for our boards (with
> that exact config we're shipping and providing for our customers), and
> arm* drivers are especially fractured so it's a bit misleading to see
> "arm64 pass", that's just the tip of the actual setup tested.
> 
> 
> (Anyway, the main reason for me is mostly that $job is a small company
> that cannot afford extensive upstream testing, so I just don't have the
> time to do extended tests -- for the same reason we're only supporting
> the 5.10 tree so I'm focusing my limited time on just this branch, even
> if I'd love to do more.
> I'm just taking the stance that some test is better than no test and
> report back things we'd need to test before shipping customers a few
> weeks later anyway -- thank you for covering more!)
> 

Just to clarify, I wasn't assuming or expecting that _everyone_ would report
those errors. I was just puzzled that I had not seen _any_ reports, especially
since arm:allmodconfig and arm64:allmodconfig both failed to build for me
(and I had somehow missed Florian's perf report).

Thanks,
Guenter

