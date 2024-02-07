Received: from mail-ed1-f43.google.com (mail-ed1-f43.google.com [209.85.208.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E4FDD208D4
	for <patches@lists.linux.dev>; Wed,  7 Feb 2024 09:04:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707296658; cv=none; b=FkjwdVNwXeHDO1MxTrG9f/bIxBpRlK//xWx0ShGtpOa9s8Y8J6YfQXR8r3CioZc9bPwt+kNOtirK2akbppiakw1xoATR+Pvr4XA3bSl8mAyJmaybtOC2sdrwAezkiA36B7b1gOQn6L9Wrpe0Q/rU9XqqkQ9YZ4B8bk/MWtaijvI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707296658; c=relaxed/simple;
	bh=uTouoritSBniH6ODqAixgsHapd1gND7Dpi5XY1suL8c=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=BePrBG2pPEDGBl3oG2rrB1UqQtoCar0IFeh0NpVK8ap/5Z9g7VvDJBVMtaWsvlFxBrehH94zPCKKgBGO70USk0/A4yO+RbzABaBQPQu/YhNzO6B7RYLpSRzDhNtKUaHgf8iSpuf7XXFoI50pk3KWiET8c2cap3IP9qEyYGU5iQw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org; spf=pass smtp.mailfrom=gmail.com; arc=none smtp.client-ip=209.85.208.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ed1-f43.google.com with SMTP id 4fb4d7f45d1cf-560a9738081so393962a12.1
        for <patches@lists.linux.dev>; Wed, 07 Feb 2024 01:04:16 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1707296655; x=1707901455;
        h=content-transfer-encoding:in-reply-to:autocrypt:from:references:cc
         :to:content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=1zIOgF73UoU1efAJaUsPi5EeaDGzs4N42PXEo6xd4xM=;
        b=K799ZRCS26l3bzWPjnaGHyzC80ynJTXeQAdEK2JBo7YcLqAFsAtAzIwF5194+ntBTh
         X1Xo6n0jWnkKRa2rB2s/KmvZ3yR28s2HNex2+TlkpfI5l1iR6IxOrlk2utyuP6QeRyv9
         WJNeq3nLgSWHOeOm2dq3lV47VSzBVGOiy/9wr2zXlJzHxepSfjV0b5uU1IO+aRjDm1T9
         5F49kpiuvx6TjqP7kF3rPLTeGm2rQuUjmZKWHUMbVVBRZKLDiPK7yqkrzAsY0On/YfzG
         tXonLqolLBkqQ8BkSs5+59/MqHt3vKn0ReFkgF4lEOggXTLPnhcu+vI8z2dOwpW4VHq9
         8PeQ==
X-Gm-Message-State: AOJu0Yz9hrv69vs4v0X5SA6D7giotLV+GYz3BApKDPJhqMNSqlAMNa5J
	32wZTtHyhXnMwr3ooQ7Vw1BzLOCaeIN2kdbJVG7wI5gKpA/Tms7W
X-Google-Smtp-Source: AGHT+IELamvHZ2VDkAX4T8OV5YwmXlKQUw5K1qZD3CNNuoE1ovffVTUtPIzsvmwWpZxt1W0gqKI7pQ==
X-Received: by 2002:aa7:c2d3:0:b0:55f:95ac:d698 with SMTP id m19-20020aa7c2d3000000b0055f95acd698mr3437967edp.32.1707296655008;
        Wed, 07 Feb 2024 01:04:15 -0800 (PST)
X-Forwarded-Encrypted: i=1; AJvYcCUdqcpBvOO8xsBI5BL5MhrAcdHNlqbhqJmhlQvE0cDC6Ymq4CwkUdU8np7gtLN/yFLnS/sL6fAd5Tv3aIEw9QmXVQiBonfoC3PlDxygoxR6THVEa43dHCL4WXYwQtCSdUr1UQjsZa3IMkVSe2+CMXIqLqOnbyRotVHI5w==
Received: from ?IPV6:2a0b:e7c0:0:107::aaaa:59? ([2a0b:e7c0:0:107::aaaa:59])
        by smtp.gmail.com with ESMTPSA id v30-20020a50a45e000000b0056023efc5besm475161edb.53.2024.02.07.01.04.13
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 07 Feb 2024 01:04:14 -0800 (PST)
Message-ID: <f1d815b2-7c0c-4773-a91e-f381df193795@kernel.org>
Date: Wed, 7 Feb 2024 10:04:12 +0100
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.7 427/641] io_uring: dont check iopoll if request
 completes
Content-Language: en-US
To: Jens Axboe <axboe@kernel.dk>,
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, Pavel Begunkov <asml.silence@gmail.com>
References: <20240122235818.091081209@linuxfoundation.org>
 <20240122235831.353232285@linuxfoundation.org>
 <9fc00f54-24d5-44a6-a690-d4f73c37caa1@kernel.org>
 <8ec60240-800e-40b5-838f-b4779b5fee36@kernel.org>
 <6c91c497-0653-4901-a673-66922f3f5e7e@kernel.dk>
From: Jiri Slaby <jirislaby@kernel.org>
Autocrypt: addr=jirislaby@kernel.org; keydata=
 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
In-Reply-To: <6c91c497-0653-4901-a673-66922f3f5e7e@kernel.dk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 29. 01. 24, 14:58, Jens Axboe wrote:
> On 1/29/24 12:34 AM, Jiri Slaby wrote:
>> On 29. 01. 24, 7:44, Jiri Slaby wrote:
>>> On 23. 01. 24, 0:55, Greg Kroah-Hartman wrote:
>>>> 6.7-stable review patch.  If anyone has any objections, please let me know.
>>>
>>> Hi,
>>>
>>> 6.7.2 fails in liburing tests (both x64 and x86-32 lib on x64 kernel):
>>> [  115s] Tests failed (5): <fd-pass.t> <msg-ring-overflow.t> <pipe-bug.t> <poll-race-mshot.t> <reg-hint.t>
>>>
>>> I cannot reproduce locally, that happens only in openSUSE build machinery (the errors are transient, the links might not be valid in the future):
>>> https://build.opensuse.org/package/live_build_log/openSUSE:Factory:Staging:H/liburing/standard/i586
>>> https://build.opensuse.org/package/live_build_log/openSUSE:Factory:Staging:H/liburing/standard/x86_64
>>>
>>> So I cannot tell if 6.8-rc is affected.
>>>
>>> I suspect one of the 6.7.2 uring changes:
>>> e24bf5b47a57 io_uring: adjust defer tw counting
>>> 22eed9134509 io_uring: ensure local task_work is run on wait timeout
>>> ba8d8a8a36b2 io_uring/rw: ensure io->bytes_done is always initialized
>>> d413a342275d io_uring: don't check iopoll if request completes
>>>
>>> It looks like EINVAL is received unexpectedly (see below). Any ideas?
>>
>> Forget about this. The build service is currently broken and is using
>> 5.14 kernel instead of 6.7.2.
> 
> Ah that makes sense, the tests should work (in the sense that they
> should not fail) on eg 5.15-stable, but I guess the 5.14 kernel is
> something else entirely? Most of them would return 77 on older kernels
> where a specific feature is missing, but eg pipe-bug.t should definitely
> run and pass on older kernels.

It's SUSE's 5.14, so 5.14 with this many patches (45k+):
https://raw.githubusercontent.com/openSUSE/kernel-source/SLE15-SP5/series.conf

I am not sure it is supposed to be working in there too. But maybe we 
are missing some fixes on the top of the backported patches...

FWIW 6.7.2 was fine after all.

thanks,
-- 
js
suse labs

