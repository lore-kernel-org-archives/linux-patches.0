Received: from mail-lf1-f45.google.com (mail-lf1-f45.google.com [209.85.167.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 025BC5789D;
	Tue, 10 Jun 2025 03:48:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749527283; cv=none; b=RcPface6eB7pTR/+owj9PNTilCiy0P9jomjcgcV2YmfjjjvVjEDTBaab8q6kLvcpYkxem6kvnbF4nqSfniT6i/pTpqvyu8P4hoy0v88KTnQ+Nq7Qvyng0/pOQlYGem9lNhE32AE+v47Oqjx2zb6Dmc3RBqO0EH5iSVSHJAlncMY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749527283; c=relaxed/simple;
	bh=SuVp9AFmt8gLD64j4a+SRLxEwyPAPmST5oVeKyyVGVI=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Mu8uHccwBCdDoNdl2v6G+sovkuBYpacsA6eHpP+f/r1PPH2PbphcqF/A6tfn2tAcHlaTtc/w4twB2vq/n3DRdGK9/WF2dAwMzEDtsu7UaLpz26BciL0asHsnf4iuwMIQne7dFmHa1kmWXtdeNslqPwm3dUNNlqORtBfjEiF1ofc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=csie.org; spf=pass smtp.mailfrom=gmail.com; arc=none smtp.client-ip=209.85.167.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=csie.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-lf1-f45.google.com with SMTP id 2adb3069b0e04-55324062ea8so6500869e87.3;
        Mon, 09 Jun 2025 20:48:00 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749527277; x=1750132077;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :reply-to:in-reply-to:references:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=nZk/7/4MvcJfckdyvA+r+JfqYVWkeTH5dDDkcVRzYjI=;
        b=npvz1VhC5KA6u0OjMoj+2uReTIGarS2o8jVousLs6Afkzhd8G2R57JFi2vtTrJuNIJ
         trK8Q5ZTy/MUU6pYPmu7a3wImIRNTuYxImi0OCZ6R7QGstT9gJyk836A9n2TROqACrde
         ShR23YagqDPM14maJYdqzvvl7jGVDkCjYYVaN+LKOO/hwyVTAWp+8xSvSrnC8JP2CUHs
         RiW7k8x1n1HafOs2cXfVkMfcHO36TRShZ9DqllJetOTYl3oJcBTye40+ffNVRoF7WZpW
         uv44gW+BzbZeI/UAukkpG62i0uLZftUWs9qqL9TV/UEfhtKokT4Y9JnbZEQklBk9GEgI
         ruFQ==
X-Forwarded-Encrypted: i=1; AJvYcCUuCNGfHBqrsxmopS937gDBeAwtbS+bXXK5kVommpfigOKLBmBzOQhCmKjnUKk6K0GnDjrXKw==@lists.linux.dev, AJvYcCUvBWV36XJYOLKOpC7fvHxX7VpGI6amZUqqFJZnQGcfsN9lTY8ekF3vodfzZRmg3XCu+NkEO0jpYXNe69A=@lists.linux.dev, AJvYcCVzieEgg+FGZ5ffHRcwXozLrXTLT7jKca0mRVIEKGYFbOwK1gWr7cCwsXdzL+fZt6+2eJVtMUNaS2Gb1C+Lbwo=@lists.linux.dev, AJvYcCXr7B6Zi6KNoG5QTqPDNe/GyUopy7xDFoKubMnKY0b0Ss6DvSWLmY9UIiiYgucGKcpA572X3Zw=@lists.linux.dev, AJvYcCXxmTeWUMZPEeI6IH1VA/4kHHFh7nNF3s3UL8M9CLWgdilKuMtwmdrALBKOG3qq6J22SNN8nyjFvw==@lists.linux.dev
X-Gm-Message-State: AOJu0YxXp6RRlRhQDnjIthr9igEBeRZ9OfhtbYq1SJjIDsLDQhHTjKtW
	cn726Lr4hREecR9o3iFQF1ETDFuPwZeePcLZg5HMnD7VRi36kVLRWnLTOn7do94sx3o=
X-Gm-Gg: ASbGncsrvPv+DUbvpksIuO9QyjqNTU2b1+p5y7yJy8/fUBswHRxnEXmBnwD46G5/z0f
	A3tUTXk8hrf8XLW1Hd/cEO8ANbBYLjzkVjE9T7o6pqr2vim7uqGHh0zZMPf+s3yQiTvTj4+dPPB
	6VUw6VYAS0bV90P8WpW40M2hSuOvzmwqruVYvb3zeGwEVwLRDgjEz2vSORz1x7swo9qh46cH17X
	CFQxt/GiguAjZqbHr5QdyhxfyU/M+QeQZjGfrPvp6tab16qgbisatogOFnr1Ht8gR9X3W/8SMkb
	JFLihVKgval7KVc4MQfA3s3D1AfsGGYzMnvwZj7F5c2UvlYmOL5uB+wAW6CAmf2SLPXvRpOg5xq
	X80WmCsTb3ssTW9Twknw=
X-Google-Smtp-Source: AGHT+IGtAx3E0GkGm96xBngjQMnlMxOYfUOrjVJ/FWCIHj0a/rSABsf/iGXRzYWdHKJrM9Fw89B6Hw==
X-Received: by 2002:a05:6512:3056:b0:553:2ca4:39d3 with SMTP id 2adb3069b0e04-55366c3288cmr4346426e87.48.1749527276542;
        Mon, 09 Jun 2025 20:47:56 -0700 (PDT)
Received: from mail-lj1-f180.google.com (mail-lj1-f180.google.com. [209.85.208.180])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-553676d03c2sm1402937e87.18.2025.06.09.20.47.54
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 09 Jun 2025 20:47:55 -0700 (PDT)
Received: by mail-lj1-f180.google.com with SMTP id 38308e7fff4ca-310447fe59aso47865611fa.0;
        Mon, 09 Jun 2025 20:47:54 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCUUcfAxfY09EycBp3URiND+SBv5l3fAtTjE/yVJDQCqTgViZ2U0hOwQI67UUkk6+SOdgen3OGXK5g==@lists.linux.dev, AJvYcCVHDbgWHO5Uc/sxr4wVLoo4RRzbCjCVa54gMv3VMXTFGeQPNOpFW3dS6uqh+XjrukaSB1KaR9Pt/++VPN5uFOw=@lists.linux.dev, AJvYcCVIf1kXeQACZUBx1ahX1ocsBna+ZJ06MZ/3s10reUGmHlhH9mdabNk4+OmgjQhp/ecaAARxbBu1ABmhg5Y=@lists.linux.dev, AJvYcCVQPkd+8Lt9QXzKL35O4rANoTXKN0ALeSv4gzmTVhLLnwrGJK4oYgsZ7hBy+wIHh43+j0dN9g==@lists.linux.dev, AJvYcCWoGIUBgdLptIW9DQYxbVZvq5jIiVuoETE4gOYXvndBxnyt9nwnSBb2sJF+xY9Ii+ShUC3v0Ys=@lists.linux.dev
X-Received: by 2002:a2e:b693:0:b0:32a:ddd2:208e with SMTP id
 38308e7fff4ca-32adfc06f41mr30364041fa.9.1749527274652; Mon, 09 Jun 2025
 20:47:54 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <0-v2-68a2e1ba507c+1fb-iommu_rm_ops_pgsize_jgg@nvidia.com> <4-v2-68a2e1ba507c+1fb-iommu_rm_ops_pgsize_jgg@nvidia.com>
In-Reply-To: <4-v2-68a2e1ba507c+1fb-iommu_rm_ops_pgsize_jgg@nvidia.com>
Reply-To: wens@csie.org
From: Chen-Yu Tsai <wens@csie.org>
Date: Tue, 10 Jun 2025 11:47:42 +0800
X-Gmail-Original-Message-ID: <CAGb2v672aLfjX2_+=gnYEt09Z2m+sDoUi-weN2VsgtqnrK_fDw@mail.gmail.com>
X-Gm-Features: AX0GCFvT3cfnNTYictCtJSVKUrXJH3fCgSrvu85ggYc6KyathRV-zklZHWwYSnM
Message-ID: <CAGb2v672aLfjX2_+=gnYEt09Z2m+sDoUi-weN2VsgtqnrK_fDw@mail.gmail.com>
Subject: Re: [PATCH v2 4/7] iommu: Remove iommu_ops pgsize_bitmap from simple drivers
To: Jason Gunthorpe <jgg@nvidia.com>
Cc: Alexandre Ghiti <alex@ghiti.fr>, Alim Akhtar <alim.akhtar@samsung.com>, 
	Alyssa Rosenzweig <alyssa@rosenzweig.io>, 
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>, Albert Ou <aou@eecs.berkeley.edu>, 
	asahi@lists.linux.dev, Baolin Wang <baolin.wang@linux.alibaba.com>, 
	David Woodhouse <dwmw2@infradead.org>, Gerald Schaefer <gerald.schaefer@linux.ibm.com>, 
	Heiko Stuebner <heiko@sntech.de>, iommu@lists.linux.dev, Janne Grunau <j@jannau.net>, 
	Jean-Philippe Brucker <jean-philippe@linaro.org>, Jernej Skrabec <jernej.skrabec@gmail.com>, 
	Jonathan Hunter <jonathanh@nvidia.com>, Joerg Roedel <joro@8bytes.org>, 
	Krzysztof Kozlowski <krzk@kernel.org>, linux-arm-kernel@lists.infradead.org, 
	linux-arm-msm@vger.kernel.org, linux-mediatek@lists.infradead.org, 
	linux-riscv@lists.infradead.org, linux-rockchip@lists.infradead.org, 
	linux-s390@vger.kernel.org, linux-samsung-soc@vger.kernel.org, 
	linux-sunxi@lists.linux.dev, linux-tegra@vger.kernel.org, 
	Marek Szyprowski <m.szyprowski@samsung.com>, Matthias Brugger <matthias.bgg@gmail.com>, 
	Matthew Rosato <mjrosato@linux.ibm.com>, Neal Gompa <neal@gompa.dev>, 
	Orson Zhai <orsonzhai@gmail.com>, Palmer Dabbelt <palmer@dabbelt.com>, 
	Paul Walmsley <paul.walmsley@sifive.com>, Rob Clark <robin.clark@oss.qualcomm.com>, 
	Robin Murphy <robin.murphy@arm.com>, Samuel Holland <samuel@sholland.org>, Sven Peter <sven@kernel.org>, 
	Thierry Reding <thierry.reding@gmail.com>, Krishna Reddy <vdumpa@nvidia.com>, 
	virtualization@lists.linux.dev, Will Deacon <will@kernel.org>, 
	Yong Wu <yong.wu@mediatek.com>, Chunyan Zhang <zhang.lyra@gmail.com>, 
	Lu Baolu <baolu.lu@linux.intel.com>, Kevin Tian <kevin.tian@intel.com>, patches@lists.linux.dev, 
	Niklas Schnelle <schnelle@linux.ibm.com>, Sven Peter <sven@svenpeter.dev>, 
	Tomasz Jeznach <tjeznach@rivosinc.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Jun 10, 2025 at 4:41=E2=80=AFAM Jason Gunthorpe <jgg@nvidia.com> wr=
ote:
>
> These drivers just have a constant value for their page size, move it
> into their domain_alloc_paging function before setting up the geometry.
>
> Reviewed-by: Kevin Tian <kevin.tian@intel.com>
> Acked-by: Niklas Schnelle <schnelle@linux.ibm.com> # for s390-iommu.c
> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
> ---
>  drivers/iommu/exynos-iommu.c   | 3 ++-
>  drivers/iommu/ipmmu-vmsa.c     | 4 ++--
>  drivers/iommu/mtk_iommu_v1.c   | 3 ++-
>  drivers/iommu/omap-iommu.c     | 3 ++-
>  drivers/iommu/rockchip-iommu.c | 3 ++-
>  drivers/iommu/s390-iommu.c     | 2 +-
>  drivers/iommu/sprd-iommu.c     | 3 ++-
>  drivers/iommu/sun50i-iommu.c   | 3 ++-

Acked-by: Chen-Yu Tsai <wens@csie.org> # sun50i-iommu.c
