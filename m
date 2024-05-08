Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D86A12836A
	for <patches@lists.linux.dev>; Wed,  8 May 2024 15:22:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715181730; cv=none; b=izNI8O4Kz+6eTlyGNVjguMErVmRIT/GdVHMQ/wvxb/kRyN9S2787oXyYec3NeJGJuZxsDuEmzXEmwk0wUQE1wMMX+dQwPEAqGNgJk9buwAQ/W3oA2t0lqq9HKZrqB9euvgYBFDDF6PHlyFOMqzOlQdhybgfMvBefialYjDUTQSw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715181730; c=relaxed/simple;
	bh=IeU+ikK/RaXL2dTlSwtTJbI5IL9t+dI2CSxMLaAcXE4=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=OzzmEohggOSw1yuFAYhklBzY37j04fLYOP3BhcCw/dMbHtmRfJhUkSbE653BiZbSLAP7tfb5EGQh7cqAH06bh3pIq64WOzmJX1kjT9OQtb1psKlezFHKhllOiZUN9kTu7f50PxRxclwzqMxK5SwPi1VbLabWMyO+4LnxjQoo0tg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=l/AEFCd0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="l/AEFCd0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E863AC113CC
	for <patches@lists.linux.dev>; Wed,  8 May 2024 15:22:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1715181729;
	bh=IeU+ikK/RaXL2dTlSwtTJbI5IL9t+dI2CSxMLaAcXE4=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=l/AEFCd0cfEsmR8a8toANnWQTBK4qScSH7VjKXJxtlwsVFVa3mOdEnifg73C1sEsh
	 eWXBwK1un9FDj4jhr8DG3dU3LVrzEYquLdCGeabQmiFRXR+IEys4RTh92EGTsKfLvj
	 vS558nAZ9Uh8ZkKSXq7lpXrNYNpSjI0U2vEbKTNJVSsrVuFiGU0HHZu65l7Z7RPcKN
	 uvO3eQ4qTPFUX5KAmvPgPXpSXTaj9qttMSBF1kwtMa9p5BZ1A1xCUDwzySw0zR+EmQ
	 5IHCgU80dAx/YS8CVYHWd7iwoEbLv4/54uF6xM8HGIkDM+lSqem4eAUX8x+n5ghyth
	 4tNRoqhYJZsfQ==
Received: by mail-oo1-f50.google.com with SMTP id 006d021491bc7-5aa28cde736so2788315eaf.1
        for <patches@lists.linux.dev>; Wed, 08 May 2024 08:22:09 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCXBeYDo7J7wFuV93u7D486t9PmY0e9kZ7RB2MyqNgKlKVHe/1A4NYlUfe1QVJ7191XHkwUKq3ejyzrO8bFayUU1F1v74ptAJg==
X-Gm-Message-State: AOJu0Yx8bXJzlrfi9tR+ecLLs5+j6bAI+fR1yyZQBEy4uzj5j4A5hZxv
	WXyRnvaWp7u1qGQn61KHlXgS/zGavHonMGS/sMR15MPMpBSP/gWMcsTkAFjzkkxz2aHJm2IiqCN
	bLoz8EA1F/BQXIQnoB+cHtQvHNPw=
X-Google-Smtp-Source: AGHT+IGjHQEBzb2A3WtWhJ9cAaHhTvD8SsmC4FBLoWmoQo8odbmOSyDXd3MvOug2Dy3zswo3tsF+kJr5h3reyQ1MRZs=
X-Received: by 2002:a4a:8c6b:0:b0:5af:a5d8:c445 with SMTP id
 006d021491bc7-5b24ca90b69mr3095826eaf.0.1715181729390; Wed, 08 May 2024
 08:22:09 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240424181245.41141-1-tony.luck@intel.com> <20240424181532.42178-1-tony.luck@intel.com>
In-Reply-To: <20240424181532.42178-1-tony.luck@intel.com>
From: Chanwoo Choi <chanwoo@kernel.org>
Date: Thu, 9 May 2024 00:21:32 +0900
X-Gmail-Original-Message-ID: <CAGTfZH0vVrrJTeUTvAK0NrWUqiVB7yqzmpYj4PvZn4w10mGSOw@mail.gmail.com>
Message-ID: <CAGTfZH0vVrrJTeUTvAK0NrWUqiVB7yqzmpYj4PvZn4w10mGSOw@mail.gmail.com>
Subject: Re: [PATCH v4 53/71] extcon: axp288: Switch to new Intel CPU model defines
To: Tony Luck <tony.luck@intel.com>
Cc: Borislav Petkov <bp@alien8.de>, MyungJoo Ham <myungjoo.ham@samsung.com>, 
	Chanwoo Choi <cw00.choi@samsung.com>, Hans de Goede <hdegoede@redhat.com>, 
	Chen-Yu Tsai <wens@csie.org>, linux-kernel@vger.kernel.org, patches@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Apr 25, 2024 at 3:29=E2=80=AFAM Tony Luck <tony.luck@intel.com> wro=
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
