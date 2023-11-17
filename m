Received: from mail-oi1-f169.google.com (mail-oi1-f169.google.com [209.85.167.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 992301370
	for <patches@lists.linux.dev>; Fri, 17 Nov 2023 01:25:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=roeck-us.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="UHnZwqqM"
Received: by mail-oi1-f169.google.com with SMTP id 5614622812f47-3b2e44c7941so879526b6e.2
        for <patches@lists.linux.dev>; Thu, 16 Nov 2023 17:25:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1700184339; x=1700789139; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:autocrypt:from:references:cc
         :to:content-language:subject:user-agent:mime-version:date:message-id
         :sender:from:to:cc:subject:date:message-id:reply-to;
        bh=WKeX8QHzT5xr6BXfBhXLId9dWsY3VlMa6hhbkyDTa9o=;
        b=UHnZwqqMu9AfeqJ6eukD2KvruN+d/jO9NeYw6eVTAo0uVs/CqODd3/aSW15kkLZtWJ
         xL2XleJm1qmS7Uo4GyjLpstVwihk76NzvNJPsozkUSdfqUPTou83wjCUhVtNaFSidXBy
         sv6VmnPNxCp1Moz1wvNihbzU11XG7IM07lHYS0H4p/xYF++c3FMTLB+KEOAGMGbwu6d3
         rK3MNbvfEJ+luEtLjbme/MWqUS0/6Tk6gsQjBSnVJ+RFYNL4QUd5R8OSpgz8RGtFn02l
         h6RuQqNTc6GiRjfttL9M11cLAQHOz4JouV9kchBuF2o4+d37msi5HjAqgmgp7G5xUD3k
         xkBA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1700184339; x=1700789139;
        h=content-transfer-encoding:in-reply-to:autocrypt:from:references:cc
         :to:content-language:subject:user-agent:mime-version:date:message-id
         :sender:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=WKeX8QHzT5xr6BXfBhXLId9dWsY3VlMa6hhbkyDTa9o=;
        b=SNV0YYfJlonX9GV1poERg3oSHJc1JpiZpXsM+fCgwv5a5sgjF89TGL4tRhsC3dlBXg
         2//xKi5PPSqsZbZoTedS09D/6p2VZIMqahnrYFBLAY1cvBDZnJ+eZQPRU1WOurC7jSct
         I0chCKoez+OucQ/BYWS95OhJ76CbQ/1lAYJBU+e2p3E4veGqtHJW2c+kyjgldOG+JHFf
         3ooPItL/zRvgKWMvvkhsGHENFzWiy0P0d90EfRoqqXWbiC4DI6RS8mrz45mQFMZF7zIg
         hZpyoD4Mnxf4eRN9ItWs7yepCOcKlcdHp4AGf2FhJ+FzUK++G1MzeV0ofkVY4ZcAhhad
         3EyQ==
X-Gm-Message-State: AOJu0Yx/mUQzREJAKo8QfgftO1qRY4GAphc8H1QpsQ8H4guh3JeIBfkb
	uPgh+xc2sD+9ZQs06ZIdSao=
X-Google-Smtp-Source: AGHT+IHVZfCoY6DZrNPuUIFzCQwR0gnLkJlylOsH1iukFRXnRgKhgIut3+ChVZhxhNZMkjhkJjjmrw==
X-Received: by 2002:a05:6870:9d0e:b0:1ea:3f79:defb with SMTP id pp14-20020a0568709d0e00b001ea3f79defbmr20013084oab.52.1700184339500;
        Thu, 16 Nov 2023 17:25:39 -0800 (PST)
Received: from ?IPV6:2600:1700:e321:62f0:329c:23ff:fee3:9d7c? ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id l187-20020a6325c4000000b0058ee60f8e4dsm337961pgl.34.2023.11.16.17.25.38
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 16 Nov 2023 17:25:39 -0800 (PST)
Sender: Guenter Roeck <groeck7@gmail.com>
Message-ID: <e23be029-25b5-4bfc-a5b9-60eda0c214b6@roeck-us.net>
Date: Thu, 16 Nov 2023 17:25:37 -0800
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 5.10 000/191] 5.10.201-rc1 review
Content-Language: en-US
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org, shuah@kernel.org,
 patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
 jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
 srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org
References: <20231115204644.490636297@linuxfoundation.org>
From: Guenter Roeck <linux@roeck-us.net>
Autocrypt: addr=linux@roeck-us.net; keydata=
 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
 mDW4+i+XlNFUPUYMrIKi9joBhu18ssf5i5Q=
In-Reply-To: <20231115204644.490636297@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 11/15/23 12:44, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.201 release.
> There are 191 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 17 Nov 2023 20:46:03 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 159 pass: 154 fail: 5
Failed builds:
	arm:allmodconfig
	arm64:allmodconfig
	i386:tools/perf
	x86_64:allyesconfig
	x86_64:tools/perf
Qemu test results:
	total: 495 pass: 495 fail: 0

with:

Building arm64:allmodconfig ... failed
--------------
Error log:
drivers/interconnect/qcom/osm-l3.c:6:10: fatal error: linux/args.h: No such file or directory

There is no linux/args.h in v5.10.y.

Caused by "interconnect: qcom: osm-l3: Replace custom implementation of COUNT_ARGS()".

Also:

Building i386:tools/perf ... failed

util/evlist.c: In function ‘evlist__add_aux_dummy’:
util/evlist.c:269:24: error: implicit declaration of function ‘evlist__dummy_event’; did you mean ‘evsel__is_dummy_event’? [-Werror=implicit-function-declaration]
   269 |  struct evsel *evsel = evlist__dummy_event(evlist);
       |                        ^~~~~~~~~~~~~~~~~~~
       |                        evsel__is_dummy_event
util/evlist.c:269:24: error: initialization of ‘struct evsel *’ from ‘int’ makes pointer from integer without a cast

There is indeed no 'evlist__dummy_event' function in v5.10.y.

This is with v5.10.200-192-g550b7e1fee20. I am a bit puzzled why others
don't seem to see those problems.

Guenter

