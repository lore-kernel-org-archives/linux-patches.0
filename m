Received: from maynard.decadent.org.uk (maynard.decadent.org.uk [65.21.191.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 482F435B62F;
	Mon, 13 Apr 2026 21:10:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=65.21.191.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776114660; cv=none; b=TlajuZctwfkOeFc4jTz7tUwmyqmbDcOSC0L9XkXxXQOP7kcyuQGchFYgnCCNNvs9hgfGqD/bybWmxGsvKom09537wGWt/RMzb4G1tDZUCyaM369UFfp8NAubxlWbHlDiX10nfUBPKdWI5zH/nSXWiw+Q1fc0fEN8W5z6Oxjdf68=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776114660; c=relaxed/simple;
	bh=E9tlf8Bct13YCtYButRVoDjXu5pfBJtC88O/nwKLvT4=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=a8Y55JGvFU0h5zpr0T93yFVTRvNhxymLuck7WLS1pN0/4QoTjDXCTTBekz7Mz0rDBkKvucgiz/OnqQV/owDSSgpA6EKn1Ug2YE3/PBb1AigGSXNTFP009n84RlI2z4aYRl1cb4qiPL0k0wN5jwDWl9nVjytqDCkC8DulMJF1Umk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=decadent.org.uk; spf=pass smtp.mailfrom=decadent.org.uk; arc=none smtp.client-ip=65.21.191.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=decadent.org.uk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=decadent.org.uk
Received: from [2a02:578:851f:1502:391e:c5f5:10e2:b9a3] (helo=deadeye)
	by maynard with esmtps  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.96)
	(envelope-from <ben@decadent.org.uk>)
	id 1wCOYc-004n48-0Y;
	Mon, 13 Apr 2026 21:10:57 +0000
Received: from ben by deadeye with local (Exim 4.99.1)
	(envelope-from <ben@decadent.org.uk>)
	id 1wCOYa-00000002kvq-0vui;
	Mon, 13 Apr 2026 23:10:56 +0200
Message-ID: <65cd5a0b7c68af467b8b13b4fbce51cc2febb5ad.camel@decadent.org.uk>
Subject: Re: [PATCH 5.10 474/491] mmc: core: Drop superfluous validations in
 mmc_hw|sw_reset()
From: Ben Hutchings <ben@decadent.org.uk>
To: Ulf Hansson <ulf.hansson@linaro.org>
Cc: patches@lists.linux.dev, Adrian Hunter <adrian.hunter@intel.com>, Sasha
 Levin <sashal@kernel.org>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
 stable	 <stable@vger.kernel.org>
Date: Mon, 13 Apr 2026 23:10:43 +0200
In-Reply-To: <20260413155836.794775290@linuxfoundation.org>
References: <20260413155819.042779211@linuxfoundation.org>
	 <20260413155836.794775290@linuxfoundation.org>
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-KvvnMgBNjCfGogkaoR+j"
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


--=-KvvnMgBNjCfGogkaoR+j
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, 2026-04-13 at 18:01 +0200, Greg Kroah-Hartman wrote:
> 5.10-stable review patch.  If anyone has any objections, please let me kn=
ow.
>=20
> ------------------
>=20
> From: Ulf Hansson <ulf.hansson@linaro.org>
>=20
> [ Upstream commit fefdd3c91e0a7b3cbb3f25925d93a57c45cb0f31 ]
>=20
> The mmc_hw|sw_reset() APIs are designed to be called solely from upper
> layers, which means drivers that operates on top of the struct mmc_card,
> like the mmc block device driver and an SDIO functional driver.
>=20
> Additionally, as long as the struct mmc_host has a valid pointer to a
> struct mmc_card, the corresponding host->bus_ops pointer stays valid and
> assigned.
>=20
> For these reasons, let's drop the superfluous reference counting and the
> redundant validations in mmc_hw|sw_reset().

Is this reasoning still correct for older branches such as 5.10?

And if so, do they also need commit 406e14808ee6 ("mmc: block: Remove
error check of hw_reset on reset"), which claims to fix this one?  I
don't really follow the explanation in its commit message.

Ben.

>=20
> Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
> Reviewed-by: Adrian Hunter <adrian.hunter@intel.com>
> Link: https://lore.kernel.org/r/20210212131532.236775-1-ulf.hansson@linar=
o.org
> Stable-dep-of: 901084c51a0a ("mmc: core: Avoid bitfield RMW for claim/ret=
une flags")
> Signed-off-by: Sasha Levin <sashal@kernel.org>
> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> ---
>  drivers/mmc/core/block.c |    2 +-
>  drivers/mmc/core/core.c  |   21 +--------------------
>  2 files changed, 2 insertions(+), 21 deletions(-)
>=20
> --- a/drivers/mmc/core/block.c
> +++ b/drivers/mmc/core/block.c
> @@ -987,7 +987,7 @@ static int mmc_blk_reset(struct mmc_blk_
>  	md->reset_done |=3D type;
>  	err =3D mmc_hw_reset(host);
>  	/* Ensure we switch back to the correct partition */
> -	if (err !=3D -EOPNOTSUPP) {
> +	if (err) {
>  		struct mmc_blk_data *main_md =3D
>  			dev_get_drvdata(&host->card->dev);
>  		int part_err;
> --- a/drivers/mmc/core/core.c
> +++ b/drivers/mmc/core/core.c
> @@ -2096,18 +2096,7 @@ int mmc_hw_reset(struct mmc_host *host)
>  {
>  	int ret;
> =20
> -	if (!host->card)
> -		return -EINVAL;
> -
> -	mmc_bus_get(host);
> -	if (!host->bus_ops || host->bus_dead || !host->bus_ops->hw_reset) {
> -		mmc_bus_put(host);
> -		return -EOPNOTSUPP;
> -	}
> -
>  	ret =3D host->bus_ops->hw_reset(host);
> -	mmc_bus_put(host);
> -
>  	if (ret < 0)
>  		pr_warn("%s: tried to HW reset card, got error %d\n",
>  			mmc_hostname(host), ret);
> @@ -2120,18 +2109,10 @@ int mmc_sw_reset(struct mmc_host *host)
>  {
>  	int ret;
> =20
> -	if (!host->card)
> -		return -EINVAL;
> -
> -	mmc_bus_get(host);
> -	if (!host->bus_ops || host->bus_dead || !host->bus_ops->sw_reset) {
> -		mmc_bus_put(host);
> +	if (!host->bus_ops->sw_reset)
>  		return -EOPNOTSUPP;
> -	}
> =20
>  	ret =3D host->bus_ops->sw_reset(host);
> -	mmc_bus_put(host);
> -
>  	if (ret)
>  		pr_warn("%s: tried to SW reset card, got error %d\n",
>  			mmc_hostname(host), ret);
>=20
>=20

--=20
Ben Hutchings
When in doubt, use brute force. - Ken Thompson

--=-KvvnMgBNjCfGogkaoR+j
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEErCspvTSmr92z9o8157/I7JWGEQkFAmndW9MACgkQ57/I7JWG
EQmvOhAAyECeUjLUec+pN3SNMW+GXNfzJjm/+OHbibNapH1vKCwkQaRCXFPMmIEH
HPlDJFTr4H6OlgQZuCdj5p2s8mlyRT0jmmdLukmQuO6hIZoUxo/8Lfd7w0Z5lRI/
aRv0zPpjMc5ekuDfNZNqrD+8KRyzjWIPawEOGohksfqK7oU19XdEkFKU3xgcqwqR
/JL3F5aNGje+aYtgC64nH0RFoGZ1ZYOgAjN1uCgw3aaAMJR4MMbBmN73QqcN07oh
8TlH9uTQKw/ZDhml4eOfDkIayL6u97s38JKyAOaiMJw1jpjlo5homVI53Krq4b10
i6BS+cvl/35dNg+F5U4tOBST/jW24ZmT15Q1LRVs/yW5cNy4Nz3iGary30S/sV8c
C1EAfinV+dIrE3bKgXDDFmrAqVVB8ypNxMhkb2NNYJQiYQPymnFkaPAyAAV7XEsJ
huKzVIsVBhsPdiTbLL2E9SEM9YcOdxubnIzKNXRQON/IABLKYDOSxo7UnaJMhGkv
Mz7Grlrob3nso1rCHSldd2oNi13qgFWtVN5s0YBthhOwmwExSdAiDHLx/bVYr5w/
KCZ8SLkJxaprvrmdQ828tJNKEV+zvGjg5YultBMxsMxvi1xBAwn89lkE9n2M2Go1
mmhpDQFZ/tm3eRRGEAQRaJjZye4IfWCbIO4b50hwt9gIYO+8xXA=
=SE/g
-----END PGP SIGNATURE-----

--=-KvvnMgBNjCfGogkaoR+j--
