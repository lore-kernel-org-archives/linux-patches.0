Received: from mail-qt1-f172.google.com (mail-qt1-f172.google.com [209.85.160.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC7DBC151
	for <patches@lists.linux.dev>; Fri, 23 Jun 2023 15:19:49 +0000 (UTC)
Received: by mail-qt1-f172.google.com with SMTP id d75a77b69052e-40079b6fc56so213731cf.1
        for <patches@lists.linux.dev>; Fri, 23 Jun 2023 08:19:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1687533588; x=1690125588;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=k9o7YVEzoV5lz+8vLzrqhGQ2D/1rlU+02uMgaoqMDIE=;
        b=XOZa9v/7zkAy73pr3ZosKiB+YlVu1jh81K1h3okUGFyHrTz3LBIiwz9T7hZZYuYYoP
         1eJXPInd8MxtXYaRsw3/KyCOmOCEOd4vH//EOjT3V1LeHr9MjT6UKbp9Wz7taUTe9er9
         HvdSX2AdFgfPC1+iC8ASCipcxIuLrvmfGn7ikZ2wffnpoFwOXYpNpkkZeeeiTnHw8UEl
         FuIKXZes0KemJ79vfVC7K8DTPCIJNd0cc8Ml8Ax7SgBqks232XTp2TBiapLSkhzGSvjK
         gO0L5GkCvIadtQSpbolNbX4PFQAuIaaPbCJmPwv2afZ0sDJ+WKTKlaYYJyahHnJOvmAd
         /xWw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1687533588; x=1690125588;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=k9o7YVEzoV5lz+8vLzrqhGQ2D/1rlU+02uMgaoqMDIE=;
        b=DhXW0e+l6y6DXndN/uWNW6G8Bgc6id/WT/M2ej2iWoXL4y+tmryRAv2FNT5/9FIJRe
         6oqgaWrho04OJKsfeFzuZOFIlveA2zNZ36ZLDkrr/7hbEMZ6MjgdFIwANIpbSVtj8LL+
         04PI/8cnTUK3HGYS4KnhkaNOTzQsGcSc4f8fDz1W9l05FVXIeOsTaqlO9yiQb0/0gcfJ
         YeAMOjgoUxytt4VI7gbjtXmOxc69YrxIlbPlHaWoG+dnA0boa3q9fueJK7WldRvU9Ghw
         REjYH/PWU90f1Wfc5wrBwJKsJpFcV+9Afz8oXKKI/kQVF3VU3YHLXzaFGNyoAGEVHqUv
         Z2+w==
X-Gm-Message-State: AC+VfDyJhNnC/FJbzd/IuuvW81H5Cplg36Gzwn0FEZE8mdOEYm6n4H3G
	mS1BOp2FD0s0+q2DYRv0yU7Ynrv7WQnClyUwEJMDEg==
X-Google-Smtp-Source: ACHHUZ6CDS5pW+9OsHA6eKMXUWXt6u0FtfKRp+ZdZdMi3tmcJaNbZ2dNV8prqFcjyEwsBEWAfs/EzXe+4ASIB+DlLV8=
X-Received: by 2002:ac8:5952:0:b0:3ef:5f97:258f with SMTP id
 18-20020ac85952000000b003ef5f97258fmr143411qtz.16.1687533588350; Fri, 23 Jun
 2023 08:19:48 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20230621174006.42533-1-tony.luck@intel.com> <20230621174006.42533-8-tony.luck@intel.com>
 <CALPaoCgF04M0Jc-c4VmbKkRSFo677SBGoPHzNCSeQ4S6Bqb60w@mail.gmail.com> <SJ1PR11MB60836CD7493B0EAF0F687051FC22A@SJ1PR11MB6083.namprd11.prod.outlook.com>
In-Reply-To: <SJ1PR11MB60836CD7493B0EAF0F687051FC22A@SJ1PR11MB6083.namprd11.prod.outlook.com>
From: Peter Newman <peternewman@google.com>
Date: Fri, 23 Jun 2023 17:19:37 +0200
Message-ID: <CALPaoCiaknUMSU4CunSQrRP=WS8DAbToVo5jibh8TaWNZXGMbQ@mail.gmail.com>
Subject: Re: [PATCH v2 7/7] x86/resctrl: Determine if Sub-NUMA Cluster is
 enabled and initialize.
To: "Luck, Tony" <tony.luck@intel.com>
Cc: "Yu, Fenghua" <fenghua.yu@intel.com>, "Chatre, Reinette" <reinette.chatre@intel.com>, 
	Jonathan Corbet <corbet@lwn.net>, "x86@kernel.org" <x86@kernel.org>, Shaopeng Tan <tan.shaopeng@fujitsu.com>, 
	James Morse <james.morse@arm.com>, Jamie Iles <quic_jiles@quicinc.com>, 
	Babu Moger <babu.moger@amd.com>, 
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, 
	"linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>, 
	"patches@lists.linux.dev" <patches@lists.linux.dev>, "Eranian, Stephane" <eranian@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Tony,

On Thu, Jun 22, 2023 at 6:02=E2=80=AFPM Luck, Tony <tony.luck@intel.com> wr=
ote:
>
> > Unfortunately I'm not getting as good of results with the new series.
> > The main difference seems to be updating the 0xca0 MSR instead of
> > applying the offset to PQR_ASSOC.
>
> I think I may have reversed the actions to update the MSR in one of
> my refactor/rebase. The comment here is correct, but that's not
> what the code is doing :-(
>
> Can you swap the bodies of these two functions and retest?

It's a small improvement, but still not great. Still only node 0
giving believable results, but at least no more empty results from the
second package.

I poked around in /proc/kcore and noticed that my snc_ways is still 1, thou=
gh.

-Peter
