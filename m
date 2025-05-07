Received: from stravinsky.debian.org (stravinsky.debian.org [82.195.75.108])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 54272280A2E;
	Wed,  7 May 2025 13:12:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=82.195.75.108
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746623580; cv=none; b=lbbxKkE7QNUm3zIvt9W/bj9hkUa4iusyT9XBXPZh4ja9XINSMZFGg4FVyXZNpjIAr0wShTvetPJw5OdSc7cJTRvrJ4RH54MIpMHnkkvxB/92TgACF8xS2QOBmvuA+OfnaxvWoP5kIOWdRZl29Yic8E81I5KwljSYP/XkMp1CBLc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746623580; c=relaxed/simple;
	bh=af0dAto1JmJFZpxWd9GQUrw53UawMnLkUhh04P5h7g0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Dk58VgfLeHguU1kqNVDkEkSJqbLvqnGgVotvHcYWjrBu+H6r2wyKAYC5OvzazJCEDI4QF+o/H3wE/kDeq3WM/rTxszOnd/6Y3Ho6Az4JW+zEFtFfiPiqvIOFdemwiexN987aiH1GOMecLl4UaFM8+sH0vb5oIzq84mkzufynVOY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=debian.org; spf=none smtp.mailfrom=debian.org; dkim=pass (2048-bit key) header.d=debian.org header.i=@debian.org header.b=pWwnH2qm; arc=none smtp.client-ip=82.195.75.108
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=debian.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=debian.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=debian.org header.i=@debian.org header.b="pWwnH2qm"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=debian.org;
	s=smtpauto.stravinsky; h=X-Debian-User:Content-Type:In-Reply-To:From:
	References:Cc:To:Subject:MIME-Version:Date:Message-ID:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=egQKSx3cep+E3uxArOI1BZhiCL8LDjF+9Xzlb16fT+w=; b=pWwnH2qmb+I6NoVv3DdGhgtb2Z
	zjqrOzHLsBh908o1UWDQXZN/aMc3Q/2WYGZq6vZkhkFx4QpE5i5CYsI43EdBxJi3y495IRmQ0pusd
	ttIfDl4xAB8CHwKU4AETyO1+IYYfzbebrDddmxwJd647O2plTSZ2LL6naJCHoeHW74kZKNC5IKDp5
	G83stoYB7qzTgrfjL2vS/hc45s0WOUDgzto1lOLKRtK91O1M6c+jtP1Enmf8/u9WTAah2+GxV9TGx
	9LtqmkKD/uPLnSasuGRT6mGcSeOfPTuk91xt5bULkL3q9ojyTSVdjZXhzCbOnOjJY9bnM8xZuhEAV
	bNvnCR9Q==;
Received: from authenticated user
	by stravinsky.debian.org with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_128_GCM:128)
	(Exim 4.94.2)
	(envelope-from <ukleinek@debian.org>)
	id 1uCeZx-005f3V-Dp; Wed, 07 May 2025 13:12:53 +0000
Message-ID: <01f69c5b-9c6c-4964-9038-a91ddab6e220@debian.org>
Date: Wed, 7 May 2025 15:12:47 +0200
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.1 150/167] of: module: add buffer overflow check in
 of_modalias()
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
 Hideki Yamane <henrich@iijmio-mail.jp>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
 Sergey Shtylyov <s.shtylyov@omp.ru>, Rob Herring <robh@kernel.org>,
 h-yamane@sios.com
References: <20250429161051.743239894@linuxfoundation.org>
 <20250429161057.791863253@linuxfoundation.org>
 <20250507200533.ac131fe0c774b23054b4261e@iijmio-mail.jp>
 <2025050737-banked-clarify-3bf8@gregkh>
Content-Language: en-US, de-DE
From: =?UTF-8?Q?Uwe_Kleine-K=C3=B6nig?= <ukleinek@debian.org>
In-Reply-To: <2025050737-banked-clarify-3bf8@gregkh>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="------------jxBuu8650CC5JTC1U0151rc0"
X-Debian-User: ukleinek

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--------------jxBuu8650CC5JTC1U0151rc0
Content-Type: multipart/mixed; boundary="------------EvsA0FIKop2ZEYdp15DLUuw1";
 protected-headers="v1"
From: =?UTF-8?Q?Uwe_Kleine-K=C3=B6nig?= <ukleinek@debian.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
 Hideki Yamane <henrich@iijmio-mail.jp>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
 Sergey Shtylyov <s.shtylyov@omp.ru>, Rob Herring <robh@kernel.org>,
 h-yamane@sios.com
Message-ID: <01f69c5b-9c6c-4964-9038-a91ddab6e220@debian.org>
Subject: Re: [PATCH 6.1 150/167] of: module: add buffer overflow check in
 of_modalias()
References: <20250429161051.743239894@linuxfoundation.org>
 <20250429161057.791863253@linuxfoundation.org>
 <20250507200533.ac131fe0c774b23054b4261e@iijmio-mail.jp>
 <2025050737-banked-clarify-3bf8@gregkh>
In-Reply-To: <2025050737-banked-clarify-3bf8@gregkh>

--------------EvsA0FIKop2ZEYdp15DLUuw1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

Hello Greg,

On 5/7/25 13:12, Greg Kroah-Hartman wrote:
> On Wed, May 07, 2025 at 08:05:33PM +0900, Hideki Yamane wrote:
>> Hi,
>>
>> On Tue, 29 Apr 2025 18:44:18 +0200
>> Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:
>>> 6.1-stable review patch.  If anyone has any objections, please let me=
 know.
>>>
>>> ------------------
>>>
>>> From: Sergey Shtylyov <s.shtylyov@omp.ru>
>>>
>>> commit cf7385cb26ac4f0ee6c7385960525ad534323252 upstream.
>>>
>>> In of_modalias(), if the buffer happens to be too small even for the =
1st
>>> snprintf() call, the len parameter will become negative and str param=
eter
>>> (if not NULL initially) will point beyond the buffer's end. Add the b=
uffer
>>> overflow check after the 1st snprintf() call and fix such check after=
 the
>>> strlen() call (accounting for the terminating NUL char).
>>
>>  Thank you for catching this and push it to 6.1.y branch.
>>
>>  And it seems that other older stable branches - linux-5.4.y, linux-5.=
10.y
>>  and linux-5.15.y can be updated with cherry-picking =20
>>  5d59fd637a8af42b211a92b2edb2474325b4d488=20
>>
>>  Could you also review and apply it if it is okay, please?
>=20
> It does not apply there cleanly, please submit tested patches against
> those branches if you wish to have it applied there.

`git cherry-pick 5d59fd637a8af42b211a92b2edb2474325b4d488` applies and co=
mpiles fine (amd64)
here on top of v5.15.181, 5.10.237 and 5.4.293.

*some time later*

Ah, the hunk offsets are different, which git gets right but patch fails.=


Sent out three patches for the three stable trees.

Best regards
Uwe

--------------EvsA0FIKop2ZEYdp15DLUuw1--

--------------jxBuu8650CC5JTC1U0151rc0
Content-Type: application/pgp-signature; name="OpenPGP_signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="OpenPGP_signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCgAdFiEEP4GsaTp6HlmJrf7Tj4D7WH0S/k4FAmgbXFAACgkQj4D7WH0S
/k6q0wf8C/RMLyLn8Lu3fVG3pt0XaK/9QBIf6J+6Lz8Dekuovi5EKmltDdb9mxgt
6Ba4gVnfQP0Pcmohm1jVV8fxm/fwkNkizvPufneseVbS3qGavUYBSkp3IgpHt7cr
TCXSBgcuEgMajDIGh8nBkYkW6j+1bWA+SBvFyiZPz3e9BrILOb7cVbMw2UtYImYJ
WOyo8mZZSGPwTLtskPFEBOObS0Xj/SkxitfIBq8npt+8tAgfDfW/CfbVss2Cl/fW
rk+/E9IDjOmJ1L7YEZPMVKt9CzAH8jVJrVwo6MFEuOfkoHb67f5OLxAczMf1qL0W
TdwJbzQqatg7XjsQLaOc7IYdml3rag==
=C+v8
-----END PGP SIGNATURE-----

--------------jxBuu8650CC5JTC1U0151rc0--
