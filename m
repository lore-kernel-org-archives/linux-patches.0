Received: from mail-oa1-f47.google.com (mail-oa1-f47.google.com [209.85.160.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F1E9397E88
	for <patches@lists.linux.dev>; Wed,  1 Jul 2026 19:17:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.160.47
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782933430; cv=pass; b=a4zNvBIXm9wJ+drd7twHuAAW5ora2OS71CoO12z1QEsI2mmwmlj8z52hvRSEGQkocsywnnzV50e62xlvE1/u/qDjp4B/fwnx1zLV5M421LL9NjF2Ynl9Ynq0yGA8McmJEwHukdYVW7WmSg2N4zES3tBgy9jsrySblf4ygdRdv/I=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782933430; c=relaxed/simple;
	bh=r+NletA3FmRDG/GD5IvXS5VhekYurTM15nt1C3iy2LU=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=T0l88xdFPocaIlnGRFQUFyPfACkgaLb2ZYzayMqaTHFE6Ff8V8kIOu/f4AyzyRjDZQP59Rnx2HlgvNbmQMnQC70JsKIGN8NAqBhZDSH6H+nZHav5rXOPtLEPGCJ+gy12y9HT4/eh5F85a24CxTbHbLcJrNzRfPNInLUPS22kHNQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=opqq9qRu; arc=pass smtp.client-ip=209.85.160.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="opqq9qRu"
Received: by mail-oa1-f47.google.com with SMTP id 586e51a60fabf-44cb68d549fso259654fac.1
        for <patches@lists.linux.dev>; Wed, 01 Jul 2026 12:17:09 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1782933428; cv=none;
        d=google.com; s=arc-20260327;
        b=pQENloMwTvHuI4JauoRZ3fbGT2hCaAcGtgMWnZqpW/jZ09yGtQ+GwTAp5pGjAfUmVP
         H/wPEW7LSZCSGL8KmDA8XSwWWsnw9hrz6Z/ESykOoa+ObQcZcS//sPhXrb5WmFnUcXk2
         j1Y6W8C/zdOgvy6YqjeLYkl024UUhAj21ZeRrl6/SdvVhYWjIfwVmwh2dGGY7TCX9y7K
         ssXu+OfgQ7hXtescKydmSCPH0kCj8LNNblTGxMxWJrg45n0ybmpndNVgz+YBAQsA2uWW
         JLOrADhuUpBFYcLTb3bcn8PKAlNaexUWllwaXLtY59f3OAzZ1fRp6h7y6hO5org+Nn91
         1doQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=r+NletA3FmRDG/GD5IvXS5VhekYurTM15nt1C3iy2LU=;
        fh=8xo0oqinnBlglsuALLoXhueMEnqb288vI4cS1Q9ex/U=;
        b=EfPD2MzCC8JzY+l0asnePNJdm8KYnueipqRpqos2iej0fvq/UcR/ltGMzBnvZWgRaK
         nkXghX3XJm9Nvtl9x6U8hcdfgagiuf/Qj27/ORSCecpW28EPei5UgSKaRRqnioZj+sHF
         DSUyT4q9z2oHRRjLby93ZRWorI3k5HtaqeBXf5eQJL70qB4w0FS1VM/2Op1E3NM0r3kg
         Me9JtGK/qCLz03gsU9e3LHd6bS0oDtmaIVdtnT0EKmfYGUXABL099LBGk/IVQrgs76/X
         OA9cXNBCAhRo3eUpHec3h4ttqwzseZdO7hVrblpEyBeqDZO1BRCLxdVNt84wIApfVWgu
         D/Lg==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1782933428; x=1783538228; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=r+NletA3FmRDG/GD5IvXS5VhekYurTM15nt1C3iy2LU=;
        b=opqq9qRut9Uo+inVjyj9+ZsJzF3gGLKQtPhPG8faBNay+c1dl7VRTsUKC3duhEHSBw
         +wzsHoE/33UkHbrgfxucL7bPWzciUHL9GKHiBJbGMdjmwm101xSSDN682bWnPXi6zhNw
         w2STiXNDadeZDV9NnuI/1pRXk+N5OBlTAgqR1rzkYIX5QJvQGslzfDD9JVlI6OpIs6Ss
         cLYnHYKdNxuUWWDS8lz8D0ASSwhvaYih7LXKTyi3XJNYfB5VYwDSbUizSOBdJWS71gF3
         3CmzzRNaWcCqyIs3+688z4YsL6zhLc6hfF06dEPWO3Vrvzd7THUvSuV/JrcR8VQqbro8
         9PMg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782933428; x=1783538228;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=r+NletA3FmRDG/GD5IvXS5VhekYurTM15nt1C3iy2LU=;
        b=sl7LKceGnqG/HoM5NBTK1QlaXZcOApr4qnQqXMlaQDnkrDJwy1G1MQ+SIknAuxzJD8
         ZPN/MsT66GrQW9X3Nu7egWAPBu6DtwqGXOt4O+8sL5gdDI3ZSyAbTAhV3AJW0lTpL9fF
         DVIE9GRJ4UOG7eA2m5dGekeqg1mgKV+mhA1DTwpRo6wJsdt+U52rD+bplkuT74gboYYY
         cH+gau6pTpotJKp1G4vO/e/PpcTLOcsREIjnfd49bE2FoS7mxmh54ly1/pNTWmdXrTs2
         MOlVFc1UBSGjm23UQ44bifoAU6TUQaXKoGTRKQOPSdmKYWWtCxw8ZgyFfWibo00nFFA7
         t7Qg==
X-Forwarded-Encrypted: i=1; AHgh+Ro8H48aFvNczOUv3CcrIrvopuGjqcwcsMk55NHHvxuZTzEon1UWLMyinGd3gDvp9tZemJV88Cfc@lists.linux.dev
X-Gm-Message-State: AOJu0Yy2SCbqPZXlT+hbbP5Y9hd90SyW8F7xEytcO2Hqr2XZ2mz8u/IN
	yIAaOqwM+8KVSOmtOXngJDvNfjnvBCWlrGBZXXJ9jrUsjPXYRIJVKWv5hNGY1/kf1/a2U1fkINJ
	TY4qZmuFBPDc3F9wgQWByuFHV4/OLVH0=
X-Gm-Gg: AfdE7ckY0qKCCPCkC+7ZJTzZ8xTbkr7F3UcJcn5SFqRn6vOBOacKOTHZXjOm6r+561e
	4jtD/mRwv/vPnhNQpgNUJD40IVCX0DynBXVDVO2I5AwKOQiJT/m5D9X2eQRaNm5DG7Y3p7E0I9G
	BjwUo+KcqS+UlWvEg1cyhBzhMDkJMCEs401PFAstBmRkArwlpYvDxxhtsmEWikjU54MvqZzs0UO
	ubfj9gn6RG2SzZ9lQ9Ghj20Sd7JsmCqa4qINzU7iEUGjyQ+to5P2IOvJV7BJ6L6APG9pfo=
X-Received: by 2002:a05:6871:c8c7:b0:439:ecb3:52bb with SMTP id
 586e51a60fabf-44ae2b77260mr4418100fac.2.1782933428320; Wed, 01 Jul 2026
 12:17:08 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <89ea76b3-e956-4232-8180-ee3929adf905@kernel.org>
 <20260625101132.3859505-1-safinaskar@gmail.com> <63f7860c-4f5c-4682-8914-27978b9fbfe1@kernel.org>
 <20260629-bauland-knabbern-abgeladen-c0acbfa62cc2@brauner> <CAPnZJGAJROqfCWSeeBu31HsE6nmgxVqHTNeC554S5y1Y-VN19w@mail.gmail.com>
In-Reply-To: <CAPnZJGAJROqfCWSeeBu31HsE6nmgxVqHTNeC554S5y1Y-VN19w@mail.gmail.com>
From: Andrei Vagin <avagin@gmail.com>
Date: Wed, 1 Jul 2026 12:16:55 -0700
X-Gm-Features: AVVi8Cfr-c-MwbiVa4Na7Gy64V9E0QAPHBSr0wHsSXCEVpPyigPKnVtNTDOprcQ
Message-ID: <CANaxB-wewdUnxApVU3yn7hqbztNJFQfN6Y8r_XZk-TZRXpOQ=w@mail.gmail.com>
Subject: Re: [PATCH v2 0/7] vmsplice: fix some problems in my previous
 vmsplice patchset
To: Askar Safin <safinaskar@gmail.com>
Cc: Christian Brauner <brauner@kernel.org>, "David Hildenbrand (Arm)" <david@kernel.org>, akpm@linux-foundation.org, 
	axboe@kernel.dk, collin.funk1@gmail.com, david.laight.linux@gmail.com, 
	dhowells@redhat.com, fuse-devel@lists.linux.dev, hch@infradead.org, 
	jack@suse.cz, joannelkoong@gmail.com, kernel@infinite-source.de, 
	linux-api@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, luto@amacapital.net, 
	metze@samba.org, miklos@szeredi.hu, netdev@vger.kernel.org, 
	patches@lists.linux.dev, pfalcato@suse.de, torvalds@linux-foundation.org, 
	val@packett.cool, viro@zeniv.linux.org.uk, w@1wt.eu, willy@infradead.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Jun 30, 2026 at 9:01=E2=80=AFPM Askar Safin <safinaskar@gmail.com> =
wrote:
>
> On Mon, Jun 29, 2026 at 11:56=E2=80=AFAM Christian Brauner <brauner@kerne=
l.org> wrote:
> > The amount of regression reports that we got in short succession doesn'=
t
> > make it likely that we can merge a plain degradation.
>
> Let me repeat: this v2 patchset fixes all regressions found so far,
> except for major CRIU performance regression

Askar,

As previously mentioned, this isn't just a major performance issue for
CRIU; it completely breaks the current pre-dump implementation.

The other proposed fixes look like workarounds that target specific
projects. Since few projects run tests on linux-next kernels, we should
expect more projects to be affected by these changes.

Thanks,
Andrei
