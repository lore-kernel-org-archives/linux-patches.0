Received: from maynard.decadent.org.uk (maynard.decadent.org.uk [65.21.191.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A2D0523741;
	Tue, 10 Feb 2026 16:07:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=65.21.191.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770739630; cv=none; b=ZBQ3UYxGWnkFBOGPmAOtZNrVs9z4tu3zaNw924nctKm0nNbVtYBrWcnszY0hA9IM5QejxH5961oyCZkPe4dV/JnKuhKEU6YupbBUEQFMK4s2j1EjnxoQZf+xrq5FAOS9SS4fbimIdn5rEiLW1G5ZmprL/h72q3JSygKJmKfZEXY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770739630; c=relaxed/simple;
	bh=UJY7ILzFaSA8sP8FhTKXCv+lFSKTNojyFJPE7WNCvBA=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=PvqoH0w4M9Nmzn4K9jS+zYYkOaliiuJ3JG2MiNDUb+C/X+qQ79hxtNRvp4ERBnX2aoaTeSXmA5zciEw8EmrL1ifZc8pUVX4OI7nz9O4qh7alDCK+DH+KTPFHn3/RcunEvE67tLHEYgY7A2nggLLkkQjr+MCgtHIEgWVM2E02kwY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=decadent.org.uk; spf=pass smtp.mailfrom=decadent.org.uk; arc=none smtp.client-ip=65.21.191.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=decadent.org.uk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=decadent.org.uk
Received: from [2a02:578:851f:1502:391e:c5f5:10e2:b9a3] (helo=deadeye)
	by maynard with esmtps  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.96)
	(envelope-from <ben@decadent.org.uk>)
	id 1vpqGT-0008LI-1N;
	Tue, 10 Feb 2026 16:07:00 +0000
Received: from ben by deadeye with local (Exim 4.99.1)
	(envelope-from <ben@decadent.org.uk>)
	id 1vpqGR-00000002SVq-2DZR;
	Tue, 10 Feb 2026 17:06:59 +0100
Message-ID: <94cad986396d5a231a60d41cb6f86da146a6b435.camel@decadent.org.uk>
Subject: Re: [PATCH 6.12 519/567] gpiolib: acpi: Move quirks to a separate
 file
From: Ben Hutchings <ben@decadent.org.uk>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, Hans de Goede <hdegoede@redhat.com>, Mika
 Westerberg <mika.westerberg@linux.intel.com>, Andy Shevchenko
 <andriy.shevchenko@linux.intel.com>,  Sasha Levin <sashal@kernel.org>
Date: Tue, 10 Feb 2026 17:06:50 +0100
In-Reply-To: <20260106170510.584316139@linuxfoundation.org>
References: <20260106170451.332875001@linuxfoundation.org>
	 <20260106170510.584316139@linuxfoundation.org>
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-LP3ZT70abYpvZkAbkFdS"
User-Agent: Evolution 3.56.2-8 
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-SA-Exim-Connect-IP: 2a02:578:851f:1502:391e:c5f5:10e2:b9a3
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on maynard); SAEximRunCond expanded to false


--=-LP3ZT70abYpvZkAbkFdS
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, 2026-01-06 at 18:05 +0100, Greg Kroah-Hartman wrote:
> 6.12-stable review patch.  If anyone has any objections, please let me kn=
ow.
>=20
> ------------------
>=20
> From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
>=20
> [ Upstream commit 92dc572852ddcae687590cb159189004d58e382e ]
>=20
> The gpiolib-acpi.c is huge enough even without DMI quirks.
> Move them to a separate file for a better maintenance.
>=20
> No functional change intended.
[...]

However, this did cause some documentation breakage.  Please cherry-pick
commit ec0c0aab1524 ("gpiolib-acpi: Update file references in the
Documentation and MAINTAINERS") to fix that.

Ben.

--=20
Ben Hutchings
It's easier to fight for one's principles than to live up to them.

--=-LP3ZT70abYpvZkAbkFdS
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEErCspvTSmr92z9o8157/I7JWGEQkFAmmLV5oACgkQ57/I7JWG
EQmO+RAApbQpF7LmiZET50cTi6njW9ZW6/bfrzxoZ6RIrDVSJ9S4tjxMw7huMAqf
tqB/lxWjjEqyz48R2091w7ekixYzGueBx0Uyk36rLd65yOiIgHHxNzECJeQGq6KC
p5PaRKycR3tSQ3kEEqphRV9NNYzvBQnIrBIYAaZL+bQvNfEBZxwtGbtCepFUbPxl
d+uVL3q40eh9IuoTTd+AEwflXkdiA3erpUuqhpDPvs57FJUw3mWJkSJJWtbpUiKG
BIu65GXARhZ4dZFS1/qtxIPPj5XnEfva8q0e1ZV36zDOGjW37uGe/lvND6eoiZC2
gXb6vJy45bcFgjXY301xaazOZqY8T7E6LvJvIC4sScetXZdb8dWOTpTJ0XYpWvBN
4xZSnCJ46orpmr7uz7ysctRht0BifxW8Zh6Y4g/t4ZFaftbH+K+aWTf82mdsJzje
dqCxRDJwTgvt5nwLobloq6xXv2vDkSblFzCk6BR0+QcXDO5ofiqBMBDt+CgP30JA
knzwQymYAJuc3NciXb28sTM1fIU/0oVBqhp/qjW3IP2j8Qac5S6h4PRGyiLLs/Pc
idJhA5q5zDI3gb28/9GN4KCl+W2lkqK5H5dkAamttgLrtsp1W3TNLX6K72+lLXX6
mJrwPHxbDjNoRYn/tEpZhPQW5iKsS4kGIMeFK1IX7lEkLbnjtt4=
=Cu08
-----END PGP SIGNATURE-----

--=-LP3ZT70abYpvZkAbkFdS--
