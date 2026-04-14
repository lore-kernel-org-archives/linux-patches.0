Received: from maynard.decadent.org.uk (maynard.decadent.org.uk [65.21.191.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 30056372B50;
	Tue, 14 Apr 2026 20:48:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=65.21.191.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776199740; cv=none; b=rDTvMlPWG0Lx0nhCzWyD91hl5NB9V42topHOwfEQnvPCMQFaJH0fr0QH+W+ko47yZxDUzTGm8KST54BUpt/DLlwfjdZnbWTC1YaMk9LwuLwzAHDwQCXWwBAT4nHYn9n1S8s8hv3hMCj8pb6xRpPxZeyL85Gj5dX+VKq8Y2Y/S/4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776199740; c=relaxed/simple;
	bh=FZhVmZDmoc+e4tnw/rUsAPvhn+Fv1Ql1ghdXUhYNQMs=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=Zf0/sPKNuYzYe7ztELYT2A/d8e/xGDN4KMFdWTZbvvEJW9g7IrPsiE4sRdJNmD401V3JFNLMa+8o63R3m960ZDnxHXgPUgNX1gJA6afa9wqttX5QILB8y6f2z/9YfFHM6ScFqh1FOzD3rdc7Gezg41VFDB586FuPQMDalbdYK/Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=decadent.org.uk; spf=pass smtp.mailfrom=decadent.org.uk; arc=none smtp.client-ip=65.21.191.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=decadent.org.uk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=decadent.org.uk
Received: from [2a02:578:851f:1502:391e:c5f5:10e2:b9a3] (helo=deadeye)
	by maynard with esmtps  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.96)
	(envelope-from <ben@decadent.org.uk>)
	id 1wCkgc-004tdR-0j;
	Tue, 14 Apr 2026 20:48:41 +0000
Received: from ben by deadeye with local (Exim 4.99.1)
	(envelope-from <ben@decadent.org.uk>)
	id 1wCkgZ-00000003JXJ-22TJ;
	Tue, 14 Apr 2026 22:48:39 +0200
Message-ID: <408661f69f263266b028713e1412ba36d457e63d.camel@decadent.org.uk>
Subject: Re: [PATCH 5.10 040/491] wifi: cw1200: Fix locking in error paths
From: Ben Hutchings <ben@decadent.org.uk>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Bart Van Assche
	 <bvanassche@acm.org>, Johannes Berg <johannes.berg@intel.com>
Cc: patches@lists.linux.dev, Sasha Levin <sashal@kernel.org>, stable
	 <stable@vger.kernel.org>
Date: Tue, 14 Apr 2026 22:48:34 +0200
In-Reply-To: <20260413155820.553917826@linuxfoundation.org>
References: <20260413155819.042779211@linuxfoundation.org>
	 <20260413155820.553917826@linuxfoundation.org>
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-3XcIgO2PhS3b5fJ4IWpi"
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


--=-3XcIgO2PhS3b5fJ4IWpi
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, 2026-04-13 at 17:54 +0200, Greg Kroah-Hartman wrote:
> 5.10-stable review patch.  If anyone has any objections, please let me kn=
ow.
>=20
> ------------------
>=20
> From: Bart Van Assche <bvanassche@acm.org>
>=20
> [ Upstream commit d98c24617a831e92e7224a07dcaed2dd0b02af96 ]
>=20
> cw1200_wow_suspend() must only return with priv->conf_mutex locked if it
> returns zero. This mutex must be unlocked if an error is returned. Add
> mutex_unlock() calls to the error paths from which that call is missing.

These error paths already call cw1200_wow_resume() which unlocks
conf_mutex.  So this is introducing and not fixing a locking bug.=20
Please drop this from all stable queues and revert it upstream.

> This has been detected by the Clang thread-safety analyzer.

A bug report against that analyser may also be in order!

Ben.

>=20
> Fixes: a910e4a94f69 ("cw1200: add driver for the ST-E CW1100 & CW1200 WLA=
N chipsets")
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>
> Link: https://patch.msgid.link/20260223220102.2158611-25-bart.vanassche@l=
inux.dev
> Signed-off-by: Johannes Berg <johannes.berg@intel.com>
> Signed-off-by: Sasha Levin <sashal@kernel.org>
> ---
>  drivers/net/wireless/st/cw1200/pm.c | 2 ++
>  1 file changed, 2 insertions(+)
>=20
> diff --git a/drivers/net/wireless/st/cw1200/pm.c b/drivers/net/wireless/s=
t/cw1200/pm.c
> index a20ab577a3644..212b6f2af8de4 100644
> --- a/drivers/net/wireless/st/cw1200/pm.c
> +++ b/drivers/net/wireless/st/cw1200/pm.c
> @@ -264,12 +264,14 @@ int cw1200_wow_suspend(struct ieee80211_hw *hw, str=
uct cfg80211_wowlan *wowlan)
>  		wiphy_err(priv->hw->wiphy,
>  			  "PM request failed: %d. WoW is disabled.\n", ret);
>  		cw1200_wow_resume(hw);
> +		mutex_unlock(&priv->conf_mutex);
>  		return -EBUSY;
>  	}
> =20
>  	/* Force resume if event is coming from the device. */
>  	if (atomic_read(&priv->bh_rx)) {
>  		cw1200_wow_resume(hw);
> +		mutex_unlock(&priv->conf_mutex);
>  		return -EAGAIN;
>  	}
> =20

--=20
Ben Hutchings
73.46% of all statistics are made up.

--=-3XcIgO2PhS3b5fJ4IWpi
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEErCspvTSmr92z9o8157/I7JWGEQkFAmneqCMACgkQ57/I7JWG
EQlvLw/+JL+dXnWLRtJ34u60t+0cVAdpyArua8EZRhk0AsLOLB6r6Ea6uReGeXCp
Q17Ah6wrQ3MjLcUwABJ9STD2H6VuLIoeuEdLlE16pqo+r08py9gxjB5pdayGOVaR
jam8Kyp2lhkn1Z2jyAPC3lytF2hXxrzfuZ1WL6EkE7sTq+3x2XDZjpflCt65OWi5
kk57PzchgBRm9j9F2vbN4fdQckczCHymm0DaxDN2A6wZxdZJ8NJ7ap/lhXpaXpN7
Gv38pPVzRrcZvYXxTyx6I/P8OSTDvmE3gwnt37+8H5a0wKsCcU2ZHapWupMxE4t4
vnHiyeN9m7g3szc3d6uQKzqGkvGGFEHDsdeEdgWRmQYiPddzzG3iuGGhhljooJB8
nEvYHLCgD2dv+GKVS+8fwoWW+b7yV2EMR/G1h2AtlHoCiY64cg+kg7r6nEqohUo2
ICKKVWXyc+DzrhKeKjc6w8pWJV/aZI2BW9y5A87jrIHpkkOqnRO4GBnUXomaPdUp
sik0W4i5sXASs36TJ7xqBB6uL14enm6Z/S2HR/8P9ac9nEMMwMJbfIfp+0qlsxHN
6/qfswnYgKJAjQOvZ+IZIpqkUtvWVGIg8OM+EUDtVIElcfcAzR5xUIC4QumYgnPd
Kr6wy/0Q+7/Z6GS8lESAr27W9wf5YFM0/y+sM/0gFkCaAxHrU8A=
=W5Jd
-----END PGP SIGNATURE-----

--=-3XcIgO2PhS3b5fJ4IWpi--
