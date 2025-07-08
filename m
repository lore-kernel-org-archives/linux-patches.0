Received: from smtpbgjp3.qq.com (smtpbgjp3.qq.com [54.92.39.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8409A10A1F
	for <patches@lists.linux.dev>; Tue,  8 Jul 2025 08:03:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=54.92.39.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751961829; cv=none; b=TKi3IhhxBngAgm09kogw+lOUxMJQ+iUWHo5GWfIV2AkV327+GqHu3JYG36A4BN+f5Jfq/rPutkGtQ+clb1qGPED0ft8n0UZQDv0UUiXKOh4JQgwlNfp7o0iKTYhX+OXykV2KGBS/vH9uChqCPtm+drBOf9dfFlOd+SiTJJ36ll0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751961829; c=relaxed/simple;
	bh=b2r0ujkSeGroM/GqApvkkP3Drg1BXmX6t2wZTGwJfrw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=BuVtKjtzYLML9YymnXBvyA8UAIDa9tnVji6oIOynJmFYfjZ5Ba1CLa0qLaXHsAVihk11dJ+vWosa6/NZYANEPvrNMf2wCJt14QTULi3JFlz0n/bEgcgV1/EOUhnIorEeCLrK058qFokQgzFZLjclc1SizcKY94JVmx2oXn2NakI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=uniontech.com; spf=pass smtp.mailfrom=uniontech.com; dkim=pass (1024-bit key) header.d=uniontech.com header.i=@uniontech.com header.b=FIf3tsxI; arc=none smtp.client-ip=54.92.39.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=uniontech.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=uniontech.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=uniontech.com header.i=@uniontech.com header.b="FIf3tsxI"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=uniontech.com;
	s=onoh2408; t=1751960739;
	bh=b2r0ujkSeGroM/GqApvkkP3Drg1BXmX6t2wZTGwJfrw=;
	h=Message-ID:Date:MIME-Version:Subject:To:From;
	b=FIf3tsxIY8fYV5W2cgs+w97dmFaAWMl8OEbSyi9bGcCCns/RDVqlro9WujOjrXa9J
	 23MunrWo9cKFrvdNlM6B/h/Y+rblI98nTdwexs1pWVvSMHH079KkFwqbPztErloVQe
	 tkaFZLC/gm2Yrn5z/KP6mF7XodCQMmhNtVLH5HoE=
X-QQ-mid: zesmtpip2t1751960718tc12a1d04
X-QQ-Originating-IP: mTg1DJEddB7wGVp24meqZ593oE4WfO8CoTFpcTWYsV4=
Received: from [IPV6:240e:668:120a::212:232] ( [localhost])
	by bizesmtp.qq.com (ESMTP) with 
	id ; Tue, 08 Jul 2025 15:45:16 +0800 (CST)
X-QQ-SSF: 0000000000000000000000000000000
X-QQ-GoodBg: 1
X-BIZMAIL-ID: 9855057718642021363
EX-QQ-RecipientCnt: 9
Message-ID: <572685AD12256749+e24050a6-dde6-4447-8b45-69578b352e5f@uniontech.com>
Date: Tue, 8 Jul 2025 15:45:16 +0800
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.6 129/139] scripts: clean up IA-64 code
To: Greg KH <gregkh@linuxfoundation.org>
Cc: chuck.lever@oracle.com, masahiroy@kernel.org, nicolas@fjasle.eu,
 patches@lists.linux.dev, stable@vger.kernel.org, dcavalca@meta.com,
 jtornosm@redhat.com, guanwentao@uniontech.com
References: <20250703143946.229154383@linuxfoundation.org>
 <E845ABA28076FEFB+20250708032644.1000734-1-wangyuli@uniontech.com>
 <2025070857-junkman-tablet-6a45@gregkh>
Content-Language: en-US
From: WangYuli <wangyuli@uniontech.com>
Autocrypt: addr=wangyuli@uniontech.com; keydata=
 xjMEZoEsiBYJKwYBBAHaRw8BAQdAyDPzcbPnchbIhweThfNK1tg1imM+5kgDBJSKP+nX39DN
 IVdhbmdZdWxpIDx3YW5neXVsaUB1bmlvbnRlY2guY29tPsKJBBMWCAAxFiEEa1GMzYeuKPkg
 qDuvxdofMEb0C+4FAmaBLIgCGwMECwkIBwUVCAkKCwUWAgMBAAAKCRDF2h8wRvQL7g0UAQCH
 3mrGM0HzOaARhBeA/Q3AIVfhS010a0MZmPTRGVfPbwD/SrncJwwPAL4GiLPEC4XssV6FPUAY
 0rA68eNNI9cJLArOOARmgSyJEgorBgEEAZdVAQUBAQdA88W4CTLDD9fKwW9PB5yurCNdWNS7
 VTL0dvPDofBTjFYDAQgHwngEGBYIACAWIQRrUYzNh64o+SCoO6/F2h8wRvQL7gUCZoEsiQIb
 DAAKCRDF2h8wRvQL7sKvAP4mBvm7Zn1OUjFViwkma8IGRGosXAvMUFyOHVcl1RTgFQEAuJkU
 o9ERi7qS/hbUdUgtitI89efbY0TVetgDsyeQiwU=
In-Reply-To: <2025070857-junkman-tablet-6a45@gregkh>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="------------5bjoeusxawvLALaIWwJ05qX0"
X-QQ-SENDSIZE: 520
Feedback-ID: zesmtpip:uniontech.com:qybglogicsvrgz:qybglogicsvrgz8a-1
X-QQ-XMAILINFO: NDW+fwfL9uPKvIZyRLYGpS0Lo/B+HRiJcLXbVcQglyWVZdZgRFk9gE9E
	NbZZpSNpXkjUnsF2z6fThcSMyq0Ahhj0uoRoz9Q9N4ikEVGpSV7gMb2opAvj4+ZnVovkSkn
	+fqyGU7VWNMA/txYXtr1ImlrWpyA2uS5W99z0czYcZHNr57tYEJaoMz7XRb2iBmMlG0eAAj
	dlRPlo4F/qwid2nZObXf8CNzK9wwJ0jfTKiU5tnX6JS9L3X9eLbMephUEBOTY207V1jAx1p
	I4JXgq29y2G/1Mm5sQQQVnhRRcuPZuBOlgRgseOPBWVNB/s36VumEvODG93ywKGGOUsyXjO
	dI+8xcbs4MNJkdKWyHI2wULHQX2mmVhU6ROoqhLhUWm8rk6D4DQKVsZL44IAE4EcuZ52/Ys
	tvS+1ncv2FdKMmezV1gt/N1ButqcPvwVm+Qtp4M+H7CXomJJro96WDGJAQA49mNotC9Jz/O
	DHjTRKo8IKrps7yPSgGyYF4i3gqhYafJXKK9Cy1AsECvaNJ+0SbFuFpUiklpu51nYR1sbPt
	HEabgUQ1cWpmD+79Xgv2IL2OaCZevlmi+SAcDBj4As9yvSzU/c0KeJtztMC0+GR2Eg+g55W
	fA1m/uX3NQtvyDybPzWEmo4SylRBdsQGQPcv3cLeIR9OSE7tGMzcUzzArOIhbSG8qlOot/g
	4bLyqZBMpwN05GqrjL2SkBDHFYb5tOrCeZdmvTHPTy8z+IV9NSta/7pk0hjf9q/94Vv4Cny
	lk3lWbq8+VUXg9e9bJNRJbfEH0xvSgjghkxoZp+V7rlg1AKR7QxuQUHbCe5l8ZFeoTHZhlE
	k7U82PcXPMKBmZMccFASQKldPsej2l+WL5pS2bDD/CEYW+rl/JAXa67Hn0V3wjB+ytj6vUU
	p8G/Sua4iOMKAEYZ2e2GGOjpGkVUVA8YRoUSfoalaxnlm/MORTf/2w25whw+PW0GOpnhyPC
	N2D0vmk9N495j5Jwj/T85Qaj9YLtFeda+ez57BLykeyCZkFngv2P4uCuwdFgbVC+oyzVrfq
	K6fuBiSSuNJVqTN5LtLUT8UmPIUqMVgAA0oT0xRW4zeULlTeWE
X-QQ-XMRINFO: MSVp+SPm3vtS1Vd6Y4Mggwc=
X-QQ-RECHKSPAM: 0

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--------------5bjoeusxawvLALaIWwJ05qX0
Content-Type: multipart/mixed; boundary="------------l5mi6KR2rBrnrJJObU03lj00";
 protected-headers="v1"
From: WangYuli <wangyuli@uniontech.com>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: chuck.lever@oracle.com, masahiroy@kernel.org, nicolas@fjasle.eu,
 patches@lists.linux.dev, stable@vger.kernel.org, dcavalca@meta.com,
 jtornosm@redhat.com, guanwentao@uniontech.com
Message-ID: <e24050a6-dde6-4447-8b45-69578b352e5f@uniontech.com>
Subject: Re: [PATCH 6.6 129/139] scripts: clean up IA-64 code
References: <20250703143946.229154383@linuxfoundation.org>
 <E845ABA28076FEFB+20250708032644.1000734-1-wangyuli@uniontech.com>
 <2025070857-junkman-tablet-6a45@gregkh>
In-Reply-To: <2025070857-junkman-tablet-6a45@gregkh>

--------------l5mi6KR2rBrnrJJObU03lj00
Content-Type: multipart/mixed; boundary="------------ouuQ0fLqS2ATwhCcKLdhdjKM"

--------------ouuQ0fLqS2ATwhCcKLdhdjKM
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: base64

SGkgZ3JlZyBrLWgsDQoNCk9uIDIwMjUvNy84IDE1OjIwLCBHcmVnIEtIIHdyb3RlOg0KPiBJ
cyBpYS02NCBhY3R1YWxseSBiZWluZyB1c2VkIGluIHRoZSA2LjYueSB0cmVlIGJ5IGFueW9u
ZT8gIFdobyBzdGlsbCBoYXMNCj4gdGhhdCBoYXJkd2FyZSB0aGF0IGlzIGtlZXBpbmcgdGhh
dCBhcmNoIGFsaXZlIGZvciBvbGRlciBrZXJuZWxzIGJ1dCBub3QNCj4gbmV3ZXIgb25lcz8N
Cj4NCkknbSBhZnJhaWQgSSBkb24ndCBxdWl0ZSBmb2xsb3cgeW91ciBwb2ludC4NCg0KSW4g
djYuNy1yYzEsIHdlIGludHJvZHVjZWQgdGhlIGNvbW1pdCB0byByZW1vdmUgdGhlIElBLTY0
IGFyY2hpdGVjdHVyZSBjb2RlLg0KDQpUaGlzIG1lYW5zIGxpbnV4LTYuNi55IGlzIHRoZSBs
YXN0IGtlcm5lbCB2ZXJzaW9uIHRoYXQgbmF0aXZlbHkgc3VwcG9ydHMgDQpJQS02NCwgYW5k
IGl0IGFsc28gaGFwcGVucyB0byBiZSB0aGUgY3VycmVudGx5IGFjdGl2ZSBMVFMgcmVsZWFz
ZS4NCg0KDQpJbiBhbnkgY2FzZSwgSSdtIHF1aXRlIGNvbmZ1c2VkIGJ5IHRoZSBjdXJyZW50
IHNpdHVhdGlvbiBiZWNhdXNlIHdlJ3ZlIA0KZXNzZW50aWFsbHkgYnJva2VuIElBLTY0IGJ1
aWxkIHN1cHBvcnQgaW4gdGhpcyBrZXJuZWwgdmVyc2lvbi4NCg0KSWYgeW91IGdlbnVpbmVs
eSBiZWxpZXZlIHRoYXQgbm8gb25lIGlzIHVzaW5nIElBLTY0IGRldmljZXMgd2l0aCANCmxp
bnV4LTYuNi55LCB0aGVuIGl0IG1pZ2h0IGJlIGJlc3QgdG8gZGlyZWN0bHkgYmFja3BvcnQg
Y29tbWl0IGNmOGU4NjUgDQooImFyY2g6IFJlbW92ZSBJdGFuaXVtIChJQS02NCkgYXJjaGl0
ZWN0dXJlIikgdG8gY29tcGxldGVseSByZW1vdmUgSUEtNjQuDQoNClRoaXMgd291bGQgYXZv
aWQgYW55IG1pc3VuZGVyc3RhbmRpbmcuDQoNCk90aGVyd2lzZSwgc29tZW9uZSBpbiB0aGUg
ZnV0dXJlIHdpbGwgaW5ldml0YWJseSBhc3N1bWUgbGludXgtNi42LnkgDQpzdGlsbCBzdXBw
b3J0cyBJQS02NCwgd2hlbiBpbiByZWFsaXR5LCBpdCdzIG5vIGxvbmdlciBmdW5jdGlvbmFs
Lg0KDQoNClRoYW5rcywNCg0KLS0gDQpXYW5nWXVsaQ0K
--------------ouuQ0fLqS2ATwhCcKLdhdjKM
Content-Type: application/pgp-keys; name="OpenPGP_0xC5DA1F3046F40BEE.asc"
Content-Disposition: attachment; filename="OpenPGP_0xC5DA1F3046F40BEE.asc"
Content-Description: OpenPGP public key
Content-Transfer-Encoding: quoted-printable

-----BEGIN PGP PUBLIC KEY BLOCK-----

xjMEZoEsiBYJKwYBBAHaRw8BAQdAyDPzcbPnchbIhweThfNK1tg1imM+5kgDBJSK
P+nX39DNIVdhbmdZdWxpIDx3YW5neXVsaUB1bmlvbnRlY2guY29tPsKJBBMWCAAx
FiEEa1GMzYeuKPkgqDuvxdofMEb0C+4FAmaBLIgCGwMECwkIBwUVCAkKCwUWAgMB
AAAKCRDF2h8wRvQL7g0UAQCH3mrGM0HzOaARhBeA/Q3AIVfhS010a0MZmPTRGVfP
bwD/SrncJwwPAL4GiLPEC4XssV6FPUAY0rA68eNNI9cJLArOOARmgSyJEgorBgEE
AZdVAQUBAQdA88W4CTLDD9fKwW9PB5yurCNdWNS7VTL0dvPDofBTjFYDAQgHwngE
GBYIACAWIQRrUYzNh64o+SCoO6/F2h8wRvQL7gUCZoEsiQIbDAAKCRDF2h8wRvQL
7sKvAP4mBvm7Zn1OUjFViwkma8IGRGosXAvMUFyOHVcl1RTgFQEAuJkUo9ERi7qS
/hbUdUgtitI89efbY0TVetgDsyeQiwU=3D
=3DBlkq
-----END PGP PUBLIC KEY BLOCK-----

--------------ouuQ0fLqS2ATwhCcKLdhdjKM--

--------------l5mi6KR2rBrnrJJObU03lj00--

--------------5bjoeusxawvLALaIWwJ05qX0
Content-Type: application/pgp-signature; name="OpenPGP_signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="OpenPGP_signature.asc"

-----BEGIN PGP SIGNATURE-----

wnsEABYIACMWIQRrUYzNh64o+SCoO6/F2h8wRvQL7gUCaGzMjAUDAAAAAAAKCRDF2h8wRvQL7mxV
AQCXcSeZIOIR8HoGd+tqf1LQHfsZkyntQPxqJG7+uSSB3AD/d/nuSpMvHdd3UHJa5yip065pexiT
psNAZq9ITfRjWQ4=
=5e4R
-----END PGP SIGNATURE-----

--------------5bjoeusxawvLALaIWwJ05qX0--
