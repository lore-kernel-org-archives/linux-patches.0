Received: from mail-ot1-f46.google.com (mail-ot1-f46.google.com [209.85.210.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2348F2F290A
	for <patches@lists.linux.dev>; Sat, 23 May 2026 14:55:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779548150; cv=none; b=TsZe79dkFKn0/LDEEIj/RyrR5AcKZNkhHzOopfxhsJVNVXqBCrqp608gHPG5EHeCieRzGHxvFpuB8dAq2MaZAasXepGp9VWYLk9Nxd1UqIIDOleg9ftVJ4k6a+zd0cArWhJfbWAXtDIHGn143aQTRELDx/XzVO3SmM/JPlUAh9s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779548150; c=relaxed/simple;
	bh=MOtTruu7oCpPtDhl/HWaJcw1a1JNAc9mlPuGoIepHx8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Gieu0SEsT4lNRiNwvV/2wDiCFebuoR1BIOs0K8MOKY6gm1Bygxt0SwKx9mIYKCLwjGG8ehcED6XHZeEIMNZ+DKfSMyXsRJ2hBB9o6bJF42P7/US+a8gTDd/5UWgUYQlmo56eGpsckRCHBaOCH3a6BVLvk9qH1+H0Qbo2rFb2HMk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20251104.gappssmtp.com header.i=@kernel-dk.20251104.gappssmtp.com header.b=rB0v3Zqc; arc=none smtp.client-ip=209.85.210.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20251104.gappssmtp.com header.i=@kernel-dk.20251104.gappssmtp.com header.b="rB0v3Zqc"
Received: by mail-ot1-f46.google.com with SMTP id 46e09a7af769-7e61d3fb1c6so204048a34.3
        for <patches@lists.linux.dev>; Sat, 23 May 2026 07:55:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20251104.gappssmtp.com; s=20251104; t=1779548146; x=1780152946; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=GfL9Mnhn6RS/dK9GHgYTlaEa86j6tsYvdObuz5oD1iU=;
        b=rB0v3ZqcnR+rauyQicU6BflQEkJ3dHxOLQXBAbRsaRbHZ4it0fN4fm9B7fOcAHB61C
         1Orss4Cik2KLV0/KID1Upq9VqMatV1CY+BEJeSf1yfF8JbGagQ6xY3tVc7hEhLBO9sVx
         5YTSZcHVfABtgzXHhx0oTb/sgmUrDb3/poOX69VNWnF8zQaFYLQBf5cT6ovC5vElPOsp
         kiXb6x4sLaZaLSC3bgm98gveMUnOfUnxJCZaQr766F8lNCuZ8Yespkgr34O68kKjCD5B
         VJwWZaSonS8wiuOksKMnZNhmaDMfZN5MmcSyXZjHY/4n+N3ZKO+9D9QnE2PgJ1zcAJh4
         E+NQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779548146; x=1780152946;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=GfL9Mnhn6RS/dK9GHgYTlaEa86j6tsYvdObuz5oD1iU=;
        b=hpVJ6vyVTvBpvR5MPsH9iOIWYX63iB/vSP1JAJAJBpQBvEwGdDD4pBkh4GUi1Gez+b
         yunhDcgzXyATkFsqN2Zg4kY4yC2y2bxs5ddIzHJZHalQUrTmW5V9OZ5hgD3GWPvIJ6e4
         //EIy04T828fpLcahRS3pJzxxM4MUgFmQ9jp4hoLdBFa/7V2pkn0iISgZhxKUajPLYDC
         Gm21tplhckNj7ao85yRqznJ8AP5t8aqqDPQ/4+X9KiRqgaVJ31Id0WftyqIs2zDj5X3X
         FE9bzggFkC1JLMySWS7ONP5yrIQYgClxMfHv3Wa0omqm7hb+H8VewstGNwhHFafcilWI
         Uotg==
X-Gm-Message-State: AOJu0Yz8a+1wbDpl5SRb6XXTR81WYWHZs5qAaZ6/aQLEbK3p1TNYjYjA
	k0bp/WXS2rQ3hoKAuBqZWRdnOAqJGjS+crsuXwCMOoj9e9u6zUb3CTVHScA3fNF5ioU=
X-Gm-Gg: Acq92OHGJHcO6+D4GDEiaqtVSXlfHizCXPjv2R7DMULIefABYzYIulobGsew8PQR70O
	pyMYeTA0e4qwB1ZylQZi2/rhDC1NKzZtxmOS1yJytNKtcwd2MKmoXsK/kPo8H6Wnh/auW+ZZBgG
	SSC94lFR7dci3MK2LP0x0NkfNS4UDLYsry5O/FsQ1k9wUnpis8E8hqzFgkzmV8hVws3ZA26HNBU
	jqQCYMVIhAw5CoWZlIzIaXUh36A0S9uTLqLsvfhIm/6jgyn1Nzc1cCZKUuLgwH/LkKvxC7T45sX
	QihvSh+/CISyJ9aa6qkgKiT7ZRr22nKp3Y1kHL3I6VQ/7NEbo/Emp53DqFNhH7H6B92hoY3JA12
	p3MAZWe4QBLaxP6TszfZ/4CvZy24EFJTIhDJK0n1JP3KPSu3s6aYKGjoGJbgjXq6SYN/AJ1G+pQ
	ls4+Cqa77l8AaUBSt/mg8F7FGBvfpYiQCa9zUSbZbpfEwbunA1JfxcppTPBUJWVn5wK4mDYDmPD
	QEH1Yww5w==
X-Received: by 2002:a05:6820:180e:b0:69d:6696:846e with SMTP id 006d021491bc7-69d7ec2609fmr3926788eaf.29.1779548145739;
        Sat, 23 May 2026 07:55:45 -0700 (PDT)
Received: from [192.168.1.150] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id 586e51a60fabf-43b62e4211fsm4959511fac.0.2026.05.23.07.55.44
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 23 May 2026 07:55:45 -0700 (PDT)
Message-ID: <afe1ad86-3454-4092-88d0-bd9753a1b2c8@kernel.dk>
Date: Sat, 23 May 2026 08:55:43 -0600
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
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <ahG9meYUQ-YLDwHN@laps>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 5/23/26 8:45 AM, Sasha Levin wrote:
> On Sat, May 23, 2026 at 08:23:13AM -0600, Jens Axboe wrote:
>> On 5/20/26 5:40 AM, Jens Axboe wrote:
>>> On 5/20/26 5:18 AM, Sasha Levin wrote:
>>>> From: Maoyi Xie <maoyixie.tju@gmail.com>
>>>>
>>>> [ Upstream commit 45d2b37a37ab98484693533496395c610a2cab96 ]
>>>>
>>>> io_uring_enter() with IORING_ENTER_ABS_TIMER takes an absolute
>>>> timespec from the caller via ext_arg->ts. It arms an ABS mode
>>>> hrtimer in __io_cqring_wait_schedule(). The conversion path in
>>>> io_uring/wait.c parses ext_arg->ts inline rather than going
>>>> through io_parse_user_time(). It therefore does not pick up the
>>>> time namespace conversion added by the previous patch.
>>>
>>> Once again - If you auto-pick this one, please also do the other one in
>>> the series, 9cc6bac1bebf8310d2950d1411a91479e86d69a1. Makes no sense to
>>> do just one of them.
>>
>> And once again, no reply. What is going on with stable these days?
> 
> Jens, as I've mentioned in the previous mail, I handle the AUTOSEL
> mails weeks after I originally sent them out for reviews.

And you think that's working fine? I would suggest that's a terrible
process. How are maintainers supposed to deal with that? Patches x and y
are autoselected and an email is sent out. Maintainers react to that,
either saying "no don't pick X" or "if you pick Y, please also do Z".
The expectation would then be a reply that says "ok, doing that" or
whatever might be appropriate there. Instead, it's just silence. And now
I have to follow-up MULTIPLE times to ensure the right thing is being
done. We're about 2 weeks into this particular incidence, and
hilariously, I still have no idea what the state is on your end. Did it
get dropped? Did the other one I asked for get picked up? Nobody knows!

At least Greg actually promptly replies for the non-autosel stuff he
does. Which is the ONLY thing that makes Fixes tags and CC stable
actually work. The AUTOSEL stuff, it does not. When it happens to pick
the right patches, yeah all is good. But when there's a problem, the
process is terrible, as evidenced by this particular patch.

> The volume of mails and patches makes it really difficult to give
> prompt answers here. I have no idea if
> 9cc6bac1bebf8310d2950d1411a91479e86d69a1 applies cleanly, whether I
> need to ask for a backport, or whether I should just drop
> 45d2b37a37ab9848 until I sit down and get to this batch of AUTOSEL
> commits.

If you can't handle basic replies when running AUTOSEL, then I don't
think you should have that process in the first place.

> If this process doesn't work well for you, I'm happy top skip all
> non-stable-tagged commits for io_uring. This is supposed to be only a
> best effort attempt to catch commits that slipped through the cracks.

Please don't do AUTOSEL for any patches for any subsystem that I am a
maintainer or co-maintainer of. Until this part of the stable tree
process can be improved, it's a net negative.

-- 
Jens Axboe
