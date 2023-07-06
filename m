Received: from mail-qt1-f172.google.com (mail-qt1-f172.google.com [209.85.160.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A927079FD
	for <patches@lists.linux.dev>; Thu,  6 Jul 2023 10:22:15 +0000 (UTC)
Received: by mail-qt1-f172.google.com with SMTP id d75a77b69052e-401d1d967beso270251cf.0
        for <patches@lists.linux.dev>; Thu, 06 Jul 2023 03:22:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1688638934; x=1691230934;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=OGs0tpi7zPzzVBpu0OnSiGHBmw3uywhwHgZKPt6GtMU=;
        b=j/Fd8bwiN2OJvTSE9y8ItzfxFPucsZhJNNKBzfHRm56zo8RxEGHChOibH5b9Hwg9TL
         Z2fewvooDkdM6QcysOiSuv0wOSnz+km69K8+iYqWFCSjXVMJ915poEa1Zirh52BHxoPn
         kDBo6lwLPEUb5PcWFuab4k3GxvmD8j/IiVAqaqNLmWCqeMN8WGLefUUP7O7GgO7YTgiT
         wSQ50aGKDIfOhDTyBHViBwMafjQsfeBhE9O/mAKHVH5ZH71F90A1K+gQu4id8PWr0Kid
         Iml/pPj2YY+UpzEkshgh4SgyVj5DDXyk8SemiR7WT8GqZ5XSmwSjMuqi5Ae/tEtbGsAO
         IUJA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1688638934; x=1691230934;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=OGs0tpi7zPzzVBpu0OnSiGHBmw3uywhwHgZKPt6GtMU=;
        b=UIyVKLxeXrez2gdghESeKXWftJ9GuObRGCY8Q8yarzgWn3Wcq4qlCnmSdUvzuG5h05
         sc4kEKuo33Ny4mMIodFQtMuCwn+LuL1Ekrshvo+J1q/Ai/o51MPyVy5BMrWEv/uhvrrf
         y545vJJyx4EyO2Dl2Jn1eik+UlMqoZPyAJ6+Sa+ffUUhwdWdClw7SfPQlJptLdxjxrw4
         rfWzBoDp9i4jB1GBo449iI9dq7dN9I84GlCoNqDZ1UiXALPqV2OppquWZScEQl50yThw
         ORbMJRZDtlWDn6XF4Ud76W6IzUJGGFziSyTNNVWTOlUUgP/onfbmWCllQlfel3A2kG+B
         E3ng==
X-Gm-Message-State: ABy/qLZQlprDFUDvqd86lj4ee2F6ah1iW+Iv38o/g4oF468UJqLyskRl
	A/gP4NCYl5nfjHgtbV08bnCPBSoP4D1M4hCKf4lJsw==
X-Google-Smtp-Source: APBJJlEVOdg6eZQzG0QonU1SAA7DT7uin5vQEUKHUXEKQOQdzZDBgBr/2XNPUSjX+2XQSiS3YPpYmgVQD0fLsshplwM=
X-Received: by 2002:a05:622a:54b:b0:3f8:5b2:aef0 with SMTP id
 m11-20020a05622a054b00b003f805b2aef0mr140320qtx.24.1688638934232; Thu, 06 Jul
 2023 03:22:14 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20230620033702.33344-1-tony.luck@intel.com> <20230620033702.33344-3-tony.luck@intel.com>
 <CALPaoChdFLTfA5g=vawTuOLk5T6dEkG79XXqm27shh-VeqNCOw@mail.gmail.com> <SJ1PR11MB6083FF68838400D053C884B0FC2FA@SJ1PR11MB6083.namprd11.prod.outlook.com>
In-Reply-To: <SJ1PR11MB6083FF68838400D053C884B0FC2FA@SJ1PR11MB6083.namprd11.prod.outlook.com>
From: Peter Newman <peternewman@google.com>
Date: Thu, 6 Jul 2023 12:22:03 +0200
Message-ID: <CALPaoCic3zYLxwUET5WCMUCwN8dk-B9JJvuOeUQ2o3hsgNZdQg@mail.gmail.com>
Subject: Re: [RFC PATCH 2/2] resctrl2: Arch x86 modules for most of the legacy
 control/monitor functions
To: "Luck, Tony" <tony.luck@intel.com>
Cc: James Morse <james.morse@arm.com>, "Yu, Fenghua" <fenghua.yu@intel.com>, 
	"Chatre, Reinette" <reinette.chatre@intel.com>, Drew Fustini <dfustini@baylibre.com>, 
	Babu Moger <Babu.Moger@amd.com>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, 
	Borislav Petkov <bp@alien8.de>, H Peter Anvin <hpa@zytor.com>, 
	"shameerali.kolothum.thodi@huawei.com" <shameerali.kolothum.thodi@huawei.com>, 
	D Scott Phillips OS <scott@os.amperecomputing.com>, 
	"carl@os.amperecomputing.com" <carl@os.amperecomputing.com>, "lcherian@marvell.com" <lcherian@marvell.com>, 
	"bobo.shaobowang@huawei.com" <bobo.shaobowang@huawei.com>, 
	"tan.shaopeng@fujitsu.com" <tan.shaopeng@fujitsu.com>, 
	"xingxin.hx@openanolis.org" <xingxin.hx@openanolis.org>, 
	"baolin.wang@linux.alibaba.com" <baolin.wang@linux.alibaba.com>, Jamie Iles <quic_jiles@quicinc.com>, 
	Xin Hao <xhao@linux.alibaba.com>, "Pitre, Nicolas" <npitre@baylibre.com>, 
	Kevin Hilman <khilman@baylibre.com>, "aricciardi@baylibre.com" <aricciardi@baylibre.com>, 
	"x86@kernel.org" <x86@kernel.org>, 
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, 
	"patches@lists.linux.dev" <patches@lists.linux.dev>, Stephane Eranian <eranian@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Tony,

On Wed, Jul 5, 2023 at 6:46=E2=80=AFAM Luck, Tony <tony.luck@intel.com> wro=
te:
> The mbm_poll() code that makes sure that counters don't wrap is
> doing all the expensive wrmsr(QM_EVTSEL);rdmsr(QM_COUNT)
> once per second to give you the data you want.

I was doing that in the soft RMID series I posted earlier because it
simplified things, but then I had some realizations about how much
error +/- 1 second on the sampling point could result in[1]. We
usually measure the bandwidth rate with a 5-second window, so a
reading that's up to one second old would mean a 20% error in the
bandwidth calculation.

> But existing resctrl
> filesystem doesn't let you do a bulk read. I have some ideas on how
> to provide something better. One question: do you really need that
> snapshot to be system-wide? Or can you live with separate L3-scoped
> snapshots that aren't tightly synchronized with each other?

The most demanding use case is responding to a bandwidth saturation
emergency, where the admin wants a snapshot of all jobs' bandwidth
rates to identify which one(s) to kill. Jobs aren't confined to L3
domains, so I expect it's more important to get a tight snapshot for
an RMID-at-a-time. Going domain-at-a-time could create more races
where a high-bandwidth job migrates at the right time and avoids
detection.

One workaround we've been using to cut down on IPIs is providing a
usermode threshold knob for limiting how old a reported event count
can be, but this is more useful for soft RMIDs where reading a single
CPU's counters makes all RMIDs stored counts current, and IPIs
resulting from userspace reads of different groups in the same domain
are all redundant.

We could probably work with second-old event counts if we knew the
exact time they were recorded so we'd know the exact time delta for
the bandwidth count delta, but that seems like it would be awkward in
the current interface.

-Peter

[1] https://lore.kernel.org/lkml/CALPaoCi_N8JHbP4zFD=3DijBh5-=3D4Q0Ec-LrspY=
NGGnj4G6A6U0g@mail.gmail.com/
