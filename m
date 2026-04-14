Received: from mx.nabladev.com (mx.nabladev.com [178.251.229.89])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6049D285CAA
	for <patches@lists.linux.dev>; Tue, 14 Apr 2026 08:09:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=178.251.229.89
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776154176; cv=none; b=LdKGfrGSu+o4IYC8nnbw7IbNrS9Pm18/1GvyHX31lyfeHDkktAAaaklYeV+UwFf46QfKEm8lPI2P53Mud6hj/NDR77ZKkK4eCpz3r8Ma2zqwYbFnawICkTiMBCFIHECHFCdsLAnhLyjtiFq9l7UxhofR5WofklgbmO0hs7g16FY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776154176; c=relaxed/simple;
	bh=FPNwZtL+D1kyGOizpfCxylR4jmeJWzKgIkGYJofW3eQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=eZDsgjFFFkqQWWdyfUHT3f6StwkzAck/bSwCu32VbCGPIe06bNi1YyzApVyjaLEFn6FyWddpXr9Vfsg7PX+BFAQzAVHCYpDT26B2N2qTnGvVMHKMI/+TQ7fvQqfBbypmi4f0tN5ILE9KJ73lIa+fKtHpqQe5zh5RAEftlUI6CQU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nabladev.com; spf=pass smtp.mailfrom=nabladev.com; dkim=pass (2048-bit key) header.d=nabladev.com header.i=@nabladev.com header.b=LUW53/Nw; arc=none smtp.client-ip=178.251.229.89
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nabladev.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nabladev.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nabladev.com header.i=@nabladev.com header.b="LUW53/Nw"
Received: from [127.0.0.1] (localhost [127.0.0.1]) by localhost (Mailerdaemon) with ESMTPSA id C98A41104EE;
	Tue, 14 Apr 2026 10:09:29 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nabladev.com;
	s=dkim; t=1776154171;
	h=from:subject:date:message-id:to:cc:mime-version:content-type:
	 in-reply-to:references; bh=JqXAndzKjUTSYdsv3LlLRbQ67ja65YZI/lXeILwQils=;
	b=LUW53/NwPDGqtkd+uW8GeK96L00vdDdCIL+TUbifd+y7CITGKadig4mzH2ptQvrxyj1mbo
	S8UvXHRc6VuSTC+ChkHfI516DVbgDYiEa3MSbpez4Jhy72SRdqkLuVJn1IXUs5rtYGtrqT
	k8OjtITR3UGlU+uZxvyxjavnZzRPj7X5NyYTBzkNewZCxK/W5hDH6NRge/bHrebpvsIR2O
	86t6Fhg3wcGjTD847TQaJY8EwXUiDusZcGvX3mvGE7Kze5wVh2g6k+UH982p/h06R/tubn
	Er60/CyE+WZP1JM4nhrxoU3P3PP4d/atrn+DtwJDq20vdlAEjeQsr1jTVELN4A==
Date: Tue, 14 Apr 2026 10:09:28 +0200
From: Pavel Machek <pavel@nabladev.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org,
	pavel@nabladev.com, jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, rwarsow@gmx.de, conor@kernel.org,
	hargar@microsoft.com, broonie@kernel.org, achill@achill.org,
	sr@sladewatkins.com
Subject: Re: [PATCH 5.15 000/570] 5.15.203-rc1 review
Message-ID: <ad32OJPGEmz_t4s_@duo.ucw.cz>
References: <20260413155830.386096114@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="nm1J3qj/KJrnbe8D"
Content-Disposition: inline
In-Reply-To: <20260413155830.386096114@linuxfoundation.org>
X-Last-TLS-Session-Version: TLSv1.3


--nm1J3qj/KJrnbe8D
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi!

> This is the start of the stable review cycle for the 5.15.203 release.
> There are 570 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

CIP testing did not find any problems here:

https://gitlab.com/cip-project/cip-testing/linux-stable-rc-ci/-/tree/linux-5.15.y

Tested-by: Pavel Machek (CIP) <pavel@nabladev.com>

Best regards,
                                                                Pavel

--nm1J3qj/KJrnbe8D
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCad32OAAKCRAw5/Bqldv6
8lR8AKDAdWwNyeO9Z63lPNnZKxqzoqNf0ACgm0P/VWhBnVoD0vF+k7vzRxkOs5Y=
=vI9A
-----END PGP SIGNATURE-----

--nm1J3qj/KJrnbe8D--
