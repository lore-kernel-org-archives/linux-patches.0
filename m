Received: from mout.gmx.net (mout.gmx.net [212.227.15.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B95508F6A;
	Sun, 31 Dec 2023 15:49:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmx.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmx.de header.i=svenjoac@gmx.de header.b="F+8mhInN"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.de; s=s31663417;
	t=1704037750; x=1704642550; i=svenjoac@gmx.de;
	bh=9ZkZb/6NySPoY2LhMbaCqmu0Y8p8T2cEK9vht0pBelQ=;
	h=X-UI-Sender-Class:From:To:Cc:Subject:In-Reply-To:References:
	 Date;
	b=F+8mhInN5gD7RxWV7mh31P18Cc9wvKHuP21vKCBW8lbSAapQ6rPVnzT/Hk8MjMap
	 BoM0Jkjd0ZzIiL4milgVkxp4gVNBDoLESJ57cBmMHteEF8x7HpqWpR2vPk6QL8Z+R
	 n3jZi1zou2DOClIx9D8njuMYE8TMd4v0lHluuPwMiGvwvf3YGAOU72qNWSZ2025V1
	 YN3y53tjhZ1PV0LWAxHrfkEcGL70W7MW8LXJrsyi+CVNUs4oCLV9IxpWSz9aqXj6V
	 zgcMCcI+1/unzKpXHZoFc6kNvq1NNW64tLfw4g8j4q6ObjcqFVK12tTgQ0bZ4opfJ
	 gpLA9LTkRdecJVhlnA==
X-UI-Sender-Class: 724b4f7f-cbec-4199-ad4e-598c01a50d3a
Received: from localhost.localdomain ([79.203.84.168]) by mail.gmx.net
 (mrgmx005 [212.227.17.190]) with ESMTPSA (Nemesis) id
 1MC30Z-1rVoQF11LR-00CSWI; Sun, 31 Dec 2023 16:49:10 +0100
Received: by localhost.localdomain (Postfix, from userid 1000)
	id C849480098; Sun, 31 Dec 2023 16:49:08 +0100 (CET)
From: Sven Joachim <svenjoac@gmx.de>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org,  patches@lists.linux.dev,  Mauricio Faria de
 Oliveira <mfo@canonical.com>,  Christoph Hellwig <hch@lst.de>,  Jens Axboe
 <axboe@kernel.dk>,  Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 6.1 089/112] loop: do not enforce max_loop hard limit by
 (new) default
In-Reply-To: <20231230115809.666462326@linuxfoundation.org> (Greg
	Kroah-Hartman's message of "Sat, 30 Dec 2023 12:00:02 +0000")
References: <20231230115806.714618407@linuxfoundation.org>
	<20231230115809.666462326@linuxfoundation.org>
Date: Sun, 31 Dec 2023 16:49:08 +0100
Message-ID: <87y1dape2z.fsf@turtle.gmx.de>
User-Agent: Gnus/5.13 (Gnus v5.13)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain
X-Provags-ID: V03:K1:iASsc9y1+B9kBoxWnnVl/mmmjqfLDkMDoHd4Cz3XulKXJUY91Wx
 Z4BmBI+Qa7U+W+KOhWZjF5sfLffn6jH2lBkM3nuqW+/t5tuvm+yeVd4gPxePUieSmFU0JUI
 FMGY+mfd76Oop6N9/TDTUyOlfG8G02bR5CN1TEVXcEGNT9cbJ/WcicrsrP0JqAo4zFXwh4g
 7J9LOgC2suMO9n0hYxfZg==
X-Spam-Flag: NO
UI-OutboundReport: notjunk:1;M01:P0:Hw3V35oM3oc=;bLSri1artzPi0OnZwt1+wHu2ydN
 VUs1dB0I9EjSGFBiQtPUhywwpS2f+TcE7JP6hq/wQWCecheT0rcze2hPTo7taQxrhAeH8jU7y
 HuNSXFNZ6VvJikVt6FebY44JKLastecOl3DC5xIIHIJtTRbT0ja7e3J3ymIlASSqXScMjoIGY
 hZyeZfHTtkbM9IJ9cCtVkNznvA2Kz6qlQJZXwI+HulME2c4I2nJbZhzTcZqq6tLbj8K/MIklR
 z7fZzv1BzkQnFdZHGaEu1x8/N563mjU0Ydda2x7RTCy20qqJDCHOEzmBPxyDv2nqs0tItCPvp
 dXEn9MU1xU6nFUUbclaLDz0q+dGfIDhWOrEPIWxYJ6ktvFVF+mqox9nlKYPbCmWTaw17DqQSN
 Vah+Byn2V81xdFI082HE4m7eJ8iGlmu/oPVULdFejbzvnT+/U+oiLrEXpWDDwmFZOQwUzMSL5
 mq0vPiR2ot/UklFLJyXPYPyCuGKROJiBkaM028Ao5quOdWCBCv7t/VdsWL8YMtBuplSiNvnzV
 Knwm7GRTinsQ6okPrIdesYJyhtMyRgsQth81jCAdeKh5yV7LEqjvOu4dFteHPtBpIQeassZGZ
 58JANowxPLRN3fiUv/7zlACi8Hj2G6jrMioimAmUZAben49Vp4LtZJZ9jnZEfUTI12HLaHKEc
 +blrKiwTUejLcHjXsBcAj97ay742Y7b0wGyfXYe6RzkHsLDc4Tyx9gTsVz41CCfRJzu1DTAav
 epD9Su5QyyfNFFYfJ+qZH96OxUa09vbTq2hTrVKFo5FiTWNlIVhS/8VX6zd4ABStYUmXIre5Q
 xPcxrHtUTFz1Ib4eIZF+H6CJ6uTzO0QV90oC/ohyfKwn9egih6C0VVMMn2xr32WsgQskI3076
 F3/3DK8uV2NIw9uMMv2t4evpgQlR6issKXIbjPoqVADoBsH08QcvxtVTTQkyb85Q0GWyOphPS
 de3RuK5Q1t1mzlOTvWkygE/nFOE=
Content-Transfer-Encoding: quoted-printable

On 2023-12-30 12:00 +0000, Greg Kroah-Hartman wrote:

> 6.1-stable review patch.  If anyone has any objections, please let me kn=
ow.

This failed to build here:

,----
|   CC [M]  drivers/block/loop.o
| drivers/block/loop.c: In function 'loop_probe':
| drivers/block/loop.c:2125:6: error: 'max_loop_specified' undeclared (fir=
st use in this function)
|  2125 |  if (max_loop_specified && max_loop && idx >=3D max_loop)
|       |      ^~~~~~~~~~~~~~~~~~
| drivers/block/loop.c:2125:6: note: each undeclared identifier is reporte=
d only once for each function it appears in
| make[6]: *** [scripts/Makefile.build:250: drivers/block/loop.o] Error 1
`----

> @@ -2093,7 +2122,7 @@ static void loop_probe(dev_t dev)
>  {
>  	int idx =3D MINOR(dev) >> part_shift;
>
> -	if (max_loop && idx >=3D max_loop)
> +	if (max_loop_specified && max_loop && idx >=3D max_loop)
>  		return;
>  	loop_add(idx);
>  }

If CONFIG_BLOCK_LEGACY_AUTOLOAD is not set, max_loop_specified is
undeclared.  Applying commit 23881aec85f3 ("loop: deprecate autoloading
callback loop_probe()") fixes that.

Cheers,
       Sven
