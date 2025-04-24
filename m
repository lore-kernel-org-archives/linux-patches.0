Received: from mout.kundenserver.de (mout.kundenserver.de [217.72.192.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 907211AED5C
	for <patches@lists.linux.dev>; Thu, 24 Apr 2025 06:37:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.72.192.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745476639; cv=none; b=tJXemoc6vJ9dcGmdxdvtm323krXEVvCUYZzh1WJ7Y4YC5vyfu+Y7+k75jp8c4iAbm30XZk7owhNoaVgG+3XjG62F/WEfHEe9RU6ybN8xQBS0Zdms9HMiIGfoaeCe7SNZtSLNdUdK+4kOBQ5lFdurP/cgjjR0OUQ7HKviRCHlK7s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745476639; c=relaxed/simple;
	bh=/jSPP5jRjyGm2EyKagVSup3qGysKbQLr9FSymPXCeis=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=SvwWHL7Udj/47tb7FjgW3/s5evFGtZPhI6Hd2PmRHsv2l1GyZiWIl+j8bz/tGCKByzeGSnr/fBxgVGp8z9mIvHv4k09XtlO2FbdT0SvdXUkZlEW/BROTnHhyPiSyJvSv9wcSyOREyt549osHqagjdy4DKYKWAVVk7PZCv0qLc04=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=heusel.eu; spf=pass smtp.mailfrom=heusel.eu; dkim=pass (2048-bit key) header.d=heusel.eu header.i=christian@heusel.eu header.b=ueN9Fxm9; arc=none smtp.client-ip=217.72.192.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=heusel.eu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=heusel.eu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=heusel.eu header.i=christian@heusel.eu header.b="ueN9Fxm9"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=heusel.eu;
	s=s1-ionos; t=1745476595; x=1746081395; i=christian@heusel.eu;
	bh=EbSvx2qQa9ddzKM9jOKOli59TXLhM3lPCc288iVCqC0=;
	h=X-UI-Sender-Class:Date:From:To:Cc:Subject:Message-ID:References:
	 MIME-Version:Content-Type:In-Reply-To:cc:
	 content-transfer-encoding:content-type:date:from:message-id:
	 mime-version:reply-to:subject:to;
	b=ueN9Fxm9gXJGrP/9/4+xvOs+N37nF2ImX72xU/oaMxA5oOBGW7syBj2iOuV3CL9E
	 S+m3B+Ojz6H/VtvKsAVvxe3O8s0CelNHPUm+iATCWL6KaVxTLmYtPVhI5sDkDSwhZ
	 fgv6XKGcar+vvDTFPnlzQ5OicgKGKg+LFf/6YDKprzW92reECHr4nkQf5qp4Z4UpP
	 xV4Ecjkp58gLhPD6GwzV0aNvmYYbwCShYWpoA3YTbSw/TOJS/rsSeCIQ3UifyCV5Q
	 B4aHE/7aWKqiocc6whUP/gY+8LjEjAyX43F4QTBjYflPwLDJcRMHq44N3DrgC03JN
	 3MjmDCDuhxXbbz3a/Q==
X-UI-Sender-Class: 55c96926-9e95-11ee-ae09-1f7a4046a0f6
Received: from localhost ([89.244.90.34]) by mrelayeu.kundenserver.de
 (mreue107 [212.227.15.183]) with ESMTPSA (Nemesis) id
 1MBmI6-1uFZQV1jMi-00BTBI; Thu, 24 Apr 2025 08:36:35 +0200
Date: Thu, 24 Apr 2025 08:36:33 +0200
From: Christian Heusel <christian@heusel.eu>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, akpm@linux-foundation.org, 
	linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org, 
	lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com, f.fainelli@gmail.com, 
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org, 
	hargar@microsoft.com, broonie@kernel.org
Subject: Re: [PATCH 6.14 000/241] 6.14.4-rc1 review
Message-ID: <ced73860-417c-4f08-b84a-db0d88f24bf4@heusel.eu>
References: <20250423142620.525425242@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="easgnngilahnb3q5"
Content-Disposition: inline
In-Reply-To: <20250423142620.525425242@linuxfoundation.org>
X-Provags-ID: V03:K1:rWc6rPP0Fts8PfvlGsVBGrBbx43vcw4/gLEHVN1kV74+s25pwl9
 SPCCUBlS+IvNOpWEmg4z6mHGOMHUnlpVmHSauw4qGJfqPYjXoEqTl4kg+ST/fDLVb4RJXqu
 /J/NFv7gZiENpE15AvrBdw4PC86EySs3j1grF4GiYyDAh6/UV2Wr6dDxkhFrER1PuAd47zV
 czQ1p3tVSIrt/QSi2Jk1g==
X-Spam-Flag: NO
UI-OutboundReport: notjunk:1;M01:P0:TfpLlIxvAyc=;WIL/V0x9SkdUZUUdi544k4D88zt
 1InkmajVPGjaWCgFgeaGa8gS7DKybRBF2iRh5FktqLQ2bsM9TGrktVYbXFOpK2u8GhqUaKAqm
 3/9H9159J2GwnNEiVE0RsynLfdJ0DSaSuN0bmFIItyWGGjU28deK6AZ1AlPmiGdY+M16tD3Jv
 eVdYIYOKZVa0hTTkS2/uCrKgyKVWTVwsS9aOlaKCzW+9bD09mcGaECoqiazvMPST3vOIcN9gA
 1hnnsOH1s1jU0wSEgacssttLYIvzsuPdkOMXRQjIcNyN9ZrMSnxY1qzzPZxcdcqmHPyrP4bos
 uNMCYeqIi8F3gqDiGHgLOWrqPZgbYcc9J9aK3uLHc722mxra4H1ZZSvL8RUW1nCXWOukbKMlN
 VwKV8xrKf/YuU3y/eIvtA4+yzU5pAwGv7iQJmcLxcAlcS6AuwS1KBmbTZ5ZzEW2Okp+F9g+d+
 5hNu4GCpLJk/7Vs/TEhX816cs8plXxFj7+Y5v+EgEnaHGaXcohBC+nCTziWViw/hoD35r8hae
 DEhAFEYDGgpYbIy0YcBhczr1/YQcY+yAfADZgpLvorT//TO17iBu5YWs3MpG0zWjOoXqU14r+
 yOTxkrkm/va/Nc56b1NuUyqV8FuaZA0FVinP4FYvK27oUMNI4+ADKlZxIEvc8HS08Gk74ikC/
 OqQwv5m5me/e4jhj5oNKn1pYHn9MohejHN3z/agGTZZnmvx+JLc4LlLJEqzQ393EGNO+OzTda
 ELQ8jdzqUJaxuHQyzml7OjbcIAgMPoKjGHkQ3mORg4aKg1Mjvaqi7H63raG91B8IHYnMOK3Jp
 oi5h4mrccQcxv00snZPEF97LIUyUhaY343yljBaFV7MdIHa+KqSJpE61D/1HvBPpwJQ436oME
 M22UALUWH9b6sEFEQor4errgNL3Dp/RsqZizitUCzVzzCud8Qgvy6CexwSHAZu5Y7HEUz64Bv
 Vt5y9SlEWrenz7jgz82BoOyXMS7ocVpRoOt8ECwBkA1JXRitK9LcEwKY8SDxKvO8FILlTSTpN
 4pEUK0quqxODwC9zgt9r42eMtBJTusVTKPZ6aW9Zdegwa/U7xpsfP8Vb4iBlCj5WlJpToOwri
 Sdd6PUyw1hMos+/EJwCpOgZnPDEhHK/iGI+Br8ih+y+dk4o5E9aYI6+EmFfS9Geyld2AbjX2n
 Yd6upAwOm0Zmsjj4O9tzLiQEXwvPXk5eTEx8LLMQID/hhdfSuPy6ad/0PXbvnYmslE3vYWt+B
 a4k0A1mj9HmSXCMk7o9TeOztB2NF9YerpeCpgfGMw12ck7POy80zAQUDHlclYTyzaQifLAeOf
 Ujn50aEWNXgTTeQNBoBrC+r3vVaH3Rzisyovq2bgbehB1xpT1rvk5YYBrwI8hL2X6ix+xkESK
 3XKtwhVNnMLPUxx7zjIR/42gNIOBYIiw6EUY4=


--easgnngilahnb3q5
Content-Type: text/plain; protected-headers=v1; charset=us-ascii
Content-Disposition: inline
Subject: Re: [PATCH 6.14 000/241] 6.14.4-rc1 review
MIME-Version: 1.0

On 25/04/23 04:41PM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.14.4 release.
> There are 241 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Fri, 25 Apr 2025 14:25:27 +0000.
> Anything received after that time might be too late.
>

Tested-by: Christian Heusel <christian@heusel.eu>

Tested on a ThinkPad E14 Gen 3 with a AMD Ryzen 5 5500U CPU and on the
Steam Deck (LCD variant) aswell as a Framework Desktop.

--easgnngilahnb3q5
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEEb3ea3iR6a4oPcswTwEfU8yi1JYUFAmgJ2/AACgkQwEfU8yi1
JYU98xAAmxjwxgb7cnrL/Vy4J0Yt5RmG9badIxxaJM52ds6KW4zcjd3RFvbrfkQo
lXA77TrWKkZ5q60uZTqxjBpPIpzjKC1+eWCAsXV7AWfXl3u0VMzVGGxJ5fDrKFUR
8EvhFjX7KjB5/9wI7dQ/48t/HjOkngSJPZmuLgAlXr9+t1E9N1l7rMADyHdiT50T
9A9xyhSDO1KaIFeE9VXREWBCDfc02fEuRpfOQ5WVRFof1ff8jOoHRPvHFHxUEDpV
6QAJcFFXWKIx6w8qaJKI2xV4DeNCuFqcNposhgJ89QgK/rSS3j4g9HyXmsb9bAO9
nraXScWRUPC86nSAb7UD6kKZFKyzyPYHN1AtdQKD8rWz0BJkr5DEGFITUmRV9rGm
NPPHSoDtyejO0DuOzj13mQPalDuYG072pChRjVPs7wVZQp3kZigMVX0PCTFIvRNM
rA58fYM39DwLFXQ7BEwo3evuC97hn29pkyyZ7UIveK6aQMJ5JJfx0J1YJGubXu1l
3rkxq7zY8YaoFtFTDZtOCnOCmOTlXB7agjMBnHx7Dv79UrKMMi1IDFdkqLDZa+Id
0/ojj+Fqo2CQdiGC58Vw5RpHKqlNwmNIZ0PCsbNybxF4Qmkp0hQfsMf+wb463Axd
utQExkZapgrIj7J8K13JpDr3gdIqYpVhlc0Ba7AByLIjbtvNtDE=
=mHAX
-----END PGP SIGNATURE-----

--easgnngilahnb3q5--
