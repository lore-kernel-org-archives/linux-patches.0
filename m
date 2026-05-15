Received: from mail-ot1-f46.google.com (mail-ot1-f46.google.com [209.85.210.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B871C36894F
	for <patches@lists.linux.dev>; Fri, 15 May 2026 14:05:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778853902; cv=none; b=fMNSPgd0+rYoJPcd7GQ+waILtYNVhyVXgsFu5NdH7BDSnv8xbB/qPmfy28NCqbkNGf3KurnxKAiiMMRNSyH3sqptZKWlMaC5zmpGwXtrrT1DTnIMJlCl+nrnyA8CkbyfJ5HSUwQNKgvL4kiZPBS0FJxAby/Lr79epzVEbkFTQF8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778853902; c=relaxed/simple;
	bh=JqktXW/5n+RkTw2u+eeRD19Y+s9wECY+hNjunBA2ark=;
	h=Message-ID:Date:MIME-Version:Subject:From:To:Cc:References:
	 In-Reply-To:Content-Type; b=mDVXVdYuZGYNSWn6bZvamGR8wK12mk+YYZBO1zuhM/e0cyQLiHP3EnR3+1xgsEr2L2hvVYhXjM6wqUlAQtaL61EjIDbi+yDvUV6Tw5p8gKLLs0EQEIxkN53ny9vVhIHWnqpImT+hG9rPs5CcBz1bn53TZs0vWLibaplmVcjXdkQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20251104.gappssmtp.com header.i=@kernel-dk.20251104.gappssmtp.com header.b=lGiTz4ss; arc=none smtp.client-ip=209.85.210.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20251104.gappssmtp.com header.i=@kernel-dk.20251104.gappssmtp.com header.b="lGiTz4ss"
Received: by mail-ot1-f46.google.com with SMTP id 46e09a7af769-7dcdaf06498so6273785a34.2
        for <patches@lists.linux.dev>; Fri, 15 May 2026 07:05:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20251104.gappssmtp.com; s=20251104; t=1778853900; x=1779458700; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :cc:to:from:subject:user-agent:mime-version:date:message-id:from:to
         :cc:subject:date:message-id:reply-to;
        bh=qa5WkmLYfl5O5HePZG/1LY1cXG3nwQYMN7evwKBu/fU=;
        b=lGiTz4ssYRVK5KpVA1r1GLx9Fuj33OsoMq9ZwC0doZvkmOjB7p69G1UpIuISGJlh9g
         ShYrubU/ecjLRj6Y5OWcFgmGj3FgicgoV4cy9kbiGsHC7iutb0W0qiS01iYoYiDBkeqN
         AusGzYDf7Yx9WY2N0fnNJt7ziBK3EsD3hy29RcQL6v/Y8vtc36iYyuSJK7P/tOO/LtlI
         QkjeTMcUUfsIu4ou4DZlm0gdpvPTojTxFn4gmwhZ/DX9VemBPCmK6glcacELLpx+Yv9z
         oKnWRwROy6XPG/6r1aenEBJFWjGeXn2Lf/V8SmwYOKjNHGCOe/vVUEetBQHZ4f+1LWXW
         01TQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778853900; x=1779458700;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :cc:to:from:subject:user-agent:mime-version:date:message-id:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=qa5WkmLYfl5O5HePZG/1LY1cXG3nwQYMN7evwKBu/fU=;
        b=Be2SGBHK4YBwn5qEKsNlCKi87aqGmcH0L5b6q9C7O36LsLfxnCr0zywE3kUdO6xHfZ
         fg2fTDDcZ8BKLk2LgCTvsDtI3wjP+YSG5hSP6VVMqjIFrsmrMdDmwbvGMcDNUVtOH+IY
         q0fA5DFjiOHtSP7O4AC+rBvmA5MqjIHnlDvY7pUe3Jt1MD09W64iIL4iQzXS4XTvIQgx
         ZFxnH9sYsT/GT4NUIE6ZI9H/ABsjXNdDMGedGjWHnSzKzoCdqjtwmPwA9m+AZ4bzgUAM
         jeSoB5bM8y+hQu2uRG+J1F1Wo1v+5BzNdaNwsYFwGMJh+ItqzmDE/2+En4UJtX7AZHgA
         iBgw==
X-Forwarded-Encrypted: i=1; AFNElJ8RhHzu3qHsTnURLfJgYzbZIcPTLnXWyKu3F1I+1GDYn5s3HksUonM7HRi96nlORJIMBySVwyi8@lists.linux.dev
X-Gm-Message-State: AOJu0YyoXvYXgRmFACAVppCPGy1J76g9dBE2/lyLcHlio8H9TlpzDBqA
	XIt6hLGswzzbNp4PMMpdTc18tr4u6DUiwSsI8vH4HlmAEwRhD2JEdww2+iHhl8YddvE=
X-Gm-Gg: Acq92OFt+0B12I/iIDxfD+Ma4mRTl1lkwG4LoVLSAT8w40UevFyL/epdx2CdQyARpJH
	pL7DorvmA6Mq+WUNlsCKBZViGIJZ8fJ1MGTCs4Wztccvj9srcjrN9+r84gqtq2XNc89flpuNUd1
	rOWlccq0UrJYaIYAPrpmeDDiSAtB3xEr/uWAaayfWvDgbR9KfwVHKl0VZ3oMbsVp76buSqrCL12
	nDgow3Avol+Q+w8a7AiVNXyp/NpDIGPi6e5iGv6jwmB2WOHGoyl+PhZQJIvtL1Z72NM93zM4QKT
	nWe4rhJgkynDT/d6rfeYkRgDf6JD/HBSahZnKuoSkTlE5rGMd11xo9Ff7kWOert3BXRcY7TWLcG
	3E49rKpHdafbg0x+oDQ/qpntO6vFaXqMfd0SM/sEG0bcwZE1rt6xpX9E0+GCmg+XOTDL3zoweVL
	9X3KNhTXWFZTFbfvF0f3HzaJc4Qhy9kZohovBruPjTHuHjBdnplzwvY9fHy7dYsG9DoVvrVmuhh
	ChjpOOZ
X-Received: by 2002:a05:6830:3c0e:b0:7dc:dd91:b5b1 with SMTP id 46e09a7af769-7e4ea032147mr2628097a34.5.1778853899533;
        Fri, 15 May 2026 07:04:59 -0700 (PDT)
Received: from [192.168.1.102] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id 46e09a7af769-7e55bc4983asm1319072a34.26.2026.05.15.07.04.58
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 15 May 2026 07:04:58 -0700 (PDT)
Message-ID: <96e5ee2d-a64b-408a-ba7f-e9ca25952959@kernel.dk>
Date: Fri, 15 May 2026 08:04:57 -0600
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
References: <20260511221931.2370053-1-sashal@kernel.org>
 <20260511221931.2370053-13-sashal@kernel.org>
 <e12d01e9-8934-4150-bcb3-09ba147fc842@kernel.dk>
Content-Language: en-US
In-Reply-To: <e12d01e9-8934-4150-bcb3-09ba147fc842@kernel.dk>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 5/12/26 9:47 AM, Jens Axboe wrote:
> On 5/11/26 4:19 PM, Sasha Levin wrote:
>> From: Maoyi Xie <maoyixie.tju@gmail.com>
>>
>> [ Upstream commit 45d2b37a37ab98484693533496395c610a2cab96 ]
> 
> If you auto-pick this one, please also do the other one in the
> series, 9cc6bac1bebf8310d2950d1411a91479e86d69a1. Makes no sense
> to do just one of them.

Hello?

-- 
Jens Axboe

