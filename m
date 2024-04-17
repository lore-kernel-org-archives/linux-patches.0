Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2DB247D405
	for <patches@lists.linux.dev>; Wed, 17 Apr 2024 08:22:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713342151; cv=none; b=Os3NeA1ZpHb7f8k1wNxJSddX6SrSrY5ECu3i3cOmz8vMGaYgYYa5HKTKoeJquNWpzVTf4nBlwtlBbPYBzqmactBxqxoM+MZFcW8QNIyGyD2UQPaaq8qG+RnQX+6DEM4awdLivlRpyoxLEsUA/m6rkHtshQwhTj3iP2DnSuHONmA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713342151; c=relaxed/simple;
	bh=vxL+yxEBtW69wT2VNPtV3o2n6+YTBPYdeGmwrvtUUYA=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=WvQKnaeQMrAeXkZvMRftOtM35VhJgaO1tJAdg+DfMIITs2HY5MbF+yd32A0imtjUc5KarP6R/LQwQYsa+RWfQ/na64/bGs2+MylSMYch+ue0H9BrAgTnlSr+QV4pCVOxWFQy6d2RJEZsFo/4TQzLQCMeV/NYiOrvjYonr2pEztA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=dogaSANW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="dogaSANW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ADC04C32781
	for <patches@lists.linux.dev>; Wed, 17 Apr 2024 08:22:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1713342150;
	bh=vxL+yxEBtW69wT2VNPtV3o2n6+YTBPYdeGmwrvtUUYA=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=dogaSANWv2AzM5+rClXb1dimseX9oKu/we3riLUBqQ5+mS6q7bGPetgZPkCQHvFEa
	 djOxTqbQLPIJNNqQq6Q794U/zcMiv2ksLhKDyjjcrBo1W1v4jocPVN0MwxGY4wQmDa
	 ieb9jevlcp3HSFuJOjx/X4dd85q/5fraTZMIsxXZdPWRKd/lpgs82ipEna7i+EDBIw
	 g56OJR9vz2+oDG7e/Y9RCNYYXB9nKJf317qGCUek9uGrGJcOTR3CncpEYJ8wD8Fqx+
	 UTYx99XkpC10r+zq+2qp0ylkfWcT9+N2LkhZyq6z7+mrifsUOrFU11S4iCKsSvgD3Y
	 SK6944R91yjgA==
Received: by mail-ot1-f44.google.com with SMTP id 46e09a7af769-6eb7a4d64e8so1162347a34.0
        for <patches@lists.linux.dev>; Wed, 17 Apr 2024 01:22:30 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCWXOcJoUW1ZomxAOJZl2XbUx/1X3GpmJw1fxASheImNVM70+WzCgemi2Y1J34o71iRrOwLFTaKj5g6aLkWgtfsEpwPcbp6u3g==
X-Gm-Message-State: AOJu0YzacorseuR/UeKnr6X0ma4TJTe105+JgjjUyFStjxEOVi2UYpOG
	Vg3ih1e/WgcfzhC50Ma1/1Ch/sFUM8vC9HQRuUszYSQuFe6i1eI+AMASBa7Peq1NbX/pD6x1V2G
	pAPvRWOUNvyi427HZIim1tnF2CNc=
X-Google-Smtp-Source: AGHT+IFrSekiz2ow8oMM1nzzDDUyICAfK9eLF583H9K9wsJGYqysgZFcvoUQKjCJpVjwMuMvfXAQPk4VISJFQP+//g8=
X-Received: by 2002:a4a:e9f0:0:b0:5aa:6a31:4f53 with SMTP id
 w16-20020a4ae9f0000000b005aa6a314f53mr13550582ooc.0.1713342150021; Wed, 17
 Apr 2024 01:22:30 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240416211941.9369-1-tony.luck@intel.com> <20240416212245.9929-1-tony.luck@intel.com>
In-Reply-To: <20240416212245.9929-1-tony.luck@intel.com>
From: "Rafael J. Wysocki" <rafael@kernel.org>
Date: Wed, 17 Apr 2024 10:22:17 +0200
X-Gmail-Original-Message-ID: <CAJZ5v0gFqbysg5Qm2SD+Y2QqONAxbUnOOKA2viCxoGnFzVxpgw@mail.gmail.com>
Message-ID: <CAJZ5v0gFqbysg5Qm2SD+Y2QqONAxbUnOOKA2viCxoGnFzVxpgw@mail.gmail.com>
Subject: Re: [PATCH v3 67/74] x86/cpu/vfm: Update drivers/powercap/intel_rapl_msr.c
To: Tony Luck <tony.luck@intel.com>
Cc: linux-kernel@vger.kernel.org, "Rafael J. Wysocki" <rafael@kernel.org>, 
	linux-pm@vger.kernel.org, patches@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Apr 16, 2024 at 11:22=E2=80=AFPM Tony Luck <tony.luck@intel.com> wr=
ote:
>
> New CPU #defines encode vendor and family as well as model.
>
> Signed-off-by: Tony Luck <tony.luck@intel.com>

Acked-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>

> ---
>  drivers/powercap/intel_rapl_msr.c | 16 ++++++++--------
>  1 file changed, 8 insertions(+), 8 deletions(-)
>
> diff --git a/drivers/powercap/intel_rapl_msr.c b/drivers/powercap/intel_r=
apl_msr.c
> index 35cb152fa9aa..733a36f67fbc 100644
> --- a/drivers/powercap/intel_rapl_msr.c
> +++ b/drivers/powercap/intel_rapl_msr.c
> @@ -139,14 +139,14 @@ static int rapl_msr_write_raw(int cpu, struct reg_a=
ction *ra)
>
>  /* List of verified CPUs. */
>  static const struct x86_cpu_id pl4_support_ids[] =3D {
> -       X86_MATCH_INTEL_FAM6_MODEL(TIGERLAKE_L, NULL),
> -       X86_MATCH_INTEL_FAM6_MODEL(ALDERLAKE, NULL),
> -       X86_MATCH_INTEL_FAM6_MODEL(ALDERLAKE_L, NULL),
> -       X86_MATCH_INTEL_FAM6_MODEL(ATOM_GRACEMONT, NULL),
> -       X86_MATCH_INTEL_FAM6_MODEL(RAPTORLAKE, NULL),
> -       X86_MATCH_INTEL_FAM6_MODEL(RAPTORLAKE_P, NULL),
> -       X86_MATCH_INTEL_FAM6_MODEL(METEORLAKE, NULL),
> -       X86_MATCH_INTEL_FAM6_MODEL(METEORLAKE_L, NULL),
> +       X86_MATCH_VFM(INTEL_TIGERLAKE_L, NULL),
> +       X86_MATCH_VFM(INTEL_ALDERLAKE, NULL),
> +       X86_MATCH_VFM(INTEL_ALDERLAKE_L, NULL),
> +       X86_MATCH_VFM(INTEL_ATOM_GRACEMONT, NULL),
> +       X86_MATCH_VFM(INTEL_RAPTORLAKE, NULL),
> +       X86_MATCH_VFM(INTEL_RAPTORLAKE_P, NULL),
> +       X86_MATCH_VFM(INTEL_METEORLAKE, NULL),
> +       X86_MATCH_VFM(INTEL_METEORLAKE_L, NULL),
>         {}
>  };
>
> --
> 2.44.0
>
