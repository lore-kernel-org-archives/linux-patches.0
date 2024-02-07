Received: from mail-io1-f48.google.com (mail-io1-f48.google.com [209.85.166.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F4C97FBD9
	for <patches@lists.linux.dev>; Wed,  7 Feb 2024 15:42:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707320576; cv=none; b=UZr/NzkHixTU/In8t+Zmb3VainDMlQjs40fkYIN4UddosQWsQr3NbeLM6ipOmtLtFAhhjeRZukkXpeGlUAVaVmjbb6lKd3K0+XbJ4fndjgTQtn8vEz/mgzVO7bzGTd1VvNVBGAAUEV2x7be9TnCx+HYPU3RQLPX7E0OcF4yBUu4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707320576; c=relaxed/simple;
	bh=1TrfzkBsL1WVx9RjhlOtzOZiYzcHZHgnoJCCqCC7iAY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Z0g5t/LHraHiOA6t5JMDYzCJD3o7zWIZ1Nify13fD62v9oIOwUN92Bv+xETIPYsqZhmsBAAxIVsmQmhR8bqp/xxzDl84INAeWif04zrxVJBUyW5ypxjCynP5Pvm/Is0mwf4td5ybSmLFM80aIHWpMgDDPH2ESkCpcJdOP+qptTE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=zNg4ONLO; arc=none smtp.client-ip=209.85.166.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="zNg4ONLO"
Received: by mail-io1-f48.google.com with SMTP id ca18e2360f4ac-7c3e06c8608so9468639f.1
        for <patches@lists.linux.dev>; Wed, 07 Feb 2024 07:42:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1707320573; x=1707925373; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Ihwp8cTqnihc34CsunDqqET9HspjGRMlUSXeNp8o+Vo=;
        b=zNg4ONLOO7zsRtwX6vyICtvWbrVbJtoucbZKllzRKtzSXowb00rUetpgtqgXz1iBWg
         T8UuWAycUGYOeT5kaw/zTA3QEq8zdl5sit/APAlpkBMYwOaNSbEnHVRkIU3Q30JL7rWU
         ZuEJK+ODX/nRTJy/3oVUvpjqxhWiSBexSGlMG65EtSw4AsNoyAmbA0HdVX6xyq/JEhxH
         8mMvAOvu9OMfikqPPuuZP3g6LobWocTzQgTLCBUKEHpNtQipboqmcYzZsFSQtwcqPxg3
         8NLgqZFUp8Ykyt5PCkkttEdoF+VEdUWX50J6EviKNKJX8/E8UaQpn2gh2maLLba5kMgl
         RoaQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1707320573; x=1707925373;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Ihwp8cTqnihc34CsunDqqET9HspjGRMlUSXeNp8o+Vo=;
        b=uLfWymERxJd60OhYdKMyg3LuPynLUN+VMADcR+Lyzuk+CCdCmr0o7GdyXx/9PVGJiH
         HgyixmKFrDu9eullZchEYhFmArqh6R/EhdsUolGqzezK8JUtLSsWi/TTOxL9z21itm78
         TVn7WSqjX979OlaICQnEpbX9B+pEQK5b/QTD7YCjsaTcUwehp8bQREz2V7AquLLIMADA
         pTNgppSu4+XED9ZlHKDCcuI0vbs3qDoKLZFTTC0U0VPpooLnF8zJGZ9Uv4+g4SzYexFs
         Z1OUNbsHm7OO9TRfqP1YUoMEYlm5F4Co9T974DdGvfZgGJ8rRK8xGFpdXGD5vD4OP9pa
         JXUw==
X-Gm-Message-State: AOJu0YwhszogJqpRU3m+iGQl7/ygLOvzYUbse2kXPEdLrvYElC8CYfMj
	2vdR7LzPBSIHATFliD5dIYwUWp/8zuHQaDbXKwUVp5AVJ3da8bCh/7GIQBjmJCs=
X-Google-Smtp-Source: AGHT+IF0kKyZkV7GPSwQSM/boSw3gjUTmIjIz2biVT9P1TsvfQbulft5Jox1vLaSpOCA7ZAYCLFbaQ==
X-Received: by 2002:a05:6602:2410:b0:7c3:f2c1:e8aa with SMTP id s16-20020a056602241000b007c3f2c1e8aamr5593903ioa.0.1707320573199;
        Wed, 07 Feb 2024 07:42:53 -0800 (PST)
X-Forwarded-Encrypted: i=1; AJvYcCV6RbbH4hrJrGnhnZ6MDSpPFGPFHwmyd4PTWzpAH1sektPo+U6OuGxbIMb3NUmpClh6JyBcovF0G19t0+0oLabi9Bc/SKeD2bDTj0k2nGr/5L8W6rOFgjkkIVtK1naV9V6mmaZeR2ycc4aiEDrMZRQYZ3SLuBqRQFUp1Q==
Received: from [192.168.1.116] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id dx4-20020a0566381d0400b0047133171d55sm363718jab.133.2024.02.07.07.42.52
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 07 Feb 2024 07:42:52 -0800 (PST)
Message-ID: <0e293041-b06a-4657-a35e-29519bdeb2fe@kernel.dk>
Date: Wed, 7 Feb 2024 08:42:51 -0700
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
To: Jiri Slaby <jirislaby@kernel.org>,
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, Pavel Begunkov <asml.silence@gmail.com>
References: <20240122235818.091081209@linuxfoundation.org>
 <20240122235831.353232285@linuxfoundation.org>
 <9fc00f54-24d5-44a6-a690-d4f73c37caa1@kernel.org>
 <8ec60240-800e-40b5-838f-b4779b5fee36@kernel.org>
 <6c91c497-0653-4901-a673-66922f3f5e7e@kernel.dk>
 <f1d815b2-7c0c-4773-a91e-f381df193795@kernel.org>
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <f1d815b2-7c0c-4773-a91e-f381df193795@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 2/7/24 2:04 AM, Jiri Slaby wrote:
> On 29. 01. 24, 14:58, Jens Axboe wrote:
>> On 1/29/24 12:34 AM, Jiri Slaby wrote:
>>> On 29. 01. 24, 7:44, Jiri Slaby wrote:
>>>> On 23. 01. 24, 0:55, Greg Kroah-Hartman wrote:
>>>>> 6.7-stable review patch.  If anyone has any objections, please let me know.
>>>>
>>>> Hi,
>>>>
>>>> 6.7.2 fails in liburing tests (both x64 and x86-32 lib on x64 kernel):
>>>> [  115s] Tests failed (5): <fd-pass.t> <msg-ring-overflow.t> <pipe-bug.t> <poll-race-mshot.t> <reg-hint.t>
>>>>
>>>> I cannot reproduce locally, that happens only in openSUSE build machinery (the errors are transient, the links might not be valid in the future):
>>>> https://build.opensuse.org/package/live_build_log/openSUSE:Factory:Staging:H/liburing/standard/i586
>>>> https://build.opensuse.org/package/live_build_log/openSUSE:Factory:Staging:H/liburing/standard/x86_64
>>>>
>>>> So I cannot tell if 6.8-rc is affected.
>>>>
>>>> I suspect one of the 6.7.2 uring changes:
>>>> e24bf5b47a57 io_uring: adjust defer tw counting
>>>> 22eed9134509 io_uring: ensure local task_work is run on wait timeout
>>>> ba8d8a8a36b2 io_uring/rw: ensure io->bytes_done is always initialized
>>>> d413a342275d io_uring: don't check iopoll if request completes
>>>>
>>>> It looks like EINVAL is received unexpectedly (see below). Any ideas?
>>>
>>> Forget about this. The build service is currently broken and is using
>>> 5.14 kernel instead of 6.7.2.
>>
>> Ah that makes sense, the tests should work (in the sense that they
>> should not fail) on eg 5.15-stable, but I guess the 5.14 kernel is
>> something else entirely? Most of them would return 77 on older kernels
>> where a specific feature is missing, but eg pipe-bug.t should definitely
>> run and pass on older kernels.
> 
> It's SUSE's 5.14, so 5.14 with this many patches (45k+):
> https://raw.githubusercontent.com/openSUSE/kernel-source/SLE15-SP5/series.conf
> 
> I am not sure it is supposed to be working in there too. But maybe we
> are missing some fixes on the top of the backported patches...
> 
> FWIW 6.7.2 was fine after all.

If all stable backports were done, it should Just Work. But it's
obviously a bit harder as it's not matching eg 5.15-stable, since it's
5.14 based.

-- 
Jens Axboe

