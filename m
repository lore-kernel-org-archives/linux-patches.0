Received: from mail-ej1-f42.google.com (mail-ej1-f42.google.com [209.85.218.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 90E444207A
	for <patches@lists.linux.dev>; Tue,  7 Jan 2025 01:16:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736212619; cv=none; b=UFvrs703kV2uhXgvOsR3yzUaZiKN1bLiJIJF01fzvXUQoEOibrS8ZH7giMCD4sTXG7venRR8nHFr3/FDqF8srxtnEE83D6T3JJhZYZ2zucJgYJldwZWnIhWynGJqofAqrStm9mrSkWzy4gPmOcHbW+ioPKJjqk51tEBG9FfKD/o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736212619; c=relaxed/simple;
	bh=sLoMUAGWX8CA19mnOsLb9VnLoIPGeUHX9OopTB1vpxo=;
	h=Message-ID:Date:MIME-Version:Subject:From:To:Cc:References:
	 In-Reply-To:Content-Type; b=YqGOKw1V9HFeh/Tezh3X3VjpDY0XqmqpZ5mt1rV/lOME+x1WnPXrZFaEDMxdDWaiy1YfzMYYg3mZDE2aKtzvfuK6FX4exyQq8uHU7JQtb6OXb7SCWAaI4hTBFF6V3b43EP6Oaj/b0J/Upel/c8pG3gS07nFbdGnWR+akrm4a/Wo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com; spf=pass smtp.mailfrom=googlemail.com; dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b=iQG+d7mp; arc=none smtp.client-ip=209.85.218.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=googlemail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b="iQG+d7mp"
Received: by mail-ej1-f42.google.com with SMTP id a640c23a62f3a-aae81f4fdc4so2527105766b.0
        for <patches@lists.linux.dev>; Mon, 06 Jan 2025 17:16:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20230601; t=1736212614; x=1736817414; darn=lists.linux.dev;
        h=in-reply-to:autocrypt:references:cc:to:from:content-language
         :subject:user-agent:mime-version:date:message-id:from:to:cc:subject
         :date:message-id:reply-to;
        bh=sLoMUAGWX8CA19mnOsLb9VnLoIPGeUHX9OopTB1vpxo=;
        b=iQG+d7mpnWaGUN9K7tkWliMCkS6CFQ//VMKPI/nykvDpEGTezIVYt/FxrvXjDzMlsl
         k0+ja9nrHPuC/qjLqhDFbHczdqCw1qnTEFw6xR7EuNx+Vcnj5YN06VHnMzcVNxkcda0e
         mhWq1sgNAlYMPGqGmROiGhJvjK7frQsB8cht+RmND2/kUIQckdjamwD7p0nOyNn8PY57
         J5kSfcE083Gn5Su7cumzsBr41Iw2kmwS7ecBw+i9JYGcgBGf4HccXFm4nr9U/jJpTvXi
         oVA4KC5CdUhOg1CUAtd6zt+qQG3yD6oJvGpBFfqRu0fUdPE9PNeuGnpWgZGAs+XKUwB1
         auKA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1736212614; x=1736817414;
        h=in-reply-to:autocrypt:references:cc:to:from:content-language
         :subject:user-agent:mime-version:date:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=sLoMUAGWX8CA19mnOsLb9VnLoIPGeUHX9OopTB1vpxo=;
        b=mLCZ+9pnfP5rAPN4hix2QdpkqPjJdhHgAh0v5QDdzWw1X2Sri0gNJ9PKuhgyNJm41G
         zSR0JHqljfNEdoLqVqjpvr83dVExBi4yU+k/cvhnfwgC+u4Wp28bDMoSNdeX+BJ6tIDp
         aQlZm8DVUFaAxe10CsZzg3CMANJQpBJhcHbzKCYEUJDTyiJuNrwSfOm5Mk6iW8ZtUfIl
         RMAyEbwRK+7MUKjSsFEbDMmwCdbUcUi2oK8tQJIk6uS+AQrkFgDy5nEp14m0P+3JzCKs
         EXMrtCSMjSkPdxseYHKR+aEevHUlpZjc0xF6jTkScqGrwLUDkej7JV6z2NgMdWBMwA0m
         NNVg==
X-Gm-Message-State: AOJu0YyaPSX+4wtGO3AlkCmLEo/HsvFEDkyplCs7MW8P4BCXeCz2L4/3
	2ezm5ODVqE+jN/0/b5uxpFIR5V8rU/dGo/cs9lMxmf6CA7DSPxk=
X-Gm-Gg: ASbGncuvFqAi/5youhzkqLUZzJlLBuZ57Wpe5URzRj73nZARs0lyZHOEKWBGoV3hKKu
	aFondPBh/kIu+DpS8FufJfhF1dERa7kuuHVzg1RP3k8j76AFzxo72c2AUjVZNJvWyYQ9Wnuat3h
	XojhpBu44nBEGWqO1CeIS0DBg+VAWut5j/LQeTEUQ5vfUTBsxcF7F3NO90MfTXOjjfdWbQH6OvS
	oz3cCcKVGm9QU4gQwr6xJPDMVpJ3dt2iEByMvVZLU/eiRyNrfXhgQS/F+eQvo412nCamg80TTIF
	34GKtTL7ZbXtSpi2vhdU4/wPW0uIhX1u
X-Google-Smtp-Source: AGHT+IEkQgYtlCg4O1QX83/7At53+shUBSsZ//pLT85U1zV72yvwfdJbGQ/vShJgcY7C67lfxaUwHg==
X-Received: by 2002:a17:907:c1c:b0:aa6:8520:718b with SMTP id a640c23a62f3a-aac34218aabmr4999909566b.56.1736212613467;
        Mon, 06 Jan 2025 17:16:53 -0800 (PST)
Received: from [192.168.1.3] (p5b2b4110.dip0.t-ipconnect.de. [91.43.65.16])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-aac0efe49e2sm2319124766b.97.2025.01.06.17.16.51
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 06 Jan 2025 17:16:52 -0800 (PST)
Message-ID: <e335fd7b-1a22-4ce1-b77b-ff74cd311e01@googlemail.com>
Date: Tue, 7 Jan 2025 02:16:51 +0100
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Betterbird (Windows)
Subject: Re: [PATCH 6.6 000/222] 6.6.70-rc1 review
Content-Language: de-DE
From: Peter Schneider <pschneider1968@googlemail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com, broonie@kernel.org
References: <20250106151150.585603565@linuxfoundation.org>
 <896ab5a8-e86b-4176-812f-9111b44df90a@googlemail.com>
Autocrypt: addr=pschneider1968@googlemail.com; keydata=
 xjMEY58biBYJKwYBBAHaRw8BAQdADPnoGTrfCUCyH7SZVkFtnlzsFpeKANckofR4WVLMtMzN
 L1BldGVyIFNjaG5laWRlciA8cHNjaG5laWRlcjE5NjhAZ29vZ2xlbWFpbC5jb20+wpwEExYK
 AEQCGyMFCQW15qgFCwkIBwICIgIGFQoJCAsCBBYCAwECHgcCF4AWIQSjgovXlszhGoyt6IZu
 OpLJLD/yRAUCY58b8AIZAQAKCRBuOpLJLD/yRIeIAQD0+/LMdKHM6AJdPCt+e9Z92BMybfnN
 RtGqkdZWtvdhDQD9FJkGh/3PFtDinimB8UOB7Gi6AGxt9Nu9ne7PvHa0KQXOOARjnxuIEgor
 BgEEAZdVAQUBAQdAw2GRwTf5HJlO6CCigzqH6GUKOjqR1xJ+3nR5EbBze0sDAQgHwn4EGBYK
 ACYWIQSjgovXlszhGoyt6IZuOpLJLD/yRAUCY58biAIbDAUJBbXmqAAKCRBuOpLJLD/yRONS
 AQCwB9qiEQoSnxHodu8kRuvUxXKIqN7701W+INXtFGtJygEAyPZH3/vSBJ4A7GUG7BZyQRcr
 ryS0CUq77B7ZkcI1Nwo=
In-Reply-To: <896ab5a8-e86b-4176-812f-9111b44df90a@googlemail.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="------------DDsZUs55kKXZcwEr06HZrzBT"

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--------------DDsZUs55kKXZcwEr06HZrzBT
Content-Type: multipart/mixed; boundary="------------PyxSYkEGvGh5606uSO3bXLaQ";
 protected-headers="v1"
From: Peter Schneider <pschneider1968@googlemail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com, broonie@kernel.org
Message-ID: <e335fd7b-1a22-4ce1-b77b-ff74cd311e01@googlemail.com>
Subject: Re: [PATCH 6.6 000/222] 6.6.70-rc1 review
References: <20250106151150.585603565@linuxfoundation.org>
 <896ab5a8-e86b-4176-812f-9111b44df90a@googlemail.com>
In-Reply-To: <896ab5a8-e86b-4176-812f-9111b44df90a@googlemail.com>

--------------PyxSYkEGvGh5606uSO3bXLaQ
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: base64

QW0gMDcuMDEuMjAyNSB1bSAwMTozNiBzY2hyaWViIFBldGVyIFNjaG5laWRlcjoNCj4gQW0g
MDYuMDEuMjAyNSB1bSAxNjoxMyBzY2hyaWViIEdyZWcgS3JvYWgtSGFydG1hbjoNCj4+IFRo
aXMgaXMgdGhlIHN0YXJ0IG9mIHRoZSBzdGFibGUgcmV2aWV3IGN5Y2xlIGZvciB0aGUgNi42
LjcwIHJlbGVhc2UuDQo+PiBUaGVyZSBhcmUgMjIyIHBhdGNoZXMgaW4gdGhpcyBzZXJpZXMs
IGFsbCB3aWxsIGJlIHBvc3RlZCBhcyBhIHJlc3BvbnNlDQo+PiB0byB0aGlzIG9uZS7CoCBJ
ZiBhbnlvbmUgaGFzIGFueSBpc3N1ZXMgd2l0aCB0aGVzZSBiZWluZyBhcHBsaWVkLCBwbGVh
c2UNCj4+IGxldCBtZSBrbm93Lg0KPiANCj4gNi42LjcwLXJjMSBidWlsZHMsIGJvb3RzIGFu
ZCBzZWVtcyB0byB3b3JrIG9uIG15IDItc29ja2V0IEl2eSBCcmlkZ2UgWGVvbiBFNS0yNjk3
IHYyIA0KPiBzZXJ2ZXIsIGJ1dCBJIHNlZSBhIHNjYXJ5IGxvb2tpbmcgZG1lc2cgd2Fybmlu
ZywgcmlnaHQgYWZ0ZXIgYm9vdGluZy4gQXMgaXQgaXMgY3VycmVudGx5IA0KPiBydW5uaW5n
LCBJIHdpbGwgdHJ5IGJ1aWxkaW5nIDYuMTIuOS1yYyB3aXRoIGl0LCBhbmQgc2VlIGhvdyB0
aGF0IGdvZXMuIFRoZSBkbWVzZyB3YXJuaW5ncyANCj4gSSBzZWUgbG9vayBzaW1pbGFyIHRv
IHRoYXQgYWxyZWFkeSByZXBvcnRlZCBieSBNaWd1ZWwgT2plZGEuDQoNClsuLi5dDQoNClNv
IHJ1bm5pbmcgNi42LjcwLXJjMSwgZGVzcGl0ZSB0aGUgYWJvdmUgbWVudGlvbmVkIGluaXRp
YWwgd2FybmluZyBtZXNzYWdlLCBJIGNvdWxkIGJ1aWxkIA0KNi4xMi45LXJjMSBqdXN0IGZp
bmUgd2l0aCBpdC4gSXQgdG9vayB0aGUgdXN1YWwgfjIwIG1pbnV0ZXMsIGFuZCBubyBtb3Jl
IGRtZXNncyB3YXJuaW5nIA0KaGF2ZSBiZWVuIGFkZGVkLg0KDQpCZXN0ZSBHcsO8w59lLA0K
UGV0ZXIgU2NobmVpZGVyDQoNCi0tIA0KQ2xpbWIgdGhlIG1vdW50YWluIG5vdCB0byBwbGFu
dCB5b3VyIGZsYWcsIGJ1dCB0byBlbWJyYWNlIHRoZSBjaGFsbGVuZ2UsDQplbmpveSB0aGUg
YWlyIGFuZCBiZWhvbGQgdGhlIHZpZXcuIENsaW1iIGl0IHNvIHlvdSBjYW4gc2VlIHRoZSB3
b3JsZCwNCm5vdCBzbyB0aGUgd29ybGQgY2FuIHNlZSB5b3UuICAgICAgICAgICAgICAgICAg
ICAtLSBEYXZpZCBNY0N1bGxvdWdoIEpyLg0KDQpPcGVuUEdQOiAgMHhBMzgyOEJENzk2Q0NF
MTFBOENBREU4ODY2RTNBOTJDOTJDM0ZGMjQ0DQpEb3dubG9hZDogaHR0cHM6Ly93d3cucGV0
ZXJzLW5ldHpwbGF0ei5kZS9kb3dubG9hZC9wc2NobmVpZGVyMTk2OF9wdWIuYXNjDQpodHRw
czovL2tleXMubWFpbHZlbG9wZS5jb20vcGtzL2xvb2t1cD9vcD1nZXQmc2VhcmNoPXBzY2hu
ZWlkZXIxOTY4QGdvb2dsZW1haWwuY29tDQpodHRwczovL2tleXMubWFpbHZlbG9wZS5jb20v
cGtzL2xvb2t1cD9vcD1nZXQmc2VhcmNoPXBzY2huZWlkZXIxOTY4QGdtYWlsLmNvbQ0KDQo=


--------------PyxSYkEGvGh5606uSO3bXLaQ--

--------------DDsZUs55kKXZcwEr06HZrzBT
Content-Type: application/pgp-signature; name="OpenPGP_signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="OpenPGP_signature.asc"

-----BEGIN PGP SIGNATURE-----

wnsEABYIACMWIQSjgovXlszhGoyt6IZuOpLJLD/yRAUCZ3yAgwUDAAAAAAAKCRBuOpLJLD/yRNy7
AP4nNXptFiaR9LDac8Nab8HKP6dquItWTlTTKA91sBe4UgD/RzQFZLz8UhRkxlt5rdS9THS4DcSJ
XNtVrqHVpux/hg8=
=Ffjx
-----END PGP SIGNATURE-----

--------------DDsZUs55kKXZcwEr06HZrzBT--
