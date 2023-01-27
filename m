Received: from mail-qk1-f175.google.com (mail-qk1-f175.google.com [209.85.222.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 960CD2FB6
	for <patches@lists.linux.dev>; Fri, 27 Jan 2023 16:02:27 +0000 (UTC)
Received: by mail-qk1-f175.google.com with SMTP id s19so2548158qkg.7
        for <patches@lists.linux.dev>; Fri, 27 Jan 2023 08:02:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=K6anF/hme5CxdN/v2AxIOwVlqBuJbrYgKdBlK4gdSTc=;
        b=rfn4ZOVzxnWfwhSIE8fkDMAxjolzF6kjdNho2Tt2KbjgrwOdvpYDCJg4XE0UF1ww/a
         DWLoEkC3WvlpmCpGmzy3JCRm3y/ekNQ+VJw9Qg7YbBn+BgaNixIipxSUP2aDLyvAxgxF
         UPK5ciVbW056HreDoSQSF+UlIbC9KGmzM7XwOsEcakZrPTNLVPUt5OPuiasL5WCFprKe
         YIOdWzPY2MmanVRj6NrjOTbou6mKwojzy1wHVjNqyA/zS4Q39L/ppG+JRF63KRUra/KH
         n9N1B4wF13I2sHApXGUIF5wHHVZzE/u49bCFteRMP50r6EZenFdZADc/bJztTjD9/z2R
         ZlAg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=K6anF/hme5CxdN/v2AxIOwVlqBuJbrYgKdBlK4gdSTc=;
        b=0qwL22FvKmps5Vxg4RYDLxD3rDEFQOtwvXMQiNuQYFZek0q0EGgl3agaTLTOX02hZM
         L+4MSso2FDShXFldVa7GcZvCbaH6CoMxIeeHDUsFyu7oGM9wyq2/RXi83Yb7HxlnEQZ5
         kXEUkSCIKY6XRpzZ9GxOFlZn8m7w3AhuGru1JVHn8wieHkMY/cu8sqZQww72AENFGwLl
         0E9NCBeP8bhrnP2N3ML9yJx/lNrXmpolBH0XaxOtmwNdjlXBgrdriKknrIHWoTyUY7bp
         MZ73Ev4kLr+yxj6L10flP3UBoGr3JXomwMtyeht/DunTKudgNtiIvmSyg2GQl7OMe2ak
         GcHw==
X-Gm-Message-State: AFqh2kq1NPpMsk5vfo2k0bd+6SrS+mjoXgrOFbtM1ncYWzDCGPSwwp5A
	v9ctkKvh2s2g/7jFukHwNR+534orZngzHFiXHbHnzg==
X-Google-Smtp-Source: AMrXdXtQsGdbJsrbBeF3q8V17XDVqU2isO6dhJveWB03TYXftJcVZ2ElfilNcMywMtoyOtMxp8PqMFzRNq5S/xKnSpc=
X-Received: by 2002:a05:620a:9cf:b0:706:8a3f:f17a with SMTP id
 y15-20020a05620a09cf00b007068a3ff17amr1913224qky.52.1674835346359; Fri, 27
 Jan 2023 08:02:26 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20230126184157.27626-1-tony.luck@intel.com> <20230126184157.27626-4-tony.luck@intel.com>
 <IA1PR11MB6097400A3056553FCC8E193C9BCC9@IA1PR11MB6097.namprd11.prod.outlook.com>
In-Reply-To: <IA1PR11MB6097400A3056553FCC8E193C9BCC9@IA1PR11MB6097.namprd11.prod.outlook.com>
From: Peter Newman <peternewman@google.com>
Date: Fri, 27 Jan 2023 17:02:15 +0100
Message-ID: <CALPaoCiFotg80LJZ3d+QeO=bNUh85AuP2VgmLaWXX7JaAMYfLQ@mail.gmail.com>
Subject: Re: [PATCH 3/7] x86/resctrl: Add a new node-scoped resource to rdt_resources_all[]
To: "Yu, Fenghua" <fenghua.yu@intel.com>
Cc: "Luck, Tony" <tony.luck@intel.com>, "Chatre, Reinette" <reinette.chatre@intel.com>, 
	Jonathan Corbet <corbet@lwn.net>, "x86@kernel.org" <x86@kernel.org>, Shaopeng Tan <tan.shaopeng@fujitsu.com>, 
	James Morse <james.morse@arm.com>, Jamie Iles <quic_jiles@quicinc.com>, 
	Babu Moger <babu.moger@amd.com>, 
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, 
	"linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>, 
	"patches@lists.linux.dev" <patches@lists.linux.dev>
Content-Type: text/plain; charset="UTF-8"

Hi Tony,

On Fri, Jan 27, 2023 at 6:25 AM Yu, Fenghua <fenghua.yu@intel.com> wrote:
>
> On 1/26/23 10:41, Tony Luck wrote:
> > diff --git a/arch/x86/kernel/cpu/resctrl/core.c b/arch/x86/kernel/cpu/resctrl/core.c
> > index 6914232acf84..19be6fe42ef3 100644
> > --- a/arch/x86/kernel/cpu/resctrl/core.c
> > +++ b/arch/x86/kernel/cpu/resctrl/core.c
> > @@ -100,6 +100,16 @@ struct rdt_hw_resource rdt_resources_all[] = {
> >                       .fflags                 = RFTYPE_RES_MB,
> >               },
> >       },
> > +     [RDT_RESOURCE_NODE] =
> > +     {
> > +             .r_resctrl = {
> > +                     .rid                    = RDT_RESOURCE_NODE,
> > +                     .name                   = "L3",
> "L3" was named as RDT_RESOURCE_L3 already. The duplicate name here may
> cause duplicate file names in info dir. Maybe rename it as "L3_NODE"?

I'm trying to get some feedback from our own users on whether changing
the directory names would bother them. At least from my own testing, I
did learn to appreciate the interface change a bit more: I needed an
SNC and non-SNC case to correctly predict which mon_data subdirectory
the data would appear in.

I was able to confirm that this change allows bandwidth to be counted
on RMID/CPU combos where it didn't work before on an SNC2
configuration.

If I'm understanding this correctly, it might be helpful to highlight
that the extra resource is needed to allow a different number of L3
domains in L3 monitoring vs allocation.

Thanks!
-Peter

Tested-By: Peter Newman <peternewman@google.com>
Reviewed-By: Peter Newman <peternewman@google.com>
