Received: from mail-ot1-f46.google.com (mail-ot1-f46.google.com [209.85.210.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E771D3A63E0
	for <patches@lists.linux.dev>; Sat, 23 May 2026 14:23:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779546197; cv=none; b=ew+zTbYQPR487Z5IBYc55wA0hUUwpTpRl0EUXE0VnwUWFISNrEcgSHcmZbhh/NuZKFGP8NRBppBj0tj3lLuV1o7IZWtOPUYKooSJeaKAGZwqUK9tx2dZA0UPDtmcIs5F5zXHUubzXfsQtFljZK858zUBle+S+VKES3tic2qo/BQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779546197; c=relaxed/simple;
	bh=B1SkOVQybuYZKnQkgQqnT8euq6KxNqLE/BvgDc/1ZEs=;
	h=Message-ID:Date:MIME-Version:Subject:From:To:Cc:References:
	 In-Reply-To:Content-Type; b=g4YD7XTDOrlVb212zd/hmufa3xOX/CuU7vCKYASyYSuf+0+OjHQlw1rX4915+eabnOBipkDfBntfwLuctCpsP3gm1lmmKiDXpeSA2j5J+DOI5lsgroBQnVSBoCTH3ZoeOy4xe+ZbmxLi9KLfJDxe24ayC5n/d+r8DtyAGU6N/8U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20251104.gappssmtp.com header.i=@kernel-dk.20251104.gappssmtp.com header.b=UzVB5wkr; arc=none smtp.client-ip=209.85.210.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20251104.gappssmtp.com header.i=@kernel-dk.20251104.gappssmtp.com header.b="UzVB5wkr"
Received: by mail-ot1-f46.google.com with SMTP id 46e09a7af769-7e582b3bcaaso6973242a34.3
        for <patches@lists.linux.dev>; Sat, 23 May 2026 07:23:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20251104.gappssmtp.com; s=20251104; t=1779546195; x=1780150995; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :cc:to:from:subject:user-agent:mime-version:date:message-id:from:to
         :cc:subject:date:message-id:reply-to;
        bh=cy9jYvmsFlyJHrWwIX2opm2bPqsw1+AmzdT1aGicVEs=;
        b=UzVB5wkrkZelJ8eZsaWGRQ3P25ZYvUvS++g2+kFlouMky8Lb3/pAXMlqC8W9MonOC6
         OjkaLCt2LQ9FyF78iLzJuLBJmpBYqZhn3WQLNfFK4wAm8UqrD9W441W0JXMu5c6WPk9/
         UFZVdk361U0jXAEoVzhFV3UkJ8YkWne5TrTEds/+ZKqX8aNwb4RnCxfa15ZKVUQagMWd
         YLVl/VrJrStJklnhE26SsQOvR0INLC4ykmPaVVKckyA4GC9g0C2T6TTw3RUbk+tiDWft
         cPmAZrYwJetOAAepnWMCtEDhJKuulMPUrStXRQT+KIQZHbtVOpYfBG+9O5+wpfaCFnxM
         XiMw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779546195; x=1780150995;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :cc:to:from:subject:user-agent:mime-version:date:message-id:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=cy9jYvmsFlyJHrWwIX2opm2bPqsw1+AmzdT1aGicVEs=;
        b=PqDV9ToL4BbyquptDMMh/XK4/yWakdeD6aHB/GuxMZ5STRdPGfxOqPzJF4NdOmTkGT
         hzunlhEUAX1EyVS5Nz61HoWgvjrQhuu2EVLcg9PIX7gLVV3kaUpmsA4OTU6f/eaEbbGj
         Uet1xJ7Pq/cEE1XAgrfXbCiSIX0GGg9KC2raRBEeTl165go83xGT8Bwl7HIabhhRierM
         2Zjo5eUZ4ZM/t4iwBCCDidy+FF9+RfljLi2WFpQytLrGTzddE16TdP6LoEEVORpnNIw0
         3oatRY7jsx/qMxqWRLuLAPemSQrxCKLFCdcmzG9ylmKe57MsmWbVyVxNXL7Yh+VaXxH0
         p1Pw==
X-Forwarded-Encrypted: i=1; AFNElJ+NQI6CAl8BiUJNGXDUoiaYyND566lwEvJqKNTFvKW/jCavLS5ykEfyEWa0j5lYCtVvPm3Th2im@lists.linux.dev
X-Gm-Message-State: AOJu0YxqlakNvU3ipeDdfFUwqd3rKdxRaYIMQNdj/8WD5atSH9eP4Qnw
	E4KCDGi55neAyn3yZgI9vKxBIJZqaSV1lctFLQ9/OyNvcTmzJsqO25CwbByfz8DfxdU=
X-Gm-Gg: Acq92OF2rQqnOwF9zfn+Pf+oe/nm6eSrcnyL5Ygu48omX5VLT+mWBa3GD5+fxRGggw/
	IG7PJ6Q13hv3YJdpyB49+GyEnO614ybOxvEWX7u1OiWK35Fioo0xEEDMiyzTjfX0LN1TkC3IaCq
	mthZeet5K7n125BBiGY10vNvpsXFzDOxJNxMUJFffANjQwl19N3+3YtzRrEIyfJS+FAp6T8sneq
	SU++jYE7GMY/J1R3E2cmSGCDMPGYP2OzyAiyI/q58nwUXc0WXiATEy2yLIZe8Z206fxJCXHpkC8
	gcL+0zO/6CKrp+Zg5u33RvCYRBBX9Dwe6sHFmhymcdHCz+hml53psKy66YKDAK1H0eq1LewEh24
	baNgL/qxptxKy6cw8ucp7P7WTNqfdB1cHceWuWsrQPJi2B9J5AiE8Qp3LQ3SzhfebB601lkDI34
	SgiD5fkasexvlITxo2ReX7Y3RLq1TKvUYWphifrW9DVowabJr3m1KDQtJRmWfSrrBhSVOmdh/x7
	rB+NeBM3Q==
X-Received: by 2002:a05:6830:6285:b0:7df:5fc:3fd8 with SMTP id 46e09a7af769-7e5fed0ab9cmr4772009a34.1.1779546194811;
        Sat, 23 May 2026 07:23:14 -0700 (PDT)
Received: from [192.168.1.150] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id 46e09a7af769-7e606459dadsm3299655a34.4.2026.05.23.07.23.13
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 23 May 2026 07:23:14 -0700 (PDT)
Message-ID: <8e853555-604e-46e5-8e25-a5f80b88e51c@kernel.dk>
Date: Sat, 23 May 2026 08:23:13 -0600
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH AUTOSEL 7.0] io_uring/wait: honour caller's time namespace
 for IORING_ENTER_ABS_TIMER
From: Jens Axboe <axboe@kernel.dk>
To: Sasha Levin <sashal@kernel.org>, patches@lists.linux.dev,
 stable@vger.kernel.org
Cc: Maoyi Xie <maoyixie.tju@gmail.com>,
 Pavel Begunkov <asml.silence@gmail.com>, Maoyi Xie <maoyi.xie@ntu.edu.sg>,
 io-uring@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20260520111944.3424570-1-sashal@kernel.org>
 <20260520111944.3424570-26-sashal@kernel.org>
 <5a50c3f5-a5ef-4b2b-821c-5858d8b1ac13@kernel.dk>
Content-Language: en-US
In-Reply-To: <5a50c3f5-a5ef-4b2b-821c-5858d8b1ac13@kernel.dk>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 5/20/26 5:40 AM, Jens Axboe wrote:
> On 5/20/26 5:18 AM, Sasha Levin wrote:
>> From: Maoyi Xie <maoyixie.tju@gmail.com>
>>
>> [ Upstream commit 45d2b37a37ab98484693533496395c610a2cab96 ]
>>
>> io_uring_enter() with IORING_ENTER_ABS_TIMER takes an absolute
>> timespec from the caller via ext_arg->ts. It arms an ABS mode
>> hrtimer in __io_cqring_wait_schedule(). The conversion path in
>> io_uring/wait.c parses ext_arg->ts inline rather than going
>> through io_parse_user_time(). It therefore does not pick up the
>> time namespace conversion added by the previous patch.
> 
> Once again - If you auto-pick this one, please also do the other one in
> the series, 9cc6bac1bebf8310d2950d1411a91479e86d69a1. Makes no sense to
> do just one of them.

And once again, no reply. What is going on with stable these days?

-- 
Jens Axboe

