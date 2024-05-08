Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F1716127E22
	for <patches@lists.linux.dev>; Wed,  8 May 2024 15:08:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715180887; cv=none; b=u4rNVD937Dq0kH1vttPN07tObwA5kfYIUWsfTQ0ZGBotuQo6DcjC54iQVjh0YgD7YBy6Hd/DLBs/mDMnof+2rn1UN4X0y27Qp4sjp8EaWVNjRdsnaj1q8LqKtPoaaKO6dDrlhF3jylSDDvNseB4mgGzmMCgSuCW7v1Qp/crc4Rs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715180887; c=relaxed/simple;
	bh=fk7GxC1PPEc7qrUG7K+DrVTUtdnP9TQkDTTKR3NFiQ0=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=ozoumkEuUCBSBAJAacSm2AyUIdCh+YNZT4YGgbp4v2gS00KWFgVxBN2nDkXPAJzcZkEwvmaCtlSIksPfvIu9mCAdAG9Rbh/JGahZznk+wlftXkiZUWGBCsG9QAW6cJgOG3kB0hu8NzWwa37zf3v3RcPxQJ57TpeHzNoCKEpmVOg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Kqmfmjgz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Kqmfmjgz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9F2B3C2BD10
	for <patches@lists.linux.dev>; Wed,  8 May 2024 15:08:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1715180886;
	bh=fk7GxC1PPEc7qrUG7K+DrVTUtdnP9TQkDTTKR3NFiQ0=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=KqmfmjgzfA7SCpd2skvs5EweP4UWYpe/EgQw5Lblio/1CGIa1/NkjQS6dEbb7S39u
	 yQncy7lQGMK+0nszk3GR6UszEIjI3jjl1CbKuGm6RbpPInIpWfB90wJOi5EzNj6I4V
	 00Exk/vWptXodaaUrIPT1HnDfYj9wCjwQl8Cizzfdl3d6rL2fHlNAoEfFrN4lc/J6S
	 isItL+ip8wu+UDzsAnTQLHxZAHvSTneo17zvkmSGSJeOE7Pfwsy1jAFfocjGEZs9DB
	 dzNvwUME9rt/OxHUTKsXegGfuDiKTQRJum/VCBfdCZOumi5ZePTTNgm8KlFnSTYMS+
	 FCljcJbpxqrwA==
Received: by mail-oo1-f42.google.com with SMTP id 006d021491bc7-5b20318a866so2319723eaf.0
        for <patches@lists.linux.dev>; Wed, 08 May 2024 08:08:06 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCXW+OVcpRziTipR5mjP4R1UBzW4BGnZMNyf9IcpcklnyddJPzc0V1BmwSIwGL55vHiZvkBTbcMu6oPl2P7ZDgJB18b3pXXoPQ==
X-Gm-Message-State: AOJu0YxbjxWwDFZySgvauc6rTqVw7u+bHtn6W+DojMGTSukeR1Vi+oO5
	XHZ/J+NjD7tnUbW2M4oVc035q5GKESPlWNAWaYVFsPNmB3Jf/bkKgA4lJuk7PaxgwvYew8gKRje
	TnEVjSvtNCxw/IRmZW1kHdwy9xi0=
X-Google-Smtp-Source: AGHT+IFz6Ek/HKY5LqapHYp2J3UPciEFtCHWRtdaW10My+nmaYFrHG+n4/M/edgWSE1MPtgvRcB47UJ6HiFsKanjCPQ=
X-Received: by 2002:a4a:aa86:0:b0:5aa:4a0c:d99e with SMTP id
 006d021491bc7-5b24d75c1b8mr2668167eaf.8.1715180886050; Wed, 08 May 2024
 08:08:06 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240416211941.9369-1-tony.luck@intel.com> <20240416212214.9586-1-tony.luck@intel.com>
In-Reply-To: <20240416212214.9586-1-tony.luck@intel.com>
From: Chanwoo Choi <chanwoo@kernel.org>
Date: Thu, 9 May 2024 00:07:29 +0900
X-Gmail-Original-Message-ID: <CAGTfZH3UTdOVd+RAY6jTVHWFRgsFNCoTM7g0TLaL8GQqVTM86Q@mail.gmail.com>
Message-ID: <CAGTfZH3UTdOVd+RAY6jTVHWFRgsFNCoTM7g0TLaL8GQqVTM86Q@mail.gmail.com>
Subject: Re: [PATCH v3 49/74] x86/cpu/vfm: Update drivers/extcon/extcon-axp288.c
To: Tony Luck <tony.luck@intel.com>
Cc: MyungJoo Ham <myungjoo.ham@samsung.com>, Chanwoo Choi <cw00.choi@samsung.com>, 
	Chen-Yu Tsai <wens@csie.org>, Hans de Goede <hdegoede@redhat.com>, linux-kernel@vger.kernel.org, 
	patches@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Apr 17, 2024 at 6:31=E2=80=AFAM Tony Luck <tony.luck@intel.com> wro=
te:
>
> New CPU #defines encode vendor and family as well as model.
>
> Signed-off-by: Tony Luck <tony.luck@intel.com>
> ---
>  drivers/extcon/extcon-axp288.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/extcon/extcon-axp288.c b/drivers/extcon/extcon-axp28=
8.c
> index a703a8315634..d3bcbe839c09 100644
> --- a/drivers/extcon/extcon-axp288.c
> +++ b/drivers/extcon/extcon-axp288.c
> @@ -108,7 +108,7 @@ struct axp288_extcon_info {
>  };
>
>  static const struct x86_cpu_id cherry_trail_cpu_ids[] =3D {
> -       X86_MATCH_INTEL_FAM6_MODEL(ATOM_AIRMONT,        NULL),
> +       X86_MATCH_VFM(INTEL_ATOM_AIRMONT,       NULL),
>         {}
>  };
>
> --
> 2.44.0
>
>

Acked-by: Chanwoo Choi <cw00.choi@samsung.com>

--=20
Best Regards,
Chanwoo Choi
Samsung Electronics
