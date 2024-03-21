Received: from mail-qt1-f179.google.com (mail-qt1-f179.google.com [209.85.160.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 66E3F8565C
	for <patches@lists.linux.dev>; Thu, 21 Mar 2024 14:58:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711033089; cv=none; b=EoX/SwiYqdVtDQaXG4MXfJfWhLWn9UmMPU6zH9FH1Bq/3QVwYhjN6ZRl9F4G8xctbw76ZZl/6PqtuzF2sAKIJmtaaWYoZ3/vQWJxHENWoufZAvK+us/fx7ldtzWeV8/x/9DWGTV6IsShRE5iQ6WKTbq1Mcl5tO8T2iZUkkK35O0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711033089; c=relaxed/simple;
	bh=agLpce2z9FwJwT33c/120zQCMrtP5RPFZ4ebii0kb1o=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=oxRZeFZwQZFlaXe8DK92vZQ3xOA/VxnQ/oNQMDYbEJhaxqFwuHJczZyWHFs26WliOrR43VgmXOxkOJB3akm73DoW3sO1JvS+u8aaVLBnaQXNAypTYtaF1RH/j8GU8jH/QwRB+nwtsAfYV1M27LrLXbna0weULU8jtHy0iOTU1NY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=DlmxvGEu; arc=none smtp.client-ip=209.85.160.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="DlmxvGEu"
Received: by mail-qt1-f179.google.com with SMTP id d75a77b69052e-428405a0205so326711cf.1
        for <patches@lists.linux.dev>; Thu, 21 Mar 2024 07:58:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1711033086; x=1711637886; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=knuU+bN3mRTrt098EHjBQeurVLZoHLcRuAXjCxz4p7k=;
        b=DlmxvGEuyeyKfkEh7sx2XwCbbZqwLjs8k647B59RHW+QxGWg/eGqU20s3TWYk2TEno
         VDqRP2rDCzVGK+vkfXYv07eTooDCBORwtIg3qbNO+oI6QpoyolKriXpP/aMM4f7+3GI5
         f0HGNNndsriCwZ8gQedbCBSPKkE/oG3T6eTVcGoLdXL6CQ8vrVOloIIjDeZYn/r5cpn3
         R96JMbkeMc0QQSFQh+jgaIXb1yo63oyLRd52//u0X6LD/b4o9Aovcx7QltaEox/dqfAC
         boS6uIpIAeV3tvHVYsuAQkU1wZ1V0h6IDYehoI/ScJO21JsgZ5seVrGaFG61B8cRZlK4
         T+Dg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1711033086; x=1711637886;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=knuU+bN3mRTrt098EHjBQeurVLZoHLcRuAXjCxz4p7k=;
        b=ugQ8g5CP9vGxeiBAaMXaOU8KUZ/UbVGqTirgv0A8CFp6Ds6o2jTf2NKU0MQbkpjDSf
         7qOvapTrWEiRHxZreAIbE58r22ZjBl/vI+LF/zvBv4/vtSZE58II4e7R0/nrACgFuBDI
         F94dbci2UDTcBUhznpCBfMs5RUpFIBhIle48rE323OpHD/ObEl2+HnUeyfg5FYvWnQOb
         txXNnIrK9qRSdEhn9HxfroTZnCmwbJkBhRdYBv2J6VvCme7tuk9S7UpfDJqyGvcjeaPs
         iAf4b/lyO0A7BX8w8lAfS0Jf5SnyM2xSVNRoeHgQlqEKkgorKhKOggEsTjP8CRUtgjos
         jf+g==
X-Forwarded-Encrypted: i=1; AJvYcCV91rdb4JCY931HUvqTyXtQSFLgjP4zETXTKWAorrhMoXSEmjb/SRonyw/9KBPGp7e1hCo3MEWuzXyISDF+mHR2UQno6PNbMA==
X-Gm-Message-State: AOJu0Yxr5NTjNBc1sKH1kgWP6lMZsaehOfsRrkKrrXbrDas1ABOpn0sc
	okhy/H7HS/wKl27cNyHfAthcrQSW/LSnslh/EyjpdiojkpvWRyRMvZ7QI7SeIbFlj1kPooDnpG5
	4whCUxFsrbHKqQ//d04pxlQrN9CVp4h6NUgvi
X-Google-Smtp-Source: AGHT+IEuGSQ+56IpfGI3PEGVPMzRSXwvw5hBeQOE2QP/AcKnXjNF3i/P93FyqtxqijSGEOt98HL0gOFIJrwhU56rtFM=
X-Received: by 2002:a05:622a:28e:b0:431:156f:b91 with SMTP id
 z14-20020a05622a028e00b00431156f0b91mr264496qtw.3.1711033085946; Thu, 21 Mar
 2024 07:58:05 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <0-v5-9a37e0c884ce+31e3-smmuv3_newapi_p2_jgg@nvidia.com>
 <14-v5-9a37e0c884ce+31e3-smmuv3_newapi_p2_jgg@nvidia.com> <CAKHBV25xx51EuDXK91-o9BnFq5TZ66TAPuZ4YEdJ1UPq8sr7ZQ@mail.gmail.com>
 <20240321132839.GK1044235@nvidia.com> <CAKHBV26dSY+Gy-x9HTWVCcNMyAkB1g+Y+dv-Lg+-furpu9bnSw@mail.gmail.com>
In-Reply-To: <CAKHBV26dSY+Gy-x9HTWVCcNMyAkB1g+Y+dv-Lg+-furpu9bnSw@mail.gmail.com>
From: Michael Shavit <mshavit@google.com>
Date: Thu, 21 Mar 2024 22:57:29 +0800
Message-ID: <CAKHBV24A7rQPg-iSj_sLOisahFj9Ek=84Ru91bU9CnLcdCkqhg@mail.gmail.com>
Subject: Re: [PATCH v5 14/27] iommu/arm-smmu-v3: Make changing domains be
 hitless for ATS
To: Jason Gunthorpe <jgg@nvidia.com>
Cc: iommu@lists.linux.dev, Joerg Roedel <joro@8bytes.org>, 
	linux-arm-kernel@lists.infradead.org, Robin Murphy <robin.murphy@arm.com>, 
	Will Deacon <will@kernel.org>, Eric Auger <eric.auger@redhat.com>, 
	Jean-Philippe Brucker <jean-philippe@linaro.org>, Moritz Fischer <mdf@kernel.org>, 
	Nicolin Chen <nicolinc@nvidia.com>, patches@lists.linux.dev, 
	Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Mar 21, 2024 at 10:53=E2=80=AFPM Michael Shavit <mshavit@google.com=
> wrote:
>
> On Thu, Mar 21, 2024 at 9:28=E2=80=AFPM Jason Gunthorpe <jgg@nvidia.com> =
wrote:
> >
> > On Thu, Mar 21, 2024 at 08:26:43PM +0800, Michael Shavit wrote:
> > > Overall I think the patch works, but it took me a while to really
> > > digest the big picture. Just to make sure I fully understand:
> > >
> > > We're trying to satisfy the following invariants for correctness:
> > > 1. Devices cannot get translations from a domain that was detached
> > > after arm_smmu_attach_dev() returns.
> >
> > Yes, regardless of ATS this is the API requirement.
> >
> > > 2. Devices cannot get cached translations from a domain after
> > > arm_smmu_atc_inv_domain() returns, regardless of whether the domain i=
s
> > > simultaneously being attached/detached from a device.
> >
> > There is no simultaneously here since the group lock is held by the
> > core code.
>
> I meant a call to arm_smmu_attach_dev concurrent with
> arm_smmu_atc_inv_domain (through tlb_flush_all).
>
> >
> > > Apart from note point 2. above, the behaviour of translations while i=
n
> > > the middle of an arm_smmu_attach_dev doesn't have well defined
> > > requirements:
> > > 1. Before this patch, devices may get translations belonging to the
> > > old domain, then aborts or identity translations, and then the new
> > > domain while arm_smmu_attach_dev() is in progress.
> >
> > Yes
> >
> > > 2. Ater this patch, devices may get an arbitrary mix of translations
> > > belonging to the old domain and the new domain while
> > > arm_smmu_attach_dev() is in progress.
> >
> > Yes, but no aborts.
> >
> > > While disabling and re-enabling ATS inside arm_smmu_attach_dev() woul=
d
> > > meet the same requirements as this patch, it's not optimal since the
> > > device may still have traffic on other pasids than the one being
> > > manipulated.
> >
> > Yes, we can't just disable ATS due to the PASIDs. A SVA PASID might be
> > present and disabling ATS to change the RID domain would completely
> > wreck it. Today this scenario is prevented by sva_enable, which is
> > removed in following patches.
>
> What do you mean by wrecking? We might slow it down to a crawl but we
> wouldn't be corrupting or destroying anything by disabling ATS while
> SVA is running would we?
> Oh does disabling ATS abort all transactions rather than making it transp=
arent?
>
> >
> > I added this note for context to the commit message:
> >
> >  This is part of the bigger picture to allow changing the RID domain wh=
ile
> >  a PASID is in use. If a SVA PASID is relying on ATS to function then
> >  changing the RID domain cannot just temporarily toggle ATS off without
> >  also wrecking the SVA PASID. The new infrastructure here is organized =
so
> >  that the PASID attach/detach flows will make use of it as well in
> >  following patches.

Huh ok yeah, I thought this was just enabling/disabling caching of
translations in the ATC but looks like it's disabling translation for
those PCIe devices.
