Received: from mx.denx.de (mx.denx.de [89.58.32.78])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 152B678F59
	for <patches@lists.linux.dev>; Fri, 30 May 2025 09:55:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=89.58.32.78
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748598927; cv=none; b=Y/E20Lrry0H7NTx733WIU5xhEWbFhmgEulH8WrcLQvM/78XZh2hBXabdghLcvqQ/cavhOjmmdT+PWLXsAUUrV8jI6jcsncHxCQv122A79sjMYFp4DjaWyIOKcC1Hd3s/WDpae35QLD24Xxy/3ZA876EzeoQ552tzfr3JwO5vG4A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748598927; c=relaxed/simple;
	bh=4Mng0ywUmUrfZeAKSmxJ7JTlibNDrNKxo79JSFFkags=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=oSIcJpbYpXB68/k7wldt6MFb2arnKGVBUuMEBsQnwf6aygQVkddqXOhyezJ/9zrnGMXEv3unvaE/p5Flhdvf8MX7tmf0n9BC80NMMWhfpyv3Rsf4i4HbLofc0a98PH6aE0VBtKNYwdDGtPnu+I3eFX5ovLxraCqN9W0wxx4jwV0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=denx.de; spf=pass smtp.mailfrom=denx.de; dkim=pass (2048-bit key) header.d=denx.de header.i=@denx.de header.b=VHzx3xXr; arc=none smtp.client-ip=89.58.32.78
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=denx.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=denx.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=denx.de header.i=@denx.de header.b="VHzx3xXr"
Received: from [127.0.0.1] (localhost [127.0.0.1]) by localhost (Mailerdaemon) with ESMTPSA id 1ED6B103972A6;
	Fri, 30 May 2025 11:55:21 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=denx.de; s=mx-20241105;
	t=1748598923; h=from:subject:date:message-id:to:cc:mime-version:content-type:
	 in-reply-to:references; bh=4XaaXyzfTKo6sYckoNRHdpqnhB4w2WbrFF82VsAWBeo=;
	b=VHzx3xXrOv8XTe5lHL468V6B5zOS5yyXOidHPDhj0zUopU2ZMOlab3ZBvNOwwc23jpGlIn
	+HzlAm79rf4D7YWqUrRw0B4ozYk54VDnpjj6BHKg/A1N6u/vH8WzVMKMCeX4qNm7dFkyR8
	Q9a7RAHiwDKINfXSdVdVuidbzzzgo/VErajksdHF51A5Qg/hM0fa+VY9g3qKNgyeJP4dZo
	2mH0qzdfQ8TJkjpRzNuxpockotdP6StaOBqFreu0poltgd/QkP7rRlr75TIqnbB2nZhBQe
	ebCOlSojeIy+5ihwH4xzs0ZERNtRpoJVCDMImGxJhfxoGw13r6kHr4PN/grSSQ==
Date: Fri, 30 May 2025 11:55:19 +0200
From: Pavel Machek <pavel@denx.de>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	Kuniyuki Iwashima <kuniyu@amazon.com>,
	Eric Dumazet <edumazet@google.com>,
	Ido Schimmel <idosch@nvidia.com>, Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 6.12 423/626] ip: fib_rules: Fetch net from fib_rule in
 fib[46]_rule_configure().
Message-ID: <aDmAh5WL5PmpleD6@duo.ucw.cz>
References: <20250527162445.028718347@linuxfoundation.org>
 <20250527162502.196494967@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="igsI8r5nMsd01AYU"
Content-Disposition: inline
In-Reply-To: <20250527162502.196494967@linuxfoundation.org>
X-Last-TLS-Session-Version: TLSv1.3


--igsI8r5nMsd01AYU
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> 6.12-stable review patch.  If anyone has any objections, please let
  me know.

Preparation for future development, does not fix a bug. Sasha
should not be picking these up.

BR,
                                                                        Pav=
el

> From: Kuniyuki Iwashima <kuniyu@amazon.com>
>=20
> [ Upstream commit 5a1ccffd30a08f5a2428cd5fbb3ab03e8eb6c66d ]
>=20
> The following patch will not set skb->sk from VRF path.
>=20
> Let's fetch net from fib_rule->fr_net instead of sock_net(skb->sk)
> in fib[46]_rule_configure().
>=20
> Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.com>
> Reviewed-by: Eric Dumazet <edumazet@google.com>
> Reviewed-by: Ido Schimmel <idosch@nvidia.com>
> Tested-by: Ido Schimmel <idosch@nvidia.com>
> Link: https://patch.msgid.link/20250207072502.87775-5-kuniyu@amazon.com
> Signed-off-by: Jakub Kicinski <kuba@kernel.org>
> Signed-off-by: Sasha Levin <sashal@kernel.org>
> ---
>  net/ipv4/fib_rules.c  | 4 ++--
>  net/ipv6/fib6_rules.c | 4 ++--
>  2 files changed, 4 insertions(+), 4 deletions(-)
>=20
> diff --git a/net/ipv4/fib_rules.c b/net/ipv4/fib_rules.c
> index b07292d50ee76..4563e5303c1a8 100644
> --- a/net/ipv4/fib_rules.c
> +++ b/net/ipv4/fib_rules.c
> @@ -245,9 +245,9 @@ static int fib4_rule_configure(struct fib_rule *rule,=
 struct sk_buff *skb,
>  			       struct nlattr **tb,
>  			       struct netlink_ext_ack *extack)
>  {
> -	struct net *net =3D sock_net(skb->sk);
> +	struct fib4_rule *rule4 =3D (struct fib4_rule *)rule;
> +	struct net *net =3D rule->fr_net;
>  	int err =3D -EINVAL;
> -	struct fib4_rule *rule4 =3D (struct fib4_rule *) rule;
> =20
>  	if (!inet_validate_dscp(frh->tos)) {
>  		NL_SET_ERR_MSG(extack,
> diff --git a/net/ipv6/fib6_rules.c b/net/ipv6/fib6_rules.c
> index 04a9ed5e8310f..29185c9ebd020 100644
> --- a/net/ipv6/fib6_rules.c
> +++ b/net/ipv6/fib6_rules.c
> @@ -365,9 +365,9 @@ static int fib6_rule_configure(struct fib_rule *rule,=
 struct sk_buff *skb,
>  			       struct nlattr **tb,
>  			       struct netlink_ext_ack *extack)
>  {
> +	struct fib6_rule *rule6 =3D (struct fib6_rule *)rule;
> +	struct net *net =3D rule->fr_net;
>  	int err =3D -EINVAL;
> -	struct net *net =3D sock_net(skb->sk);
> -	struct fib6_rule *rule6 =3D (struct fib6_rule *) rule;
> =20
>  	if (!inet_validate_dscp(frh->tos)) {
>  		NL_SET_ERR_MSG(extack,

--=20
DENX Software Engineering GmbH,        Managing Director: Erika Unter
HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany

--igsI8r5nMsd01AYU
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCaDmAhwAKCRAw5/Bqldv6
8ovKAKCM7cAmVIa5PlxseneLACtoBm18/ACgqoBvHkrtFAsDVu8hCC4EOL6+Oc4=
=iUK8
-----END PGP SIGNATURE-----

--igsI8r5nMsd01AYU--
