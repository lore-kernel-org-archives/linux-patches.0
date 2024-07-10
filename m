Received: from mout.kundenserver.de (mout.kundenserver.de [212.227.126.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C20A517BB20;
	Wed, 10 Jul 2024 09:08:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.227.126.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720602491; cv=none; b=jZ/PmMt3o8bjKe6yYx9l4SuXkiM8qTuCYxpxYUJYacFf6rb/2tFQ4UCFd+B7V9Ik69hKii0kpz45tEbKg28wavrEseGV0oTR21vnJ/tqUh2/G1Hdjqwn80mxzanWosVWKV9Nqg+5j/Ia4rY440IPWuXXN53uQ9i/u863MbRwIsw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720602491; c=relaxed/simple;
	bh=OwXkbQR+5KO3sIQFguLEwnm3xencoPLxOiyIzddz444=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=M27FspTn+ypFhTig/bNw+CbSwtBVoZShDPDJz4qQbQpkDuARdNveWFJBAIZNmpHi0p3DVoVvH4GexXYMfMuQCaSsY2JOtFwzz/QrTuM/l/urdckN4CFPUE3+IX2PfqVcysvJ2C/D7ojx45SWzQs1JHI+NWMFFdustri1Xi/MzEY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=heusel.eu; spf=pass smtp.mailfrom=heusel.eu; dkim=pass (2048-bit key) header.d=heusel.eu header.i=christian@heusel.eu header.b=zEYHOl8V; arc=none smtp.client-ip=212.227.126.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=heusel.eu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=heusel.eu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=heusel.eu header.i=christian@heusel.eu header.b="zEYHOl8V"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=heusel.eu;
	s=s1-ionos; t=1720602449; x=1721207249; i=christian@heusel.eu;
	bh=5PIwsLcrFIdPwJQZDhPgaBW9K4bw6t/Q6QH8AE4deKA=;
	h=X-UI-Sender-Class:Date:From:To:Cc:Subject:Message-ID:References:
	 MIME-Version:Content-Type:In-Reply-To:cc:
	 content-transfer-encoding:content-type:date:from:message-id:
	 mime-version:reply-to:subject:to;
	b=zEYHOl8V6eECJnc9e7nBDpsuQp5KmmckZm7oy4bNXqNO6me7OpCqeWnKVERg58sU
	 0MRThqLXO1SUUjvjylxtTYZ1DTd1WKmqqLtoeY5QGyiQKsjHmcWTj7PJ2WSCOs74C
	 1W1Sx6vVdcw1SmGkeeleeU16sqKob/Q7zNByaHKCX8eUHE7iOAcqv0BzkI3YfaWv0
	 lfcPST4DuArldIzfruS8dkVuhAHrGlGpEU3wySimy30pKa8UBObZElGx5IQBOEhY7
	 nRNG0b3zTvvSjHkMaY/3x6HfcHXny8Gqcrz7e6+d55tH0HVTpMDOvUT0LkZBve5cp
	 PnKrjD/8xdJWboPWVQ==
X-UI-Sender-Class: 55c96926-9e95-11ee-ae09-1f7a4046a0f6
Received: from localhost ([78.42.228.106]) by mrelayeu.kundenserver.de
 (mreue012 [212.227.15.167]) with ESMTPSA (Nemesis) id
 1MXGSU-1ssO583pNu-00Wevz; Wed, 10 Jul 2024 11:07:29 +0200
Date: Wed, 10 Jul 2024 11:07:22 +0200
From: Christian Heusel <christian@heusel.eu>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, akpm@linux-foundation.org, 
	linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org, 
	lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com, f.fainelli@gmail.com, 
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org, 
	allen.lkml@gmail.com, broonie@kernel.org
Subject: Re: [PATCH 6.9 000/197] 6.9.9-rc1 review
Message-ID: <c5e979e5-5ce2-43a4-ad86-6ed779d54ba3@heusel.eu>
References: <20240709110708.903245467@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="jxwcuumspbzxvdfq"
Content-Disposition: inline
In-Reply-To: <20240709110708.903245467@linuxfoundation.org>
X-Provags-ID: V03:K1:ww2f4s8MdUQNw9cGPyRTkxacyq3HXWtMuuDsmaA0sLh4VXHxSMI
 UUS4SAz6tEIMNllJmbc1+IlE9AUbDf6CQ3ekzNxMPcay+7vxxIhhzpp1PIv3J9mFp0iimhD
 EQQBhFlOVzy6K7obuchzil0RLyPn7MyxTt9H7fNGYytlNdcCItIrefKLSHVM5oSDiCtWIuF
 K8WQRneBTfZ4PkfpCbbwg==
X-Spam-Flag: NO
UI-OutboundReport: notjunk:1;M01:P0:8SQpYoMcCi0=;yhDVnOh0dGbq7JjeAYgaLedvq1N
 54YxbfzyZ6QOBZaQBhK606kYub/PiiPljIKWjF24+iM3FDFIJy0ULMHjaKZCC7X/rGgQdrL4+
 uWMkslXeq5Xusrvuaba7F0oqu/LWno2ffyrTwKOfl/jXivZp+IOWsV/zLZPgY9UkBVRl/j+2+
 CMThwy5Bv6UiYCnBwHPCTB7t+bHu3lbWhnOGTKoNYAd9pB58WtYqh4/3OPP4TW3XhiiTJLQkQ
 DVN1pshiPvH8CwZEodnA8i3S2n/IyFxwyeY3j92A9H3i5F79cvUNRX3AxX1lcN08r60B7lO+j
 izVkGfb7iVjRRmUBPDom49YWSDqFxomRsT31oYvwnljwIjBTgx9mAu5rDUiK2nYgV9MaEqwSt
 aRCZgJipD5PqypadVTHv8JcKTNvFgqM4l6x6GzXk82HI57ErUHa3Pj2nmLpE7fDp0jn0i9iFb
 zHxQpnRhKmju8i4bVdVS9lelq+V7zAe+1/S6EKDfl1b/w+SjvMK6RJ34DoUDkE+6xS/Pbvnrz
 KJXPoFoTOT+cotXomyjHwGZJCJP2KKturQ9QnLHUlWwR2qd0Wy/n/mjiQHVSb1be2VK9Yzjtq
 oPRd71TbYoUIb425/pyCy0laWMA6aBx7lgRFLrN8PGxEJ668PlbWyX7VnoIhpMO3Up0y5Crvz
 NFCbf8rk1cIwYM+O9DGiexPTUyXlxihms1OIORQW3er3mKRTORCSwrvyZF9qaNrJ0Y7SUhrg7
 NDsOGpvSAGyFs+VA+Q3NqFqxjPCy1uOik1i0cUiEE5F/BCvuUmu8P0=


--jxwcuumspbzxvdfq
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On 24/07/09 01:07PM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.9.9 release.
> There are 197 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

Tested-by: Christian Heusel <christian@heusel.eu>

Tested on a ThinkPad E14 Gen 3 with a AMD Ryzen 5 5500U CPU

--jxwcuumspbzxvdfq
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEEb3ea3iR6a4oPcswTwEfU8yi1JYUFAmaOT0oACgkQwEfU8yi1
JYXKdg//Z6AdxMj1uOO3F9jbk434AeEZGvxIGnuTMFdA3oW3TXnNWEevz4E/om3X
IZFuI7Pgj8vaPpo+QfgY28rTpAzSdK2Vmq8TkVj3cNWMegl8dKefHcgabPVDV3kD
il6Af/YhWQqhvLLe5tHoruRTnHU9pIIxXGQ5fCsPlBKN/RicbbmkvoUIvHnRmO3F
1defbp9WajPuGt3XvHKa8ruA9Xc+cczx1Ul9Guy5DSX0j7v0lGH4NKz0kmKm9pHD
1qMO/Afb2k1BnNgWHhQYs6ujPI2BJlNGtYoh3HzLpeaNupZGRSrWojZ7/eKB9IUq
jISOPwuYwzYwPZDwttMLvtLXbCvbhqsfa0SDFddGn/ZieUWr1KItB80z0TTnjN9T
hrBjhotnZrhcPlcU/SPNO6RN5urkjaolT5RGCsIbfcgoqvmCXN5pS6N1R/0ePXAw
SxwmyyIgxhLSq/5jCy+WU3z5Ybmgm0lBiD1IRtzSo6GX4VhT2nfuPm8Mnn3wn7gP
dOeQTnLOUuJsgaamKz24gvfZEcmdZjklfBVmmsfsCESFz6YJ5xVqZFfWe6rrbSIE
oTztzSE862tRxpfi5NM+OEwZ8j/0k/MsdwEMM0oIl807W5YwmlJ6yg6b+4PuSJtU
Yww5AxPrE2ROwuJzM1XO8tPk5bfDNeP0Ygz3a5UA+dqo43X2hBQ=
=7186
-----END PGP SIGNATURE-----

--jxwcuumspbzxvdfq--
