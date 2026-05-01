Received: from mail-oi1-f178.google.com (mail-oi1-f178.google.com [209.85.167.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 45B9B35A933
	for <patches@lists.linux.dev>; Fri,  1 May 2026 21:42:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777671729; cv=none; b=R8zfZfhaE04ETVgpc4ecFDG8Uu89WGNwnr3dakhnQWpDxBf7uIoj2ZEnEK9kBGtrUvEH0jt9Gazx+4nEHyJ92XV7QieGNLeVbCuzuLW5AjxZ6i3q24CD+eSNLg2Mz2cq48a684HhTL4w0mFzZnJonQnAccnCezTgeAZhmXvsfVw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777671729; c=relaxed/simple;
	bh=lDM13he57cwPmcmYjRqkKJTWL/Cw4cBje7jFzjK14fc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=IO3zadhKxwXR5OqOgg8k/2D6avj+m2ObkYeNkFFMN3qYE/N5fO/04LGVGYnn6UeDu65I3j/weemJdEMgfpRuyc65vAJvY2Phi62NP+fn3oeY96TsmO8cbwWWqX9SfMI8rdUZ/IlDGnmbAiZrHLnVdBAGBqhlGNP03l4KevwM8Dg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20251104.gappssmtp.com header.i=@kernel-dk.20251104.gappssmtp.com header.b=nonmwhzk; arc=none smtp.client-ip=209.85.167.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20251104.gappssmtp.com header.i=@kernel-dk.20251104.gappssmtp.com header.b="nonmwhzk"
Received: by mail-oi1-f178.google.com with SMTP id 5614622812f47-479ef2b7979so1791983b6e.3
        for <patches@lists.linux.dev>; Fri, 01 May 2026 14:42:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20251104.gappssmtp.com; s=20251104; t=1777671727; x=1778276527; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=7hgj3oDBUCHFsd236n2RzKySxztc4GxMy6oFSyuV6Qw=;
        b=nonmwhzkJ1JscTB/FknpleXWGjYEkJ1JYwDePEs1C09sTP9p+6gThg9K8/SsQ/Hjel
         uFYMSs3EKehNNiOO2f6WjHbgKH19e0zATNtkQEqKhd5MtwE8RM9U9LYg0dOKI2R8+0FP
         n4rN0agQRFwLdPD5Ri/lXHFvyL2lAI6ql6K88achOsB2lUImv1xZcmVPKKetk13zdanH
         w+QS/VqGCbEPXXsKqmjWjiAqbBeJ9UwvJE8/c7RlIonNozIVzuAvmQ3ICNX6gKmRbeTf
         2ZPTYBHaZ4q75o6Qz0d9g3gGsU4mGIC5eUwj7guLdoMPLhDj0mgrdELT4ASZAGBb3U92
         mZXA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777671727; x=1778276527;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=7hgj3oDBUCHFsd236n2RzKySxztc4GxMy6oFSyuV6Qw=;
        b=tYMOkcGFUILZG/4MTJgs6kiQXJiScNHQK6Ah6sivTfxFnAy2puC8yk32dRiLSjAdlG
         Te3gIVZrB+C0F8NhyApmoMLIUUxpQIQAwvKx1jRmKYZUnuhfw+LZ3vQd2kVLPOWcqkFA
         tGVAlQ8s53O8FBJtZzj2+Qw8KqwxdRj8cN5KXlNM8uHWWcfXj8GMd+IvD6MWuUy3dr8e
         x8N0+/X3boNeamqbYP+nGl618/vCmjQJ141h1ANvszbLXCw+jNDry6AALVEcFxAh4/ww
         u+ev/tMVMWEQW+Xb78TRniRgaAl/wJXMizuTOz1a2MsOkBCUroakKchUGU9D8KZMV7WM
         0pSQ==
X-Forwarded-Encrypted: i=1; AFNElJ+B2e7m5WBIHQSyIBxrJUZSyEmO6vRFGBlYkxW6MHYDUtVaTQEqzCObzkCwUyIK+Z+Q1v2g7Y2Q@lists.linux.dev
X-Gm-Message-State: AOJu0Yw9TLUiyvd29E89vtMev2RIOcWIvFmkKAbkm2mBDrfYkPZ12Jr/
	kdW/xq+sIlnQPet9/kjOEnyp1ieKvOZ8L0dApZncOz9g99ohTFRxShKKYVU6JD4X8V4=
X-Gm-Gg: AeBDievIjQluMhp5LanmDQKX6tVeFBYu2whlv6FAPA1Fg8hnlHa1cKgOmmi3ZPqE9DQ
	QNjjC8RSS28DiX4HTfGwgG0LOBpYD10BJ6glbQvYkfiZ+zgX+csPIkzNXEQZb5g9pOEBGWUprsH
	Ayin3zXod/UAatfzHNTVkxyFXTpFx4Lc71sKR4ayKj2GOqHqhOWbysNPE7MPlyHru7oIK4fZ2TL
	xbGMpIYrbRh/VQPPav/6YORX5sEpkbVXbmGJ+UqGd0XhOeaGocpjFpGTWSbmk81/ta41UKTqsjj
	OzGN6TXi2GxTDhuWkO5yFTFdKfn7XfXRaHq63fwtw2ULRKBR8cnTmZib2UBWeYgaf2Y/V1t4qLH
	AgWbdPtdgQNRmvn71Rhkbp4/qzjRQwiYlgpWSiLYUlUwUa6/+FF5+6eklKMcL0qPySiaAl+TzwJ
	yoYbLZU3HVAqPon7mbn7vGTVrdWPrVyZ4avWtugpf9YLYZwNs13N1YzydVkwvKWLYd6AFXO+bKy
	QnbRKJPezat2zLpDyxR
X-Received: by 2002:a05:6808:2217:b0:479:3a08:b50f with SMTP id 5614622812f47-47c88fb61bcmr762983b6e.4.1777671727140;
        Fri, 01 May 2026 14:42:07 -0700 (PDT)
Received: from [192.168.1.150] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id 5614622812f47-47c76400690sm2066165b6e.7.2026.05.01.14.42.06
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 01 May 2026 14:42:06 -0700 (PDT)
Message-ID: <74e3db05-780a-4a2d-9e54-63a4f00decca@kernel.dk>
Date: Fri, 1 May 2026 15:42:05 -0600
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 5.10 491/491] io_uring/poll: correctly handle
 io_poll_add() return value on update
To: Sasha Levin <sashal@kernel.org>
Cc: Ben Hutchings <ben@decadent.org.uk>,
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
 patches@lists.linux.dev,
 syzbot+641eec6b7af1f62f2b99@syzkaller.appspotmail.com,
 lvc-project@linuxtesting.org, Fedor Pchelkin <pchelkin@ispras.ru>
References: <20260413155819.042779211@linuxfoundation.org>
 <20260501111233-b371eac52cd006bfddfbd9e5-pchelkin@ispras>
 <20260501200000.item005-revert@kernel.org>
 <6eb47d20-ed49-45f6-90f1-41c15fa99896@kernel.dk> <afUdfo_lfJJX_2pG@laps>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <afUdfo_lfJJX_2pG@laps>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 5/1/26 3:39 PM, Sasha Levin wrote:
> On Fri, May 01, 2026 at 03:23:33PM -0600, Jens Axboe wrote:
>> On 5/1/26 3:11 PM, Sasha Levin wrote:
>>> On Fri, 01 May 2026 11:54:18 +0300, Fedor Pchelkin wrote:
>>>> The Fixes: tag of upstream 84230ad2d2afb points to 97b388d70b53
>>>> ("io_uring: handle completions in the core", v5.19), which is NOT
>>>> present in 5.10 or 5.15. Additionally, in 5.10/5.15 'preq->result'
>>>> is unsigned so the 'if (preq->result < 0)' check is a no-op, and
>>>> __io_poll_add() already completes the request when it returns
>>>> non-zero, leading to a potential double-completion.
>>>>
>>>> I would suggest to revert the patch from these trees because there
>>>> appears to be no real bug to fix.
>>>
>>> Agreed. I've reverted both the original backport and the followup
>>> "fix backport" commit on 5.10 and 5.15.
>>
>> Please hold off, I have fully tested these. It's quite possible they are
>> wonky in certain ways, but they currently fix a livelock as well that
>> you can hit on 5.10/15 which is arguably worse. Double claim + complete
>> should be handled by the poll grab side, I'm _assuming_ more cosmetic
>> than anything else.
>>
>> Please refrain from dropping patches until they have been confirmed by
>> someone that actually knows the code. I've been busy today and haven't
>> had time to look into this one just yet. You're just making more work
>> for me by dropping this you have little insight into.
> 
> I haven't realized that this was a custom backport - I thought that they were
> pulled in without the Fixes commit being present.
> 
> I'll drop the revert, luckily this wasn't pushed to stable-queue yet.

Please just add the fixup, which should go into 5.15-stable as well
of course. Both of those have been notified about previously.

-- 
Jens Axboe

