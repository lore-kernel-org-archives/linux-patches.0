Received: from jabberwock.ucw.cz (jabberwock.ucw.cz [46.255.230.98])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0AA33315531
	for <patches@lists.linux.dev>; Fri,  4 Jul 2025 16:08:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=46.255.230.98
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751645318; cv=none; b=suHWcJgpVzNHnmshJWGSYEc/mE1oyKtm43QRFo8ZBmAkFqQMaHmVT80LoEEdU3J1O41APazRFiEq2pMlmov+9g34do8fUjCCJyMVaybF4uNxfIRzwafnsd5poWGVU1p2sqCd17TWVm1ryfP0DBzmV2UgaWLIFp4OADi9O5llPD0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751645318; c=relaxed/simple;
	bh=IQSgTvu22z4jTaDwUlpFakllNJA2GFU2ZRgOrcqMBtU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=GKi9i7AzhZ3UVYdwhNc7Xo743KA0qMqk0EWZkBdWz3XMyObISjb8a7qTrQX+DMMUafVmWMk0hkZFbuSCjH6v2JUS0JUHPkLQrgGOf8d91AN4VLCVIDQadEuTZoq5Yhd0eUziYequvS/ghTDARa9m941A6aVK//V1M1Og+tR/vtM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=ucw.cz; spf=pass smtp.mailfrom=ucw.cz; dkim=pass (1024-bit key) header.d=ucw.cz header.i=@ucw.cz header.b=H/Urj6gs; arc=none smtp.client-ip=46.255.230.98
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=ucw.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ucw.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=ucw.cz header.i=@ucw.cz header.b="H/Urj6gs"
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
	id DF2E61C00AB; Fri,  4 Jul 2025 18:08:31 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ucw.cz; s=gen1;
	t=1751645311;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=s9iZagXbgeik5aaC+851EKPeAc4Tqrh9L/My33iJMYY=;
	b=H/Urj6gsjU5qY8q0XrsdPU31uI6Q2hUx6ukRIUyEBSgHLNpdeB9ysDNH7KXpOj94YL/KwM
	zzBVMP6MaRZ6bZPqnFjpOwO2thfHF3/AAj+YGw7WQsPZih5xWBju/WREsyVdRikyuVEby3
	hPGarU7bZQvaW6gzfe9FZyjuLPt6Plw=
Date: Fri, 4 Jul 2025 18:08:31 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	Jacek Anaszewski <jacek.anaszewski@gmail.com>,
	Tobias Deiminger <tobias.deiminger@linutronix.de>,
	Sven Schuchmann <schuchmann@schleissheimer.de>,
	Sven Schwermer <sven.schwermer@disruptive-technologies.com>,
	Lee Jones <lee@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 6.1 007/132] leds: multicolor: Fix intensity setting
 while SW blinking
Message-ID: <aGf8fwdvCgr4jVjr@duo.ucw.cz>
References: <20250703143939.370927276@linuxfoundation.org>
 <20250703143939.681590816@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="6/9YvccF99rIB7pV"
Content-Disposition: inline
In-Reply-To: <20250703143939.681590816@linuxfoundation.org>


--6/9YvccF99rIB7pV
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu 2025-07-03 16:41:36, Greg Kroah-Hartman wrote:
> 6.1-stable review patch.  If anyone has any objections, please let me kno=
w.

Let's not do that. Blinking at wrong intensity is not nearly
significant enough bug to risk regressions.

And please stop using bots for patch selection.
							Pavel

> ------------------
>=20
> From: Sven Schwermer <sven.schwermer@disruptive-technologies.com>
>=20
> [ Upstream commit e35ca991a777ef513040cbb36bc8245a031a2633 ]
>=20
> When writing to the multi_intensity file, don't unconditionally call
> led_set_brightness. By only doing this if blinking is inactive we
> prevent blinking from stopping if the blinking is in its off phase while
> the file is written.
>=20
> Instead, if blinking is active, the changed intensity values are applied
> upon the next blink. This is consistent with changing the brightness on
> monochrome LEDs with active blinking.
>=20
> Suggested-by: Jacek Anaszewski <jacek.anaszewski@gmail.com>
> Acked-by: Jacek Anaszewski <jacek.anaszewski@gmail.com>
> Acked-by: Pavel Machek <pavel@ucw.cz>
> Reviewed-by: Tobias Deiminger <tobias.deiminger@linutronix.de>
> Tested-by: Sven Schuchmann <schuchmann@schleissheimer.de>
> Signed-off-by: Sven Schwermer <sven.schwermer@disruptive-technologies.com>
> Link: https://lore.kernel.org/r/20250404184043.227116-1-sven@svenschwerme=
r.de
> Signed-off-by: Lee Jones <lee@kernel.org>
> Signed-off-by: Sasha Levin <sashal@kernel.org>
> ---
>  drivers/leds/led-class-multicolor.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
>=20
> diff --git a/drivers/leds/led-class-multicolor.c b/drivers/leds/led-class=
-multicolor.c
> index ec62a48116135..e0785935f4ba6 100644
> --- a/drivers/leds/led-class-multicolor.c
> +++ b/drivers/leds/led-class-multicolor.c
> @@ -61,7 +61,8 @@ static ssize_t multi_intensity_store(struct device *dev,
>  	for (i =3D 0; i < mcled_cdev->num_colors; i++)
>  		mcled_cdev->subled_info[i].intensity =3D intensity_value[i];
> =20
> -	led_set_brightness(led_cdev, led_cdev->brightness);
> +	if (!test_bit(LED_BLINK_SW, &led_cdev->work_flags))
> +		led_set_brightness(led_cdev, led_cdev->brightness);
>  	ret =3D size;
>  err_out:
>  	mutex_unlock(&led_cdev->led_access);

--=20
I don't work for Nazis and criminals, and neither should you.
Boycott Putin, Trump, and Musk!

--6/9YvccF99rIB7pV
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCaGf8fwAKCRAw5/Bqldv6
8hX2AJ9MFM0JXfD3C+Tna4T1SuREtpYTYgCfUtT2BtwLhVE6Q59HSDMRwkb3DIs=
=nzeT
-----END PGP SIGNATURE-----

--6/9YvccF99rIB7pV--
