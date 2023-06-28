Received: from mail-qt1-f176.google.com (mail-qt1-f176.google.com [209.85.160.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A99C479C8
	for <patches@lists.linux.dev>; Wed, 28 Jun 2023 09:43:25 +0000 (UTC)
Received: by mail-qt1-f176.google.com with SMTP id d75a77b69052e-4007b5bafceso175191cf.1
        for <patches@lists.linux.dev>; Wed, 28 Jun 2023 02:43:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1687945404; x=1690537404;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=xc48rBVZsLOiSEa3oMkPeMBce2yb6sDPpiW6pwcCNoo=;
        b=x3ZsMrbusFi+IePpNS5Mo9bZDJ7S5QC7ngE0gCBFadsOV4f3BaMeHc1SAzWFJ8qyW+
         0IFdOx4YhwYo9b13PAxRuk7idaR3uLiL7+lN3bUfAblMLv72W9YRvYGNK8M67Pw1G1Fw
         Tn6zOOast0mxVVvMHCf8tocHCxd3UYUoe2AiKCWwYZPk9K7VPOkzFJRo3U0TSNQzA00j
         7GYqkmoa160qDgxhMnhGrbsbNiGmtzFnVyUghYw929i7jE8JN7dYIYKMGgEkoFUCIsD1
         U136wG/+/DN/EwiRssjCwnDRMBehpIO+nRj4njxjNS10MIJlneKctvWWM9VpaPl7yaex
         eTGA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1687945404; x=1690537404;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=xc48rBVZsLOiSEa3oMkPeMBce2yb6sDPpiW6pwcCNoo=;
        b=HYeA+OZJXB0adWTdIoLMVkSA8ZQWvvSIyB3pBJG0RZDRNiQTbnK5xSEey97/lbiQ8k
         HarzhMUbEtCMtMZ3yXbKBCC9jXkCWwJFHiQvO8ADc9vFvInzXVMMHeacWHpVAfv2AjaS
         TtjC8gJScSMDXEx1GD1n9OtwU8UWLYyrwKPdlLCP2lut2zUVyFVJRO6+7hL+r0/8g3Cf
         N4LdLo4jPzYjBm3aBa6HhZQMHBDO8Nzh46pySRHM+5u19eNkzTeCNmUVoUJED+mTWAX1
         TZumKeIKFvDmREz6z44DT7D760MQDar1ONZs8ReTkSfEelvPjigbwcHnha4K6k3THZ8s
         9Xxg==
X-Gm-Message-State: AC+VfDxl0s/NxUUdh7y7s9GeEcy00k2CjgtiXyDK7+MrpdWaw3lHMEOB
	4MYbqSa5gOaTQxQHkInGlDmiJVzlikDkDlN+aixr7w==
X-Google-Smtp-Source: ACHHUZ5ThdefZ5zrxt8vbic/eVPtftP8/D0ci1YRpZ+PpEC4vB72hVRtLPei4agSrnA6TWDJ8Y0zaMUyKmkLLpVlQPs=
X-Received: by 2002:ac8:5710:0:b0:3ef:343b:fe7e with SMTP id
 16-20020ac85710000000b003ef343bfe7emr197664qtw.2.1687945403876; Wed, 28 Jun
 2023 02:43:23 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20230620033702.33344-1-tony.luck@intel.com>
In-Reply-To: <20230620033702.33344-1-tony.luck@intel.com>
From: Peter Newman <peternewman@google.com>
Date: Wed, 28 Jun 2023 11:43:13 +0200
Message-ID: <CALPaoChfFSKiWeVC39wFoxUXG+hYU3_HQtCU6AQaB+kAYh3ffg@mail.gmail.com>
Subject: Re: [RFC PATCH 0/2] Resctrl - rewrite (WIP)
To: Tony Luck <tony.luck@intel.com>
Cc: James Morse <james.morse@arm.com>, Fenghua Yu <fenghua.yu@intel.com>, 
	Reinette Chatre <reinette.chatre@intel.com>, Drew Fustini <dfustini@baylibre.com>, 
	Babu Moger <Babu.Moger@amd.com>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, 
	Borislav Petkov <bp@alien8.de>, H Peter Anvin <hpa@zytor.com>, shameerali.kolothum.thodi@huawei.com, 
	D Scott Phillips OS <scott@os.amperecomputing.com>, carl@os.amperecomputing.com, 
	lcherian@marvell.com, bobo.shaobowang@huawei.com, tan.shaopeng@fujitsu.com, 
	xingxin.hx@openanolis.org, baolin.wang@linux.alibaba.com, 
	Jamie Iles <quic_jiles@quicinc.com>, Xin Hao <xhao@linux.alibaba.com>, 
	Nicolas Pitre <npitre@baylibre.com>, Kevin Hilman <khilman@baylibre.com>, aricciardi@baylibre.com, 
	x86@kernel.org, linux-kernel@vger.kernel.org, patches@lists.linux.dev, 
	Stephane Eranian <eranian@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Tony,

On Tue, Jun 20, 2023 at 5:37=E2=80=AFAM Tony Luck <tony.luck@intel.com> wro=
te:
>
> Back in April I posted some RFC patches that added a "driver
> registration" interface to the core resctrl code so that additional
> resource control and monitor features could be added without further
> complicating the core code. Link to that discussion:
>
> https://lore.kernel.org/all/20230420220636.53527-1-tony.luck@intel.com/
>
> Reinette gave the feedback that it would be better to base the module
> registration on the resctrl resource structure. Reinette also pointed
> me to work from James Morse, and some additional discussion happened
> here:
>
> https://lore.kernel.org/all/ZG%2FMZVrWYrCHm%2Ffr@agluck-desk3/
>
> James provided details on where ARM's MPAM has similarities and
> differences from the Intel Resource Director Technology and AMD's
> similar implementation. Drew Fustini was also pulled into that
> conversation to comment on RISC-V CBQRI.
>
> From those discussions I believed we need a do-over on the core
> /sys/fs/resctrl implementation to make it friendlier for architecural
> variations. Here's what I have so far.
>
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> | N.B. This is a general direction check. There are many obvious        |
> | rough edges (e.g. some careful thought needs to happen on locking     |
> | for the files in /sys/fs/resctrl that are "owned" by modules that     |
> | can be unloaded). I'm mostly looking for feedback from AMD, ARM and   |
> | RISCV on whether this is a foundation to build on, whether some small |
> | tweaks could make it better, or if this is still going to be really   |
> | hard for architectures that have radical divergence from the Intel    |
> | model.                                                                |
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D

Thanks for working on this! I played with these changes locally on
some of our machines and they seemed reasonably functional so far and
was happy to see dynamically adding and removing resources working.

I will need to try working with the code to give it a serious
evaluation, though. Would you consider it ready for me to try
re-implementing soft RMIDs on it?

I'm also very interested in James's opinion and what this means for
the ongoing MPAM upstreaming.

Thanks!
-Peter
