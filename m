Received: from maynard.decadent.org.uk (maynard.decadent.org.uk [65.21.191.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7625D1DFD96;
	Thu,  5 Feb 2026 23:09:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=65.21.191.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770332980; cv=none; b=ggWYcj0ksHcNmSjcfeCLZ4+EgANMCuE+qBDDzjmhEllbC3ljJrwlYc7kguS4AuQa3PmniqbR151fNStTaFpadIYZ7DY6baqClUSo/GzcGsDafWahg2XeLGJqcCC4XENpGr007rx5Ajx6lMr+UshMV+UcEt0jMyJl4FcalHtMYRM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770332980; c=relaxed/simple;
	bh=JP426iVcaWPvib54cYM5aAiRZN1e/AgyY2xQnBo4wxk=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=c7iKivhcojJf4U7KDlM088BA0vD1/UOMphkc9I4PdhFRCHByg8iGPpSlctQWBgvVJt/K3baGJc3yx2y38JnFkUDj8s2sm8SYE6yrzA9PcdWw1WkHs3VgvW55HV8tDGuUKRUoWKAbXSFvl2coaw9q+NcMIa8wH3eQ2LK0AVVWyEg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=decadent.org.uk; spf=pass smtp.mailfrom=decadent.org.uk; arc=none smtp.client-ip=65.21.191.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=decadent.org.uk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=decadent.org.uk
Received: from [2a02:578:851f:1502:391e:c5f5:10e2:b9a3] (helo=deadeye)
	by maynard with esmtps  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.96)
	(envelope-from <ben@decadent.org.uk>)
	id 1vo8Tg-003wtu-0V;
	Thu, 05 Feb 2026 23:09:35 +0000
Received: from ben by deadeye with local (Exim 4.99.1)
	(envelope-from <ben@decadent.org.uk>)
	id 1vo8Te-00000001ipL-0vCq;
	Fri, 06 Feb 2026 00:09:34 +0100
Message-ID: <bce38fd1f10ecc0ae3ec3ccf95da89f58ca3e623.camel@decadent.org.uk>
Subject: Re: [PATCH 5.10 080/161] scsi: hisi_sas: Use managed PCI functions
From: Ben Hutchings <ben@decadent.org.uk>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, Xiang Chen <chenxiang66@hisilicon.com>, John
 Garry	 <john.garry@huawei.com>, "Martin K. Petersen"
 <martin.petersen@oracle.com>,  Sasha Levin <sashal@kernel.org>
Date: Fri, 06 Feb 2026 00:09:29 +0100
In-Reply-To: <20260204143854.629264200@linuxfoundation.org>
References: <20260204143851.755002596@linuxfoundation.org>
	 <20260204143854.629264200@linuxfoundation.org>
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-PtuHCLC74femXQ59onCA"
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


--=-PtuHCLC74femXQ59onCA
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, 2026-02-04 at 15:39 +0100, Greg Kroah-Hartman wrote:
> 5.10-stable review patch.  If anyone has any objections, please let me kn=
ow.
>=20
> ------------------
>=20
> From: Xiang Chen <chenxiang66@hisilicon.com>
>=20
> [ Upstream commit 4f6094f1663e2ed26a940f1842cdaa15c1dd649a ]
>=20
> Use managed PCI functions such as pcim_enable_device() and
> pcim_iomap_regions() to simplify exception handling code.
>=20
> Link: https://lore.kernel.org/r/1629799260-120116-2-git-send-email-john.g=
arry@huawei.com
> Signed-off-by: Xiang Chen <chenxiang66@hisilicon.com>
> Signed-off-by: John Garry <john.garry@huawei.com>
> Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
> Stable-dep-of: d5077426e1a7 ("drm/amd/pm: Don't clear SI SMC table when s=
etting power limit")

WTF?  That's a totally unrelated driver.

Unless this is actually fixing something I think it can be dropped,
since there are no other patches to hisi_sas in this series.

Ben.

> Signed-off-by: Sasha Levin <sashal@kernel.org>
> ---
>  drivers/scsi/hisi_sas/hisi_sas_v3_hw.c | 20 ++++++++------------
>  1 file changed, 8 insertions(+), 12 deletions(-)
[...]

--=20
Ben Hutchings
Beware of programmers who carry screwdrivers. - Leonard Brandwein

--=-PtuHCLC74femXQ59onCA
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEErCspvTSmr92z9o8157/I7JWGEQkFAmmFIykACgkQ57/I7JWG
EQmuVxAAte9Mu/VmC4t4tlomg1By2jg5j2dbeTJVuJ2IBOAagHHkgHHoTWJRGds+
4ATXRJxO3GI51Hy9A37ka5WK583gISSgZW0yVMvsT4cVkYIdKsJULesencDL27tJ
yq5B9z79JmALvEdDDWa0pvUFG5g/1li8+HyRqDwS91IWVo7mSB9FX3C56NpqEcFl
aBSAfdmFfiRqNpLjZ3FkSE1mFGQP9hISEuJTPOecGUZE/pjYJ+ymU1NzDLpI67ZC
Ky9idrrx9eGQIdxtUZR3A/ol4iln2Lk1N3kC59fWTFnDt93RYLYDNahFTAb5JxdR
8x8KOsF9SiWK9cJUJ1gjay6yWPVR6FL/SOgjnWxClEo+822RkoumAth2L4xVYQN8
JF6XjyYt4t0BwUmk8T7hn0oOFnXRrfG1TQbo3chG87ooWYv8oYeRrW2dpFYVEcBr
ZwaM5AXYEMPRbTmxeffasgoMXBUWgxZ4mIOlAZaI0EyBceEfVUcQpzHVERZtw9pE
npel2HG1HLSa3/aA2Ab3wXXpU183GLG5j3889g8/RQVuifAXE5yMnMSLjxQhXqeq
A8/foKOnYBzPfDgLusgMvrsisWHO+jomdr0HI04FgnePVr564tJY3zmlkkGdKvmj
HpzaJlenbHjzFN7Csgl4i+q6JawZ+HW8kkBDGVlpTER8d0FC8Io=
=poYT
-----END PGP SIGNATURE-----

--=-PtuHCLC74femXQ59onCA--
