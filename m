Received: from mail-qt1-f175.google.com (mail-qt1-f175.google.com [209.85.160.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F15FB81722
	for <patches@lists.linux.dev>; Wed, 21 Feb 2024 16:19:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708532387; cv=none; b=lazLRNttlH5UsEKPC4eKII7nU9/meFrIrK9hvLIDBqOYswPTMmGm+AwJA82XPnMHNNJ7eZ568ivvKbcp1Xktb93C1FMYdQV6VrbaJfGc/uQCBVAMcGjBD/iTRObX16KhhVJcyzfVVWrgkhWTHYis+A5w4xsZm+EVhHUjWj5X8VY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708532387; c=relaxed/simple;
	bh=FBLyFoFFU5YRVyvvqlDTfMPWl9CsnVhbrvNf42AaM1k=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=YgXkBuWRA3LOZv3E9ksReSq2oV//UQpDLzYgB95pvC3uqoLpyzKIUSzpWpUS6LbiiohyKFyd7dhng7VVTp+OVF8vzCSJweE2xpzdvCphubgVlbN3p4T/DuNi7sidOI0VL1eLkRWTxip3PY28BtwQyXtXmTCiizULkjvl/MdBD+w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=LegVtSo9; arc=none smtp.client-ip=209.85.160.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="LegVtSo9"
Received: by mail-qt1-f175.google.com with SMTP id d75a77b69052e-42e2507c6e1so265941cf.1
        for <patches@lists.linux.dev>; Wed, 21 Feb 2024 08:19:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1708532385; x=1709137185; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=arl0fzz6TB+mDBQSxtnFgvSHghA7NLawqyNW3EPWxH8=;
        b=LegVtSo9PMWkIxHCW5pzGehkvSKgyZWxLCmQddZmuQVyK8/Csf99pnNl48UztOl6Vo
         a8AwZ/ELRwif+JBc9hIlT977TyCeCdUFSlKcXRHeoYuuVYTtLz1ZB9nyQl9bnmFGosTb
         5VpGPOTSOmmS2CUiYVK6Kz3bXk5295rmt1K6QnkgaTSqrAAeJhzkUl9E+zHZUYgjkvsn
         +JLpFR4zPy6lrUmoRqNmfq1iFDdbwhdgNDR/wCgLHPZvccifaiOtqjqxr0wppQ+EuJZr
         dBKn1U+oKlNQCKrBewSg9vN8H1ZhfZHG3FSV/9zLyqLGshZrkxHI8OT0ihUaj9VN4whN
         kbWQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1708532385; x=1709137185;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=arl0fzz6TB+mDBQSxtnFgvSHghA7NLawqyNW3EPWxH8=;
        b=dB5b3OmmS5q2wfTzjyQCDmSJpOPmrcFLm1KAG8MVhAeAbPuTX70H+Es49VHPy6Bp7r
         V3hUrggTv78/0CZ+uu1tdckDxagd8ckCiHoHSVecXCbthJJ1PRwH8JiRPMmNIMxfOG2U
         rNLhcC58+cm0naFFtCPsGoLedoQcW4Pfx60+jNvG8ZwQIJ6ZgHMYa1AhKdsZpsEN5XZy
         hozAch7gs/sS9jDdpVbrTLFAMLpNQCd1BeQLJpY6Ap+Gl9HqQHC7hu6OehuRXCukONg/
         CxI2Un4n76+ko6Bp4nZ2WLQLBDvElC8NCf3MXhQzfPCT2hpc6bCiTWBF3d8Y+xwMudY1
         BI+Q==
X-Forwarded-Encrypted: i=1; AJvYcCUo1LcKzQZL91IDKrCXBThgDBwjFra7DSHeWOVwa32cgtTSO4QOXaq2PaOdRk2hI0pRsH+EgOiCUBVXjqpY64DGlnMpSikJVw==
X-Gm-Message-State: AOJu0Yys1Svd3UgL6yexDvyb6lob1Ezs5b0sB8TdQ+k+4XpHOml3qcH8
	TnVLZHTytSYJgsr1Pzlpxsg/foHSdwPLcNicPt+sWj0oRCDKgm5SbEkGC+3W3TUkPlY7bkLHvuw
	fr3LTrS4k/0jNnTL2jgu1tFCQAuRI8XQeMey5
X-Google-Smtp-Source: AGHT+IF03ue/kQYI6nVauk5Jp7DIfLX2vYATuegN40BS0XIc1RYCwm0is6FHiEkKbzM/qEsPgc3paZNUnWnnlogXlpU=
X-Received: by 2002:ac8:4907:0:b0:42e:660:eb8d with SMTP id
 e7-20020ac84907000000b0042e0660eb8dmr209224qtq.5.1708532384638; Wed, 21 Feb
 2024 08:19:44 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <0-v5-cd1be8dd9c71+3fa-smmuv3_newapi_p1_jgg@nvidia.com>
 <1-v5-cd1be8dd9c71+3fa-smmuv3_newapi_p1_jgg@nvidia.com> <20240215134952.GA690@willie-the-truck>
 <20240215160135.GL1088888@nvidia.com> <20240221134923.GA7362@willie-the-truck>
 <20240221140818.GA2635804@nvidia.com>
In-Reply-To: <20240221140818.GA2635804@nvidia.com>
From: Michael Shavit <mshavit@google.com>
Date: Thu, 22 Feb 2024 00:19:06 +0800
Message-ID: <CAKHBV25XrwOXyrYkjLZ7=5sNoFsM8VPS=HaJupswu6QDZ02LcQ@mail.gmail.com>
Subject: Re: [PATCH v5 01/17] iommu/arm-smmu-v3: Make STE programming
 independent of the callers
To: Jason Gunthorpe <jgg@nvidia.com>
Cc: Will Deacon <will@kernel.org>, iommu@lists.linux.dev, Joerg Roedel <joro@8bytes.org>, 
	linux-arm-kernel@lists.infradead.org, Robin Murphy <robin.murphy@arm.com>, 
	Lu Baolu <baolu.lu@linux.intel.com>, Jean-Philippe Brucker <jean-philippe@linaro.org>, 
	Joerg Roedel <jroedel@suse.de>, Moritz Fischer <mdf@kernel.org>, Moritz Fischer <moritzf@google.com>, 
	Nicolin Chen <nicolinc@nvidia.com>, patches@lists.linux.dev, 
	Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>, Mostafa Saleh <smostafa@google.com>, 
	Zhangfei Gao <zhangfei.gao@linaro.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Feb 21, 2024 at 10:08=E2=80=AFPM Jason Gunthorpe <jgg@nvidia.com> w=
rote:
>
> On Wed, Feb 21, 2024 at 01:49:23PM +0000, Will Deacon wrote:
>
> > Very roughly, yes, although I'd go further and just return a bitmap of
> > used qwords instead of tracking these bits. Basically, we could have so=
me
> > #defines saying which qwords are used by which configs,
>
> I don't think this will work well for CD's EPD0 case..
>
> static void arm_smmu_get_cd_used(const __le64 *ent, __le64 *used_bits)
> {
>         used_bits[0] =3D cpu_to_le64(CTXDESC_CD_0_V);
>         if (!(ent[0] & cpu_to_le64(CTXDESC_CD_0_V)))
>                 return;
>         memset(used_bits, 0xFF, sizeof(struct arm_smmu_cd));
>
>         /* EPD0 means T0SZ/TG0/IR0/OR0/SH0/TTB0 are IGNORED */
>         if (ent[0] & cpu_to_le64(CTXDESC_CD_0_TCR_EPD0)) {
>                 used_bits[0] &=3D ~cpu_to_le64(
>                         CTXDESC_CD_0_TCR_T0SZ | CTXDESC_CD_0_TCR_TG0 |
>                         CTXDESC_CD_0_TCR_IRGN0 | CTXDESC_CD_0_TCR_ORGN0 |
>                         CTXDESC_CD_0_TCR_SH0);
>                 used_bits[1] &=3D ~cpu_to_le64(CTXDESC_CD_1_TTB0_MASK);
>         }
> }
>
> > and then we can
> > simplify the algorithm while retaining the ability to reject updates
> > to qwords which we're not expecting.
>
> It is not much simplification. arm_smmu_entry_qword_diff() gets a bit
> shorter (not that it is complex anyhow) and other stuff gets worse.

I think the simplification here is in the first if branch of
arm_smmu_write_ste. With Will's proposal, we only perform a hitless
update if there's a single used qword that needs updating. There's no
longer a case where we first set unused bits in qwords whose other
bits are in use. I'd argue that setting unused bits of a q word was
very clever and removing the logic does conceptually simplify things,
although yes it's not much fewer lines of code. I also don't think
this throws away the entire logic of the current design, the idea of
counting the number of qwords that differ and writing qwords that are
unused first is still there.

But, it does mean that hitless updates are only possible under
narrower circumstances...We now have to figure out if there are
transitions where this is problematic where we could previously assume
that we'd always get the best behavior possible. Both in the present
(i.e this SHCFG discussion and EPD0 case) and in the future if new
parts of the configs start getting used. IMO not having to think about
this is a meaningful advantage of the current solution.

> > > We'd have to really start doing really hacky things like remove the
> > > SHCFG as a used field entirely - but I think if you do that you break
> > > the entire logic of the design and also go backwards to having
> > > programming that only works if STEs are constructed in certain ways.
> >
> > I would actually like to remove SHCFG as a used field. If the encoding
> > was less whacky (i.e. if 0b00 always meant "use incoming"), then it wou=
ld
> > be easy, but it shouldn't be too hard to work around that.
>

What do you mean by removing SHCFG as a used field? Are we changing
the driver so that it only ever sets SHCFG to a single possible value?
Or are we talking about fudging things and pretending it's not used
when it is and might have different values?
