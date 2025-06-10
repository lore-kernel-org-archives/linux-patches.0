Received: from mail-wr1-f53.google.com (mail-wr1-f53.google.com [209.85.221.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C5CA028A71A;
	Tue, 10 Jun 2025 09:11:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749546700; cv=none; b=lx2Mx1k9zkIYNEtgyhaIsbbZZZZELDTkNQc2KR7JLKep5Ps2MvVWV8z2tAysljUXau9DwWIj0oonvjhTuflpiG8NZ/cSp2P0/Egew57IKCBNsP01S41RKxV1NxsAbFPZLdD9mMM5nSzj3IF9Sir3MYkw1Ye72oKBbiKGaaM9ZU0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749546700; c=relaxed/simple;
	bh=gtuGk4aRFSpL1zHBjW3pY01TZxS1XUNvzlXCe18x3zY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=AokrcfttryTOMaWfu2htW0ySxGLfeWhYgg7xgi8XjbTF4n3dCw/huREmtdpzPytQtz+wSn1DnTdjF1RP5+oq51MivJbkr3J6v3TgseeOGj5APLNU4ZjlRWOfQn2uPRlQRw+JLQyasK2dcJfuTsZwcsRBrnFZ2u9tlWI8XlYXD8I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=F/1hzaj7; arc=none smtp.client-ip=209.85.221.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="F/1hzaj7"
Received: by mail-wr1-f53.google.com with SMTP id ffacd0b85a97d-3a53ee6fcd5so1565617f8f.1;
        Tue, 10 Jun 2025 02:11:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1749546694; x=1750151494; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=/J4JSHATnk9TCsjKFzEkFQy2OXqCakBAt2qzrcv/bCo=;
        b=F/1hzaj7d6LszItlOPvGDPi6HbZ/kxblDGcnhFcbEXCU0+qmdiutcdi31IqoeUbW6o
         DpsdReGJNoRNWBGNK5uT1Y/QxVpvqThIN9CH9qvNckchLb7Gza1c/Xx313WFn9+LwqkU
         yisULe+Ex0iQwNJehfeQSxycfGWYjhKL339WPzHYPXXBcIj7Ynuhumoanf6vjSB3MN0S
         iFIPW85egcD0o7yvjXOvbJMUSM9t0coGBDGusCasH37xGuzvH4644UpHstjBgIm3zQqn
         M1TBmSCnLK6Qwv8x3esg+yncUn8+r/O6pShvCwQv53GFRirY0QR+dOnBBkWK5/6fobT0
         M7TA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749546694; x=1750151494;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=/J4JSHATnk9TCsjKFzEkFQy2OXqCakBAt2qzrcv/bCo=;
        b=quY4HFqqxQHTg5qg8W7v/XJ4ST+3iCHvaUtu8xvmzstyMsF5/ji4U/IQecfTs389mi
         YCLxyJn1UFfj38ZVzUuN/QUoyN6xnvywyAv2ENxGGt8O4nblhISED4u8V5Q3PFmRipUr
         u6gD/EiW9eswnYDlNGKbp3oPdMPj9tIvPKXhBSYJAfxf8P2h777qwE99sMPBdCD3jk/z
         utwIW7ims/mASdEiLgnBQ0aPKkNOfVO7k8mokwVM1RhVPuBjqJVsPt2D1MaMXjI6CcZw
         ZJ+6U3qznWEGFxO1RCvkK8GUZWHnkK565GGYs31QGV6ihLJG7eUhIVkeyf71VbldGVal
         QyeQ==
X-Forwarded-Encrypted: i=1; AJvYcCU2w7bVsM4Fa9BLv+pN8po1B3WzaWzblEezxIcY0HMi86CM+Rl1hdzrCmHB/DLx9MPtOii/NA==@lists.linux.dev, AJvYcCV4ulvcvQEt6TejaX0Xrx/iTio1VAkkNOKsd4Xy7diHlW9bFF5Zlzmwu6fIBjj9gkcXYSjsvxbqEdtTK+0=@lists.linux.dev, AJvYcCVes+JduTtbgDx4raBT8QBGXEAH6wHegt3YqkQIGa2l++qvGB5QjgdhSzMdPJ/LCcf1C2/5xLA7l88UpNTU25Y=@lists.linux.dev, AJvYcCW0/UDuwWEsrqjXBfwLk2NwclBXO7MfIqFXuZ1rOI/uCzef6XHiAadPp5gfVpdscyv6LCrNQT40Rg==@lists.linux.dev, AJvYcCXPPOQIez7tgTMCUhM4CxZ69kSQwipvy79HqxfMaEW48va+Q7C/LkhsQo7I2/Ls2pj1E/2dtZs=@lists.linux.dev
X-Gm-Message-State: AOJu0YxT7DmOn3y3/giReXoFsZyB/YJOeofu8zKIo2hieVXaYQ4w13O5
	JKK/vx9Rfz9y968YoEpDOJBFFNjEKNY2d8VEY8dI/DtseaynCa8X8pxt
X-Gm-Gg: ASbGncsfSmPpKfG0M4bDmD0QXyMhiDCS5bDRuBY8G9Fyg/5ubtOJ0cBDANHFXu49Scb
	4zChDiaNUgr695Sw/tPosbd9A/qLh7Ieni2Pr83SjVK4QrYVPhkPSWxIcH9QXijQ+oVEZCfm6WM
	BSOP/b17ypVaCr3FedbIuX322jvFrO1HMiQbrKKHlmb+LEAwnjfHd7D6ON3yxyl7hB5vDJj9laY
	PgwADgACHG2fH+AAxj0fJoBwU4VnzasSJVC9SOOMnfYlkAYL/5LuLGn5ziler7b4DwojExZNrBf
	Ly1f1s4gpsJva5rmtgZnjh7Hy8xYMk6Y+8FsNcfhwHKzjnZoKJBYTJDtcLxBY298kjAbSj9SF20
	pUKgU1+jZ+/1t2SSvlooTEzvojzsUM0+TR4wKsjuNDDEjWo/i
X-Google-Smtp-Source: AGHT+IGiaud+NmiD3BNjNEkh0KdS8oAZ8TPOqcLbBsZsD4cCdkMv4OiwbthBO25zWdPhWgZ1rXZiAA==
X-Received: by 2002:a5d:588a:0:b0:3a4:f936:7882 with SMTP id ffacd0b85a97d-3a531ced06fmr13875069f8f.55.1749546693846;
        Tue, 10 Jun 2025 02:11:33 -0700 (PDT)
Received: from orome (p200300e41f281b00f22f74fffe1f3a53.dip0.t-ipconnect.de. [2003:e4:1f28:1b00:f22f:74ff:fe1f:3a53])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-45320580af6sm6174635e9.1.2025.06.10.02.11.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 Jun 2025 02:11:32 -0700 (PDT)
Date: Tue, 10 Jun 2025 11:11:30 +0200
From: Thierry Reding <thierry.reding@gmail.com>
To: Jason Gunthorpe <jgg@nvidia.com>
Cc: Alexandre Ghiti <alex@ghiti.fr>, Alim Akhtar <alim.akhtar@samsung.com>, 
	Alyssa Rosenzweig <alyssa@rosenzweig.io>, 
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>, Albert Ou <aou@eecs.berkeley.edu>, asahi@lists.linux.dev, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, David Woodhouse <dwmw2@infradead.org>, 
	Gerald Schaefer <gerald.schaefer@linux.ibm.com>, Heiko Stuebner <heiko@sntech.de>, iommu@lists.linux.dev, 
	Janne Grunau <j@jannau.net>, Jean-Philippe Brucker <jean-philippe@linaro.org>, 
	Jernej Skrabec <jernej.skrabec@gmail.com>, Jonathan Hunter <jonathanh@nvidia.com>, 
	Joerg Roedel <joro@8bytes.org>, Krzysztof Kozlowski <krzk@kernel.org>, 
	linux-arm-kernel@lists.infradead.org, linux-arm-msm@vger.kernel.org, 
	linux-mediatek@lists.infradead.org, linux-riscv@lists.infradead.org, 
	linux-rockchip@lists.infradead.org, linux-s390@vger.kernel.org, linux-samsung-soc@vger.kernel.org, 
	linux-sunxi@lists.linux.dev, linux-tegra@vger.kernel.org, 
	Marek Szyprowski <m.szyprowski@samsung.com>, Matthias Brugger <matthias.bgg@gmail.com>, 
	Matthew Rosato <mjrosato@linux.ibm.com>, Neal Gompa <neal@gompa.dev>, Orson Zhai <orsonzhai@gmail.com>, 
	Palmer Dabbelt <palmer@dabbelt.com>, Paul Walmsley <paul.walmsley@sifive.com>, 
	Rob Clark <robin.clark@oss.qualcomm.com>, Robin Murphy <robin.murphy@arm.com>, 
	Samuel Holland <samuel@sholland.org>, Sven Peter <sven@kernel.org>, Krishna Reddy <vdumpa@nvidia.com>, 
	virtualization@lists.linux.dev, Chen-Yu Tsai <wens@csie.org>, Will Deacon <will@kernel.org>, 
	Yong Wu <yong.wu@mediatek.com>, Chunyan Zhang <zhang.lyra@gmail.com>, 
	Lu Baolu <baolu.lu@linux.intel.com>, Kevin Tian <kevin.tian@intel.com>, patches@lists.linux.dev, 
	Niklas Schnelle <schnelle@linux.ibm.com>, Sven Peter <sven@svenpeter.dev>, 
	Tomasz Jeznach <tjeznach@rivosinc.com>
Subject: Re: [PATCH v2 4/7] iommu: Remove iommu_ops pgsize_bitmap from simple
 drivers
Message-ID: <zkfsgkps6z5wyjxdl3wmn2piwgir7swgml4jomuhxxkedne22d@hwzwxvcwpu3h>
References: <0-v2-68a2e1ba507c+1fb-iommu_rm_ops_pgsize_jgg@nvidia.com>
 <4-v2-68a2e1ba507c+1fb-iommu_rm_ops_pgsize_jgg@nvidia.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="noll3rebw4hmh74s"
Content-Disposition: inline
In-Reply-To: <4-v2-68a2e1ba507c+1fb-iommu_rm_ops_pgsize_jgg@nvidia.com>


--noll3rebw4hmh74s
Content-Type: text/plain; protected-headers=v1; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
Subject: Re: [PATCH v2 4/7] iommu: Remove iommu_ops pgsize_bitmap from simple
 drivers
MIME-Version: 1.0

On Mon, Jun 09, 2025 at 05:41:28PM -0300, Jason Gunthorpe wrote:
[...]
> diff --git a/drivers/iommu/tegra-smmu.c b/drivers/iommu/tegra-smmu.c
> index 61897d50162dd7..fa0913e9346c71 100644
> --- a/drivers/iommu/tegra-smmu.c
> +++ b/drivers/iommu/tegra-smmu.c
> @@ -318,6 +318,8 @@ static struct iommu_domain *tegra_smmu_domain_alloc_p=
aging(struct device *dev)
> =20
>  	spin_lock_init(&as->lock);
> =20
> +	as->domain.pgsize_bitmap =3D SZ_4K;
> +
>  	/* setup aperture */
>  	as->domain.geometry.aperture_start =3D 0;
>  	as->domain.geometry.aperture_end =3D 0xffffffff;
> @@ -1002,7 +1004,6 @@ static const struct iommu_ops tegra_smmu_ops =3D {
>  	.probe_device =3D tegra_smmu_probe_device,
>  	.device_group =3D tegra_smmu_device_group,
>  	.of_xlate =3D tegra_smmu_of_xlate,
> -	.pgsize_bitmap =3D SZ_4K,
>  	.default_domain_ops =3D &(const struct iommu_domain_ops) {
>  		.attach_dev	=3D tegra_smmu_attach_dev,
>  		.map_pages	=3D tegra_smmu_map,

Acked-by: Thierry Reding <treding@nvidia.com>

--noll3rebw4hmh74s
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEEiOrDCAFJzPfAjcif3SOs138+s6EFAmhH9sIACgkQ3SOs138+
s6HNrxAAo93PCboo986Da72XguJIozPLAKyIbWbaeG0mAjcZN8YUqcSh21C3Xp4m
qkNL3FwIbtg55H/1upzln07ZErFxc56r95b+GjnH7G4+X4608YnbKmdlZMxzkhpk
Hiqglce9T205CGZdT2oaZeO26+zHlTeh3LBiiR4o0eurhupQldQ9evEZ5qVseZDA
FOHY9nWWRDf0/HkM/+MpPA/8cXnNUpME3+OMZIWf6E0Fk0YJnGKS/FIj/aoYPvJI
9cHiJLi/xs2mxDGh9xUuYDXRcapqzGw6fpsFzJM4G1dEDbYctUR9IOgvdWJ/vzNk
zYnCdPC4tMYkkOwW85wmXbkVUkbTplxVlLUrVBDVjsou2gKfhKOj/lXWBQjWXJ2w
PWaIHU9l+OSWsvXB3qkUtROmoqFqrf4+XA/2kV9AlRJO7rrb0hK8yj42rtjec2ix
y5aU/5/v0Hcr+d09jaikpqhAx1miE9mHEFObqRBtOVko2pZ4l/DD6OVWBNDJyqHM
9fX438+BucatKIy11m72MpW4m9FdBxwhPEfpyQSc79NCDtoKzoxE0wGFzxqcKyys
EMGegmdKh0OKQke0uP2Ieo02BIp7sCoCf4m98nTRTYfOGTgfXO4kmfccAUeki59x
5ez2fDP654E1ESVH+Xn7bWfBKtFiuw6IlaPL+CPNnjcaAxxtDUk=
=E5td
-----END PGP SIGNATURE-----

--noll3rebw4hmh74s--
