Received: from maynard.decadent.org.uk (maynard.decadent.org.uk [65.21.191.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1DC9424DCF9;
	Mon,  1 Jun 2026 17:22:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=65.21.191.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780334522; cv=none; b=qGACxIWcurxzf9XagUHBER0IECNn+iH9vl3RgkxIdX/yjH/g6kn692UO6MifhnOrHDYFqYI/7Skn4FxPf8g798hg1V1VDQ0QUxqkW9dLWSsCspqSj9Q1EB1FvEgEjVo0qjW81yn6yMOPO9dF4Z1dAhGE94zdD/cSt0X7SVmBh70=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780334522; c=relaxed/simple;
	bh=yoJHAYVXF75NXAc5uyzodlVcXJV6tlxBGccr5HCLApI=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=g4gHldubMpL5WCwbziQk8CAYO8Wccup9bybW6/VLRUmsXrXFYEwndcjEyXinIG5AnVy3L9+Tjiz+I/LPfNDLwiSR+frgP/lzivBGwieeEjJkieyMkYAY0CmOKj4fanDy5KF3OEFVj/BBA9GB3f8ijv1FeiHy8bEL5UY7ew/u0Fw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=decadent.org.uk; spf=pass smtp.mailfrom=decadent.org.uk; arc=none smtp.client-ip=65.21.191.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=decadent.org.uk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=decadent.org.uk
Received: from [2a02:578:851f:1502:391e:c5f5:10e2:b9a3] (helo=deadeye)
	by maynard with esmtps  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.96)
	(envelope-from <ben@decadent.org.uk>)
	id 1wU6Kt-000WiQ-0U;
	Mon, 01 Jun 2026 17:21:59 +0000
Received: from ben by deadeye with local (Exim 4.99.2)
	(envelope-from <ben@decadent.org.uk>)
	id 1wU6Ks-0000000Fkh1-3Bzp;
	Mon, 01 Jun 2026 19:21:58 +0200
Message-ID: <8135746e835e432d7b0f21e142389cf8b4979f0f.camel@decadent.org.uk>
Subject: Re: [PATCH 5.10 257/589] PCI/AER: Stop ruling out unbound devices
 as error source
From: Ben Hutchings <ben@decadent.org.uk>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, Lukas Wunner <lukas@wunner.de>, Bjorn Helgaas
	 <bhelgaas@google.com>, Stefan Roese <stefan.roese@mailbox.org>
Date: Mon, 01 Jun 2026 19:21:48 +0200
In-Reply-To: <20260530160231.730576543@linuxfoundation.org>
References: <20260530160224.570625122@linuxfoundation.org>
	 <20260530160231.730576543@linuxfoundation.org>
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-kDPoebwS4zxNJ7TnWhDY"
User-Agent: Evolution 3.56.2-9 
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-SA-Exim-Connect-IP: 2a02:578:851f:1502:391e:c5f5:10e2:b9a3
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on maynard); SAEximRunCond expanded to false


--=-kDPoebwS4zxNJ7TnWhDY
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sat, 2026-05-30 at 18:02 +0200, Greg Kroah-Hartman wrote:
> 5.10-stable review patch.  If anyone has any objections, please let me kn=
ow.
>=20
> ------------------
>=20
> From: Lukas Wunner <lukas@wunner.de>
>=20
> commit 1ab4a3c805084d752ec571efc78272295a9f2f74 upstream.
>=20
> When searching for the error source, the AER driver rules out devices who=
se
> enable_cnt is zero.  This was introduced in 2009 by commit 28eb27cf0839
> ("PCI AER: support invalid error source IDs") without providing a
> rationale.
>=20
> Drivers typically call pci_enable_device() on probe, hence the enable_cnt
> check essentially filters out unbound devices.  At the time of the commit=
,
> drivers had to opt in to AER by calling pci_enable_pcie_error_reporting()
> and so any AER-enabled device could be assumed to be bound to a driver.
> The check thus made sense because it allowed skipping config space access=
es
> to devices which were known not to be the error source.
>=20
> But since 2022, AER is universally enabled on all devices when they are
> enumerated, cf. commit f26e58bf6f54 ("PCI/AER: Enable error reporting whe=
n
> AER is native").

That commit went into 6.0 and didn't get backported, so this doesn't
seem to be needed here.

Ben.

>=20
> Errors may very well be reported by unbound devices, e.g. due to link
> instability.  By ruling them out as error source, errors reported by them
> are neither logged nor cleared.  When they do get bound and another error
> occurs, the earlier error is reported together with the new error, which
> may confuse users.  Stop doing so.
>=20
> Fixes: f26e58bf6f54 ("PCI/AER: Enable error reporting when AER is native"=
)
> Signed-off-by: Lukas Wunner <lukas@wunner.de>
> Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
> Reviewed-by: Stefan Roese <stefan.roese@mailbox.org>
> Cc: stable@vger.kernel.org # v6.0+
> Link: https://patch.msgid.link/734338c2e8b669db5a5a3b45d34131b55ffebfca.1=
774605029.git.lukas@wunner.de
> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> ---
>  drivers/pci/pcie/aer.c |    2 --
>  1 file changed, 2 deletions(-)
>=20
> --- a/drivers/pci/pcie/aer.c
> +++ b/drivers/pci/pcie/aer.c
> @@ -853,8 +853,6 @@ static bool is_error_source(struct pci_d
>  	 *      3) There are multiple errors and prior ID comparing fails;
>  	 * We check AER status registers to find possible reporter.
>  	 */
> -	if (atomic_read(&dev->enable_cnt) =3D=3D 0)
> -		return false;
> =20
>  	/* Check if AER is enabled */
>  	pcie_capability_read_word(dev, PCI_EXP_DEVCTL, &reg16);
>=20
>=20

--=20
Ben Hutchings
The obvious mathematical breakthrough [to break modern encryption]
would be development of an easy way to factor large prime numbers.
                                                           - Bill Gates

--=-kDPoebwS4zxNJ7TnWhDY
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEErCspvTSmr92z9o8157/I7JWGEQkFAmodv6wACgkQ57/I7JWG
EQlrRw/8CM6j9BawsY2jMNguhoanC3IYeLqeqhrh2T7iaAem7wX0JDlJJPV7K8uB
/49kQ9MBWDRo070676bzt4QMHaqF36mB2O6zw3SK3/jN3wFg99dNk3ctjJmUAuNC
+QPd3k0VByPVuBJmkWdi75IczleKoOFQwJbuf9UxNUEnPThFYLwKyzlB61KV43uH
r7FtagecfvAjkH9Fe9+IExT0b4DOwNgmxDc9O7cvYgqeeM+fgN4XokmS1n7hPr8S
sX3zQP/VUojrJbsmtzRtGbhLbeiIbalQWOBNFZZ324e5UZPMtMWjr+VmeOE+5TLe
exSsAVaXNbNfB5rdg7nfnVjPORYYALwvyZWr8VVgKNhysi4b/yihNiAY/3iKL6A3
yEMCvGu1uTjVvWVDhOGOmuHiX7Ddew76sygyZsQB4sLET79U0xrHF5+KM7iRyj8r
rSE2lGDWt4wCfomgW4e3zs72e9gJDA2OKAakyE+L4GFzHeSMouErgGMnHMA+yivl
FDACq6ejrk4YkHDcxyN8Chvx8BEY5yj1FLYBXeV6YNJEgMRdtzc/HkR0dJ31cak2
z2SAKVjoLCHCSfJR2uQ8bKB7ppcAM+iiGpqL+KBAX9O6CTf8oD/bDgSmeUe7kafk
0s6lua6jsY21EeEMqklmi2+PsfZS35njxR1/XoRpW3DwhAQE8AQ=
=SSLh
-----END PGP SIGNATURE-----

--=-kDPoebwS4zxNJ7TnWhDY--
