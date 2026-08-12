Received: from mail-pj1-f45.google.com (mail-pj1-f45.google.com [209.85.216.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9516840F8ED
	for <patches@lists.linux.dev>; Wed, 12 Aug 2026 22:13:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.216.45
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786572819; cv=pass; b=FrByASgk+uP2uTszRFOuQ76uPHsyqdYCXbgqgrWYGd5oxw6h/tkLHJLwCXjXBysGDdls0g3nlYqGaxE9knpn7nhkkLbOZBAfT78+E2L0++UvPPXK0cXiZkPDo6yaxGw0tVNOW8QtDATIMp6WyHaOGMTuKQZv9lgbzfSmQDS5lz0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786572819; c=relaxed/simple;
	bh=byyagvsc1UjkE8b+SW2ccxMNYjbe0DMj7QW0GEW3cJE=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=UHrtRzzQ/MacU0g4tAp0a2jomA1oPoLpcGtw8vjAcT1uRMBPDWRIechwtRLPttqxDuoKgnc9Z9iKdSdNLcVfLzyXGly6K92YDPVIxIQ4ahD0QY2aX4GKPvkmdf4mObAUhs3V/DLzX9ySBtDnbjXUnkMa20gZprPPkNhoOy+xeeo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=txj7PkIG; arc=pass smtp.client-ip=209.85.216.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="txj7PkIG"
Received: by mail-pj1-f45.google.com with SMTP id 98e67ed59e1d1-38e07ebd263so1195348a91.1
        for <patches@lists.linux.dev>; Wed, 12 Aug 2026 15:13:37 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1786572817; cv=none;
        d=google.com; s=arc-20260327;
        b=S8Oy9X8A7PsAdfBk1j74DP+asP0KEmaKP7+9X63/5BNe1zoh5VxhTVlckfPD/q7vCi
         7BRGXB9XhUh7Xjbr6Ot+jY1LlDZIjNZh5mznyCssMWYAnjQJxOlmpglqfTDAtUjxKsJt
         63ME0VmRuN5UmnSWbLNQtj8nTR4LdtuIpr0sLz3kxdQMxy5ZhNa7PR6II+EJrZm/5Ra5
         gpMpv3LpAfxmXd9WBwdv99Mw4qhIgXs1vu3SZ/hGW8uAkqyyQ6DzsHZYQ5B6aNyqVJfb
         WA7OXw/2QfJqymDNkOZWBaiygBBY0ZDvNM0UIt/l8gr/B0pJaWfag4G41qWIl2Z2G8xH
         whVA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=I2diJELU9B/EJYj35M681THFCJwWyYCFNlAAsuJpsCA=;
        fh=j6lLTM3goqDPDEDNp6FsITx20nTQWI+X/0/mZcHfvoo=;
        b=sg/NEnhlUhzhKfdMLRKhiVeNjz844+txgeRt1LZkAQoQveKzEgcai7M4ZTGM9zMXnW
         qtB1+IJFzEgOVrMkwIdsR1g4z+hW3MlbaL7jNUW/xqPZs70B1v9X6Ehm/qbH1fX0Gb3s
         SNPLmB70gAyv0ug/yzXHTruHdF8DEd9WiD/kOSjsr5LrfTZfcl5t2dYDIGV2ni7bc625
         myYmXf2qHKZnrjO3UsyefPNH/TvcFdBPr0OKTrAybv6/tHaADf14iWEXvtmutOyB8Igh
         reNoow8CYJak83fWhyoN3+w4GIXAl/krVBUKKntgW92+Q5sgsuHAg4y5L3TZxOOvBHDT
         Hbng==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1786572817; x=1787177617; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=I2diJELU9B/EJYj35M681THFCJwWyYCFNlAAsuJpsCA=;
        b=txj7PkIGzRxgrnXy8LQZq2WSK6GLS4rtLoeeK00RvFHGXCVcgCvR4LcaN3j3Jcygvu
         QlVJbbnbB+gW3QFqbW064pYK9fhW6N999H7MdTYatwty5DEZCljqTB/OOX9C5dOIEMZV
         kmwLQYAgN27ocAE40GG6XZq5AWG5FW3MFxQQi4RNlNitnLkQBer73mlpUfr62A8MbVKh
         QtlSV4BWwJHFpB8Hr+Ae7mUqsMU/otJE2RwwxGq+Vns460gcZ/SKwxLnH6qIR9v5Rzg1
         Pf3rxwzmLrlfTTM3teFa2cpdq+485v8FTl/+u63GDTr8S73oEs4YLL4lFOpQm8HE2Zbd
         TofQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786572817; x=1787177617;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=I2diJELU9B/EJYj35M681THFCJwWyYCFNlAAsuJpsCA=;
        b=G9KP4TGm3gmWB7d8gWXV661VPFTONrZiG7rV5HhZTgaBr/WjFYgF+QCbKgE1UMf014
         p4Q10ZIHF/OB3zCI26ZqnOVmteDNbDjv5BS3LOax21GJ338RQ/URjqJ1UfstZpSKj3rt
         TIwj42Vhlz7i3yxcbzVMEZ5ZL7In1Hd6Zoga5vVNoX8ou/GZZJjRBm1Z2G7dk3NfehC5
         bPNL6egWAhCWOVjix4CCmbt5hdX7FkJK+BhyXSDtcB/uH+6kG56HYeFzzIOUiwL2pMRY
         Dz63vsNxYDYfjlxBwrKXZgH4+heqCJXC8dD+dxSpCCI87Wa18R5Luj/BjB9f2TcZRmgm
         43og==
X-Forwarded-Encrypted: i=1; AHgh+RrDJF4Jot6Nnfu498vKuWK+K4+WT+j95aCvyLPoi3DZmJDI3LXlrg0w6xvFBeCs31NQA9MkEAo8@lists.linux.dev
X-Gm-Message-State: AOJu0YxxAqNWZ1w4y/F8B/FfvjEvc4r0NDPyy2KMMUgNOZF1cCZOAoCx
	bDdo842iLVisTjnv0Q7Dg0E19FySSHCQckrFj/7KDVyTlrtekXkRFZDVyWQ91Q4/EFhjOk3F8sF
	/qIjk4qUBb+4Sebaw2m1dPng3mG7RRxIEf1Hk7Tut
X-Gm-Gg: AR+sD12aHXzGVRhJoqeaxw9oNGudmhGU54PudFWOpkggZGMlTDsaGRjGE5euTdIzPHT
	ZbYiKoIOig7zPVyW6Z6PqtbMtrT7bXlmB8CI3kp8XUbuUOfl8IFQGvcCDubR70x4yDCNpLJ9R0m
	acvGUJbnhmKPV3AwNxwDPPK/uJZhsuJ1DJCaPj3vWBz+4ODPUGeDstCZRSoVAMc29RVUHqWgbH5
	XeBlf3PiUF/C4OLZSNIPYhj/5TcbjiY7klTRjAkqri2Y9YFqQxkegWdl47znD+qvuu0qxORRB3k
	Qe5mEcsT5/DKJAALL8f/yKicxukUC+Qv9Ve6WYJssLI7oLkXiR6e9lc=
X-Received: by 2002:a17:90b:4e8e:b0:38e:5b59:c2ff with SMTP id
 98e67ed59e1d1-3931dfd0888mr1664002a91.3.1786572816160; Wed, 12 Aug 2026
 15:13:36 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <0-v4-021df3fb5a3f+98e-mlx5st_jgg@nvidia.com> <6-v4-021df3fb5a3f+98e-mlx5st_jgg@nvidia.com>
 <anzvkibgzTae9eV9@google.com>
In-Reply-To: <anzvkibgzTae9eV9@google.com>
From: David Matlack <dmatlack@google.com>
Date: Wed, 12 Aug 2026 15:13:09 -0700
X-Gm-Features: AUfX_mwo8Ob8itM9mFOrvjUREAOlXg8MDm_8-_pKnvDnHzhEXLZf3Bq4dnwstOw
Message-ID: <CALzav=dptFQTKyUAiDVsv4LF79pkhfHaVyaYE8FD4-5rrWHGZg@mail.gmail.com>
Subject: Re: [PATCH v4 06/10] vfio: selftests: Allow drivers to specify
 required region size
To: Jason Gunthorpe <jgg@nvidia.com>
Cc: Alex Williamson <alex@shazbot.org>, kvm@vger.kernel.org, 
	Leon Romanovsky <leon@kernel.org>, linux-kselftest@vger.kernel.org, 
	linux-rdma@vger.kernel.org, Mark Bloch <mbloch@nvidia.com>, netdev@vger.kernel.org, 
	Saeed Mahameed <saeedm@nvidia.com>, Shuah Khan <shuah@kernel.org>, Tariq Toukan <tariqt@nvidia.com>, 
	patches@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Aug 12, 2026 at 3:11=E2=80=AFPM David Matlack <dmatlack@google.com>=
 wrote:
>
> On 2026-08-12 11:59 AM, Jason Gunthorpe wrote:
> > Add a region_size field to struct vfio_pci_driver_ops so drivers can
> > declare how much DMA-mapped region they need. The mlx5 driver will need
> > ~18MB for firmware pages. Existing drivers pass in the sizeof their sta=
te
> > struct. Since drivers all use only their declared state we can use the
> > value directly and remove the SZ_2M hard coding.
> >
> > Assisted-by: Claude:claude-opus-4.6
> > Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
>
> ...
>
> > diff --git a/tools/testing/selftests/vfio/lib/iova_allocator.c b/tools/=
testing/selftests/vfio/lib/iova_allocator.c
> > index 4a660f636f4972..c8075575e9131d 100644
> > --- a/tools/testing/selftests/vfio/lib/iova_allocator.c
> > +++ b/tools/testing/selftests/vfio/lib/iova_allocator.c
> > @@ -13,8 +13,10 @@
> >
> >  #include <linux/iommufd.h>
> >  #include <linux/limits.h>
> > +#include <linux/log2.h>
> >  #include <linux/mman.h>
> >  #include <linux/overflow.h>
> > +#include <linux/sizes.h>
> >  #include <linux/types.h>
> >  #include <linux/vfio.h>
> >
> > @@ -50,7 +52,8 @@ void iova_allocator_cleanup(struct iova_allocator *al=
locator)
> >  iova_t iova_allocator_alloc(struct iova_allocator *allocator, size_t s=
ize)
> >  {
> >       VFIO_ASSERT_GT(size, 0, "Invalid size arg, zero\n");
> > -     VFIO_ASSERT_EQ(size & (size - 1), 0, "Invalid size arg, non-power=
-of-2\n");
> > +     /* Adjust the size to the allocator requirements */
> > +     size =3D max_t(u64, roundup_pow_of_two(size), getpagesize());
>
> ...
>
> > diff --git a/tools/testing/selftests/vfio/lib/vfio_pci_driver.c b/tools=
/testing/selftests/vfio/lib/vfio_pci_driver.c
> > index 5e65434d2318b2..52b9c2a2bbb9b6 100644
> > --- a/tools/testing/selftests/vfio/lib/vfio_pci_driver.c
> > +++ b/tools/testing/selftests/vfio/lib/vfio_pci_driver.c
> > @@ -32,6 +32,9 @@ void vfio_pci_driver_probe(struct vfio_pci_device *de=
vice)
> >                       continue;
> >
> >               device->driver.ops =3D ops;
> > +
> > +             VFIO_ASSERT_NE(ops->region_size, 0);
> > +             device->driver.region.size =3D ops->region_size;
>
> I'm seeing failures with the IGB driver with this series. I think it's
> coming from here. The region size needs to be page-aligned so that the
> IOMMU map/unmap calls can work?
>
> The size of struct igb is 0x20080 bytes which is not page-aligned. The
> size of struct mlx5st_device is 0x200D000, which is page-aligned, so
> that's probably why your Claude did not notice.
>
> # #  RUN           vfio_pci_driver_test.iommufd.send_msi ...
> # /usr/local/google/home/dmatlack/kernel/trees/review/tools/testing/selft=
ests/vfio/lib/include/libvfio/iommu.h:42:
> # Assertion Failure
> #
> #   Expression: __iommu_map(iommu, region) =3D=3D 0
> #   Observed: 0xffffffffffffffea =3D=3D 0
> #   [errno: 22 - Invalid argument]
> #
> # # send_msi: Test failed
> # #          FAIL  vfio_pci_driver_test.iommufd.send_msi
> # not ok 33 vfio_pci_driver_test.iommufd.send_msi
>
> Applying this on top fixes things and also avoids a potential overflow
> when doing the roundup_pow_of_two() in the allocator.
>
> diff --git a/tools/testing/selftests/vfio/lib/iova_allocator.c b/tools/te=
sting/selftests/vfio/lib/iova_allocator.c
> index c8075575e913..66a160d4ff9d 100644
> --- a/tools/testing/selftests/vfio/lib/iova_allocator.c
> +++ b/tools/testing/selftests/vfio/lib/iova_allocator.c
> @@ -52,8 +52,11 @@ void iova_allocator_cleanup(struct iova_allocator *all=
ocator)
>  iova_t iova_allocator_alloc(struct iova_allocator *allocator, size_t siz=
e)
>  {
>         VFIO_ASSERT_GT(size, 0, "Invalid size arg, zero\n");
> -       /* Adjust the size to the allocator requirements */
> -       size =3D max_t(u64, roundup_pow_of_two(size), getpagesize());
> +       VFIO_ASSERT_LT(size, rounddown_pow_of_two(SIZE_MAX),

Oops, that should be VFIO_ASSERT_LE().

> +                      "Invalid size arg, too large (%lu)\n", size);
> +
> +       size =3D roundup_pow_of_two(size);
>
>         for (;;) {
>                 struct iommu_iova_range *range;
> diff --git a/tools/testing/selftests/vfio/lib/vfio_pci_driver.c b/tools/t=
esting/selftests/vfio/lib/vfio_pci_driver.c
> index 96a940ea59b5..b31abfe2c7ff 100644
> --- a/tools/testing/selftests/vfio/lib/vfio_pci_driver.c
> +++ b/tools/testing/selftests/vfio/lib/vfio_pci_driver.c
> @@ -36,7 +36,8 @@ void vfio_pci_driver_probe(struct vfio_pci_device *devi=
ce)
>                 device->driver.ops =3D ops;
>
>                 VFIO_ASSERT_NE(ops->region_size, 0);
> -               device->driver.region.size =3D ops->region_size;
> +               device->driver.region.size =3D
> +                       round_up(ops->region_size, getpagesize());
>         }
>  }
