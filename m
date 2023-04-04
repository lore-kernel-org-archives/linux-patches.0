Received: from jabberwock.ucw.cz (jabberwock.ucw.cz [46.255.230.98])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2336A7C
	for <patches@lists.linux.dev>; Tue,  4 Apr 2023 11:31:54 +0000 (UTC)
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
	id 450311C0DFD; Tue,  4 Apr 2023 13:22:02 +0200 (CEST)
Date: Tue, 4 Apr 2023 13:22:01 +0200
From: Pavel Machek <pavel@denx.de>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	Corey Minyard <cminyard@mvista.com>,
	Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 5.10 006/173] ipmi:ssif: resend_msg() cannot fail
Message-ID: <ZCwIWfSovPxvPzU2@duo.ucw.cz>
References: <20230403140414.174516815@linuxfoundation.org>
 <20230403140414.435644519@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="kaXC/y2ScS6jCe+I"
Content-Disposition: inline
In-Reply-To: <20230403140414.435644519@linuxfoundation.org>


--kaXC/y2ScS6jCe+I
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> The resend_msg() function cannot fail, but there was error handling
> around using it.  Rework the handling of the error, and fix the out of
> retries debug reporting that was wrong around this, too.

> @@ -909,31 +909,17 @@ static void msg_written_handler(struct ssif_info *s=
sif_info, int result,
>  	if (result < 0) {
>  		ssif_info->retries_left--;
>  		if (ssif_info->retries_left > 0) {
> -			if (!start_resend(ssif_info)) {
> -				ssif_inc_stat(ssif_info, send_retries);
> -				return;
> -			}
> -			/* request failed, just return the error. */
> -			ssif_inc_stat(ssif_info, send_errors);
> -
> -			if (ssif_info->ssif_debug & SSIF_DEBUG_MSG)
> -				dev_dbg(&ssif_info->client->dev,
> -					"%s: Out of retries\n", __func__);
> -			msg_done_handler(ssif_info, -EIO, NULL, 0);
> +			start_resend(ssif_info);
>  			return;
>  		}

ssif_inc_stat(ssif_info, send_errors); disappeared here, is that
intentional?

Best regards,
								Pavel
--=20
DENX Software Engineering GmbH,        Managing Director: Erika Unter
HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany

--kaXC/y2ScS6jCe+I
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCZCwIWQAKCRAw5/Bqldv6
8k2lAKCAMfVys8P3G+wY0FR3nIJt5iaDkwCgu8ib2MYDHIpRvpm1docPUDK3BpQ=
=nS+o
-----END PGP SIGNATURE-----

--kaXC/y2ScS6jCe+I--
