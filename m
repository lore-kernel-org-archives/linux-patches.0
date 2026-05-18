Received: from mail-oo1-f48.google.com (mail-oo1-f48.google.com [209.85.161.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B8E2917DFE7
	for <patches@lists.linux.dev>; Mon, 18 May 2026 01:02:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779066151; cv=none; b=ZZQRZK+MpRXaoXP6ULNVEScJKobPtFEVYfMuDyOBbp46vXVAZSEJnOiwippDhpwKolR5w58zOTOhoT+ZI5i0lfQeCdCqstg+VYLCrLJGvIYlIfYQhu8r3140t5ZjzNY9FGfJuPfR1wHEG+QQT+OX8BUTFGEFst1HBuUbgvbWWU8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779066151; c=relaxed/simple;
	bh=ppDo6lY4EgDm1UvbFn26ys4DZhwkX2RjDb9QoQbtrRM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=H7oZq2Jj8CWkfFAyyP+s+DmE5CY2GQJc8fGt9uG+y5Bv1jzjUL5hW8sLkcr4rswbL63tDNaqwEC1OAC+ZCBggK0fj5HxKoniSMk/kKpy1CXnAOv5zcTRqHhLTHJFM02PCn3F9+w4gxJMlgJfqotu24VsoTcTKhkAleFhsXv9AUg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20251104.gappssmtp.com header.i=@kernel-dk.20251104.gappssmtp.com header.b=a3BczUPB; arc=none smtp.client-ip=209.85.161.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20251104.gappssmtp.com header.i=@kernel-dk.20251104.gappssmtp.com header.b="a3BczUPB"
Received: by mail-oo1-f48.google.com with SMTP id 006d021491bc7-6969c864c89so891696eaf.2
        for <patches@lists.linux.dev>; Sun, 17 May 2026 18:02:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20251104.gappssmtp.com; s=20251104; t=1779066147; x=1779670947; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=eAyxR58Fwui0t3p4KL1oNmRW0W2CBG5utIFQCEI3LBE=;
        b=a3BczUPB3+sBqNbadBgMVHesYpOj0dW3IpdxfJSC3K/jJPi9GOp4N4T46QTgCD/qci
         0FGwIgSuRV5lS3H/Yrj6qaTMKIbIvevvlho4k5Vn2NMCjEsI620BLFxGD7YF5zVbN4b6
         Bw9hmLzMDIgRItcWcPGHp66Btw7rQvFu+4P6iew8qn6BkqVVEr44aV7btTRz+SDVctZR
         tdHhRbiooisNZbZC9y+bc/F2PRZl2QmSA9qJO+tY8bmSPGqE5kzpROS04QvxR+SnfRn1
         rB7qDY3Cov6rrOUIahhaRzWA6959T5uNxmaS7G5ccBb/m2XyDv4dNAV+Sqy2SmmTnKbH
         RqMQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779066147; x=1779670947;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=eAyxR58Fwui0t3p4KL1oNmRW0W2CBG5utIFQCEI3LBE=;
        b=ZpRi43TBLDXXTwf8fRvoRXFkuUV1ATstODflmZJrG3yKTw6M5ARqMhhBKVWBnOPoPL
         aIQxdPkwTkZLdVJ1HJioCbx45c1s6hK7sdwT/rjLuDZ1OGK+RhaXzeRS4gICdog9uZ4Z
         o0HCrnbrlVWhDhq1uGl8ewOEoYRGgWT59c4HYmUSSJubU+7x39Lx1DOJxdXpXok4hIZo
         W6mjwqSOAiHGr+DgZ13I+1qQ2kuY5uLI3T6bpGqHa3r6sgsgsXL4mKgXY+62FdGAAMzJ
         jU4BFMvKJQ6ologPEPwCmhtAqrKQ8plfQanQyoRB2KF2Wm+ztunzUepdVelSPg1pWr6W
         Un7A==
X-Gm-Message-State: AOJu0Yzu/58tfhhq+0wqboasysNnCAtUNyKiReHbwjxFKMWQdUr8VE6n
	HldK5FmpqDoKpAzESO9VLWS4gqmssP8wUtcY1w8wSwsPQWK/QB6Dzx6MtR/KjAGDMS8=
X-Gm-Gg: Acq92OFLRrXS7MLINfmmfnNBfn+0IjXwUGxX3S7r3R+Z4RHwwXphjJE6vwBgxiEmf6o
	QoaoOPXhMPAiBxg370m2PWkJ+tncBfFMB53LJ07n6TF8N/ZWPcnnxP7XxfxdJxyTyAbv3b2jgKG
	ZrOAWeaxrX5DUZaQ7rG/+I4b/vuGMqlue4/yAWkAPuWe8DDWRdjpgFCvJf6z5dw1uKImqPcDCpW
	N6ktgjQFMMMI85oaO7iG4xAvsFfgrjltQ2NO1RsLqzlDg9fns91Ls6f3zatlm8MDYu5j9ZXI5Fm
	glkpgZGjAEqFQFJzMiJ2v5dhLmyrFJYTfc+5FhwY6Xajt3ZCVKllC2ZugqHgy5y5lmGDaUZP5JE
	UXwyga4sFNwoXT2jXEFjPYVbPc3VDmshBf6+cJjUUeylNFNWujElJahU9JX/HrOzE4BHQN8JHbB
	ALV95Fr7aHBISgs7ndgNsKSRrns6vvrk7JYdy2sPLL4OPUP+Odd5AKo/NdNT99CAiPBsdsN9Owu
	ylpTFf5/g==
X-Received: by 2002:a05:6820:1807:b0:696:757d:1942 with SMTP id 006d021491bc7-69c9436a31fmr7784772eaf.32.1779066147281;
        Sun, 17 May 2026 18:02:27 -0700 (PDT)
Received: from [192.168.1.150] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id 586e51a60fabf-43a94f49e25sm3012258fac.2.2026.05.17.18.02.25
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 17 May 2026 18:02:26 -0700 (PDT)
Message-ID: <bc8ede5a-ab28-4191-9153-7e66c28916ac@kernel.dk>
Date: Sun, 17 May 2026 19:02:25 -0600
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.12 130/144] io_uring/kbuf: support min length left for
 incremental buffers
To: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>,
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, Martin Michaelis <code@mgjm.de>,
 Gabriel Krisman Bertazi <krisman@suse.de>,
 Vegard Nossum <vegard.nossum@oracle.com>
References: <20260515154653.469907118@linuxfoundation.org>
 <20260515154656.529062291@linuxfoundation.org>
 <876ac528-b2db-4d52-afff-2a44f13a6767@oracle.com>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <876ac528-b2db-4d52-afff-2a44f13a6767@oracle.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 5/17/26 12:39 PM, Harshit Mogalapalli wrote:
> Hi Greg and Jens,
> 
> On 15/05/26 21:19, Greg Kroah-Hartman wrote:
>> 6.12-stable review patch.  If anyone has any objections, please let me know.
>>
>> ------------------
>>
>> From: Martin Michaelis <code@mgjm.de>
>>
>> commit 7deba791ad495ce1d7921683f4f7d1190fa210d1 upstream.
>>
>> Incrementally consumed buffer rings are generally fully consumed, but
>> it's quite possible that the application has a minimum size it needs to
>> meet to avoid truncation. Currently that minimum limit is 1 byte, but
>> this should be a setting that is the hands of the application. For
>> recvmsg multishot, a prime use case for incrementally consumed buffers,
>> the application may get spurious -EFAULT returned at the end of an
>> incrementally consumed buffer, as less space is available than the
>> headers need.
>>
>> Grab a u32 field in struct io_uring_buf_reg, which the application can
>> use to inform the kernel of the minimum size that should be available
>> in an incrementally consumed buffer. If less than that is available,
>> the current buffer is fully processed and the next one will be picked.
>>
>> Cc: stable@vger.kernel.org
>> Fixes: ae98dbf43d75 ("io_uring/kbuf: add support for incremental buffer consumption")
>> Link: https://github.com/axboe/liburing/issues/1433
>> Signed-off-by: Martin Michaelis <code@mgjm.de>
>> [axboe: write commit message, change io_buffer_list member name]
>> Reviewed-by: Gabriel Krisman Bertazi <krisman@suse.de>
>> Signed-off-by: Jens Axboe <axboe@kernel.dk>
>> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
>> ---
>>   include/uapi/linux/io_uring.h |    3 ++-
>>   io_uring/kbuf.c               |    8 +++++++-
>>   io_uring/kbuf.h               |    7 +++++++
>>   3 files changed, 16 insertions(+), 2 deletions(-)
>>
>> --- a/include/uapi/linux/io_uring.h
>> +++ b/include/uapi/linux/io_uring.h
>> @@ -758,7 +758,8 @@ struct io_uring_buf_reg {
>>       __u32    ring_entries;
>>       __u16    bgid;
>>       __u16    flags;
>> -    __u64    resv[3];
>> +    __u32    min_left;
>> +    __u32    resv[5];
>>   };
> 
> ^^^ let us remember this. More comments below
>>     /* argument for IORING_REGISTER_PBUF_STATUS */
>> --- a/io_uring/kbuf.c
>> +++ b/io_uring/kbuf.c
>> @@ -47,7 +47,7 @@ static bool io_kbuf_inc_commit(struct io
>>           this_len = min_t(u32, len, buf_len);
>>           buf_len -= this_len;
>>           /* Stop looping for invalid buffer length of 0 */
>> -        if (buf_len || !this_len) {
>> +        if (buf_len > bl->min_left_sub_one || !this_len) {
>>               WRITE_ONCE(buf->addr, READ_ONCE(buf->addr) + this_len);
>>               WRITE_ONCE(buf->len, buf_len);
>>               return false;
>> @@ -727,6 +727,10 @@ int io_register_pbuf_ring(struct io_ring
>>       if (reg.ring_entries >= 65536)
>>           return -EINVAL;
>>   +    /* minimum left byte count is a property of incremental buffers */
>> +    if (!(reg.flags & IOU_PBUF_RING_INC) && reg.min_left)
>> +        return -EINVAL;
>> +
>>       bl = io_buffer_get_list(ctx, reg.bgid);
>>       if (bl) {
>>           /* if mapped buffer ring OR classic exists, don't allow */
>> @@ -747,6 +751,8 @@ int io_register_pbuf_ring(struct io_ring
>>       if (!ret) {
>>           bl->nr_entries = reg.ring_entries;
>>           bl->mask = reg.ring_entries - 1;
>> +        if (reg.min_left)
>> +            bl->min_left_sub_one = reg.min_left - 1;
>>           if (reg.flags & IOU_PBUF_RING_INC)
>>               bl->flags |= IOBL_INC;
> 
> 
> I have run an AI assisted backport review and it spotted an issue: I
> have taken a look and the issues goes like:
> 
> Backport updates struct io_uring_buf_reg to min_left + resv[5] but
> keeps legacy validation that only checks reg.resv[0..2], so resv[3]
> and resv[4] are silently accepted.
> 
> Upstream has something like this:
> 
> if (copy_from_user(&reg, arg, sizeof(reg)))
>     return -EFAULT;
> if (!mem_is_zero(reg.resv, sizeof(reg.resv)))
>     return -EINVAL;
> if (reg.flags & ~(IOU_PBUF_RING_MMAP | IOU_PBUF_RING_INC))
>     return -EINVAL;
> 
> 6.12.y still has:
> 
> if (copy_from_user(&reg, arg, sizeof(reg)))
>     return -EFAULT;
> 
> if (reg.resv[0] || reg.resv[1] || reg.resv[2])
>     return -EINVAL;
> if (reg.flags & ~(IOU_PBUF_RING_MMAP | IOU_PBUF_RING_INC))
>     return -EINVAL;
> 
> So we are not checking resv[3], resv[4],
> 
> This commit is needed commit: 172484907285 ("io_uring/kbuf: use
> mem_is_zero()") to fix this. It is a clean cherry-pick, so I think the
> best thing is to take it for next cycle. this commit is present in
> 6.16-rc1+ so newer long-term stable kernel releases than 6.12.y don't
> have this problem.
> 
> 
> Jens, please correct me if the above understanding looks wrong.

Nope you are right. It's not an actual issue, it's just future proofing
checking. So it's quite fine to just add that commit for the next stable
release. I'll check the others too, as the mem_is_zero() commit landed
in 6.16.

-- 
Jens Axboe
