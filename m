Received: from mail-ej1-f49.google.com (mail-ej1-f49.google.com [209.85.218.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A38352D593E
	for <patches@lists.linux.dev>; Wed, 19 Aug 2026 08:59:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.218.49
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787129955; cv=pass; b=IQK++dxBVEQzpwTs6E9N5vb+8hS9J6z6KOkOkVLM6Q0R65LZrnud9fR4jQOCUbBtWabj1Dt14yEDuIUHMWtYlB1LHTGB1ybUghVc4fqu2I5WZRs+67engtpYjD2BSWCk5d51r6ZKeclwhsufeAtqcDg/2rt/rSlD093EYccVNUI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787129955; c=relaxed/simple;
	bh=POU4QgGjlkB1m401znQIYU3NrwHbaXA8RwN9Ac5rsHY=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=u6xG4MRJespizz86sH6tsj9465qNYYJAxQ1oJ25Q9ud7yEe2IzfUuwInsXwspV3VJ+mRnNPqA6nlfw7N/KwXdNWNX5W6eaxdyXa85/1r/y0XESrwJnLHO89DVoGwp8Q1HBCVAKlv8nz/kjC4j7ZXtvMsAnzX0LHQ9EcWVL9MlJY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=cloud.ionos.com; spf=pass smtp.mailfrom=ionos.com; dkim=pass (2048-bit key) header.d=cloud.ionos.com header.i=@cloud.ionos.com header.b=fsW8eHBo; arc=pass smtp.client-ip=209.85.218.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=cloud.ionos.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ionos.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=cloud.ionos.com header.i=@cloud.ionos.com header.b="fsW8eHBo"
Received: by mail-ej1-f49.google.com with SMTP id a640c23a62f3a-c15b51ba80dso8531466b.2
        for <patches@lists.linux.dev>; Wed, 19 Aug 2026 01:59:11 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1787129950; cv=none;
        d=google.com; s=arc-20260327;
        b=O4O3OMm2Hde68B7mRzTLytKj2wEVfwmMYYgdJrxRki6/YlsmM/v/fPJvT/lvkJKsux
         WkFwVI9EwizS75JaOaKy+QfMgpROVDOEl8z8Jcfty/pDw8b7g8B345lxRsgCIVCuB0Ob
         pv/eeo9ZDTSuy8U4fQOKDA6D5FssqcPPJo9fpApyPVHWQW/qj0awJdtrIeKYoZ58IJra
         yZTUN1zmi0bKOmYyF/Kia0sgDGZiuS5N4euxG97Wt5bdPFnrgpz5x0wdwir5YY+VqbaG
         oPSYJyT0kLhhzFNGztMTDO/UoReKtQgo4pB6gRfAIYXLFY/i32Cz+LigLc2tWbx8lxwn
         0ayA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=v6LqpiNyutcjnM2YuW2WgPqXG0K1W5YBbJLrp6yBCYY=;
        fh=Wyds7R7msVaBZHajMPNr0++S6TXhivPdsaNlOI9k6m0=;
        b=cJFFhahalHKIjst9U4pph58SFijs67/qhLoXz/B1fMRw3Jr6QAZ9rIHpxLOGrXvogx
         ha6cDZSSJUMO7gu6/jFMWJH0m231fTc7+GkDm6sBiWQJ7N+Oyk0y6aDGS3t3efggr6ur
         VSTYKYLY1VmJ7GyZOeOjybG1e7W1ia411C3X07jXxWbnbCErudXViZdwpFGwSMCJfn86
         1ZePlhzhwUuJ9vKODTq4GSTz1osaO0nrtFpJORETtCMA42lKZBk90ppq+hy7Ew7TtRlZ
         MnvwSVUSYPRfbDSmFATujlGbaukl4uAO6eYNT4TOPmsROmXdfNqpI8H5E2i24z2yoA8E
         efXA==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloud.ionos.com; s=google; t=1787129950; x=1787734750; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=v6LqpiNyutcjnM2YuW2WgPqXG0K1W5YBbJLrp6yBCYY=;
        b=fsW8eHBo/l1e5/TZkmaaOWtZcJS6hl6ZtGo2j4p0Uhr+pL01LyiZY0l3Kp8C8x+ZNj
         oV8y6547mR1vVy87HHR2hgRbAF+CTX3Day5KeaLYKHyGqHHCo/hZGfQ0mLkTiTx9J6sW
         +I2k0d6FpL13NOeRo3RjHIWz9W6HjSeSUANIxsTBj2AlKNAHvNiIM8SPsY0Y3sif050I
         XgnJnKqO/NgqqkN4DvH31LOOGxQBLi/rueiBfGOzJ5K1sGfv4n2seVT8aK6O4d52oK86
         b0MfLS7d09d88f3KsKZtB81QoL0a3Nh8J7BJVr1oXAGjYujN7wjTsU4K8kZ5DT4dBK5L
         A1Qg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787129950; x=1787734750;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=v6LqpiNyutcjnM2YuW2WgPqXG0K1W5YBbJLrp6yBCYY=;
        b=gdvqSDUHk5FMbd+LkqxdPkzzoVBR6pUCrRBGSRzdCiKQFVxSf+Bw2a9qLESJC9fok1
         eYTw2ocawB67/cohErD9yB8q0NK3BIzZqKztP09m1yHDISELTW8zhmXEDwC2wVMe/CKn
         UiKM5LGSrPrCB92ymahvnRFT3hDTSYRu2/S7JAThHNuNNy647JyLbHqCtOfGW5oDdLVg
         Yj1i2qde3Eng/MSx8JpW5Lcv10CXEtw/QSPS55akFBBoS5s9B5bcWkCVEHaM3KY9x2fI
         F+IeiSDi4+ihKFEBjediIsGIQdSxCZQLZMxFUKXQOSiZH6zOqPGMeXqVQBWa64/WzwzA
         WZpQ==
X-Forwarded-Encrypted: i=1; AHgh+RqIb2cvJ3c1v9bf7ykvh8n3El5y6lF770iftThP+5Zf7dqEwBfkT5PJiKdIL/iQ0LaPDbOKnviF@lists.linux.dev
X-Gm-Message-State: AOJu0YzakxWLyHfHHgUI9h5hGTTM7QEZooyXkfiT7oEKNhBp68yCDJaT
	m8JPmftsKh5KOhVsnUGqBnqXkiRytimOfQctlF89P6kb/Hg3fPECqXjYihJMZVfmyuXZQHnShZP
	tVR6R8ZKZ8w6jihUencnpKNWvexhCvRBQfSw9hh/kwg==
X-Gm-Gg: AR+sD12EPhiQnKW+8pZz8sIZ4meoQZa0fXPjHHKOYkFxwuxYV0rUI3PTAEkAgTF4SG9
	VliDDk5n+b3PRZ/QwpD2KCVHwYVGQz/WLWVnFTe7JvDnYhV+02a1DqA6XSe+aEHmNIKaQ4fLPfp
	P3czaJvQYo/dczZ/9e8njyTDzeemylI2fUzyYBXAZmAdCEOh4z6UbG56g/w65BufV9NvL43VXEA
	CoL6zrNNXrPNlvpWIp/wZ7L4HMTGzsd7Z8NEEDIWWFiECs7wXe4CMtXousns9VEPCfDbhx5FWYD
	DxBI7/kxKGBnrg4rS7VpBUWJ0RQaP+SUFpMdo7wXnaMh
X-Received: by 2002:a17:907:960b:b0:c20:c5f4:e19f with SMTP id
 a640c23a62f3a-c242e36cb2dmr96307066b.4.1787129949839; Wed, 19 Aug 2026
 01:59:09 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260817132535.394764707@linuxfoundation.org> <20260817132539.879554007@linuxfoundation.org>
 <521b22fa-ef09-4449-909f-0120edfc4b24@oracle.com>
In-Reply-To: <521b22fa-ef09-4449-909f-0120edfc4b24@oracle.com>
From: Jinpu Wang <jinpu.wang@cloud.ionos.com>
Date: Wed, 19 Aug 2026 10:58:57 +0200
X-Gm-Features: AcwNN1XurzPwR7awOPzLb57kAKAR4d79LccUPmimiEZT5l1Ul5JEpUvyXAsYtLM
Message-ID: <CAMGffEmqrrFN6O2oqtAZC3iTD5UJrhVK80bmJLkof28C=uAfvQ@mail.gmail.com>
Subject: Re: [PATCH 6.12 111/181] KVM: SVM: Add support to initialize SEV/SNP
 functionality in KVM
To: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org, 
	patches@lists.linux.dev, Sean Christopherson <seanjc@google.com>, 
	Tom Lendacky <thomas.lendacky@amd.com>, Ashish Kalra <ashish.kalra@amd.com>, 
	Herbert Xu <herbert@gondor.apana.org.au>, liam.merwick@oracle.com, 
	Sasha Levin <sashal@kernel.org>, vegard.nossum@oracle.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Harshit,

On Wed, Aug 19, 2026 at 9:12=E2=80=AFAM Harshit Mogalapalli
<harshit.m.mogalapalli@oracle.com> wrote:
>
> Hi Jack, Greg, Sasha,
>
>
> On 17/08/26 7:03 pm, Greg Kroah-Hartman wrote:
> > 6.12-stable review patch.  If anyone has any objections, please let me =
know.
> >
> > ------------------
> >
> > From: Ashish Kalra <ashish.kalra@amd.com>
> >
> > commit 6f1d5a3513c2370bbd6115dd430906bc2f4bdc53 upstream.
> >
> > Move platform initialization of SEV/SNP from CCP driver probe time to
> > KVM module load time so that KVM can do SEV/SNP platform initialization
> > explicitly if it actually wants to use SEV/SNP functionality.
> >
> > Add support for KVM to explicitly call into the CCP driver at load time
> > to initialize SEV/SNP. If required, this behavior can be altered with K=
VM
> > module parameters to not do SEV/SNP platform initialization at module l=
oad
> > time. Additionally, a corresponding SEV/SNP platform shutdown is invoke=
d
> > during KVM module unload time.
> >
> > Continue to support SEV deferred initialization as the user may have th=
e
> > file containing SEV persistent data for SEV INIT_EX available only late=
r
> > after module load/init.
> >
> > Suggested-by: Sean Christopherson <seanjc@google.com>
> > Reviewed-by: Tom Lendacky <thomas.lendacky@amd.com>
> > Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>
> > Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
> > Signed-off-by: Jack Wang <jinpu.wang@cloud.ionos.com>
> > Signed-off-by: Sasha Levin <sashal@kernel.org>
> > ---
> >   arch/x86/kvm/svm/sev.c | 12 ++++++++++++
> >   1 file changed, 12 insertions(+)
> >
> > diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
> > index 6cec696461da2..bd0344bacaf1e 100644
> > --- a/arch/x86/kvm/svm/sev.c
> > +++ b/arch/x86/kvm/svm/sev.c
> > @@ -2972,6 +2972,7 @@ void __init sev_set_cpu_caps(void)
> >   void __init sev_hardware_setup(void)
> >   {
> >       unsigned int eax, ebx, ecx, edx, sev_asid_count, sev_es_asid_coun=
t;
> > +     struct sev_platform_init_args init_args =3D {0};
> >       bool sev_snp_supported =3D false;
> >       bool sev_es_supported =3D false;
> >       bool sev_supported =3D false;
> > @@ -3088,6 +3089,15 @@ void __init sev_hardware_setup(void)
> >       sev_supported_vmsa_features =3D 0;
> >       if (sev_es_debug_swap_enabled)
> >               sev_supported_vmsa_features |=3D SVM_SEV_FEAT_DEBUG_SWAP;
> > +
> > +     if (!sev_enabled)
> > +             return;
> > +
> > +     /*
> > +      * Do both SNP and SEV initialization at KVM module load.
> > +      */
> > +     init_args.probe =3D true;
> > +     sev_platform_init(&init_args);
> >   }
> >
>
> I ran an AI-assisted backport review and checked the finding against
> 6.12.y. The backport appears to be missing the ordering used upstream
> when kvm_amd is built-in.
>
> Upstream ensures that the PSP driver is ready before KVM continues:
>
>         if (IS_BUILTIN(CONFIG_KVM_AMD) && sev_module_init())
>                 goto out;
>
> It also initializes the SNP RMP table from AMD IOMMU initialization:
>
>         if (snp_rmptable_init())
>                 goto disable_snp;
>
> 6.12.y has no sev_module_init() call and still initializes the RMP table
> through a later initcall:
>
>         device_initcall(snp_rmptable_init);
>
> The backport can therefore reach:
>
>         init_args.probe =3D true;
>         sev_platform_init(&init_args);
>
> before the PSP device exists. The call returns -ENODEV and its result is
> ignored. KVM can then enable SVM before SNP/RMP setup has completed.
> Since bb1c84647025 removed probe-time platform initialization, this can
> leave encrypted guests unable to start.
>
That looks like the case, we only use kvm as module, didn't hit the issue.
> The relevant upstream commits are:
>
> 435b344a7042 ("crypto: ccp: Add external API interface for PSP module
> initialization")
> 44e70718df4f ("KVM: SVM: Ensure PSP module is initialized if KVM module
> is built-in")
> 409f45387c93 ("x86/sev: Fix broken SNP support with KVM module built-in")
>
>
> https://lore.kernel.org/stable/cover.1739226950.git.ashish.kalra@amd.com/
>
>
> Could the KVM maintainers confirm whether 6.12.y needs this full series
> ? Probably could be done after this cycle, but still noting it here.
+1
>
> thanks,
> Harshit
Thanks!
> >   void sev_hardware_unsetup(void)
> > @@ -3103,6 +3113,8 @@ void sev_hardware_unsetup(void)
> >
> >       misc_cg_set_capacity(MISC_CG_RES_SEV, 0);
> >       misc_cg_set_capacity(MISC_CG_RES_SEV_ES, 0);
> > +
> > +     sev_platform_shutdown();
> >   }
> >
> >   int sev_cpu_init(struct svm_cpu_data *sd)
>
