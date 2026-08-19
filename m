Received: from mail-pg1-f199.google.com (mail-pg1-f199.google.com [209.85.215.199])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C1E3821CC5C
	for <patches@lists.linux.dev>; Wed, 19 Aug 2026 16:28:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.199
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787156914; cv=none; b=lkhVPP3VJkGD17A9wynOSUyCvSCGiu/sL5aYvRyPu0wV5oaTVsSm1RdzfCaD6TJNSECxppGBpEPk1fPIDF4YAAiqvVc4aToh2jRPRhSnW8lXijRsY66l+ND8VZmK7Vsg1EFuXUiqCvpxHBFrgeh0wkbQ2JcqDRmRPKwI2Yn2Y2c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787156914; c=relaxed/simple;
	bh=gzfJs5HYntu8gcGCJ6sAjebyKzMhabA2OudsbWoFFYw=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=MO+5QFIZ6IlksUJ+Cc0nN+ZDWIJfA73vbrReD/8ZAAIKLdMDqSYXTka+LN3Kh9+9oZxDrKju6upPvCZjrFe5cYf7ZUrnEufIMgq7429ME26LSqsOjBCDr/kXFkUhNvJhpny207Kk0nMHCM4wsFF/+gmo/M5Ge6FODmXgT6ysME0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=tTFJ6e4N; arc=none smtp.client-ip=209.85.215.199
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="tTFJ6e4N"
Received: by mail-pg1-f199.google.com with SMTP id 41be03b00d2f7-c89704da8c7so1549728a12.0
        for <patches@lists.linux.dev>; Wed, 19 Aug 2026 09:28:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1787156905; x=1787761705; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:cc:to:from:subject
         :message-id:references:mime-version:in-reply-to:date:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=+B8j39F6K6IPnckNY9ZHScQQlOhyC0PWjU+Co8ybQzs=;
        b=tTFJ6e4N1sh8YeOVY1DLSFCQoTIooMSrh3g5pg4OYjmPQfEc1ZfThar/ha/LQFZcz8
         C+NzhAei2vFbG60khPCS8jKBXpJGHj+gPIyLDwDL33VP+IUzlDhS9MwAIOTi/ohPK3Qm
         jUii8bsNT9U8cSEdOVILsyrohMWksg/4zQX6W7uaqK2iTEK4RmRoWKioCPAaYdRnWhmu
         7FNCnYk6YnsFFKxElCW8kJF9poM/l/qGcafIZBdnALa6uh95Zjya1/LT3vql2W25mS4Q
         56tx027qWwbR2sNn4db9RFgzzDQTfgZeiRx4ojwJQuPKAedj8C5BVcTp2ysE2vODBNDh
         KFqQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787156905; x=1787761705;
        h=content-transfer-encoding:content-type:cc:to:from:subject
         :message-id:references:mime-version:in-reply-to:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=+B8j39F6K6IPnckNY9ZHScQQlOhyC0PWjU+Co8ybQzs=;
        b=MOU4R1SyHJ83OfRPYVSxdHrk+cpL2+cpm2PdaD4XNo2+Dc/7E5QSr5V3UM0LeSaapx
         NU11dtNMNr45QrP1GUut0c5u9npnwKqx5A/n4Tp+2EcWxyRGwnPuh4X8i6YWruPBO2ZD
         eaNDMXMcLWZ9nARyVAQTrzXWQykD24/C5NyI1u/dNbIjjFO9S12gftjHa+X7S2bCX84m
         SP3LrJlzYkNsWsfukW6eR5wNT23SBo+s5Nrl1tjkZcRllB9frOA2b2kpPbcora7kcxmf
         yuq9uCAz/9GXXdsaxfp2EMGdsJt3sayzFnn8NQkyDYzBlds7TJ9D31ncY5pJ89wxxEoQ
         0DdA==
X-Forwarded-Encrypted: i=1; AHgh+RoJK8ARQubs48plVsFXsXjtGoWCH8tc5l6J9jwBxFh3LOYdwa+2T1r29TLB9CJ2IVIkivu/cFq+@lists.linux.dev
X-Gm-Message-State: AOJu0Yyqs5aIk+fPHkRVyy5uMXq4DEU88GH5OVbJM8pfzymC9UIkXBLO
	uHSncZzEyRfMJCEzL+ybGrTOX5jk3OjtL7vsA7Qi5RBas76WKCQlpIviXizoSUS6cooMTca4TOA
	fJ3N0nQ==
X-Received: from pgar15.prod.google.com ([2002:a05:6a02:2e8f:b0:c99:aff5:707b])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a20:12c7:b0:3c3:cc3e:a9
 with SMTP id adf61e73a8af0-3cd00dd6be8mr9394127637.4.1787156904767; Wed, 19
 Aug 2026 09:28:24 -0700 (PDT)
Date: Wed, 19 Aug 2026 09:28:18 -0700
In-Reply-To: <CAMGffEmqrrFN6O2oqtAZC3iTD5UJrhVK80bmJLkof28C=uAfvQ@mail.gmail.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20260817132535.394764707@linuxfoundation.org> <20260817132539.879554007@linuxfoundation.org>
 <521b22fa-ef09-4449-909f-0120edfc4b24@oracle.com> <CAMGffEmqrrFN6O2oqtAZC3iTD5UJrhVK80bmJLkof28C=uAfvQ@mail.gmail.com>
Message-ID: <aoXZohqTkyXQmteX@google.com>
Subject: Re: [PATCH 6.12 111/181] KVM: SVM: Add support to initialize SEV/SNP
 functionality in KVM
From: Sean Christopherson <seanjc@google.com>
To: Jinpu Wang <jinpu.wang@cloud.ionos.com>
Cc: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>, 
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org, 
	patches@lists.linux.dev, Tom Lendacky <thomas.lendacky@amd.com>, 
	Ashish Kalra <ashish.kalra@amd.com>, Herbert Xu <herbert@gondor.apana.org.au>, 
	liam.merwick@oracle.com, Sasha Levin <sashal@kernel.org>, vegard.nossum@oracle.com
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Aug 19, 2026, Jinpu Wang wrote:
> Hi Harshit,
>=20
> On Wed, Aug 19, 2026 at 9:12=E2=80=AFAM Harshit Mogalapalli
> <harshit.m.mogalapalli@oracle.com> wrote:

...

> > > diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
> > > index 6cec696461da2..bd0344bacaf1e 100644
> > > --- a/arch/x86/kvm/svm/sev.c
> > > +++ b/arch/x86/kvm/svm/sev.c
> > > @@ -2972,6 +2972,7 @@ void __init sev_set_cpu_caps(void)
> > >   void __init sev_hardware_setup(void)
> > >   {
> > >       unsigned int eax, ebx, ecx, edx, sev_asid_count, sev_es_asid_co=
unt;
> > > +     struct sev_platform_init_args init_args =3D {0};
> > >       bool sev_snp_supported =3D false;
> > >       bool sev_es_supported =3D false;
> > >       bool sev_supported =3D false;
> > > @@ -3088,6 +3089,15 @@ void __init sev_hardware_setup(void)
> > >       sev_supported_vmsa_features =3D 0;
> > >       if (sev_es_debug_swap_enabled)
> > >               sev_supported_vmsa_features |=3D SVM_SEV_FEAT_DEBUG_SWA=
P;
> > > +
> > > +     if (!sev_enabled)
> > > +             return;
> > > +
> > > +     /*
> > > +      * Do both SNP and SEV initialization at KVM module load.
> > > +      */
> > > +     init_args.probe =3D true;
> > > +     sev_platform_init(&init_args);
> > >   }

...

> That looks like the case, we only use kvm as module, didn't hit the issue=
.
> > The relevant upstream commits are:
> >
> > 435b344a7042 ("crypto: ccp: Add external API interface for PSP module
> > initialization")
> > 44e70718df4f ("KVM: SVM: Ensure PSP module is initialized if KVM module
> > is built-in")
> > 409f45387c93 ("x86/sev: Fix broken SNP support with KVM module built-in=
")
> >
> >
> > https://lore.kernel.org/stable/cover.1739226950.git.ashish.kalra@amd.co=
m/
> >
> >
> > Could the KVM maintainers confirm whether 6.12.y needs this full series=
?

Yes, we should also backport the above fixes to 6.12.y.

> > Probably could be done after this cycle, but still noting it here.

Yes, sadly this patch is needed to make SNP usable for *any* configuration,=
 due
to bb1c84647025 ("crypto: ccp - Move SEV/SNP Platform initialization to KVM=
")
already being in 6.12.
