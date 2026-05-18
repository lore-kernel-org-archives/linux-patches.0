Received: from mail-oi1-f173.google.com (mail-oi1-f173.google.com [209.85.167.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 30204381AF
	for <patches@lists.linux.dev>; Mon, 18 May 2026 13:28:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779110899; cv=none; b=KCetqyUELMslfZkAD0Udq3qDpXIRwHmi0CfDJDH1G7x8/mHTThd6+pqDpBLsetU+SNSrOrkNtfAheu2Paib+mwcCRSQpQl1OnkYcACIi2cIcssxaqjZPg4m+Dn1kg7qGk1oRWt5fHsLIWJpe1gXMgA+z/Y1pUQ+Viaaftnvqtqk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779110899; c=relaxed/simple;
	bh=7qgIJKx6jB7//23rw9I/17KAcv7/R5w93uBSpHhdmZg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=K2e9mDy2MKXTTnJZaELLdTgEm2YXbjdIp70GGak7v+uf7szZeHxj8tmEs0jP8xeJGhI6aq+pUtqTvaEwJwMYc402N8bn35Kj+Hc+DPSwazGJdjiQC95pscJuUu/TSRYP0O7BCMRik0M3bbRyZufAZUi6VStXfxoMIOYZO3KMPCg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20251104.gappssmtp.com header.i=@kernel-dk.20251104.gappssmtp.com header.b=d7zUIlpN; arc=none smtp.client-ip=209.85.167.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20251104.gappssmtp.com header.i=@kernel-dk.20251104.gappssmtp.com header.b="d7zUIlpN"
Received: by mail-oi1-f173.google.com with SMTP id 5614622812f47-479d9b155deso605272b6e.3
        for <patches@lists.linux.dev>; Mon, 18 May 2026 06:28:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20251104.gappssmtp.com; s=20251104; t=1779110895; x=1779715695; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=izu6ilS0aWgn06SyEgroVOflUroeHp1roh/NZR2jEuQ=;
        b=d7zUIlpNm9tRyCI/LJfz/JOVrZlIF57Kvae83T3gMEsGoM7Ll1VX6NFjBUloKb2zhU
         4xKMh/V4OYjh8zMDVZoRSFA+0G/KUr47OQvCMQ082gDFTSvZjhSTPNnyKcGNixoXFN3u
         r7mQ4ZE2uvDvDjF05DyZsoCD69ifxUIV6HN1cM08537bwuoDDcAnxwfe624uNjbMtWhR
         IlpJLskRX9Prm5yCDd3FgX2e+Qg838ZoHVqzmLvwD5mNMLg2+Mjazj/yk0vK7eU0WBxd
         mJJNQn5DiYF+eqzVl4oXbPtzLHV/s1lXU7nxrXfR1q8+QLgbd8JR7DMEjPd+emNR1Awy
         SdCw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779110895; x=1779715695;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=izu6ilS0aWgn06SyEgroVOflUroeHp1roh/NZR2jEuQ=;
        b=NJBROVioZ1q5mf5cQetyYx8Ai05oVtd0gzx8ZniYkAY//T6UeBRhSrsca/vQJE99rE
         VnVwHpKNR55Y8FRTENT3e1B6Gmm00jsMEXNv0GSIwYOOSh6q68cEVbtkMBpl784BOK2k
         3okVYvlBYyhWvVo6KvEHp5nPXlQZ59Wj9UdZGuVeFVUONHE93l14F+XzvCGh6RiAqt1/
         Ya2PkVcGFqEzK8OeoZQIcT/f1ouXR6A/XtVp36Xa1+dx1RrXnE6gdNDHCTR1OYKxcejw
         G5AZyqAB4ntmcx7G1dees70JZOZwErqYYKe6XWZuvofSdi8/NYGuEqtkvKuWxX++6HO1
         YLAA==
X-Forwarded-Encrypted: i=1; AFNElJ/L1Ef3piSjWzTLzL2f4zow8ME80WUIKPpkdh9rNkXsSJYc+xoU+5YdxInK7DZ3aMpZTj6ZcMpy@lists.linux.dev
X-Gm-Message-State: AOJu0Yxqthx9TK1ZYha4QdcpI3qIH7l9UHmzOyb+Xijk8Wa6Q9/+2NaL
	YZgjEPaaobT/Zf+Y5yugYhU1ZK0fa0yys6lCyvSCqmx+aqg9Yu9GeKIrInr4Kf/TaLQ=
X-Gm-Gg: Acq92OEBzgZyB4LYPX/dE3s+1zYdyb1uPilhvK4Wc7f5T8u0EwCJ4MGZ+0n1lIpaUQl
	5/xSY2u24OJad2RYhH9UQhfOSlL79mhbKzQ0Y9Z4VOpCz/V64hU3brlnyUhqjgmi2jPNEDTmLyo
	oU8E4e8xdFu4VGAcJDqAsQHidAGEa1J334svVzB0/T8gbie8sEMxy6dWy0FxRtOdFN7PrxYFzay
	Us7QHPqmXWL402pnIZeVdEYSNq+Fql00Blujz2VGBWTKXOSsDpmpev3bGP7LRsa9yFCFZLNq+rp
	bIj67OdKV8oPcXRK/i95T3Y4PA8fk+8+IuftxCIKY6qp2zMH92bZmMk9GCHxuwXG1suUDt0pUhG
	6fpotdjoyT2aQLPQo/2xNaRU/4Apaq2I6FgqpgGmyLXiWGk5HGPJAxRLDOZBDP5ahKimS3P4SGQ
	QAzCDI/rxcrtyVvQcRXermOTZRJEk5fjkb8Z26XOi710x9RfwIk74Q+Z2Bso75qo/sDzW/beE7r
	5hePJq3
X-Received: by 2002:a05:6808:3992:b0:46e:df55:23fa with SMTP id 5614622812f47-482e562d225mr8979603b6e.17.1779110894636;
        Mon, 18 May 2026 06:28:14 -0700 (PDT)
Received: from [192.168.1.102] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id 5614622812f47-482ee38c9aesm4861520b6e.8.2026.05.18.06.28.13
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 18 May 2026 06:28:13 -0700 (PDT)
Message-ID: <77993be8-8170-4666-8531-1c46f49907ed@kernel.dk>
Date: Mon, 18 May 2026 07:28:12 -0600
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.12 130/144] io_uring/kbuf: support min length left for
 incremental buffers
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>,
 stable@vger.kernel.org, patches@lists.linux.dev,
 Martin Michaelis <code@mgjm.de>, Gabriel Krisman Bertazi <krisman@suse.de>,
 Vegard Nossum <vegard.nossum@oracle.com>
References: <20260515154653.469907118@linuxfoundation.org>
 <20260515154656.529062291@linuxfoundation.org>
 <876ac528-b2db-4d52-afff-2a44f13a6767@oracle.com>
 <bc8ede5a-ab28-4191-9153-7e66c28916ac@kernel.dk>
 <2026051801-trifocals-gummy-2be3@gregkh>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <2026051801-trifocals-gummy-2be3@gregkh>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 5/18/26 6:16 AM, Greg Kroah-Hartman wrote:
> On Sun, May 17, 2026 at 07:02:25PM -0600, Jens Axboe wrote:
>> On 5/17/26 12:39 PM, Harshit Mogalapalli wrote:
>>> Hi Greg and Jens,
>>>
>>> On 15/05/26 21:19, Greg Kroah-Hartman wrote:
>>>> 6.12-stable review patch.  If anyone has any objections, please let me know.
>>>>
>>>> ------------------
>>>>
>>>> From: Martin Michaelis <code@mgjm.de>
>>>>
>>>> commit 7deba791ad495ce1d7921683f4f7d1190fa210d1 upstream.
>>>>
>>>> Incrementally consumed buffer rings are generally fully consumed, but
>>>> it's quite possible that the application has a minimum size it needs to
>>>> meet to avoid truncation. Currently that minimum limit is 1 byte, but
>>>> this should be a setting that is the hands of the application. For
>>>> recvmsg multishot, a prime use case for incrementally consumed buffers,
>>>> the application may get spurious -EFAULT returned at the end of an
>>>> incrementally consumed buffer, as less space is available than the
>>>> headers need.
>>>>
>>>> Grab a u32 field in struct io_uring_buf_reg, which the application can
>>>> use to inform the kernel of the minimum size that should be available
>>>> in an incrementally consumed buffer. If less than that is available,
>>>> the current buffer is fully processed and the next one will be picked.
>>>>
>>>> Cc: stable@vger.kernel.org
>>>> Fixes: ae98dbf43d75 ("io_uring/kbuf: add support for incremental buffer consumption")
>>>> Link: https://github.com/axboe/liburing/issues/1433
>>>> Signed-off-by: Martin Michaelis <code@mgjm.de>
>>>> [axboe: write commit message, change io_buffer_list member name]
>>>> Reviewed-by: Gabriel Krisman Bertazi <krisman@suse.de>
>>>> Signed-off-by: Jens Axboe <axboe@kernel.dk>
>>>> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
>>>> ---
>>>>   include/uapi/linux/io_uring.h |    3 ++-
>>>>   io_uring/kbuf.c               |    8 +++++++-
>>>>   io_uring/kbuf.h               |    7 +++++++
>>>>   3 files changed, 16 insertions(+), 2 deletions(-)
>>>>
>>>> --- a/include/uapi/linux/io_uring.h
>>>> +++ b/include/uapi/linux/io_uring.h
>>>> @@ -758,7 +758,8 @@ struct io_uring_buf_reg {
>>>>       __u32    ring_entries;
>>>>       __u16    bgid;
>>>>       __u16    flags;
>>>> -    __u64    resv[3];
>>>> +    __u32    min_left;
>>>> +    __u32    resv[5];
>>>>   };
>>>
>>> ^^^ let us remember this. More comments below
>>>>     /* argument for IORING_REGISTER_PBUF_STATUS */
>>>> --- a/io_uring/kbuf.c
>>>> +++ b/io_uring/kbuf.c
>>>> @@ -47,7 +47,7 @@ static bool io_kbuf_inc_commit(struct io
>>>>           this_len = min_t(u32, len, buf_len);
>>>>           buf_len -= this_len;
>>>>           /* Stop looping for invalid buffer length of 0 */
>>>> -        if (buf_len || !this_len) {
>>>> +        if (buf_len > bl->min_left_sub_one || !this_len) {
>>>>               WRITE_ONCE(buf->addr, READ_ONCE(buf->addr) + this_len);
>>>>               WRITE_ONCE(buf->len, buf_len);
>>>>               return false;
>>>> @@ -727,6 +727,10 @@ int io_register_pbuf_ring(struct io_ring
>>>>       if (reg.ring_entries >= 65536)
>>>>           return -EINVAL;
>>>>   +    /* minimum left byte count is a property of incremental buffers */
>>>> +    if (!(reg.flags & IOU_PBUF_RING_INC) && reg.min_left)
>>>> +        return -EINVAL;
>>>> +
>>>>       bl = io_buffer_get_list(ctx, reg.bgid);
>>>>       if (bl) {
>>>>           /* if mapped buffer ring OR classic exists, don't allow */
>>>> @@ -747,6 +751,8 @@ int io_register_pbuf_ring(struct io_ring
>>>>       if (!ret) {
>>>>           bl->nr_entries = reg.ring_entries;
>>>>           bl->mask = reg.ring_entries - 1;
>>>> +        if (reg.min_left)
>>>> +            bl->min_left_sub_one = reg.min_left - 1;
>>>>           if (reg.flags & IOU_PBUF_RING_INC)
>>>>               bl->flags |= IOBL_INC;
>>>
>>>
>>> I have run an AI assisted backport review and it spotted an issue: I
>>> have taken a look and the issues goes like:
>>>
>>> Backport updates struct io_uring_buf_reg to min_left + resv[5] but
>>> keeps legacy validation that only checks reg.resv[0..2], so resv[3]
>>> and resv[4] are silently accepted.
>>>
>>> Upstream has something like this:
>>>
>>> if (copy_from_user(&reg, arg, sizeof(reg)))
>>>     return -EFAULT;
>>> if (!mem_is_zero(reg.resv, sizeof(reg.resv)))
>>>     return -EINVAL;
>>> if (reg.flags & ~(IOU_PBUF_RING_MMAP | IOU_PBUF_RING_INC))
>>>     return -EINVAL;
>>>
>>> 6.12.y still has:
>>>
>>> if (copy_from_user(&reg, arg, sizeof(reg)))
>>>     return -EFAULT;
>>>
>>> if (reg.resv[0] || reg.resv[1] || reg.resv[2])
>>>     return -EINVAL;
>>> if (reg.flags & ~(IOU_PBUF_RING_MMAP | IOU_PBUF_RING_INC))
>>>     return -EINVAL;
>>>
>>> So we are not checking resv[3], resv[4],
>>>
>>> This commit is needed commit: 172484907285 ("io_uring/kbuf: use
>>> mem_is_zero()") to fix this. It is a clean cherry-pick, so I think the
>>> best thing is to take it for next cycle. this commit is present in
>>> 6.16-rc1+ so newer long-term stable kernel releases than 6.12.y don't
>>> have this problem.
>>>
>>>
>>> Jens, please correct me if the above understanding looks wrong.
>>
>> Nope you are right. It's not an actual issue, it's just future proofing
>> checking. So it's quite fine to just add that commit for the next stable
>> release. I'll check the others too, as the mem_is_zero() commit landed
>> in 6.16.
> 
> Thanks, now queued up.

Thanks Greg!

-- 
Jens Axboe

