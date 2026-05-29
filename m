Received: from mail-wm1-f47.google.com (mail-wm1-f47.google.com [209.85.128.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B928F3375C5
	for <patches@lists.linux.dev>; Fri, 29 May 2026 10:59:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780052366; cv=none; b=W+jFYLhNFEZhRPS9MfRxLmgM6/Aq32GyUGP3bsUUD1VAWNBb58AjCr8tvGFM9EdvfhEtMlcG85MpX0ZMTiEr+TR/X95tNgxmYIsyHaVHoI3bmQte0vK9ov9LR5QNpTTlk6/9s8ny3nKIHX26ySZQYTTVj4Gh13FLI4dbCvWHb5k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780052366; c=relaxed/simple;
	bh=OALE1Pc/rF8dgWSwkPtQJkCEVXfiJcU73/nCbwbqG6M=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=ATnUFZZMXDx5Mk2c+a+KdZDQv6LJX3nnykXTsMKh2ZUZMdnSfk1e5yk7pWIXlKhi47eGUfjZ0yj8MHJR7LvXofPZriLYGKNB7NxEKdulE4mYtXjfNCxZa5tdTzV/VXDjrwnrrFpHDQlaZOnNUM5vTCOyxyBW58KBRQdcu6Azssw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com; spf=pass smtp.mailfrom=googlemail.com; dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b=bGMr4E3q; arc=none smtp.client-ip=209.85.128.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=googlemail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b="bGMr4E3q"
Received: by mail-wm1-f47.google.com with SMTP id 5b1f17b1804b1-4905e190c71so64507995e9.3
        for <patches@lists.linux.dev>; Fri, 29 May 2026 03:59:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20251104; t=1780052363; x=1780657163; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=F21Dsc8xJ3JaBQAyJr3DbcWUQMZ4eqao7aBELV86M4c=;
        b=bGMr4E3qO8f9m7axBVXts4oUovJz5zcYCb0xK7VbSn2oAKAMfGMl70p2GxGxdbioaV
         9HRvURsF21RBpV/LZENSpo8Jyss7qjodpV2855Wy4xqP5QnVHy42fTMRu4fm3gz16cXc
         1f4E/9VbvyaMKCLiLtJg8VVJ0zNPsLob2RxBjK6ve5rjB82So8k6qju3WCXNOhKbQcAV
         i4o4Gt1BqHrwoCNjUX5ynIp3Ktmz93vdjZ1HYmbtXEemcCkvVJv6z7F7wQd/lCMfbfSX
         QtFZtOHW4kylBlLFUvmntQP54HCenCOUfXcuO4tI66XqpOfb83aDrCgd7AWGDv5Tal+m
         hmjw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780052363; x=1780657163;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=F21Dsc8xJ3JaBQAyJr3DbcWUQMZ4eqao7aBELV86M4c=;
        b=P5An8868+midKu3afYA58MqXQPwV/mYlxmogDB5KLecOAXYVIThVbST4RkjPNqWs9T
         WVP8humPabCJbWMR/Wqz1rOVOtZ+gYewNvrqxEZkjtnteThAar5nCSpttl1kfQjTeIo0
         e0QJx+jsJjSLrpVDmV2EA7+/hOcCmwHNscu2NayMbnDmQooKk0Tvp4CFsB3LOWfq5TzC
         A5tt7CbKwlK3cDlOczXGtY3eeeqDKF/Bj1xsQra695zBoBzNZSUzDFWOSKibpbVtoP8a
         9Anm5x/9wYOHjBznX8sYFX+oEQxkAki8N87OwPbrTMPxREwMHr8GC5P4XX/q67al80vi
         QLNg==
X-Forwarded-Encrypted: i=1; AFNElJ/k0jvHZHr2acUvShijsy8U6mmHjWJxbliswmWxXWyCizKRiqUoQQ+inLedsge/FoW9xSCbOsJ9@lists.linux.dev
X-Gm-Message-State: AOJu0Yx5qP7QDy3XZ1FBGzWRwKxbcsUmpp6ST/ar76JXujm3Sfza1Ms0
	/BwoJfXr0B6MXlHjrRFD7gGCiy5mYN77jlIOMlkmfi17dua0dtkHBxk=
X-Gm-Gg: Acq92OFNldDp+pMxDpGTndofRjCVfNXqSsiPk2kxh5SsdkPT3RU3XNnzaseh9t8VoYD
	AgfnCpfTLnR4dOXD0lsMEP2nJNlc6xvdbLO1/zlSZLxj9fPEQudecStdF3fWhxIOIMhTKSy916n
	gm36kPw2Se1272TXFD6NKoUwfxW2TLkz1zEXqgUDZwW+r7CZTx8yJGMVzSYbDLxf0yDpuE8+eiW
	v1GfYsH8QnL0z4ATgsXJv7o/aZWUL16TDn/RwxKczj89waYIBrvORXhpeLPZCcFeN3pXrZmuFy4
	QiiE+JIFKkIrnAVrUJIIrPk71hoYFoytmwrMUYuPXujsf5qXd6av8VsSqU3LRUEsHMpqj8T7nv5
	Wo8QEF6kVQXfI0TH/OomSNjWJFjHlxaw9F+GZhYsLl+ipRixDQHQIS6k6ovurdfHa+/IDiC5N93
	GqHrrCgGVOnM2v8zAW1mNNw7xHQXHO+3csj2nepIMxYVz4AyTrvRnfnRuHmXjzjAJs83DIEBdfN
	D/7BApvjby4lw==
X-Received: by 2002:a05:600c:a55:b0:490:3ff5:737f with SMTP id 5b1f17b1804b1-4909c0af305mr44771955e9.18.1780052362946;
        Fri, 29 May 2026 03:59:22 -0700 (PDT)
Received: from [192.168.1.3] (p5b2b4ac5.dip0.t-ipconnect.de. [91.43.74.197])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4909c1263dfsm12436465e9.30.2026.05.29.03.59.21
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 29 May 2026 03:59:22 -0700 (PDT)
Message-ID: <9b886b8c-f3cb-4497-a4d3-159cddb0dec1@googlemail.com>
Date: Fri, 29 May 2026 12:59:21 +0200
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Betterbird (Windows)
Subject: Re: [PATCH 6.12 000/272] 6.12.92-rc1 review
Content-Language: de-DE
To: Miguel Ojeda <ojeda@kernel.org>, gregkh@linuxfoundation.org
Cc: achill@achill.org, akpm@linux-foundation.org, broonie@kernel.org,
 conor@kernel.org, f.fainelli@gmail.com, hargar@microsoft.com,
 jonathanh@nvidia.com, linux-kernel@vger.kernel.org, linux@roeck-us.net,
 lkft-triage@lists.linaro.org, patches@kernelci.org, patches@lists.linux.dev,
 pavel@nabladev.com, rwarsow@gmx.de, shuah@kernel.org, sr@sladewatkins.com,
 stable@vger.kernel.org, sudipm.mukherjee@gmail.com,
 torvalds@linux-foundation.org, Anuj Gupta <anuj20.g@samsung.com>,
 Kanchan Joshi <joshi.k@samsung.com>, Christoph Hellwig <hch@lst.de>,
 Keith Busch <kbusch@kernel.org>, Jens Axboe <axboe@kernel.dk>,
 linux-block@vger.kernel.org
References: <20260528194629.379955525@linuxfoundation.org>
 <20260529060918.123155-1-ojeda@kernel.org>
From: Peter Schneider <pschneider1968@googlemail.com>
In-Reply-To: <20260529060918.123155-1-ojeda@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Am 29.05.2026 um 08:09 schrieb Miguel Ojeda:
> On Thu, 28 May 2026 21:46:14 +0200 Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:
>>
>> This is the start of the stable review cycle for the 6.12.92 release.
>> There are 272 patches in this series, all will be posted as a response
>> to this one.  If anyone has any issues with these being applied, please
>> let me know.
>>
>> Responses should be made by Sat, 30 May 2026 19:45:52 +0000.
>> Anything received after that time might be too late.
> 
> Boot-tested under QEMU for Rust x86_64, arm64 and riscv64; built-tested
> for loongarch64:
> 
> Tested-by: Miguel Ojeda <ojeda@kernel.org>
> 
> I am seeing:
> 
>      In file included from kernel/trace/blktrace.c:23:
>      In file included from kernel/trace/../../block/blk.h:5:
>      ./include/linux/bio-integrity.h:101:12: error: unused function 'bio_integrity_map_user' [-Werror,-Wunused-function]
>        101 | static int bio_integrity_map_user(struct bio *bio, struct iov_iter *iter)
>            |            ^~~~~~~~~~~~~~~~~~~~~~
> 
> This looks like it needs:
> 
>    546d191427cf ("block: make bio_integrity_map_user() static inline")
> 
> (and indeed in my run `CONFIG_BLK_DEV_INTEGRITY` is not set like the
> commit message says).


I didn't see this error message on x86_64; I built with CONFIG_WERROR=y and CONFIG_BLK_DEV_INTEGRITY=y


Builds, boots and works on my 2-socket Ivy Bridge Xeon E5-2697 v2 server. No dmesg oddities or regressions found.

Tested-by: Peter Schneider <pschneider1968@googlemail.com>


Beste Grüße,
Peter Schneider

-- 
Climb the mountain not to plant your flag, but to embrace the challenge,
enjoy the air and behold the view. Climb it so you can see the world,
not so the world can see you.                    -- David McCullough Jr.

OpenPGP:  0xA3828BD796CCE11A8CADE8866E3A92C92C3FF244
Download: https://www.peters-netzplatz.de/download/pschneider1968_pub.asc
https://keys.mailvelope.com/pks/lookup?op=get&search=pschneider1968@googlemail.com
https://keys.mailvelope.com/pks/lookup?op=get&search=pschneider1968@gmail.com
