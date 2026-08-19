Received: from mail-oo1-f46.google.com (mail-oo1-f46.google.com [209.85.161.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C9A017C211
	for <patches@lists.linux.dev>; Wed, 19 Aug 2026 20:53:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787172838; cv=none; b=pGVlqH4ElT2zmIxAS9eMVilXLT5+/VLEpX4S991vSYVL1MwuIn6GKI/uraeI1CPE3PwZOgguWy0aThE4GCgdLHrBq/h63EULLlai6My+agtkZyR4dtwT+Vgv6ZCif8WQDVJvu8I6/2HSIFth+gMjZeXNWIshgEkB8m9Dg2a0dQ4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787172838; c=relaxed/simple;
	bh=9COjZBjMNWPO66tZjXBlEbkfK1lABv+uJewU4IkvCLA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=R7Zl8XGd58qsKw6axlbg/SuHtHS9JRq/S9qfaqRceV/e/sOUFDsSNyrdHHlfePEYf5YxSkHwTpkJ0ViROIwcRlhqlMeHJYMphAwdeY27hCC5Mrgcyb6o+lo2vDlEYXVXTNU4Q9vM1MXQzkCWSghy3adtuNiM3ycdS+unN7s715s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20251104.gappssmtp.com header.i=@kernel-dk.20251104.gappssmtp.com header.b=y3nlHnYD; arc=none smtp.client-ip=209.85.161.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20251104.gappssmtp.com header.i=@kernel-dk.20251104.gappssmtp.com header.b="y3nlHnYD"
Received: by mail-oo1-f46.google.com with SMTP id 006d021491bc7-6b14a370dc5so152152eaf.0
        for <patches@lists.linux.dev>; Wed, 19 Aug 2026 13:53:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20251104.gappssmtp.com; s=20251104; t=1787172835; x=1787777635; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=PpLEkKOKUwZ5t98OnGDW7134XoHRGbaaW2RNRtHE9rc=;
        b=y3nlHnYDnid+9+zWl0O4CUvxrQPLiVK5sx7mDGkoawNKN+i4R3jk1SJ6P0QW3gKotY
         /FF3EjhlTSzMqEGlyHYWZVr4/DlOh2uMg6ecMPpZuOmf7002LQEYZeSFrRETD/kCfbBA
         0xhlXhCPP9Jt8RMpvSddMZfga0M/xuTn9ukWVR9gT4WTWUAQuSHefR5QKhWhGz95TEAE
         ZgtzoikCzT3lS7E8qW2CRrYr4vPbj8eoTBWw5ztBhWa6at/92gYltgdYPlTqFrzqoH69
         kr91bMnbwsg7DjTrcmr+R/wvKxE8imJawXq97wWvEsO3XO1VDD1CBNc/S9lJO2wz9Ezi
         Z9BQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787172835; x=1787777635;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=PpLEkKOKUwZ5t98OnGDW7134XoHRGbaaW2RNRtHE9rc=;
        b=ajG4j145i66ZGmVlbzEv+JVIqzuuNT8irLz35HHegrhrZdOm0ZxO0djLyrc3uvXXmq
         SA+LLLolnfyPtS3djm0iTVD6VYHI+PMm2sZ9y2cPBnG3a4nfm/XSHVEJMrmfItLDEhu1
         0KMDWlZ9pgW9BkirwdtgQab6v9CBxVtREknveDopdPGLQKM0HHsidW47Hp+MAvdOtm0i
         lw5nZpTyKuvB2omSk0Qg0cunK0kjmzADyJSLvDsqctP3ldnO6LzgPmWsZNCKCJLsPsx4
         a1LxY415KCbSUknIe2uErH+1pmAaF1aIip21LXfVJEZLoHSA+24z8uKev3SZ0D26SotQ
         mJTg==
X-Gm-Message-State: AOJu0Yx4eLqwoJDR6bd21V8ZcGM4H1kb8YP8Ha5VolXACdpCXIV4HmWC
	eOPqsEAjHhzgD5hMJd7mZzGO2WWOGVF0Br9MNtMmfjv1xhqvAqLTfatzThjw7l252/4=
X-Gm-Gg: AR+sD12zP8Xg4P9DkvWAN07zOl/w07hc5yneG4dDZ6zG/YD7OYyKdiApeB4a9H8p83n
	qCURHhnpkmwx75zm2Xdu33lto3neSdFd5TLt/33if3YVMTAJrWk6ZzqDkGXwNriNLy6q7q3KM7E
	srf6GWLHVvdDa0qhSSZof5T/9U8uznM76zkebSa3YX7u1Q+KoL3eb3N3yJCkp944v/okfNekgEG
	WyHgPEqLCiSgw24x/WHsKLVwBEwF1a5jWES/v1QGu32n1DKrGJuJV9kAkKiwxpgtpN2QxuWtMDH
	riMI0O1/VuPJfDJlPeEBpwVyd5brUM+CJTRxUJXtP6hO/mSBXvQmHG3nvVrspI7doGrwX13UJMX
	k1UU1tQB6l28papqAvj++92bx/lr96yd5hPhVsFjuki4fW586eqx2fi4GR8ez/smzpvbYWw8FOz
	ICO4Qt889Vw+bn/Vm5FiTK2J3JK60DHbDy/38uYMx20XGMivciHT72oohGXPAkHnvcEH09Cfgyh
	IG2ld7zcfnUtsetBzY9qeeP1owMUJaBQVNyS8wZy80nqPy8aGU=
X-Received: by 2002:a05:6820:2211:b0:6b1:3270:23b1 with SMTP id 006d021491bc7-6b148fe8629mr1648344eaf.5.1787172835333;
        Wed, 19 Aug 2026 13:53:55 -0700 (PDT)
Received: from [192.168.1.102] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id 006d021491bc7-6b13cb51ebdsm2839413eaf.3.2026.08.19.13.53.53
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 19 Aug 2026 13:53:53 -0700 (PDT)
Message-ID: <8671f4fb-e9fd-4f1a-bb2d-bfba7bf1bceb@kernel.dk>
Date: Wed, 19 Aug 2026 14:53:52 -0600
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH AUTOSEL 7.0] io_uring/wait: honour caller's time namespace
 for IORING_ENTER_ABS_TIMER
To: Sasha Levin <sashal@kernel.org>
Cc: patches@lists.linux.dev, stable@vger.kernel.org,
 Maoyi Xie <maoyixie.tju@gmail.com>, Pavel Begunkov <asml.silence@gmail.com>,
 Maoyi Xie <maoyi.xie@ntu.edu.sg>, io-uring@vger.kernel.org,
 linux-kernel@vger.kernel.org
References: <20260520111944.3424570-1-sashal@kernel.org>
 <20260520111944.3424570-26-sashal@kernel.org>
 <5a50c3f5-a5ef-4b2b-821c-5858d8b1ac13@kernel.dk>
 <8e853555-604e-46e5-8e25-a5f80b88e51c@kernel.dk> <ahG9meYUQ-YLDwHN@laps>
 <afe1ad86-3454-4092-88d0-bd9753a1b2c8@kernel.dk> <aoXlt3pcqsqfp52s@laps>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <aoXlt3pcqsqfp52s@laps>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 8/19/26 11:19 AM, Sasha Levin wrote:
> On Sat, May 23, 2026 at 08:55:43AM -0600, Jens Axboe wrote:
>> On 5/23/26 8:45 AM, Sasha Levin wrote:
>>> On Sat, May 23, 2026 at 08:23:13AM -0600, Jens Axboe wrote:
>>>> On 5/20/26 5:40 AM, Jens Axboe wrote:
>>>>> On 5/20/26 5:18 AM, Sasha Levin wrote:
>>>>>> From: Maoyi Xie <maoyixie.tju@gmail.com>
>>>>>>
>>>>>> [ Upstream commit 45d2b37a37ab98484693533496395c610a2cab96 ]
>>>>>>
>>>>>> io_uring_enter() with IORING_ENTER_ABS_TIMER takes an absolute
>>>>>> timespec from the caller via ext_arg->ts. It arms an ABS mode
>>>>>> hrtimer in __io_cqring_wait_schedule(). The conversion path in
>>>>>> io_uring/wait.c parses ext_arg->ts inline rather than going
>>>>>> through io_parse_user_time(). It therefore does not pick up the
>>>>>> time namespace conversion added by the previous patch.
>>>>>
>>>>> Once again - If you auto-pick this one, please also do the other one in
>>>>> the series, 9cc6bac1bebf8310d2950d1411a91479e86d69a1. Makes no sense to
>>>>> do just one of them.
>>>>
>>>> And once again, no reply. What is going on with stable these days?
>>>
>>> Jens, as I've mentioned in the previous mail, I handle the AUTOSEL
>>> mails weeks after I originally sent them out for reviews.
>>
>> And you think that's working fine? I would suggest that's a terrible
>> process. How are maintainers supposed to deal with that? Patches x and y
>> are autoselected and an email is sent out. Maintainers react to that,
>> either saying "no don't pick X" or "if you pick Y, please also do Z".
>> The expectation would then be a reply that says "ok, doing that" or
>> whatever might be appropriate there. Instead, it's just silence. And now
>> I have to follow-up MULTIPLE times to ensure the right thing is being
>> done. We're about 2 weeks into this particular incidence, and
>> hilariously, I still have no idea what the state is on your end. Did it
>> get dropped? Did the other one I asked for get picked up? Nobody knows!
> 
> Hey Jens,
> 
> So I took some time to figure it out, and I want to try out a slightly
> different process to address the concerns you've raised.

Appreciate it!

> Instead of weekly AUTOSEL dumps, I'm just going to do them for a given
> release after Linus tags it (so I'm going to do all of 7.2 in one go),
> about a week after the release, and targetting just the LTS trees to
> reduce the number of commits we backport.
> 
> This will make it easier for me to handle the volume of mails, and
> also reduce the number of reviews folks do since we can skip the most
> recent stable (not LTS) tree.
> 
> What are your thoughts on this change?

I think that sounds like a great move in the right direction. As you
probably recall, one of my big objections was lack of response when
issues were flagged. If one per cycle makes that easier for you to deal
with, then I'm all for it.

Ideally I'd want AUTOSEL to work _exactly_ like the other patches that
were grabbed for that stable release. Sent out the same way, at the same
time, and responsive when issues are raised. If you only want to do one
AUTOSEL per cycle, then IMHO it should be timed with the regular sending
out of patches picked for the next stable release. If we have 2 separate
things going on still, then that's annoying for maintainers to deal
with. If I was doing this, I'd have AUTOSEL be EXACTLY the same thing as
normal stable picks, work the same way, with the only difference being
that they would have the AUTOSEL marker in the subject line.

-- 
Jens Axboe
