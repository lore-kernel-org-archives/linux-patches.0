Received: from mail-qt1-f172.google.com (mail-qt1-f172.google.com [209.85.160.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4EC191CAA3
	for <patches@lists.linux.dev>; Wed, 13 Mar 2024 09:19:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710321556; cv=none; b=ZeHSVx6yjbTHI6jP0+HIuMR9svZ0x3ecMy/WP1RIVxxOjg6USoqcruvhisH4XzKj53VbPIeetNNsaLKtBQjLLUCZ4wFEI9DycyZ0sphdlS7VRYm15P2HyvCrhDW5mo7ERFwr94/19mCgtIEyO9sFhV+j4N5Zu9oKbHTHN4SBKag=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710321556; c=relaxed/simple;
	bh=wBB7DVpy1uSNs4MGAm/0ZnuUEDCM2fXMfnXKV13z59c=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=YN+DYn62DkKjIU4TUee9VeIwTy8BGTsC9lQ3njkoGlKeNFo0HIS64X0xsNJjy0VqsMUTbm/wApZZNDmTt3uWSK+6vBoY5+/AcBs1oFAJw+mIj1ClLRpdtL+LFMjCfhtiIUIw6xzjhnLjjMXJrCMJ60AZ8Xr224LFMiZAx9ldChc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=t2iplvxi; arc=none smtp.client-ip=209.85.160.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="t2iplvxi"
Received: by mail-qt1-f172.google.com with SMTP id d75a77b69052e-42ef8193ae6so169871cf.1
        for <patches@lists.linux.dev>; Wed, 13 Mar 2024 02:19:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1710321554; x=1710926354; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=sb+S6UppVnn4w7hdxgCL/WHS7Fkrh3i9kZy6ZdromFs=;
        b=t2iplvxi7PPWXrSLASNIYmAVx4oNzQBabQf5ka5Kp4dPGad3g/e6POYkSyYeifo7UE
         pAaY71tPfM0pz5S5z3c39pY3oeKMIoaro7nmgzijN6t17Ugkd0lwagX0xfpNdVXCLX3O
         lo8W2vbas9hvbEGA85xCI3WuMeoRwjTb7AqjZVx3UZ9bVwzdcvbfr+x98jzbtcvLCrkz
         ZaA667RSf2cHWqFx79ZWvonq7Euwdzw8jk9QGrQ3kyU8CzJKOFzEFYlUTOLUlvVWCVgM
         aSpo5YvPseMm90B+uhRtUyJc2TqrkVda8SlZEKO1dFqV5EXWXYCqUvMi1Gda6Pn7hxJX
         Vx6w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1710321554; x=1710926354;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=sb+S6UppVnn4w7hdxgCL/WHS7Fkrh3i9kZy6ZdromFs=;
        b=WISEMnk6xcUAAk7F1k81EGLSOE38y7jR/rwbIAEe7fKYWYVsy5AuYh5fm7b8AQgnnp
         1cO1Lihnnw7On/mOhn0djsamZyBAMUUa0woa6nXM+2eW5Yuro7UL3yRx2tBpWggDnK+E
         OVF61UAaMcymSdJj0OSoU/sMwZ8Rsjs8F6YvqsGVni+Qs+rfLSFzFjdXWVDOhlfq62Vo
         7v/Spyv+zfWbMr5PC96gUzoIQbUrtDxuE1HPspBbSb+GG/lOCI2Ca1N0aFpKm/tJafXn
         8IWeSUfcW4azJwPJRnZQtj/eWu2h+lVM9xsB7uWyJH6OXLe1ukHMAnA+qTC4Xtl48Amf
         Kr5w==
X-Forwarded-Encrypted: i=1; AJvYcCUl6ieNMUmkv1n+pR2YFT9TxAqvhlX2/GZJtzgWwUXp+hxSeVnqPylMQs2T5xzv/AUpJUKk1yvH/Nxvkd48G5Nq4eAM5tuIqw==
X-Gm-Message-State: AOJu0Yz+OAUx+4LXarWL/SUuH3WXD8cMPJ/rTJZRb0Ek98DXT43zeEhc
	4vuliLnmJwR4ztgLNrRaqeGb7XhrEDIEElYGutnyOHe/kgTvbfQppDQX4t4Nm8iXkCOrGiniGVf
	77QUeDb85ubHjyER0b097GS0E7gn8qo/AueAf
X-Google-Smtp-Source: AGHT+IGmlHoBGdgtDrqZQEOgDrE4YurE3IPrHq5J/dHoluiz27ChdMk4a4wLMRqkhWSwfQjuDuM/WgDh26Eyt97xDHA=
X-Received: by 2002:a05:622a:108:b0:42e:fce9:a5e4 with SMTP id
 u8-20020a05622a010800b0042efce9a5e4mr286978qtw.4.1710321554028; Wed, 13 Mar
 2024 02:19:14 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <0-v5-9a37e0c884ce+31e3-smmuv3_newapi_p2_jgg@nvidia.com> <2-v5-9a37e0c884ce+31e3-smmuv3_newapi_p2_jgg@nvidia.com>
In-Reply-To: <2-v5-9a37e0c884ce+31e3-smmuv3_newapi_p2_jgg@nvidia.com>
From: Michael Shavit <mshavit@google.com>
Date: Wed, 13 Mar 2024 17:18:36 +0800
Message-ID: <CAKHBV24+cd5n+W2-hOga7Trujk3PcObTvwTj=dkyRTjUFu_4ZQ@mail.gmail.com>
Subject: Re: [PATCH v5 02/27] iommu/arm-smmu-v3: Do not ATC invalidate the
 entire domain
To: Jason Gunthorpe <jgg@nvidia.com>
Cc: iommu@lists.linux.dev, Joerg Roedel <joro@8bytes.org>, 
	linux-arm-kernel@lists.infradead.org, Robin Murphy <robin.murphy@arm.com>, 
	Will Deacon <will@kernel.org>, Eric Auger <eric.auger@redhat.com>, 
	Jean-Philippe Brucker <jean-philippe@linaro.org>, Moritz Fischer <mdf@kernel.org>, 
	Nicolin Chen <nicolinc@nvidia.com>, patches@lists.linux.dev, 
	Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Reviewed-by: Michael Shavit <mshavit@google.com>

On Tue, Mar 5, 2024 at 7:44=E2=80=AFAM Jason Gunthorpe <jgg@nvidia.com> wro=
te:
>
> At this point we know which master we are going to change the PCI config
> on, this is the only device we need to invalidate. Switch
> arm_smmu_atc_inv_domain() for arm_smmu_atc_inv_master().
>
> Tested-by: Nicolin Chen <nicolinc@nvidia.com>
> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
> ---
>  drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c | 5 ++++-
>  1 file changed, 4 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c b/drivers/iommu/=
arm/arm-smmu-v3/arm-smmu-v3.c
> index d1bc151a5dff8c..9e9233331c4636 100644
> --- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
> +++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
> @@ -2447,7 +2447,10 @@ static void arm_smmu_enable_ats(struct arm_smmu_ma=
ster *master,
>         pdev =3D to_pci_dev(master->dev);
>
>         atomic_inc(&smmu_domain->nr_ats_masters);
> -       arm_smmu_atc_inv_domain(smmu_domain, IOMMU_NO_PASID, 0, 0);
> +       /*
> +        * ATC invalidation of PASID 0 causes the entire ATC to be flushe=
d.
> +        */
> +       arm_smmu_atc_inv_master(master);
>         if (pci_enable_ats(pdev, stu))
>                 dev_err(master->dev, "Failed to enable ATS (STU %zu)\n", =
stu);
>  }
> --
> 2.43.2
>
>
