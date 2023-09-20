Received: from mail-pl1-f169.google.com (mail-pl1-f169.google.com [209.85.214.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 25F3A405D1
	for <patches@lists.linux.dev>; Wed, 20 Sep 2023 21:47:04 +0000 (UTC)
Received: by mail-pl1-f169.google.com with SMTP id d9443c01a7336-1c469ab6935so23495ad.1
        for <patches@lists.linux.dev>; Wed, 20 Sep 2023 14:47:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1695246424; x=1695851224; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=gANn8NVB2NEK8/dkBC5MGqGDIrIr0tBy9ASv9Dt/xcQ=;
        b=cdAA6Fsru3f8H8smxMPuEnwjJ4hVKrhsTtPRA9X83ZQbRExL4VEZyVqYHOhYxqsQjV
         ffzSV1GQ43yALLR6WZk7520d1Y9SHPlMlYuRV7AG7HAsW4flDbZ8rREMkGqso2qrSKDB
         Z3hdtiP+M6Yk/Yr9FPGUXkb13cg1bw1osQvHLzQIKY6rSLcXI3oG+CY7+5saGf72AYS1
         FHr0f7Vwn4xOFsbDCURqF9e58iBmtIGsgRKXXAQx/HKvEzSOTarUxzHG3y06+zcS7xfy
         MDX4rkDhiHMBPOeroj8m35QcgK7VSEDewfYT/BRpTfAcje3T/FPQexEJD8subKjNAI/K
         e8Wg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1695246424; x=1695851224;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=gANn8NVB2NEK8/dkBC5MGqGDIrIr0tBy9ASv9Dt/xcQ=;
        b=PiEvigpoNELPeCOKfj+onIncLSIqZdP4SBHSIAXvuHv94qW3fjHn+/Hi1OqDTogv90
         RhSoMPs8OgamcjnGuvQTaE/jgjIy1McVyge5bPYIH0hqBzhY+J5i0dhwRXbdjZkOr/ZR
         1hGxMVjIKgBZr4Dwh5vcWSDIa4+PNosawoGgmn0ZCVYesR0pITLivyPu+yGjqC5GeCVO
         OENdVncwlpfCZCIdrXz/KEIPwNpA/p1TUzm3M1pAU1wrm5VXvGcNh54ZSfo24hlTAhXY
         EMIWsibv6XlxX5y3f+gxTdvIJJf/2s+qcZb/ejNIdOWeTbUnAHg2URJXBlfKN1HWg0j5
         0onA==
X-Gm-Message-State: AOJu0Yy6TT1XBiCkC+jrG7Dzif0N0JIsTnrdXFzG/gvxFc3AiQykdN1P
	PIVjemI+0Cis35s5AZxHiBjJvL9VM4sOKAj3JZLiOQ==
X-Google-Smtp-Source: AGHT+IFXbWfy6csSqRz3YbIOJf32CePT0J0T1e3RUq2k1c/wNw2XTsxo4NBrKI6WzhP+fZJL+GEvVH2o8pllJgrDPj4=
X-Received: by 2002:a17:902:c949:b0:1c4:1392:e4b5 with SMTP id
 i9-20020a170902c94900b001c41392e4b5mr20503pla.21.1695246424078; Wed, 20 Sep
 2023 14:47:04 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20230917191042.204185566@linuxfoundation.org> <20230920081101.GA12096@linuxonhyperv3.guj3yctzbm1etfxqx2vob5hsef.xx.internal.cloudapp.net>
 <ZQqwzK/fDm+GLiKM@dhcp22.suse.cz> <101987a1-b1ab-429d-af03-b6bdf6216474@linux.microsoft.com>
 <ZQrSXh+riB7NnZuE@dhcp22.suse.cz> <4eb47d6a-b127-4aad-af30-896c3b9505b4@linux.microsoft.com>
 <ZQr3+YfcBM2Er6F7@dhcp22.suse.cz> <CALvZod7E_Jm9y+40OKtLs5EFA0ptKGjoe2BU58SY29pUiPc93g@mail.gmail.com>
 <ZQskGGAwlsr1YxAp@dhcp22.suse.cz> <CALvZod6b3=+=xXEUeWOQW3t_URJpeeVX46WjBHv5BS+436KoFA@mail.gmail.com>
 <ZQtRKzUOfdaVKRCF@dhcp22.suse.cz>
In-Reply-To: <ZQtRKzUOfdaVKRCF@dhcp22.suse.cz>
From: Shakeel Butt <shakeelb@google.com>
Date: Wed, 20 Sep 2023 14:46:52 -0700
Message-ID: <CALvZod5DSMoEGY0CwGz=P-2=Opbr4SmMfwHhZRROBx7yCaBdDA@mail.gmail.com>
Subject: Re: [REGRESSION] Re: [PATCH 6.1 033/219] memcg: drop kmem.limit_in_bytes
To: Michal Hocko <mhocko@suse.com>
Cc: Jeremi Piotrowski <jpiotrowski@linux.microsoft.com>, Johannes Weiner <hannes@cmpxchg.org>, 
	Roman Gushchin <roman.gushchin@linux.dev>, Muchun Song <muchun.song@linux.dev>, 
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org, 
	patches@lists.linux.dev, Tejun Heo <tj@kernel.org>, 
	Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org, 
	regressions@lists.linux.dev, mathieu.tortuyaux@gmail.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Sep 20, 2023 at 1:08=E2=80=AFPM Michal Hocko <mhocko@suse.com> wrot=
e:
>
[...]
> > have a strong opinion against it. Also just to be clear we are not
> > talking about full revert of 58056f77502f but just the returning of
> > EOPNOTSUPP, right?
>
> If we allow the limit to be set without returning a failure then we
> still have options 2 and 3 on how to deal with that. One of them is to
> enforce the limit.
>

Option 3 is a partial revert of 58056f77502f where we keep the no
limit enforcement and remove the EOPNOTSUPP return on write. Let's go
with option 3. In addition, let's add pr_warn_once on the read of
kmem.limit_in_bytes as well.
