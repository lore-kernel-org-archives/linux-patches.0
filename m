Received: from mail-ot1-f50.google.com (mail-ot1-f50.google.com [209.85.210.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B210E1A8F7B
	for <patches@lists.linux.dev>; Fri,  1 May 2026 23:27:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777678052; cv=none; b=GPpMwjlKZINyswFo0MxqeA5CZHmIggQrbjSfn01k5TTyJWx0lruehGU6ADVLhOVlnYmDG8S8E3KD4Q+/1Tis88fTj7e/4Z0Tqysobi+Pl3vtA7XnjZjKwforT6EOKAoxQs4Vcwr5uJO3I43v/9zWPp0aF5enemeRkZqUTnR/1cU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777678052; c=relaxed/simple;
	bh=+RX7L6fUat4Wp+AUHq2pgAIB6jS1bJbGELu7AFYBJ0w=;
	h=Content-Type:Message-ID:Date:MIME-Version:Subject:From:To:Cc:
	 References:In-Reply-To; b=EU6rMef6lX4OXeyKzuU1z2WpQDIEABItw+lbZWuwKaAvhyc2jpvgIXyx0ySTB25ZBWi9cJNXZil5jHEut7nz7AAmibYN/SuOZu2M8q4LCMUKyGX/5ZrOH3aFKFo5rCbtyGZTTQvlRG7t9kpOuEFJJcdkbRGnf7MeOvNNGbiuyOo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20251104.gappssmtp.com header.i=@kernel-dk.20251104.gappssmtp.com header.b=Ryq32ekV; arc=none smtp.client-ip=209.85.210.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20251104.gappssmtp.com header.i=@kernel-dk.20251104.gappssmtp.com header.b="Ryq32ekV"
Received: by mail-ot1-f50.google.com with SMTP id 46e09a7af769-7d4c383f2fcso2209901a34.0
        for <patches@lists.linux.dev>; Fri, 01 May 2026 16:27:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20251104.gappssmtp.com; s=20251104; t=1777678050; x=1778282850; darn=lists.linux.dev;
        h=in-reply-to:content-language:references:cc:to:from:subject
         :user-agent:mime-version:date:message-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=XjrfMO63U95PdjGFZAI4vMipk855McCwbqiJx7KyHY8=;
        b=Ryq32ekVWo6wY4n0RBrFPcZgS+qUI5etf6fvEqU3bnnqOPrQJonCSFqRB5sdSVvgxY
         kG0a69EUdY4mSIvCv9IW1Fkx76mEEM78+2f/u9Iwiw19usd/8eOv1/RFfavfThoAN9UH
         jpRxKNXb12NIYiJlRY7WXeZwnj95lPniJ/FsClTaJwyxtUp3goI1y+5hSO7CMB7xH3lZ
         W98l/olwToNlrwluHpc+vTHXP0jnGa8AncQ+v2QAcbBw/Q01GPwtmnA1bplaibfYybpB
         6/xDbiWNMhpN/0XeR29PS7ze9G3chy47lGzNtlpmBmKdHzKTx9OXzKUDNSSdw5AnEdtg
         cBug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777678050; x=1778282850;
        h=in-reply-to:content-language:references:cc:to:from:subject
         :user-agent:mime-version:date:message-id:x-gm-gg:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=XjrfMO63U95PdjGFZAI4vMipk855McCwbqiJx7KyHY8=;
        b=XpiDoF5KDqBv63MjsJXDJNskNNBEh2Vy2AHtfM6I23lTVRPak5qABotmM0tIPvDMBV
         B06FXBe0B1VvMbIbKuPIHfe9d8WOsNAB3+TraSo3l8xZLmVB77Q36Yiel2BCqMOWDyki
         gOaZFJ9J7p4xsNiUasLkNSsCPJyh1Pv82J9vvxAtz6Lkawvkr9Wo8Oz6TCv6WcdM1cYp
         +ojgxIQvmcl6drayMch1EYv4LHADafcE+F83JsAu3lRMqi1aCmeb+/DlhO4Ls7jPjdFN
         5SB8ph9i7MrVdxy/I9PdRqgSkRHxMUNgscQSl6gwheC+F72iwxbv8dscItJSIWk7q1E1
         EJqw==
X-Forwarded-Encrypted: i=1; AFNElJ9EnNRJ2n+xuNAUguMZa5leKYX5Vm3BRDqpjk+AAznYi3NgGcbxQgtZzn1yh/aXUkluYrg4uPqZ@lists.linux.dev
X-Gm-Message-State: AOJu0YwRwfIvPc2ZxWqlmj4LtKwPrFdjyd2GsOkX6sZqGWu9O7D4ad//
	KaUYKgrPuJltYrbFexb2I1gcXBf5BWbtKKy6sCNMGHG29huVRleZGe/YpSRAPFvCL/E=
X-Gm-Gg: AeBDieskwOnpeWxk5iqPEr7LzTe/4NSiU4Y9dFiglOivokRljQlGNzJdo/BUS8LaVvk
	HSTJjjtG0HwzOic2D+OmdoMjxKyogQtAyt4ABNthIKWHw6zOWHdyjIUbi9HUlBktWhKvorvlq/o
	ow8z9zg+NpORD6pv6eQykHQD0kuqqtgLgY/YzXdBQJ9EpdNW54vkIOq9INVEuajeqtiJaBGETRC
	7Dtwmwklan5UCNqdRd6BUy6PxaQKgR5F5GqALU7tWXpHRQxsm/SsAmzrnaY+U0G14bVYyMeYrkx
	jNnMV9M9iUczrLCqxX1/GFY9yl9HaAFtgDijqxbtaz9Xy7+pP1r0cH6xKmq6vjkizIb3D3A31DH
	IaY0cjERGcQ622j01XLV2YabsoXsy1MB2g0O88Zokc7sxNtVzTtOYuN6Fg2i2ppXeJwjWLC7pl+
	O8n3zI5wTcetmeh7ejEelBpY6yzJs0WtNC6JVFvNiF0cLlRNrHWNzBmAp5HMEWshs3cDZmxV8cJ
	M26Mg+mPNs17DUwArhZ
X-Received: by 2002:a05:6820:81c9:b0:67e:2988:15e1 with SMTP id 006d021491bc7-696979db1b7mr673500eaf.16.1777678049728;
        Fri, 01 May 2026 16:27:29 -0700 (PDT)
Received: from [192.168.1.150] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id 586e51a60fabf-43454951a95sm3831017fac.7.2026.05.01.16.27.28
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 01 May 2026 16:27:28 -0700 (PDT)
Content-Type: multipart/mixed; boundary="------------tAlOktRJxkv9monnvnCUb0jV"
Message-ID: <9b00a03b-ff87-4d09-be2a-5865e555bcd6@kernel.dk>
Date: Fri, 1 May 2026 17:27:27 -0600
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 5.10 491/491] io_uring/poll: correctly handle
 io_poll_add() return value on update
From: Jens Axboe <axboe@kernel.dk>
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
 <fb26a75a-cb2c-4ee6-92b9-4c488a2c7ba5@kernel.dk>
 <20260502011444-849ff2d3f8fe48b07f48d496-pchelkin@ispras>
 <5794c5cd-ff76-428a-830b-6aaff9d36089@kernel.dk>
Content-Language: en-US
In-Reply-To: <5794c5cd-ff76-428a-830b-6aaff9d36089@kernel.dk>

This is a multi-part message in MIME format.
--------------tAlOktRJxkv9monnvnCUb0jV
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 5/1/26 4:29 PM, Jens Axboe wrote:
> On 5/1/26 4:26 PM, Fedor Pchelkin wrote:
>>> @@ -6188,7 +6184,7 @@ static int io_poll_update(struct io_kiocb *req, unsigned int issue_flags)
>>>  		preq->result = ret2;
>>>  
>>>  	}
>>> -	if (preq->result < 0)
>>> +	if (ret2 < 0)
>>>  		req_set_fail(preq);
>>>  	io_req_complete(preq, preq->result);
>>>  out:
>>
>> I'm really uncomfortable to raise this but - ret2 should be initialized in
>> beginning of the function io_poll_update().
> 
> It's your second version... I'll send out a new set.

OK, here's the new set for both 5.10-stable and 5.15-stable. Ran it through the
usual testing.

Let's hope we can put this one to bed now :-)

-- 
Jens Axboe

--------------tAlOktRJxkv9monnvnCUb0jV
Content-Type: text/x-patch; charset=UTF-8;
 name="0001-io_uring-poll-fix-EPOLL_URING_WAKE-sometimes-not-bei.patch"
Content-Disposition: attachment;
 filename*0="0001-io_uring-poll-fix-EPOLL_URING_WAKE-sometimes-not-bei.pa";
 filename*1="tch"
Content-Transfer-Encoding: base64

RnJvbSAzOGViYWUzYjkzNDAzZTAzZDJlNmE0NGFmZDJkOTgwY2NlNDlkYjhjIE1vbiBTZXAg
MTcgMDA6MDA6MDAgMjAwMQpGcm9tOiBKZW5zIEF4Ym9lIDxheGJvZUBrZXJuZWwuZGs+CkRh
dGU6IFR1ZSwgMjEgQXByIDIwMjYgMTY6NDE6MzIgLTA2MDAKU3ViamVjdDogW1BBVENIIDEv
Ml0gaW9fdXJpbmcvcG9sbDogZml4IEVQT0xMX1VSSU5HX1dBS0Ugc29tZXRpbWVzIG5vdCBi
ZWluZwogaG9ub3JlZAoKUmF0aGVyIHRoYW4gZG8gdGhlIG1hc2tpbmcgIG9ubHkgd2hlbiB3
ZSBqdW1wIHN0cmFpZ2h0IHRvIGV4ZWN1dGlvbiwKbWFyayBpdCBhcyBFUE9MTE9ORVNIT1Qg
cmVnYXJkbGVzcy4gVGhpcyBlbnN1cmVzIGl0IGRvZXNuJ3QgZ2V0IGxvc3QuCkFuZCBqdXN0
IGtpbGwgdGhlIHBvbGwgZW50cnkgdXBmcm9udCwgaWYgbWFya2VkLiBUaGlzIGlzIGFuIG9w
dGltaXphdGlvbgppbiBsYXRlciBrZXJuZWxzLCBidXQgaXQncyBhY3R1YWxseSByZXF1aXJl
ZCBvbiB0aGUgb2xkZXIga2VybmVscyB0bwpub3RlIHRoZSBFUE9MTF9VUklOR19XQUtFIG1h
c2sgY29ycmVjdGx5LgoKRml4ZXM6IGNjZjA2YjVhOTgxYyAoImlvX3VyaW5nOiBwYXNzIGlu
IEVQT0xMX1VSSU5HX1dBS0UgZm9yIGV2ZW50ZmQgc2lnbmFsaW5nIGFuZCB3YWtldXBzIikK
U2lnbmVkLW9mZi1ieTogSmVucyBBeGJvZSA8YXhib2VAa2VybmVsLmRrPgotLS0KIGlvX3Vy
aW5nL2lvX3VyaW5nLmMgfCAxOSArKysrKysrKysrKystLS0tLS0tCiAxIGZpbGUgY2hhbmdl
ZCwgMTIgaW5zZXJ0aW9ucygrKSwgNyBkZWxldGlvbnMoLSkKCmRpZmYgLS1naXQgYS9pb191
cmluZy9pb191cmluZy5jIGIvaW9fdXJpbmcvaW9fdXJpbmcuYwppbmRleCAzOGRlY2ZjMWE5
MTQuLjRmMWRkYTdkNjhjMiAxMDA2NDQKLS0tIGEvaW9fdXJpbmcvaW9fdXJpbmcuYworKysg
Yi9pb191cmluZy9pb191cmluZy5jCkBAIC01Nzk0LDE0ICs1Nzk0LDE5IEBAIHN0YXRpYyBp
bnQgaW9fcG9sbF93YWtlKHN0cnVjdCB3YWl0X3F1ZXVlX2VudHJ5ICp3YWl0LCB1bnNpZ25l
ZCBtb2RlLCBpbnQgc3luYywKIAlpZiAobWFzayAmJiAhKG1hc2sgJiBwb2xsLT5ldmVudHMp
KQogCQlyZXR1cm4gMDsKIAorCS8qCisJICogSWYgd2UgdHJpZ2dlciBhIG11bHRpc2hvdCBw
b2xsIG9mZiBvdXIgb3duIHdha2V1cCBwYXRoLAorCSAqIGRpc2FibGUgbXVsdGlzaG90IGFz
IHRoZXJlIGlzIGEgY2lyY3VsYXIgZGVwZW5kZW5jeSBiZXR3ZWVuCisJICogQ1EgcG9zdGlu
ZyBhbmQgdHJpZ2dlcmluZyB0aGUgZXZlbnQuCisJICovCisJaWYgKG1hc2sgJiBFUE9MTF9V
UklOR19XQUtFKQorCQlwb2xsLT5ldmVudHMgfD0gRVBPTExPTkVTSE9UOworCiAJaWYgKGlv
X3BvbGxfZ2V0X293bmVyc2hpcChyZXEpKSB7Ci0JCS8qCi0JCSAqIElmIHdlIHRyaWdnZXIg
YSBtdWx0aXNob3QgcG9sbCBvZmYgb3VyIG93biB3YWtldXAgcGF0aCwKLQkJICogZGlzYWJs
ZSBtdWx0aXNob3QgYXMgdGhlcmUgaXMgYSBjaXJjdWxhciBkZXBlbmRlbmN5IGJldHdlZW4K
LQkJICogQ1EgcG9zdGluZyBhbmQgdHJpZ2dlcmluZyB0aGUgZXZlbnQuCi0JCSAqLwotCQlp
ZiAobWFzayAmIEVQT0xMX1VSSU5HX1dBS0UpCi0JCQlwb2xsLT5ldmVudHMgfD0gRVBPTExP
TkVTSE9UOworCQlpZiAobWFzayAmJiBwb2xsLT5ldmVudHMgJiBFUE9MTE9ORVNIT1QpIHsK
KwkJCWxpc3RfZGVsX2luaXQoJnBvbGwtPndhaXQuZW50cnkpOworCQkJc21wX3N0b3JlX3Jl
bGVhc2UoJnBvbGwtPmhlYWQsIE5VTEwpOworCQl9CiAKIAkJX19pb19wb2xsX2V4ZWN1dGUo
cmVxLCBtYXNrKTsKIAl9Ci0tIAoyLjUzLjAKCg==
--------------tAlOktRJxkv9monnvnCUb0jV
Content-Type: text/x-patch; charset=UTF-8;
 name="0002-io_uring-poll-fix-backport-of-io_poll_add-changes.patch"
Content-Disposition: attachment;
 filename*0="0002-io_uring-poll-fix-backport-of-io_poll_add-changes.patch"
Content-Transfer-Encoding: base64

RnJvbSAxYTA3NGI2MTIzOTYxMzIzMWIwZDZjYjY4YTMzYjAwMWNhOGU0NmNlIE1vbiBTZXAg
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
az4KLS0tCiBpb191cmluZy9pb191cmluZy5jIHwgMTYgKysrKysrLS0tLS0tLS0tLQogMSBm
aWxlIGNoYW5nZWQsIDYgaW5zZXJ0aW9ucygrKSwgMTAgZGVsZXRpb25zKC0pCgpkaWZmIC0t
Z2l0IGEvaW9fdXJpbmcvaW9fdXJpbmcuYyBiL2lvX3VyaW5nL2lvX3VyaW5nLmMKaW5kZXgg
NGYxZGRhN2Q2OGMyLi5jYjU0ZWJkYTBhOGEgMTAwNjQ0Ci0tLSBhL2lvX3VyaW5nL2lvX3Vy
aW5nLmMKKysrIGIvaW9fdXJpbmcvaW9fdXJpbmcuYwpAQCAtNjE0NCwyNiArNjE0NCwyMiBA
QCBzdGF0aWMgaW50IF9faW9fcG9sbF9hZGQoc3RydWN0IGlvX2tpb2NiICpyZXEsIHVuc2ln
bmVkIGludCBpc3N1ZV9mbGFncykKIAlpZiAoIXJldCAmJiBpcHQuZXJyb3IpCiAJCXJlcV9z
ZXRfZmFpbChyZXEpOwogCXJldCA9IHJldCA/OiBpcHQuZXJyb3I7Ci0JaWYgKHJldCA+IDAp
IHsKKwlpZiAocmV0KQogCQlfX2lvX3JlcV9jb21wbGV0ZShyZXEsIGlzc3VlX2ZsYWdzLCBy
ZXQsIDApOwotCQlyZXR1cm4gcmV0OwotCX0KLQlyZXR1cm4gMDsKKwlyZXR1cm4gcmV0Owog
fQogCiBzdGF0aWMgaW50IGlvX3BvbGxfYWRkKHN0cnVjdCBpb19raW9jYiAqcmVxLCB1bnNp
Z25lZCBpbnQgaXNzdWVfZmxhZ3MpCiB7Ci0JaW50IHJldDsKLQotCXJldCA9IF9faW9fcG9s
bF9hZGQocmVxLCBpc3N1ZV9mbGFncyk7Ci0JcmV0dXJuIHJldCA8IDAgPyByZXQgOiAwOwor
CV9faW9fcG9sbF9hZGQocmVxLCBpc3N1ZV9mbGFncyk7CisJcmV0dXJuIDA7CiB9CiAKIHN0
YXRpYyBpbnQgaW9fcG9sbF91cGRhdGUoc3RydWN0IGlvX2tpb2NiICpyZXEsIHVuc2lnbmVk
IGludCBpc3N1ZV9mbGFncykKIHsKIAlzdHJ1Y3QgaW9fcmluZ19jdHggKmN0eCA9IHJlcS0+
Y3R4OwogCXN0cnVjdCBpb19raW9jYiAqcHJlcTsKLQlpbnQgcmV0MiwgcmV0ID0gMDsKKwlp
bnQgcmV0MiA9IC1FQ0FOQ0VMRUQsIHJldCA9IDA7CiAKIAlpb19yaW5nX3N1Ym1pdF9sb2Nr
KGN0eCwgIShpc3N1ZV9mbGFncyAmIElPX1VSSU5HX0ZfTk9OQkxPQ0spKTsKIApAQCAtNjE5
NCw3ICs2MTkwLDcgQEAgc3RhdGljIGludCBpb19wb2xsX3VwZGF0ZShzdHJ1Y3QgaW9fa2lv
Y2IgKnJlcSwgdW5zaWduZWQgaW50IGlzc3VlX2ZsYWdzKQogCQlwcmVxLT5yZXN1bHQgPSBy
ZXQyOwogCiAJfQotCWlmIChwcmVxLT5yZXN1bHQgPCAwKQorCWlmIChyZXQyIDwgMCkKIAkJ
cmVxX3NldF9mYWlsKHByZXEpOwogCWlvX3JlcV9jb21wbGV0ZShwcmVxLCBwcmVxLT5yZXN1
bHQpOwogb3V0OgotLSAKMi41My4wCgo=

--------------tAlOktRJxkv9monnvnCUb0jV--
