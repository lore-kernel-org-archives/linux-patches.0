Received: from mail-il1-f171.google.com (mail-il1-f171.google.com [209.85.166.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AFC215915C
	for <patches@lists.linux.dev>; Fri,  8 Dec 2023 22:10:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="UGR6FTVG"
Received: by mail-il1-f171.google.com with SMTP id e9e14a558f8ab-357d0d15b29so9225ab.1
        for <patches@lists.linux.dev>; Fri, 08 Dec 2023 14:10:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1702073403; x=1702678203; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Yq8sLZY529fpZyvYcaaHG7aerxfsju32DEaOISOYWys=;
        b=UGR6FTVG+HryB9XklAxYHnvRHrOmByMIWPi960ed7O8i7eJEp9A4BTF6MgOwhwCu3t
         a6JLrN+OB9jrJM66GuR09rJpkDKvlFy4Iaj6OemN/6+cdjqlqRyAq+69xM15XHp+BJPT
         57kEgPSg0ExlqMqhrkzucpuoPn1HYsNd5lCHSLkDcxXrK/Z7QUMVSKNvOjb1wJvL7udJ
         iR17/gO7+FhFYTC+YZWwqBbUgBUpNxuE6TAUbNnPXF2sPxJdl69PQCF8lW2OPcH8Vw0S
         ToBHzyzevNdqpBeJ0eJSZSiDhQB/qelvEe+8/T6vLc+UHOov13+1+STeGw14Fq7SGchZ
         y6iQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1702073403; x=1702678203;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Yq8sLZY529fpZyvYcaaHG7aerxfsju32DEaOISOYWys=;
        b=i0n+Mg7cXH0g2xkIYH9tzNHtL4olTX4OQPQEsuLaV7IDkx1Qe14TXW97YYoE6hi/UI
         Mj4nvDjdxIaICTESR7nM6dtw6t8k3/ne8i9JrWi/W6uaXpixPBETswlwWCOEPqnpuRrc
         GxOMgnFYjgPAUvKrqPvRI7zBd2B0+yL1CWsV4QXWBka+ZVd2dbZkSBZ48EjciHU6wZUw
         GFuTiaLziFcsr4A+XSFncihoeit9xCIjBPHynSWCvNpSWCeNUe1aQBbCzpUP81+UwOtt
         FgodP2lstJi0xsbZRx9xBj6VWmKpO7hRBSoh2A5WrsKoiKvREM6KSf7zfYQBQba2Ked+
         3iPA==
X-Gm-Message-State: AOJu0Yyv+vCgjFYfBuboxw6cxsgV5KhxPmzSEUhQfeGWNk6xpTORj3ZW
	jAM7+vLtXyp6Yv5LWsOJxtf+Myx6nG4vV/aYeuxswg==
X-Google-Smtp-Source: AGHT+IF+7j3OGuA6M1m1GklJP1yo6EP7HkZ23ytD0eEL4vpAJ88qnrNWtxyHiYrK17I7SJvwBMPxSHB9bsYkWIrc+PI=
X-Received: by 2002:a92:c52c:0:b0:35c:efe7:e9fa with SMTP id
 m12-20020a92c52c000000b0035cefe7e9famr285633ili.23.1702073403543; Fri, 08 Dec
 2023 14:10:03 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20231201214737.104444-1-tony.luck@intel.com> <20231207195613.153980-1-tony.luck@intel.com>
 <20231207195613.153980-2-tony.luck@intel.com> <CALPaoCji1yzfkA=tms3LhYMvRB+wSJQM3qzPKrHNEa7a+KduTA@mail.gmail.com>
 <ZXORTTIUKWXOsd9p@agluck-desk3>
In-Reply-To: <ZXORTTIUKWXOsd9p@agluck-desk3>
From: Peter Newman <peternewman@google.com>
Date: Fri, 8 Dec 2023 14:09:52 -0800
Message-ID: <CALPaoCj_OvMzD8W9+jEORewwDquM6F-sOW32Ngcy+Gm6A1+OcQ@mail.gmail.com>
Subject: Re: [PATCH v6 1/3] x86/resctrl: Add mount option "mba_MBps_event"
To: Tony Luck <tony.luck@intel.com>
Cc: Fenghua Yu <fenghua.yu@intel.com>, Reinette Chatre <reinette.chatre@intel.com>, 
	Jonathan Corbet <corbet@lwn.net>, Shuah Khan <skhan@linuxfoundation.org>, x86@kernel.org, 
	Shaopeng Tan <tan.shaopeng@fujitsu.com>, James Morse <james.morse@arm.com>, 
	Jamie Iles <quic_jiles@quicinc.com>, Babu Moger <babu.moger@amd.com>, 
	Randy Dunlap <rdunlap@infradead.org>, linux-kernel@vger.kernel.org, 
	linux-doc@vger.kernel.org, patches@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Dec 8, 2023 at 1:57=E2=80=AFPM Tony Luck <tony.luck@intel.com> wrot=
e:
>
> On Fri, Dec 08, 2023 at 10:17:08AM -0800, Peter Newman wrote:
> > Hi Tony,
> >
> > On Thu, Dec 7, 2023 at 11:56=E2=80=AFAM Tony Luck <tony.luck@intel.com>=
 wrote:
> > > @@ -2715,7 +2723,25 @@ static int rdt_parse_param(struct fs_context *=
fc, struct fs_parameter *param)
> > >         case Opt_mba_mbps:
> > >                 if (!supports_mba_mbps())
> > >                         return -EINVAL;
> > > -               ctx->enable_mba_mbps =3D true;
> > > +               if (is_mbm_local_enabled())
> > > +                       ctx->enable_mba_mbps_local =3D true;
> > > +               else
> > > +                       return -EINVAL;
> > > +               return 0;
> > > +       case Opt_mba_mbps_event:
> > > +               if (!supports_mba_mbps())
> > > +                       return -EINVAL;
> > > +               if (!strcmp("mbm_local_bytes", param->string)) {
> > > +                       if (!is_mbm_local_enabled())
> > > +                               return -EINVAL;
> > > +                       ctx->enable_mba_mbps_local =3D true;
> > > +               } else if (!strcmp("mbm_total_bytes", param->string))=
 {
> > > +                       if (!is_mbm_total_enabled())
> > > +                               return -EINVAL;
> > > +                       ctx->enable_mba_mbps_total =3D true;
> > > +               } else {
> > > +                       return -EINVAL;
> >
> > It looks like if I pass
> > "mba_MBps_event=3Dmbm_total_bytes,mba_MBps_event=3Dmbm_local_bytes" I c=
an
> > set both flags true.
>
> That's going to be confusing. I'll add code to stop the user from
> passing both options.

Also kind of confusing, after reading the second patch, I realized
"mba_MBps_event=3Dmbm_total_bytes,mba_MBps" also results in both being
set. If you're able to fail the mount operation if both flags somehow
get set, that would address this one too.

-Peter
