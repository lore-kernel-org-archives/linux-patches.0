Received: from mail-ej1-f47.google.com (mail-ej1-f47.google.com [209.85.218.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 956F023D288
	for <patches@lists.linux.dev>; Wed, 26 Nov 2025 14:13:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764166429; cv=none; b=IsYSY+v1VVKaq1Olyzq0fTG9qiprUEvZJlmT8GMyjBqARwwDVSEV/14MPoVZnKZSn6bX8Q3gWYLo1saQ7eSmYnsG/lPDlBjuDYwsJtkMHHrQbM5V5x9x4jAlkw6fpreH8cc/4nluyxShs0OswV2fEuXpNhtV1krkG+GwzqsUU2s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764166429; c=relaxed/simple;
	bh=+hA4IE8EPhIuDjv81rqsngjYwPxJbPcF6gLtoajjBRg=;
	h=Content-Type:Message-ID:Date:MIME-Version:Subject:To:Cc:
	 References:From:In-Reply-To; b=Pk8i8Rhgazcyrg35Svf5hrQLwDAEQo88N7vxcbhjwGDSGLAcitRdZvgv1N03DjT1Yk1JafWrvWnWYKl8OMgMnHPSwO1MHxalYe3EafS/KkTLaFLdiyOhmYZn5GjrjOFLWNq6+BS5Dqbd61+f3hMgN5wGbdo5r/rsPWYoQhQt0RQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=Ji22oBA/; arc=none smtp.client-ip=209.85.218.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="Ji22oBA/"
Received: by mail-ej1-f47.google.com with SMTP id a640c23a62f3a-b735ce67d1dso1054785366b.3
        for <patches@lists.linux.dev>; Wed, 26 Nov 2025 06:13:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1764166425; x=1764771225; darn=lists.linux.dev;
        h=in-reply-to:from:content-language:references:cc:to:subject
         :user-agent:mime-version:date:message-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Da5raVUjdzc1+pnJeLlOaEeJlsyIGS3AMp/0wMIl9vY=;
        b=Ji22oBA/WyfgciFlxQ8u0FkTifvRJ7J0OHNmd3sxVxWRDPMbIKFxHutN+pOjSWcSVA
         HCvQLgNsr9g2BWFfVa3iLXCr6EFrMTJxwKLJHGpXSpk9E8/pDkiLg6qi/UlumHzQBfse
         Ns6SKBeDtGeD054Kag47o917BGsLVW5ENtwWdhlxH0t0jGnnLI4PaUVTicJWFRfMn6z9
         ajjnQS9KQI7szBXGvFf3WD9Ss61sax8h4sh9LO9aAXxVK7+bwXqzqzYHYiBVcTAT1m4K
         rkfhLSttOUUMSMerrlOqKZDhQ7YvikG7oodjvL8bp5ZJcAIlsd0rM02/0COuJGs6UV+i
         vPHA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764166425; x=1764771225;
        h=in-reply-to:from:content-language:references:cc:to:subject
         :user-agent:mime-version:date:message-id:x-gm-gg:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Da5raVUjdzc1+pnJeLlOaEeJlsyIGS3AMp/0wMIl9vY=;
        b=Tqo/s2XjEjZ/FPV5f2UK5HAF70KdZW0pozl+6cqwt+vQIjN+WehbcaKPjMvdjNYDad
         m61zMx5P1w/y1Y92g0huhFP3o9OFXZFuP5ybfkfVBDDPMUuUetOerPpNSc8CEZjATJaZ
         PeWwsDZTacqShflfZkPCTn7UHHue61NhBjrscMVmiPlSwbGHfGxO1LraV0qR48Ytuxxs
         1vpTXen0qlOv/gHf+wBipaswJtT6nztFXxQtSF/u0dZ3nNWrALU7rweqC84+jZdPnRhE
         i6HGa0ngDUOjX4+32NeVi+EP4QU3pdrShiDMqOp6bBeGqX0cfKuZWZ1DBWXtcd6BjwFo
         DSOg==
X-Gm-Message-State: AOJu0YwsxvS+2gI6kQaiE6rrO2Y3JWMLihz7YlqZeRo/fdV+G8YVhPWD
	hpOksW6kwOxCt2issNcnuchwJouh+W2yRwTE/3emXo5DptjqI3xeLTOttiBzO4xRmPE=
X-Gm-Gg: ASbGnctLxy5HYyCxLy9mCvN9r/sFFhNH0l9Bj0xkEviqhQQyNdllJORcQPfg5EttiXe
	TORB9czxiPQ+oRoHTmCCAQ5OD0foAHvW7aMKX7L8Ztfzx1PBHIPZ4yJlNKqjErNJn6kUF8ECceQ
	rEIl9eWCFaZx+aVEKSfeL8XjRpt1I8cdjNQhHBy2cqq+4tXSntKTQipkPywCtV9t7W5QQLR6hCi
	M3BCpzvCW7Djjby3/Os/jU0jleCw+gmXRiUTcTXGs6LwFcAcuvftBzy4Llwl2D66ilkEOaJSUSc
	+MvLcVWguYZh1YqmktoiVn046dVT18Wv8Y6auOMEEW0n6+EF1aZt9kYRvhpfrg3ZyZi5i9bChSr
	NWVVgAnkgeusBXuJ0e+O55WQTp4DfiM7bwafhfIGl9jeg8hIdLZEs9T4nygHKl55DX/XagxHMXE
	WWHp7GS3QE0AKNBSwERazc/jcu/8CBD4Ul09HTF6LB0rajVkEYErmPoMQA
X-Google-Smtp-Source: AGHT+IFIZ9lvI7Pz6taNQRDIsjsZGFJuvltZHL4+Hzgk3QXKmNiZVQPVoQtJV8OeLtVVcbz+AcdUVw==
X-Received: by 2002:a17:907:3e1c:b0:b73:4006:1877 with SMTP id a640c23a62f3a-b76c558b96bmr773789566b.55.1764166424789;
        Wed, 26 Nov 2025 06:13:44 -0800 (PST)
Received: from [192.168.15.14] (189-47-60-231.dsl.telesp.net.br. [189.47.60.231])
        by smtp.gmail.com with ESMTPSA id 46e09a7af769-7c78d32cbd9sm7476014a34.11.2025.11.26.06.13.42
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 26 Nov 2025 06:13:44 -0800 (PST)
Content-Type: multipart/mixed; boundary="------------Dp0bB0Wsmy7f4MoUq0ZVWneR"
Message-ID: <2f9985eb-e180-44f4-9185-b863826245f9@suse.com>
Date: Wed, 26 Nov 2025 11:11:30 -0300
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.17 817/849] smb: client: fix potential UAF in
 smb2_close_cached_fid()
To: Jiri Slaby <jirislaby@kernel.org>,
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, Jay Shin <jaeshin@redhat.com>,
 "Paulo Alcantara (Red Hat)" <pc@manguebit.org>,
 Steve French <stfrench@microsoft.com>
References: <20251111004536.460310036@linuxfoundation.org>
 <20251111004556.178148239@linuxfoundation.org>
 <ed7d962e-b350-4986-ae92-14509306ea65@kernel.org>
Content-Language: en-US
From: Henrique Carvalho <henrique.carvalho@suse.com>
In-Reply-To: <ed7d962e-b350-4986-ae92-14509306ea65@kernel.org>

This is a multi-part message in MIME format.
--------------Dp0bB0Wsmy7f4MoUq0ZVWneR
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 11/26/25 3:47 AM, Jiri Slaby wrote:
> On 11. 11. 25, 1:46, Greg Kroah-Hartman wrote:
>> 6.17-stable review patch.  If anyone has any objections, please let me
>> know.
>>
>> ------------------
>>
>> From: Henrique Carvalho <henrique.carvalho@suse.com>
>>
>> commit 734e99623c5b65bf2c03e35978a0b980ebc3c2f8 upstream.
...
> 
> This _backport_ (of a 6.18-rc5 commit) omits to change
> cfids_invalidation_worker() which was removed in 6.18-rc1 by:
> 7ae6152b7831 smb: client: remove cfids_invalidation_worker
> 
> This likely causes:
> https://bugzilla.suse.com/show_bug.cgi?id=1254096
> BUG: workqueue leaked atomic, lock or RCU
> 
> Because cfids_invalidation_worker() still does:
>                 kref_put(&cfid->refcount, smb2_close_cached_fid);
> instead of now required kref_put_lock() aka:
>                 close_cached_dir(cfid);
> 
> thanks,

Thanks, Jiri.

I'm sending the updated patch attached.

This new version should also replace the patch backported to stable
versions:

- 6.12.y (065bd62412271a2d734810dd50336cae88c54427)
- 6.6.y (cb52d9c86d70298de0ab7c7953653898cbc0efd6)

Alternatively, I'm sending just the fix ("smb: client: fix incomplete
backport in cfids_invalidation_worker()").

-- 
Henrique
SUSE Labs
--------------Dp0bB0Wsmy7f4MoUq0ZVWneR
Content-Type: text/x-patch; charset=UTF-8;
 name="0001-smb-client-fix-potential-UAF-in-smb2_close_cached_fi.patch"
Content-Disposition: attachment;
 filename*0="0001-smb-client-fix-potential-UAF-in-smb2_close_cached_fi.pa";
 filename*1="tch"
Content-Transfer-Encoding: base64

RnJvbSBkNWQzM2E3NTFlOWQwOTlkNDZmNDhkYmE0MGI4Yjc3ZWM2YzA0MDdhIE1vbiBTZXAg
MTcgMDA6MDA6MDAgMjAwMQpGcm9tOiBIZW5yaXF1ZSBDYXJ2YWxobyA8aGVucmlxdWUuY2Fy
dmFsaG9Ac3VzZS5jb20+CkRhdGU6IE1vbiwgMyBOb3YgMjAyNSAxOTo1Mjo1NSAtMDMwMApT
dWJqZWN0OiBbUEFUQ0hdIHNtYjogY2xpZW50OiBmaXggcG90ZW50aWFsIFVBRiBpbiBzbWIy
X2Nsb3NlX2NhY2hlZF9maWQoKQoKY29tbWl0IDczNGU5OTYyM2M1YjY1YmYyYzAzZTM1OTc4
YTBiOTgwZWJjM2MyZjggdXBzdHJlYW0uCgpmaW5kX29yX2NyZWF0ZV9jYWNoZWRfZGlyKCkg
Y291bGQgZ3JhYiBhIG5ldyByZWZlcmVuY2UgYWZ0ZXIga3JlZl9wdXQoKQpoYWQgc2VlbiB0
aGUgcmVmY291bnQgZHJvcCB0byB6ZXJvIGJ1dCBiZWZvcmUgY2ZpZF9saXN0X2xvY2sgaXMg
YWNxdWlyZWQKaW4gc21iMl9jbG9zZV9jYWNoZWRfZmlkKCksIGxlYWRpbmcgdG8gdXNlLWFm
dGVyLWZyZWUuCgpTd2l0Y2ggdG8ga3JlZl9wdXRfbG9jaygpIHNvIGNmaWRfcmVsZWFzZSgp
IGlzIGNhbGxlZCB3aXRoCmNmaWRfbGlzdF9sb2NrIGhlbGQsIGNsb3NpbmcgdGhhdCBnYXAu
CgpGaXhlczogZWJlOThmMTQ0N2JiICgiY2lmczogZW5hYmxlIGNhY2hpbmcgb2YgZGlyZWN0
b3JpZXMgZm9yIHdoaWNoIGEgbGVhc2UgaXMgaGVsZCIpCkNjOiBzdGFibGVAdmdlci5rZXJu
ZWwub3JnClJlcG9ydGVkLWJ5OiBKYXkgU2hpbiA8amFlc2hpbkByZWRoYXQuY29tPgpSZXZp
ZXdlZC1ieTogUGF1bG8gQWxjYW50YXJhIChSZWQgSGF0KSA8cGNAbWFuZ3VlYml0Lm9yZz4K
U2lnbmVkLW9mZi1ieTogSGVucmlxdWUgQ2FydmFsaG8gPGhlbnJpcXVlLmNhcnZhbGhvQHN1
c2UuY29tPgpTaWduZWQtb2ZmLWJ5OiBTdGV2ZSBGcmVuY2ggPHN0ZnJlbmNoQG1pY3Jvc29m
dC5jb20+ClNpZ25lZC1vZmYtYnk6IEdyZWcgS3JvYWgtSGFydG1hbiA8Z3JlZ2toQGxpbnV4
Zm91bmRhdGlvbi5vcmc+Ci0tLQogZnMvc21iL2NsaWVudC9jYWNoZWRfZGlyLmMgfCAxOCAr
KysrKysrKysrLS0tLS0tLS0KIDEgZmlsZSBjaGFuZ2VkLCAxMCBpbnNlcnRpb25zKCspLCA4
IGRlbGV0aW9ucygtKQoKZGlmZiAtLWdpdCBhL2ZzL3NtYi9jbGllbnQvY2FjaGVkX2Rpci5j
IGIvZnMvc21iL2NsaWVudC9jYWNoZWRfZGlyLmMKaW5kZXggY2M4NTdhMDMwYTc3Li5lOTUy
YWZkNThmMjYgMTAwNjQ0Ci0tLSBhL2ZzL3NtYi9jbGllbnQvY2FjaGVkX2Rpci5jCisrKyBi
L2ZzL3NtYi9jbGllbnQvY2FjaGVkX2Rpci5jCkBAIC0zODksMTEgKzM4OSwxMSBAQCBpbnQg
b3Blbl9jYWNoZWRfZGlyKHVuc2lnbmVkIGludCB4aWQsIHN0cnVjdCBjaWZzX3Rjb24gKnRj
b24sCiAJCQkgKiBsZWFzZS4gUmVsZWFzZSBvbmUgaGVyZSwgYW5kIHRoZSBzZWNvbmQgYmVs
b3cuCiAJCQkgKi8KIAkJCWNmaWQtPmhhc19sZWFzZSA9IGZhbHNlOwotCQkJa3JlZl9wdXQo
JmNmaWQtPnJlZmNvdW50LCBzbWIyX2Nsb3NlX2NhY2hlZF9maWQpOworCQkJY2xvc2VfY2Fj
aGVkX2RpcihjZmlkKTsKIAkJfQogCQlzcGluX3VubG9jaygmY2ZpZHMtPmNmaWRfbGlzdF9s
b2NrKTsKIAotCQlrcmVmX3B1dCgmY2ZpZC0+cmVmY291bnQsIHNtYjJfY2xvc2VfY2FjaGVk
X2ZpZCk7CisJCWNsb3NlX2NhY2hlZF9kaXIoY2ZpZCk7CiAJfSBlbHNlIHsKIAkJKnJldF9j
ZmlkID0gY2ZpZDsKIAkJYXRvbWljX2luYygmdGNvbi0+bnVtX3JlbW90ZV9vcGVucyk7CkBA
IC00MzQsMTIgKzQzNCwxNCBAQCBpbnQgb3Blbl9jYWNoZWRfZGlyX2J5X2RlbnRyeShzdHJ1
Y3QgY2lmc190Y29uICp0Y29uLAogCiBzdGF0aWMgdm9pZAogc21iMl9jbG9zZV9jYWNoZWRf
ZmlkKHN0cnVjdCBrcmVmICpyZWYpCitfX3JlbGVhc2VzKCZjZmlkLT5jZmlkcy0+Y2ZpZF9s
aXN0X2xvY2spCiB7CiAJc3RydWN0IGNhY2hlZF9maWQgKmNmaWQgPSBjb250YWluZXJfb2Yo
cmVmLCBzdHJ1Y3QgY2FjaGVkX2ZpZCwKIAkJCQkJICAgICAgIHJlZmNvdW50KTsKIAlpbnQg
cmM7CiAKLQlzcGluX2xvY2soJmNmaWQtPmNmaWRzLT5jZmlkX2xpc3RfbG9jayk7CisJbG9j
a2RlcF9hc3NlcnRfaGVsZCgmY2ZpZC0+Y2ZpZHMtPmNmaWRfbGlzdF9sb2NrKTsKKwogCWlm
IChjZmlkLT5vbl9saXN0KSB7CiAJCWxpc3RfZGVsKCZjZmlkLT5lbnRyeSk7CiAJCWNmaWQt
Pm9uX2xpc3QgPSBmYWxzZTsKQEAgLTQ3NCw3ICs0NzYsNyBAQCB2b2lkIGRyb3BfY2FjaGVk
X2Rpcl9ieV9uYW1lKGNvbnN0IHVuc2lnbmVkIGludCB4aWQsIHN0cnVjdCBjaWZzX3Rjb24g
KnRjb24sCiAJc3Bpbl9sb2NrKCZjZmlkLT5jZmlkcy0+Y2ZpZF9saXN0X2xvY2spOwogCWlm
IChjZmlkLT5oYXNfbGVhc2UpIHsKIAkJY2ZpZC0+aGFzX2xlYXNlID0gZmFsc2U7Ci0JCWty
ZWZfcHV0KCZjZmlkLT5yZWZjb3VudCwgc21iMl9jbG9zZV9jYWNoZWRfZmlkKTsKKwkJY2xv
c2VfY2FjaGVkX2RpcihjZmlkKTsKIAl9CiAJc3Bpbl91bmxvY2soJmNmaWQtPmNmaWRzLT5j
ZmlkX2xpc3RfbG9jayk7CiAJY2xvc2VfY2FjaGVkX2RpcihjZmlkKTsKQEAgLTQ4Myw3ICs0
ODUsNyBAQCB2b2lkIGRyb3BfY2FjaGVkX2Rpcl9ieV9uYW1lKGNvbnN0IHVuc2lnbmVkIGlu
dCB4aWQsIHN0cnVjdCBjaWZzX3Rjb24gKnRjb24sCiAKIHZvaWQgY2xvc2VfY2FjaGVkX2Rp
cihzdHJ1Y3QgY2FjaGVkX2ZpZCAqY2ZpZCkKIHsKLQlrcmVmX3B1dCgmY2ZpZC0+cmVmY291
bnQsIHNtYjJfY2xvc2VfY2FjaGVkX2ZpZCk7CisJa3JlZl9wdXRfbG9jaygmY2ZpZC0+cmVm
Y291bnQsIHNtYjJfY2xvc2VfY2FjaGVkX2ZpZCwgJmNmaWQtPmNmaWRzLT5jZmlkX2xpc3Rf
bG9jayk7CiB9CiAKIC8qCkBAIC01OTQsNyArNTk2LDcgQEAgY2FjaGVkX2Rpcl9vZmZsb2Fk
X2Nsb3NlKHN0cnVjdCB3b3JrX3N0cnVjdCAqd29yaykKIAogCVdBUk5fT04oY2ZpZC0+b25f
bGlzdCk7CiAKLQlrcmVmX3B1dCgmY2ZpZC0+cmVmY291bnQsIHNtYjJfY2xvc2VfY2FjaGVk
X2ZpZCk7CisJY2xvc2VfY2FjaGVkX2RpcihjZmlkKTsKIAljaWZzX3B1dF90Y29uKHRjb24s
IG5ldGZzX3RyYWNlX3Rjb25fcmVmX3B1dF9jYWNoZWRfY2xvc2UpOwogfQogCkBAIC03MTgs
NyArNzIwLDcgQEAgc3RhdGljIHZvaWQgY2ZpZHNfaW52YWxpZGF0aW9uX3dvcmtlcihzdHJ1
Y3Qgd29ya19zdHJ1Y3QgKndvcmspCiAJbGlzdF9mb3JfZWFjaF9lbnRyeV9zYWZlKGNmaWQs
IHEsICZlbnRyeSwgZW50cnkpIHsKIAkJbGlzdF9kZWwoJmNmaWQtPmVudHJ5KTsKIAkJLyog
RHJvcCB0aGUgcmVmLWNvdW50IGFjcXVpcmVkIGluIGludmFsaWRhdGVfYWxsX2NhY2hlZF9k
aXJzICovCi0JCWtyZWZfcHV0KCZjZmlkLT5yZWZjb3VudCwgc21iMl9jbG9zZV9jYWNoZWRf
ZmlkKTsKKwkJY2xvc2VfY2FjaGVkX2RpcihjZmlkKTsKIAl9CiB9CiAKQEAgLTc3MSw3ICs3
NzMsNyBAQCBzdGF0aWMgdm9pZCBjZmlkc19sYXVuZHJvbWF0X3dvcmtlcihzdHJ1Y3Qgd29y
a19zdHJ1Y3QgKndvcmspCiAJCQkgKiBEcm9wIHRoZSByZWYtY291bnQgZnJvbSBhYm92ZSwg
ZWl0aGVyIHRoZSBsZWFzZS1yZWYgKGlmIHRoZXJlCiAJCQkgKiB3YXMgb25lKSBvciB0aGUg
ZXh0cmEgb25lIGFjcXVpcmVkLgogCQkJICovCi0JCQlrcmVmX3B1dCgmY2ZpZC0+cmVmY291
bnQsIHNtYjJfY2xvc2VfY2FjaGVkX2ZpZCk7CisJCQljbG9zZV9jYWNoZWRfZGlyKGNmaWQp
OwogCX0KIAlxdWV1ZV9kZWxheWVkX3dvcmsoY2ZpZF9wdXRfd3EsICZjZmlkcy0+bGF1bmRy
b21hdF93b3JrLAogCQkJICAgZGlyX2NhY2hlX3RpbWVvdXQgKiBIWik7Ci0tIAoyLjUwLjEK
Cg==
--------------Dp0bB0Wsmy7f4MoUq0ZVWneR
Content-Type: text/x-patch; charset=UTF-8;
 name="0001-smb-client-fix-incomplete-backport-in-cfids_invalida.patch"
Content-Disposition: attachment;
 filename*0="0001-smb-client-fix-incomplete-backport-in-cfids_invalida.pa";
 filename*1="tch"
Content-Transfer-Encoding: base64

RnJvbSAzOGVmODUxNDVmZDM2NTVjZDRhYzE2NTc4ODcxYWZkYzBhYTY2MzZmIE1vbiBTZXAg
MTcgMDA6MDA6MDAgMjAwMQpGcm9tOiBIZW5yaXF1ZSBDYXJ2YWxobyA8aGVucmlxdWUuY2Fy
dmFsaG9Ac3VzZS5jb20+CkRhdGU6IFdlZCwgMjYgTm92IDIwMjUgMTA6NTU6NTMgLTAzMDAK
U3ViamVjdDogW1BBVENIXSBzbWI6IGNsaWVudDogZml4IGluY29tcGxldGUgYmFja3BvcnQg
aW4KIGNmaWRzX2ludmFsaWRhdGlvbl93b3JrZXIoKQoKVGhlIHByZXZpb3VzIGNvbW1pdCBi
ZGI1OTZjZWI0YjcgKCJzbWI6IGNsaWVudDogZml4IHBvdGVudGlhbCBVQUYgaW4Kc21iMl9j
bG9zZV9jYWNoZWRfZmlkKCkiKSB3YXMgYW4gaW5jb21wbGV0ZSBiYWNrcG9ydCBhbmQgbWlz
c2VkIG9uZQprcmVmX3B1dCgpIGNhbGwgaW4gY2ZpZHNfaW52YWxpZGF0aW9uX3dvcmtlcigp
IHRoYXQgc2hvdWxkIGhhdmUgYmVlbgpjb252ZXJ0ZWQgdG8gY2xvc2VfY2FjaGVkX2Rpcigp
LgoKRml4ZXM6IGJkYjU5NmNlYjRiNyAoInNtYjogY2xpZW50OiBmaXggcG90ZW50aWFsIFVB
RiBpbiBzbWIyX2Nsb3NlX2NhY2hlZF9maWQoKSIpIgpTaWduZWQtb2ZmLWJ5OiBIZW5yaXF1
ZSBDYXJ2YWxobyA8aGVucmlxdWUuY2FydmFsaG9Ac3VzZS5jb20+Ci0tLQogZnMvc21iL2Ns
aWVudC9jYWNoZWRfZGlyLmMgfCAyICstCiAxIGZpbGUgY2hhbmdlZCwgMSBpbnNlcnRpb24o
KyksIDEgZGVsZXRpb24oLSkKCmRpZmYgLS1naXQgYS9mcy9zbWIvY2xpZW50L2NhY2hlZF9k
aXIuYyBiL2ZzL3NtYi9jbGllbnQvY2FjaGVkX2Rpci5jCmluZGV4IDFhYjczN2ZmZWRmZS4u
ZTk1MmFmZDU4ZjI2IDEwMDY0NAotLS0gYS9mcy9zbWIvY2xpZW50L2NhY2hlZF9kaXIuYwor
KysgYi9mcy9zbWIvY2xpZW50L2NhY2hlZF9kaXIuYwpAQCAtNzIwLDcgKzcyMCw3IEBAIHN0
YXRpYyB2b2lkIGNmaWRzX2ludmFsaWRhdGlvbl93b3JrZXIoc3RydWN0IHdvcmtfc3RydWN0
ICp3b3JrKQogCWxpc3RfZm9yX2VhY2hfZW50cnlfc2FmZShjZmlkLCBxLCAmZW50cnksIGVu
dHJ5KSB7CiAJCWxpc3RfZGVsKCZjZmlkLT5lbnRyeSk7CiAJCS8qIERyb3AgdGhlIHJlZi1j
b3VudCBhY3F1aXJlZCBpbiBpbnZhbGlkYXRlX2FsbF9jYWNoZWRfZGlycyAqLwotCQlrcmVm
X3B1dCgmY2ZpZC0+cmVmY291bnQsIHNtYjJfY2xvc2VfY2FjaGVkX2ZpZCk7CisJCWNsb3Nl
X2NhY2hlZF9kaXIoY2ZpZCk7CiAJfQogfQogCi0tIAoyLjUwLjEKCg==

--------------Dp0bB0Wsmy7f4MoUq0ZVWneR--
