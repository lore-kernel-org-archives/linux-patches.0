Received: from mail-oi1-f174.google.com (mail-oi1-f174.google.com [209.85.167.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C78FE3A5E76
	for <patches@lists.linux.dev>; Tue, 21 Apr 2026 22:18:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776809936; cv=none; b=vEvmqBrcRPlyrcEaPs5CG+PxrJG8upLGUU/hel61A0IBGirmMJDkXsqUIzocgA1fU3KSIGhiFQIO4zt+k9hFZZQlTITYq0+0xFYoteCUl+ESdosCHYfEFV6eBeLnl1LVhjbcZat5GGAXPqA70WVYTBvtZ75JoV9ojXl63CZwmAE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776809936; c=relaxed/simple;
	bh=YxaDhucYJqR+pLsF3cmCQy1mP20FRBqBNvoFdl7AKRY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=IH7YSCP6eN45IQUpxHrmBos91hbd1hyYMKW//vmvRFqVAWCf3WpZ7PFEXU2bZyhjtRIubETQX0OYYVzJaL9SoSw2LBPVpQPPwTXLyvQ6H2iepF2R+TnzwaVaQuqRnKtepRMu83P7GA7FHloOmE2sznnZgDKtZ7XSUT29EzW4CgU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20251104.gappssmtp.com header.i=@kernel-dk.20251104.gappssmtp.com header.b=n4X3BICI; arc=none smtp.client-ip=209.85.167.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20251104.gappssmtp.com header.i=@kernel-dk.20251104.gappssmtp.com header.b="n4X3BICI"
Received: by mail-oi1-f174.google.com with SMTP id 5614622812f47-479e6bc357eso858779b6e.2
        for <patches@lists.linux.dev>; Tue, 21 Apr 2026 15:18:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20251104.gappssmtp.com; s=20251104; t=1776809930; x=1777414730; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=B3VPUbIOBm8jC+mr0MXSF2GSTvOeKJwM6inCehb0UtI=;
        b=n4X3BICIRwFBg34ti+qZJwA/j0pCv7MemHl0m9ekQK6wlDHueGOzSEI96gQLPCWRzu
         jm3zS43rS5vjDFhYeVoucRvJrFbCYkTqK69vMrAa6PYgHIJuzVXyrxZWzFKW3eRpyZaS
         z+ecdW4/a3FmvghTc9jqgfF12bHjpJKQI+fgK0rwZ8/l05Ii4JiDxgzIClCWjFbwOMfI
         sXVq6tY5x7DiO9fstfO97n/kQ80PhTbOulAcgu9QCPquyabc+9+YDGvRI/Cte608JA+I
         P3ZOZHd4lfYoMn7ShCuZ6MXgszS/oXrkA3P0DZzyh+Zjdr3IhF6LBqMh+zGD5OSMcaAZ
         36Ug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776809930; x=1777414730;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=B3VPUbIOBm8jC+mr0MXSF2GSTvOeKJwM6inCehb0UtI=;
        b=qj2z/5KHXOUSD2BnuIMB2N2uvDBrG6HY4ONqPjglHYL5VLuDGRGY9VJxeEqkzmn+ZX
         8BjCw7h4g+IG5GP6coO+tTCLhs2sgZ0LCXhoRIg1jdO7Vrbpix6pQrLn1taiDwKt+eEY
         r+TrKqvUuVBeM+Hf0sMfxuqAcOWEQykZcKjHaKnE4fKTVMIMwt3fNEGfYvzeOOH2dySG
         YOsgM570S5lE1bXFw/hO8nViNjAW07bjdbDuPMcIsT1uBK2Ptu5mBabLBHopAyIxFTxt
         thLh78RfAlbKljupDAJ31BdHPOxxXGSd6cYtic4wmOz5cZX2mcOXIF3Z/IuJeomP4ElJ
         0KzA==
X-Gm-Message-State: AOJu0Yw3DMYZykP/heNe1UfyNZ7hCVGO2itIUIqp43ZQvywWGIbV5hRI
	BUnTNbUruvWDbJ4Dy81hP6kTey5bxrOo7tH5rFZLbowHD5VEhfZMp6xnlj61m5MP3So=
X-Gm-Gg: AeBDievqUUIrQvjfiaQUATaUwcC5RmcP3XiHNWDzFrZBlcxDbMTY5+i7PlJtTy7PbjG
	I26cgWP6I9hlSSLV6ToG+R5BJ3DQi7QVI9agumdEcknijkqTSixWBkK4I7qpu+OWzSlFHuETMX6
	zCUs3mf58jnr+gq3brxUmA8hUh+Oh7Y4EssuEIdssdyfFZkJ1FEnl/qg0M9FhaRlE5V3636EG/5
	EJ4Z5IhU6Hzg+Cz0D5hyhOwnTzdZgwvGcvobmy1QZPXPtnp846xpmvhYJD7gUY6kcA1R60EG4y+
	+BR8DSwgz55/lpl1xB78eU3BOmODkwc689cAMCvOlz8wuThRWouoKu/AmQd8tUUcEWLMYE5cixZ
	aty0M7UN1QtPxCK1H/Q9jeHvYoFSyJw12y8qC30L16uyWTZeeE05PPyvEiFOlG1aMeJlb7AwOfj
	j5/de1O2ieenzoLPe+D4auya6cubwNnpNT6B8N7ZVy0Z6moKdSO3PObF4ts0h+n60L/NC/4Pnfv
	RH9HlG+Y64SMY0Gt1FQ
X-Received: by 2002:a05:6808:1a03:b0:466:ff3a:c745 with SMTP id 5614622812f47-4799c8d25famr10432101b6e.21.1776809930454;
        Tue, 21 Apr 2026 15:18:50 -0700 (PDT)
Received: from [192.168.1.150] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id 5614622812f47-4799fc19273sm9795783b6e.0.2026.04.21.15.18.49
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 21 Apr 2026 15:18:49 -0700 (PDT)
Message-ID: <d7d521e7-35bb-463b-b1f5-552bb931bdff@kernel.dk>
Date: Tue, 21 Apr 2026 16:18:49 -0600
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 5.10 491/491] io_uring/poll: correctly handle
 io_poll_add() return value on update
To: Ben Hutchings <ben@decadent.org.uk>,
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev,
 syzbot+641eec6b7af1f62f2b99@syzkaller.appspotmail.com
References: <20260413155819.042779211@linuxfoundation.org>
 <20260413155837.438151458@linuxfoundation.org>
 <d4b85e905345dc69e9c660c7f51775703fa83320.camel@decadent.org.uk>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <d4b85e905345dc69e9c660c7f51775703fa83320.camel@decadent.org.uk>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 4/19/26 9:45 AM, Ben Hutchings wrote:
> On Mon, 2026-04-13 at 18:02 +0200, Greg Kroah-Hartman wrote:
>> 5.10-stable review patch.  If anyone has any objections, please let me know.
>>
>> ------------------
>>
>> From: Jens Axboe <axboe@kernel.dk>
>>
>> Commit 84230ad2d2afbf0c44c32967e525c0ad92e26b4e upstream.
>>
>> When the core of io_uring was updated to handle completions
>> consistently and with fixed return codes, the POLL_REMOVE opcode
>> with updates got slightly broken. If a POLL_ADD is pending and
>> then POLL_REMOVE is used to update the events of that request, if that
>> update causes the POLL_ADD to now trigger, then that completion is lost
>> and a CQE is never posted.
>>
>> Additionally, ensure that if an update does cause an existing POLL_ADD
>> to complete, that the completion value isn't always overwritten with
>> -ECANCELED. For that case, whatever io_poll_add() set the value to
>> should just be retained.
> 
> This backport is very different from the upstream version, and I have
> some questions about that (inline below).

It is, was quite painful.

>> Cc: stable@vger.kernel.org
>> Fixes: 97b388d70b53 ("io_uring: handle completions in the core")
>> Reported-by: syzbot+641eec6b7af1f62f2b99@syzkaller.appspotmail.com
>> Tested-by: syzbot+641eec6b7af1f62f2b99@syzkaller.appspotmail.com
>> Signed-off-by: Jens Axboe <axboe@kernel.dk>
>> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
>> ---
>>  io_uring/io_uring.c |   26 +++++++++++++++++++-------
>>  1 file changed, 19 insertions(+), 7 deletions(-)
>>
>> --- a/io_uring/io_uring.c
>> +++ b/io_uring/io_uring.c
>> @@ -5980,7 +5980,7 @@ static int io_poll_add_prep(struct io_ki
>>  	return 0;
>>  }
>>  
>> -static int io_poll_add(struct io_kiocb *req, unsigned int issue_flags)
>> +static int __io_poll_add(struct io_kiocb *req, unsigned int issue_flags)
>>  {
>>  	struct io_poll_iocb *poll = &req->poll;
>>  	struct io_poll_table ipt;
>> @@ -5992,11 +5992,21 @@ static int io_poll_add(struct io_kiocb *
>>  	if (!ret && ipt.error)
>>  		req_set_fail(req);
>>  	ret = ret ?: ipt.error;
>> -	if (ret)
>> +	if (ret > 0) {
>>  		__io_req_complete(req, issue_flags, ret, 0);
>> +		return ret;
>> +	}
>>  	return 0;
>>  }
>>  
>> +static int io_poll_add(struct io_kiocb *req, unsigned int issue_flags)
>> +{
>> +	int ret;
>> +
>> +	ret = __io_poll_add(req, issue_flags);
>> +	return ret < 0 ? ret : 0;
> 
> __io_poll_add() still never returns a negative result, so why is there a
> check for that here?
> 
>> +}
>> +
>>  static int io_poll_update(struct io_kiocb *req, unsigned int issue_flags)
>>  {
>>  	struct io_ring_ctx *ctx = req->ctx;
>> @@ -6012,6 +6022,7 @@ static int io_poll_update(struct io_kioc
>>  		ret = preq ? -EALREADY : -ENOENT;
>>  		goto out;
>>  	}
>> +	preq->result = -ECANCELED;
>>  	spin_unlock(&ctx->completion_lock);
>>  
>>  	if (req->poll_update.update_events || req->poll_update.update_user_data) {
>> @@ -6024,16 +6035,17 @@ static int io_poll_update(struct io_kioc
>>  		if (req->poll_update.update_user_data)
>>  			preq->user_data = req->poll_update.new_user_data;
>>  
>> -		ret2 = io_poll_add(preq, issue_flags);
>> +		ret2 = __io_poll_add(preq, issue_flags);
>>  		/* successfully updated, don't complete poll request */
>>  		if (!ret2)
>>  			goto out;
>> +		preq->result = ret2;
>> +
>>  	}
>> -	req_set_fail(preq);
>> -	io_req_complete(preq, -ECANCELED);
>> +	if (preq->result < 0)
>> +		req_set_fail(preq);
>> +	io_req_complete(preq, preq->result);
> 
> If __io_poll_add() returned an events mask then it completed preq, but
> then we also complete preq here.  Is that really correct?

Let me take a closer look, I do agree with you that the final result
does not look entirely correct.

-- 
Jens Axboe
