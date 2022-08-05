Received: from hop.stappers.nl (hop.stappers.nl [141.105.120.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D30491C13
	for <patches@lists.linux.dev>; Fri,  5 Aug 2022 16:55:56 +0000 (UTC)
Received: from gpm.stappers.nl (gpm.stappers.nl [82.168.249.201])
	by hop.stappers.nl (Postfix) with ESMTP id EFFC4200F4;
	Fri,  5 Aug 2022 16:48:35 +0000 (UTC)
Received: by gpm.stappers.nl (Postfix, from userid 1000)
	id 96E2F304049; Fri,  5 Aug 2022 18:48:35 +0200 (CEST)
Date: Fri, 5 Aug 2022 18:48:35 +0200
From: Geert Stappers <stappers@stappers.nl>
To: Miguel Ojeda <ojeda@kernel.org>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	rust-for-linux@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, patches@lists.linux.dev,
	Jarkko Sakkinen <jarkko@kernel.org>,
	Boqun Feng <boqun.feng@gmail.com>
Subject: Re: [PATCH v9 01/27] kallsyms: use `sizeof` instead of hardcoded size
Message-ID: <20220805164834.4xq7hm6ee6ywjpjo@gpm.stappers.nl>
References: <20220805154231.31257-1-ojeda@kernel.org>
 <20220805154231.31257-2-ojeda@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="ojgl5e33l337cax4"
Content-Disposition: inline
In-Reply-To: <20220805154231.31257-2-ojeda@kernel.org>
User-Agent: NeoMutt/20170113 (1.7.2)


--ojgl5e33l337cax4
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Aug 05, 2022 at 05:41:46PM +0200, Miguel Ojeda wrote:
> From: Boqun Feng <boqun.feng@gmail.com>
>=20
> This removes one place where the `500` constant is hardcoded.
>=20
> Signed-off-by: Boqun Feng <boqun.feng@gmail.com>
> Co-developed-by: Miguel Ojeda <ojeda@kernel.org>
> Signed-off-by: Miguel Ojeda <ojeda@kernel.org>
> ---
>  scripts/kallsyms.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>=20
> diff --git a/scripts/kallsyms.c b/scripts/kallsyms.c
> index f18e6dfc68c5..52f5488c61bc 100644
> --- a/scripts/kallsyms.c
> +++ b/scripts/kallsyms.c
> @@ -206,7 +206,7 @@ static struct sym_entry *read_symbol(FILE *in)
> =20
>  	rc =3D fscanf(in, "%llx %c %499s\n", &addr, &type, name);
>  	if (rc !=3D 3) {
> -		if (rc !=3D EOF && fgets(name, 500, in) =3D=3D NULL)
> +		if (rc !=3D EOF && fgets(name, sizeof(name), in) =3D=3D NULL)
>  			fprintf(stderr, "Read error or end of file.\n");
>  		return NULL;
>  	}
> --=20
> 2.37.1
>=20


Signed-off-by: Geert Stappers <stappers@stappers.nl>


And I think that this patch and all other "rust" kallsyms patches
allready should have been accepted in the v3 or v5 series.





Regards
Geert Stappers
--=20
Silence is hard to parse

--ojgl5e33l337cax4
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEEin8gjG2ecykWV0FNITXRI9jBm+wFAmLtSdsACgkQITXRI9jB
m+yFvRAAqobvCSSsxB7Z87XEpwzMkNsdtwn04eRPEsQctCU3u1bfvVVHqq9G8rvH
RwUeyPpAOxbmEs+B5UCE3CbU5p/tSuw4au2+Gn3S23aAJLSNQd/ddtai3ca02y5a
Sw6ype8LlZsFnhmocfB+RsHsch7PQyS0CMkcfsFaYx7Lj44YsaHMLtuHOYt2jmCI
/B2kKn7dze85uCPF/tronsLR9aD1kpSEQ4x/ZUyZ88OtE3pQKQvPu1IWHLsGPBNC
bjg6NzkgyO4qFb3bgmv21q+VOSK3jMwr3kY1t9FoxMsHtoPi4c5+87aj4iLze0zK
enrSYseH670xScX19DqZvrY+C9uh5iVBsv2+Pz/0WaR3HT4sUxg3xkl1wdMlA1Ui
xLoBK3ayljhdaxhkLx6Eif5YxyB4BBCXq3cjugkMECT0L86DSj91dPB9mWGAItFN
dydrsOmAnh4Jl/LahJYoSmnkmCBtxAL4p2WkLmpEvHHcAfw/Hx8Bwu0LKXigMdDh
I4/BtNKknlceQ9hzY0VkeVbj3WUnZ2bkMPd1Q87YpQPVZlj6ArS+QXEB1Uq1GeHE
29gmr3CZOlOMiXEXnLM17uS8w9smjIkx4WpuE5CK3F4aVjYBdRWZF8NDsmYWglMT
K3RJ/FYKfaXfeXBwLLcN/vkgqOulY1Dg3buhg6mX5kYcjNCHlt4=
=6Oog
-----END PGP SIGNATURE-----

--ojgl5e33l337cax4--
