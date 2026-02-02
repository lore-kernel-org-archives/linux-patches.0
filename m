Received: from mail-oo1-f48.google.com (mail-oo1-f48.google.com [209.85.161.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2BB4A23ED75
	for <patches@lists.linux.dev>; Mon,  2 Feb 2026 06:02:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.161.48
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770012130; cv=pass; b=Kitp7bKKgmwL9SLuT3b+ACnbpzQsbBm51Z1zoLgel0lbPi4ygqUiCljRECyvylLkzgxWMnDDLrYzpwmbX2Q/rapM9rl3WsW+eaLrSFWQnQs9HX5CD7Zz70CrfnEoq+Xu2yICymooYx2a2DPW4Uz+itb7B7GFxJ3ZMSqcLciGFgo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770012130; c=relaxed/simple;
	bh=1PCVKoGEu5ZKGgsfNA8Godrm165Zgd+zEgQyqYZf1M4=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Hg/C6VhwUhdye9QHynSXD4FnOZ80apshDC+M0BLEvzL3bwAQu2BGn+daPuVDWLBeep5sEIKCQjtaIIKpwc4J+LU4q+1ZqNI9Tb9QWJqSVNns1c8gP155AmCXy1phOF/AMHM6/uaUjWvesZ6xTqNJWiB6zQZ2n0Aj9JfgqPEklTY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=rivosinc.com; spf=pass smtp.mailfrom=rivosinc.com; dkim=pass (2048-bit key) header.d=rivosinc.com header.i=@rivosinc.com header.b=OHnZiBCS; arc=pass smtp.client-ip=209.85.161.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=rivosinc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=rivosinc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=rivosinc.com header.i=@rivosinc.com header.b="OHnZiBCS"
Received: by mail-oo1-f48.google.com with SMTP id 006d021491bc7-6610e72112bso1920115eaf.1
        for <patches@lists.linux.dev>; Sun, 01 Feb 2026 22:02:08 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1770012128; cv=none;
        d=google.com; s=arc-20240605;
        b=d75DJk869916dtdw7rXhnxYvPhHrj5ULgICAIfWhTo0/GunqBsmO9EVY15ywtHD5oR
         TeGKto17fDuaAEA8vE9+hvGdW1JZPovQyOvSzJuZdjR9zoQ15l/RNA3iRPOV3EGx3b7d
         9Nf4eYl9ujEHWEqE3wUHkA7rg8q8fv4OSaH6qydNId2rZwhmTxwXMI2en/fKbn86oIZU
         x/OkE1gR4f9j6W4KSObfLMpJNx3CxGwxBGyorTNvJyOwx3ACqPBnp6sv2Qow5XLTlNCd
         kIUyBwbmJEGgy7lh43piQDVoDBqnwmuGwNXDawNk7tEHRHHbDdyBID8PGftCDUMIJlfR
         czgw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=GcxQOk1Ogg7o0Jhu3EeWbmSG4NAptutIfk5zNYKLdfs=;
        fh=TAxxTSfOBsY9GbV+geWHipJh1pDeP7GdMW7mchE4uh0=;
        b=PFVvDFSmGXhDT/OyYdXq3ouWUF8uUlHReYi7jYyl9mRPGfQF36bkCt24HTs/miLiUP
         HnpGF6QPi1I5q7atvigSPWdN2CjP3Mramt/nJ6pfNZ0QtlTwV3AJn9gvHE+rObtZ2YE+
         eC0foGeUyfonsoxIUraWobQmn8h/wZfBhtyhK3DHxniAQR215dJR/8mK/Vml+sEx09HF
         Sa3EKtyOdUnNlktuSVzBBjDk4LuQQuX3keHs0ObubePurR08xox4M1PbG10VzsDsKGwQ
         VjfVQLs4xa3PZnGOYuFwXBrWK8d50oNUYX6QrFylOuW0LoS3bB+mQUJSGIBYbSZatWc+
         ENQg==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc.com; s=google; t=1770012128; x=1770616928; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=GcxQOk1Ogg7o0Jhu3EeWbmSG4NAptutIfk5zNYKLdfs=;
        b=OHnZiBCSB9tPxsfdQWn7b/NiHJIAAsn6CEMr7ZGnYp45eGyLYb5hIEc6+RuIFwhYHb
         XXxDyWLCcsu5fGhszZI9gKFcvZzUkmhTWF16Blc99LPHHIXUh2IlaWzhfiumUvGpnbL9
         REGaKqDUXlqsJmN8eK/fDd6FAlVc7hHwopixkpd1fyYkKLXy0FTOSgRmGP2evO9Is2ft
         T3dkhySWMDJzi4Y/2hmpcHmup3NbCSJ/4kKVbiVCSuIE5/8fGV+fAUenL7ttexxsXGY9
         3Y2luynKNll9jS+cdg9VobDZGRoymP+96DTRxz7rTcZpCChdeqO+kqFSznQL6EpbxUMZ
         q+nw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770012128; x=1770616928;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=GcxQOk1Ogg7o0Jhu3EeWbmSG4NAptutIfk5zNYKLdfs=;
        b=goegamTqLkEsN2g8XxWbnLSELsF2MXZ5Y+RcNWlWhrmeDOTdiOVEslPGntPVoiZikc
         G6cfj85FGCzCoShJqJ/niVTF2MZ4kq8ePuX4EfFh4gHAv+zoy7uR783CkQ57PtkXjxzH
         qw7KeJf2BFbz6TtbO3d2ZBUTUasPvzVKQL9IWn4085VdvfUXFwzPrmkt3jySJVXXv0Bz
         y5gCtyUJ2DU2swQTr0GBBr1dCzw3kllPg+x+UHIZyZE4/ztxYWf05VQnPnHsN2BXlnd+
         CaHUtn2ppjFTJtcM5KXskXzwQ39RWwfmwGhD/omA+6sSrhueYhYmD/6w9HcMgqh8NUnP
         iKeA==
X-Forwarded-Encrypted: i=1; AJvYcCXE99JzcLTk/PAVh89U3lZKQVpmhrNxMG695W0S4wIooZCp1rLaLYKo8BSo1mdi1TVZoPV86hE+@lists.linux.dev
X-Gm-Message-State: AOJu0YzEHnPiFmo8/jG5Qfighyo2WxKPM2q4kbdyflTbNNlKBr5L+V8H
	qJKQRwc3sAVq3tUo5HJ9ejkZAAiAVg5JfRydp+RMOTBKV3rN9sYKP5XFHGap+RH/OTmGnbJK6To
	1kDlaIa1PnR0qyibk0QMBObi6qqz3mYYR7ksxoRPYDw==
X-Gm-Gg: AZuq6aKwUnbzxKKzy05d6iyjm6hBuiv9RMO2mlELZGxhsp+PBG9bnP3dYIPuUPH54rs
	sXjQmdI/wnlyrZpb88VG3E3dq4tsbizeR5oedShAg+rFILLtlEeBSmG9L3WF2xklpONWhOniwMk
	Nqc4TuA26Hc4HnTWuVxAXavOxjQtc/cLyFDIPeV2P/cuyH5xUyOgrZVRwyCP8DV0RKMdqPTAZYr
	1nYKFd3okYwAO2scXJE5sQCyPLF4Vj8R/nNGWKgmQQ98oCr+Y3/bJ1YYo180RLp/u1C/VE=
X-Received: by 2002:a05:6820:22a7:b0:662:fc84:fa6b with SMTP id
 006d021491bc7-6630f35f60cmr5159965eaf.49.1770012128041; Sun, 01 Feb 2026
 22:02:08 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <0-v3-9dbf0a72a51c+302-iommu_pt_riscv_jgg@nvidia.com>
In-Reply-To: <0-v3-9dbf0a72a51c+302-iommu_pt_riscv_jgg@nvidia.com>
From: Tomasz Jeznach <tjeznach@rivosinc.com>
Date: Sun, 1 Feb 2026 22:01:55 -0800
X-Gm-Features: AZwV_Qje4rxoo7R40kPWf455fQUtzOoH5ybCxsGtQwxNUqW6waJoYKR0ZFyVEDA
Message-ID: <CAH2o1u5-VuEUJp2MNb41uxQJk=SR1uZbQkiqQWoLBj-+GXTVkw@mail.gmail.com>
Subject: Re: [PATCH v3 0/5] Convert riscv to use the generic iommu page table
To: Jason Gunthorpe <jgg@nvidia.com>
Cc: Alexandre Ghiti <alex@ghiti.fr>, Albert Ou <aou@eecs.berkeley.edu>, iommu@lists.linux.dev, 
	Joerg Roedel <joro@8bytes.org>, linux-riscv@lists.infradead.org, 
	Palmer Dabbelt <palmer@dabbelt.com>, Robin Murphy <robin.murphy@arm.com>, Will Deacon <will@kernel.org>, 
	lihangjing@bytedance.com, Xu Lu <luxu.kernel@bytedance.com>, 
	patches@lists.linux.dev, Paul Walmsley <pjw@kernel.org>, 
	Vincent Chen <vincent.chen@sifive.com>, xieyongji@bytedance.com, tjeznach@fb.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Jan 30, 2026 at 4:00=E2=80=AFPM Jason Gunthorpe <jgg@nvidia.com> wr=
ote:
>
> [ Joerg, I think we are good now, please pick it up this cycle ]
>
> This is a fairly straightforward conversion of the RISC-V iommu driver to
> use the now merged generic iommu page table code.
>
> It brings support for SVNAPOT which is a 64K contiguous page. Otherwise i=
t
> should not change the behavior.
>
> The series disables SADE as the dirty tracking support is not implemented
> in the driver and should be done somewhat differently. The generic code
> gets further along though this does not include the format implementation
> of read and clear dirty.
>
> The format implementation should be able to support the 32 bit option, bu=
t
> this does not enable the iommu implementation as there seems to be no use=
r
> today.
>
> It looks like RISCV could support the DYNAMIC_TOP option. It would requir=
e
> some additional work on the core side to interact safely with SIGN_EXTEND=
.
>
> This is on github: https://github.com/jgunthorpe/linux/commits/iommu_pt_r=
iscv
>
> v3:
>  - Rebase to v6.19-rc7
>  - Add missed line in Kconfig
> v2: https://patch.msgid.link/r/0-v2-b11ebca8abb6+c096-iommu_pt_riscv_jgg@=
nvidia.com
>  - Rebase to v6.19-rc1
>  - Fix typo in PT_FEAT_RISCV_SVNAPOT_64K
> v1: https://patch.msgid.link/r/0-v1-d3317b0ee398+50-iommu_pt_riscv_jgg@nv=
idia.com
>
> Jason Gunthorpe (5):
>   iommupt: Add the RISC-V page table format
>   iommu/riscv: Disable SADE
>   iommu/riscv: Use the generic iommu page table
>   iommu/riscv: Enable SVNAPOT support for contiguous ptes
>   iommu/riscv: Allow RISC_VIOMMU to COMPILE_TEST
>
>  drivers/iommu/generic_pt/.kunitconfig        |   1 +
>  drivers/iommu/generic_pt/Kconfig             |  11 +
>  drivers/iommu/generic_pt/fmt/Makefile        |   2 +
>  drivers/iommu/generic_pt/fmt/defs_riscv.h    |  29 ++
>  drivers/iommu/generic_pt/fmt/iommu_riscv64.c |  11 +
>  drivers/iommu/generic_pt/fmt/riscv.h         | 313 +++++++++++++++++++
>  drivers/iommu/riscv/Kconfig                  |   8 +-
>  drivers/iommu/riscv/iommu-bits.h             |   4 +-
>  drivers/iommu/riscv/iommu.c                  | 302 +++---------------
>  include/linux/generic_pt/common.h            |  16 +
>  include/linux/generic_pt/iommu.h             |  11 +
>  11 files changed, 447 insertions(+), 261 deletions(-)
>  create mode 100644 drivers/iommu/generic_pt/fmt/defs_riscv.h
>  create mode 100644 drivers/iommu/generic_pt/fmt/iommu_riscv64.c
>  create mode 100644 drivers/iommu/generic_pt/fmt/riscv.h
>
>
> base-commit: 63804fed149a6750ffd28610c5c1c98cce6bd377
> --
> 2.43.0
>

Thanks Jason for this change.

All tested, run with NVMe / NICs. No issues. Some minor performance
changes (positive or negative depending on the workload). No issues.
Open issue on QEMU RISC-V IOMMU model - SVNAPOT support is missing.
I've made a local change to fix it, and will post it soon.

Reviewed-by: Tomasz Jeznach <tjeznach@rivosinc.com>
Tested-by: Tomasz Jeznach <tjeznach@rivosinc.com>

Best,
- Tomasz
