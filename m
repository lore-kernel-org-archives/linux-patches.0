Received: from mail-oi1-f171.google.com (mail-oi1-f171.google.com [209.85.167.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 54D6437106E
	for <patches@lists.linux.dev>; Tue, 21 Apr 2026 22:58:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776812338; cv=none; b=ccPdWAHaBAghsactvEFC/Bo/Hsdi2J9zeXu01yXTDxQMOTyBNf3ZbH5jCC7wd0weoZYFLro9ouRdoa8mlNd1AUnzXOZOuyVRv4ULyFJqFcGhsSg9IAQLTVme9j9xuxCyi+YtcjyGdCIgo1VHMWUVZiRqUyWqXK8tKppmXWilqx8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776812338; c=relaxed/simple;
	bh=tVS1I51gR8ialQjV66JTaRvpNhYQyIiFfnHQHHNlOKg=;
	h=Content-Type:Message-ID:Date:MIME-Version:Subject:From:To:Cc:
	 References:In-Reply-To; b=rHeP7axSlGMILB+9ehSTrMm7uQyG493GEnBSRtCrzaV4fsAVRk1RLd5BuET9ZUOX6GQQcVr5h7wozWJEQgbRrv/CLL7NOHMZmoniOW4ck0Z+W9m5L46dJuhR6mptiwBYn/t4wnhxunhc5USr/XxA6INvbuym7APoYJqodVMo2HI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20251104.gappssmtp.com header.i=@kernel-dk.20251104.gappssmtp.com header.b=bCs5EKn3; arc=none smtp.client-ip=209.85.167.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20251104.gappssmtp.com header.i=@kernel-dk.20251104.gappssmtp.com header.b="bCs5EKn3"
Received: by mail-oi1-f171.google.com with SMTP id 5614622812f47-464bba3a9easo2511383b6e.0
        for <patches@lists.linux.dev>; Tue, 21 Apr 2026 15:58:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20251104.gappssmtp.com; s=20251104; t=1776812334; x=1777417134; darn=lists.linux.dev;
        h=in-reply-to:content-language:references:cc:to:from:subject
         :user-agent:mime-version:date:message-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=qCp5VnunPbPtqwjenjYn7N3AFQ6NsGppCcqzyezyOQw=;
        b=bCs5EKn3Fx+Mw5wGZoOsNLPi+48qAN4n0oRRLLz7UGS6qQI8GEgn0q9P6ySDhnHcym
         9C0bMk/R/GdiDsSH2zdvMg92u7YXhsJQu7TgjvJdqrQqtBNgaN390OOidvFH2baFB1Zn
         VA1mRJat88ZGQQqNgaNQTM2ZqmJxAdwZJwpW9n61ZqXg51WGpNnP2tNcgwK9DYM8a/vi
         zQosuO8uBIJo/C/R0JaqdAuplD90VnxaOGDU06CmfSLWQhWmhaF/6Awi6sMhqMHOEcDL
         nEWLpnEG6bcGwEpxyGjeRHJ0f4TvpVqsDV8E3m7p5CBiR1Q/j/VXRFHm6fN72Y+cblR7
         WUoA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776812334; x=1777417134;
        h=in-reply-to:content-language:references:cc:to:from:subject
         :user-agent:mime-version:date:message-id:x-gm-gg:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=qCp5VnunPbPtqwjenjYn7N3AFQ6NsGppCcqzyezyOQw=;
        b=kzZbeYvrKia+WghP39Yrlz8iKKgOo6c4+zChRHUcJ2YlXQxfMYhr3eDzzYzb+7yTP+
         +rNX32Tk61oXD7YbPawGPCLXbACoyvTIQhcjIh0gUnygWCvdXwWzi21olOS2rQjK+uXb
         BFJjvOJqkbUnu+xh5CcgCQ0YJJ1vqutEYMobpPaN7u8lMPOXtxaoRUpDbvsdLvvS3PmS
         2pC0iQ4N91QHNec1GOBmrIjVslXYCzVBKeZYXJe2bcjF+IDV6KKejDtDpIjkPevP1vUU
         a0TpkUTQe6MtjQSx9nsmg0Wgx3HpZIXqKcaGukobOg0fOLmxv2wTQjSAe1bvTdXU1+zM
         Wvqg==
X-Gm-Message-State: AOJu0Yyec9Dg1TjTKm+yYxkIzpFREZAMnY0Qtk3+gkURjspe3Cs1EP4a
	2kwPMMLbSThyY7vsCY1krySKymAmj1K1nNZnTipsQjaZqnZkMIH9pyy9YMx8Zkv3Y7Y=
X-Gm-Gg: AeBDievnLyxoHeRO5s/m8WBbdMQJsHIEXvUyMi65f2qaLCXbJSUpR6VlyTPzE5cJAG8
	fkWUFOqiw2jh6MAcEbsZRp01AmvNTm9aHRAGm1dzX/zAPNVnrWHPUbPhlbyj+GjdloInZ4DrmWV
	QFgB7Jpc6NkY4kH8c4cdFNXuSFGUzGtDM7t1ZPRtwqMpDez4rd201xlIE2r+Pjv1WgWy8pxudV0
	WhIuvDpWCihVe1OjIxLQZ9Z8FcT9k3CuxWMT0DhygmIGai+T7Dk4asI1eWjq2gQdQRPK78OlFOd
	zNcgikDzt4n6iJEcskAmRnty7SugtN+Mbh6IFRt6HBdlCX4r0Iefs8vfoxv6AIr6jihvPRn4eaE
	7jrLSfZ3lSMn851s4xz0mmvo8b4qv0hP9tL+TTrAlb/hq5DdXPJTCW4r+/eg1C2ENvDrF1yt3kO
	hSD12bsRGJsR4FfD0WJs066n7yMOXvoa5iFq3MN0Bju92YFxdEHycVfVFRlCRlb+30OMpgJZZZM
	eJVlNSpdT+S0KCMhuQ+
X-Received: by 2002:a05:6808:690b:b0:467:16e4:d263 with SMTP id 5614622812f47-4799ca9c15emr10810877b6e.44.1776812334343;
        Tue, 21 Apr 2026 15:58:54 -0700 (PDT)
Received: from [192.168.1.150] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id 5614622812f47-4799ff451d9sm9841826b6e.8.2026.04.21.15.58.53
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 21 Apr 2026 15:58:53 -0700 (PDT)
Content-Type: multipart/mixed; boundary="------------A7X9iAKAQsAJ4DD6TaBJvWWc"
Message-ID: <3512c6ae-0b99-4c50-89ed-f1087a558a25@kernel.dk>
Date: Tue, 21 Apr 2026 16:58:52 -0600
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
To: Ben Hutchings <ben@decadent.org.uk>,
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev,
 syzbot+641eec6b7af1f62f2b99@syzkaller.appspotmail.com
References: <20260413155819.042779211@linuxfoundation.org>
 <20260413155837.438151458@linuxfoundation.org>
 <d4b85e905345dc69e9c660c7f51775703fa83320.camel@decadent.org.uk>
 <d7d521e7-35bb-463b-b1f5-552bb931bdff@kernel.dk>
Content-Language: en-US
In-Reply-To: <d7d521e7-35bb-463b-b1f5-552bb931bdff@kernel.dk>

This is a multi-part message in MIME format.
--------------A7X9iAKAQsAJ4DD6TaBJvWWc
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 4/21/26 4:18 PM, Jens Axboe wrote:
>>> @@ -6024,16 +6035,17 @@ static int io_poll_update(struct io_kioc
>>>  		if (req->poll_update.update_user_data)
>>>  			preq->user_data = req->poll_update.new_user_data;
>>>  
>>> -		ret2 = io_poll_add(preq, issue_flags);
>>> +		ret2 = __io_poll_add(preq, issue_flags);
>>>  		/* successfully updated, don't complete poll request */
>>>  		if (!ret2)
>>>  			goto out;
>>> +		preq->result = ret2;
>>> +
>>>  	}
>>> -	req_set_fail(preq);
>>> -	io_req_complete(preq, -ECANCELED);
>>> +	if (preq->result < 0)
>>> +		req_set_fail(preq);
>>> +	io_req_complete(preq, preq->result);
>>
>> If __io_poll_add() returned an events mask then it completed preq, but
>> then we also complete preq here.  Is that really correct?
> 
> Let me take a closer look, I do agree with you that the final result
> does not look entirely correct.

As far as I can tell, these two should be applied to 5.10 and 5.15
stable. The first one fixes an old backporting issue that I didn't
notice until doing some targeted testing just now. The second one should
take care of the issues that Ben spotted in the current backport.

Will be nice when 5.x is finally taken out behind the barn :-)

-- 
Jens Axboe
--------------A7X9iAKAQsAJ4DD6TaBJvWWc
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
--------------A7X9iAKAQsAJ4DD6TaBJvWWc
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

--------------A7X9iAKAQsAJ4DD6TaBJvWWc--
