Received: from mail-wm1-f43.google.com (mail-wm1-f43.google.com [209.85.128.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0422030CD87
	for <patches@lists.linux.dev>; Fri,  6 Feb 2026 08:17:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770365866; cv=none; b=Eu1nt+jDpTQ+Re81eVBH+LgaszaGwYTK8Nn2ESw45h+gvYdKN4Dz2FVFISlBXml6YV20+8wQSwvuEHptG+16c/G+5/ZkKP+NBJPvgSfjTEEwFzcu2o+wpRrnvIZ0HTE5np6tATmGmwetR1ChUq55xrXYUD3CR4EN/JdgvNID/dY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770365866; c=relaxed/simple;
	bh=Kjfri+drppMwAz5RgjQPZflMK34bPLpJOOUZ8SpxV7s=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=nycz7SG9TssX4/kmLz8NKrfN3pwZDhagt7DKOYC6aFfLGhQzebIGPzjfHngzIXwIJd2+Qjf7GJaP7cXFAp2PdeiNGH7aypAXk8i2FMejT+bOGFZrQwyqHE2vKzNmfptedunuwFYBTWzQxCfwK1Qu8LBHI6TJ04ExNaMmkAYBmaQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=baylibre.com; spf=pass smtp.mailfrom=baylibre.com; dkim=pass (2048-bit key) header.d=baylibre-com.20230601.gappssmtp.com header.i=@baylibre-com.20230601.gappssmtp.com header.b=v40S8J8X; arc=none smtp.client-ip=209.85.128.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=baylibre.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=baylibre.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=baylibre-com.20230601.gappssmtp.com header.i=@baylibre-com.20230601.gappssmtp.com header.b="v40S8J8X"
Received: by mail-wm1-f43.google.com with SMTP id 5b1f17b1804b1-4806fbc6bf3so4552785e9.2
        for <patches@lists.linux.dev>; Fri, 06 Feb 2026 00:17:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=baylibre-com.20230601.gappssmtp.com; s=20230601; t=1770365864; x=1770970664; darn=lists.linux.dev;
        h=mime-version:user-agent:organization:references:in-reply-to:date:cc
         :to:from:subject:message-id:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Kjfri+drppMwAz5RgjQPZflMK34bPLpJOOUZ8SpxV7s=;
        b=v40S8J8XLWOGXh3oszTAOMGe2+Irug8rfCWDVsbY9SgrsAXgw6l2Nb3kuB9LzRRkhI
         gNGIyybfxTdI9iMr9nOVtBZXi4HpjSfIflM54Bj0vAermWcFhoNIFpRrymJi7NrItMKS
         FUOIUpW2RdfhZypWPcW8lVFAfWVcFhj5EQk3gMlUTY+6qRo1dZnbsrOs2gKZw46eVoEs
         GeTkI4jePJa21RRe/uStNv205rgEfUmxHCENRWkl0sdozXni4Bl7tgBwQUySoVqfyX5/
         LO8wdenGF+onkZGr9mt4LDrj93C9SJqqPJdVVjr+VnUECJ/zKQj/YjwwFT/CiED7ySau
         6vKA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770365864; x=1770970664;
        h=mime-version:user-agent:organization:references:in-reply-to:date:cc
         :to:from:subject:message-id:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Kjfri+drppMwAz5RgjQPZflMK34bPLpJOOUZ8SpxV7s=;
        b=oQLqIXuishrJulvNxOFo1RXr3iaWkYoCh31//NUMnVve/rDN24l0e1+c+NIZWdYFoy
         e9Ozshjfx6o2USQzjH7YHBzZ0f49KDNr0ueU71l9uCJMnVtxfkldd7gaq+dtU3lNbP/F
         NBUBb9UEgP3JsctMohv8LmZX1ldCTGoTl5fboiu7Opozju00IX/hq2HNMspRc8Wn3H5O
         LsAGSlQAjX8jjKOuYqJiHbdNu0MDDU0wd4wjImwpkmF0yDxWw2na+oz7W7gmN6tfMpom
         FJdr/r3BUEygHrvi8Fu1mnhqGBp8T7BV0JJzcmUTWVWqsXQyfXDN6H3R98/xlrqhTPv2
         k7Zg==
X-Gm-Message-State: AOJu0YwGcr2vTOWpWy7fLR0ISErEzie+L71O36uJkVFtdMJIOAaRmujA
	uouQfq7f6N6rE/rsmEx+FsNbZVB1JkBVae9vZtCA76GfXwDdZ4Vp48qQLvDafmXk0TM=
X-Gm-Gg: AZuq6aLR6u/yjwWq0hBgMQg+/Z3KrM+9JHdEeNMkfUUML3hierhdFnvc24yRazjN0L4
	BQU+4DtKR7VlIoP4ihvdoZqfK+Skc88WjAZQsbwO5tzaiL0ZTuVtk0Apw3EMsMuGoBLuhfSHTDw
	BEQu5V6rryO00FoxjPcW5P2D6JopaQ3WWTlVKve+9L+gw2b9UB9rCoUOanj6WguPmdI3WHtfZPf
	BOB7S1anmfsMUxTA2/rwPbiUj907tOktoDWjxu0+oohG8V8lbXqbmW05R9DI81UNRw8IcxssUp9
	Rv6ciuwcQOnW1qDEyj0s3zwOMeeWsLXknfJW6U44B4yesxoc0CQYA9YEZT2ZjPYfojfD9/agl4J
	0jlKi+VYiosM7SDMl8ELUSFz9MN/ttEZVn3uKQfi5H3taIzpGHhPyziYren+gVFa3F1T2J8FJ9g
	aN6FThCzIVnkPQyu1rHgpYU2YAEgivKA4+TfCT/Pwg1wYiav8hzr2UWt3xMg==
X-Received: by 2002:a05:600c:1390:b0:477:5ad9:6df1 with SMTP id 5b1f17b1804b1-483201dc4bamr28137285e9.3.1770365864192;
        Fri, 06 Feb 2026 00:17:44 -0800 (PST)
Received: from [10.203.83.147] (mob-176-247-2-76.net.vodafone.it. [176.247.2.76])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-483209eeef0sm11981065e9.20.2026.02.06.00.17.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 06 Feb 2026 00:17:43 -0800 (PST)
Message-ID: <b5f8757ebd48c3a11591a68e8b97017f7b9d7e31.camel@baylibre.com>
Subject: Re: [PATCH 5.10 070/161] iio: imu: st_lsm6dsx: fix iio_chan_spec
 for sensors without event detection
From: Francesco Lavra <flavra@baylibre.com>
To: Ben Hutchings <ben@decadent.org.uk>, Greg Kroah-Hartman
	 <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, Andy Shevchenko <andriy.shevchenko@intel.com>, 
 Lorenzo Bianconi <lorenzo@kernel.org>, Jonathan Cameron
 <Jonathan.Cameron@huawei.com>
Date: Fri, 06 Feb 2026 09:17:38 +0100
In-Reply-To: <eb892614c9cd28aa03922567f8a6d75ed2f594bc.camel@decadent.org.uk>
References: <20260204143851.755002596@linuxfoundation.org>
	 <20260204143854.274769162@linuxfoundation.org>
	 <eb892614c9cd28aa03922567f8a6d75ed2f594bc.camel@decadent.org.uk>
Organization: BayLibre
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-NFvMVEynZQs+voLGOa2j"
User-Agent: Evolution 3.46.4-2 
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0


--=-NFvMVEynZQs+voLGOa2j
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: base64

T24gVGh1LCAyMDI2LTAyLTA1IGF0IDIzOjQ0ICswMTAwLCBCZW4gSHV0Y2hpbmdzIHdyb3RlOgo+
IE9uIFdlZCwgMjAyNi0wMi0wNCBhdCAxNTozOCArMDEwMCwgR3JlZyBLcm9haC1IYXJ0bWFuIHdy
b3RlOgo+ID4gNS4xMC1zdGFibGUgcmV2aWV3IHBhdGNoLsKgIElmIGFueW9uZSBoYXMgYW55IG9i
amVjdGlvbnMsIHBsZWFzZSBsZXQgbWUKPiA+IGtub3cuCj4gPiAKPiA+IC0tLS0tLS0tLS0tLS0t
LS0tLQo+ID4gCj4gPiBGcm9tOiBGcmFuY2VzY28gTGF2cmEgPGZsYXZyYUBiYXlsaWJyZS5jb20+
Cj4gPiAKPiA+IGNvbW1pdCBjMzRlMmUyZDY3YjNiYjhkNWE2ZDA5YjBkNmRhYzg0NWNkZDEzZmIz
IHVwc3RyZWFtLgo+ID4gCj4gPiBUaGUgc3RfbHNtNmRzeF9hY2NfY2hhbm5lbHMgYXJyYXkgb2Yg
c3RydWN0IGlpb19jaGFuX3NwZWMgaGFzIGEgbm9uLQo+ID4gTlVMTAo+ID4gZXZlbnRfc3BlYyBm
aWVsZCwgaW5kaWNhdGluZyBzdXBwb3J0IGZvciBJSU8gZXZlbnRzLiBIb3dldmVyLCBldmVudAo+
ID4gZGV0ZWN0aW9uIGlzIG5vdCBzdXBwb3J0ZWQgZm9yIGFsbCBzZW5zb3JzLCBhbmQgaWYgdXNl
cnNwYWNlIHRyaWVzIHRvCj4gPiBjb25maWd1cmUgYWNjZWxlcm9tZXRlciB3YWtldXAgZXZlbnRz
IG9uIGEgc2Vuc29yIGRldmljZSB0aGF0IGRvZXMgbm90Cj4gPiBzdXBwb3J0IHRoZW0gKGUuZy4g
TFNNNkRTMCksIHN0X2xzbTZkc3hfd3JpdGVfZXZlbnQoKSBkZXJlZmVyZW5jZXMgYQo+ID4gTlVM
TAo+ID4gcG9pbnRlciB3aGVuIHRyeWluZyB0byB3cml0ZSB0byB0aGUgd2FrZXVwIHJlZ2lzdGVy
Lgo+ID4gRGVmaW5lIGFuIGFkZGl0aW9uYWwgc3RydWN0IGlpb19jaGFuX3NwZWMgYXJyYXkgd2hv
c2UgbWVtYmVycyBoYXZlIGEKPiA+IE5VTEwKPiA+IGV2ZW50X3NwZWMgZmllbGQsIGFuZCB1c2Ug
dGhpcyBhcnJheSBpbnN0ZWFkIG9mIHN0X2xzbTZkc3hfYWNjX2NoYW5uZWxzCj4gPiBmb3IKPiA+
IHNlbnNvcnMgd2l0aG91dCBldmVudCBkZXRlY3Rpb24gY2FwYWJpbGl0eS4KPiBbLi4uXQo+ID4g
QEAgLTExNzAsOCArMTE3Nyw4IEBAIHN0YXRpYyBjb25zdCBzdHJ1Y3Qgc3RfbHNtNmRzeF9zZXR0
aW5ncwo+ID4gwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqB9LAo+ID4gwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAuY2hhbm5lbHMgPSB7Cj4gPiDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqBbU1RfTFNNNkRTWF9JRF9BQ0NdID0gewo+
ID4gLcKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgLmNoYW4gPSBzdF9sc202ZHN4X2FjY19jaGFubmVscywKPiA+IC3CoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoC5sZW4g
PQo+ID4gQVJSQVlfU0laRShzdF9sc202ZHN4X2FjY19jaGFubmVscyksCj4gPiArwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAuY2hh
biA9IHN0X2xzbTZkczBfYWNjX2NoYW5uZWxzLAo+ID4gK8KgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgLmxlbiA9Cj4gPiBBUlJBWV9T
SVpFKHN0X2xzbTZkczBfYWNjX2NoYW5uZWxzKSwKPiA+IMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoH0sCj4gPiDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqBbU1RfTFNNNkRTWF9JRF9HWVJPXSA9IHsKPiA+IMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqAuY2hhbiA9IHN0X2xzbTZkc3hfZ3lyb19jaGFubmVscywKPiAKPiBJbiB0aGUgdXBzdHJlYW0g
Y29tbWl0IHRoZSAzcmQgaHVuayBjaGFuZ2VkIHRoZSBlbnRyeSBmb3IgaGFyZHdhcmUgSURzCj4g
U1RfTFNNNkRTTzE2SVNfSUQgYW5kIFNUX0lTTTMzMElTX0lELgo+IAo+IFRoYXQgZW50cnkgd2Fz
IGFkZGVkIGJ5IGNvbW1pdCBmMzVlMWVlOWNiNWQgImlpbzogaW11OiBzdF9sc202ZHN4OiBhZGQK
PiBzdXBwb3J0IHRvIExTTTZEU08xNklTIiBpbiA2LjIuwqAgU28gaW4gdGhpcyBiYWNrcG9ydCB0
aGUgM3JkIGh1bmsgaXMKPiBjaGFuZ2luZyBjb25maWd1cmF0aW9uIGZvciBvdGhlciBkZXZpY2Vz
Lgo+IAo+IEkgdGhpbmsgdGhlIHJpZ2h0IHRoaW5nIHRvIGRvIGZvciB0aGUgNS4xMC02LjEgYnJh
bmNoZXMgaXMgdG8gb25seSBhcHBseQo+IHRoZSBmaXJzdCAyIGh1bmtzLgoKR29vZCBjYXRjaC4g
SW4gdGhlIDUuMTAgYnJhbmNoLCB0aGUgdGhpcmQgaHVuayBpcyBjaGFuZ2luZyBjb25maWd1cmF0
aW9uCmZvciBTVF9MU002RFNSX0lELCBTVF9JU00zMzBESENYX0lELCBhbmQgU1RfTFNNNkRTUlhf
SUQsIG5vbmUgb2Ygd2hpY2gKc2hvdWxkIGhhdmUgdGhlaXIgY29uZmlndXJhdGlvbiBjaGFuZ2Vk
OyBzbyBvbmx5IHRoZSBmaXJzdCB0d28gaHVua3Mgc2hvdWxkCmJlIGFwcGxpZWQuCg==


--=-NFvMVEynZQs+voLGOa2j
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQGzBAABCgAdFiEEhleFT5U73KMewxTm7fE7c86UNl8FAmmFo6IACgkQ7fE7c86U
Nl9bTwv+JNn6JenrkIjmvCsGXya7H0lGVBCyQqMH1J0EPqCS85zVDkTDcBJ8O38o
Em2QRrZpxAAHCeSJP9KrQ3Y/xXTjAw7PXuLaGE++I2UzpPOZEMHnkWrDDcVKrlwD
cd/pDtLiisAovwZtAqc6sPEoA1Fi4x9OqLcxOEb44WnqCX12oe4m2PGfpHB0iQkj
n+GCJhuC8YJcPsrrNzrffeeUZfdyB5/uvU9GCYGvvMcqQSN5wg/PbzVDONo0s4an
nHhh5Hs1q5cJXFEx3srTBJIdXhMPmZ2y6neHCskKsq+v9NVMxdjyNF/1hyxW9eAf
T8lWH4h8JFKAtxFR/zTzL7Da4CvyeexBo9+0BdLJc/ElKhIK4DDfgLkLtk7nMEZm
A8DBo1Qx7Ks/OguVfK0ENmZT6njWH1Z3axz+5mFdu7AQhSs8NXfEBIIBEdEaTVst
9ItGjofhMxVFiEnbQuNa88XuZseQWehCAim8ppotfQJJksq1S3JdS9CbsdT8Wfdx
qJ8TsHmq
=iBpQ
-----END PGP SIGNATURE-----

--=-NFvMVEynZQs+voLGOa2j--
