Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E10929CEB
	for <patches@lists.linux.dev>; Wed, 17 Apr 2024 08:25:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713342349; cv=none; b=sloSYWusIVoOnkuADBfuPvCv0/j9k3wAPCoPfJQGJh7pD2w/qjHdENwRKLfXEjts8bRNYwjeI474zAWT4yLy+oZ68n+LgWRrhFQiq5ifXkPhAbp3pXk1VcheAnAadIcR46YFDebaPzFJ37X8ipt/Js3b43/G6BiIZ82auqMBnts=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713342349; c=relaxed/simple;
	bh=ni2dZHo4oHABNTjcemnlwpO/U8ITGYPkSL4a1KmIldw=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=MiobAgaxYZxQeLHVwmDSOwo5vu+yTvLIbcSlQ4NdT8I6U/zoGQxbM+CAPdybERRFG2UTSQZHg4V59LBBaB6k2qDMPPwfFHXMOMQsUt6HfqvpzWOaEXk1bnZyCC5dEillZWCSuGrDGP9k8t7kzYedQ3wstyd+S0fMgs3INPlKgNw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ZmvVruk5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ZmvVruk5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EF068C2BD10
	for <patches@lists.linux.dev>; Wed, 17 Apr 2024 08:25:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1713342349;
	bh=ni2dZHo4oHABNTjcemnlwpO/U8ITGYPkSL4a1KmIldw=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=ZmvVruk5NcE5LQL2s04sJ1tFRrbCEX+KNFmHiWJqOkKfRsNS8D/gutOoD4YkHqcd/
	 5GBV9RNQZxB1fn3W6z6qWzg4SgZp90euUl3gCyMPOKc36ZCuZovMhS87Wh0gvTo/D2
	 dKQF6gWGst4hRXDZUHCreODw/bictrJXgXU06kfZR3UgcKWtYMUcMQDZ4QK7kiSoHS
	 f32shrYLfgBw1ffQaOIjXVyldEEf+yoUtag/0Qf7zoG6VNIxXmTiT6469At5DJyeXO
	 5wZrIxxjwHjrwpJL8BoHbH/L5GWb9Pcq74FDMUfTx6i9nwCpHrt5Z2ieHooS/qo6bL
	 utxUM8E5MX4Lg==
Received: by mail-ot1-f51.google.com with SMTP id 46e09a7af769-6eba841d83bso83368a34.3
        for <patches@lists.linux.dev>; Wed, 17 Apr 2024 01:25:48 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCXd7UAuCYByitj9Fz2eI281OdpOF6tK4gcCWerJheQah6dVLgePiTUfdlDBXjEMeie8r0dOQ4aLVspgzMecK7SLhHpnDA0LEw==
X-Gm-Message-State: AOJu0YwHXRKFgIHTik4ER7fAn7Arm/u7UdO5Fc9BjJg60G5UmuwDGm4H
	XctiNjza1NC3z/9FtOPNowe81xXWPnIkJ1Xsp3ypy9sHij3RvJSSvOXmKeDTtgsSkwYiMLmByYs
	nDmKoFD2xFeHecsKj4WqnzSk+2Iw=
X-Google-Smtp-Source: AGHT+IGTo7T4sQQ+b5Vfo2JDa0ZQEGNY6l5zAskf0HCPhag3E8pX5fEKHsYuwBiLCqqgNk2eRHFEfgJsP40ZwK7eJOA=
X-Received: by 2002:a4a:e9f0:0:b0:5aa:6a31:4f53 with SMTP id
 w16-20020a4ae9f0000000b005aa6a314f53mr13556244ooc.0.1713342348323; Wed, 17
 Apr 2024 01:25:48 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240416211941.9369-1-tony.luck@intel.com> <20240416212156.9413-1-tony.luck@intel.com>
In-Reply-To: <20240416212156.9413-1-tony.luck@intel.com>
From: "Rafael J. Wysocki" <rafael@kernel.org>
Date: Wed, 17 Apr 2024 10:25:36 +0200
X-Gmail-Original-Message-ID: <CAJZ5v0inW4d3pk5=PmpCk8OZ4+dM_b6o7n-uRVKL19ib1nSQKQ@mail.gmail.com>
Message-ID: <CAJZ5v0inW4d3pk5=PmpCk8OZ4+dM_b6o7n-uRVKL19ib1nSQKQ@mail.gmail.com>
Subject: Re: [PATCH v3 40/74] x86/cpu/vfm: Update drivers/acpi/acpi_lpss.c
To: Tony Luck <tony.luck@intel.com>
Cc: linux-kernel@vger.kernel.org, "Rafael J. Wysocki" <rafael@kernel.org>, 
	Len Brown <lenb@kernel.org>, linux-acpi@vger.kernel.org, patches@lists.linux.dev
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
>  drivers/acpi/acpi_lpss.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/acpi/acpi_lpss.c b/drivers/acpi/acpi_lpss.c
> index 04e273167e92..e7b57dcce146 100644
> --- a/drivers/acpi/acpi_lpss.c
> +++ b/drivers/acpi/acpi_lpss.c
> @@ -337,8 +337,8 @@ static const struct lpss_device_desc bsw_spi_dev_desc=
 =3D {
>  };
>
>  static const struct x86_cpu_id lpss_cpu_ids[] =3D {
> -       X86_MATCH_INTEL_FAM6_MODEL(ATOM_SILVERMONT,     NULL),
> -       X86_MATCH_INTEL_FAM6_MODEL(ATOM_AIRMONT,        NULL),
> +       X86_MATCH_VFM(INTEL_ATOM_SILVERMONT,    NULL),
> +       X86_MATCH_VFM(INTEL_ATOM_AIRMONT,       NULL),
>         {}
>  };
>
> --
> 2.44.0
>
