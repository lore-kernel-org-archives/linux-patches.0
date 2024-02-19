Received: from mail-qt1-f176.google.com (mail-qt1-f176.google.com [209.85.160.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5887621345
	for <patches@lists.linux.dev>; Mon, 19 Feb 2024 08:33:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708331600; cv=none; b=LXupcC42bpr4IKW/RFyuD1saSWV7MQ1d+lwXxAzWpaGWcdgabXchx8tHWTp6mN5sFg4EPWwMGCWjz1bRqIosIOOSrV04gi9sSL/Xs5eRzvPpAlLni2y7KX67W5gGmL9uNqyFDwEYLvlKGLQSzqfXvZFzvwMU4w8RXkkzOxqraAg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708331600; c=relaxed/simple;
	bh=PqYWmo+uhcPAWZeSru8STImn2OIXJLbsDTXE/THPQLo=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=lHyuVtZ6uqHrMYQYPOA8fxGwkVITm+rtA3QRaDN9PpmTxUkW+ADEPeytNClTmChHZHfQ1foUPKivvjWVXbn8ZFC4PlFljNKL7TZdJX4FQ1Oq6tSaJdrbgG1vAEmIOFF8Qem6CZGuglWg2F+nMwxvYlKDw82o219aOUsYMx1afEU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Ogk2oyDh; arc=none smtp.client-ip=209.85.160.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Ogk2oyDh"
Received: by mail-qt1-f176.google.com with SMTP id d75a77b69052e-428405a0205so461091cf.1
        for <patches@lists.linux.dev>; Mon, 19 Feb 2024 00:33:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1708331598; x=1708936398; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=mY6qE6rDJQn9dXLUvPE17yUasRfs4Z6Ne4EoTgIyn08=;
        b=Ogk2oyDhZQm0NgW19vGsutMUJk+7FcqPoNfYOKu91oFIo76H4GoxyYWQVosf48Zx/x
         I/3y2LTJ4SN8dnYq3mPTDWYMgoDXT/GH+xyrTF9pCCO2xmzEOMZOpEGAK3Vr/M3+YY7I
         jOmNNNBcQxxbcyale2ljL6wp9PfqexzyveeOwJNjtYzDd8FiRvyKgQidsiBoF5j/Of2b
         n1+xVCSWsaRXqlvmPyWyp6Iq5JZToQIQJx6W868igp1JuxREMdREsUm/YTgIU388O96B
         dSQQNmOFEgUS7dtPmYiJJK8ITj3wyeFuCdC/ib2bIAu9+YfMC7UTTsCq02tPj8MYk9lq
         cTfg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1708331598; x=1708936398;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=mY6qE6rDJQn9dXLUvPE17yUasRfs4Z6Ne4EoTgIyn08=;
        b=RdhUc7kgIbiiMkVJo/XisQFeBPqQKZFeUAhZvdr97tJ6nnuvzW86Ogd9oLJWwywufA
         DFLoQ2zC9ZfaKIo3TPx0Q/vK4WUN1EvZA99e77KNxipHqewTCvdbm2O2Xz0sphVTNMnq
         Ua7LUbtOycyRDyJQiRSDsfUrg50CFQ1E81QOD/lGHklIAUsK8i7i7kKIFEG7cSRn7gdS
         vQ8b9h7IAqRL+XYV0BPyXZ0SotHzUR+0RKTebmZYFptRvopc2xevZcpDpj2cGuffuTL5
         mDOYKXyNbLUOGzwox/ooRElHDGPWHUAx2CcChrjmW+B9sLLGJYICKMqBRSn0ofa78jE/
         T5UQ==
X-Forwarded-Encrypted: i=1; AJvYcCXEpc3JfEry4ilbxGQA19CxqlDe4VQobZ+vX/rLr63iS27R7FbKTXXRN0lXNNuNGH8AOFF/Al8+olmGrB97IVZrjPDggb/I1Q==
X-Gm-Message-State: AOJu0YwaEbbaziXK9pqks/GWLtI0Xp+pOk7PfoTsh9hNzDQg0GseZpYT
	0d99eckVKU75hcDf2mkrdm8V+4LwCPXbgGAWcuv93tvWMgRRNSmQ1Kiitd/2J/9ZMm5ilJHM+oZ
	hUuAimQHSDtEfCZwJY+ziIyg8hqkI4r5uLE5L
X-Google-Smtp-Source: AGHT+IFr9OYPLYm7VyUZlts/EcytQFgXazQ9FLYhMfF7VHVj8GtRDg1eZZqsT9Q6V9bpSqyX0IcaE3U2Qx7c320+mC8=
X-Received: by 2002:a05:622a:5d3:b0:42d:fad2:ab34 with SMTP id
 d19-20020a05622a05d300b0042dfad2ab34mr303889qtb.28.1708331598112; Mon, 19 Feb
 2024 00:33:18 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <0-v2-7988c2682634+261-smmu_cd_atomic_jgg@nvidia.com>
 <20240216120512.GA1841@willie-the-truck> <20240216123606.GA13330@nvidia.com>
 <CAKHBV27eBnCrnXeaoqONWksh89tfX1b0=yvLfTkxviU_wKG_mw@mail.gmail.com> <20240217132446.GJ13330@nvidia.com>
In-Reply-To: <20240217132446.GJ13330@nvidia.com>
From: Michael Shavit <mshavit@google.com>
Date: Mon, 19 Feb 2024 16:32:40 +0800
Message-ID: <CAKHBV26bwkvRAeyNuiUdmh0OWmvLfS7Ja8OHabT-H9nUY=SyNg@mail.gmail.com>
Subject: Re: [PATCH rc v2] iommu/arm-smmu-v3: Do not use GFP_KERNEL under as spinlock
To: Jason Gunthorpe <jgg@nvidia.com>
Cc: Will Deacon <will@kernel.org>, iommu@lists.linux.dev, Joerg Roedel <joro@8bytes.org>, 
	linux-arm-kernel@lists.infradead.org, Robin Murphy <robin.murphy@arm.com>, 
	Dan Carpenter <dan.carpenter@linaro.org>, Nicolin Chen <nicolinc@nvidia.com>, patches@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sat, Feb 17, 2024 at 9:24=E2=80=AFPM Jason Gunthorpe <jgg@nvidia.com> wr=
ote:
>
> On Sat, Feb 17, 2024 at 08:25:36PM +0800, Michael Shavit wrote:
>
> > Calling arm_smmu_write_ctx_desc requires the CD which we get from the
> > mmu_notifiers list...which makes it a bit more complicated than
> > that.
>
> @@ -404,9 +384,15 @@ static int __arm_smmu_sva_bind(struct device *dev, s=
truct mm_struct *mm)
>                 goto err_free_bond;
>         }
>
> +       ret =3D arm_smmu_write_ctx_desc(master, pasid, bond->smmu_mn->cd)=
;
> +       if (ret)
> +               goto err_put_notifier;
> +
>
Oh hey that's not much more complicated :) . I'm guessing that'll be a
call to arm_smmu_mmu_notifier_put() rather than a goto on the error
path?
Speaking of... the arm_smmu_update_ctx_desc_devices call in
arm_smmu_mmu_notifier_put might be tricky as well if it's encountered
on the error path before all devices (in theoretical non-pci case) had
a chance to previously call arm_smmu_write_ctx_desc.
