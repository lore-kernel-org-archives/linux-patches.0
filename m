Received: from mail-ot1-f42.google.com (mail-ot1-f42.google.com [209.85.210.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 814F347DD69
	for <patches@lists.linux.dev>; Tue,  5 May 2026 16:32:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.210.42
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777998730; cv=pass; b=Zu/f8avu/JHnjxNoSr3IQJWkmcs7hw1nL9ZobuGY7UQzDq8xJWmXE9fdOGYboGfdl6c76wF4Dq3p8nz06hh7uOb/tIegI0x0q+KvsweJ+98U2/TH/7/UxctOS4jSq0iSVQoQ4yPsNOxoDF/GU77KMh5tvIkkeCm6qZYm9b6LOIA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777998730; c=relaxed/simple;
	bh=iy3n3rJ21iXxzxWQtymxZU8jDcKP80ZeTnptO0tAl6Q=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=M4jtMT7iuNC7Gk2nxLzcJSKM3jP0Xr+Od+vRHXphwU09mcyAKDx7MCHkAXvIMq1+ynID2s6reMrfTrivTmRn4DrFo6G5D9SuyhAEuNDkNtWYImX0Qp9NnR3Pv/cIVyZRJf+9DYmrm29klSjrflRoPTNdJXIcnwsGi4ZZzLDkhH8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=rivosinc.com; spf=pass smtp.mailfrom=rivosinc.com; dkim=pass (2048-bit key) header.d=rivosinc.com header.i=@rivosinc.com header.b=LsQg+x6b; arc=pass smtp.client-ip=209.85.210.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=rivosinc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=rivosinc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=rivosinc.com header.i=@rivosinc.com header.b="LsQg+x6b"
Received: by mail-ot1-f42.google.com with SMTP id 46e09a7af769-7dcd17e19b6so3216761a34.1
        for <patches@lists.linux.dev>; Tue, 05 May 2026 09:32:08 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1777998727; cv=none;
        d=google.com; s=arc-20240605;
        b=E2OuZXxT8J5jWNN7VBqlFVwrWgWhnqrzLjCXgleJTsVLj1Br5aP2g8IFWJYcj587sm
         qtMEy8w+dWP2CSKqr5I2FXDcH8sLGZQZIb+TVazRxNEbwEKNcgfRHoIbZvm63SEP0RT+
         D3XPdlbSTP2/F65APhjanCCOXTlSrW8s5wIj40CvXZq701irtt/iVBIZ9f+tlQpTDXEt
         HOcVbXrXWpwNnsNI+qmS3Fa2C1l6mQZ4KMobSlDRpLk8kORdAXLfrm9WyOkVL1hAGXXF
         e1odZloZjt67OWwF5YE4WcpNIs/9W8OZEAcQrL7jP4uSH7RZt9BpUbWPDWCYJPG9YR63
         4HEg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=7eXEy6+DCrmMWFnLDZ4Fw27+W46tPenXbPYSAHMIGQY=;
        fh=1UGvC+cNjr+MH9RBDnB7K7Gl91bhT0Z0uOvEOpBWnnU=;
        b=CTpt2mjVs2jJJS6dnq8nxLNWbc+RU/cSBJtKF5XLHfEqZM2ytUv/qEqRqyWJqXpCKU
         VXFPkAULXkCT6M+23iE9DFp4s+vU1KlkHGvQkb+8K2VRLW27dMW/5L3Ui9ckcQbqoMtY
         we215LWVWgjtj2HW1mTDN58ZRAXvOuuIL+DBqMSLvlQEw+dPN84oosDzoNX189aFwF7/
         j3xyfQaOn7sGRG9e/+G+61g9I0gOjV3nFnx8RZcO7RM7jGVShDT9zIH7WDVcwPT3womi
         s2bJXgShf9H03sXgi/Do4tgJh24hmzJGQz0ya9ykT8zf5wj7JbOxB3higfFd1YN1LDqx
         wqsA==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc.com; s=google; t=1777998727; x=1778603527; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=7eXEy6+DCrmMWFnLDZ4Fw27+W46tPenXbPYSAHMIGQY=;
        b=LsQg+x6b3df6CazlYBQ+7iDgkS+QGarHroxhm0hg20l/bn+N/A+VRptXS+RHTHKCFd
         8/gO61iYzzJ9qC0jymwnWq32YxGyGHr5DiIHGNcBgV4yHgFBjRSqFXcTJdJeYzmVO6C7
         Sai49EORiZZHoeM/6Omx+yU+o8Q2I+YYLsQcYkf7/Z8b5WxhVUlHFXOZKuZ6CDgnGZ2R
         0+7WMHqZrCqMwQA+2YRf2VVqfXrN7ktEaDbD+XKv6USoQzYToCeV+EMwJak6Ym7H9wvb
         m4ShUkb3bFjbVXaeBI9LTMEeejh2A42ik5Ll80LkYxPjpvZxfkQj9mufkc+trUKoP37O
         OamQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777998727; x=1778603527;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=7eXEy6+DCrmMWFnLDZ4Fw27+W46tPenXbPYSAHMIGQY=;
        b=h4hQ3pvLXo+T4sov7Ec+T7aoc+z3sPc7yf3FSJ5zfJD75i6tNF0h3kppKwMohTMFcn
         +N+QupGNpeMHvTFnqPjqLyZhzhqfTfy6CaGYjLfLr1En1TCgJyx3yiRdkoFPuIOiXfPf
         /tVJR6PjaOjnxQUgaVEC8hbi3oDfXiWxTdeDYmdLKUwGtPiWxrKeLlcvXNdk8MW0azsg
         DikxUHtSLvob/+/EOWMSamrooMevzQLGk6mRJcL+/1ZRbAXrWyamQAbgg57kkYLJB8Bk
         boNMrTi2gOG3FWpfXPjppBq9XisSpki3+inXtWCf7W7V3IfnlgsWVvkOCB8Dmmmsar+y
         1u4w==
X-Forwarded-Encrypted: i=1; AFNElJ+FH2mz9Ea5UZV2XOvRj8fpbTr+41kZGhrm3MZfgPVUnEnJ4vv5D4ne2Gujw0icC773mDrolGeO@lists.linux.dev
X-Gm-Message-State: AOJu0Yz9+lppvxrAfFGod6chlAl8YN1xcOWHR3oQIhRsjFvm006i9Og/
	YwnQraenVEx4PLq1AwF6zUjc9/hSW6gQphMiVTYIf66ebC8ry+aduFHz8VpIjq4qn6zWSJMgIZI
	LJ9GmUdeLj7AisiPWe85Y8i0VVMjGDfaG26s7+RKnLQ==
X-Gm-Gg: AeBDiev7BN3jSbitIx10mdpRrRFftZ5PFZkJCsIxXkrwIXQOmMl0WICp36FFR6wOKxH
	z5/i3NJw6kuIR5KvV5WReBA2h5aFMstf7xgn+6Pb0+Jg+2ysHc1DjED9HZe3U/zxzwJAbZNik+V
	aVQN6kOBFrWUMvDliN1Bh0Ggu9pEQaHPCY1MXmO3Icsj6ZORVSASBB1jYzhySVCbCCS/wbCXMjL
	QEO201Mnsade7VbXybBpBp9Qjs9z9cTXmKR2q04B44vss3jkmapAcfXbYhSEV0l4b3RkEcdbgtW
	21yepj/Ark+je3Wk15hHo7sZe6l+
X-Received: by 2002:a05:6808:2518:b0:479:ffcf:52dc with SMTP id
 5614622812f47-47c8930caadmr7143176b6e.44.1777998727293; Tue, 05 May 2026
 09:32:07 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <0-v1-54e7264d71b4+17cc3-iommu_riscv_inv_jgg@nvidia.com>
In-Reply-To: <0-v1-54e7264d71b4+17cc3-iommu_riscv_inv_jgg@nvidia.com>
From: Tomasz Jeznach <tjeznach@rivosinc.com>
Date: Tue, 5 May 2026 09:31:55 -0700
X-Gm-Features: AVHnY4KXzwjaC_Gb5GnddRMzX9LqC580rYOWyeA1_Y7wcl4kfXs2AQTViUP1SDo
Message-ID: <CAH2o1u699nbGABw1mcZR=BrZcyy7s_WNz-szpe8bn8bPhuv-yQ@mail.gmail.com>
Subject: Re: [PATCH 0/7] Support non-leaf and range invalidation features in RISC-V
To: Jason Gunthorpe <jgg@nvidia.com>
Cc: Alexandre Ghiti <alex@ghiti.fr>, Albert Ou <aou@eecs.berkeley.edu>, iommu@lists.linux.dev, 
	Joerg Roedel <joro@8bytes.org>, linux-riscv@lists.infradead.org, 
	Palmer Dabbelt <palmer@dabbelt.com>, Paul Walmsley <pjw@kernel.org>, Robin Murphy <robin.murphy@arm.com>, 
	Will Deacon <will@kernel.org>, Fangyu Yu <fangyu.yu@linux.alibaba.com>, patches@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Thanks Jason for this series.
I've verified github/iommu_pt_arm64 on RISC-V, looks good.

- Tomasz

On Fri, Apr 10, 2026 at 8:57=E2=80=AFAM Jason Gunthorpe <jgg@nvidia.com> wr=
ote:
>
> This is part of the patch pile to get SMMUv3 moved to iommupt. From
> that perspective it introduces the PT_FEAT_DETAILED_GATHER which will
> be used by both RISC-V and SMMUv3 to generate optimized invalidation
> commands.
>
> I don't have any RISC-V anything so this needs to be tested by someone wh=
o
> does.
>
> Improve the invalidation flow in RISC-V:
>  - For single address invalidation, compute a stride based on what
>    IOPTEs were changed by having the gather track level changes in
>    bitmaps. This allows things like unmapping hugetlb-backed mappings
>    to avoid jumping to global invalidation.
>
>  - Support the NL bit to avoid global invalidation when table
>    structure is changed
>
>  - Support the S range invalidation feature to convert any gather
>    into a single invalidation command using an aligned power-of-2
>    size like AMD and VT-d.
>
> This is also a requirement for the kunit iotlb series, which was used
> to test the math used to generate the invalidation commands from the
> gather in this series.
>
> It replaces a similar series Fangyu sent prior to the iommupt
> conversion:
>
> https://lore.kernel.org/linux-iommu/20260208144213.94856-1-fangyu.yu@linu=
x.alibaba.com/
>
> The full patch pile is here:
>
> https://github.com/jgunthorpe/linux/commits/iommu_pt_arm64/
>
> Jason Gunthorpe (7):
>   iommu: Split the kdoc comment for struct iommu_iotlb_gather
>   iommupt: Add struct iommupt_pending_gather
>   iommupt: Add PT_FEAT_DETAILED_GATHER
>   iommu/riscv: Enable PT_FEAT_DETAILED_GATHER and pass gather to
>     iotlb_inval
>   iommu/riscv: Compute best stride for single invalidation
>   iommu/riscv: Add RISCV_IOMMU_CAPABILITIES_NL
>   iommu/riscv: Add NAPOT range invalidation support
>
>  drivers/iommu/generic_pt/fmt/iommu_riscv64.c |   4 +-
>  drivers/iommu/generic_pt/iommu_pt.h          |  98 ++++++++----
>  drivers/iommu/riscv/iommu-bits.h             |  24 +++
>  drivers/iommu/riscv/iommu.c                  | 160 ++++++++++++++-----
>  include/linux/generic_pt/common.h            |   5 +
>  include/linux/iommu.h                        |  42 ++++-
>  6 files changed, 259 insertions(+), 74 deletions(-)
>
>
> base-commit: ac81c0f2e6a779e444c5b6fd43756ef811656098
> --
> 2.43.0
>
