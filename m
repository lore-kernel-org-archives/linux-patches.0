Received: from mail.alien8.de (mail.alien8.de [65.109.113.108])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 798842989B5
	for <patches@lists.linux.dev>; Tue,  7 Apr 2026 18:56:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=65.109.113.108
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775588175; cv=none; b=k9BJ0onxw0qz9OMjpGDUsRlSm+ViLeS7g6Qlj1TKoNMIh1jz+1+LBKXaUqbAoI6SrhNrCIMbLVHl30FvbFVH8u6mVl0FAabKPtYDjSe7OoXgcpl0fcet09ZAixdxZxGVlbOG/5H2ZR2GoCzLmgNt1WuF11tIEbm3O4kVwSdfG4w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775588175; c=relaxed/simple;
	bh=F9HcWIw4vkyue4zgPilHslzyq8xxs4WLiNjQwP8sQOE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=VR1Ns6B06nqkPWLSbKKwRdLBKcVozexGFkW+ufjoORCAuzESLQnYU/rVHEZGuQVacY+K4WoTNqW4G1kFlSzB5v5R//5//uylDiYxPidgMCkvqGWSYSg+DS73zKOS/06UymNM7/LL6sN4G2Ke2nMl4S6mItw7eACHnOlXc+AfdFQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de; spf=pass smtp.mailfrom=alien8.de; dkim=fail (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b=kEpr2rFq reason="signature verification failed"; arc=none smtp.client-ip=65.109.113.108
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=alien8.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=fail reason="signature verification failed" (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b="kEpr2rFq"
Received: from localhost (localhost.localdomain [127.0.0.1])
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTP id 0E60640E0176;
	Tue,  7 Apr 2026 18:56:10 +0000 (UTC)
X-Virus-Scanned: Debian amavisd-new at mail.alien8.de
Authentication-Results: mail.alien8.de (amavisd-new); dkim=fail (4096-bit key)
	reason="fail (body has been altered)" header.d=alien8.de
Received: from mail.alien8.de ([127.0.0.1])
	by localhost (mail.alien8.de [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP id JHJnUbegfrxY; Tue,  7 Apr 2026 18:56:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=alien8;
	t=1775588165; bh=LrmQ0u560Wgdtol4w+rSjUTepkAwtQfyj0DjSjiLicM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=kEpr2rFqRyMb2/5hTitok+XhrqfwK8PjS0JxNdVqCzS/2uj4SUPuAYlVmm8RoT05K
	 BGFxmdF7OflbZOd1ypN8ORxy744oaWJ959lrk+bwAy8EckCf5Ay7D6NXVVDQi/oo/8
	 +TjLTKzform3EAFEglqyxmZW22Tbz05nePscqh2dFEoIXFyRsWTOEkV8cOJSrPWV1d
	 p9w6AZZd787VbZP+CJmOMQ109tHuTV+fUgzzejIwryUGQV6SmRPP7ev0/Mn/DbrWql
	 LVd0v3jXViIgHORuWJvAPi5cCfheUYfcY/TD3fYOBLvepoHCp8uFBdQbjk+RXFf4E1
	 0cPWcMSCOPx90gMOaBa9MiDuUwTeoAVmFnpqCf0BvkPArSmNUn4tB9iVIgM+aIW1Cl
	 x4TALHcx5XDb2QAimKZ1tW6AdCJJaj7twIz/cKGiGPx+/n6NodBHqP3bbzCUwwcSMD
	 puOt3N5nvrTp8WzoN7IVC07jsZ2qlrmH5+MhSzAGwV2nCIt3CdHbbvsddZM7aghhau
	 FxjavtNL1b/Hi4GxQe1sQ7wfx6PLa9HPjVcbLgzclxTCFuzQ0g5RR0mLi1335MRX++
	 O6uAhxxjBBF0nfX8wyLuDxlX5hkk+dunHS5RKj0wKCIy4xlMlT4ctDPPRIFyRSGQmQ
	 isebTeRqnLao90e+4wgkBHnA=
Received: from zn.tnic (p5de8e020.dip0.t-ipconnect.de [93.232.224.32])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature ECDSA (P-256) server-digest SHA256)
	(No client certificate requested)
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with UTF8SMTPSA id 2661D40E00DE;
	Tue,  7 Apr 2026 18:55:50 +0000 (UTC)
Date: Tue, 7 Apr 2026 20:55:43 +0200
From: Borislav Petkov <bp@alien8.de>
To: Reinette Chatre <reinette.chatre@intel.com>
Cc: tony.luck@intel.com, james.morse@arm.com, Dave.Martin@arm.com,
	babu.moger@amd.com, tglx@linutronix.de, dave.hansen@linux.intel.com,
	x86@kernel.org, hpa@zytor.com, ben.horgan@arm.com,
	fustini@kernel.org, fenghuay@nvidia.com, peternewman@google.com,
	linux-kernel@vger.kernel.org, patches@lists.linux.dev
Subject: Re: [PATCH v3 03/13] fs/resctrl: Avoid "may be used uninitialized"
 warning
Message-ID: <20260407185543.GFadVTLy82sBzT3eej@fat_crate.local>
References: <cover.1775576382.git.reinette.chatre@intel.com>
 <56fa3b5937ec6fda4eec162393463d8dbfc1abe4.1775576382.git.reinette.chatre@intel.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <56fa3b5937ec6fda4eec162393463d8dbfc1abe4.1775576382.git.reinette.chatre@intel.com>
Content-Transfer-Encoding: quoted-printable

On Tue, Apr 07, 2026 at 09:02:00AM -0700, Reinette Chatre wrote:
> Building resctrl with extra checks ("W=3D12") produces the following wa=
rning:
>  .../include/linux/ucopysize.h:22:17: warning: =E2=80=98buf=E2=80=99 ma=
y be used uninitialized [-Wmaybe-uninitialized]
>    22 |                 __check_object_size(ptr, n, to_user);
>       |                 ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
>  .../include/linux/ucopysize.h: In function =E2=80=98pseudo_lock_measur=
e_trigger=E2=80=99:
>  .../include/linux/ucopysize.h:10:13: note: by argument 1 of type =E2=80=
=98const void *=E2=80=99 to =E2=80=98__check_object_size=E2=80=99 declare=
d here
>    10 | extern void __check_object_size(const void *ptr, unsigned long =
n,
>       |             ^~~~~~~~~~~~~~~~~~~
>  .../fs/resctrl/pseudo_lock.c:754:14: note: =E2=80=98buf=E2=80=99 decla=
red here
>   754 |         char buf[32];
>       |              ^~~
>=20
> __check_object_size() ensures the provided buffer is within a valid loc=
ation
> but does not read from the uninitialized buffer. Even so, initialize th=
e
> buffer to silence the warning to help resctrl have a cleaner build.
>=20
> Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
> ---
>  fs/resctrl/pseudo_lock.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>=20
> diff --git a/fs/resctrl/pseudo_lock.c b/fs/resctrl/pseudo_lock.c
> index fa3687d69ebd..e1e9134474f4 100644
> --- a/fs/resctrl/pseudo_lock.c
> +++ b/fs/resctrl/pseudo_lock.c
> @@ -750,8 +750,8 @@ static ssize_t pseudo_lock_measure_trigger(struct f=
ile *file,
>  					   size_t count, loff_t *ppos)
>  {
>  	struct rdtgroup *rdtgrp =3D file->private_data;
> +	char buf[32] =3D {};

AFAIU, you're not leaking any uninitialized stack data from that buffer,
right?

If so, why do you care about some silly build warning and are willing to =
waste
a 32-byte memset on every function entry?

There's a reason those warnings are behind W=3D ...

:-)

--=20
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
