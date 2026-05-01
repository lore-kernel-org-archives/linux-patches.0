Received: from mail-oo1-f52.google.com (mail-oo1-f52.google.com [209.85.161.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 23873213E89
	for <patches@lists.linux.dev>; Fri,  1 May 2026 21:33:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777671194; cv=none; b=l/wyyEfvex21iGDnI88vam9cEWjc4wKizDQhH9glsdfT63B8GB7Lfnkb5oE8MdtITN4JFiK3EOEjsSRf3KKOFjQCqolJbjVqYXff1Rf2b40900W4jFUY1xJ8KWADXmXZaWlndSj5N+wUkkcLEwrG01mFKZ82lRm0nn9Fiej6CQ4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777671194; c=relaxed/simple;
	bh=Mj0E3J34d5phtM5sQPs3cAukaXDcoxZZzTYXSlBZlgg=;
	h=Content-Type:Message-ID:Date:MIME-Version:Subject:To:Cc:
	 References:From:In-Reply-To; b=ZAmBC+LjkcVWBEIG1gqBoFjG29ZbQDZaulav8J6RyvJ+zMZGdZFyqB9h22/1xO+EQZlN8olziCp0YXxeBNfnxxNdmnIQG1XMTJBy0GllP0jKvMxCz9kxLco7/in5ZtTh0wSWhrgJWn3AzxOyRFIPBliaixBfoC08exf9fp/fSio=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20251104.gappssmtp.com header.i=@kernel-dk.20251104.gappssmtp.com header.b=CVM9GWh1; arc=none smtp.client-ip=209.85.161.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20251104.gappssmtp.com header.i=@kernel-dk.20251104.gappssmtp.com header.b="CVM9GWh1"
Received: by mail-oo1-f52.google.com with SMTP id 006d021491bc7-6967080e6beso737653eaf.2
        for <patches@lists.linux.dev>; Fri, 01 May 2026 14:33:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20251104.gappssmtp.com; s=20251104; t=1777671191; x=1778275991; darn=lists.linux.dev;
        h=in-reply-to:from:content-language:references:cc:to:subject
         :user-agent:mime-version:date:message-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=jqo/S64QjQ2tROyU1wOybG/D2kuxZ6ciFJ7oklmPXqw=;
        b=CVM9GWh1xwkoItmTXbAbTwHly6v9yEYwD8+1YUh94NM4LhLpLbojy93z2Lp4iU9UZb
         3G7vdEXjy2gqaM5ggVx/CakKCaASc60QBXqknA1yxp5x7oU+/FsQkZSVNFXDv08mpdp0
         1eYVZTOF8uOmmoBY/sYmI69aaiJMFfCYSJB86H226aUEE6h8klGSXzg54g0XiGtgcDOd
         BO88iWZF5GDu8/busTVBMiU4pBymMsS7PQnLKyFVIF1B3/uybzAGzZUl3Uq8gFX6bYQE
         an/92EwKgHSm3v0ZaIGV4pUtBYdl8BCJ8pkAjO00POrx1zp7amGnB4O+W90S2PpJXNGC
         eG0A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777671191; x=1778275991;
        h=in-reply-to:from:content-language:references:cc:to:subject
         :user-agent:mime-version:date:message-id:x-gm-gg:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=jqo/S64QjQ2tROyU1wOybG/D2kuxZ6ciFJ7oklmPXqw=;
        b=lPinydT5cXL97WAWps5uypxzJnydKTL2kaumsF51Dl8ckdB61aWPheo4X7UOKWLdCJ
         DRDh3+uHdLcBbxqMOgnBkp9BcL5mCkG3z8jHIEE9eMIDNnmDWEU/txsr8/fGMjuLSuWu
         oI+4Mq+xw1/aBt3r16zxf1FUtxgRB1zdgbIwHiW9DhVRJ8hSPxDSnfWTnu1+yS1tgANS
         qC4TlwF65/ACFBpX2D/0sSRY6FoEIhEq5SgbgmQfaPfu5qomeAz1pqwT3pRdPYq7upds
         mdxFMYlOpYgUtRGu+4hEYfrbqJKZA4Wlr/1YV0J2KyeYzpD7NbzB0Ddn6DethOOqJWcO
         Agdg==
X-Forwarded-Encrypted: i=1; AFNElJ8+MNIAlYhYJoG68K4Lj1Yq5sdaZlTHBa9xE7u87u/wqziSLxLLredkCD2q9mkTidIpSsy5p769@lists.linux.dev
X-Gm-Message-State: AOJu0YwksAIn6+uqgTIBkWNlqTNNIiWL5B5MwYZ/CalgmRgRDrrLLkb/
	R/mfAnFHSmD3wvl0yblSYep1A57HAmhb/5Yk6AUjSdAiVT3+isTIGBx5mvUkxpqX4uc=
X-Gm-Gg: AeBDieuknOSMD6R1k9lcqU5IkPy1JStSF9SWu202kyY+ju4JtTEfGB4S4BVc2fgmuJa
	iRcmqHjOhd9RTxhCD96hrMlpO5fYdiKl894NzKOI8MCedfvSLb3HuZ5M37Alsd+WFoTGoi4mTR0
	T+VKbUKu9+Fs8DqkjXz3pIf8C1Jdt35pakS1fDjyjSJIdXcFdX1h8stZvifCU/7+eXffM1KxVwv
	ToQ77HmhPsvirfI7GlzLw2tk9R62kfiYWI60gO9UwC3BitSeJPRGNx3KyK99vxe551qYce6eEr0
	Rkk5yLWldilGQnjSTQXWEd9qvs+a9vCakoVAJ8FnH1+ozJv/O6PzZI5JFGJITLZCSN73rLmX+uC
	Z9glqyPubcU4q/VtePJqgwfBGTRt7Xm2lvyxZ8KX4EXN8UgWfAkRcV+qLUOjKKG5nkWe2vF+eQl
	ERuVLpt3GYfJgMcnLcePC2XH65oCUP81XTo0bC0eAxufZxe9muB+1Axl94TDwQTjq0hHetM1X1u
	7PRwLcOdM4DRLyYNDNb
X-Received: by 2002:a05:6820:88f:b0:696:702f:6172 with SMTP id 006d021491bc7-696979f6c9amr452210eaf.24.1777671191071;
        Fri, 01 May 2026 14:33:11 -0700 (PDT)
Received: from [192.168.1.150] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id 006d021491bc7-6968945d4fbsm2043932eaf.5.2026.05.01.14.33.09
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 01 May 2026 14:33:10 -0700 (PDT)
Content-Type: multipart/mixed; boundary="------------j5tERgBqSLXJJAxTmFu7xhnp"
Message-ID: <58103791-4c19-441c-9d4f-7ae5f9c6151a@kernel.dk>
Date: Fri, 1 May 2026 15:33:09 -0600
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
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <20260501111233-b371eac52cd006bfddfbd9e5-pchelkin@ispras>

This is a multi-part message in MIME format.
--------------j5tERgBqSLXJJAxTmFu7xhnp
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 5/1/26 2:54 AM, Fedor Pchelkin wrote:
> Hi Jens,
> 
> the patch has some issues even after "[PATCH 2/2] io_uring/poll: fix
> backport of io_poll_add() changes" has been applied.  Please see below.
> 
> Jens Axboe wrote:
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
>>
>> Cc: stable@vger.kernel.org
>> Fixes: 97b388d70b53 ("io_uring: handle completions in the core")
> 
> This commit is not present in 5.10/5.15 in any form, to my mind.  That
> is, io_uring changes were imported in big chunks there without preserving
> upstream git history in some places but still I can't find whether the
> changes of the mentioned Fixes-commit are present in those old kernels.
> 
> So either the Fixes tag is not completely correct or this patch can just
> be reverted from 5.10/5.15 stables.

The fixes tag is wrong.

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

This should all be handled in the fixup patch - yes this one ended up
being broken, but that's why there's the followup fix.

Now this is all pretty broken because some patches ended up in 5.15 and
some in 5.10 and honestly I've almost lost track at this point. Sasha
spotted some that were dropped in some broken commit from Greg. For
5.15, the two attached are what I recently asked for to be added. 5.10
should ALWAYS get the exact same patches as 5.15, because of the whole
sale backport that was done years ago. I always ask for that explicitly
in the emails. But looks like that wasn't always done...

5.10 doesn't look like it ever got what is sha
349ef5d2e7bfb292e7000e6041a984ab56eccf28 in 5.15-stable, hence the fixup
can be merged with queueing that backport.

Sigh...

-- 
Jens Axboe
--------------j5tERgBqSLXJJAxTmFu7xhnp
Content-Type: text/x-patch; charset=UTF-8;
 name="0001-io_uring-poll-fix-EPOLL_URING_WAKE-sometimes-not-bei.patch"
Content-Disposition: attachment;
 filename*0="0001-io_uring-poll-fix-EPOLL_URING_WAKE-sometimes-not-bei.pa";
 filename*1="tch"
Content-Transfer-Encoding: base64

RnJvbSA3ZmRmZmZjZTUwOGYzOGQ4OTMzOGU4YmJlZDQyMWRkOTFkZGZjYjNmIE1vbiBTZXAg
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
--------------j5tERgBqSLXJJAxTmFu7xhnp
Content-Type: text/x-patch; charset=UTF-8;
 name="0002-io_uring-poll-fix-backport-of-io_poll_add-changes.patch"
Content-Disposition: attachment;
 filename*0="0002-io_uring-poll-fix-backport-of-io_poll_add-changes.patch"
Content-Transfer-Encoding: base64

RnJvbSA3YTYxYzM4YzRkNmFlM2Q1Y2JlNmVmYTA2ODg1YjFjYTgyMWExMjljIE1vbiBTZXAg
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
az4KLS0tCiBpb191cmluZy9pb191cmluZy5jIHwgMTIgKysrKy0tLS0tLS0tCiAxIGZpbGUg
Y2hhbmdlZCwgNCBpbnNlcnRpb25zKCspLCA4IGRlbGV0aW9ucygtKQoKZGlmZiAtLWdpdCBh
L2lvX3VyaW5nL2lvX3VyaW5nLmMgYi9pb191cmluZy9pb191cmluZy5jCmluZGV4IGRiNWM5
ZmJkZWMzYi4uMDc1MTllOWE2OTVjIDEwMDY0NAotLS0gYS9pb191cmluZy9pb191cmluZy5j
CisrKyBiL2lvX3VyaW5nL2lvX3VyaW5nLmMKQEAgLTYxMzgsMTkgKzYxMzgsMTUgQEAgc3Rh
dGljIGludCBfX2lvX3BvbGxfYWRkKHN0cnVjdCBpb19raW9jYiAqcmVxLCB1bnNpZ25lZCBp
bnQgaXNzdWVfZmxhZ3MpCiAJaWYgKCFyZXQgJiYgaXB0LmVycm9yKQogCQlyZXFfc2V0X2Zh
aWwocmVxKTsKIAlyZXQgPSByZXQgPzogaXB0LmVycm9yOwotCWlmIChyZXQgPiAwKSB7CisJ
aWYgKHJldCkKIAkJX19pb19yZXFfY29tcGxldGUocmVxLCBpc3N1ZV9mbGFncywgcmV0LCAw
KTsKLQkJcmV0dXJuIHJldDsKLQl9Ci0JcmV0dXJuIDA7CisJcmV0dXJuIHJldDsKIH0KIAog
c3RhdGljIGludCBpb19wb2xsX2FkZChzdHJ1Y3QgaW9fa2lvY2IgKnJlcSwgdW5zaWduZWQg
aW50IGlzc3VlX2ZsYWdzKQogewotCWludCByZXQ7Ci0KLQlyZXQgPSBfX2lvX3BvbGxfYWRk
KHJlcSwgaXNzdWVfZmxhZ3MpOwotCXJldHVybiByZXQgPCAwID8gcmV0IDogMDsKKwlfX2lv
X3BvbGxfYWRkKHJlcSwgaXNzdWVfZmxhZ3MpOworCXJldHVybiAwOwogfQogCiBzdGF0aWMg
aW50IGlvX3BvbGxfdXBkYXRlKHN0cnVjdCBpb19raW9jYiAqcmVxLCB1bnNpZ25lZCBpbnQg
aXNzdWVfZmxhZ3MpCi0tIAoyLjUzLjAKCg==

--------------j5tERgBqSLXJJAxTmFu7xhnp--
