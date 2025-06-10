Received: from mail-ej1-f54.google.com (mail-ej1-f54.google.com [209.85.218.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF96C28BAB5;
	Tue, 10 Jun 2025 09:53:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749549209; cv=none; b=SCdCJNg3k2byTekey3NxXaCqr3ho171E/2WVqOffdyMGhJJSoMi4TgbCOMjubwCwIYoGPAAO+k4iAKSWd+l5fD7kxLwBwadwetsfA6+5y8wPOAb0hpTe0QVdJqrLm7jkW3ZbJhXrrQw/pG1245G1pMb6ZQ4gjEWimAJi0UB0A7w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749549209; c=relaxed/simple;
	bh=YmsTgiwWpHWvrWlkYScp/25qE9Zm0x2xShBrVv7CupE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=mnXwYqpbecpZCCkiBUnuEm88DYUOLzzRdNEGzgfbjc1bNZhIu9xYPg5amp/UVpivxwzWuU+hBG4LyikehAYB475ptnKEuLUMz5HPAIiCo99lUxfikk5NzOxEz9I3fgAfrHDLkYL/o8Q+00hR7tePjxtC1Bj0s+EbAvb9DtY6V+g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=fa/uWHhw; arc=none smtp.client-ip=209.85.218.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="fa/uWHhw"
Received: by mail-ej1-f54.google.com with SMTP id a640c23a62f3a-adb5cb6d8f1so835379466b.3;
        Tue, 10 Jun 2025 02:53:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1749549206; x=1750154006; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=ynyqhKwfprNPUGA4lTvvfAnYi3kIYj6o56wh0qfwUuY=;
        b=fa/uWHhwz8Wvysa0fb/TKfEjrQaLrNIo1Rr1FVGl5EsXRWcx5md/mh/mJv2RcUCqDm
         C07NVViTjeyhZZihWhRU38XIQyooOAjaIdkNpN27h759ryyxN8fycV6MeMZZlvESG99H
         4uouUqH2AUV3DMoAHONzGEfva92b1pKw6/6wMyqgY8s+m4xhNfA7zKMRGq2769gLTTNO
         5cgi0JE+71RNZUcHJC3NsE6hC4md/QXmQH47Gnd8QruqdP+fuX9Q/HsYvXuZVMxiFsN/
         T50DYlw3eYT3GACZEjvZyRJdZsNcLUYeNLRsMM+eqrw6QUezscCDpy44R29VwvRL2Ple
         UVGA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749549206; x=1750154006;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ynyqhKwfprNPUGA4lTvvfAnYi3kIYj6o56wh0qfwUuY=;
        b=uYypW5nx4rGYOwvkzn9I3HKzRTa/TDGb5hStTr9sxa1x/8amwspuCLmrJ2iHPRgopq
         2PsELpI8+YA9x94V2eeXUtDINw3WsxLcLd0Y9mBr0Ur77tYmBEcGb+w+crKw+oXYbXZ0
         jfDZbDmgagF4R2Q+Oco6wETLJemF2cT/CCI0bcEDrt324kQrVwK57gAAgr3Or7/k4zPL
         RyzqhYWUJqbG2pBIuMS9twMPiw1CG0KlEt4E+1F3MH5rECYuKJtZOF0lyJpot8RPXPFD
         4t6WpQFKznp6U08mJO/wPnxZEtg4T5COSgR6AE2wzaZwckW76w3Dj89tNHbw6pq0IQQa
         hRZQ==
X-Forwarded-Encrypted: i=1; AJvYcCUyQSWOUJaU73UbhEifL94ID10kC7L3xoLuFWM1IRlclvrTjJKfNz7K3TqKZS3YYtIVYtCQC3XR@lists.linux.dev
X-Gm-Message-State: AOJu0YzKkQH1eCax3F7Uofix23O0a2ZUXkrjhmntLTwPvTbYjbc44MIE
	YySz8IuUtZOHNFfBZut/TxrQxczvJOR8asjsvNzGx3PU5oBglbvBt/4I
X-Gm-Gg: ASbGncv2vnuWGrmmwNXUPFDU46tqp/j7/Y8K0IdPwZ2aoylqsf14DIZwLuKbtMYUY6h
	K0p29M+JSBAnAuD49DCZfK4US4SA3IsnicEjpuRO4GOB2UAb/fEz7XhSsCfelaLOnBsePz5p6Ht
	QzFMu7BkLiFI6/QZkBlLaEHqz7sm53yh7q7abeMcrud6Sa4eYmlPVH8/iHi+0GZ35QDs6pAC7gr
	RjPzuyNw7rB5dfajZvXenWr0Z1Nb8MnXiA3DbY296saRx1l0DytyfPNvpYIMyp3RTxP1//Ob2C5
	yvmkeVy5dB20HKqrnAWFUXU/UxOISjrBRbhgmKxmr/KNEkkTD1MaCTmuSdBCs2hHTfEYI49luVz
	RvYXMii5Md6mvgF0AJ9PIlT7qsz/VMp09NEbTxZudz3HWt62ZaJaF8kPSBZY=
X-Google-Smtp-Source: AGHT+IGe0qSd+CguPpuDw/vWQmo+8UBgL9eF8vO1hXeva+H8aYcdbH0HcR/1Tkn/Fb7c2OknDpbnIA==
X-Received: by 2002:a17:907:7b96:b0:ad8:8efe:3205 with SMTP id a640c23a62f3a-ade1abc5a39mr1482183866b.55.1749549205928;
        Tue, 10 Jun 2025 02:53:25 -0700 (PDT)
Received: from orome (p200300e41f281b00f22f74fffe1f3a53.dip0.t-ipconnect.de. [2003:e4:1f28:1b00:f22f:74ff:fe1f:3a53])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-ade1db5784bsm688003166b.71.2025.06.10.02.53.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 Jun 2025 02:53:24 -0700 (PDT)
Date: Tue, 10 Jun 2025 11:53:22 +0200
From: Thierry Reding <thierry.reding@gmail.com>
To: Jason Gunthorpe <jgg@nvidia.com>
Cc: iommu@lists.linux.dev, Jonathan Hunter <jonathanh@nvidia.com>, 
	Joerg Roedel <joro@8bytes.org>, linux-tegra@vger.kernel.org, Robin Murphy <robin.murphy@arm.com>, 
	Krishna Reddy <vdumpa@nvidia.com>, Will Deacon <will@kernel.org>, 
	Diogo Ivo <diogo.ivo@tecnico.ulisboa.pt>, Joerg Roedel <jroedel@suse.de>, patches@lists.linux.dev
Subject: Re: [PATCH rc] iommu/terga: Fix incorrect size calculation
Message-ID: <ymj7mvy7ezlbb2t5jrv47qdrxg557q424g6d2vlnc4dyav4vfn@smwgn5d4av3s>
References: <0-v1-da7b8b3d57eb+ce-iommu_terga_sizeof_jgg@nvidia.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="xtiiprxlyuwuxuqc"
Content-Disposition: inline
In-Reply-To: <0-v1-da7b8b3d57eb+ce-iommu_terga_sizeof_jgg@nvidia.com>


--xtiiprxlyuwuxuqc
Content-Type: text/plain; protected-headers=v1; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
Subject: Re: [PATCH rc] iommu/terga: Fix incorrect size calculation
MIME-Version: 1.0

On Tue, Jun 03, 2025 at 04:14:45PM -0300, Jason Gunthorpe wrote:
> This driver uses a mixture of ways to get the size of a PTE,
> tegra_smmu_set_pde() did it as sizeof(*pd) which became wrong when pd
> switched to a struct tegra_pd.
>=20
> Switch pd back to a u32* in tegra_smmu_set_pde() so the sizeof(*pd)
> returns 4.
>=20
> Fixes: 50568f87d1e2 ("iommu/terga: Do not use struct page as the handle f=
or as->pd memory")
> Reported-by: Diogo Ivo <diogo.ivo@tecnico.ulisboa.pt>
> Closes: https://lore.kernel.org/all/62e7f7fe-6200-4e4f-ad42-d58ad272baa6@=
tecnico.ulisboa.pt/
> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
> ---
>  drivers/iommu/tegra-smmu.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)

Acked-by: Thierry Reding <treding@nvidia.com>

--xtiiprxlyuwuxuqc
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEEiOrDCAFJzPfAjcif3SOs138+s6EFAmhIAJAACgkQ3SOs138+
s6F98Q//SCHTzZhRnxaJm7hof3jA2KxWVvS+Xsgu1tWVrea5XhXWm6wz6BoupZPk
zLdS9MGapHHxrsqVfddKDGsBW08GqDml+oFxuYV6gnX7sYpcHyjFYbqOkR2+6Z9W
wl2jRJEhDaU0woCj7NsVqqBABMSJhQxsZLp7tIOACNXNUIQ0clz4uwXCfnBDEhFI
BB6Bm9pdOy5BovIq0JeQnus8S32W84Ptn0OXB7ZCxhBHr1kM3kuiz3YU5Y2e69cb
hM5jcuNKIsp2xFEoC5dnfYA2lyH3aO+/+6bcbU16ZoHJHohByREND7XaKnZFe8pW
I1VfWSl7A3jC+Ti6q4Q43jUVAdPsOh02umxDzMZvXebySC43YE5dxoHWbBJCTf7j
1P0C0Sv/7vhUfaW8Vb7ocvEMFufBreVryrgGs98HW9LRYQ80J/HsQGlOG4z5nbqr
ljLk+nq9WNYNFgKb/KNwhWodGehQh+oR5fkBxjoRaqUwlSl3QDx/jXfvK4ihsdmr
0wC1/hv/wVgJ4bcWEVi1nbMb+Ryoij9QVwp0c/ETLqNVjwag+wjDwW19IPHtP+kW
Sos6hV1fcwOo5/+g29MLLNJEmokgaVw6O4XzmDcgyOAp7/ZQrwYEV1frSjYOIdNm
DnLfkT6xj+MP1vXUxNJEBTKlkIJjJo51zRseJiAWfKc/HJkbmds=
=CuHx
-----END PGP SIGNATURE-----

--xtiiprxlyuwuxuqc--
