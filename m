Received: from mail-ej1-f43.google.com (mail-ej1-f43.google.com [209.85.218.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D18C134CEF;
	Thu, 12 Oct 2023 18:05:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="HzihVdgJ"
Received: by mail-ej1-f43.google.com with SMTP id a640c23a62f3a-9ad810be221so201467066b.2;
        Thu, 12 Oct 2023 11:05:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1697133903; x=1697738703; darn=lists.linux.dev;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=QfIb1D07nfI+0Ch1761SwKK3aO/nbsGIC751epSoaTc=;
        b=HzihVdgJB45uTN/DzqTO3u47b1yOinDLNy/urotyv8n7B2eUnNaN9kmYGQCT2qDb5k
         ouL9vGxAo5Lk3NnccvVi/tdIbKZms41eakhNTAdvxQugkFvelyUG75lQoFu91pZx3dCs
         0eTh2h430tndB67TQvQPoOPLMdm7RgdbPRw+gsD55mo8DanLNijxKbtERSYp/vlLMR27
         2inZReTTfcAjBV3wuueHbJeTqOz/f3ri2ixUD170a8pGs/01JbZd9Nu5WbPsRR90xQcc
         9r571XQ9ulvbPuxrlTWIMQZu+X8/egZTQiQ9yvfwAyWfzGPiD1Pbcay4UUIYSTTdsYvv
         h2jg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1697133903; x=1697738703;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=QfIb1D07nfI+0Ch1761SwKK3aO/nbsGIC751epSoaTc=;
        b=gWLYnSYlTvKhrF4zrfwiHbIZXXfszOvWCLutpYXgChBPcAWZ6sdYdCHS6hx0dirkEz
         bn4OQwkcJg4hVHbb6vXsintxWiJoExer76Hu0tU4l5b8H/L78eXvNpJttVGC+JHRAKuq
         A8cNZQer9Kyqnlaab3MytvpBiXMQJnBrbRbWnSQ4SK6NCY5ZmB0+x3WdjzN0O+xeIMO5
         qcX0V6c8hmmDGUtveiIP+yiftejikHKOBtKftq+e2RgPpxbdJSr2f+zsG29UxzWFcNgU
         j2hJq28kq6i+9VRCjOkhvlxzZDCDdXOgK1Bbl7V5fxaU2q1Lyvu76L6CWEULtFwDj3UC
         +ToA==
X-Gm-Message-State: AOJu0YxQXMiPovFOaKUs+VHLSkGeNuqjGdCtEucGFd2NSQLfKIq1/rq1
	DzvkmTdKHYy3xYDPYWgSAbg=
X-Google-Smtp-Source: AGHT+IFdStcd3c2GGinYpRXye7AwYjUTLBoOWruKg6//W80bNpLA3+vpu34T9qw3GrF5BXwkZ696Ig==
X-Received: by 2002:a17:906:310b:b0:9ae:5765:c134 with SMTP id 11-20020a170906310b00b009ae5765c134mr22622471ejx.15.1697133902720;
        Thu, 12 Oct 2023 11:05:02 -0700 (PDT)
Received: from orome.fritz.box (p200300e41f3f4900f22f74fffe1f3a53.dip0.t-ipconnect.de. [2003:e4:1f3f:4900:f22f:74ff:fe1f:3a53])
        by smtp.gmail.com with ESMTPSA id a24-20020a170906685800b009828e26e519sm11289137ejs.122.2023.10.12.11.05.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 Oct 2023 11:05:02 -0700 (PDT)
Date: Thu, 12 Oct 2023 20:05:00 +0200
From: Thierry Reding <thierry.reding@gmail.com>
To: Nathan Chancellor <nathan@kernel.org>
Cc: broonie@kernel.org, robh@kernel.org, lgirdwood@gmail.com,
	jonathanh@nvidia.com, ndesaulniers@google.com, trix@redhat.com,
	alsa-devel@alsa-project.org, linux-tegra@vger.kernel.org,
	llvm@lists.linux.dev, patches@lists.linux.dev
Subject: Re: [PATCH] ASoC: tegra: Fix -Wuninitialized in
 tegra210_amx_platform_probe()
Message-ID: <ZSg1TEvIMu2qDzhm@orome.fritz.box>
References: <20231011-asoc-tegra-fix-uninit-soc_data-v1-1-0ef0ab44cf48@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="edj+BPVW5o8cXPI2"
Content-Disposition: inline
In-Reply-To: <20231011-asoc-tegra-fix-uninit-soc_data-v1-1-0ef0ab44cf48@kernel.org>
User-Agent: Mutt/2.2.12 (2023-09-09)


--edj+BPVW5o8cXPI2
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Oct 11, 2023 at 01:21:51PM -0700, Nathan Chancellor wrote:
> Clang warns (or errors with CONFIG_WERROR=3Dy):
>=20
>   sound/soc/tegra/tegra210_amx.c:553:10: error: variable 'soc_data' is un=
initialized when used here [-Werror,-Wuninitialized]
>     553 |                                             soc_data->regmap_co=
nf);
>         |                                             ^~~~~~~~
>=20
> A refactoring removed the initialization of this variable but its use
> was not updated. Use the soc_data value in the amx variable to resolve
> the warning and remove the soc_data variable, as it is now entirely
> unused.
>=20
> Closes: https://github.com/ClangBuiltLinux/linux/issues/1943
> Fixes: 9958d85968ed ("ASoC: Use device_get_match_data()")
> Signed-off-by: Nathan Chancellor <nathan@kernel.org>
> ---
>  sound/soc/tegra/tegra210_amx.c | 3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)

I see that Mark was quicker and this is already applied, but just for
the record, this fixes an OOPS that I started seeing recently but hadn't
gotten around to look at more closely, so I guess:

Tested-by: Thierry Reding <treding@nvidia.com>

And thanks!

Thierry

--edj+BPVW5o8cXPI2
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEEiOrDCAFJzPfAjcif3SOs138+s6EFAmUoNUwACgkQ3SOs138+
s6FvjxAAsd5bwFFR8vGCLIUjLqquDW0xtQm0nZacYaJmO059dJTozlND+izhpVvt
wwh1GxcniMG5Qg55FmxG82icd4V+3JmtKvCjSx32DO0CsdlOUg/JHTwifRI8mr2d
9a45DaeInh8pCQpYiEf3EjPZ+vuoDH0YKivuJwL+UGcCTzWyuA4Aoh8NciHJASQw
4Bwc3uq4dmvS/Ax2DgUO3/9hY0nEHT6o0Ke9xyPeQ+ZlBi9m304dY7Y53jNi8IWG
p8BF62VBiLqDh3icmqFTVd7NuBdkhjDP3BFvv8WjKssC5dv/e+/3wZT6od4EBK3j
ru+ZTDwzkx7sOuaS+UZ01D49LjCRS9Jq64XJxe1vUo5w97w297KanCgCIMo5AFQA
brqk8n9t9EluL2hgSlT7PidybAvsFO59dfhh+IraBhKUIe0j1gmFLtqU6UIVGosb
PoMqiQyuW29sLUABzGQY3zus38U8XI64DQC+nqAsrsvpSkwk5KgRdDqJ5DYhqVE1
qbFzPC9ONgM21oDzSybEuN1hDG1fHhhrLg8vMjWTjyDQInsv0J+vpobpnzuAdhOX
qVxYan5FyZThbet9v2/s/fK50P5S1+a9ShKSLlNkpAw9MLTrepd/SP9w7cw2ZLF2
TGp2g902Pnle5sSbNPqTYrtbEx1+lnhCpJvee8+Uf3WwrTzZbAc=
=WcBW
-----END PGP SIGNATURE-----

--edj+BPVW5o8cXPI2--
