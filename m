Received: from mail-lf1-f44.google.com (mail-lf1-f44.google.com [209.85.167.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4DBCBC13B
	for <patches@lists.linux.dev>; Sun, 27 Oct 2024 15:02:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730041367; cv=none; b=vEe40mV4nyG2CuEBH5e5M9uJn+sNHFgv0L33MdnVSaIw7tDh03eB0D0PjNUzjp9j/O6ED831JwEdhAQrQxUuCBl3BC0YETOije08JJpTww5Idfk0p3KY1ZIdly25lYt3/zlkae/lws08soyaWaf6pfb9J35paq5LYX1nY1ZBOmE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730041367; c=relaxed/simple;
	bh=YN5uOcCVqLCrU2rPWl/pSKH8JOoi5g+jhmSQm5uMpRE=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=M0T+HzgbSx5mBAz7qS1DI5R2mYEYMYeJIoBdb6GYVzzIm0OPZMczmUfgdvUORrCs/NwdQA+LSs2tgG1oDp96sCzc9R1OwOPaOA6mXnhxASvLR1FR8YAMvOiB3VDXBZRXlokl1xqPb0VyPu6RKnv+uJ0f+1EQgbdkzI3I5i3SguU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=DKQw65bg; arc=none smtp.client-ip=209.85.167.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="DKQw65bg"
Received: by mail-lf1-f44.google.com with SMTP id 2adb3069b0e04-539e5c15fd3so3094121e87.3
        for <patches@lists.linux.dev>; Sun, 27 Oct 2024 08:02:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1730041363; x=1730646163; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=x4R7lu/kAshlAJXnNL3llyVtKBCbHq8h1Es4W4nUkAU=;
        b=DKQw65bgfB5Y68rPbm6cHMIkT7ZKNd2/sdzenNHjsPSIgUDU8mNeufdWxWcSPYIzZa
         k5lnOQVGolgQIpIBmQ8kgWQXVkUysAc2fvOGyhdPlAKjKO0vPXHq4+aHDt8W5PuJwzXV
         YYIKU5vD/2II+jKsUajfQE0mj+Vc5XT+ZphikXBtxZF9pdrRh3pBm71qeiNbyUPiMP9m
         vrkPqlTXPMdwR3KknCgtJXmBk99FU3X7ovUbDzzeKavYoOozpUcdvzrp2nnazvsWNXCh
         xsaOXAI47NzvaGl81MusmM6gU23KskUa5/2cYSCzRzRsC2jFVR8ADWM2xYxHSgpOoN01
         Hz+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1730041363; x=1730646163;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=x4R7lu/kAshlAJXnNL3llyVtKBCbHq8h1Es4W4nUkAU=;
        b=SFEp57VGnhVgHfW2RZIHhv0DD59+Gp2zN118h3jGXtWcjKxtFcDScLyS+VzR2uyOHi
         5xMRTs50qYDZ/uEHMFZMBBWiXl8cNKqgvjjVqHHa0LE3lsHTDjPeh7j0KmW7TiSrz1O4
         4Q00cmjgM+6UTTT7GrBdQPXQymFx3h+n0hWYkLrQPRhMnnaASqk7LKjcbImqPvhKGfr+
         I/tpqloYYGmbmmQdxJpeYRAu+/6omMiNjB80683cfaGj6/blug+9UDodJyezy6Er1Obi
         A5OhMukeSguLOEPj5aT/Vn38zsIacBOlZYiaiNnByAULtP3nQf/tVYy2RfWJPITjpdSu
         ThLQ==
X-Forwarded-Encrypted: i=1; AJvYcCWXkYHbgIj6l5fy2LZ/YxBaZwVRjB8XWynHKyAyOZt4FcMVEtqSol4ZlRJW92uJpVdOew1YpnV5@lists.linux.dev
X-Gm-Message-State: AOJu0Yy/6VjnRDeFEQd3yqXeX7lM43n5YdLNcnBWrrDV4ZvsykdGpicg
	jL30BNeQ8oeZ/B97g3wcC+LROhTjMveRUDW8D7pq8mrJHQpOCe642byXuPipmX5Vcz5CtdLmSCF
	pjOi28Q2BoHN/7+T++rI4QLDsTIATYQLjf4lv+w==
X-Google-Smtp-Source: AGHT+IFqLjsyKJ5CxjDNJGvvyW3lXMFUulX6UFQluIj2OcmHgocN09ZljnrI5ISQ8+uIxzhs+el7dmiVvKGjST2wbUc=
X-Received: by 2002:a05:6512:1092:b0:53b:20a1:1c4a with SMTP id
 2adb3069b0e04-53b34a19077mr1821924e87.42.1730041363426; Sun, 27 Oct 2024
 08:02:43 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <cover.1729897278.git.nicolinc@nvidia.com> <384f7b4333a1f75da09e390902b8f82be21a0dd3.1729897278.git.nicolinc@nvidia.com>
In-Reply-To: <384f7b4333a1f75da09e390902b8f82be21a0dd3.1729897278.git.nicolinc@nvidia.com>
From: Zhangfei Gao <zhangfei.gao@linaro.org>
Date: Sun, 27 Oct 2024 23:02:31 +0800
Message-ID: <CABQgh9EpGPwdQhv7mepiMGVgR-8NMx5dcXyJ2A92W8ZzQt3bJw@mail.gmail.com>
Subject: Re: [PATCH v5 07/13] iommufd/viommu: Add iommufd_viommu_find_dev helper
To: Nicolin Chen <nicolinc@nvidia.com>
Cc: jgg@nvidia.com, kevin.tian@intel.com, will@kernel.org, joro@8bytes.org, 
	suravee.suthikulpanit@amd.com, robin.murphy@arm.com, dwmw2@infradead.org, 
	baolu.lu@linux.intel.com, shuah@kernel.org, linux-kernel@vger.kernel.org, 
	iommu@lists.linux.dev, linux-arm-kernel@lists.infradead.org, 
	linux-kselftest@vger.kernel.org, eric.auger@redhat.com, 
	jean-philippe@linaro.org, mdf@kernel.org, mshavit@google.com, 
	shameerali.kolothum.thodi@huawei.com, smostafa@google.com, yi.l.liu@intel.com, 
	aik@amd.com, patches@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"

On Sat, 26 Oct 2024 at 07:51, Nicolin Chen <nicolinc@nvidia.com> wrote:
>
> This avoids a bigger trouble of exposing struct iommufd_device and struct
> iommufd_vdevice in the public header.
>
> Signed-off-by: Nicolin Chen <nicolinc@nvidia.com>
> ---
>  include/linux/iommufd.h        |  8 ++++++++
>  drivers/iommu/iommufd/driver.c | 13 +++++++++++++
>  2 files changed, 21 insertions(+)
>
> diff --git a/include/linux/iommufd.h b/include/linux/iommufd.h
> index 0287a6d00192..dc174d02132b 100644
> --- a/include/linux/iommufd.h
> +++ b/include/linux/iommufd.h
> @@ -184,6 +184,8 @@ static inline int iommufd_vfio_compat_set_no_iommu(struct iommufd_ctx *ictx)
>  struct iommufd_object *_iommufd_object_alloc(struct iommufd_ctx *ictx,
>                                              size_t size,
>                                              enum iommufd_object_type type);
> +struct device *iommufd_viommu_find_dev(struct iommufd_viommu *viommu,
> +                                      unsigned long vdev_id);
>  #else /* !CONFIG_IOMMUFD_DRIVER */
>  static inline struct iommufd_object *
>  _iommufd_object_alloc(struct iommufd_ctx *ictx, size_t size,
> @@ -191,6 +193,12 @@ _iommufd_object_alloc(struct iommufd_ctx *ictx, size_t size,
>  {
>         return ERR_PTR(-EOPNOTSUPP);
>  }
> +
> +static inline struct device *
> +iommufd_viommu_find_dev(struct iommufd_viommu *viommu, unsigned long vdev_id)
> +{
> +       return NULL;
> +}
>  #endif /* CONFIG_IOMMUFD_DRIVER */
>
>  /*
> diff --git a/drivers/iommu/iommufd/driver.c b/drivers/iommu/iommufd/driver.c
> index c0876d3f91c7..3604443f82a1 100644
> --- a/drivers/iommu/iommufd/driver.c
> +++ b/drivers/iommu/iommufd/driver.c
> @@ -36,3 +36,16 @@ struct iommufd_object *_iommufd_object_alloc(struct iommufd_ctx *ictx,
>         return ERR_PTR(rc);
>  }
>  EXPORT_SYMBOL_NS_GPL(_iommufd_object_alloc, IOMMUFD);
> +
> +/* Caller should xa_lock(&viommu->vdevs) to protect the return value */
> +struct device *iommufd_viommu_find_dev(struct iommufd_viommu *viommu,
> +                                      unsigned long vdev_id)
> +{
> +       struct iommufd_vdevice *vdev;
> +
> +       lockdep_is_held(&viommu->vdevs.xa_lock);
> +
> +       vdev = xa_load(&viommu->vdevs, vdev_id);
> +       return vdev ? vdev->idev->dev : NULL;
> +}

Got this error?

ld: Unexpected GOT/PLT entries detected!
ld: Unexpected run-time procedure linkages detected!
ld: drivers/iommu/iommufd/driver.o: in function `iommufd_viommu_find_dev':
linux/drivers/iommu/iommufd/driver.c:47: undefined reference to
`lockdep_is_held'
make[2]: *** [scripts/Makefile.vmlinux:34: vmlinux] Error 1
make[1]: *** [/home/linaro/iommufd/linux/Makefile:1166: vmlinux] Error 2
make: *** [Makefile:224: __sub-make] Error 2
