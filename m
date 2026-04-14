Received: from maynard.decadent.org.uk (maynard.decadent.org.uk [65.21.191.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 06CC72C029D;
	Tue, 14 Apr 2026 22:16:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=65.21.191.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776204968; cv=none; b=dzk+1tr949oeEpQ9nrtOgT3PRxlx4wfF8Q3NV4q3te4k31jBWMpz1EoXRGsizqkN3lFb1w3aWM1zW3ofVZi62mhC0MJQZVM9TAse5Qx7yoq1MtgXx3h5R3ESPQh85bODpkHA9KxVlaT7Wd+c1LsSpMqsR/ZLA1H07nqJCC/AEYo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776204968; c=relaxed/simple;
	bh=PIlVJrVQBrXAJUHj56IknhEBILzhIAtIv3IBWZh6TGw=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=DChmHCvf+dOz/uXkmnxe3JRkL42K+VNApg0DC+RDn5tT+EayxmQPNTl9AwSJMyFrB18DpqJDBQH0W6jozXhgVMtLn6fo1VXf2TpAe0IjOw5mzt8lfVPQCYKh9E0leGo0GaprmRBy0ftlAMAjb7UM7wKt2vFe80B+dywo+GYWJk8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=decadent.org.uk; spf=pass smtp.mailfrom=decadent.org.uk; arc=none smtp.client-ip=65.21.191.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=decadent.org.uk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=decadent.org.uk
Received: from [2a02:578:851f:1502:391e:c5f5:10e2:b9a3] (helo=deadeye)
	by maynard with esmtps  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.96)
	(envelope-from <ben@decadent.org.uk>)
	id 1wCm39-004tw4-2L;
	Tue, 14 Apr 2026 22:16:02 +0000
Received: from ben by deadeye with local (Exim 4.99.1)
	(envelope-from <ben@decadent.org.uk>)
	id 1wCm37-00000003PFq-020L;
	Wed, 15 Apr 2026 00:16:01 +0200
Message-ID: <5006a2a4e34e7fbbb89fc8969facc6b80c7d00de.camel@decadent.org.uk>
Subject: Re: [PATCH 5.10 070/491] ASoC: core: Exit all links before removing
 their components
From: Ben Hutchings <ben@decadent.org.uk>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, Cezary Rojewski <cezary.rojewski@intel.com>, 
 Amadeusz =?UTF-8?Q?S=C5=82awi=C5=84ski?=
	 <amadeuszx.slawinski@linux.intel.com>, Mark Brown <broonie@kernel.org>, 
 Sasha Levin <sashal@kernel.org>
Date: Wed, 15 Apr 2026 00:15:56 +0200
In-Reply-To: <20260413155821.667271642@linuxfoundation.org>
References: <20260413155819.042779211@linuxfoundation.org>
	 <20260413155821.667271642@linuxfoundation.org>
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-KgAk7R9Y/lOTXM51ustF"
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


--=-KgAk7R9Y/lOTXM51ustF
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, 2026-04-13 at 17:55 +0200, Greg Kroah-Hartman wrote:
> 5.10-stable review patch.  If anyone has any objections, please let me kn=
ow.
>=20
> ------------------
>=20
> From: Cezary Rojewski <cezary.rojewski@intel.com>
>=20
> [ Upstream commit c7eb967d70446971413061effca3226578cb4dab ]

I don't think this change is safe for 5.10.

[...]
> diff --git a/sound/soc/soc-core.c b/sound/soc/soc-core.c
> index 4294206dff362..562fbc0fb3475 100644
> --- a/sound/soc/soc-core.c
> +++ b/sound/soc/soc-core.c
> @@ -962,9 +962,6 @@ void snd_soc_remove_pcm_runtime(struct snd_soc_card *=
card,
> =20
>  	lockdep_assert_held(&client_mutex);
> =20
> -	/* release machine specific resources */
> -	snd_soc_link_exit(rtd);
> -
>  	/*
>  	 * Notify the machine driver for extra destruction
>  	 */

snd_soc_remove_pcm_runtime() is called from remove_link() in
soc-topology.c.  I might be misunderstanding it, but it seems to free
the structure that snd_soc_link_exit() accesses immediately after
snd_soc_remove_pcm_runtime() returns.

> @@ -1928,6 +1925,9 @@ static void soc_cleanup_card_resources(struct snd_s=
oc_card *card)
> =20
>  	snd_soc_dapm_shutdown(card);
> =20
> +	/* release machine specific resources */
> +	for_each_card_rtds(card, rtd)
> +		snd_soc_link_exit(rtd);
>  	/* remove and free each DAI */
>  	soc_remove_link_dais(card);
>  	soc_remove_link_components(card);

So it wouldn't be safe to defer snd_soc_link_exit() to here.

After ff9226224437 ("ASoC: topology: Change allocations to resource
managed") upstream that memory is device-managed, making the lifetime of
the link structure long enough for this to be OK.  So none of the newer
branches would have this problem.

Ben.

--=20
Ben Hutchings
The obvious mathematical breakthrough [to break modern encryption]
would be development of an easy way to factor large prime numbers.
                                                           - Bill Gates

--=-KgAk7R9Y/lOTXM51ustF
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEErCspvTSmr92z9o8157/I7JWGEQkFAmnevJwACgkQ57/I7JWG
EQmaHw//dMRNffj7LgJlotzR+fyyz6aZs5Dtwm6s6Q+PCM9VGjRqiYH/l9cnKb0J
9WoUFBEGGI3LkrYbQ4U9oecuYd3KyXpAFeSOKIGIq4AUEJQU8GIKc8Z3gNv2gM9d
769/bjhz7St/0k+3Eh3P/5jWiBXrd8FFaFyVwJRpyAFWjOXcFOV5Lfn4S2WUSOkA
+IsCJ661Ac/Ik5VaxkyOe6BcJqRQj6BBGHOOj7RUE8w6IGZ6eJqLzLsKNyIiXYF5
2y8CaoTGXw5I5ffIpwhXQNLr0NS6mLAR+iDFVPVe4kgTayVeqa8UftKm5S1tiIqS
qb48xq38I3juzlE+Z+OtPlaWURw8Q5HWlX38cvSLLVi6lNbrWzqmrT4WHMuLa0B4
yM7clVIDBVIrAzXuLlxSkz53LpFfZ9+TCC149tfQ55M1wFEqE/5B4kdh95xgfoXU
ivG8W5L838Tdliw1NR96ca1nt3wXklt24ecDXtq6iBh04hHLPX2BoNrrAfLRm5mQ
b8WoyyNPUREoP8TI9yYyk4Is2zA6tuMtDO04j592i4RBDvz5X2R04CFDsTe7ICPx
335EdjlTuv09N5UO50r1icjUwmsnzOnE+KhGUMGhlF6O7CswgfA05Z9Ul0GrmhgX
RFOW7TNdW2dKf55KWPxqlJrrRP53LzWdkvrp9fxh8+nP2GfyEtw=
=dgKB
-----END PGP SIGNATURE-----

--=-KgAk7R9Y/lOTXM51ustF--
