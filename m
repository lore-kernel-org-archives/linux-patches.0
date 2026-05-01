Received: from mail-oi1-f181.google.com (mail-oi1-f181.google.com [209.85.167.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DEE55329C54
	for <patches@lists.linux.dev>; Fri,  1 May 2026 22:07:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777673276; cv=none; b=rDskviTb3VH5COjQMckyjzzSaXDmkCuP6WWpRpPDEXUAdB6u6F1IQWuEzvotLV3vsDBS5PyuWB6PIlU2ajRhnEc/njYQggzkUgmsRWDP5Zi3ih1mrbDEvj/ZRVrkO11a25/UYuNth98mencRSVyTO7PyOM5EI7M3avSzW4r8Ppc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777673276; c=relaxed/simple;
	bh=xS5gDR7pcU0pT6VL9LZrzj3cYVFPxoupzfxgBNsa1/g=;
	h=Content-Type:Message-ID:Date:MIME-Version:Subject:To:Cc:
	 References:From:In-Reply-To; b=sdL2RHR1tqlSeaMy0u56twPAotSDU7zgLS5rkWLVfTFnv4I7mdzDS45WmSx27orXNh4wacnzZogWOVrhjVRK/5v5wrRdDcCOfhgTc91fxuBgCf+dr0GjsBerCq0bn5BA/SMyCMe2jyZwMyBcPyS5PJqiHTezzBqPZQn8jOqpj/o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20251104.gappssmtp.com header.i=@kernel-dk.20251104.gappssmtp.com header.b=C8WWfZb2; arc=none smtp.client-ip=209.85.167.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20251104.gappssmtp.com header.i=@kernel-dk.20251104.gappssmtp.com header.b="C8WWfZb2"
Received: by mail-oi1-f181.google.com with SMTP id 5614622812f47-479f7e75a6bso1058593b6e.2
        for <patches@lists.linux.dev>; Fri, 01 May 2026 15:07:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20251104.gappssmtp.com; s=20251104; t=1777673273; x=1778278073; darn=lists.linux.dev;
        h=in-reply-to:from:content-language:references:cc:to:subject
         :user-agent:mime-version:date:message-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=KTBJI5sNzjAKNKqgiLLQMozhodV6qu5Rb8tmUHBewUA=;
        b=C8WWfZb2kEUbEqiH1X0xUaE4JWKw9YYKn1QRH7//xCxgm0KYr1LSwVdptg8ilBMha3
         fNH0zg2aE0QEJl0M9UezmcDgXWPtX1q/Ug+joPDvAEDhKD5mbh4nBVZLFJhOe32fwL6/
         0oHUqmH6SK+GQ1ScX66ltI8sUgriOmH6sIeMHFnToSWIdlo90GVbSIEMmcctFvirATU7
         SWvBuJU7JX93QfnQjLT3TQA7R/ML8FAz9v0RkUsG0OSc2w2Wxa2uGvpUutW5nouG75uQ
         mVwlZn8/9HbDtr64Mm5Wx9ROPRKVh3A0sfhVWoyilrnFHdS/zzkEORQ7vVb42aht4oRm
         0NFw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777673273; x=1778278073;
        h=in-reply-to:from:content-language:references:cc:to:subject
         :user-agent:mime-version:date:message-id:x-gm-gg:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=KTBJI5sNzjAKNKqgiLLQMozhodV6qu5Rb8tmUHBewUA=;
        b=ngVJO1LVmH1k3t+XcBmDL/mGh8VVulUhBXKy6WOdj3FI+ldKWg9olSjyGkNUBSxOnp
         cDaxJ3XHDtxCH8Rbog2aE9EB5B1scDHDKYtWSB6EtuUqtN3ilZQZZJfNvzJDYs4zm5lD
         wd82SnS2pszL7dWM120CZ8qgRTKFKfgEunsbFC2Z77lGlqeSeU3R8QjUMc9WnR/uEmSh
         1JkLuQBtwdZgz+i2GsY0UCGnh5l0PpQJGktECFLLVPWbDbQe1GaSaKatuG53UFlN94st
         L/M8kPVkvqEQ2tnAksN3NqOACLiePKB3iJnlj8jw0jpcC/H/JEz3WFvKwK4gQoCmPYaf
         bDqw==
X-Forwarded-Encrypted: i=1; AFNElJ+4uBpdGfClJcVXLEUzS1mlLtjPB9PYP3kBUY1Z+JAZG14gwBPNnV98MjKY7Tr/pm3bIkegfDe3@lists.linux.dev
X-Gm-Message-State: AOJu0Yx81wAAlf17VNgi32+HcOxawKVG2swT5LzVgaqJBeoCvN0fLleV
	Sl9rbaTnkd78E8cZNzJERNZP0/1b6e8TEd/izy5MAYK99eTBTjEHhnTGDlCtjWxhR8A=
X-Gm-Gg: AeBDieugmUpxrvyY3q4S2aFdd0EYycIviLiZxVil5IWIs/6Dv38AhdpC8RT7r9yCRNy
	Ux+YQHwDlesNxzvrm8H5VW099prXYOm/hxAL4EsTZ6gx0+bT3P3Nd9pcpColkJDtM7Mwr6tsAfu
	2uXN+wz+4dKu0+I6Gne5fNaCpp4EqAJeXhvhLKHrBQ63sAAgVgQqHYo7dHWB5ZJLcWwFYhiPWy5
	95ne9h/Xe1Fr2Vri+lGUho1Zc8d6KjSJhXnoxe44pZlyYRTRYyIEw0hnyYhteEiOdWrBTPhWpqM
	dHW77TjRiCaVxa/ISy+paB4D4BAeHHhoZd5GmQAPmk31Py0YerrzN3VgQA+nwj0cX7n5m9d9xdb
	57Ijp7lC47GnrC10LGQ+OTGIR/PpEA/2EUVecYD9yq04RtcV692CgUIVj7u38QawGApLzI4wNqC
	llr9+ORoEHOEeRehmkTO+FAWJt9IbcQBSnmkd7GQK4tMf+vlD0Pb0edxHD+v3R5mqEV7EvsK+bN
	pONiW1to17m2bSrxJUb
X-Received: by 2002:a05:6808:1929:b0:467:2652:b29d with SMTP id 5614622812f47-47c88e893c8mr743079b6e.8.1777673272696;
        Fri, 01 May 2026 15:07:52 -0700 (PDT)
Received: from [192.168.1.150] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id 5614622812f47-47c76986f9dsm2079143b6e.16.2026.05.01.15.07.48
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 01 May 2026 15:07:50 -0700 (PDT)
Content-Type: multipart/mixed; boundary="------------A8p0UoQPpNU5B0IW0tmvoTwX"
Message-ID: <fb26a75a-cb2c-4ee6-92b9-4c488a2c7ba5@kernel.dk>
Date: Fri, 1 May 2026 16:07:48 -0600
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 5.10 491/491] io_uring/poll: correctly handle
 io_poll_add() return value on update
To: Fedor Pchelkin <pchelkin@ispras.ru>
Cc: Ben Hutchings <ben@decadent.org.uk>,
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
 patches@lists.linux.dev,
 syzbot+641eec6b7af1f62f2b99@syzkaller.appspotmail.com,
 lvc-project@linuxtesting.org
References: <20260501111233-b371eac52cd006bfddfbd9e5-pchelkin@ispras>
 <58103791-4c19-441c-9d4f-7ae5f9c6151a@kernel.dk>
 <20260502003658-e04f382bc8ed201a99b573e0-pchelkin@ispras>
 <20260502005417-671675fb5906578c85c3fb4f-pchelkin@ispras>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <20260502005417-671675fb5906578c85c3fb4f-pchelkin@ispras>

This is a multi-part message in MIME format.
--------------A8p0UoQPpNU5B0IW0tmvoTwX
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 5/1/26 3:55 PM, Fedor Pchelkin wrote:
> On Sat, 02. May 00:50, Fedor Pchelkin wrote:
>> On Fri, 01. May 15:33, Jens Axboe wrote:
>>>>> @@ -6024,16 +6035,17 @@ static int io_poll_update(struct io_kioc
>>>>>  		if (req->poll_update.update_user_data)
>>>>>  			preq->user_data = req->poll_update.new_user_data;
>>>>>  
>>>>> -		ret2 = io_poll_add(preq, issue_flags);
>>>>> +		ret2 = __io_poll_add(preq, issue_flags);
>>>>>  		/* successfully updated, don't complete poll request */
>>>>>  		if (!ret2)
>>>>>  			goto out;
>>>>> +		preq->result = ret2;
>>>>> +
>>>>>  	}
>>>>> -	req_set_fail(preq);
>>>>> -	io_req_complete(preq, -ECANCELED);
>>>>> +	if (preq->result < 0)
>>>>> +		req_set_fail(preq);
>>>>> +	io_req_complete(preq, preq->result);
>>>
>>> This should all be handled in the fixup patch - yes this one ended up
>>> being broken, but that's why there's the followup fix.
>>>
>>> Now this is all pretty broken because some patches ended up in 5.15 and
>>> some in 5.10 and honestly I've almost lost track at this point. Sasha
>>> spotted some that were dropped in some broken commit from Greg. For
>>> 5.15, the two attached are what I recently asked for to be added. 5.10
>>> should ALWAYS get the exact same patches as 5.15, because of the whole
>>> sale backport that was done years ago. I always ask for that explicitly
>>> in the emails. But looks like that wasn't always done...
>>>
>>> 5.10 doesn't look like it ever got what is sha
>>> 349ef5d2e7bfb292e7000e6041a984ab56eccf28 in 5.15-stable, hence the fixup
>>> can be merged with queueing that backport.
>>>
>>> Sigh...
>>
>> Oh, for the fixup patch - it is in the 5.10-queue (or at least was when I
>> wrote up report today).  It was taken into consideration.  The concern
>> for the Fixes tag is resolved now by you, thanks for clarification.
>>
>> But that `if (preq->result) < 0` thing is not covered by the fixup patch.
>> This check is not correct in 5.10/5.15 because preq->result is unsigned.
>>
>> Taken that double complete is OK (I had doubts about that), the following
>> change should do the job now:
>>
>> diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
>> index 8b0dfea96ee0..b17a26b1b5e1 100644
>> --- a/io_uring/io_uring.c
>> +++ b/io_uring/io_uring.c
>> @@ -6006,7 +6006,7 @@ static int io_poll_update(struct io_kiocb *req, unsigned int issue_flags)
>>  {
>>         struct io_ring_ctx *ctx = req->ctx;
>>         struct io_kiocb *preq;
>> -       int ret2, ret = 0;
>> +       int ret2 = -ECANCELED, ret = 0;
>>  
>>         io_ring_submit_lock(ctx, !(issue_flags & IO_URING_F_NONBLOCK));
>>  
>> @@ -6037,7 +6037,7 @@ static int io_poll_update(struct io_kiocb *req, unsigned int issue_flags)
>>                 preq->result = ret2;
>>  
>>         }
>> -       if (preq->result < 0)
>> +       if (ret2 < 0)
>>                 req_set_fail(preq);
>>         io_req_complete(preq, preq->result);
>>  out:
>>
>>
>> The fixup patch may be updated with this if the changes look OK.
>>
> 
> Or maybe this one which is less hassle:
> 
> diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
> index 8b0dfea96ee0..bb01eaa9761f 100644
> --- a/io_uring/io_uring.c
> +++ b/io_uring/io_uring.c
> @@ -6037,7 +6037,7 @@ static int io_poll_update(struct io_kiocb *req, unsigned int issue_flags)
>                 preq->result = ret2;
>  
>         }
> -       if (preq->result < 0)
> +       if (preq->result)
>                 req_set_fail(preq);
>         io_req_complete(preq, preq->result);
>  out:

That'd be fine. Note that both your patches are white space damaged. I
can send out updated fixup patches, the above does improve them. But at
this point I don't even know what is queued up where. As far as I can
tell neither 5.10-stable or 5.15-stable have the fixup queued up yet,
even though I asked for it 10 days ago. Neither the fixup, nor the
EPOLL_URING_WAKE patch.

I feel like I spend a lot of time both on stable, and defending stable
against people that complain about it. And usually it's all been fine,
but lately it does seem like a bit of a mess :(, and as a maintainer, I
absolutely 100% need to rely on stable doing what they are asked to do,
and if patches fail, then I need to know about it. If patches get yanked
for whatever reason, I need to get asked. And if I ask for patches to
get included and I get an ack, I should not need to scour various stable
branches to check if that actually happened or not.

So let me make it VERY clear - apply the two attached patches to BOTH
5.10-stable and 5.15-stable. Thank you.

-- 
Jens Axboe
--------------A8p0UoQPpNU5B0IW0tmvoTwX
Content-Type: text/x-patch; charset=UTF-8;
 name="0001-io_uring-poll-fix-EPOLL_URING_WAKE-sometimes-not-bei.patch"
Content-Disposition: attachment;
 filename*0="0001-io_uring-poll-fix-EPOLL_URING_WAKE-sometimes-not-bei.pa";
 filename*1="tch"
Content-Transfer-Encoding: base64

RnJvbSAyNDAyMTFiZDgyNzBlYTQyNDQwYjE3NzVlNGQ3YmMwMDU5MDhjZDQ2IE1vbiBTZXAg
MTcgMDA6MDA6MDAgMjAwMQpGcm9tOiBKZW5zIEF4Ym9lIDxheGJvZUBrZXJuZWwuZGs+CkRh
dGU6IFR1ZSwgMjEgQXByIDIwMjYgMTY6NDE6MzIgLTA2MDAKU3ViamVjdDogW1BBVENIIDEv
Ml0gaW9fdXJpbmcvcG9sbDogZml4IEVQT0xMX1VSSU5HX1dBS0Ugc29tZXRpbWVzIG5vdCBi
ZWluZwogbWFza2VkIGluCgpSYXRoZXIgdGhhbiBkbyBpdCBvbmx5IHdoZW4gd2UganVtcCBz
dHJhaWdodCB0byBleGVjdXRpb24sIG1hcmsgaXQKcmVnYXJkbGVzcy4gVGhpcyBlbnN1cmVz
IGl0IGRvZXNuJ3QgZ2V0IGxvc3QuCgpGaXhlczogY2NmMDZiNWE5ODFjICgiaW9fdXJpbmc6
IHBhc3MgaW4gRVBPTExfVVJJTkdfV0FLRSBmb3IgZXZlbnRmZCBzaWduYWxpbmcgYW5kIHdh
a2V1cHMiKQpTaWduZWQtb2ZmLWJ5OiBKZW5zIEF4Ym9lIDxheGJvZUBrZXJuZWwuZGs+Ci0t
LQogaW9fdXJpbmcvaW9fdXJpbmcuYyB8IDE3ICsrKysrKysrLS0tLS0tLS0tCiAxIGZpbGUg
Y2hhbmdlZCwgOCBpbnNlcnRpb25zKCspLCA5IGRlbGV0aW9ucygtKQoKZGlmZiAtLWdpdCBh
L2lvX3VyaW5nL2lvX3VyaW5nLmMgYi9pb191cmluZy9pb191cmluZy5jCmluZGV4IDM4ZGVj
ZmMxYTkxNC4uZGI1YzlmYmRlYzNiIDEwMDY0NAotLS0gYS9pb191cmluZy9pb191cmluZy5j
CisrKyBiL2lvX3VyaW5nL2lvX3VyaW5nLmMKQEAgLTU3OTQsMTcgKzU3OTQsMTYgQEAgc3Rh
dGljIGludCBpb19wb2xsX3dha2Uoc3RydWN0IHdhaXRfcXVldWVfZW50cnkgKndhaXQsIHVu
c2lnbmVkIG1vZGUsIGludCBzeW5jLAogCWlmIChtYXNrICYmICEobWFzayAmIHBvbGwtPmV2
ZW50cykpCiAJCXJldHVybiAwOwogCi0JaWYgKGlvX3BvbGxfZ2V0X293bmVyc2hpcChyZXEp
KSB7Ci0JCS8qCi0JCSAqIElmIHdlIHRyaWdnZXIgYSBtdWx0aXNob3QgcG9sbCBvZmYgb3Vy
IG93biB3YWtldXAgcGF0aCwKLQkJICogZGlzYWJsZSBtdWx0aXNob3QgYXMgdGhlcmUgaXMg
YSBjaXJjdWxhciBkZXBlbmRlbmN5IGJldHdlZW4KLQkJICogQ1EgcG9zdGluZyBhbmQgdHJp
Z2dlcmluZyB0aGUgZXZlbnQuCi0JCSAqLwotCQlpZiAobWFzayAmIEVQT0xMX1VSSU5HX1dB
S0UpCi0JCQlwb2xsLT5ldmVudHMgfD0gRVBPTExPTkVTSE9UOworCS8qCisJICogSWYgd2Ug
dHJpZ2dlciBhIG11bHRpc2hvdCBwb2xsIG9mZiBvdXIgb3duIHdha2V1cCBwYXRoLAorCSAq
IGRpc2FibGUgbXVsdGlzaG90IGFzIHRoZXJlIGlzIGEgY2lyY3VsYXIgZGVwZW5kZW5jeSBi
ZXR3ZWVuCisJICogQ1EgcG9zdGluZyBhbmQgdHJpZ2dlcmluZyB0aGUgZXZlbnQuCisJICov
CisJaWYgKG1hc2sgJiBFUE9MTF9VUklOR19XQUtFKQorCQlwb2xsLT5ldmVudHMgfD0gRVBP
TExPTkVTSE9UOwogCisJaWYgKGlvX3BvbGxfZ2V0X293bmVyc2hpcChyZXEpKQogCQlfX2lv
X3BvbGxfZXhlY3V0ZShyZXEsIG1hc2spOwotCX0KIAlyZXR1cm4gMTsKIH0KIAotLSAKMi41
My4wCgo=
--------------A8p0UoQPpNU5B0IW0tmvoTwX
Content-Type: text/x-patch; charset=UTF-8;
 name="0002-io_uring-poll-fix-backport-of-io_poll_add-changes.patch"
Content-Disposition: attachment;
 filename*0="0002-io_uring-poll-fix-backport-of-io_poll_add-changes.patch"
Content-Transfer-Encoding: base64

RnJvbSA4ZjFhNDAxYjBmY2U1YTQ2OTM1MTUzZjg1NzJiMDY4MWQ1YjlhMDBkIE1vbiBTZXAg
MTcgMDA6MDA6MDAgMjAwMQpGcm9tOiBKZW5zIEF4Ym9lIDxheGJvZUBrZXJuZWwuZGs+CkRh
dGU6IFR1ZSwgMjEgQXByIDIwMjYgMTY6NDQ6MDYgLTA2MDAKU3ViamVjdDogW1BBVENIIDIv
Ml0gaW9fdXJpbmcvcG9sbDogZml4IGJhY2twb3J0IG9mIGlvX3BvbGxfYWRkKCkgY2hhbmdl
cwoKVGhlIDUuMTUvNS4xMCBiYWNrcG9ydCBvZiA4NDIzMGFkMmQyYWYgaGFkIGEgZmV3IGlz
c3VlcywgZHVlIHRvIHRoZQpvbGRlciBwb2xsIGJhc2UuIE5vdGFibHkgcmV0dXJuIHZhbHVl
IGhhbmRsaW5nIF9faW9fYXJtX3BvbGxfaGFuZGxlcigpCmFuZCBpbiByZXR1cm4gX19pb19w
b2xsX2FkZCgpIGFzIHdlbGwuIEZpeCB0aGVtIHVwLgoKUmVwb3J0ZWQtYnk6IEJlbiBIdXRj
aGluZ3MgPGJlbkBkZWNhZGVudC5vcmcudWs+CkZpeGVzOiAzNDllZjVkMmU3YmYgKCJpb191
cmluZy9wb2xsOiBjb3JyZWN0bHkgaGFuZGxlIGlvX3BvbGxfYWRkKCkgcmV0dXJuIHZhbHVl
IG9uIHVwZGF0ZSIpClNpZ25lZC1vZmYtYnk6IEplbnMgQXhib2UgPGF4Ym9lQGtlcm5lbC5k
az4KLS0tCiBpb191cmluZy9pb191cmluZy5jIHwgMTQgKysrKystLS0tLS0tLS0KIDEgZmls
ZSBjaGFuZ2VkLCA1IGluc2VydGlvbnMoKyksIDkgZGVsZXRpb25zKC0pCgpkaWZmIC0tZ2l0
IGEvaW9fdXJpbmcvaW9fdXJpbmcuYyBiL2lvX3VyaW5nL2lvX3VyaW5nLmMKaW5kZXggZGI1
YzlmYmRlYzNiLi45N2QwZWNlYzgzMjIgMTAwNjQ0Ci0tLSBhL2lvX3VyaW5nL2lvX3VyaW5n
LmMKKysrIGIvaW9fdXJpbmcvaW9fdXJpbmcuYwpAQCAtNjEzOCwxOSArNjEzOCwxNSBAQCBz
dGF0aWMgaW50IF9faW9fcG9sbF9hZGQoc3RydWN0IGlvX2tpb2NiICpyZXEsIHVuc2lnbmVk
IGludCBpc3N1ZV9mbGFncykKIAlpZiAoIXJldCAmJiBpcHQuZXJyb3IpCiAJCXJlcV9zZXRf
ZmFpbChyZXEpOwogCXJldCA9IHJldCA/OiBpcHQuZXJyb3I7Ci0JaWYgKHJldCA+IDApIHsK
KwlpZiAocmV0KQogCQlfX2lvX3JlcV9jb21wbGV0ZShyZXEsIGlzc3VlX2ZsYWdzLCByZXQs
IDApOwotCQlyZXR1cm4gcmV0OwotCX0KLQlyZXR1cm4gMDsKKwlyZXR1cm4gcmV0OwogfQog
CiBzdGF0aWMgaW50IGlvX3BvbGxfYWRkKHN0cnVjdCBpb19raW9jYiAqcmVxLCB1bnNpZ25l
ZCBpbnQgaXNzdWVfZmxhZ3MpCiB7Ci0JaW50IHJldDsKLQotCXJldCA9IF9faW9fcG9sbF9h
ZGQocmVxLCBpc3N1ZV9mbGFncyk7Ci0JcmV0dXJuIHJldCA8IDAgPyByZXQgOiAwOworCV9f
aW9fcG9sbF9hZGQocmVxLCBpc3N1ZV9mbGFncyk7CisJcmV0dXJuIDA7CiB9CiAKIHN0YXRp
YyBpbnQgaW9fcG9sbF91cGRhdGUoc3RydWN0IGlvX2tpb2NiICpyZXEsIHVuc2lnbmVkIGlu
dCBpc3N1ZV9mbGFncykKQEAgLTYxODgsNyArNjE4NCw3IEBAIHN0YXRpYyBpbnQgaW9fcG9s
bF91cGRhdGUoc3RydWN0IGlvX2tpb2NiICpyZXEsIHVuc2lnbmVkIGludCBpc3N1ZV9mbGFn
cykKIAkJcHJlcS0+cmVzdWx0ID0gcmV0MjsKIAogCX0KLQlpZiAocHJlcS0+cmVzdWx0IDwg
MCkKKwlpZiAocmV0MiA8IDApCiAJCXJlcV9zZXRfZmFpbChwcmVxKTsKIAlpb19yZXFfY29t
cGxldGUocHJlcSwgcHJlcS0+cmVzdWx0KTsKIG91dDoKLS0gCjIuNTMuMAoK

--------------A8p0UoQPpNU5B0IW0tmvoTwX--
