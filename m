Received: from mail-wm1-f46.google.com (mail-wm1-f46.google.com [209.85.128.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 35C6E1E8323;
	Wed, 19 Mar 2025 18:10:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742407851; cv=none; b=KoXAIhjxf4m0ujZLV12oEZ3pcPL7apQ9FTm/ieu3PGEjpAUsRTpoDhWHmMxDnFokXe6uH3CSFOvvEEJ7TerRTx8wsMKsOobIbd5dMXSSNdrlTtk6LTpLsdotwf0jYi82zSh/NjoDxcfjfZbJPeztvF5r2aJKNRaqK1qdaaQN6Dk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742407851; c=relaxed/simple;
	bh=NRDBPEHgXUupa2eHopjm+NVMZxrKrUuYtULMiQNFxdw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=FeEQ1qRKn1McVLRz7tWTL0Vc5No7xOZJA8X5lt0S2T9Xhs6PWeS3w/jA2q/ZTIYwDukJjEhcKhrMnwPYUfSG7NoRIWGYs0TzwDbVlxoCRQWjZ9fbYmFA+xISkqCex++nmOZKscDtLekOUj28YDuz+h0RQ0pMX+9KMmAJoxly5Pc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=by4Ngmdq; arc=none smtp.client-ip=209.85.128.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="by4Ngmdq"
Received: by mail-wm1-f46.google.com with SMTP id 5b1f17b1804b1-43d2d952eb1so33018585e9.1;
        Wed, 19 Mar 2025 11:10:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1742407846; x=1743012646; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=NRDBPEHgXUupa2eHopjm+NVMZxrKrUuYtULMiQNFxdw=;
        b=by4NgmdqYY0WagEdCD5/BKFKqu3NB73BGTzbA1Yi+W9R2tcNtLffH3Sl1/9pCUsv08
         HD9mBhy+Gza/4NHpQCN1fJP7+pTeR3edLpz1Ia6pWmhfus9CyZy2hnHWvZhJvboOBozl
         UJP+H3Fjqi8Thur45JDlI9mvx+3SzHJntIDV7gUpramqMMBhWLGq++TuJB9UFp71DLAp
         aWstCzwn3A/9wpu2RUeMi+R+9SH4ZNik44BWINBlw0X0fxNxzwrRLqK+DqV36x1oT+wH
         8q2z7D1pS5L5kNdZJhSY162MXEfXxHXB9DSF++x5iIQtqwq58JkiKMZ31qWfsk/vDp2v
         ZSXQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1742407846; x=1743012646;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=NRDBPEHgXUupa2eHopjm+NVMZxrKrUuYtULMiQNFxdw=;
        b=QlEoEjiPacJijQJv7QEN0A5BxTRqVE9t001K1LTdKfbjtLqG4W2HdFGMdFV3NlbPzf
         Mkt+KOnVQpouaph962+7yR2FUtD3UzrAHia1DkG4EbgdphWNom1LXtW63Iu1NB9tEh+N
         hzy9erUVPqMg518wdaT/NU/xXbQ+SA/4rYyrOmj7s0ZDYdxgIjKU2MxXx+oNpvcxgGbF
         djDYc0fdxLd4raFR6NhnIf3d+1IoWYelpfLy33AUEDANdyhWyQ/3zzBsgbGQm9jjoSGN
         WPGrI2upzGE0PSa8PSyRehQ3ZP+9jEkTd8U7hjd/w/KJzdMddI/zFCNAFaZ5e5qRe7Bk
         2hvg==
X-Forwarded-Encrypted: i=1; AJvYcCU59oBzagu89l4W4drRgacIvV22/WWtncvT9ziqfWRL5iBmmc1khFORMu2rBtDsEloJ4ELUVp2mFWOQ10k=@lists.linux.dev, AJvYcCVnM/GSDKNecRhe91p+3ySGlX1cLZu9xSIeTfM9f1Kv6KqK8IblXIa+45pzFGk7AtSO3Noa9eyV@lists.linux.dev
X-Gm-Message-State: AOJu0YxUQRvDspZFuFVA8ehP5v5/qnn8Ba7RIdl9H7EwXBSCXrrU05er
	Wmp8Ir26wZkhRwqQsBSN/Wqmn730hWAolG6iXxRUBHUfDAkeaQ7q
X-Gm-Gg: ASbGncvrfF4TP2JnV/QNqPodry4TbVk39IVNUY/0UECj3CxowYrYJJGgpszi2KU+Al7
	0/MorR3SYxPcvl/F5/FU9FO/8NoJ5LiDW6jjgtzGEoTWIDNyHVMeByxVR9WGNValzkewOUoRonA
	aB4TI10i+lbBiN/PplszzusQKkvi4ycjIAb1hbTZB+D8Z+WT6z4b9FgmPa4keLaR0wZY7Wup4x2
	xleGQAh7Tx2u1gNDrzAIAc84z7jcjDoB+oSDJ4oQDKBHM6OiiJoCu2eW1W/mjbN23hg40r9FWlR
	x2i/6Ya5E/orb9Dzj1JyB+Uv4qqeeobLTpZQVWmRsrP/BEpDnOs7Vs7yytYUTc6GhwAhTJ2pnTx
	GOfxjcq173/jDBT8GBVs1nC/2fbfy5eE=
X-Google-Smtp-Source: AGHT+IHYFWZdONoLhtaU63p45Xf9+bWz8YoVzEW+0yAcNTLY2gKQG7/aemrHzQVaMzVWmdFrLB4q/A==
X-Received: by 2002:a05:600c:348e:b0:43c:f16a:641e with SMTP id 5b1f17b1804b1-43d43781690mr33983605e9.6.1742407846139;
        Wed, 19 Mar 2025 11:10:46 -0700 (PDT)
Received: from orome (p200300e41f3a9f00f22f74fffe1f3a53.dip0.t-ipconnect.de. [2003:e4:1f3a:9f00:f22f:74ff:fe1f:3a53])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-395c8881187sm21267993f8f.41.2025.03.19.11.10.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 19 Mar 2025 11:10:45 -0700 (PDT)
Date: Wed, 19 Mar 2025 19:10:43 +0100
From: Thierry Reding <thierry.reding@gmail.com>
To: Diogo Ivo <diogo.ivo@tecnico.ulisboa.pt>
Cc: Jason Gunthorpe <jgg@nvidia.com>, David Airlie <airlied@gmail.com>, 
	dri-devel@lists.freedesktop.org, linux-tegra@vger.kernel.org, 
	Mikko Perttunen <mperttunen@nvidia.com>, Simona Vetter <simona@ffwll.ch>, 
	Lu Baolu <baolu.lu@linux.intel.com>, Joerg Roedel <jroedel@suse.de>, 
	Jerry Snitselaar <jsnitsel@redhat.com>, patches@lists.linux.dev, regressions@lists.linux.dev
Subject: Re: [PATCH rc] gpu: host1x: Do not assume that a NULL domain means
 no DMA IOMMU
Message-ID: <vn6lqxfqvi6tbxomrvn6ct3ezvegx3y2q4sdwpjkvbehzzs3gl@ctek3pks5y3e>
References: <0-v1-10dcc8ce3869+3a7-host1x_identity_jgg@nvidia.com>
 <19478509-5007-4a20-9512-b965126b7026@tecnico.ulisboa.pt>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="3vs3sblqwnplgzuh"
Content-Disposition: inline
In-Reply-To: <19478509-5007-4a20-9512-b965126b7026@tecnico.ulisboa.pt>


--3vs3sblqwnplgzuh
Content-Type: text/plain; protected-headers=v1; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
Subject: Re: [PATCH rc] gpu: host1x: Do not assume that a NULL domain means
 no DMA IOMMU
MIME-Version: 1.0

On Mon, Mar 10, 2025 at 12:34:35PM +0000, Diogo Ivo wrote:
>=20
> Hello again,
>=20
> On 2/4/25 7:18 PM, Jason Gunthorpe wrote:
> > Previously with tegra-smmu, even with CONFIG_IOMMU_DMA, the default dom=
ain
> > could have been left as NULL. The NULL domain is specially recognized by
> > host1x_iommu_attach() as meaning it is not the DMA domain and
> > should be replaced with the special shared domain.
> >=20
> > This happened prior to the below commit because tegra-smmu was using the
> > NULL domain to mean IDENTITY.
> >=20
> > Now that the domain is properly labled the test in DRM doesn't see NULL.
> > Check for IDENTITY as well to enable the special domains.
> >=20
> > This is the same issue and basic fix as seen in
> > commit fae6e669cdc5 ("drm/tegra: Do not assume that a NULL domain means=
 no
> > DMA IOMMU").
> >=20
> > Fixes: c8cc2655cc6c ("iommu/tegra-smmu: Implement an IDENTITY domain")
> > Reported-by: Diogo Ivo <diogo.ivo@tecnico.ulisboa.pt>
> > Closes: https://lore.kernel.org/all/c6a6f114-3acd-4d56-a13b-b88978e927d=
c@tecnico.ulisboa.pt/
> > Tested-by: Diogo Ivo <diogo.ivo@tecnico.ulisboa.pt>
> > Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
>=20
> Any news on this patch or any other solutions for this regression? It's
> not great if this falls through the cracks, especially when there is a
> solution for the problem.

Looks like I had marked this as applied by mistake. Thanks for the
reminder, it's applied now.

Thierry

--3vs3sblqwnplgzuh
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEEiOrDCAFJzPfAjcif3SOs138+s6EFAmfbCKMACgkQ3SOs138+
s6Gc0A//TrzbaprQO4xc8Hgq6tcEIg3KdqfdbBdYgELgL6bY+60NkY0cm5wcsUaG
he5y3ZfuZLUBjV2rlhJAuyOdpScrjekO0lB12wmnTKypOsp/ugFDTgDnrdgIgQU9
Brs4DDAVu9AB/pjN8jHnQ0wOYpR5yXW69ZKGZuu+FAlscC8hVQ2SoyAUP9WDBcw5
cy2E5pZuVs7ti6MhF4MaL1hkFz4QjPnlupAxwBEMslsf/6vzJeTwVwAB9wq6aoj7
43NFJ2U7VLPMBQA0DfdPMI50gJGeAkKfBWuQMIXwRsH2XUT93uzXrJr0qKDWROUA
/s8z6kuKi1jnUZ+gbUUZauQyHFF9OT8sJAND9Tx2bnDUncfmj7ZSrP4MU0F6uYJV
PU13U30Dm76w6IV0X+zNfDUyRUoapVBAbpFRtlKX8yn+mGrZy5vMJdGiu+AUZJBS
hbuEAg5qW+DDcwwJsrjMpOTfIPAEWJ6Kxm2t5Qr/Jtd1WpiCmQD6pDrxud24yEBt
DQ897YMsOP7DT5UJG8B7IXFL95OTyDYTXcSFK8D802Il1tBfjh1jZnoteva8VhHd
wI0bHAyWDdND+KrX8WbtLeDzCc97vw9yJ4RfI7ZI9G2waRmQBdpWXTv1K8lt5gDy
03jmd6jX8CfULyXueikrm5+Br92M9afX66J+ubSq1o2QPn9R+UU=
=aAbR
-----END PGP SIGNATURE-----

--3vs3sblqwnplgzuh--
